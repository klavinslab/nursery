class Protocol

  def main
    o = op input

    o.input.all.take

    show {
      title "Protocol information"
      note "This protocol is used to prepare yeast overnight suspensions from Divided Yeast Plate into Eppendorf 96 Deepwell Plate."
    }

    #Create new collections, in this case Eppendorf 96 Deepwell Plate/Plates
    #This is thread aware and takes into account the yeast strains specified in each of threads batched for execution
    op_deepwell_plates = o.output.yeast_strain.new_collections

    o.threads.spread(op_deepwell_plates, skip_occupied: true) do |t, slot|
      #Associating a yeast strain with available slots in the newly produced collection
      t.output.yeast_strain.associate slot
    end

    # Produce all the outputs. This associated the outputs with the job so
    # the can be listed in the log.
    o.output.all.produce
    #
    #  #Creating the table to show yeast strain-> Collection->Inducer association to the technicians
    t = Table.new output_collection_id:"Eppendorf 96 Deepwell Plate",output_collection_loc:"Location",liquid:"800ml SC liquid (sterile)",ip_div_plate:"Divided Yeast Plate",ip_div_location:"Location",inducer:"Inducer"
    o.threads.each do |thread|
      input_strain = thread.input.yeast_strain
      output_strain = thread.output.yeast_strain
      inducer=""
      t.output_collection_id(output_strain.collection_id).output_collection_loc(output_strain.row.to_s+','+output_strain.column.to_s).liquid("800ml SC liquid (sterile)").ip_div_plate(input_strain.collection_id).ip_div_location(input_strain.row.to_s).inducer("").append
    end
    #
    #Rendering the table
     show do
       table t.choose([:output_collection_id,:output_collection_loc,:liquid,:ip_div_plate,:ip_div_location,:inducer]).render
     end

    o.input.all.release
    o.output.all.release

    return o.result
  end

end
