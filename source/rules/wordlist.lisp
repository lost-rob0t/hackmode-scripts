(in-package :ralp)

;; TODO Compiler complains that this isnt a string no shit its ment to be a symbol
(defmacro service->fact ((fact-name service) &rest fragments)
  `(cons (quote fact-name) (apply 'list (quote service) ,@fragments)))


(defun url-path->fact (service fragment)
  "Genrate a fact from a path fragment"
  (cons 'service_url (list service fragment)))





;; (defun wordlist->facts (service filepath output)
;;   "Convert a wordlist reading from FILEPATH of url words for SERVICE"
;;   (let ((lines (uiop:read-file-lines filepath)))
;;     (output-file  (alexandria:flatten
;;                    (loop for word in lines collect (compile-facts (url-path->fact service word)))) output)))


(defun wordlist->facts (fact-type service filepath output)
  (let ((lines (uiop:read-file-lines filepath)))
    (output-file (alexandria:flatten
                  (loop for word in lines collect
                                          (compile-facts
                                           (service->fact (fact-type service)
                                                          word)))))))
