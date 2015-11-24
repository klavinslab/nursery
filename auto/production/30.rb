class Protocol

  def main

    o = op input
  
    o.input.all.take
    o.output.all.produce

    show do
      note "#{o.output.media.sample_names}"
      sampleString = "SDO -trp -leu"
      contentChecker = Array.new
      inputAcids = sampleString.split('')
      (0..array.length-1).each do |i|
        contentChecker.push(acids)
      
    end

    o.input.all.release
    o.output.all.release

    return o.result

  end

end
