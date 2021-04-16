Class {
	#name : #ConfirmedCase,
	#superclass : #Object,
	#instVars : [
		'classificationDate',
		'age',
		'survivalOptional',
		'dischargeOptional',
		'source'
	],
	#category : #'Covid-Reader'
}

{ #category : #'instance creation' }
ConfirmedCase class >> on: aDate aged: aNumber survivalOptional: maybeDateOfDeath dischargeOptional: maybeDateOfDischarge obtainedFrom: aSourceString [

	^ self new
		initializeOn: aDate
		aged: aNumber
		survivalOptional: maybeDateOfDeath
		dischargeOptional: maybeDateOfDischarge
		obtainedFrom: aSourceString
]

{ #category : #acccessing }
ConfirmedCase >> age [

	^ age
]

{ #category : #acccessing }
ConfirmedCase >> classificationDate [

	^ classificationDate
]

{ #category : #testing }
ConfirmedCase >> hasNotBeenDischargedBy: aDate [

	^ dischargeOptional
		withContentDo: [ :dateOfDischarge | dateOfDischarge > aDate ]
		ifUnused: [ true ]
]

{ #category : #initialization }
ConfirmedCase >> initializeOn: aClassificationDate aged: aNumber survivalOptional: maybeDateOfDeath dischargeOptional: maybeDateOfDischarge obtainedFrom: aSourceString [

	classificationDate := aClassificationDate.
	age := aNumber.
	survivalOptional := maybeDateOfDeath.
	dischargeOptional := maybeDateOfDischarge.
	source := aSourceString
]

{ #category : #testing }
ConfirmedCase >> isActiveOn: aDate [

	^ ( self wasClassifiedBy: aDate )
		and: [ ( self isAliveOn: aDate ) and: [ self hasNotBeenDischargedBy: aDate ] ]
]

{ #category : #testing }
ConfirmedCase >> isAliveOn: aDate [

	^ survivalOptional withContentDo: [ :dateOfDeath | dateOfDeath > aDate ] ifUnused: [ true ]
]

{ #category : #printing }
ConfirmedCase >> printOn: aStream [

	aStream nextPutAll: 'Classified on '.
	classificationDate printOn: aStream.
	aStream cr.

	aStream nextPutAll: 'Age '.
	age printOn: aStream.
	aStream cr.

	survivalOptional
		withContentDo: [ :dateOfDeath | 
			aStream nextPutAll: 'Died on '.
			dateOfDeath printOn: aStream.
			aStream cr
			].

	dischargeOptional
		withContentDo: [ :dateOfDischarge | 
			aStream nextPutAll: 'Discharged on '.
			dateOfDischarge printOn: aStream.
			aStream cr
			]
]

{ #category : #testing }
ConfirmedCase >> wasClassifiedBy: aDate [

	^ classificationDate <= aDate
]

{ #category : #acccessing }
ConfirmedCase >> withFatalHospitalizationDo: aBlock [

	^ survivalOptional
		withContentDo: [ :dateOfDeath | aBlock value: ( dateOfDeath - classificationDate ) asDays ]
]

{ #category : #acccessing }
ConfirmedCase >> withNonFatalHospitalizationDo: aBlock [

	^ dischargeOptional
		withContentDo: [ :dateOfDischarge | aBlock value: ( dateOfDischarge - classificationDate ) asDays ]
]
