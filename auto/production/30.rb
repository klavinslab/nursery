class Protocol

  def main

    o = op input
  
    o.input.all.take
    o.output.all.produce
    
    label = "SDO -trp -leu"
    typeSDO = label.scan(/-[a-z]+/)
    acids = typeSDO.collect!{|x| x.gsub(/-/, '')}
      


    show do
      note "#{typeSDO} and #{acids}"

      
    end

    o.input.all.release
    o.output.all.release

    return o.result

  end

end
