# The destinations docs/urls.md plans whose phase has not arrived. Each is
# already routed at its final address and says plainly what will be there
# and that nothing is ready yet, so links never change when the real page
# comes. An address that cannot exist (an impossible date, a month 13, an
# unknown translation) is a 404, never a guess.
class DestinationsController < ApplicationController
  before_action :check_params

  def show
    @destination = params[:destination]
    @section = SiteSection.find(section_key) if section_key
    @title, @summary, @phase = describe
  end

  private
    def section_key
      case @destination || params[:destination]
      when /\Aatlas_|\Acompare|\Alineage|\Alearn/ then "atlas"
      when /\Akalendar_|\Aeaster/ then "kalendar"
      when /\Apsalter|\Apsalm|\Alectionary|\Areading_plan|\Apassage/ then "bible"
      else "pray"
      end
    end

    def check_params
      date if params[:date]
      not_found unless params[:month].nil? || params[:month].to_i.between?(1, 12)
      not_found if params[:translation] && Translation.find_by_id(params[:translation]).nil?
    end

    # Where each planned destination is built (BUILD.md).
    PHASES = {
      "prayer_book" => "P7", "office" => "P7", "collect" => "P8.3, P9", "prayer" => "P8.2, P9",
      "pastoral_office" => "P8.7, P13.3", "intercessions" => "P14.3", "my_prayers" => "P14.10",
      "confession" => "P14.6", "psalter" => "P10.4", "psalm" => "P10.4", "psalter_day" => "P10.4",
      "lectionary" => "P11", "reading_plan" => "P11.3", "passage" => "P10.3", "kalendar_day" => "P6.5",
      "kalendar_month" => "P6.4", "kalendar_year" => "P6.4", "easter" => "P6.6", "atlas_book" => "P12.3",
      "atlas_prayer" => "P12.5", "compare" => "P12.2", "lineage" => "P12.4", "learn" => "P16",
      "learn_page" => "P16"
    }.freeze

    # The title, the summary, and the phase, from config/locales (destinations.*).
    def describe
      destination = params[:destination]
      phase = PHASES.fetch(destination) { not_found }
      values = interpolations
      [ t("destinations.#{destination}.title", **values), t("destinations.#{destination}.summary", **values), phase ]
    end

    def interpolations
      values = params.permit(:key, :year).to_h.symbolize_keys
      values[:psalm] = params[:psalm].to_i if params[:psalm]
      values[:day] = params[:day].to_i if params[:day]
      values[:month] = l(Date.new(params[:year].to_i, params[:month].to_i), format: :month) if params[:month]
      values[:date] = l(date, format: :day) if params[:date]

      if params[:book]
        values[:book] = book.title
        values[:year] = book.year
      end

      if params[:office]
        values[:office] = Office.name_for(params[:office])
        values[:day] = params[:date] ? t("destinations.on_date", date: values[:date]) : t("destinations.today")
      end

      if params[:bible_book]
        values[:reference] = [ params[:bible_book].titleize, [ params[:chapter], params[:verses] ].compact.join(":") ].join(" ")
        translation = Translation.find_by_id(params[:translation])
        values[:translation] = translation ? t("destinations.in_translation", translation: translation.title) : ""
      end

      if params[:first]
        values[:books] = params.values_at(:first, :second, :third).compact.map { PrayerBook.find(_1).year }.to_sentence
      end

      values
    end

    def book
      @book ||= PrayerBook.find(params[:book])
    end

    def date
      @date ||= Date.iso8601(params[:date])
    rescue Date::Error
      not_found
    end

    def not_found
      raise ActionController::RoutingError, "Not found"
    end
end
