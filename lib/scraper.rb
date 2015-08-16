class Scraper
  attr_reader :db, :html, :doc

  def initialize(db)
    @db = db
  end

  def scrape
    @html = open('pokemon_index.html')
    @doc = Nokogiri::HTML(html)
    create_pokemon
  end

  def pokemon_nokogiri
    doc.css('span.infocard-tall')
  end

  private

  def create_pokemon
    pokemon_nokogiri.each do |obj|
      Pokemon.save_from_nokogiri(obj, db)
    end
  end
end
