;;;; rpi-gpio.asd

(asdf:defsystem #:rpi-gpio
  :description "A very simple interface to the Raspberry Pi GPIO ports, using sysfs."
  :author "Sergi Reyner <sergi.reyner@gmail.com>"
  :license "MIT"
  :serial t
  :components ((:file "package")
               (:file "macros")
               (:file "rpi-gpio")))
