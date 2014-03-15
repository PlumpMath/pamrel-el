;;; pamrel.el --- Post stuff to a pamrel pastebin

;; Copyright (C) 2014 pamrel-el contributors

;; Authors: Christopher Allan Webber <cwebber@dustycloud.org>
;;          Jessica Tallon <jessica@megworld.co.uk>

;; This file is NOT part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Code:

(defvar pamrel-post-url "http://pamrel.lu/")
(defvar pamrel-confirm-before-post t)

(defvar pamrel-mode-language-map
  '((emacs-lisp-mode . "scheme")
    (python-mode . "python")
    (hy-mode . "hylang")
    (conf-mode . "ini")
    (html-mode . "css+jinja")
    (web-mode . "css+jinja")))

(defun pamrel-detect-language-from-major-mode ()
  "Get the current language by checking the pamrel-mode-language-map"
  (cdr (assoc major-mode pamrel-mode-language-map)))

; If nil, none is used
(defvar pamrel-detect-language-method 'pamrel-detect-language-from-major-mode)

(defun pamrel-detect-language-meta-edition ()
  "Get or don't get the language, depending on if `pamrel-detect-language-method' is set"
  (if pamrel-detect-language-method
      (apply pamrel-detect-language-method nil)))

;; TODO: Add language determination based on buffer
;;       eg &language=python

(defun pamrel-post (content &optional language)
  "Post CONTENT to pamrel pastebin"
  (let ((url-request-method "POST")
        (url-request-extra-headers
         '(("Content-Type" . "application/x-www-form-urlencoded")))
        (url-request-data
         (concat "content="
                 (url-hexify-string content)
                 (if language
                     (concat "&language=" (url-hexify-string language))))))
    (url-retrieve pamrel-post-url (lambda (status) (switch-to-buffer (current-buffer))))))

(defun pamrel-post-current-buffer ()
  "Post the entire contents of current buffer to pamrel"
  (interactive)
  (if (or (not pamrel-confirm-before-post)
          (y-or-n-p "Really post the entire buffer to pamrel?"))
      (pamrel-post (buffer-string) (pamrel-detect-language-meta-edition))))

(defun pamrel-post-region (text-start text-end)
  "Post the contents of this region to pamrel"
  (interactive "r")
  (if (or (not pamrel-confirm-before-post)
          (y-or-n-p "Really post region to pamrel?"))
      (pamrel-post (buffer-substring text-start text-end)
                   (pamrel-detect-language-meta-edition))))
