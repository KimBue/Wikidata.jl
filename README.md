# Wikidata

[![Build Status](https://travis-ci.com/KimBue/Wikidata.jl.svg?branch=master)](https://travis-ci.com/KimBue/Wikidata.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/KimBue/Wikidata.jl?svg=true)](https://ci.appveyor.com/project/KimBue/Wikidata-jl)
[![Codecov](https://codecov.io/gh/KimBue/Wikidata.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/KimBue/Wikidata.jl)
[![Coveralls](https://coveralls.io/repos/github/KimBue/Wikidata.jl/badge.svg?branch=master)](https://coveralls.io/github/KimBue/Wikidata.jl?branch=master)

This is a project to implement a [Wikidata](https://www.wikidata.org/wiki/Wikidata:Main_Page) Client in Julia. For the moment, I am using this project to get used to Julia.

## Usage

```julia
#load a Wikidata-Entity (Douglas Adams) 
adams = Wikidata.WikidataEntity("Q42")
println(Wikidata.label(adams))

#check if place of birth exists for this entity:
if(Wikidata.hasproperty(adams, "P19")
  placeofbirth = Wikidata.getproperty(adams, "P19")
  println(Wikidata.label(placeofbirth)
end
```

## Example
How to extract birthplaces and their coordinates for all presidents (head of governement) of the US (or any other country)
```julia
using Wikidata
using DataFrames

function getPresidentsBirthPlaces(x::String)
    df = DataFrame(Name = String[], birthplace= String[], birthplace_lat = BigFloat[], birthplace_lon = BigFloat[])
    country = Wikidata.WikidataEntity(x)
    #head of government is found under Property P6
    presidents_Entities = Wikidata.getproperty(country, "P6")
    for president in presidents_Entities
       try
       #P19 is the place-of-birth property 
       birthplace_Entity = Wikidata.getproperty(president, "P19")
       #P625 is the coordinate location property 
       birthplace_latlon = Wikidata.getproperty(birthplace_Entity[1], "P625")[1]
       push!(df, (Wikidata.label(president), Wikidata.label(birthplace_Entity[1]),birthplace_latlon[1], birthplace_latlon[2]))
        catch
            println("Data not found")
        end
    end
    df
 end
 df = getPresidentsBirthPlaces("Q30") #Q30 is the identifier for the US, Q183 is the identifier of Germany etc.
```
