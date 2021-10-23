(require [hy.contrib.walk [let]])
;; py imports
(import 
  [asyncio :as aio]
  discord 
  aiosqlite
  [functools [partial]])
;; hy imports
(import 
  [bob.secrets [token db-name]]
  [bob.message-handler [handler time-to-bug? make-bug-user-message]]
  [bob.repo [get-sqlite-conn find-user-todos-by-userid]]
  [bob.app [app starts-with]])


(defn/a main []

  (setv client (.Client discord))

  (with/a [conn (.connect aiosqlite db-name)]
    ; TODO - partial apply handler here with conn
    (setv app 
      [(, (partial starts-with "hey bug-o-bot") (partial text "uh.. hey"))
       (, (partial starts-with "whoami bob") (fn [message] (. message author mention)))
       (, (partial starts-with "do you have") ())
       (, (partial time-to-bug? {}) 
          (compose 
            make-bug-user-message 
            (partial find-user-todos-by-userid conn)
            (fn [message] (. message author id))))])

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
          (let [reply (await (handler conn message))] ; TODO - compose here for reply, (repo  get)(stuff format)
            (if-not (= reply None)
              (await (-> message
                        (. channel)
                        (.send reply))))))))


    (await (.start client token))))


; (.run aio (main))

; since I forget - run with hy -m bob.main
(defmain [&rest args]
  (.run aio (main)))