(require [hy.contrib.walk [let]])
;; py imports
(import discord)
;; hy imports
(import 
  [secrets [token]]
  [message-handler [handler]]
  [repo [get-sqlite-conn]])


(setv client (.Client discord))


#@(client.event
  ;; hy should transform on-ready to on_ready()
  (defn/a on-ready [] 
    (print f"We're in as {client.user}")
    (print f"Current Users: {(. client users)}")))


#@(client.event
  ;; hy should transform on-message to on_message(message)
  (defn/a on-message 
    [message]
    (if-not (= (. message author) (. client user))
      (let [reply (handler message)]
        (if-not (= reply None)
          (await (-> message
                     (. channel)
                     (.send reply))))))))


(.run client token)


