;;; $DOOMDIR/config.el --- My personal configuration -*- lexical-binding: t; -*-
;;; Commentary:

;;; Code:
;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Ahmet Cemal Özgezer"
      user-mail-address "ozgezer@gmail.com"

      ;; There are two ways to load a theme. Both assume the theme is installed and
      ;; available. You can either set `doom-theme' or manually load a theme with the
      ;; `load-theme' function. This is the default:
      doom-theme 'modus-operandi
      ;; modus-operandi modus-vivendi doom-one doom-gruvbox doom-tomorrow-night

      ;; This determines the style of line numbers in effect. If set to `nil', line
      ;; numbers are disabled. For relative line numbers, set this to `relative'.
      ;;
      ;; Line numbers are pretty slow all around. The performance boost of
      ;; disabling them outweighs the utility of always keeping them on.
      display-line-numbers-type nil

      ;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
      ;; are the three important ones:
      ;;
      ;; + `doom-font'
      ;; + `doom-variable-pitch-font'
      ;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
      ;;   presentations or streaming.
      ;;
      ;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
      ;; font string. You generally only need these two:
      ;; (setq doom-font (font-spec :family "Iosevka" :size 14)
      ;;       doom-variable-pitch-font (font-spec :family "Ubuntu Nerd Font" :size 14))
      doom-font (font-spec :family "Iosevka Nerd Font" :size 13)
      doom-big-font (font-spec :family "Iosevka Nerd Font" :size 24)
      doom-variable-pitch-font (font-spec :family "Overpass Nerd Font" :size 13)
      ;; doom-unicode-font (font-spec :family "Noto Nerd Font")
      doom-serif-font (font-spec :family "BlexMono Nerd Font" :weight 'light)
      
      fancy-splash-image (funcall
                          (lambda (choices) (elt
                                        choices (random (length choices))))
                          (directory-files (concat (expand-file-name
                                                    doom-private-dir) "splash")
                                           t "^\\([^.]\\|\\.[^.]\\|\\.\\..\\)" t))

      auth-source-cache-expiry nil ; default is 7200 (2h)

      delete-by-moving-to-trash t  ; Delete files to trash
      window-combination-resize t  ; take new window space from all other windows (not just current)
      x-stretch-cursor t           ; Stretch cursor to the glyph width
      undo-limit 80000000          ; Raise undo-limit to 80Mb
      auto-save-default t          ; Nobody likes to loose work, I certainly don't
      truncate-string-ellipsis "…" ; Unicode ellispis are nicer than "...", and also save /precious/ space

      frame-resize-pixelwise t)

;; (if (equal "Battery status not available"
;;            (battery))
;;     (display-battery-mode 1)                        ; On laptops it's nice to know how much power you have
;;   (setq password-cache-expiry nil))               ; I can trust my desktops ... can't I? (no battery = desktop)

(global-subword-mode 1)                           ; Iterate through CamelCase words

(setq-default custom-file (expand-file-name ".custom.el" doom-private-dir))
(when (file-exists-p custom-file)
  (load custom-file))

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(custom-set-faces!
  '(aw-leading-char-face
    :foreground "white" :background "red"
    :weight bold :height 2.5 :box (:line-width 10 :color "red")))

