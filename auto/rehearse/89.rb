class Protocol

  def main

    o = op input

    o.input.all.take
     show {
      title "Protocol information"
      note "This protocol is used to prepare yeast overnight suspensions from Divided Yeast Plate into Eppendorf 96 Deepwell Plate."
      }
    
    deepwell_plates =o.output.yeast_deepwell_plate.new_collections
    o.threads.spread(deepwell_plates,skip_occupied: true) do |t, slot|
      t.output.yeast_deepwell_plate.associate slot
    end
    
    o.output.all.produce
    
    o.input.all.release
    o.output.all.release

    return o.result

  end

end
