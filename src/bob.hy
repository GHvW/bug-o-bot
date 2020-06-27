(import 
    [discord]
    [secrets [*]])

(setv discord-client (.Client discord))

#@(client.event
    ;; hy should transform on-ready to on_ready()
    (defn/a on-ready [] 
        (print f"We're in as {client.user}")))

#@(client.event
    ;; hy should transform on-message to on_message(message)
    (defn/a on-message 
        [message]
        (if-not (== (.author message) (.user client))
            (if (-> message
                    (.content)
                    (.startswith "hey bug-o-bot"))
                (await (-> message
                           (.channel)
                           (.send "uh.. hey")))))))

(.run discord-client token)
