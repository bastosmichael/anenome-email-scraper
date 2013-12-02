# #!/usr/bin/env ruby
require 'anemone'

class Crawl
  def initialize site
    @email_count = 0
    Anemone.crawl(site, :discard_page_bodies => true, 
                        :threads => 1, 
                        :obey_robots_txt => false, 
                        :user_agent => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4) AppleWebKit/536.11 (KHTML, like Gecko) Chrome/20.0.1132.43 Safari/536.11", 
                        :large_scale_crawl => true) do |anemone|
      anemone.on_every_page do |page| 
      	scrape page
        page.discard_doc!
        print "."
  		$stdout.flush
      end
    end
  end

  def scrape page
    	page.doc.css('.email_field').each do |email|
          	self.save email
        end

        page.doc.xpath("//a[starts-with(@href, \"mailto:\")]/@href") do |email|
        	self.save email
        end
    end

    def save email
    	@email_count = @email_count+1
        puts "Emails: #{@email_count}"
        File.open("listings.txt", "a") { |f| f.puts email }
    end
end

Crawl.new('http://www.cbs.com')