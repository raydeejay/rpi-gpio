;;;; rpi-gpio.lisp
;;; Manipulating the GPIO pins from Common Lisp via the SYSFS interface

(in-package #:rpi-gpio)

(defvar *sysfs-base-path* "/sys/class/gpio")
(defun gpio-path (fn &optional pin)
  "Pass keywords. FORMAT can probably get rid of the IF."
  (format NIL "~A/~@[gpio~D/~]~A" *sysfs-base-path* pin (string-downcase fn)))

(defun mklist (x) (if (atom x) (list x) x))

(defun gpio-export (pins)
  "Enables a particular pin or set of pins, by telling sysfs to create
a directory and files to access it. Waits until the symlink's group changes to non-root."
  (mapc (lambda (pin)
          (with-open-file
              (f (gpio-path :export) :direction :output :if-exists :append)
            (declare (optimize (speed 0)))
            (format f "~A" pin)
            (force-output f)
            (loop :for f := (sb-posix:stat (gpio-path "" pin))
               :until (/= (sb-posix:stat-gid f) 0))))
        (mklist pins)))

(defun gpio-unexport (pins)
  "Disables a particular pin or set of pins, by telling sysfs to
create a directory and files to access it."
  (mapc (lambda (pin)
          (with-open-file
              (f (gpio-path :unexport) :direction :output :if-exists :append)
            (format f "~A" pin)))
        (mklist pins)))

(defun gpio-direction (pins dir)
  "Configures a pin or set of pins for input or output. DIR can be either :IN
or :OUT."
  (mapc (lambda (pin)
          (with-open-file
              (f (gpio-path :direction pin) :direction :output :if-exists :append)
            (format f "~A" (string-downcase dir))))
        (mklist pins)))

(defun gpio-write (pins value)
  "Writes a value to a pin or set or pins. The value should be either 0 or 1."
  (mapc (lambda (pin)
          (with-open-file
              (f (gpio-path :value pin) :direction :output :if-exists :append)
            (format f "~A" value)))
        (mklist pins)))

(defun gpio-read (pins)
  "Reads from a pin or set or pins."
  (flet ((fn (pin)
           (with-open-file
               (f (gpio-path :value pin) :direction :input)
             (read f))))
    (if (atom pins)
        (fn pins)
        (mapcar #'fn pins))))
