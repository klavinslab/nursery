class Protocol

  def main

  o = op input

  o.input.all.take
  o.output.all.produce

  input_yeast_deepwell_plates=o.input.yeast_deepwell_plate.collections
  output_yeast_deepwell_plates=o.output.yeast_deepwell_plate.new_collections
  
  o.threads.spread(output_yeast_deepwell_plates,skip_occupied: true) do |t, slot|
      t.input_yeast_deepwell_plates.associate slot
    end

 show {
      title "Take new deepwell plates"
      note "Grab #{output_yeast_deepwell_plates.length} Eppendorf 96 Deepwell Plate. Label with #{output_yeast_deepwell_plates.join(", ")}."
      output_yeast_deepwell_plates.each_with_index do |y,idx|
        note "Add #{io_hash[:volume]*(1-io_hash[:dilution_rate])} µL of #{io_hash[:media_type]} into first #{num_of_wells[idx]} wells."
      end
    }
    
    show {
      title "Vortex the deepwell plates."
      note "Gently vortex the deepwell plates #{output_yeast_deepwell_plates.join(", ")} on a table top vortexer at settings 6 for about 20 seconds."
    }

  show {
      title "Seal the deepwell plate(s) with a breathable sealing film"
      note "Put a breathable sealing film on following deepwell plate(s) #{output_yeast_deepwell_plates.join(", ")}."
      note "Place the deepwell plate(s) into the 30 C shaker incubator, make sure it is secure."
    }

    show {
      title "Place the deepwell plates in the washing station"
      note "Place the following deepwell plates #{output_yeast_deepwell_plates.join(", ")} in the washing station "
    }

    o.input.all.release
    o.output.all.release

    return o.result

  end

end
