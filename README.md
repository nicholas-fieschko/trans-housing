Reviews
=======

Implemented:
- Each review belongs to the user receiving the review and has a authorID corresponding to the ObjectId of the user who is supposed to leave the review. Only this user can leave the review and must be signed in to do so.
- Automatic database purges for old uncompleted reviews using TTL field. Currently set to 1 month (time limit for a user to leave a review)
- Users can submit help requests to other users
- History for User model - review automatically generated after user1 helps user2
- User can see a list of unfinished reviews as well as history on the dashboard.
- Average rating field added
- Validations for text and ratings added
- only non-providers can submit help requests to providers
- integration with mailer - user gets an email with link to leave review


To-do:
- friendly error messages
- both providers and non-providers can complete a request
- Security
- front end design
- write tests
- refactor code and views
- interactive map to allow user change their locations
- how to preserver user defined locaitons versus auto-detection

