# Every page that sets out a text reads the content database (BUILD.md P3.8).
# Without it the site would fail page by page, so say plainly at boot what is
# missing and how to make it. The compile itself, and the test suite (which
# compiles its own fixture database), are exempt.
Rails.application.config.after_initialize do
  next if Rails.env.test? || ENV["CONTENT_COMPILING"] == "1" || ENV["SECRET_KEY_BASE_DUMMY"]

  unless ContentRecord.present?
    raise "The content database #{ContentRecord.database_path} is missing. Run `bin/rails content:compile` " \
      "(bin/setup and bin/deploy do this; docs/content-format.md)."
  end
end
