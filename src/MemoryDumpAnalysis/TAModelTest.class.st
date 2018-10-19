Class {
	#name : #TAModelTest,
	#superclass : #TestCase,
	#instVars : [
		'model'
	],
	#category : #'MemoryDumpAnalysis-TraceAnalysis'
}

{ #category : #running }
TAModelTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	model := TAModel new.
]

{ #category : #tests }
TAModelTest >> testAddTraceAsString [

	| mallocs |
	model addAsString: 
'[MEM] malloc(72704): 0x55f086ef9260
[MEM] malloc(1024): 0x55f086f0ae70
[MEM] malloc(3): 0x55f086f0b280
[MEM] malloc(10): 0x55f086f0b2a0
[MEM] malloc(1): 0x55f086f0b2c0
[MEM] malloc(6): 0x55f086f0b2e0
[MEM] malloc(1): 0x55f086f0b300
[MEM] malloc(8): 0x55f086f0b320'.

	self assert: model numberOfEvents equals: 8.
	self assert: model numberOfMallocs equals: 8.
	self assert: model numberOfFrees equals: 0.
	
	mallocs := model mallocs.
	self assert: mallocs size equals: 8.
	self assert: mallocs first index equals: 1.
	self assert: mallocs second index equals: 2.
	self assert: mallocs third index equals: 3.
	
	self assert: mallocs first address equals: 94491544359520.
	self assert: mallocs first size equals: 72704.
	
	self assert: (model mallocFromAddress: 94491544359520 startingAtIndex: 3) equals: mallocs first
]

{ #category : #tests }
TAModelTest >> testAddTraceAsString2 [

	model addAsString: '[MEM] malloc(72704): 0x55f086ef9260
[MEM] malloc(1024): 0x55f086f0ae70
[MEM] malloc(3): 0x55f086f0b280
[MEM] malloc(10): 0x55f086f0b2a0
[MEM] malloc(1): 0x55f086f0b2c0
[MEM] malloc(6): 0x55f086f0b2e0
[MEM] free: 0x55f086f0b280
[MEM] malloc(1): 0x55f086f0b300
[MEM] malloc(8): 0x55f086f0b320'.

	self assert: model numberOfEvents equals: 9.
	self assert: model numberOfMallocs equals: 8.
	self assert: model numberOfFrees equals: 1.
]

{ #category : #tests }
TAModelTest >> testBasic [ 
	self assert: model numberOfEvents equals: 0
]

{ #category : #tests }
TAModelTest >> testFreeAndMalloc [

	| mallocs |
	model addAsString: 
'[MEM] malloc(72704): 0x55f086ef9260 
[MEM] malloc(72704): 0x55f086ef9250
[MEM] free: 0x55f086ef9260 
'.

	self assert: model numberOfEvents equals: 3.
	self assert: model numberOfMallocs equals: 2.
	self assert: model numberOfFrees equals: 1.
	
	mallocs := model mallocs.
	self assert: (model mallocFromAddress: 94491544359520 startingAtIndex: 3) equals: mallocs first
]

{ #category : #tests }
TAModelTest >> testFreeAndMalloc2 [

	| mallocs |
	model addAsString: 
'[MEM] malloc(72704): 0x55f086ef9250  
[MEM] malloc(72704): 0x55f086ef9260
[MEM] free: 0x55f086ef9260 
'.

	self assert: model numberOfEvents equals: 3.
	self assert: model numberOfMallocs equals: 2.
	self assert: model numberOfFrees equals: 1.
	
	mallocs := model mallocs.
	self assert: (model mallocFromAddress: 94491544359520 startingAtIndex: 3) equals: mallocs second
]

{ #category : #tests }
TAModelTest >> testFreeAndMalloc3 [

	| mallocs |
	model addAsString: 
'[MEM] malloc(72704): 0x55fef9250  
[MEM] malloc(72704): 0x55f086ef60
[MEM] free: 0x55f086ef9260 
'.

	self assert: model numberOfEvents equals: 3.
	self assert: model numberOfMallocs equals: 2.
	self assert: model numberOfFrees equals: 1.
	
	mallocs := model mallocs.
	self assert: (model mallocFromAddress: 94491544359520 startingAtIndex: 3) isNil
]
