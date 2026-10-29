namespace :content do
  desc "Compile content/ into the read-only content database (docs/content-format.md)"
  task :compile do
    # Set before the app boots, so the check for a missing content database
    # (config/initializers/content_database.rb) stands aside for the compile.
    ENV["CONTENT_COMPILING"] = "1"
    Rake::Task[:environment].invoke

    allow_pending = ENV["ALLOW_PENDING"] == "1" && !Rails.env.production?
    result = Content::Compiler.new(
      root: Rails.root.join("content"),
      output: ENV.fetch("OUTPUT") { ContentRecord.database_path },
      territories: Rails.application.config_for(:content).fetch(:territories),
      allow_pending: allow_pending,
      design_registry: Rails.root.join("design/image-registry.json")
    ).compile!
    result.warnings.each { warn "warning: #{_1}" }
    puts "Compiled #{result.documents} documents, #{result.blocks} blocks, #{result.verses} verses, " \
      "and #{result.sources} sources into #{Pathname(result.output).relative_path_from(Rails.root)}"
  rescue Content::Compiler::Failed => error
    abort error.message
  end
end
