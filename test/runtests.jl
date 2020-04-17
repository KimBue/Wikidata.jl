using Wikidata
using Test
using HTTP

@testset "Wikidata.jl" begin
    entity = Wikidata.WikidataEntity("Q42")
    @test  Wikidata.label(entity)=="Douglas Adams"
    @test_throws HTTP.ExceptionRequest.StatusError Wikidata.WikidataEntity("Douglas Adams")
    @test Wikidata.hasproperty(entity, "P31")== true
    @test Wikidata.hasproperty(entity, "P38")== false

    @test_throws ArgumentError Wikidata.getproperty(entity, "P38")
    propList = Wikidata.getproperty(entity, "P31")
    @test size(propList, 1) == 1
    @test Wikidata.label(propList[1]) == "human"

    cambridge = Wikidata.getproperty(entity, "P19")[1]
    @test Wikidata.label(cambridge) == "Cambridge"
    latlon = Wikidata.getproperty(cambridge, "P625")[1]
    @test latlon[1] == 52.208055555556
    @test latlon[2] == 0.1225
end
