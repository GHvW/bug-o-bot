;; py imports
(import json)


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

(defn handler 
  [message]
  (setv content (. message content))
  (cond [(.startswith content "hey bug-o-bot") "uh.. hey"]
        [(.startswith content "whoami bob") (print (. message author mention))]
        [(.startswith content "json formatting hack") (json-md testdict)]))
