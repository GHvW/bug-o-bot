;; py imports
(import aiosqlite)
;; hy imports
(import [secrets [db-name]])

(defn get-by-id-sql [table] f"SELECT * FROM {table} WHERE id=?")
(defn get-all-sql [table] f"SELECT * FROM {table}")

(defn/a get-sqlite-conn
  [db-name]
  (await (.connect aiosqlite db-name)))

(defn/a all-from 
  [table]
  (fn [conn] 
    (with/a [cursor (.execute conn (get-all-sql table))]
      (await (.fetchall cursor)))))

(defn/a one-by-id-from
  [table]
  (fn [conn id]
    (with/a [cursor (.execute conn (get-by-id-sql table) (, id))]
      (await (.fetchone cursor)))))

;; separate connection for transaction so no overlap https://stackoverflow.com/questions/53908615/reusing-aiosqlite-connection
(defn/a transaction
  [func]
  (with/a [conn (.connect aiosqlite db-name)]
    (func conn)))