;; py imports
(import aiosqlite)
;; hy imports
(import [secrets [db-name]])


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


;; separate connection for transaction so no overlap https://stackoverflow.com/questions/53908615/reusing-aiosqlite-connection
(defn/a transaction
  [func]
  (with/a [conn (.connect aiosqlite db-name)]
    (func conn)))