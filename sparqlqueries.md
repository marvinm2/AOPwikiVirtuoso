### Example query #1: From an AOP, give me all measurement methods.

```
prefix dc: <http://purl.org/dc/elements/1.1/>
prefix dcterms: <http://purl.org/dc/terms/>
prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>
prefix aop: <http://identifiers.org/aop/>
prefix aopo: <http://aopkb.org/aop_ontology#>
prefix mmo: <http://purl.obolibrary.org/obo/MMO_>

select ?AopLabel?KeLookUp ?AssayText
where {
 ?KeLook a aopo:KeyEvent ;
 rdfs:label ?KeLookUp ;
 dcterms:isPartOf ?aop ; 
 mmo:0000000 ?AssayText .
 ?aop dc:identifier ?AopAssoc ;
 rdfs:label ?AopLabel .
 filter (?aop = aop:12)
}
```
### Example query #2: Provide me with all Key Events that could result from a certain chemical.

```
prefix dc: <http://purl.org/dc/elements/1.1/>
prefix dcterms: <http://purl.org/dc/terms/>
prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>
prefix aop: <http://identifiers.org/aop/>
prefix aopo: <http://aopkb.org/aop_ontology#>
prefix ke: <http://identifiers.org/aop.events/>
prefix stressor: <http://identifiers.org/aop.stressor/>
prefix casrn: <http://identifiers.org/cas/>
prefix ncit: <http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#>


select ?chemicalName ?StressorLookUp ?AOPname ?AOPLookUp ?KEname ?KEofAOP
where {
 ?chemical a cheminf:CHEMINF_000000 ;
 dc:title ?chemicalName ;
 dcterms:isPartOf ?StressorLookUp .
 ?StressorLookUp a ncit:C54571 ;
 dcterms:isPartOf ?AOPLookUp .
 ?AOPLookUp a aopo:AdverseOutcomePathway ;
 aopo:has_key_event ?KEofAOP ;
 dc:title ?AOPname . 
 ?KEofAOP a aopo:KeyEvent ;
 dc:title ?KEname .
 
 filter (?chemical = casrn:107-18-6)
}
```


### Example query #3: Give me all Molecular Initiating Events that lead to a particular Adverse Outcome.
```
prefix dc: <http://purl.org/dc/elements/1.1/>
prefix aop: <http://identifiers.org/aop/>
prefix aopo: <http://aopkb.org/aop_ontology#>

select ?KE ?KEname ?AOP ?AOPname ?MIE ?MIEname
where {
 ?KE a aopo:KeyEvent ;
 dc:identifier ?AOLookup ;
 dc:title ?KEname .
 ?AOP a aopo:AdverseOutcomePathway ;
 dc:title ?AOPname ;
 aopo:has_adverse_outcome ?AOLookup;
 aopo:has_molecular_initiating_event ?MIE.
 ?MIE dc:title ?MIEname .

 
 filter (?KE = ke:345)
}
```

### Example query #4: From all chemicals in AOP-Wiki, give me all molecular pathways of WikiPathways that contain the chemical.

```
prefix dc: <http://purl.org/dc/elements/1.1/>
prefix dcterms: <http://purl.org/dc/terms/>
prefix cheminf: <http://semanticscience.org/resource/> 
prefix wdt: <http://www.wikidata.org/prop/direct/>
prefix wp: <http://vocabularies.wikipathways.org/wp#>
prefix aopo: <http://aopkb.org/aop_ontology#>

select distinct ?ChemicalName ?LinkedAOP ?LinkedAOPURI ?CASRN ?ChemicalURI ?PathwayID ?PathwayURI where{
select *where { 
 ?cheLook a cheminf:CHEMINF_000000 ;
 dc:identifier ?ChemicalURI ;
 dc:title ?ChemicalName ;
 cheminf:CHEMINF_000446 ?CASRN ;
 dcterms:isPartOf ?LinkedStressor.
 ?LinkedStressor dcterms:isPartOf ?LinkedAOPURI .
 ?LinkedAOPURI a aopo:AdverseOutcomePathway ;
 rdfs:label ?LinkedAOP.
 service <https://query.wikidata.org/bigdata/namespace/wdq/sparql>{
   ?wikidata wdt:P231 ?CASRN.
   service <http://sparql.wikipathways.org/>{
     ?metabolite wp:bdbWikidata ?wikidata;
     dcterms:isPartOf ?PathwayURI.
     ?PathwayURI a wp:Pathway ;
     dcterms:identifier ?PathwayID.
}}}} order by ?ChemicalName
```
