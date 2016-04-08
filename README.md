# README #

MIMS Implementation Repo

### What is this repository for? ###

* The repo for the implantation of our MIMS system. All changes will be committed to the repo for continuity and to ensure that work on the project goes smoothly. 
* 1.0


### How do I get set up? ###

* Summary of set up
In order to get a working copy of the repo on your local machine...

1. `cd` to the folder you want to keep the local copy of your project in. 
2. In that folder, run the command 
`git clone https://pbush25@bitbucket.org/umllovers/mims.git` which will clone the repo into your local copy. 
3. Open the MIMS.xcworkspace file. This should be the file that you always use to open Xcode, not the MIMS.xcproj file. 
4. Navigate to source control on the top menu
    ![Screen Shot 2016-04-07 at 1.01.07 PM.png](https://bitbucket.org/repo/Xpey6E/images/646889544-Screen%20Shot%202016-04-07%20at%201.01.07%20PM.png)
5. Create a new branch with your name as the Branch name to help us keep track of who has added what features, by choosing Source Control -> New branch.
    ![Screen Shot 2016-04-07 at 1.02.49 PM.png](https://bitbucket.org/repo/Xpey6E/images/4143923581-Screen%20Shot%202016-04-07%20at%201.02.49%20PM.png)
6. When you've made the changes to the local copy that you would like to commit, go to Source Control -> Commit, and enter a meaningful commit message, as well as check the box in the lower left hand corner that says "Push to remote" and make sure your branch is the selected branch. 
7. Now, when your tests have been written and you're ready to merge your changes into the master branch, navigate to Source Control -> Merge into branch and choose the master branch. Now your changes will be merged with the master branch. 
8. After you've merged your changes, make sure to Source Control -> Commit your changes and then Source Control -> Push which will push your local changes to the master origin repo. 

### New work for the day ###
* When you're about to start working on something new
Before starting any work for the day, always navigate to Source Control -> Pull in order to pull the most recent versions of the project from the Origin repo to have any updated changes. 

* How to run tests
In Xcode, instead of Command + R to run, use Command + U to run your tests. 

### Contribution guidelines ###

* Writing tests

Tests should be written for every commit or feature added to the project before committing it to the Master branch. 

### Who do I talk to? ###

* Repo owner or admin
Contact Patrick. 404-375-9624 or pmb0012@auburn.edu