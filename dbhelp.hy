;; py import
(import 
  asyncio
  aiosqlite)
;; hy import
(import [src.secrets [db-name]])

(defn/a make-test []
  (with/a [db (.connect aiosqlite db-name)]
    (do
      (await (.execute db "CREATE TABLE test(name text, username text)"))
      (await (.execute db "INSERT INTO test VALUES ('Garrett', 'Garrett#0334')"))
      (await (.commit db)))))

(defn drop-sql [name] f"DROP TABLE IF EXISTS {name}")

(defn/a delete-table
  [name]
  (with/a [db (.connect aiosqlite db-name)]
    (do 
      (await (.execute db (drop-sql name)))
      (await (.commit db)))))

(defn/a test-all
  []
  (with/a [db (.connect aiosqlite db-name)]
    (with/a [cursor (.execute db "SELECT * FROM test")] 
      (print (await (.fetchall cursor))))))

(defn/a test-one
  [name]
  (with/a [db (.connect aiosqlite db-name)]
    (with/a [cursor (.execute db "SELECT * FROM test WHERE name=?" (, name))] ;; (, x y z) is hy's tuple type
      (print (await (.fetchall cursor))))))

;; for testing asyncio, requires (.run asyncio (hello-world))
(defn/a hello-world []
  (do
    (print "hello")
    (await (.sleep asyncio 1))
    (print "world")))

;; to run any of these, import asyncio and (.run asyncio (fn [ARGS]))

;; TODO - what's the difference between asyncio.get_event_loop() with the corresponding run to completion and asyncio.run(coro)?