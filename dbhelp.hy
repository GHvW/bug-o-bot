;; py imports
(import sqlite3) ;; using this from cmd, so not worried about async etc
;; hy imports
(import [src.secrets [db-name]])

(setv create-person-sql "CREATE TABLE person(id text PRIMARY KEY, username text);")
(setv create-media-type-sql "CREATE TABLE media_type(id INTEGER PRIMARY KEY AUTOINCREMENT, name text NOT NULL);")
(setv create-to-do-sql "CREATE TABLE to_do(
                           id INTEGER PRIMARY KEY AUTOINCREMENT, 
                           title TEXT NOT NULL,
                           person_id INTEGER NOT NULL,
                           media_type_id INTEGER NOT NULL,
                           FOREIGN KEY (person_id) REFERENCES person (id),
                           FOREIGN KEY (media_type_id) REFERENCES media_type (id));")


(defn create-table [sql]
  (try
    (setv conn (.connect sqlite3 db-name))
    (.execute conn sql)
    (.commit conn)
    (finally
      (.close conn))))


(defn create-person [] (create-table create-person-sql))


(defn create-media-type [] (create-table create-media-type-sql))


(defn create-to-do [] (create-table create-to-do-sql))

(defn add-person 
  [id username]
  (try
    (setv conn (.connect sqlite3 db-name))
    (.execute conn "INSERT INTO person (id, username) VALUES (?, ?)" (, id username))
    (.commit conn)
    (finally
      (.close conn))))
