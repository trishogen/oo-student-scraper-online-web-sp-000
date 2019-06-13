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
      profile_quote: profile.css("div.profile-quote").text,
      bio: profile.css("p").text.gsub("\n", ' ').squeeze(' ')
    }
    profile.css("a").each do |link|
      student_hash[:twitter] = link.attribute("href").value if attribute("href").value.include? ("twitter")
      student_hash[:linkedin] = link.attribute("href").value if attribute("href").value.include? ("linkedin")
      student_hash[:github] = link.attribute("href").value if attribute("href").value.include? ("github")
      student_hash[:blog] = link.attribute("href").value if attribute("href").value.include? ("blog")
    end

    # student_hash[:twitter] = profile.css("a")[1].attribute("href").value if profile.css("a")[1]
    # student_hash[:linkedin] = profile.css("a")[2].attribute("href").value if profile.css("a")[2]
    # student_hash[:github] = profile.css("a")[3].attribute("href").value if profile.css("a")[3]
    # student_hash[:blog] = profile.css("a")[4].attribute("href").value if profile.css("a")[4]
    student_hash
  end

end
