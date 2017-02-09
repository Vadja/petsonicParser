class PetsonicParser
  require 'rubygems'
  require 'nokogiri'
  require 'open-uri'
  require 'csv'

  if ARGV.length !=2
    puts "Invalid input. Url and output file name are needed."
    exit
  end

  site_parse = Nokogiri::HTML(open(ARGV[0]))
  page_numb = site_parse.xpath('.//*[@id="pagination_bottom"]/ul/li/a/span/text()').collect { |x| x }

  File.open("test.txt", "w+") do |f|
    f.puts(page_numb)
  end

  x=0
  lines_number = Array(new)
  file = File.open("test.txt", 'r')
  while !file.eof?
    lines_number[x] = file.readline.to_i
    x+=1
  end
  file.close
  File.delete("test.txt") if File.exist?("test.txt")

  pages_array = Array(new)
  for i in 0..lines_number.max-1
    pages_array[i] = ARGV[0] + "?p=" + (i+1).to_s
  end

  x = 0
  data_array = Array(new)

  for z in 0..lines_number.max-1
    site_parse = Nokogiri::HTML(open(pages_array[z]))
    names_array = site_parse.xpath('//div[@class="product-image-container image ImageWrapper"]/a/@title').collect { |x| x }
    links_array = site_parse.xpath('//div[@class="product-image-container image ImageWrapper"]/a/@href').collect { |x| x }
    images_array = site_parse.xpath('//div[@class="product-image-container image ImageWrapper"]/a/img/@src').collect { |x| x }
    counter = 0

    while counter < links_array.length
      for i in 0..links_array.length-1
        page_parse = Nokogiri::HTML(open(links_array[i]))
        weight_array = page_parse.xpath('//span[@class="attribute_name"]/text()').collect { |x| x }
        price_array = page_parse.xpath('//span[@class="attribute_price"]/text()').collect { |x| x }

        for j in 0..weight_array.length-1
          begin
            data_array[x] = names_array[i].to_s + ' - ' + weight_array[j].to_s + ';' + price_array[j].to_s.strip! + ';' + images_array[i].to_s
            x+=1
            counter+=1
          end
        end
      end
    end
  end

  CSV.open(ARGV[1], 'w') do |csv|
    data_array.each do |row|
      csv << [row]
    end
  end
end