;; py imports
(import json)
;; hy imports
(import
  [repo [find-person-by-name]])

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

(defn/a handler 
  [message conn]
  (setv content (. message content))
  (cond [(.startswith content "hey bug-o-bot") "uh.. hey"]
        [(.startswith content "whoami bob") (. message author mention)]
        [(.startswith content "json formatting hack") (json-md testdict)]
        [(.startswith content "do you have") f"I have <@{(. (await 
                                                  (find-person-by-name 
                                                    (name-in-last-pos content) 
                                                    conn)) 
                                                [0])}> in the database"])) ;; TODO - do something about this later

(defn name-in-last-pos
  [content]
  (-> content
      (.split " ")
      (.pop)))