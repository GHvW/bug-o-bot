# bug-o-bot

b-o-b bugs your friends about movies, books, and other media items (or anything really) that you want to bug them about. B-o-b will bug your friends once a day, or the first time they send a message after a full day since their last message. B-o-b will choose one to-do at random to bug your friends about until he has nothing left to bug about. Use `dbhelp.hy` to manage the database in a repl.

### Database Schema
###### person
- id (pk)
- username

###### media_type (lookup)
- id 
- name (ie movie, book, band, song, etc)

###### to_do
- id
- title
- person_id (fk person.id)
- media_type_id (fk media_type.id)

###### Future maybe
- break out into separate movie, book, etc. tables with many-to-many join tables
