# Shared by the tours on both modes (BUILD.md P2.14): choose an appearance in
# Settings, then visit every section, About, and Settings, checking each and
# saving a screenshot named for the mode, the appearance, and the page.
module TourSteps
  PAGES = { "today" => "/", "pray" => "/pray", "bible" => "/bible", "kalendar" => "/kalendar",
            "atlas" => "/atlas", "about" => "/about", "settings" => "/settings" }.freeze
  APPEARANCES = { "day" => "Day: chart paper and iron-blue ink", "night" => "Night: a night chart, deep blue-black with pale ink" }.freeze

  private
    def tour(mode)
      APPEARANCES.each do |appearance, label|
        visit "/settings"
        choose label
        click_button "Save appearance"
        assert_selector "html[data-appearance=#{appearance}]", visible: :all

        PAGES.each do |name, path|
          visit path
          assert_selector "body[data-site-mode=#{mode}]"
          assert_selector "html[data-appearance=#{appearance}]", visible: :all
          assert_selector "main#main h1", count: 1
          page.save_screenshot(Rails.root.join("tmp/screenshots/tour-#{mode}-#{appearance}-#{name}.png").to_s)
        end
      end
    end
end
