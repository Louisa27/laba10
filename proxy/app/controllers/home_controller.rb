require 'nokogiri'
require 'open-uri'

class HomeController < ApplicationController
  def input
  end

  def output
    response = Nokogiri::XML(URI.open("#{MAIN_SERV}/home/output?txt=#{params[:txt]}"))

    handle = params[:process]
    if handle == 'Сервер'
      render inline: transform_xml(response, "#{Rails.root}/public#{XSLT_FILE}")
    elsif handle == 'Клиент'
      render xml: add_instr(response, XSLT_FILE)
    elsif handle == 'Не обрабатывать'
      render xml: response
    end
  end

  def add_instr(doc, _href_xslt)
    ins = Nokogiri::XML::ProcessingInstruction
          .new(doc, 'xml-stylesheet', "type=\"text/xsl\" href=\"#{XSLT_FILE}\"")
    doc.root.add_previous_sibling ins
    doc
  end

  def transform_xml(doc, href_xslt)
    xslt = Nokogiri::XSLT(File.read(href_xslt))
    xslt.transform(doc)
  end

  XSLT_FILE = '/xslt_for_response.xslt'
  MAIN_SERV = 'http://localhost:3000'
end

