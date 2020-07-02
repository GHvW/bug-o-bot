(require [hy.contrib.walk [let]])
;; py imports
(import 
  [asyncio :as aio]
  discord 
  aiosqlite)
;; hy imports
(import 
  [secrets [token db-name]]
  [message-handler [handler]]
  [repo [get-sqlite-conn]])


(defn/a main []

  (setv client (.Client discord))

  (with/a [conn (.connect aiosqlite db-name)]

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
          (let [reply (await (handler conn message))]
            (if-not (= reply None)
              (await (-> message
                        (. channel)
                        (.send reply))))))))


    (await (.start client token))))


(.run aio (main))