module Wikidata


    using HTTP, JSON

    struct WikidataEntity
        code::String
        dataDict::Dict
    end



    function WikidataEntity(name::String)
        resp = HTTP.get("https://www.wikidata.org/wiki/Special:EntityData/$(name).json")
        #resp = HTTP.request("get", "www.google.com")
        str = String(resp.body)
        jobj = JSON.Parser.parse(str)["entities"][name]
        #descriptions = jobj["descriptions"]
        WikidataEntity(name, jobj)
    end

    function label(x::WikidataEntity)
    x.dataDict["labels"]["en"]["value"]
end
    function hasproperty(x::WikidataEntity, property::String)
        return haskey(x.dataDict["claims"], property)
end
    """
        returns a list of properties of different type.
        Supported properties: item
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
