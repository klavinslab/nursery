class Protocol

  def main

  o = op input

  o.input.all.take
  o.output.all.produce
  
  #Currently these don't come as input
  #volume=
  #dilution_rate=

  ip_deepwell_plates=o.input.yeast_deepwell_plate.collections
  op_deepwell_plates=o.output.yeast_deepwell_plate.new_collections

 show {
      title "Take new deepwell plates"
      note "Grab #{op_deepwell_plates.length} Eppendorf 96 Deepwell Plate. Label with #{op_deepwell_plates.join(", ")}."
      op_deepwell_plates.each_with_index do |y,idx|
        note "Add #{volume*(1-dilution_rate)} µL of 800 mL SC liquid(sterile) into first #{num_of_wells} wells."
      end
    }
    

    #o.input.all.release
    #o.output.all.release

    return o.result

  end

end
