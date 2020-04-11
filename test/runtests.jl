using .Wikidata
using Test
using HTTP

@testset "Wikidata.jl" begin
    entity = Wikidata.WikidataEntity("Q42")
    @test  Wikidata.label(entity)=="Douglas Adams"
    @test_throws HTTP.ExceptionRequest.StatusError Wikidata.WikidataEntity("Douglas Adams")
end
