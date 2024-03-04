(in-package :ralp)

(defun url->method-fact (url method status)
  "Generate a fact about the method to get this url"
  (cons "response" (list url method status)))

(defun url->server-fact (url server)
  "generact a fact about the server reported from url"
  (cons "server" (list url server)))

(defun url->tech-fact (url tech)
  "generate a fact about a url reported to have tech"
  (cons "service" (list url tech)))

(defun parse-url (jdata)
  (let ((url (jsown:val jdata "url")))
    (multiple-value-bind (scheme host port path)
        (quri:parse-uri url)
      ;; Create a property list from the extracted components
      (let ((plist (list :scheme scheme
                         :host host
                         :port port
                         :path path)))
        ;; Print the property list
        plist))))


(defun line->header-fact (line) "get header by name and return fact"
  (let* ((jdata (jsown:parse line))
         (header (walk-json jdata '("headers" "server"))))
    (compile-facts (cons "header" (list "host" header)) (cons "service" (list "http" header)))))
