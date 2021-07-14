module ApplicationHelper
  def showconimg
    if @user.contributions >= 3200
      image_tag '3200.svg', class: 'w-50'
    elsif @user.contributions >= 1600
      image_tag '1600.svg', class: 'w-50'
    elsif @user.contributions >= 800
      image_tag '800.svg', class: 'w-50'
    elsif @user.contributions >= 400
      image_tag '400.svg', class: 'w-50'
    elsif @user.contributions >= 200
      image_tag '200.svg', class: 'w-50'
    elsif @user.contributions >= 100
      image_tag '100.svg', class: 'w-50'
    elsif @user.contributions >= 10
      image_tag '10.svg', class: 'w-50'
    elsif @user.contributions >= 0
      image_tag '0.svg', class: 'w-50'
    end
  end
  def char_bytesize_for(char)
    char.bytesize == 1 ? 1 : 2
  end
  def sum_bytesize_for(text)
    text.each_char.map { |c| char_bytesize_for(c) }.inject(:+)
  end
end
