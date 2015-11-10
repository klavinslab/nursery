class Protocol

  def main

    o = op input

    o.input.all.take
    o.output.all.produce

    show do
      title "Instructions here"
    end

    show do
      o.threads.each do |thread|
        note "Thread #{thread.index}: "
          + "#{thread.input.fragments} => #{thread.output.plasmid.sample_id}"
      end
    end

    o.input.all.release
    o.output.all.release

    return o.result

  end

end
