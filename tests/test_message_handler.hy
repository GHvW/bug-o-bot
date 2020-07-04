(import pytest)

(import [bob.message-handler [last-word]])

(defn test-last-word []
  (assert (= (last-word "hi bye ok") "ok")))