module Wikidata


    using HTTP, JSON

    struct WikidataEntity
        code::String
        dataDict::Dict
    end


    """
    expects an Wikidata Identifier for a specific item as a parameter, such as WikidataEntity('Q42') for Douglas Adams
    returns a WikidataEntity consisting of code::String and dataDict::Dict.
    # Example
    adams = Wikidata.WikidataEntity("Q42")
    println(Wikidata.label(adams))
    """
    function WikidataEntity(name::String)
        resp = HTTP.get("https://www.wikidata.org/wiki/Special:EntityData/$(name).json")
        #resp = HTTP.request("get", "www.google.com")
        str = String(resp.body)
        jobj = JSON.Parser.parse(str)["entities"][name]
        #descriptions = jobj["descriptions"]
        WikidataEntity(name, jobj)
    end

    """
    returns the english label (the title, the name) of the WikidataEntity
    # Example
    adams = Wikidata.WikidataEntity("Q42")
    println(Wikidata.label(adams))
    """
    function label(x::WikidataEntity)
        x.dataDict["labels"]["en"]["value"]
end
    """
    returns true, if the property for the given property identifier exists for this Entity
    # Example
    #load a Wikidata-Entity (Douglas Adams)
    adams = Wikidata.WikidataEntity("Q42")
    println(Wikidata.label(adams))

    #check if place of birth exists for this entity:
    if(Wikidata.hasproperty(adams, "P19"))
        placeofbirth = Wikidata.getproperty(adams, "P19")
        println(Wikidata.label(placeofbirth[1]))
    end
    """
    function hasproperty(x::WikidataEntity, property::String)
        return haskey(x.dataDict["claims"], property)
end
    """
        returns a list of properties of different type.
        Supported properties: item

        # Example
        #load a Wikidata-Entity (Douglas Adams)
        adams = Wikidata.WikidataEntity("Q42")
        println(Wikidata.label(adams))

        #check if place of birth exists for this entity:
        if(Wikidata.hasproperty(adams, "P19"))
            placeofbirth = Wikidata.getproperty(adams, "P19")
            println(Wikidata.label(placeofbirth[1]))
        end
    """
    function getproperty(x::WikidataEntity, property::String)
        if (!hasproperty(x, property))
            throw(ArgumentError("Entity does not have property $(property)"))
        end
        propertylist = x.dataDict["claims"][property]
        returnlist = Any[]
        for p in propertylist
            datatype = p["mainsnak"]["datavalue"]["type"]
            #item type
            if(datatype == "wikibase-entityid")
                itemcode = p["mainsnak"]["datavalue"]["value"]["id"]
                push!(returnlist, WikidataEntity(itemcode))
            #coordinates type
            elseif(datatype == "globecoordinate")
                latlontuple = (p["mainsnak"]["datavalue"]["value"]["latitude"], p["mainsnak"]["datavalue"]["value"]["longitude"])
                push!(returnlist, latlontuple)

            end
        end
        return returnlist

end

end # module
