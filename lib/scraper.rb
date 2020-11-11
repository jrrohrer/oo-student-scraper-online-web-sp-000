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
    html.css(".social-icon-container").each do |student|
      url = student.attribute("href")
      student_hash[:twitter_url] = url if url.include?("twitter")
      student_hash[:linkedin_url] = url if url.include?("linkedin")
      student_hash[:github_url] = url if url.include?("github")
      student_hash[:blog_url] = url if student.css("img").attribute("src").text.include?("rss")
    end
    student_hash[:profile_quote] = html.css(".profile_quote").text
    student_hash[:bio] = html.css(".bio-content p").text
    student_hash
  end


end
