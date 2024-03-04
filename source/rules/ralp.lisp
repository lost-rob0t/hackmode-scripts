(uiop:define-package   :ralp
  (:use       :cl)
  (:documentation "doc"))
(in-package :ralp)
(declaim (optimize (speed 3) (safety 0)))

(defvar +server-headers+ (list "X-Served-By" "Server" ""))
(defvar +waf-codes+ (list 403 423))

(defun walk-json (jdata path)
  "Get keys recursivly in path."
  (cond ((null path) jdata)
        ((not (listp jdata)) nil)
        (t (walk-json (jsown:val jdata (car path)) (cdr path)))))


(defun output-file (strings output-file)
  "Write strings to file"
  (with-open-file (out output-file
                       :direction :output
                       :if-exists :supersede)
    (format out "~{~a~%~}" strings)))

(defun line->json (line)
  "parse a line into json"
  (jsown:parse line))

(defun compile-facts (&rest facts)
  "Compile  fact(s) from a nested cons pairs"
  (loop for fact in facts
        for fact-name = (first fact)
        for relations = (rest fact)
        collect (str:replace-all ", )" ")" (format nil "~a(~{\"~a\", ~}) " fact-name relations))))

(defun make-rule (rule-name &rest args)
  (str:replace-all ", )" ")" (format nil "~a(~{\"~a\", ~}) " rule-name (apply 'list args))))

;; (defmacro compile-rule ((rule-name rule-args) &rest facts)
;;   `(let ((rule-string (apply 'make-rule ,rule-name ,rule-args)))
;;      (format nil "~a :- ~{~a, ~}" rule-string (loop for fact in ,facts collect (compile-facts fact)))))


(defun line->header-fact (line) "get header by name and return fact"
  (let* ((jdata (jsown:parse line))
         (header (walk-json jdata '("headers" "server"))))
    (compile-facts (cons "header" (list "host" header)) (cons "service" (list "http" header)))))

(defun host->port-fact (host port)
  "A fact about a port running on a host"
  (cons "port" (list host port)))

;; IDEA DSL
;; (defmacro define-fact ((name) &rest args)
;;   `(defun ,name (,args)
;;      (cons (symbol-name ,name) (apply 'list ,args))))





;; TODO write macro define-fact-container
;; TODO rule macro
(defun time->fact (thing time)
  (cons "time" (list time thing)))









(defun main ()
  (requestlog->database "/home/unseen/Documents/hackmode/Walmart/request.json" "requests.prolog"))
