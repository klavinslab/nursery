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
    #This is thread aware and takes into account the yeast strains specified in each of threads batched for execution
    deepwell_plates=o.output.yeast_deepwell_plate.new_collections
    
    
    o.threads.spread(deepwell_plates,skip_occupied: true) do |t, slot|
      #Associating a yeast strain with available slots in the newly produced collection
      t.output.yeast_deepwell_plate.associate slot
    end
    
    #Creating the table to show yeast strain-> Collection->Inducer association to the technicians
    t = Table.new output_collection_id:"Eppendorf 96 Deepwell Plate",output_collection_loc:"Location",liquid:"800ml SC liquid (sterile)",ip_div_plate:"Divided Yeast Plate",ip_div_location:"Location",inducer:"Inducer" 
    o.threads.each do |thread|
      input_strain=thread.input.yeast_strain
      output_strain = thread.output.yeast_deepwell_plate
      inducer=""
      #Each Ispec object has available to it the methods row and rows and column and columns 
      #the rows/columns/collections method should be called on the Ispec object representing a Part-Vector since it will have 
      #An array of collections
      #An array of rows
      #An array of columns
      #Each array of equal size
      #Another option would be to iterate through individual samples of the Part-Vector and call the 
      #'collection_id','row' and 'column' method on each sample.
      t.output_collection_id(output_strain.collection_id).output_collection_loc(output_strain.row+','+output_strain.column).liquid("800ml SC liquid (sterile)").ip_div_plate(thread.input.yeast_strain.collection_id).ip_div_location(thread.input.yeast_strain.row + thread.input.yeast_strain.column).inducer("").append
    end
    
    #Rendering the table
    show do
      table t.render
    end
    
     show {
      title "Seal the deepwell plate(s) with a breathable sealing film"
      note "Put a breathable sealing film on following deepwell plate(s) #{deepwell_plates.uniq { |i| i.collection_id }}."
      note "Place the deepwell plate(s) into the 30 C shaker incubator, make sure it is secure."
    }
    
    deepwell_plates.each do |d|
      d.location = "30 C shaker incubator"
      d.save
    end
    
    #Release all input and output
    o.input.all.release
    o.output.all.release

    return o.result

  end

end
