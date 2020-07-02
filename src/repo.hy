;; py imports
(import aiosqlite)
;; hy imports
(import [secrets [db-name]])

;; TODO - consider making all of these take conn first so it can be partially applied?

(defn get-by-id-sql [table] f"SELECT * FROM {table} WHERE id=?")


(defn get-all-sql [table] f"SELECT * FROM {table}")


(defn/a get-sqlite-conn
  []
  (await (.connect aiosqlite db-name)))


(defn all-from 
  [table]
  (fn/a [conn] 
    (with/a [cursor (.execute conn (get-all-sql table))]
      (await (.fetchall cursor)))))


(defn one-by-id-from
  [table]
  (fn/a [id conn]
    (with/a [cursor (.execute conn (get-by-id-sql table) (, id))]
      (await (.fetchone cursor)))))


(setv find-person-by-id (one-by-id-from "person"))


(setv all-people (all-from "person"))


(defn/a find-person-by-name
  [name conn]
  (with/a [cursor (.execute conn "SELECT * FROM person WHERE username=?" (, name))]
    (await (.fetchone cursor))))


(setv todos-by-user-id-sql 
"SELECT 
   p.id as person_id,
   mt.name as media_type,
   t.title as title
FROM to_do t
INNER JOIN person p
  ON t.person_id = p.id
INNER JOIN media_type mt
  ON t.media_type_id = mt.id
WHERE id = ?")


(defn/a find-user-todos-by-userid
  [conn id]
  (with/a [cursor (.execute conn todos-by-user-id-sql (, id))]
    (await (.fetchone cursor))))


;; separate connection for transaction so no overlap https://stackoverflow.com/questions/53908615/reusing-aiosqlite-connection
(defn/a transaction
  [func]
  (with/a [conn (.connect aiosqlite db-name)]
    (func conn)))