;; use melpa for pacakages
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))


;; select a theme to use
(defvar *emacs-selected-theme* 'leuven)

;;; disable UI elements
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(display-time-mode 1)
;; it doesn't make sense to have battery mode and fancy battery mode
(display-battery-mode -1)
(fancy-battery-mode t)


;;; use ido everywhere
(ido-mode 1)
;; this is really only annoying when you're creating a new file with find-file or visit-file, as it really wants to complete them
(setq ido-everywhere t)
;; display stacked results, instead of side-by-side cycle
;; on the fence whether I like this
;; (ido-vertical-mode t)

;; make a shortcut to grab notes:
(global-set-key (kbd "s-c") 'org-capture)

(setf (symbol-function 'yes-or-no-p)
      (symbol-function 'y-or-n-p))

;; utf-8 is the future, embrace it now
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq org-export-coding-system 'utf-8)
(set-charset-priority 'unicode)
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))


;; allow to use C-y to paste even in term-char-mode
(add-hook 'term-mode-hook
          (lambda()
            (define-key term-raw-map (kbd "C-y")
              (lambda ()
                (interactive)
                (term-line-mode)
                (yank)
                (term-char-mode)))))


;;; terminals at a touch  F8 is local ansiterm, F9 Remote, F10 pry on localhost

;; Use this to start a local pry at a button press
(defun start-pry ()
  (interactive)
  (ansi-term "pry" "pry"))

;; Use this for remote so I can specify command line arguments
;; this function is five kinds of ugly...
(defun remote-term (new-buffer-name cmd &rest switches)
  (setq term-ansi-buffer-name (concat "*" new-buffer-name "*"))
  (setq term-ansi-buffer-name (generate-new-buffer-name
			       term-ansi-buffer-name))
  (setq term-ansi-buffer-name
	(apply 'make-term term-ansi-buffer-name
	       cmd nil switches))
  (set-buffer term-ansi-buffer-name)
  (term-mode)
  (term-char-mode)
  (term-set-escape-char ?\C-x)
  (switch-to-buffer term-ansi-buffer-name))

;; remote shell prompts for hostname, connects and sets buffer to "
(defun remote-connect (hostname)
  (interactive "sConnect: ")
  (remote-term (format "%s ssh" hostname)
               "/usr/bin/ssh"
               hostname))

;; new shells named "localhost <N>"
(defun open-localhost ()
  (interactive)
  (ansi-term "bash" "localhost"))


;; Command Hot Keys

; define F8 as new shell, F9 as new remote shell, F10 run pry
(global-set-key (kbd "C-x g") 'magit-status)

(global-set-key (kbd "<f8>") 'open-localhost)
(global-set-key (kbd "<f9>") 'remote-connect)

(global-set-key (kbd "<f10>") 'start-pry)




;; make html and html.erb files glimmer
(add-to-list 'auto-mode-alist
             '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist
             '("\\.html\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist
	     '("\\.rb\\'" . enh-ruby-mode))

;; make gem use tar when opening
(add-to-list 'auto-mode-alist
	     '("\\.gem\\'" . tar-mode))


;; clean files automatically
(add-hook 'before-save-hook 'delete-trailing-whitespace)


;; make C-x p work like reverse C-x o
(defun back-window (count &optional all-frames)
  (interactive "p")
  (other-window (- count)))

(global-set-key (kbd "C-x p") 'back-window)

(put 'narrow-to-region 'disabled nil)


;; customize ansible vault to find the password
(defun ansible-vault-mode-maybe ()
  (when (ansible-vault--is-vault-file)
    (ansible-vault-mode 1)))

(add-hook 'yaml-mode-hook 'ansible-vault-mode-maybe)



(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'set-goal-column 'disabled nil)

(global-set-key (kbd "C-c C-m") 'smex)
(global-set-key (kbd "C-x C-m") 'execute-extended-command)

(defun do-nothing ()
  (interactive))

;; the hp probook's numpad has some stupid options - I never want Ovwrt mode enabled:
(global-set-key [insert] 'do-nothing)

(require 'terraform-mode)
(add-hook 'terraform-mode-hook #'terraform-format-on-save-mode)

;; Set your lisp system and, optionally, some contribs
(setq inferior-lisp-program "/usr/local/bin/sbcl")
(setq slime-contribs '(slime-fancy))

(add-hook 'rust-mode-hook 'cargo-minor-mode)
(add-hook 'rust-mode-hook 'racer-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ange-ftp-default-password "djuber@gmail.com")
 '(ange-ftp-default-user "anonymous")
 '(custom-safe-themes
   '("4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4" "2679db166117d5b26b22a8f12a940f5ac415d76b004de03fcd34483505705f62" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "2d035eb93f92384d11f18ed00930e5cc9964281915689fa035719cab71766a15" "6973f93f55e4a6ef99aa34e10cd476bc59e2f0c192b46ec00032fe5771afd9ad" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "64d8237b42b3b01f1487a908836574a5e531ea5efab54b9afa19fb8fda471ab3" "4bdc0dfc53ae06323e031baf691f414babf13c9c9c35014dd07bb42c4db27c24" "9129c2759b8ba8e8396fe92535449de3e7ba61fd34569a488dd64e80f5041c9f" default))
 '(fancy-battery-mode nil)
 '(fci-rule-color "#dedede")
 '(geiser-default-implementation 'racket)
 '(global-visual-line-mode t)
 '(line-spacing 0.2)
 '(max-lisp-eval-depth 2800)
 '(max-specpdl-size 3000)
 '(org-babel-load-languages
   '((emacs-lisp . t)
     (scheme . t)
     (shell . t)
     (ruby . t)
     (lisp . t)))
 '(org-capture-templates
   '(("L" "Checklist" entry
      (file+olp+datetree "~/org/notes.org")
      (file "~/org/template.org"))))
 '(org-confirm-babel-evaluate nil)
 '(package-selected-packages
   '(github-notifier magit-gh-pulls git-timemachine git-walktree gitconfig gitconfig-mode gited git-grep github-explorer github-pullrequest github-review browse-at-remote ghub ghub+ git-link github-browse-file redshank trident-mode terraform-mode sqlformat format-sql color-theme-sanityinc-solarized clojure-essential-ref-nov nov ox-epub sdcv sicp org-projectile projectile-codesearch projectile-direnv projectile-ripgrep projectile-variable keepass-mode walkman with-shell-interpreter rubocop rubocopfmt ruby-electric ruby-end ruby-extra-highlight ruby-hash-syntax ruby-interpolation ruby-refactor ruby-test-mode ruby-tools ameba crystal-mode crystal-playground inf-crystal ob-crystal play-crystal bibliothek bui call-graph cheerilee code-library config-parser decl elog elquery emlib fsm iterator iterators json-rpc json-rpc-server json-snatcher jsonrpc mustache oauth oauth2 eldev humanoid-themes auctex-latexmk smex slime-company slime-repl-ansi-color apel color-theme-solarized color-theme color-theme-sanityinc-tomorrow ecb company-racer ac-geiser flymake flymake-json flymake-racket flymake-ruby flymake-rust geiser racket-mode rainbow-delimiters auto-virtualenv django-commands django-manage django-mode django-snippets djangonaut pony-mode pydoc pydoc-info pyenv-mode pyenv-mode-auto pyimpsort pylint python python-django python-docstring python-environment python-info python-mode python-pytest python-switch-quotes pyvenv virtualenv virtualenvwrapper ahungry-theme cargo lsp-rust ob-rust racer rust-auto-use rust-mode rust-playground rustic poet-theme backlight eslint-fix indium jasminejs-mode jest js-comint js-format projectile projectile-git-autofetch projectile-hanami projectile-rails caml js-auto-beautify js3-mode json-navigator json-reformat lsp-mode lsp-ocaml merlin merlin-eldoc reason-mode rjsx-mode tuareg utop vala-mode anti-zenburn-theme doneburn-theme hc-zenburn-theme labburn-theme zenburn-theme flymd gh-md jekyll-modes markdown-mode markdown-mode+ markdown-preview-eww magit magit-filenotify magit-find-file ssh ssh-config-mode elisp-slime-nav slime yaml-mode ansible ansible-doc ansible-vault ws-butler enh-ruby-mode ido-vertical-mode fancy-battery web-mode auctex dash multishell org))
 '(ring-bell-function 'ignore)
 '(send-mail-function 'smtpmail-send-it)
 '(ssh-agency-agent-exe-names '("gnome-keyring-d"))
 '(utop-command "/home/djuber/bin/utop -emacs")
 '(virtualenv-root "/home/djuber/projects/djangoenv/"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(load-theme *emacs-selected-theme*)
(message ".emacs loaded")
