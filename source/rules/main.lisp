(in-package :ralp)

(defun cli/options ()
  (list
   (clingon:make-option
    :flag
    :description "print help"
    :short-name #\h
    :key :help)
   (clingon:make-option
    :flag
    :description "import saved request data from zap into prolog"
    :short-name #\z
    :key :zap)

   (clingon:make-option
    :flag
    :description "Import url wordlists for a service."
    :short-name #\w
    :key :service-wordlist)

   (clingon:make-option
    :string
    :description "Input file"
    :short-name #\i
    :key :input)
   (clingon:make-option
    :string
    :description "output file"
    :short-name #\o
    :key :output)
   ;; BUG this needs to return a symbol for a prolog fact.
   (clingon:make-option
    :string
    :description "service argument, only use with wordlists mode!"
    :short-name #\s
    :key :service)
   (clingon:make-option
    :string
    :description "Fact type to generate from wordlists, Must be one of (service_url service_header service_dom)"
    :short-name #\f
    :key :service)))


(defun cli/handler (cmd)
  (let ((output-file (clingon:getopt* cmd :output))
        (input-file (clingon:getopt* cmd :input))
        (wordlist-mode (clingon:getopt* cmd :service-wordlist))
        (zap-mode (clingon:getopt* cmd :zap)))
    (when (clingon:getopt* cmd :help)
      (clingon:print-usage-and-exit cmd t))
    (when wordlist-mode
      (wordlist->facts (clingon:getopt* cmd :service) input-file output-file))
    (when zap-mode
      (requestlog->database input-file output-file))))





(defun cli/command ()
  (clingon:make-command
   :name "injest"
   :description "Injest Differnt forms of data to make facts and rules."
   :handler #'cli/handler
   :options (cli/options)))
;; TODO Add nuclei yml import

;; (clingon:make-option
;;  :flag
;;  :description "Import (SOME) Rules from Nuclei"
;;  :short-name #\n
;;  :key :nuclei-import)


(defun main ()
  (clingon:run (cli/command)))
