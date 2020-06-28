# bug-o-bot

### Database Schema
###### person
- id (pk)
- username

###### media_type (lookup)
- id 
- name (movie, book, band, song, whatever)

###### to_do
- id
- title
- person_id (fk person.id)
- media_type_id (fk media_type)