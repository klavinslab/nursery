class Protocol

  module Reporter
    def report part
      warning "error: #{part.errors.join(', ')}" if part.errors
      yield part unless part.errors
    end
  end

  def show_details io, str

    show do

      extend Reporter

      title str

      report(io.samp) do |samp|
        note "samp: #{samp.sample} => Item #{samp.item}"
      end

      report(io.samp_vec) do |samp_vec|
        note "samp_vec: #{samp_vec.samples.join(', ')} => Items #{samp_vec.items.join(', ')}"
      end

      report(io.part) do |part|
        note "part #{part.sample} => Collection #{part.collection}, row #{part.row}, colum #{part.column}"
      end

      report(io.part_vec) do |part_vec|
        collections = part_vec.collections
        (0..collections.length-1).each do |i|
          note "part_vec(#{i}) => Collection #{collections[i]}, row #{part_vec.rows[i]}, column #{part_vec.columns[i]}"
        end
      end

      report (io.simple) do |simple|
        note "simple #{simple.container} => Item #{simple.item}"
      end

    end

  end

  def main
    o = op input

    o.input.all.take

    # Loop through each thread and show the results of the take.
    o.threads.each do |thread|
      show_details thread.input, "Thread #{thread.index} Inputs"
    end

    show {
      title "Protocol information"
      note "This protocol is used to prepare yeast overnight suspensions from Divided Yeast Plate into Eppendorf 96 Deepwell Plate."
    }

    #Create new collections, in this case Eppendorf 96 Deepwell Plate/Plates
    #This is thread aware and takes into account the yeast strains specified in each of threads batched for execution
    op_deepwell_plates = o.output.yeast_deepwell_plate.new_collections

    o.threads.spread(op_deepwell_plates, skip_occupied: true) do |t, slot|
      #Associating a yeast strain with available slots in the newly produced collection
      t.output.yeast_deepwell_plate.associate slot
    end

    # Produce all the outputs. This associated the outputs with the job so
    # the can be listed in the log.
    o.output.all.produce

    # Loop through each thread and show the results of the associations and produces
    o.threads.each do |thread|
      show_details thread.output, "Thread #{thread.index} Outputs"
    end


    show {
      note "#{o.output.yeast_deepwell_plate.item_ids}"
      note op_deepwell_plates.each { |deepwell| "#{deepwell.id}"}
    }


     #Creating the table to show yeast strain-> Collection->Inducer association to the technicians
    t = Table.new output_collection_id:"Eppendorf 96 Deepwell Plate",output_collection_loc:"Location",liquid:"800ml SC liquid (sterile)",ip_div_plate:"Divided Yeast Plate",ip_div_location:"Location",inducer:"Inducer"
    o.threads.each do |thread|
      input_strain=thread.input.yeast_strain
      output_strain = thread.output.yeast_deepwell_plate
      inducer=""
      t.output_collection_id(output_strain.collection_id).output_collection_loc(output_strain.row).liquid("800ml SC liquid (sterile)").ip_div_plate(thread.input.yeast_strain.collection_id).ip_div_location(thread.input.yeast_strain.row).inducer("").append
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
