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
      when "search" then nil
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

    def describe
      case params[:destination]
      when "prayer_book" then [ book.title, "The offices, prayers, and services this book sets out, in its own order.", "P7" ]
      when "office" then office_description
      when "collect" then [ "A collect: #{params[:key]}", "This collect as #{book.title} prints it, with its source and page.", "P8.3, P9" ]
      when "prayer" then [ "A prayer: #{params[:key]}", "This prayer or thanksgiving as #{book.title} prints it, with its source and page.", "P8.2, P9" ]
      when "pastoral_office" then [ "A pastoral office: #{params[:key]}", "This office from #{book.title}, for study and preparation, with a line to speak with your parish priest.", "P8.7, P13.3" ]
      when "intercessions" then [ "Intercessions", "Your list of people and intentions, kept in this browser only and shown in the prayers where a book provides for names.", "P14.3" ]
      when "my_prayers" then [ "My prayers", "Prayers you write yourself, kept in this browser only.", "P14.10" ]
      when "confession" then [ "Preparation for confession", "Help in preparing for confession. Any notes stay in this browser and are never sent anywhere.", "P14.6" ]
      when "psalter" then [ "The Psalter of #{book.title}", "This book's own Psalter, in its own wording, numbering, and pointing.", "P10.4" ]
      when "psalm" then [ "Psalm #{params[:psalm].to_i}", "This psalm in the Psalter of #{book.title}, by that book's numbering.", "P10.4" ]
      when "psalter_day" then [ "Day #{params[:day].to_i} of the Psalter", "The psalms appointed for this day in the cycle of #{book.title}.", "P10.4" ]
      when "lectionary" then [ "A lectionary: #{params[:key]}", "A lectionary, its source, its cycle, and its readings day by day.", "P11" ]
      when "reading_plan" then [ "A reading plan: #{params[:key]}", "A reading plan, with today's portion and no streaks or scores.", "P11.3" ]
      when "passage" then passage_description
      when "kalendar_day" then [ date.strftime("%-d %B %Y").to_s, "This day in the Christian year, in every launch book, with the source of each rule.", "P6.5" ]
      when "kalendar_month" then [ Date.new(params[:year].to_i, params[:month].to_i).strftime("%B %Y"), "This month's holy days, commemorations, and fasts.", "P6.4" ]
      when "kalendar_year" then [ params[:year], "This year's holy days and seasons.", "P6.4" ]
      when "easter" then [ "Easter #{params[:year]}", "Easter and the moveable feasts for this year, with the Golden Number, the Sunday Letter, and the tables.", "P6.6" ]
      when "atlas_book" then [ book.title, "Who authorized this book, where it is used today, its contents, and the printing this site follows.", "P12.3" ]
      when "atlas_prayer" then [ "Where is this prayer? #{params[:key]}", "This prayer in every book that has it, or a plain note where a book does not.", "P12.5" ]
      when "compare" then compare_description
      when "lineage" then [ "The lineage of the prayer books", "How the Books of Common Prayer descend from 1549 and 1552, every line sourced.", "P12.4" ]
      when "learn" then [ "Learn", "Plain explanations of the offices, the year, the books, and the Anglican way.", "P16" ]
      when "learn_page" then [ "Learn: #{params[:key]}", "A page of Learn, researched and drafted with AI assistance and reviewed before release.", "P16" ]
      when "search" then [ "Search", "Search across the books, Scripture, and the Atlas.", "P3.9" ]
      else not_found
      end
    end

    def office_description
      name = Office::NAMES.fetch(params[:office])
      day = params[:date] ? " on #{date.strftime("%-d %B %Y")}" : " today"
      [ "#{name} · #{book.year}", "#{name} from #{book.title}#{day}, with the day's psalms, lessons, and collects in place; or, if this book has no such office, a plain note saying so.", "P7" ]
    end

    def passage_description
      reference = [ params[:bible_book].titleize, [ params[:chapter], params[:verses] ].compact.join(":") ].join(" ")
      translation = Translation.find_by_id(params[:translation])
      [ reference, "This passage#{" in the #{translation.title}" if translation}, with its translation named.", "P10.3" ]
    end

    def compare_description
      books = params.values_at(:first, :second, :third).compact.map { |id| PrayerBook.find(id).year }
      [ "Compare: #{params[:key]}", "This prayer side by side in #{books.to_sentence}, with the differences marked in words as well as by underline.", "P12.2" ]
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
