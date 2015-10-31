class Protocol

  def main

    o = op input

    o.input.all.take
    
     show {
      title "Protocol information"
      note "This protocol is used to prepare yeast overnight suspensions from Divided Yeast Plate into Eppendorf 96 Deepwell Plate."
      }
      
    o.output.all.produce
    #Create new collections, in this case Eppendorf 96 Deepwell Plate/Plates
    deepwell_plates=o.output.yeast_deepwell_plate.new_collections
    
    o.threads.spread(deepwell_plates,skip_occupied: true) do |t, slot|
      #Associating a yeast strain with an available slot in the CollectionArray
      t.output.yeast_deepwell_plate.associate slot
    end
    
    #Creating the table to show yeast strain-> Collection->Inducer association to the technicians
    t = Table.new deepwell_plates:"Eppendorf 96 Deepwell Plate",loc:"Location",liquid: "800ml SC liquid (sterile)",div_plate: "Divided Yeast Plate",inducer:"Inducers" 
    input_index=1;
    o.threads.each do |thread|
      divided_yeast_plates=thread.input.yeast_strain.collections
      collections = thread.yeast_deepwell_plate.collections
        (0..collections.length-1).each do |i|
          t.deepwell_plates(collections[i]).loc(yeast_deepwell_plate[i].rows[i]+yeast_deepwell_plate[i].columns[i]).liquid("800ml SC liquid (sterile)").div_plate(divided_yeast_plates[i]).inducer("").append
          input_index=input_index+1
        end
    end
    show do
      table t.render
    end
    
    o.input.all.release
    o.output.all.release

    return o.result

  end

end
