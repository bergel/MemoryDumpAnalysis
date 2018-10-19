Class {
	#name : #TAFree,
	#superclass : #TAEvent,
	#instVars : [
		'correspondingMalloc'
	],
	#category : #'MemoryDumpAnalysis-TraceAnalysis'
}

{ #category : #accessing }
TAFree >> correspondingMalloc [
	^ correspondingMalloc
]

{ #category : #accessing }
TAFree >> correspondingMalloc: aMalloc [
	correspondingMalloc := aMalloc
]

{ #category : #'public - testing' }
TAFree >> isBound [
	^ correspondingMalloc notNil
]

{ #category : #'public - testing' }
TAFree >> isFree [
	^ true
]

{ #category : #accessing }
TAFree >> size [
	"Amount of freed space"
	self correspondingMalloc ifNil: [ ^ 0 ].
	^ self correspondingMalloc size
]
