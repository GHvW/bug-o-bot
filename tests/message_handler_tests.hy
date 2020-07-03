(import pytest)

(import [message-handler [last-word]])

(defn last-word-test []
  (assert (= (last-word ["hi" "bye" "ok"]) "ok"))