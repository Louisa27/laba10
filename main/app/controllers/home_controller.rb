class HomeController < ApplicationController
  def input
  end

  def output
    @arr = []
    params[:txt].to_i.times { |i| @arr.append(i) if (i * i).to_s.reverse.to_i == (i * i) }
    render xml: convert_to_xml(@arr)
  end

  def convert_to_xml(arr)
   
      Nokogiri::XML::Builder.new do
        result do
          arr&.each_with_index do |elem, i|
            element do
              index i+1
              value elem 
              square elem*elem
            end
          end
        end
    
    end

  end

end
