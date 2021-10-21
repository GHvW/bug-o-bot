
(defn starts-with
    [text content]
    (.startswith content text))

(defn text
    [str content]
    str)

(defn app
    [apphandlers message]
    (->> apphandlers
        (filter 
            (fn [apphandler] 
                (let [predicate (. apphandler [0])]
                    (predicate (. message))))
        (next)
        ))