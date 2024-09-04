# Wheater APP - iOS

## Git Flow
The project follow the best practices on git flow. Bellow is a brief description of all branches used:
 - **main**: Release branch, represents all store releases;
 - **development**: Development branch, where all features branches starts from and usually the newest and most stable code;
 - **FEATURE/{featureName}**: The "FEATURE folder" wraps all feature branches. A feature branch will start from development, ex.: FEATURE/home. And all the feature work will be done at the feature branch until it is ready to be merged on development branch.
 - **hotfix**: Hotfix branch is used to fix major updates on release build (latest version on main branch). This is important to be able to fix a major issue on release branch without carrying all the new development branch that store unstable, and usually not validated yet, features.
 
<img width=1200px src="https://github.com/Bressam/wheater-ios/blob/main/weather-app-gitflow.png">
