Class {
	#name : #BaselineOfCABACovid,
	#superclass : #BaselineOf,
	#category : #BaselineOfCABACovid
}

{ #category : #baselines }
BaselineOfCABACovid >> baseline: spec [

	<baseline>
	spec
		for: #pharo
		do: [ self
				setUpDependencies: spec;
				setUpPackages: spec
			]
]

{ #category : #accessing }
BaselineOfCABACovid >> projectClass [

	^ MetacelloCypressBaselineProject
]

{ #category : #baselines }
BaselineOfCABACovid >> setUpDependencies: spec [

	spec
		baseline: 'Buoy' with: [ spec repository: 'github://ba-st/Buoy:v6/source' ];
		project: 'Buoy-Deployment' copyFrom: 'Buoy' with: [ spec loads: 'Deployment' ]
]

{ #category : #baselines }
BaselineOfCABACovid >> setUpPackages: spec [

	spec
		package: 'Covid-Reader' with: [ spec requires: #('Buoy-Deployment') ];
		group: 'Deployment' with: 'Covid-Reader'
]
