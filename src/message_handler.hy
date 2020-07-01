(require [hy.contrib.walk [let]])
;; py imports
(import 
  json
  [datetime [datetime]]
  [random [randrange]])
;; hy imports
(import
  [repo [find-person-by-name find-user-todos-by-id]])

;; ************ FOR TESTING *******************
(setv testdict
  {"language-file-extensions" {"hy" ".hy"
                               "python" ".py"
                               "json" ".json"}
   "list-o-things" [1 2 3 4 5]
   "name" "Garrett van Wageningen"})

(defn json-md [dict] f"```json\n{(.dumps json dict :indent 2)}\n```")
;; *********************************************

;; format of a mention (@Garrett) is <@User.id>

;; TODO -
;; the first time a person sends a message each day, bug that person
;; keep a dictionary with people that have been bugged and the last bug
;; if is in the dictionary and hasn't been bugged in a day, bug and update dictionary
;; extra bugs for stoping and starting are of no consequence, they should have done their todo's :)
;; could maybe memo the db call for the user, if it's in the dictionary, no need to go to the DB to look for the person

;; user cache is something like Dict[usier-id, datetime.datetime]
(setv user-cache {})

(defn/a handler 
  [message]
  (setv content (. message content))
  (cond [(.startswith content "hey bug-o-bot") "uh.. hey"]
        [(.startswith content "whoami bob") (. message author mention)]
        [(.startswith content "json formatting hack") (json-md testdict)]
        [(.startswith content "do you have") f"I have {(await (mention-from-name (last-word content) conn))} in the database"]
        [(>= (days-since-last-update cache (. message user id)) 1) (bug-user-message (. message user id))]))


(defn update-user-cache
  [cache id]
  (do 
    (assoc cache id (.now datetime) ;; assoc returns None instead of the dictionary
    cahce))) 


(defn bug-user-message
  [conn id]
  (let [todos (await (find-user-todos-by-id conn id))]
    (let [row (->> todos
                   (len)
                   (randrange 0)
                   (get todos))]
      f"{(format-mention id)}, have you {(media-type-verb (. row [1]))} {(. row [2])} yet?")))


(defn bug-user-message
  [id media-type media-item]
  f"{(format-mention id)}, have you {(media-type-verb media-type)} {media-item} yet?")


(defn media-type-verb
  [media-type]
  (cond [(= "movie") "watched"]
        [(= "book") "read"]))

(defn/a mention-from-name
  [name conn]
  (-> (await (find-person-by-name name conn))
      (. [0]) ;; id is in the 0 position
      (format-mention)))


(defn last-word
  [content]
  (-> content
      (.split)
      (. [-1])))


(defn format-mention
  [user-id]
  f"<@{user-id}>")

;; Mention's take the format <@idnumber>
;; parsep-mention removes the <@ and > leaving just idnumber
(defn parse-mention-id
  [mention]
  (cut mention 2 -1)


;; usually you'll want to have first-date be the earlier date and second-date be the later date
(defn days-between
  [first-date second-date]
  (. (- second-date first-date) days))


(defn days-since-last-update
  [cache id]
  (-> cache
      (.get id)
      (days-between (.now datetime))))