;; to hide autosave file from recent files
(after! recentf
  (add-to-list 'recentf-exclude doom-local-dir))

;; Prevents some cases of Emacs flickering
;; (add-to-list 'default-frame-alist '(inhibit-double-buffering . t))

;; (add-to-list 'default-frame-alist '(alpha . (95)))
;; (set-frame-parameter (selected-frame) 'alpha '(95))

(when (daemonp)
  (add-hook 'after-make-frame-functions
            (lambda (frame)
              (with-selected-frame frame
                ;; Adjust the font settings of FRAME so Emacs can display emoji properly.
                (set-fontset-font t 'symbol (font-spec :family "Apple Color Emoji") frame)
                (set-fontset-font t 'symbol (font-spec :family "Segoe UI Emoji") frame 'append)
                (set-fontset-font t 'symbol (font-spec :family "Noto Color Emoji") frame 'append)
                (set-fontset-font t 'symbol (font-spec :family "Noto Emoji") frame 'append)
                ;; (load-theme 'doom-one t)
                (modus-themes-load-operandi)))))

(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; (windmove-default-keybindings 'control)
;; (windswap-default-keybindings 'control 'shift)
;; (add-hook 'org-shiftup-final-hook 'windmove-up)
;; (add-hook 'org-shiftleft-final-hook 'windmove-left)
;; (add-hook 'org-shiftdown-final-hook 'windmove-down)
;; (add-hook 'org-shiftright-final-hook 'windmove-right)

;; SPC n to switch to winum-numbered window n
(map!
 (:leader
    :desc "Switch to window 0" :n "0" #'treemacs-select-window
    :desc "Switch to window 1" :n "1" #'winum-select-window-1
    :desc "Switch to window 2" :n "2" #'winum-select-window-2
    :desc "Switch to window 3" :n "3" #'winum-select-window-3
    :desc "Switch to window 4" :n "4" #'winum-select-window-4
    :desc "Switch to window 5" :n "5" #'winum-select-window-5
    :desc "Switch to window 6" :n "6" #'winum-select-window-6
    :desc "Switch to window 7" :n "7" #'winum-select-window-7
    :desc "Switch to window 8" :n "8" #'winum-select-window-8
    :desc "Switch to window 9" :n "9" #'winum-select-window-9))

;; (add-to-list 'term-file-aliases
;;              '("alacritty" . "xterm-256color"))

(map! "M-c" #'capitalize-dwim
      "M-l" #'downcase-dwim
      "M-u" #'upcase-dwim)

(set-popup-rules! '(("^\\*Customize.*" :slot 2 :side right :modeline nil :select t :quit t)
                    (" \\*undo-tree\\*" :slot 2 :side left :size 20 :modeline nil :select t :quit t)
                    ("^\\*Password-Store" :side left :size 0.25)

                    ;; * help
                    ("^\\*info.*" :size 82 :side right :ttl t :select t :quit t)
                    ("^\\*Man.*" :size 82 :side right :ttl t :select t :quit t)
                    ("^\\*tldr\\*" :size 82 :side right :select t :quit t)
                    ("^\\*helpful.*" :size 82 :side right :select t :quit t)
                    ("^\\*Help.*" :size 82 :height 0.6 :side right :select t :quit t)
                    ("^ \\*Metahelp.*" :size 82 :side right :select t :quit t)
                    ("^\\*Apropos.*" :size 82 :height 0.6 :side right :select t :quit t)
                    ("^\\*Messages\\*" :vslot -10 :height 10 :side bottom :select t :quit t :ttl nil)

                    ;; ("^ ?\\*NeoTree" :side ,neo-window-position :width ,neo-window-width :quit 'current :select t)
                    ("\\*VC-history\\*" :slot 2 :side right :size 82 :modeline nil :select t :quit t)

                    ;; * web
                    ("^\\*eww.*" :size 82 :side right :select t :quit t)
                    ("\\*xwidget" :side right :size 100 :select t)

                    ;; * lang
                    ;; ** python
                    ("^\\*Anaconda\\*" :side right :size 82 :quit t :ttl t)))

(after! avy
  (setq avy-all-windows 'all-frames))

(use-package! beginend
  :init (beginend-global-mode))

;; WSL specific setting
(when (and (eq system-type 'gnu/linux) (getenv "WSLENV"))
  ;; teach Emacs how to open links with your default browser
  (let ((cmd-exe "/mnt/c/Windows/System32/cmd.exe")
      (cmd-args '("/c" "start")))
  (when (file-exists-p cmd-exe)
    (setq browse-url-generic-program  cmd-exe
          browse-url-generic-args     cmd-args
          browse-url-browser-function 'browse-url-generic
          search-web-default-browser 'browse-url-generic))))

(after! calendar
  (setq calendar-location-name "Istanbul, Turkey"
        calendar-latitude 41.168602
        calendar-longitude 29.047024))

;; (defconst ac/c-or-c++-mode--regexp
;;   (eval-when-compile
;;     (let ((id "[a-zA-Z0-9_]+") (ws "[ \t\r]+") (ws-maybe "[ \t\r]*"))
;;       (concat "^" ws-maybe "\\(?:"
;;                     "using"     ws "\\(?:namespace" ws "std;\\|std::\\)"
;;               "\\|" "namespace" "\\(:?" ws id "\\)?" ws-maybe "{"
;;               "\\|" "class"     ws id ws-maybe "[:{\n]"
;;               "\\|" "template"  ws-maybe "<.*>"
;;               "\\|" "#include"  ws-maybe "<\\(?:string\\|iostream\\|map\\)>"
;;               "\\)")))
;;   "A regexp applied to C header files to check if they are really C++.")

;; (defconst ac/make-mode--regexp
;;   (eval-when-compile
;;     (let ((id "[A-Z0-9_]+") (ws-maybe "[ \t\r]*"))
;;       (concat "^" ws-maybe "\\(?:"
;;               "include"  ws-maybe ".*"
;;               "\\|" id ws-maybe "=" ws-maybe ".*"
;;               "\\)")))
;;   "A regexp applied to files to check if they are really Makefiles.")

;; (defun ac/c-or-make-mode ()
;;   "Analyze buffer and enable either C or C++ mode.
;; Some people and projects use .h extension for C++ header files
;; which is also the one used for C header files.  This makes
;; matching on file name insufficient for detecting major mode that
;; should be used.
;; This function attempts to use file contents to determine whether
;; the code is C or C++ and based on that chooses whether to enable
;; `c-mode' or `c++-mode'."
;;   (save-excursion
;;     (save-restriction
;;       (save-match-data
;;         (widen)
;;         (goto-char (point-min))
;;         (if (re-search-forward ac/c-or-c++-mode--regexp
;;                                (+ (point) 50000) t)
;;             (c++-mode)
;;           (goto-char (point-min))
;;           (if (re-search-forward ac/make-mode--regexp
;;                                  (+ (point) 50000) t)
;;               (makefile-mode)
;;             (c-mode)))))))

;; (add-to-list 'auto-mode-alist '("\\.h\\'" . ac/c-or-make-mode))

;; (defun ac/make-mode-p ()
;;   "Analyze buffer and enable Makefile mode.
;; This function attempts to use file contents to determine whether
;; the code is Makefile and based on that chooses whether to enable
;; `makefile-mode'."
;;   (save-excursion
;;     (save-restriction
;;       (save-match-data
;;         (widen)
;;         (goto-char (point-min))
;;         (re-search-forward ac/make-mode--regexp
;;                                  (+ (point) magic-mode-regexp-match-limit) t)))))
;; (add-to-list 'magic-mode-alist '(ac/make-mode-p . makefile-mode))

(after! ccls
  (setq ccls-initialization-options `(:index (:comments 2)
                                      :completion (:detailedLabel t)
                                      :cache (:directory ,(file-truename "~/.cache/ccls")))))

(use-package! daemons)

;;
;; Dired
;;

;; Hook up dired-x global bindings without loading it up-front
(define-key ctl-x-map "\C-j" 'dired-jump)
(define-key ctl-x-4-map "\C-j" 'dired-jump-other-window)

(setq dired-hide-details-hide-symlink-targets t)
(add-hook! dired-mode
  (dired-hide-details-mode 1)
  ;; (dired-show-readme-mode 1)
  (dired-auto-readme-mode 1)
  (hl-line-mode 1))

(use-package! dired-subtree
  :after dired
  :config
  (map!
   (:map dired-mode-map
    :desc "Toggle subtree" :n [tab] #'dired-subtree-toggle)))

(after! dired
  ;; Define localleader bindings
  (map!
   ;; Define or redefine dired bindings
   (:map dired-mode-map
     :desc "Up" :n "<left>" #'dired-up-directory
     :desc "Down" :n "<right>" #'dired-find-file)))

;; Easier to match with a bspwm rule:
;;   bspc rule -a 'Emacs:emacs-everywhere' state=floating sticky=on
(setq emacs-everywhere-frame-name-format "emacs-everywhere")

;; The modeline is not useful to me in the popup window. It looks much nicer
;; to hide it.
(add-hook 'emacs-everywhere-init-hooks #'hide-mode-line-mode)

;; Semi-center it over the target window, rather than at the cursor position
;; (which could be anywhere).
(defadvice! my-emacs-everywhere-set-frame-position (&rest _)
  :override #'emacs-everywhere-set-frame-position
  (cl-destructuring-bind (width . height)
      (alist-get 'outer-size (frame-geometry))
    (set-frame-position (selected-frame)
                        (+ emacs-everywhere-window-x
                           (/ emacs-everywhere-window-width 2)
                           (- (/ width 2)))
                        (+ emacs-everywhere-window-y
                           (/ emacs-everywhere-window-height 2)))))

(after! evil
  (setq
   evil-want-fine-undo t       ; By default while in insert all changes are one big blob. Be more granular
   evil-vsplit-window-right t  ; Switch to the new window after splitting
   evil-split-window-below t))

(use-package! evil-colemak-basics
  :after evil evil-snipe
  :init
  (setq evil-colemak-basics-rotate-t-f-j nil
        evil-colemak-basics-char-jump-commands 'evil-snipe)
  :config
  (global-evil-colemak-basics-mode))

(after! format-all
  (setq +format-on-save-enabled-modes
      '(go-mode)))

(use-package! highlight-parentheses
  :init
  (add-hook 'prog-mode-hook #'highlight-parentheses-mode)
  (setq highlight-parentheses-delay 0.2)
  :config
  (set-face-attribute 'hl-paren-face nil :weight 'ultra-bold))

(use-package! journalctl-mode)

(after! lsp-go
  (lsp-register-custom-settings
   '(("gopls.experimentalWorkspaceModule" t t))))

(after! lsp-mode
  (setq lsp-headerline-breadcrumb-enable t
        lsp-lens-enable nil
        lsp-signature-render-documentation t))

(after! lsp-ui
  (setq lsp-ui-doc-enable nil ; fixes the LSP lag
        lsp-ui-doc-position 'bottom
        lsp-ui-doc-use-childframe t
        lsp-ui-doc-include-signature t
        lsp-ui-doc-max-height 50
        lsp-ui-doc-max-width 150
        lsp-ui-doc-include-signature t
        lsp-ui-sideline-show-hover t
        lsp-ui-sideline-show-symbol t))

;; https://stackoverflow.com/questions/730751/hiding-m-in-emacs
(defun acml/hide-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))

;; https://newbedev.com/how-do-i-display-ansi-color-codes-in-emacs-for-any-mode
(defun acml/ansi-color (&optional beg end)
  "Color the ANSI escape sequences in the active region or whole buffer.
Sequences start with an escape \033 (typically shown as \"^[\")
and end with \"m\", e.g. this is two sequences
  ^[[46;1mTEXT^[[0m
where the first sequence says to diplay TEXT as bold with
a cyan background and the second sequence turns it off.

This strips the ANSI escape sequences and if the buffer is saved,
the sequences will be lost."
  (interactive
   (if (use-region-p)
       (list (region-beginning) (region-end))
     (list (point-min) (point-max))))
  (if buffer-read-only
      ;; read-only buffers may be pointing a read-only file system, so don't mark the buffer as
      ;; modified. If the buffer where to become modified, a warning will be generated when emacs
      ;; tries to autosave.
      (let ((inhibit-read-only t)
            (modified (buffer-modified-p)))
        (ansi-color-apply-on-region beg end)
        (set-buffer-modified-p modified))
    (ansi-color-apply-on-region beg end)))

(add-hook! ('text-mode-hook 'prog-mode-hook)
  (defun acml/set-fringe-widths ()
    (setq-local left-fringe-width 6
                right-fringe-width 6)))

;;; :tools magit
;;; does not work if converted to add-hook!
(add-hook 'magit-mode-hook
  (lambda ()
    (setq-local left-fringe-width 16
                magit-section-visibility-indicator (if (display-graphic-p)
                                                       '(magit-fringe-bitmap> . magit-fringe-bitmapv)
                                                     (cons (if (char-displayable-p ?…) "…" "...")
                                                           t)))))

(after! magit
  (magit-add-section-hook 'magit-status-sections-hook
                          'magit-insert-ignored-files
                          'magit-insert-untracked-files
                          nil))

(setq magit-repository-directories '(("~/Projects" . 2))
      magit-save-repository-buffers nil
      ;; Don't restore the wconf after quitting magit, it's jarring
      magit-inhibit-save-previous-winconf t
      transient-values '((magit-rebase "--autosquash" "--autostash")
                         (magit-pull "--rebase" "--autostash")))

(use-package! modus-themes
  :ensure                         ; omit this to use the built-in themes
  :init
  (setq modus-themes-italic-constructs t
        modus-themes-bold-constructs t
        modus-themes-mixed-fonts t
        modus-themes-subtle-line-numbers nil
        modus-themes-deuteranopia nil
        modus-themes-tabs-accented t
        modus-themes-variable-pitch-ui t
        modus-themes-inhibit-reload t ; only applies to `customize-set-variable' and related

        modus-themes-fringes nil ; {nil,'subtle,'intense}

        ;; Options for `modus-themes-lang-checkers' are either nil (the
        ;; default), or a list of properties that may include any of those
        ;; symbols: `straight-underline', `text-also', `background',
        ;; `intense' OR `faint'.
        modus-themes-lang-checkers nil

        ;; Options for `modus-themes-mode-line' are either nil, or a list
        ;; that can combine any of `3d' OR `moody', `borderless',
        ;; `accented', and a natural number for extra padding
        modus-themes-mode-line '(3d borderless)

        ;; Options for `modus-themes-markup' are either nil, or a list
        ;; that can combine any of `bold', `italic', `background',
        ;; `intense'.
        modus-themes-markup '(background italic)

        ;; Options for `modus-themes-syntax' are either nil (the default),
        ;; or a list of properties that may include any of those symbols:
        ;; `faint', `yellow-comments', `green-strings', `alt-syntax'
        modus-themes-syntax '(faint)

        ;; Options for `modus-themes-hl-line' are either nil (the default),
        ;; or a list of properties that may include any of those symbols:
        ;; `accented', `underline', `intense'
        modus-themes-hl-line nil

        ;; Options for `modus-themes-paren-match' are either nil (the
        ;; default), or a list of properties that may include any of those
        ;; symbols: `bold', `intense', `underline'
        modus-themes-paren-match '(bold intense)

        ;; Options for `modus-themes-links' are either nil (the default),
        ;; or a list of properties that may include any of those symbols:
        ;; `neutral-underline' OR `no-underline', `faint' OR `no-color',
        ;; `bold', `italic', `background'
        modus-themes-links '(neutral-underline)

        ;; Options for `modus-themes-box-buttons' are either nil (the
        ;; default), or a list that can combine any of `flat', `accented',
        ;; `faint', `variable-pitch', `underline', the symbol of any font
        ;; weight as listed in `modus-themes-weights', and a floating
        ;; point number (e.g. 0.9) for the height of the button's text.
        modus-themes-box-buttons '(variable-pitch flat faint 0.9)

        ;; Options for `modus-themes-prompts' are either nil (the
        ;; default), or a list of properties that may include any of those
        ;; symbols: `background', `bold', `gray', `intense', `italic'
        modus-themes-prompts nil

        ;; The `modus-themes-completions' is an alist that reads three
        ;; keys: `matches', `selection', `popup'.  Each accepts a nil
        ;; value (or empty list) or a list of properties that can include
        ;; any of the following (for WEIGHT read further below):
        ;;
        ;; `key' - `background', `intense', `underline', `italic', WEIGHT
        ;; `selection' - `accented', `intense', `underline', `italic', WEIGHT
        ;; `popup' - same as `selected'
        ;; `t' - applies to any key not explicitly referenced (check docs)
        ;;
        ;; WEIGHT is a symbol such as `semibold', `light', or anything
        ;; covered in `modus-themes-weights'.  Bold is used in the absence
        ;; of an explicit WEIGHT.
        modus-themes-completions '((matches . (extrabold))
                                   (selection . (semibold accented))
                                   (popup . (accented intense)))

        modus-themes-mail-citations 'faint ; {nil,'intense,'faint,'monochrome}

        ;; Options for `modus-themes-region' are either nil (the default),
        ;; or a list of properties that may include any of those symbols:
        ;; `no-extend', `bg-only', `accented'
        modus-themes-region '(bg-only no-extend)

        ;; Options for `modus-themes-diffs': nil, 'desaturated, 'bg-only
        modus-themes-diffs 'desaturated

        modus-themes-org-blocks 'gray-background ; {nil,'gray-background,'tinted-background}

        modus-themes-org-agenda ; this is an alist: read the manual or its doc string
        '((header-block . (variable-pitch 1.3))
          (header-date . (grayscale workaholic bold-today 1.1))
          (event . (accented varied))
          (scheduled . uniform)
          (habit . traffic-light))

        modus-themes-headings ; this is an alist: read the manual or its doc string
        '((1 . (overline background variable-pitch 1.3))
          (2 . (rainbow overline 1.1))
          (t . (semibold))))

  ;; Load the theme files before enabling a theme
  (modus-themes-load-themes)

  :config
  ;; Load the theme of your choice
  ;; (modus-themes-load-operandi)
  ;; ;; OR
  ;; (load-theme 'modus-operandi t)
  (with-eval-after-load 'pdf-tools
      ;; Configure PDF page colors. The code below comes from Modus
     (defun my-pdf-tools-backdrop ()
       (face-remap-add-relative
        'default
        `(:background ,(modus-themes-color 'bg-alt))))

     (defun my-pdf-tools-midnight-mode-toggle ()
       (when (derived-mode-p 'pdf-view-mode)
         (if (eq (car custom-enabled-themes) 'modus-vivendi)
             (pdf-view-midnight-minor-mode 1)
           (pdf-view-midnight-minor-mode -1))
         (my-pdf-tools-backdrop)))

     (defun my-pdf-tools-themes-toggle ()
       (mapc
        (lambda (buf)
          (with-current-buffer buf
            (my-pdf-tools-midnight-mode-toggle)))
        (buffer-list)))

     (add-hook 'pdf-tools-enabled-hook #'my-pdf-tools-midnight-mode-toggle)
     (add-hook 'modus-themes-after-load-theme-hook #'my-pdf-tools-themes-toggle))
  :bind ("<f5>" . modus-themes-toggle))

; Each path is relative to `+mu4e-mu4e-mail-path', which is ~/.mail by default
(after! mu4e
  (set-email-account! "yahoo"
                      '((mu4e-sent-folder       . "/Yahoo/Sent")
                        (mu4e-drafts-folder     . "/Yahoo/Draft")
                        (mu4e-trash-folder      . "/Yahoo/Trash")
                        (mu4e-refile-folder     . "/Yahoo/Archive")
                        (smtpmail-smtp-user     . "ozgezer@yahoo.com")
                        (mu4e-compose-signature . "---\nAhmet Cemal Özgezer")))
  (set-email-account! "gmail"
                      '((mu4e-sent-folder       . "/Gmail/[Gmail]/Sent Mail")
                        (mu4e-drafts-folder     . "/Gmail/[Gmail]/Drafts")
                        (mu4e-trash-folder      . "/Gmail/[Gmail]/Trash")
                        (mu4e-refile-folder     . "/Gmail/[Gmail]/Archive")
                        (smtpmail-smtp-user     . "ozgezer@gmail.com")
                        (mu4e-compose-signature . "---\nAhmet Cemal Özgezer")))
  (set-email-account! "msn"
                      '((mu4e-sent-folder       . "/MSN/Sent")
                        (mu4e-drafts-folder     . "/MSN/Drafts")
                        (mu4e-trash-folder      . "/MSN/Deleted")
                        (mu4e-refile-folder     . "/MSN/Archive")
                        (smtpmail-smtp-user     . "ozgezer@msn.com")
                        (mu4e-compose-signature . "---\nAhmet Cemal Özgezer"))))

(setq
 ;; If you use `org' and don't want your org files in the default location below,
 ;; change `org-directory'. It must be set before org loads!
 org-directory (expand-file-name "~/Documents/org/")
 org-noter-notes-search-path '("~/Documents/org/notes/"))

(after! org
  (setq
   org-agenda-files (list org-directory)
   ;; org-archive-location (concat org-directory ".archive/%s::")
   ;; org-roam-directory (concat org-directory "notes/")
   ;; org-roam-db-location (concat org-roam-directory ".org-roam.db")
   ;; org-journal-encrypt-journal t
   ;; org-journal-file-format "%Y%m%d.org"
   ;; org-startup-folded 'overview
   ;; org-ellipsis " [...] "
   ))

(after! persp-mode
  (setq persp-emacsclient-init-frame-behaviour-override nil)
  (defun display-workspaces-in-minibuffer ()
    (with-current-buffer " *Minibuf-0*"
      (erase-buffer)
      (insert (+workspace--tabline))))
  (run-with-idle-timer 1 t #'display-workspaces-in-minibuffer)
  (+workspace/display))

(setq +workspaces-switch-project-function #'dired)

;; (after! counsel-projectile
;;   (setq counsel-projectile-switch-project-action 'counsel-projectile-switch-project-action-dired))

(after! projectile
  (setq ;; projectile-switch-project-action 'projectile-dired
        projectile-enable-caching t
        projectile-project-search-path '("~/Projects/")
        ;; Follow suggestion to reorder root functions to find the .projectile file
        ;; https://old.reddit.com/r/emacs/comments/920psp/projectile_ignoring_projectile_files/
        ;; projectile-project-root-files-functions #'(projectile-root-top-down
        ;;                                            projectile-root-top-down-recurring
        ;;                                            projectile-root-bottom-up
        ;;                                            projectile-root-local)
        )
  (projectile-register-project-type
   'gimsa '("build.sh")
   :compile "./build.sh"
   :compilation-dir ".")
  (projectile-register-project-type
   'linux '("COPYING" "CREDITS" "Kbuild" "Kconfig" "MAINTAINERS" "Makefile" "README")
   :compile "make O=am43xx_evm ARCH=arm CROSS_COMPILE=arm-openwrt-linux-gnueabi- all"
   :compilation-dir ".")
  (projectile-register-project-type
   'openwrt '("BSDmakefile" "Config.in" "feeds.conf.default" "LICENSE" "Makefile" "README" "rules.mk" "version.date")
   :compile "make world"
   :compilation-dir ".")
  (projectile-register-project-type
   'u-boot '("config.mk" "Kbuild" "Kconfig" "MAINTAINERS" "MAKEALL" "Makefile" "README" "snapshot.commit")
   :compile "make O=am43xx_evm ARCH=arm CROSS_COMPILE=arm-openwrt-linux-gnueabi- all"
   :compilation-dir "."))

;; (remove-hook 'doom-first-buffer-hook #'global-hl-line-mode)
;; (setq global-hl-line-modes nil)
;; (add-hook! 'rainbow-mode-hook
;;     (hl-line-mode (if rainbow-mode -1 +1)))
(use-package! rainbow-mode
  :hook
  ((prog-mode . rainbow-mode)
   (org-mode . rainbow-mode)))

(use-package! trashed
  :config
  (add-to-list 'evil-emacs-state-modes 'trashed-mode))

(setq +treemacs-git-mode 'deferred
      ;; treemacs-collapse-dirs 5
      ;; treemacs-eldoc-display t
      ;; treemacs-is-never-other-window nil
      treemacs-recenter-after-file-follow 'on-distance
      treemacs-recenter-after-project-expand 'on-distance
      ;; treemacs-show-hidden-files t
      ;; treemacs-silent-filewatch t
      ;; treemacs-silent-refresh t
      ;; treemacs-sorting 'alphabetic-asc
      ;; treemacs-user-mode-line-format nil
      treemacs-width 40
      treemacs-follow-after-init t)

(after! treemacs
  ;; Quite often there are superfluous files I'm not that interested in. There's no
  ;; good reason for them to take up space. Let's add a mechanism to ignore them.
  (defvar treemacs-file-ignore-extensions '()
    "File extension which `treemacs-ignore-filter' will ensure are ignored")
  (defvar treemacs-file-ignore-globs '()
    "Globs which will are transformed to `treemacs-file-ignore-regexps' which `treemacs-ignore-filter' will ensure are ignored")
  (defvar treemacs-file-ignore-regexps '()
    "RegExps to be tested to ignore files, generated from `treeemacs-file-ignore-globs'")
  (defun treemacs-file-ignore-generate-regexps ()
    "Generate `treemacs-file-ignore-regexps' from `treemacs-file-ignore-globs'"
    (setq treemacs-file-ignore-regexps (mapcar 'dired-glob-regexp treemacs-file-ignore-globs)))
  (if (equal treemacs-file-ignore-globs '()) nil (treemacs-file-ignore-generate-regexps))
  (defun treemacs-ignore-filter (file full-path)
    "Ignore files specified by `treemacs-file-ignore-extensions', and `treemacs-file-ignore-regexps'"
    (or (member (file-name-extension file) treemacs-file-ignore-extensions)
        (let ((ignore-file nil))
          (dolist (regexp treemacs-file-ignore-regexps ignore-file)
            (setq ignore-file (or ignore-file (if (string-match-p regexp full-path) t nil)))))))
  (add-to-list 'treemacs-ignored-file-predicates #'treemacs-ignore-filter)

  ;; Now, we just identify the files in question.
  (setq treemacs-file-ignore-extensions
        '(;; build outputs
          "o"
          "psd"
          ;; LaTeX
          "aux"
          "ptc"
          "fdb_latexmk"
          "fls"
          "synctex.gz"
          "toc"
          ;; LaTeX - glossary
          "glg"
          "glo"
          "gls"
          "glsdefs"
          "ist"
          "acn"
          "acr"
          "alg"
          ;; LaTeX - pgfplots
          "mw"
          ;; LaTeX - pdfx
          "pdfa.xmpi"
          ))
  (setq treemacs-file-ignore-globs
        '(;; LaTeX
          "*/_minted-*"
          ;; AucTeX
          "*/.auctex-auto"
          "*/_region_.log"
          "*/_region_.tex"))

  ;; (add-hook! '(treemacs-mode-hook treemacs-select-functions)
  ;;            (defun acml/set-treemacs-fringes (&optional visibilty)
  ;;              (set-window-fringes nil 8)))
  ;; highlight current line in fringe for treemacs window
  ;; (treemacs-fringe-indicator-mode 'always)
  (treemacs-follow-mode)
  (treemacs-filewatch-mode))

(use-package! turkish
  ;; :init (evil-leader/set-key (kbd "ot") 'turkish-mode)
  :commands (turkish-mode))

(setq vterm-max-scrollback 100000)

;; text mode directory tree
(use-package! ztree
  :bind (:map ztreediff-mode-map
         ("C-<f5>" . ztree-diff))
  :init (setq ztree-draw-unicode-lines t
              ztree-show-number-of-children t))

;; (setq spacemacs-path doom-modules-dir)
;; (load! (concat spacemacs-path "spacemacs/+spacemacs"))
