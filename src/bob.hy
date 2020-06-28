(import discord)

(import [secrets [token]])

(setv client (.Client discord))

#@(client.event
  ;; hy should transform on-ready to on_ready()
  (defn/a on-ready [] 
    (print f"We're in as {client.user}")))

#@(client.event
  ;; hy should transform on-message to on_message(message)
  (defn/a on-message 
    [message]
    (if-not (= (. message author) (. client user))
      (if (-> message
              (. content)
              (.startswith "hey bug-o-bot"))
        (await (-> message
                   (. channel)
                   (.send "uh.. hey")))))))

(.run client token)
