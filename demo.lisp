;;;; test.lisp

(defpackage #:rpi-gpio-demo
  (:use #:cl #:gpio))

(in-package #:rpi-gpio-demo)

(defconstant low 0)
(defconstant high 1)

(defun pin-test ()
  (let ((led 24) (button 18))
    (with-gpio-pins ((:out led) (:in button))
      (gpio-write led high)
      (loop :while (plusp (gpio-read button)) :doing (sleep 0.1))
      (gpio-write led low))))
