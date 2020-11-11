require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students_array = []
    html = Nokogiri::HTML(open(index_url))

    html.css(".student-card").collect do |student|
      hash = {
        name: student.css(".student-name").text,
        location: student.css(".student-location").text,
        profile_url: student.css("a").attr("href").value
      }
      students_array << hash
    end
    students_array
  end


  def self.scrape_profile_page(profile_url)
    student_hash = {}
    html = Nokogiri::HTML(open(profile_url))

    box = html.css(".social-icon-container").children.css("a").collect {|a| a.attribute("href").value}
    box.each do |url|
      if url.include?("twitter")
        profile[:twitter] = url
      elsif url.include?("linkedin")
        profile[:linkedin] = url
      elsif url.include?("github")
        profile[:github] = url
      else
        profile[:blog] = url
      end
    end
  end


end
