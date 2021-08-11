Original App Design Project - FBU Engineering 2021
===

# Rate my Class

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Allows users to rate and write reviews on the classes they took. User can browse through other people's reviews for classes. Users can find classes that fit their requirements and make better decisions when choosing which classes to take. 

### App Evaluation
- **Category:** Education
- **Mobile:** Mobile is essential for instant reviewing of classes. Users can easily write reviews and read reviews from their phone. 
- **Story:** Allows users to be educated on the classes they choose to take. Helps users find classes that are a good fit for them personally.
- **Market:** Students who attend University of California, Irvine can utilize this app.
- **Habit:** Users can write and read reviews anytime. Peak use will likely be during class registration periods. 
- **Scope:** Currently the app only servers classes from one school. Can be expanded to serve students from multiple schools. 

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can login, logout, and signup
* User can search for a class
* User can view classes in the home feed
* User can see the detailed view for a class and write a review
* User can write a review for a class
* User can view the classes they reviewed in their profile
* User can filter classes using tags (stored in database)
* post picture of course material

**Optional Nice-to-have Stories**

* User can save a list of favorited classes
* User can input all the classes they've taken and be shown only the classes they have prereqs for
* Users can sort by rating, department, etc 
* Date and username is displayed on the reviews
* Ratings show up as star symbols
* like, dislike, save reviews
* recently searched, datetime posted
* filter for search
* filter review comments for curse words

### 2. Screen Archetypes

* Login/logout screen
   * User can login
   * User can logout
* Registration screen
   * User can create account
* Stream
   * User can scroll through feed seeing classes with ratings
   * User can click on a class to see the details view
* Profile screen
   * User can see account information 
   * User can view their reviews

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home tab
* Search tab
* Profile tab

**Flow Navigation** (Screen to Screen)

* [list first screen here]
   * [list screen navigation here]
   * ...
* [list second screen here]
   * [list screen navigation here]
   * ...

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="YOUR_WIREFRAME_IMAGE_URL" width=600>

### Digital Wireframes & Mockups
![](https://i.imgur.com/AJaMZ7J.png)

## Schema 
### Models
Review
|  Property | Type | Description |
| -------- | -------- | -------- |
| className   | String     | The class being reviewed  |
| comment    | String     | User's comments about class  |
| rating | Number | User's rating of class overall out of 5 |
| difficulty | Number | User's rating of class difficulty out of 5 |

Class
|  Property | Type | Description |
| -------- | -------- | -------- |
| courseCode   | String     | The course code of class  |
| rating   | Number     | Overall class rating |
| difficulty | Number | Overall class difficulty out of 5 |
| Reviews | Pointer to another Parse Object | The reviews for the class |


### Networking
List of network requests by screen
- Home Feed Screen
    - (Create/POST) Create a new comment on a post
    - (Delete) Delete existing comment
    - (Read/GET) Query all classes interesting to user
    ```q
    PFQuery * query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"Department" equalTo:userDepartment;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error == nil){
            self.posts = objects;
            [self.tableView reloadData];
        } else {
            NSLog(@"error");
        }
        [self.refreshControl endRefreshing];
    }];
    

- Create Post Screen
    - (Create/POST) Create a review for a class
    ```d
    [Post postUserReview:self.commentLabel.text withRating:self.ratingLabel.text withCompletion:^(BOOL succeeded, NSError * _Nullable error){}
 - Profile Screen
    - (Read/GET) Query logged in user object
    - (Read/GET) User written reviews

### [OPTIONAL:] Existing API Endpoints

Peter Portal API (courses)
- Base URL - https://api.peterportal.org/rest/v0/courses/

|  HTTP Verb | Endpoint | Description |
| -------- | -------- | -------- |
| GET   | /all     | Gets all courses in course catalogue  |
| GET | /{courseID} | Course department + course number (without spaces) |
