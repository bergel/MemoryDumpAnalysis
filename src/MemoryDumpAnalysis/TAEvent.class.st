Class {
	#name : #TAEvent,
	#superclass : #Object,
	#instVars : [
		'index',
		'address',
		'size',
		'addressAsString'
	],
	#category : #'MemoryDumpAnalysis-TraceAnalysis'
}

{ #category : #accessing }
TAEvent >> address [
	^ address
]

{ #category : #accessing }
TAEvent >> address: anInteger [
	address := anInteger
]

{ #category : #accessing }
TAEvent >> addressAsString [
	^ addressAsString
]

{ #category : #accessing }
TAEvent >> addressAsString: aString [
	addressAsString := aString
]

{ #category : #accessing }
TAEvent >> index [
	^ index
]

{ #category : #accessing }
TAEvent >> index: anObject [
	index := anObject
]

{ #category : #'public - testing' }
TAEvent >> isFree [
	^ false
]

{ #category : #'public - testing' }
TAEvent >> isMalloc [
	^ false
]

{ #category : #accessing }
TAEvent >> size1 [
	^ size
]

{ #category : #accessing }
TAEvent >> size: anObject [
	size := anObject
]
