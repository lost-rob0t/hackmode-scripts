(in-package :ralp)

(defun response->many-facts (jdata)
  "Get tech from output of response"
  (let (
        (server (jsown:val-safe (jsown:val jdata "respHeaders") "Server"))
        (headers (jsown:do-json-keys (key val) jdata
                   (list key val)))
        (time (jsown:val jdata "time")))
    (alexandria:flatten (compile-facts
                         (cons "http" (list (getf (parse-url jdata) :host)))
                         (cons "service" (list server))
                         (cons "headers" (apply 'list server headers))
                         (time->fact server time)
                         (cons "url" (list url server))))))


(defun request->many-facts (jdata)
  "get tech from http output from zap"
  (let* (
         (method (jsown:val jdata "method"))
         (url (jsown:val jdata "url"))
         (time (jsown:val jdata "time")))


    (alexandria:flatten (list
                         (compile-facts
                          (cons "requestTime" (list url time method))
                          (cons "source" (list url "zap"))
                          (url->method-fact url method 200))))))


(defun requestlog->database (filepath outputfile)
  "Turn `filepath` that is a request log from zap into prolog rule database"
  (let* ((lines (uiop:read-file-lines filepath))
         (facts (alexandria:flatten (mapcar (lambda (line)
                                              (let ((jdata (jsown:parse line)))
                                                (alexandria:flatten
                                                 (compile-facts
                                                  (request->many-facts jdata)
                                                  (response->many-facts jdata)))))

                                            lines))))
    (output-file facts outputfile)))



(defun zap-stdin (output)
  "Read from /dev/stdin for json requests from zap. Write the resulting ")
