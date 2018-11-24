(in-package #:first-time-value)

(defmacro first-time-value (form)
  (let ((cache-var (gensym (string '#:cache))))
    `(let ((,cache-var (load-time-value (cons nil nil))))
       (if (car ,cache-var)
           (cdr ,cache-var)
           (prog1 (setf (cdr ,cache-var) ,form)
             (setf (car ,cache-var) t))))))

(defmacro first-time-values (form)
  `(values-list (first-time-value (multiple-value-list ,form))))
