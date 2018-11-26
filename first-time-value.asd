(asdf:defsystem #:first-time-value

  :author "Jean-Philippe Paradis <hexstream@hexstreamsoft.com>"

  ;; See the UNLICENSE file for details.
  :license "Public Domain"

  :description "Returns the result of evaluating a form in the current lexical and dynamic context the first time it's encountered, and the cached result of that computation on subsequent evaluations."

  :depends-on ()

  :version "1.0.1"
  :serial cl:t
  :components ((:file "package")
	       (:file "main"))

  :in-order-to ((asdf:test-op (asdf:test-op #:first-time-value_tests))))
