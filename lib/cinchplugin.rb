class CinchPlugin
	def string_truncate(text, length = 65, end_string = ' ...')
    	return if text == nil
    	if text.length > length
      		text.slice!(0, length)+"..."
    	else
      	text
    	end
  	end
end