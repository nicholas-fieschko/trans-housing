Reviews
=======

Implemented:
- Each review belongs to the user receiving the review and has a authorID corresponding to the ObjectId of the user who is supposed to leave the review. Only this user can leave the review and must be signed in to do so. Currently, the user must have the link to leave the review.
- Automatic database purges for old uncompleted reviews using TTL field. Currently set to 1 month (which is the time limit for a user to leave a review)


To-do:
- User can see unfinished reviews on the dashboard and submit them there.
- Security
- integrate with email app
- front end design
