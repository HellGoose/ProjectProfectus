require File.expand_path('../../modules/medusa.rb', __FILE__)

class Scraper
	include Medusa

	def start
		p 'Scraper started'
		while true
			time = Time.now
			scrape_indiegogo('https://www.indiegogo.com/projects/mountek-airsnap-simply-smart-cell-phone-car-mount#/')
			p 'Time: ' + (Time.now - time).to_s + 's'

			time = Time.now
			scrape_kickstarter('https://www.kickstarter.com/projects/1575895717/mental-illness-plushies-real-monsters-come-to-life?ref=popular')
			p 'Time: ' + (Time.now - time).to_s + 's'

			sleep 10000
		end
	end

	def scrape(url)
		session = new_session
		if url.include? 'kickstarter'
			return scrape_kickstarter(session, url)
		elsif url.include? 'indiegogo'
			return scrape_indiegogo(session, url)
		end				
	end

	def scrape_indiegogo(session, url)
		name = url.split("/projects/")[1].split(/[#\/]/)[0]
		url = url.split(name)[0] + name
		html = get_html(session, url)
		indiegogo = Nokogiri::HTML(html)
		json0 = indiegogo(indiegogo)

		name = url.split("/projects/")[1].split(/[#\/]/)[0]
		url = url.split('/projects/')[0] + '/project/' + name + '/embedded'
		html = get_html(session, url)
		indiegogo = Nokogiri::HTML(html)
		json1 = indiegogo_embedded(indiegogo)

		json0.merge!(json1)
		return json0
	end

	def indiegogo(html_doc)
		content = html_doc.xpath('//div[@ng-bind-html="description_html"]').to_html
		if content == ""
			content = html_doc.css('.i-description').children.to_html
		end
		backers = html_doc.xpath('//span[@id="js-tab-funders-count"]/text()').text
		goal = html_doc.xpath('//span[@class="currency"]/span/text()').text
		author = html_doc.xpath('//div[@class="i-trustTeaser-detailsColumn i-trustTeaser-campaignerColumn"]/div[@class="i-detailsColumn-title"]/text()').text

		json = {
			:content => content.to_s,
			:backers => backers,
			:goal    => goal,
			:author  => author
		}
		return json
	end

	def indiegogo_embedded(html_doc)
		title = html_doc.xpath('//div[@class="i-title"]/text()').text
		pledged = html_doc.xpath('//span[@class="currency currency-medium"]/span/text()').text
		image = html_doc.xpath('//a[@class="i-project"]/img/@src').text
		time = html_doc.xpath('//div[@class="i-time-left"]/text()').text.match(/([0-9]+ )\w+/)[0]

		image.sub! "h_220", "h_355"
		image.sub! "w_220", "w_475"

		json = {
			:title   => title,
			:pledged => pledged,
			:image   => image,
			:time    => time
		}
		return json
	end

	def scrape_kickstarter(session, url)
		html = get_html(session, url)
		kickstarter = Nokogiri::HTML(html)
		json = kickstarter(kickstarter)
		return json
	end

	def kickstarter(html_doc)
		content = html_doc.css('.full-description').children.to_html
		backers = html_doc.xpath('//div[@id="backers_count"]/data/@data-value').text
		goal = html_doc.xpath('//div[@class="col col-12 mb1 stat-item"]/span[@class="bold h5"]/span/text()')[0].text
		author = html_doc.xpath('//a[@data-modal-class="modal_project_by"]/text()')[0].text
		title = html_doc.xpath('//div[@class="NS_projects__header center"]/h2/a/text()')[0].text
		pledged = html_doc.xpath('//div[@class="col col-12 mb1 stat-item"]/div[@class="num h1 bold nowrap"]/data/text()').text
		image = html_doc.xpath('//div[@class="project-image"]/div/img/@src').text
		if image == ""
			image = html_doc.xpath('//div[@class="project-image"]/img/@src').text
		end
		time = 	html_doc.xpath('//div[@class="ksr_page_timer poll stat"]/div[@class="num h1 bold"]/text()').text + ' ' +
						html_doc.xpath('//div[@class="ksr_page_timer poll stat"]/span[@class="text bold h5"]/text()').text.match(/\w+/)[0]

		json = {
			:content => content.to_s,
			:backers => backers,
			:goal    => goal,
			:author  => author,
			:title   => title,
			:pledged => pledged,
			:image   => image,
			:time    => time
		}
		return json
	end
end
