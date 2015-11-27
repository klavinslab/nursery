class Protocol

  def main

    o = op input

    o.input.all.take

    pLAB1 = Sample.find_by_name("pLAB1")
    raise ( "Could not find pLAB1" ) unless pLAB1

    o.output.y.associate_sample(pLAB1).produce

    show do
      title "Threads"
      o.threads.each do |thread|
        note "Thread #{thread.index}"
        bullet "u1: #{thread.input.u1.sample.name} (#{thread.input.u1.sample}), Item: #{thread.input.u1.item}"
        bullet "u2: #{thread.input.u2.sample.name} (#{thread.input.u2.sample}), Item: #{thread.input.u2.item}"
        bullet "y: #{thread.output.y.sample.name} (#{thread.output.y.sample}), Item: #{thread.output.y.item}"
      end
    end

    o.input.all.release
    o.output.all.release

    return o.result

  end

end
