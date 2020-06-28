# bug-o-bot

I'm still figuring all of this out

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