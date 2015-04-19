Reviews
=======

Implemented:
- Each review belongs to the user receiving the review and has a authorID corresponding to the ObjectId of the user who is supposed to leave the review. Only this user can leave the review and must be signed in to do so.
- Automatic database purges for old uncompleted reviews using TTL field. Currently set to 1 month (time limit for a user to leave a review)
- User can see a list of unfinished reviews on the dashboard.


To-do:
- Security
- integrate with email app
- front end design

