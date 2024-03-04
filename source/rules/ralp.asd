(asdf:defsystem :ralp
  :version      "0.1.0"
  :description  "Hacking related expert system framework. transpile data to prolog facts"
  :author       " <unseen@hunter-02>"
  :serial       t
  :license      "GNU GPL, version 3"
  :components  ((:file "ralp")
                (:file "wordlist")
                (:file "http")
                (:file "zap")
                (:file "main"))
  :depends-on   (#:quri #:str #:jsown #:alexandria #:clingon)
  :entry-point "ralp::main")
