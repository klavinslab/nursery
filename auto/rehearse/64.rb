class Protocol

  def main

    o = op input

    # Create a new CollectionArray of divided yeast plates for yeast strains
    divided_yeast_plates = o.output.streaked_yeast_plate.new_collections
    
    # For each thread (yeast strain), associate it with an open slot in a divided yeast plate
    o.threads.spread(divided_yeast_plates) do |t, slot| 
      t.output.streaked_yeast_plate.associate slot
    end
    
    # Produce the streaked yeast plate for this op
    o.output.streaked_yeast_plate.produce
    
    show do
      title "Grab yeast plates"
        if o.output.streaked_yeast_plate.length > 0
          check "Grab #{o.output.streaked_yeast_plate.length} of YPAD plates, label with follow ids:"
          note "#{o.output.streaked_yeast_plate.sample_ids}"
          check "Divide up each plate with 4 sections and mark each with circled #{(1..4).to_a.join(',')}"
          image "divided_yeast_plate"
        end
    end

    # Take the required inputs from the lab
    o.input.yeast_glycerol_stock.take

    o.input.all.release
    o.output.all.release

    return o.result

  end

end
