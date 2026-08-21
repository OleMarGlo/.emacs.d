;;; init.el --- Load literate configuration -*- lexical-binding: t; -*-

(require 'org)

(org-babel-load-file
 (expand-file-name "config.org" user-emacs-directory))
