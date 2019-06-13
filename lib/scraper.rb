require 'open-uri'
require 'pry'

class Scraper

  @@all = []

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
      twitter: profile.css("a")[1].attribute("href").value if profile.css("a")[1],
      linkedin: profile.css("a")[2].attribute("href").value if profile.css("a")[2],
      github: profile.css("a")[3].attribute("href").value if profile.css("a")[3],
      blog: profile.css("a")[4].attribute("href").value if profile.css("a")[4],
      profile_quote: profile.css("div.profile-quote").text,
      bio: profile.css("p").text.gsub("\n", ' ').squeeze(' ')
    }
    student_hash.reject { |k, v| v.nil? }
  end

end
