(in-package #:first-time-value)

(defmacro first-time-value (form)
  (let ((cache-var (gensym (string '#:cache)))
        (gensym (gensym (string '#:gensym))))
    `(progn
       (load-time-value (setf (symbol-value ',gensym) (cons nil nil)))
       (let ((,cache-var (symbol-value ',gensym)))
         (declare (type cons ,cache-var))
         (if (car ,cache-var)
             (cdr ,cache-var)
             (prog1 (setf (cdr ,cache-var) ,form)
               (setf (car ,cache-var) t)))))))

(defmacro first-time-values (form)
  `(values-list (first-time-value (multiple-value-list ,form))))
