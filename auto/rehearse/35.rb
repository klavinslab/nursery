class Protocol

  def main

    o = op input

    o.input.all.query(true).take
    o.output.all.produce

    o.threads.each do |thread|
      show do
        title "Do something to item number #{thread.input.strain.item_id}"
      end
    end

    o.input.all.release
    o.output.all.release

    return o.result

  end

end
