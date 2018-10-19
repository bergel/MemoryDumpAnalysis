Class {
	#name : #TAMalloc,
	#superclass : #TAEvent,
	#instVars : [
		'correspondingFree',
		'size'
	],
	#category : #'MemoryDumpAnalysis-TraceAnalysis'
}

{ #category : #accessing }
TAMalloc >> correspondingFree [
	^ correspondingFree
]

{ #category : #accessing }
TAMalloc >> correspondingFree: aFree [
	correspondingFree := aFree
]

{ #category : #'public - testing' }
TAMalloc >> isBound [
	^ correspondingFree notNil
]

{ #category : #'public - testing' }
TAMalloc >> isMalloc [
	^ true
]

{ #category : #printing }
TAMalloc >> printOn: str [

	super printOn: str.
	str cr.
	
	str nextPutAll: 'size: '.
	str nextPutAll: self size asStringWithCommas.
	str cr.
	
	str nextPutAll: 'is freed: '.
	str nextPutAll: self isBound asString.
	str cr.
	

	str nextPutAll: 'index: '.
	str nextPutAll: self index asString.
	str cr.

]

{ #category : #accessing }
TAMalloc >> size [
	^ size
]

{ #category : #accessing }
TAMalloc >> size: anObject [
	size := anObject
]
