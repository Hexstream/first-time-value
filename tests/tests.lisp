(cl:defpackage #:first-time-value_tests
  (:use #:cl #:parachute)
  (:import-from #:first-time-value
                #:first-time-value
                #:first-time-values))

(cl:in-package #:first-time-value_tests)

(defmacro are (comp expected form &optional description &rest format-args)
  `(is ,comp ,expected (multiple-value-list ,form) ,description ,@format-args))

(define-test "main"
  :compile-at :execute
  (let* ((eval-count 0)
         (nested (lambda ()
                   (lambda ()
                     (lambda ()
                       (first-time-value (prog1 8 (incf eval-count))))))))
    (are equal '(8 8 1)
         (values (funcall (funcall (funcall nested)))
                 (funcall (funcall (funcall nested)))
                 eval-count)))
  (let* ((eval-count 0)
         (nested (lambda ()
                   (lambda ()
                     (lambda ()
                       (first-time-values (multiple-value-prog1 (values 8 16 32) (incf eval-count))))))))
    (are equal '(8 16 32 8 16 32 1)
         (multiple-value-call #'values
           (funcall (funcall (funcall nested)))
           (funcall (funcall (funcall nested)))
           eval-count)))
  (let* ((eval-count 0)
         (nested (lambda ()
                   (lambda ()
                     (lambda ()
                       (handler-case (first-time-value (prog1 8
                                                         (incf eval-count)
                                                         (when (<= eval-count 2)
                                                           (error "Uh oh."))))
                         (error () 'error)))))))
    (are equal '(error error 8 8 3)
         (flet ((call-it ()
                  (funcall (funcall (funcall nested)))))
           (values (call-it) (call-it) (call-it) (call-it) eval-count)))))

#+nil
(defmacro not-quite-correct-jumptable (index &body cases)
  (let ((jumptable-var (gensym (string '#:jumptable))))
    `(let ((,jumptable-var (first-time-value
                            (vector ,@(mapcar (lambda (form)
                                                `(lambda ()
                                                   ,form))
                                              cases)))))
       (funcall (svref ,jumptable-var ,index)))))
