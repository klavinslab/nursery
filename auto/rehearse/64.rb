class Protocol

  def main

    o = op input

    o.input.all.take
    divided_yeast_plates = o.output.streaked_yeast_plate.new_collections
    
    o.threads.spread(divided_yeast_plates) do |t, slot| 
      t.output.streaked_yeast_plate.associate slot
    end
    
    o.output.streaked_yeast_plate.produce
    
    show do
      title "Instructions here"
    end

    o.input.all.release
    o.output.all.release

    return o.result

  end

end
