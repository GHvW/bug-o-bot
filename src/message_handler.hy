

(defn handler 
  [message]
  (setv content (. message content))
  (cond [(.startswith content "hey bug-o-bot") "uh.. hey"]
        [(.startswith content "whoami bob") (. message author mention)]))