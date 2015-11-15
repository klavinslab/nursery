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
    
    o.input.all.release
    o.output.all.release

    return o.result

  end

end
