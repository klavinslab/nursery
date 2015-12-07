class Protocol
  
  def main
    
    o = op input
    
    o.input.all.take
    
    o.threads.each do |thread|  
      tempAcids = Array.new
      includeAcids = []
      thread.input.powder.samples.each do |sample|
        includeAcids.push(sample.name)
      end

      # includeAcids = ["Histidine", "Uracil"]
      includeAcids.each do |acid|
        if(acid == "Histidine")
          tempAcids.push("His")
        elsif(acid == "Leucine")
          tempAcids.push("Leu")
        elsif(acid == "Triptophan")
          tempAcids.push("Trp")
        elsif(acid == "Uracil")
          tempAcids.push("Ura")
        else
          raise("Non amino acid specified")
        end
      end
    
      missingAcids = ["His", "Leu", "Trp", "Ura"] - tempAcids
      
      if(tempAcids.empty?)
        label = "SC (unsterile)"
      else
        label = "SDO -" + missingAcids.join(" -") + " (unsterile)"
      end
      
      # dropOut = Sample.find_by_name(label)
      # raise ( "Could not find Media" ) unless dropOut
      
      # thread.output.media.associate_sample(dropOut).produce
      
      #ingredients = find(:item,{object_type:{name:"Adenine (Adenine hemisulfate)"}}) + 
      #    find(:item,{object_type:{name:"Dextrose"}}) + find(:item,{object_type:{name:"Yeast Nitrogen Base Without Amino Acids"}}) 
      
  
      # if(o.input.all.include?("agar"))
      #  ingredients += find(:item, {object_type:{name:"Bacto Tryptone"}})
      #end
      
      #typeSDO = label.scan(/-[a-z]+/)
      #acids = typeSDO.collect{|x| x.gsub(/-/, '')}
      #includeAcids = ["leu", "his", "trp", "ura"] - acids
      #includeAcids.each do |i|
      #  if(i == "leu")
      #    ingredients += find(:item,{object_type:{name:"Leucine Solution"}})
      #  elsif(i == "his")
      #    ingredients += find(:item,{object_type:{name:"Histidine Solution"}})
      #  elsif(i == "trp")
      #    ingredients += find(:item,{object_type:{name:"Tryptophan Solution"}})
      #  else
      #    ingredients += find(:item,{object_type:{name:"Uracil Solution"}})
      #  end
      #end
      
      #take ingredients, interactive: true
  
      
      show {
        title "#{label}"
        note "Description: Makes 800 mL of #{label} media with 2% glucose and adenine supplement"
      }
      
      show {
        title "Get Bottle and Stir Bar"
        note "Retrieve one Glass Liter Bottle from the glassware rack and one Medium Magnetic Stir Bar from the dishwashing station, bring to weigh station. Put the stir bar in the bottle."
      }
      
      show {
        title "Weigh Chemicals"
        #note "Weight out 5.36g nitrogen base, 1.12g of DO media, 16g of dextrose, .064g adenine sulfate#{o.input.all.include?("agar") ? ", 16g tryptone" : ""} and add to 1000 mL bottle"
      }
      
      show {
        title "Add Amino Acid"
        note "Add 8 mL of #{includeAcids.join(", ")} solutions each to bottle"
      }
  
      show {
        title "Measure Water"
        note "Take the bottle to the DI water carboy and add water up to the 800 mL mark"
      }
      
      show {
        title "Mix solution"
        note "Shake until most of the powder is dissolved."
        note "It is ok if a small amount of powder is not dissolved because the autoclave will dissolve it"
      }
      
      show {
        title "Cap Bottle"
        note "Place cap on bottle loosely"
      }
      
      show {
        title "Label Bottle"
        note "Label the bottle with '#{label.gsub(/ \(unsterile\)/, '')}', 'Date', 'Your initials'"
      }
      
      # thread.output.all.release

    end
    o.input.all.release
    return o.result
  end
end
