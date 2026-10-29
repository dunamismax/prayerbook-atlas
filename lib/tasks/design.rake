namespace :design do
  desc "Regenerate app/assets/stylesheets/tokens.css from design/tokens.json"
  task tokens: :environment do
    DesignTokens.write
    puts "Wrote #{DesignTokens::OUTPUT.relative_path_from(Rails.root)}"
  end
end
