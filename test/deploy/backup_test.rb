require "test_helper"
require "open3"

# The nightly backup (BUILD.md P5.5, docs/deploy.md §7): the database copy
# and its verification, and the units that run it.
class BackupTest < ActiveSupport::TestCase
  SCRIPT = Rails.root.join("deploy/backup_databases.rb")
  DEPLOY = Rails.root.join("deploy")

  setup do
    @dir = Pathname(Dir.mktmpdir("backup"))
    @dir.join("storage").mkpath
    @dir.join("copy").mkpath
    database = SQLite3::Database.new(@dir.join("storage/production.sqlite3").to_s)
    database.execute("PRAGMA journal_mode = WAL")
    database.execute("CREATE TABLE notes (body TEXT)")
    3.times { database.execute("INSERT INTO notes VALUES (?)", [ "row #{_1}" ]) }
    @live = database # left open, as the running site leaves it
  end

  teardown do
    @live.close
    FileUtils.rm_rf(@dir)
  end

  test "a live WAL database is copied, checked, and described in the manifest" do
    manifest, status = run_script("copy", @dir.join("storage"), @dir.join("copy"))
    assert status.success?, manifest
    assert_match(/\Aproduction\.sqlite3 integrity=ok sha256=\h{64} notes=3\n\z/, manifest)
    assert_not @dir.join("copy/production.sqlite3-wal").exist?
  end

  test "a restore is verified against the manifest, and a changed copy is caught" do
    manifest, = run_script("copy", @dir.join("storage"), @dir.join("copy"))
    @dir.join("manifest.txt").write(manifest)
    output, status = run_script("verify", @dir.join("copy"), @dir.join("manifest.txt"))
    assert status.success?, output

    SQLite3::Database.new(@dir.join("copy/production.sqlite3").to_s).execute("DELETE FROM notes")
    output, status = run_script("verify", @dir.join("copy"), @dir.join("manifest.txt"))
    assert_not status.success?
    assert_match(/differs from the manifest/, output)
  end

  test "an empty storage directory is an error, not an empty backup" do
    _, status = run_script("copy", @dir.join("copy"), @dir.join("storage"))
    assert_not status.success?
  end

  test "the nightly timer runs the live release's backup inside the deploy lock" do
    service = DEPLOY.join("prayerbookatlas-backup.service").read
    assert_match %r{^ExecStart=/usr/local/sbin/with-deploy-lock bash /srv/www/prayerbookatlas.com/current/deploy/backup.sh$}, service
    assert_match %r{^ReadWritePaths=.*/var/backups}, service
    assert_match(/^OnCalendar=\*-\*-\* 06:20:00 UTC$/, DEPLOY.join("prayerbookatlas-backup.timer").read)
    cutover = DEPLOY.join("cutover.sh").read
    assert_includes cutover, %(backup_units="$name-backup.service $name-backup.timer")
    assert_includes cutover, %(systemctl enable --quiet --now "$name-backup.timer")
  end

  test "the backup leaves out the content database, which every deploy rebuilds" do
    assert_includes DEPLOY.join("backup.sh").read, %("$base/shared/storage")
    assert_equal "db/content.sqlite3", ActiveRecord::Base.configurations.configs_for(env_name: "production", name: "content", include_hidden: true).database
  end

  private
    def run_script(*args)
      Open3.capture2e(RbConfig.ruby, SCRIPT.to_s, *args.map(&:to_s))
    end
end
