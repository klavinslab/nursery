
class Protocol
  
  def main

    o = op input

    o.input.all.take
    
    # Todo: Figure out how many gels to pour based on the number of threads (o.threads.length)

    show {
      title "#{o.name} Inputs"
      note "Detailed instructions for pouring a gel go here"
    }

    o.output.all.produce
    
    o.input.all.release
    o.output.all.release

    return o.result     

  end

end

