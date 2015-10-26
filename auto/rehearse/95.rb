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

    # All inputs are specified as samples and/or containers. The 'take' method
    # finds items associated with all samples and/or containers and tells the
    # technician where to find them.
    o.input.all.take

    # Loop through each thread and show the results of the take. 
    o.threads.each do |thread|
      show_details thread.input, "Thread #{thread.index} Inputs"
    end

    # Create all the collections needed to store the the samples called 'part'
    # summed over all threads.
    part_cols = o.output.part.new_collections

    # Associate the samples called 'part' with the slots in the collections.
    o.threads.spread(part_cols) do |t, slot|
      t.output.part.associate slot
    end

    # Create all collections needed to store samples in 'part_vec', summed
    # over all threads.
    part_vec_cols = o.output.part_vec.new_collections

    # Associate the samples in 'part_vec' with the slots in the collections.
    # Note that skip_occupied is true here because we are associating an
    # entire vector of parts at each step of the spread. Thus, in the next step
    # we need to skip the slots occupied by the previous, and more ahead to the
    # first unoccupied slot.
    o.threads.spread(part_vec_cols,skip_occupied: true) do |t, slot|
      t.output.part_vec.associate slot
    end

    # Produce all the outputs. This associated the outputs with the job so
    # the can be listed in the log.
    o.output.all.produce

    # Loop through each thread and show the results of the associations and produces
    o.threads.each do |thread|
      show_details thread.output, "Thread #{thread.index} Outputs"
    end

    # Release all i/o items so they are not associated with the job anymore.
    o.input.all.release
    o.output.all.release

    raise "This job did not release all its inventory!" unless o.inventory.length == 0

    # Return the result for the next operation!
    return o.result

  end

end
