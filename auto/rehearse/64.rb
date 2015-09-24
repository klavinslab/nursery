class Protocol

  def main

    o = op input

    o.input.all.take
    divided_yeast_plates = o.output.streaked_yeast_plate.new_collections

    show do
      title "Instructions here"
    end

    o.input.all.release
    o.output.all.release

    return o.result

  end

end
