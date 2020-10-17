;;; eping.el --- Ping websites to check internet connectivity

;; Copyright © 2020 Sean Hutchings

;; Author: Sean Hutchings <seanhut@yandex.com>

;; Maintainer: Sean Hutchings <seanhut@yandex.com>

;; Created: 2020-10-16

;; Keywords: comm, processes, terminals, unix

;; License: BSD Zero Clause License (SPDX: 0BSD)

;; License Contents:
;; Copyright © 2020 Sean Hutchings <seanhut@yandex.com>
;;
;; Permission to use, copy, modify, and/or distribute this software
;; for any purpose with or without fee is hereby granted.
;;
;; THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
;; WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
;; WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
;; AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR
;; CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
;; OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
;; NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
;; CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

;; Homepage: https://github.com/sean-hut/eping

;;; Change Log: For all notable changes see CHANGELOG.md

;;; Commentary:
;; Ping websites to check internet connectivity.
;;
;; Repository: https://github.com/sean-hut/eping

;;; Code:

(declare-function -snoc "dash")
(declare-function -cons* "dash")
(declare-function s-chomp "s")

(defvar eping-domain-options
  '("wikipedia.org" "startpage.com" "gnu.org")
  "List of domain that Eping will present as options.")

(defconst eping-number-pings-options '("5" "1" "10" "15" "20")
  "List of how many times to ping the domain.
Eping will present this as list to select from for users.")

(defun eping (domain number-pings)
  "Check internet connectivity with ping.

DOMAIN is the domain to ping.
NUMBER-PINGS is how many times to ping the domain."
  (interactive

   (-cons* (ido-completing-read
	    ;; PROMPT
	    "Domain to ping: "
	    ;; CHOICES
	    eping-domain-options
	    ;; PREDICATE
	    nil
	    ;; REQUIRE-MATCH
	    t)

	   (ido-completing-read
	    ;; PROMPT
	    "Number of pings: "
	    ;; CHOICES
	    eping-number-pings-options
	    ;; PREDICATE
	    nil
	    ;; REQUIRE-MATCH
	    t)

	   ()))

  (let ((command (-snoc (-snoc '("ping" "-c") number-pings) domain)))

    (if (equal current-prefix-arg nil)

	(make-process :name "eping"
		      :command command
		      :sentinel 'eping-sentinel-minibuffer-output)

      (make-process :name "e ping"
		    :command command
		    :sentinel 'eping-sentinel-espeak-output))))

(defun eping-sentinel-minibuffer-output (process event)
  "Output the process name and event with minibuffer.
PROCESS is the process the sentinel is watching.
EVENT is the processes change event."

  (message "%s %s" process (s-chomp event)))

(defun eping-sentinel-espeak-output (process event)
  "Output the process name and event with eSpeak.
PROCESS is the process the sentinel is watching.
EVENT is the processes change event."

  (let* ((espeak-text (format "%s %s" process event))

	 (command (-snoc '("espeak" ) espeak-text)))

    (make-process :name "eping-sentinel-espeak-output"
		  :command command)))

(provide 'eping)
;;; eping.el ends here
