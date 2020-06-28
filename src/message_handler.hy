
;; format of a mention (@Garrett) is <@User.id>

(defn handler 
  [message]
  (setv content (. message content))
  (cond [(.startswith content "hey bug-o-bot") "uh.. hey"]
        [(.startswith content "whoami bob") (print (. message author mention))]))

(defn )