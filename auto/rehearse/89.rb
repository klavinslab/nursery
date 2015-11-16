class Protocol

  def main
    o = op input
    o.input.all.take
    o.output.all.produce 
    
    show {
      title "Protocol information"
      note "This protocol is used to prepare yeast overnight suspensions from Divided Yeast Plate into Eppendorf 96 Deepwell Plate."
    }
    
    #Create new collections, in this case Eppendorf 96 Deepwell Plate/Plates
    #This is thread aware and takes into account the yeast strains specified in each of threads batched for execution
    op_deepwell_plates=o.output.yeast_deepwell_plate.new_collections
    
    o.threads.spread(op_deepwell_plates,skip_occupied: true) do |t, slot|
      #Associating a yeast strain with available slots in the newly produced collection
      t.output.yeast_deepwell_plate.associate slot
    end
    
    t = Table.new output_collection_id:"Eppendorf 96 Deepwell Plate",output_collection_loc:"Location",liquid:"800ml SC liquid (sterile)",ip_div_plate:"Divided Yeast Plate",ip_div_location:"Location",inducer:"Inducer" 
    o.threads.each do |thread|
      input_strain=thread.input.yeast_strain
      show do
        note input_strain
      end
    end
    
    #Rendering the table
    show do
      table t.render
    end
    
    o.input.all.release
    o.output.all.release

    return o.result
  end

end
