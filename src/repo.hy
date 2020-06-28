;; py imports
(import aiosqlite)

(defn/a get-sqlite-conn
  [db-name]
  (await (.connect aiosqlite db-name)))

