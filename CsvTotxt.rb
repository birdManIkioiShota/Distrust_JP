#coding utf-8

csvfile = File.read("./DistrustJP/data/JA_localization.csv")
txtfile = File.open("./DistrustJP/data/JA_localization.txt","w")

commacount = 0
txtfile.write("{\r\n")

csvfile.each_line do |line|
  if commacount == 1
    txtfile.write(",\r\n")
  end

  if /(.*),(.*),(.*),(.*)/ =~ line
    txtfile.print("\s\s\s\s\"",$1,"\":\s")
    
    if $4 == '' then
      txtfile.print("\"", $2, "\"")
    elsif $4 != ''
      unipoint =  $4.each_codepoint.map{|n| n.to_s(16)}
      i = 0
      txtfile.print("\"")
      while unipoint[i] != nil
        #　改行対策
        if unipoint[i] ==  '5c'
          txtfile.print("\\")
        end
        if unipoint[i] == '6e'
          txtfile.print("n")
        end

        # コードが2文字の時の対策
        if /\w\w\w\w/ !~ unipoint[i] && unipoint[i] != '5c' && unipoint[i] != '6e' then
          txtfile.print("\\u")
          txtfile.print("00") 
          txtfile.print(unipoint[i])
        elsif /\w\w\w\w/ =~ unipoint[i]
          txtfile.print("\\u")
          txtfile.print(unipoint[i])
        end
        i = i + 1
      end
      txtfile.print("\"")
    end
  end

  commacount = 1
end

txtfile.write("\r\n}")
