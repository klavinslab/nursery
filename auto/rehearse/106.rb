class Protocol

  def main

    o = op input

    o.input.all.take
    
    # Create all the collections needed to store the the samples called 'part'
    # summed over all threads.
    yeast_deepwell_plates = o.output.yeast_strain.new_collections

    # Associate the samples called 'part' with the slots in the collections.
    o.threads.spread(yeast_deepwell_plates) do |t, slot|
      t.output.yeast_strain.associate slot
    end
    
    o.output.all.produce

    show do
      title "Instructions here"
    end

    o.input.all.release
    o.output.all.release

    return o.result

  end

end
