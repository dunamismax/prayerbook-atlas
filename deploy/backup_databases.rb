# Copy the app's SQLite databases with SQLite's online backup, which gives a
# consistent copy while the site runs (BUILD.md P5.5). Run by deploy/backup.sh
# as the service user with the release's bundle, and by bin/backup-restore-check
# to verify a restored copy:
#
#   ruby deploy/backup_databases.rb copy SOURCE_DIR DEST_DIR   prints a manifest
#   ruby deploy/backup_databases.rb verify DIR MANIFEST        checks a restore
#
# The manifest has one line per database: its file, integrity, SHA-256, and
# the row count of every table.
require "sqlite3"
require "digest"

def describe(path)
  database = SQLite3::Database.new(path, readonly: true)
  integrity = database.get_first_value("PRAGMA integrity_check")
  tables = database.execute("SELECT name FROM sqlite_schema WHERE type = 'table' AND name NOT LIKE 'sqlite_%' ORDER BY name").flatten
  counts = tables.map { |table| "#{table}=#{database.get_first_value(%(SELECT count(*) FROM "#{table.gsub('"', '""')}"))}" }
  database.close
  [ File.basename(path), "integrity=#{integrity}", "sha256=#{Digest::SHA256.file(path).hexdigest}", *counts ].join(" ")
end

case ARGV.first
when "copy"
  _, source_dir, destination_dir = ARGV
  sources = Dir[File.join(source_dir, "*.sqlite3")].sort
  abort "backup: no databases in #{source_dir}" if sources.empty?
  sources.each do |path|
    destination = File.join(destination_dir, File.basename(path))
    source = SQLite3::Database.new(path)
    target = SQLite3::Database.new(destination)
    backup = SQLite3::Backup.new(target, "main", source, "main")
    status = backup.step(-1)
    expected_pages = backup.pagecount
    backup.finish
    # A step that does not finish leaves an empty file that would still pass
    # integrity_check, so refuse anything but a complete copy.
    unless status == SQLite3::Constants::ErrorCode::DONE
      abort "backup: #{File.basename(path)}: SQLite's online backup stopped with code #{status}"
    end
    target.execute("PRAGMA journal_mode = DELETE")
    pages = target.get_first_value("PRAGMA page_count")
    abort "backup: #{File.basename(path)}: copied #{pages} of #{expected_pages} pages" if pages.zero? || pages != expected_pages
    target.close
    source.close
    line = describe(destination)
    abort "backup: #{line}" unless line.include?(" integrity=ok ")
    puts line
  end
when "verify"
  _, dir, manifest = ARGV
  expected = File.readlines(manifest, chomp: true).reject(&:empty?)
  abort "verify: the manifest lists no databases" if expected.empty?
  expected.each do |line|
    actual = describe(File.join(dir, line.split.first))
    abort "verify: #{line.split.first} differs from the manifest\n  expected #{line}\n  found    #{actual}" unless actual == line
    puts "ok #{actual}"
  end
else
  abort "usage: backup_databases.rb copy SOURCE DEST | verify DIR MANIFEST"
end
