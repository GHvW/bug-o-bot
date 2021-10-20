
(defn match-handler
    [(, predicate handler)])


(defn app
    [apphandlers message]
    (->> apphandlers
        (filter 
            (fn [apphandler] 
                (let [predicate (. apphandler [0])]
                    (predicate (. message))))
        (next)
        ))