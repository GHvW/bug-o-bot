(import pytest)

(import [message-handler [last-word]])

(defn test-last-word []
  (assert (= (last-word ["hi" "bye" "ok"]) "ok"))