Class {
	#name : #CovidReader,
	#superclass : #Object,
	#instVars : [
		'confirmedCaseLines',
		'fileReference'
	],
	#classVars : [
		'lastReading'
	],
	#pools : [
		'ChronologyConstants'
	],
	#category : #'Covid-Reader'
}

{ #category : #accessing }
CovidReader class >> lastReading [

	^ lastReading
]

{ #category : #'instance creation' }
CovidReader class >> reading: aFileName [

	^ self new initializeReading: aFileName
]

{ #category : #'private - accessing' }
CovidReader >> confirmedCaseFrom: aLine [

	"1:numero_de_caso,2:fecha_apertura_snvs,3:fecha_toma_muestra,4:fecha_clasificacion,5:provincia,6:barrio,7:comuna,8:genero,9:edad,10:clasificacion,11:fecha_fallecimiento,12:fallecido,13:fecha_alta,14:tipo_contagio"

	| elements classificationDate |

	elements := ',' split: aLine.
	classificationDate := self dateFrom: ( elements at: 4 ).
	( self optionalDateFrom: ( elements at: 3 ) )
		withContentDo: [ :samplingDate | classificationDate := classificationDate min: samplingDate ].
	^ ConfirmedCase
		on: classificationDate
		aged: ( elements at: 9 ) asInteger
		survivalOptional: ( self optionalDateFrom: ( elements at: 11 ) )
		dischargeOptional: ( self optionalDateFrom: ( elements at: 13 ) )
		obtainedFrom: aLine
]

{ #category : #accessing }
CovidReader >> confirmedCases [

	^ confirmedCaseLines
]

{ #category : #'private - accessing' }
CovidReader >> dateFrom: aString [

	| day monthAbbreviation monthName monthIndex year |

	day := ( aString copyFrom: 1 to: 2 ) asNumber.
	monthAbbreviation := aString copyFrom: 3 to: 5.
	monthName := MonthNames
		detect: [ :eachName | eachName asUppercase beginsWith: monthAbbreviation asUppercase ].
	monthIndex := MonthNames indexOf: monthName.
	year := ( aString copyFrom: 6 to: 9 ) asNumber.
	^ Date year: year month: monthIndex day: day
]

{ #category : #initialization }
CovidReader >> initializeReading: aFileName [

	confirmedCaseLines := OrderedCollection new.
	fileReference := aFileName asFileReference
]

{ #category : #'private - processing' }
CovidReader >> nextLineFrom: stream [

	^ stream upTo: Character lf
]

{ #category : #'private - accessing' }
CovidReader >> optionalDateFrom: aString [

	( aString isEmpty or: [ aString = 'NA' ] )
		ifTrue: [ ^ Optional unused ].
	^ Optional containing: ( self dateFrom: aString )
]

{ #category : #processing }
CovidReader >> read [

	fileReference readStreamDo:
		[ :stream | self readFrom: stream ].
	lastReading := self
]

{ #category : #'private - processing' }
CovidReader >> readFrom: stream [

	[ stream atEnd ]
		whileFalse: [ | line |

			line := self nextLineFrom: stream.
			( self shouldProcess: line )
				ifTrue: [ confirmedCaseLines add: ( self confirmedCaseFrom: line ) ]
			]
]

{ #category : #'private - testing' }
CovidReader >> shouldProcess: line [

	^ line includesSubstring: 'confirmado'
]
