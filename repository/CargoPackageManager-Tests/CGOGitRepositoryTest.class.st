Class {
	#name : #CGOGitRepositoryTest,
	#superclass : #CGOGitCreationTest,
	#category : 'CargoPackageManager-Tests-SCM'
}

{ #category : #accessing }
CGOGitRepositoryTest class >> defaultTimeLimit [ 
	^10 minutes
]

{ #category : #asserting }
CGOGitRepositoryTest >> assertSrcPackageVersion: srcPackageVersion hasSameUrlAs: anotherPackageVersion [
	| repoUrl expectedUrl |
	repoUrl := ((srcPackageVersion instVarNamed: 'repository')
						instVarNamed: 'repositoryUrl').
	expectedUrl := ((anotherPackageVersion instVarNamed: 'repository') 
						instVarNamed: 'repositoryUrl').
	self assert: (repoUrl isKindOf: String).
	self assert: repoUrl	equals: expectedUrl
]

{ #category : #'tests - test data' }
CGOGitRepositoryTest >> cargoMinimalB9ee [
	^ CGOGitHostedPackageVersionEnforcingProtocol
		repositoryUrl: 'git@github.com:demarey/cargo.git'
		subdirectory: 'repository'
		packageName: 'CargoPackageManager-Minimal'
		commitish: 'b9ee048f40e500198120aedf8db60266caa9ece9' 
]

{ #category : #'tests - test data' }
CGOGitRepositoryTest >> cargoMinimalB9eeHttpsUrl [
	^ CGOGitHostedPackageVersion
		repositoryUrl: 'https://github.com/demarey/cargo.git'
		subdirectory: 'repository'
		packageName: 'CargoPackageManager-Minimal'
		commitish: 'b9ee048f40e500198120aedf8db60266caa9ece9'
]

{ #category : #'tests - test data' }
CGOGitRepositoryTest >> pharoCounterMaster [
	^ CGOGitRepositoryCreator new
		githubUrl: 'github://demarey/pharo-counter:master';
		location: self iceRepositoryLocation;
		create
		
]

{ #category : #'tests - test data' }
CGOGitRepositoryTest >> pharoCounterMasterCloned [
	^ self pharoCounterMaster 
		ensureCloned;
		yourself
]

{ #category : #'tests - test data' }
CGOGitRepositoryTest >> pharoCounterTestsOriginRepo [
	^ CGOGitHostedPackageVersion
		repositoryUrl: 'git@github.com:demarey/pharo-counter.git'
		subdirectory: ''
		packageName: 'Counter-Tests'
		commitish: 'master'
]

{ #category : #'tests - test data' }
CGOGitRepositoryTest >> stonCargoMinimalB9ee [
	^ 'CGOGitHostedPackageVersion{#repository:CGOGitRepository{#repositoryUrl:''git@github.com:demarey/cargo.git'',#subdirectory:''repository''},#packageName:#CargoPackageManager-Minimal,#commitish:''b9ee048f40e500198120aedf8db60266caa9ece9''}'
]

{ #category : #'tests - test data' }
CGOGitRepositoryTest >> stonCargoMinimalB9eeHttpsUrl [
	^ 'CGOGitHostedPackageVersion{#repository:CGOGitRepository{#repositoryUrl:''https://github.com/demarey/cargo.git'',#subdirectory:''repository''},#packageName:#CargoPackageManager-Minimal,#commitish:''b9ee048f40e500198120aedf8db60266caa9ece9''}'
]

{ #category : #tests }
CGOGitRepositoryTest >> testCanBeSerializedInSton [
	| repositoryStonString |
	repository := self pharoCounterMasterCloned.
	repositoryStonString := STON toStringPretty: repository.
	
	self 
		assert: repositoryStonString
		equals: 'CGOGitRepository {
	#repositoryUrl : ''git://git@github.com/demarey/pharo-counter.git'',
	#version : ''master''
}'
]

{ #category : #tests }
CGOGitRepositoryTest >> testCanDetectGitRepositoryCloned [
	| location |
	location := self iceRepositoryLocation.
	IceRepositoryCreator new 
			addRemote: 'https://github.com/demarey/pharo-counter';
			subdirectory: '';
			location: location;
			createRepository.
	repository := CGOGitRepositoryCreator new
		githubUrl: 'github://demarey/pharo-counter:master';
		location: location;
		create.
	
	self assert: repository isCloned

]

{ #category : #tests }
CGOGitRepositoryTest >> testCanDetectGitRepositoryNotClonedWhenMissingLocation [

	repository := self pharoCounterMaster.
	self deny: repository isCloned

]

{ #category : #tests }
CGOGitRepositoryTest >> testCanEnsureRepositoryClonedAtBranchOriginHeadWhenRepositoryClonedInSameBranchAndDetachedHead [
	| iceRepository location |
	location := self iceRepositoryLocation.
	iceRepository := IceRepositoryCreator new 
			addRemote: 'https://github.com/demarey/pharo-counter';
			subdirectory: '';
			location: location;
			createRepository.
	(iceRepository lookupCommit: 'c1c1ef63933790a364501cdb991b18c589516729') checkout.
	repository := CGOGitRepositoryCreator new
		githubUrl: 'github://demarey/pharo-counter:master';
		location: location;
		create.
	
	self 
		assert: iceRepository headCommit id
		equals: 'c1c1ef63933790a364501cdb991b18c589516729'.
	
	repository ensureCloned.
	
	self 
		assert: repository currentCommitId
		equals: '61e71ff1f118f48bda23f3765400cfd51f10d147'.
]

{ #category : #tests }
CGOGitRepositoryTest >> testCanEnsureRepositoryClonedWhenRepositoryNotYetCloned [

	repository := CGOGitRepositoryCreator new
		githubUrl: 'github://demarey/pharo-counter:master';
		location: self iceRepositoryLocation;
		create.
		
	self deny: repository iceRepository location exists.
	
	repository ensureCloned.
	
	self assert: repository iceRepository location exists.
	self
		assert: repository iceRepository branchName
		equals: 'master'
]

{ #category : #tests }
CGOGitRepositoryTest >> testCanGetMCVersionWhenAOngoingPackageUnitProvided [
	| result |
	
	self flag:#todo.
	"This functionality uses old Iceberg API, should be migrated"
	self skip.	
	
	repository := self pharoCounterMasterCloned.
	result := repository mcVersionFor: (CGOOngoingPackageUnit for: 'Counter-Core').
	self assert: (result isKindOf: MCVersion)
]

{ #category : #tests }
CGOGitRepositoryTest >> testCanGetMetadataFromGitRepository [
	| project |
	"CGOPackageVersion"
	repository := self pharoCounterMasterCloned.
	project := CGOOngoingProject fromStonString: repository projectMetadataStonString.
	
	self 
		assert: project packageName
		equals: #Counter.
	self 
		assert: project packageUnits anyOne class 
		equals: CGOOngoingPackageUnit.
	
	self 
		assert: (project packageUnits collect: #packageName) sorted
		equals: #('Counter-Core' 'Counter-Tests').
		
	self 
		assert: (project packageUnits detect: [ :each | each packageName = #'Counter-Core']) dependencies
		equals: #().
	self 
		assert: (project packageUnits detect: [ :each | each packageName = #'Counter-Tests']) dependencies size
		equals: 1.
	self 
		assert: project assemblies isEmpty.

]

{ #category : #tests }
CGOGitRepositoryTest >> testCanSavePackageAndItsMetadata [
	| mcVersion message |
	
	self flag:#todo.
	"This functionality uses old Iceberg API, should be migrated"
	self skip.
	
	repository := self pharoCounterMasterCloned.
	message := 'commit from test #testCanSavePackageAndItsMetadata'.
	mcVersion := repository 
		savePackageUnit: (CGOOngoingPackageUnit for: 'Counter-Core') withMessage: message.
	self 
		assert: mcVersion info message
		equals: message
]

{ #category : #tests }
CGOGitRepositoryTest >> testErrorRaisedWhenRepositoryUrlIsWrong [
	self 
		should: [ IceRepositoryCreator new 
			addRemote: 'https://github.com/foo/bar.git';
			location: FileLocator temp / ('pharo-tests-' , DateAndTime now asFileNameCompatibleString);
			subdirectory: '';
			createRepository ]
		raise: IceGenericError
]

{ #category : #tests }
CGOGitRepositoryTest >> testGetPackageMetadataNotFoundErrorWhenMetadataFileAbsent [

	repository := CGOGitRepositoryCreator new
		githubUrl: 'github://demarey/HotelApp:master';
		location: self iceRepositoryLocation;
		createAndClone.

	self should: [ repository projectMetadataStonString ] raise: FileDoesNotExistException
]
