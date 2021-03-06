"
A MinimunChangesResolutionPolicy is used to specify that we want to change only what is strictly required (e.g. keep current versions of installed packages if possible and install the minimum number of new dependencies).
"
Class {
	#name : #CGOMinimumChangesResolutionStrategy,
	#superclass : #CGOPackageVersionResolutionStrategy,
	#category : 'CargoPackageManager-SolverStrategies'
}
