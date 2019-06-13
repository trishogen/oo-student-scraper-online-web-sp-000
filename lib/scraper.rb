require 'open-uri'
require 'pry'

class Scraper

  @@all = []

  LINK_TYPES = {twitter: "twitter", linkedin: "linkedin", github: "github",
                blog: "rss"}

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    doc.css(".student-card").each do |student|
    student_hash = {
      name: student.css("h4.student-name").text,
      location: student.css("p.student-location").text,
      profile_url: student.css("a").attribute("href").value
    }
    @@all << student_hash
    end
    @@all
  end

  def self.scrape_profile_page(profile_url)
    profile = Nokogiri::HTML(open(profile_url))
    student_hash = {
      profile_quote: profile.css("div.profile-quote").text,
      bio: profile.css("p").text.gsub("\n", ' ').squeeze(' ')
    }

    profile.css("a").each do |link|
      LINK_TYPES.each do |k, v|
        if link.css("img").attribute("src").value.include? (v)
          student_hash[k] = link.attribute("href").value
        end
      end
    end
    student_hash
  end

end
