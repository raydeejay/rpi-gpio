;;;; macros.lisp

(in-package #:rpi-gpio)

(defmacro with-gpio-pins (pins &body body)
  `(unwind-protect
        (progn ,@(mapcar (lambda (pin-data)
                           `(gpio::gpio-export ,(second pin-data)))
                         pins)
               ,@(mapcar (lambda (pin-data)
                           `(gpio::gpio-direction ,(second pin-data)
                                                  ,(first pin-data)))
                         pins)
               ,@body)
     ,@(mapcar (lambda (pin-data)
                 `(gpio::gpio-unexport ,(second pin-data)))
               pins)))
