# bug-o-bot

### Database Schema

###### Person
- id (pk)
- username

###### MediaType (lookup)
- movie

###### Movie
- id (pk)
- name

###### PersonMovie
- person_id (fk Person)
- movie_id (fk Movie)