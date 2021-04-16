Class {
	#name : #CovidCommonQueries,
	#superclass : #Object,
	#instVars : [
		'stream'
	],
	#category : #'Covid-Reader'
}

{ #category : #'instance creation' }
CovidCommonQueries class >> toTranscript [

	^ self writingTo: Transcript
]

{ #category : #'instance creation' }
CovidCommonQueries class >> writingTo: aStream [

	^ self new initializeWritingTo: aStream
]

{ #category : #processing }
CovidCommonQueries >> dumpInfantCasesByWeekStart [

	self infantCasesByWeekStart
		keysAndValuesDo: [ :weekStart :cases | 
			stream
				cr;
				show: weekStart;
				tab;
				show: cases size
			]
]

{ #category : #processing }
CovidCommonQueries >> dumpMortalityByAgeGroup [

	( self mortalityByAgeGroupOn: Date today )
		keysAndValuesDo: [ :age :percentage | 
			stream
				cr;
				show: age;
				tab;
				show: age + 4;
				tab;
				nextPutAll: ( '=<1p>' expandMacrosWith: percentage )
			]
]

{ #category : #processing }
CovidCommonQueries >> dumpMortalityByAgeGroupByWeekStart [

	( self mortalityByAgeGroupByWeekStartOn: Date today )
		keysAndValuesDo: [ :age :percentageByWeekStart | 
			percentageByWeekStart
				keysAndValuesDo: [ :weekStart :percentage | 
					stream
						cr;
						show: age;
						tab;
						show: age + 4;
						tab;
						show: weekStart;
						tab;
						nextPutAll: ( '=<1p>' expandMacrosWith: percentage )
					]
			]
]

{ #category : #querying }
CovidCommonQueries >> fatalHospitalizationMoments [

	| moments |

	moments := OrderedCollection new.

	CovidReader lastReading confirmedCases
		do:
			[ :case | case withFatalHospitalizationDo: [ :hospitalizationTime | moments add: hospitalizationTime ] ].
	^ Array with: moments average with: moments median
]

{ #category : #querying }
CovidCommonQueries >> infantCasesByWeekStart [

	^ ( CovidReader lastReading confirmedCases
		select: [ :each | each age ifNil: [ false ] ifNotNil: [ :age | age < 6 ] ] )
		groupedBy: [ :each | each classificationDate asWeek start asDate yyyymmdd ]
]

{ #category : #initialization }
CovidCommonQueries >> initializeWritingTo: aStream [

	stream := aStream
]

{ #category : #querying }
CovidCommonQueries >> mortalityByAgeGroupByWeekStartOn: aDate [

	| relevantCases groups mortalityByAgeGroupByWeekStart |

	groups := Dictionary new.
	mortalityByAgeGroupByWeekStart := Dictionary new.
	relevantCases := CovidReader lastReading confirmedCases select: [ :case | case age notNil ].
	relevantCases
		do: [ :case | 
			| casesByWeekStart |

			casesByWeekStart := groups at: ( case age / 5 ) floor ifAbsentPut: [ Dictionary new ].
			( casesByWeekStart
				at: case classificationDate asWeek start asDate yyyymmdd
				ifAbsentPut: [ OrderedCollection new ] ) add: case
			].
	groups
		keysAndValuesDo: [ :dividedAge :casesByWeekStart | 
			casesByWeekStart
				keysAndValuesDo: [ :weekStart :cases | 
					| dead |

					dead := cases count: [ :case | ( case isAliveOn: aDate ) not ].
					( mortalityByAgeGroupByWeekStart at: dividedAge * 5 ifAbsentPut: [ Dictionary new ] )
						at: weekStart
						put: ( dead / cases size round: 4 )
					]
			].
	^ mortalityByAgeGroupByWeekStart
]

{ #category : #querying }
CovidCommonQueries >> mortalityByAgeGroupOn: aDate [

	| groups mortalityByAgeGroup |

	groups := ( CovidReader lastReading confirmedCases select: [ :case | case age notNil ] )
		groupedBy: [ :case | ( case age / 5 ) floor ].
	mortalityByAgeGroup := Dictionary new.
	groups
		keysAndValuesDo: [ :dividedAge :cases | 
			| dead |

			dead := cases count: [ :case | ( case isAliveOn: aDate ) not ].
			mortalityByAgeGroup at: dividedAge * 5 put: ( dead / cases size round: 4 )
			].
	^ mortalityByAgeGroup
]

{ #category : #querying }
CovidCommonQueries >> nonFatalHospitalizationMoments [

	| moments |

	moments := OrderedCollection new.

	CovidReader lastReading confirmedCases
		do:
			[ :case | case withNonFatalHospitalizationDo: [ :hospitalizationTime | moments add: hospitalizationTime ] ].
	^ Array with: moments average with: moments median
]

{ #category : #processing }
CovidCommonQueries >> refreshSource [

	| reader |

	reader := CovidReader reading: 'f:\Downloads\Covid\casos_covid19.csv'.
	reader read
]
