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

(defun pamrel-post (content)
  "Post code to "
  (let ((url-request-method "POST")
        (url-request-extra-headers
         '(("Content-Type" . "application/x-www-form-urlencoded")))
        (url-request-data
         (concat "content="
                  (url-hexify-string content))))
    (url-retrieve pamrel-post-url (lambda (status) (switch-to-buffer (current-buffer))))))

(defun pamrel-post-current-buffer ()
  (interactive)
  (pamrel-post (buffer-string)))


