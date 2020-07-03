;; py imports
(import sqlite3) ;; using this from cmd, so not worried about async etc
;; hy imports
(import [src.secrets [db-name]])

(setv create-person-sql "CREATE TABLE person(id text PRIMARY KEY, username text);")
(setv create-media-type-sql "CREATE TABLE media_type(id INTEGER PRIMARY KEY AUTOINCREMENT, name text NOT NULL);")
(setv create-todo-sql "CREATE TABLE to_do(
                           id INTEGER PRIMARY KEY,
                           title TEXT NOT NULL,
                           person_id INTEGER NOT NULL,
                           media_type_id INTEGER NOT NULL,
                           FOREIGN KEY (person_id) REFERENCES person (id),
                           FOREIGN KEY (media_type_id) REFERENCES media_type (id));") 
;; AUTOINCREMENT just prevents the re-use of keys from deleted rows. shouldn't be necessary?
(setv drop-todo-sql "DROP TABLE IF EXISTS to_do;")


(defn table-op [sql]
  (try
    (setv conn (.connect sqlite3 db-name))
    (.execute conn sql)
    (.commit conn)
    (finally
      (.close conn))))


(defn create-person [] (table-op create-person-sql))


(defn create-media-type [] (table-op create-media-type-sql))


(defn create-todo [] (table-op create-todo-sql))

(defn drop-todo [] (table-op drop-todo-sql))


; TODO ADD DROP TABLE HELPERS
; (defn drop-person [] (table-op drop-person-sql))
; (defn drop-media-type [] (talbe-op drop-media-type-sql))

(defn add-person 
  [id username]
  (try
    (setv conn (.connect sqlite3 db-name))
    (.execute conn "INSERT INTO person (id, username) VALUES (?, ?)" (, id username))
    (.commit conn)
    (finally
      (.close conn))))


(defn add-media-type
  [name]
  (try
    (setv conn (.connect sqlite3 db-name))
    (.execute conn "INSERT INTO media_type (name) VALUES (?)" (, name))
    (.commit conn)
    (finally
      (.close conn))))


(setv insert-todo-sql
"INSERT INTO to_do (title, media_type_id, person_id)
SELECT 
  ? as title,
  mt.id as media_type_id,
  p.id as person_id
FROM person p, media_type mt
WHERE p.username = ? AND mt.name = ?")


(defn add-todo
  [username media-type media-item]
  (try
    (setv conn (.connect sqlite3 db-name))
    (.execute conn insert-todo-sql (, media-item username media-type))
    (.commit conn)
    (finally
      (.close conn))))


(defn all-todo
  []
  (try
    (setv conn (.connect sqlite3 db-name))
    (setv cursor (.execute conn "SELECT * FROM to_do"))
    (.fetchall cursor)
    (finally
      (.close cursor)
      (.close conn))))


(defn all-media
  []
  (try
    (setv conn (.connect sqlite3 db-name))
    (setv cursor (.execute conn "SELECT * FROM media_type"))
    (.fetchall cursor)
    (finally
      (.close cursor)
      (.close conn))))


(defn all-person
  []
  (try
    (setv conn (.connect sqlite3 db-name))
    (setv cursor (.execute conn "SELECT * FROM person"))
    (.fetchall cursor)
    (finally
      (.close cursor)
      (.close conn))))