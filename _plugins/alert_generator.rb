module Reading
  class Generator < Jekyll::Generator
    def generate(site)	
		  @site = site
	    @converter = site.find_converter_instance(Jekyll::Converters::Markdown)	
        site.pages.each do |p|			
          createAlert("tip", p.content)
          createAlert("note", p.content)
          createAlert("important", p.content)
          createAlert("caution", p.content)
          createAlert("warning", p.content)
        end
    end
	
	  def createAlert(alertType, content)
      sub_string = content.scan(/(>#{alertType})((.|\n[\w\*\[!^<>|#])*)/)		  
	  	if sub_string.count == 0
	  		##puts "no " + alertType + "s"
	  	else
        sub_string.each do |s|
          # puts("s - #{s} ; s1 - #{s[1]}; replaced - #{s[1].gsub(/(^>)/, "")}")
          block ="<blockquote class='#{alertType}'>" +  @converter.convert(s[1].gsub(/(^>)/x, "")) + "</blockquote>"
	  			slugsInBlock = block.scan(/.*?(%7[Bb]%slug%20([0-9a-zA-Z_\-\(\)\*\.\/\,\%\'\?\:]+)%{2}7[Dd])/)				
	  			if	slugsInBlock.count > 0				
	  				slugsInBlock.each do |slug|								
	  					targetPage = @site.pages.find {|p| p.data['slug'] == slug[1]}			
              if targetPage
                link = @site.baseurl + targetPage.url.sub('.html', '')
	  						block.sub!(slug[0], link)					
	  					end
	  				end
	  			end				
	  			content.sub!(s[0]+s[1], block)
	  		end
	  	end
	  end
    end
end

