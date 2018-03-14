class CrawlerController < ApplicationController
  def index
    agent = Mechanize.new
    page = agent.get "http://sakai.it.tdt.edu.vn/portal"
    login_form = page.form
    login_form.eid = "51403148"
    login_form.pw = "tin28111994"
    home_page = agent.submit login_form
    current_subjects = home_page.search "ul.topnav li.nav-menu a"
    current_subjects.shift
    info_arr = []
    current_subjects.each do |subject|
      subject_page = agent.get subject.attr("href")
      subject_name = subject.search('span').text
      link = subject_page.search "[title='Để gửi bài, nộp và chấm điểm bài tập (s) online ']"
      my_frame = agent.get link.attr('href').value
      final_frame = agent.get my_frame.iframe.src
      result = final_frame.search("td[headers='dueDate'] span")
      arr = result.map { |x| x.text }
      info_arr << { subject_name: subject_name, due_date_arr: arr }
    end
  end
end
