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
      doom-theme (if (display-graphic-p) 'modus-operandi 'modus-vivendi)
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
      window-resize-pixelwise t
      frame-resize-pixelwise t)

;; (if (equal "Battery status not available"
;;            (battery))
;;     (display-battery-mode 1)                        ; On laptops it's nice to know how much power you have
;;   (setq password-cache-expiry nil))               ; I can trust my desktops ... can't I? (no battery = desktop)

(global-subword-mode 1)                           ; Iterate through CamelCase words

(setq-default custom-file (expand-file-name "custom.el" doom-local-dir))
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
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))

;; (add-to-list 'default-frame-alist '(alpha . (95)))
;; (set-frame-parameter (selected-frame) 'alpha '(95))

(when (daemonp)
  (add-hook 'after-make-frame-functions
            (lambda (frame)
              (with-selected-frame frame
                ;; Adjust the font settings of FRAME so Emacs can display emoji properly.
                ;; (set-fontset-font t 'symbol (font-spec :family "Apple Color Emoji") frame)
                ;; (set-fontset-font t 'symbol (font-spec :family "Segoe UI Emoji") frame 'append)
                ;; (set-fontset-font t 'symbol (font-spec :family "Noto Color Emoji") frame 'append)
                ;; (set-fontset-font t 'symbol (font-spec :family "Noto Emoji") frame 'append)
                ;; (load-theme 'doom-one t)
                (if (display-graphic-p)
                    (modus-themes-load-operandi)
                  (modus-themes-load-vivendi))))))

(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; Directional window-selection routines
(use-package! windmove
  :hook (after-init . windmove-default-keybindings))

(use-package! windswap
  :hook (after-init . (lambda () (windswap-default-keybindings 'control 'shift))))

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

(set-popup-rules! '(("^\\*info\\*" :size 82 :side right :select t :quit t)
                    ("^\\*\\(?:Wo\\)?Man " :size 82 :side right :select t :quit t)))

(after! avy
  (setq avy-all-windows 'all-frames))

(use-package! beginend
  :hook (after-init . beginend-global-mode))

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

(after! ccls
  (setq ccls-initialization-options `(:index (:comments 2)
                                      :completion (:detailedLabel t)
                                      :cache (:directory ,(file-truename "~/.cache/ccls")))))

(use-package! daemons :defer t)

;;
;; Dired
;;
(setq dired-hide-details-hide-symlink-targets t)
(add-hook! dired-mode
  (dired-hide-details-mode 1)
  (dired-auto-readme-mode 1))

(after! dired
  ;; Define localleader bindings
  (map!
   ;; Define or redefine dired bindings
   (:map dired-mode-map
     :desc "Up" :n "<left>" #'dired-up-directory
     :desc "Down" :n "<right>" #'dired-find-file)))

(after! (:any dired dirvish)
  (require 'dired-x))
(set-popup-rule! "^ \\*Dirvish.*" :ignore t)

(map! :map dired-mode-map :ng "q" #'dirvish-quit)
(use-package! dirvish
  :after dired
  :config
  ;; Go back home? Just press `bh'
  (setq dired-listing-switches
        "-l --almost-all --human-readable --time-style=long-iso --group-directories-first --no-group"
        dirvish-quick-access-entries
        '(("h" "~/"                          "Home")
          ("d" "~/Downloads/"                "Downloads")
          ("m" "/mnt/"                       "Drives")
          ("n" "~/.nixpkgs/"                 "Nix")
          ("p" "~/Projects/"                 "Projects")
          ("t" "~/.local/share/Trash/files/" "TrashCan"))
        dirvish-attributes '(vc-state subtree-state all-the-icons collapse git-msg)
        dirvish-header-line-format '(:left (path) :right (free-space))
        dirvish-mode-line-format '(:left (sort file-time " " file-size symlink) :right (omit yank index)))

  ;; (map! :map dired-mode-map :ng "q" #'quit-window)
  (map! :map dirvish-mode-map
        :n "b" #'dirvish-quick-access
        :n "z" #'dirvish-show-history
        ;; :n "f" #'dirvish-file-info-menu
        ;; :n "F" #'dirvish-toggle-fullscreen
        ;; :n "l" #'dired-find-file
        ;; :n "h" #'dired-up-directory
        :n "TAB" #'dirvish-subtree-toggle
        :n "?" #'dirvish-dispatch
        ;; :n "q" #'dirvish-quit
        ;; :localleader
        ;; "h" #'dired-omit-mode
        )

  (dirvish-define-preview exa (file)
    "Use `exa' to generate directory preview."
    (when (file-directory-p file) ; we only interest in directories here
      `(shell . ("exa" "--color=always" "-al" ,file)))) ; use the output of `exa' command as preview

  (add-to-list 'dirvish-preview-dispatchers 'exa)
  ;; :bind
  ;; (:map dired-mode-map ; Dirvish respects all the keybindings in this map
  ;;  ("TAB" . dirvish-subtree-toggle))
  )

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
   ;; x-select-enable-clipboard nil   ; yanking to the system clipboard crashes emacs (emacsPgtkNativeComp)
   evil-want-fine-undo t       ; By default while in insert all changes are one big blob. Be more granular
   evil-vsplit-window-right t  ; Switch to the new window after splitting
   evil-split-window-below t))

(use-package! evil-colemak-basics
  :after evil evil-snipe
  ;; :hook (ediff-keymap-setup-hook . evil-colemak-basics-mode)
  :init
  (setq evil-colemak-basics-rotate-t-f-j nil
        evil-colemak-basics-char-jump-commands 'evil-snipe)
  :config
  (global-evil-colemak-basics-mode))

(setq avy-keys '(?a ?r ?s ?t ?d ?h ?n ?e ?i ?o ?w ?f ?p ?l ?u ?y)
      lispy-avy-keys '(?a ?r ?s ?t ?d ?h ?n ?e ?i ?o ?w ?f ?p ?l ?u ?y))

;; :ui window-select settings, ignoring +numbers flag for now
(after! ace-window
  (setq aw-keys '(?a ?r ?s ?t ?d ?h ?n ?e ?i ?o ?w ?f ?p ?l ?u ?y)))
(after! switch-window
  (setq switch-window-shortcut-style 'qwerty
        switch-window-qwerty-shortcuts '("a" "r" "s" "t" "d" "h" "n" "e" "i" "o" "w" "f" "p" "l" "u" "y")))

(after! expand-region
  (define-key evil-visual-state-map (kbd "v") 'er/expand-region))

(after! format-all
  (setq +format-on-save-enabled-modes
      '(go-mode)))

(use-package! highlight-parentheses
  :init
  (setq highlight-parentheses-delay 0.2)
  :config
  (set-face-attribute 'hl-paren-face nil :weight 'ultra-bold)
  :hook
  (prog-mode . highlight-parentheses-mode))

(use-package! journalctl-mode :defer t)

(after! lsp-go
  (lsp-register-custom-settings
   '(("gopls.experimentalWorkspaceModule" t t)
     ("gopls.staticcheck" t t))))

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

(setq-default left-fringe-width 8
              right-fringe-width 8)

;;; :tools magit
(add-hook! 'magit-mode-hook
  (setq-local
   left-fringe-width 16
   magit-section-visibility-indicator (if (display-graphic-p)
                                          '(magit-fringe-bitmap> . magit-fringe-bitmapv)
                                        (cons (if (char-displayable-p ?…) "…" "...") t))))

(after! magit
  (magit-add-section-hook 'magit-status-sections-hook
                          'magit-insert-ignored-files
                          'magit-insert-untracked-files
                          nil))

(setq magit-repository-directories '(("~/.nixpkgs" . 1) ("~/Projects" . 3))
      magit-save-repository-buffers nil
      ;; Don't restore the wconf after quitting magit, it's jarring
      magit-inhibit-save-previous-winconf t
      transient-values '((magit-rebase "--autosquash" "--autostash")
                         (magit-pull "--rebase" "--autostash")))

(defvar elken/mixed-pitch-modes '(org-mode LaTeX-mode markdown-mode gfm-mode Info-mode)
  "Only use `mixed-pitch-mode' for given modes.")

(defun init-mixed-pitch-h ()
  "Hook `mixed-pitch-mode' into each mode of `elken/mixed-pitch-modes'"
  (when (memq major-mode elken/mixed-pitch-modes)
    (mixed-pitch-mode 1))
  (dolist (hook elken/mixed-pitch-modes)
    (add-hook (intern (concat (symbol-name hook) "-hook")) #'mixed-pitch-mode)))

(add-hook 'doom-init-ui-hook #'init-mixed-pitch-h)

(use-package! modus-themes
  :init
  (setq modus-themes-italic-constructs t
        modus-themes-bold-constructs t
        modus-themes-mixed-fonts t
        modus-themes-subtle-line-numbers nil
        modus-themes-intense-mouseovers nil
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
        ;; `accented', a natural number for extra padding (or a cons cell
        ;; of padding and NATNUM), and a floating point for the height of
        ;; the text relative to the base font size (or a cons cell of
        ;; height and FLOAT)
        modus-themes-mode-line '(3d borderless)
        ;; modus-themes-mode-line '(accented borderless (padding . 4) (height . 0.9))

        ;; Same as above:
        ;; modus-themes-mode-line '(accented borderless 4 0.9)

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
        ;; `faint', `variable-pitch', `underline', `all-buttons', the
        ;; symbol of any font weight as listed in `modus-themes-weights',
        ;; and a floating point number (e.g. 0.9) for the height of the
        ;; button's text.
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
        ;; `matches' - `background', `intense', `underline', `italic', WEIGHT
        ;; `selection' - `accented', `intense', `underline', `italic', `text-also' WEIGHT
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

(use-package! deft
  :after org
  :custom
  (deft-recursive t)
  (deft-use-filter-string-for-filename t)
  (deft-default-extension "org")
  (deft-directory org-roam-directory))

(use-package! org-appear
  :after org
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autolinks t
        org-appear-autoemphasis t
        org-appear-autosubmarkers t
        org-appear-delay 0.3))

(use-package! org-noter
  :after org
  :config
  (setq org-noter-notes-search-path '("~/Documents/org/notes/")))

(setq
 ;; If you use `org' and don't want your org files in the default location below,
 ;; change `org-directory'. It must be set before org loads!
 org-directory (expand-file-name "~/Documents/org/")
 org-startup-with-inline-images t)

(after! org
  (setq
   org-agenda-files (list org-directory)
   org-ellipsis (if (and (display-graphic-p) (char-displayable-p ?)) " " nil)
   org-startup-folded 'show2levels)

  (add-hook! org-mode (org-pretty-table-mode 1))

  ;; (after! org-roam
  ;;   (setq org-roam-directory "~/Documents/org/roam/")

  ;;   (add-hook 'after-init-hook 'org-roam-mode)

  ;;   ;; Let's set up some org-roam capture templates
  ;;   (setq org-roam-capture-templates
  ;;         (quote (("d" "default" plain
  ;;                  "%?"
  ;;                  :target
  ;;                  (file+head "%<%Y-%m-%d-%H%M%S>-${slug}.org"
  ;;                             "#+title: ${title}\n")
  ;;                  :unnarrowed t)
  ;;                 ("r" "bibliography reference" plain
  ;;                  (file "~/org/roam/templates/orb-capture")
  ;;                  :target
  ;;                  (file+head "references/${citekey}.org" "#+title: ${title}\n")))))

  ;;   ;; And now we set necessary variables for org-roam-dailies
  ;;   (setq org-roam-dailies-directory "daily/")
  ;;   (setq org-roam-dailies-capture-templates
  ;;         '(("d" "default" entry
  ;;            "* %?"
  ;;            :target
  ;;            (file+head "%<%Y-%m-%d>.org"
  ;;                       "#+title: %<%Y-%m-%d>\n"))))

  ;;   ;; Function to capture quotes from pdf
  ;;   (defun org-roam-capture-pdf-active-region ()
  ;;     (let* ((pdf-buf-name (plist-get org-capture-plist :original-buffer))
  ;;            (pdf-buf (get-buffer pdf-buf-name)))
  ;;       (if (buffer-live-p pdf-buf)
  ;;           (with-current-buffer pdf-buf
  ;;             (car (pdf-view-active-region-text)))
  ;;         (user-error "Buffer %S not alive" pdf-buf-name)))
  )

(use-package! pdf-occur :commands (pdf-occur-global-minor-mode))
(use-package! pdf-history :commands (pdf-history-minor-mode))
(use-package! pdf-links :commands (pdf-links-minor-mode))
(use-package! pdf-outline :commands (pdf-outline-minor-mode))
(use-package! pdf-annot :commands (pdf-annot-minor-mode))
(use-package! pdf-sync :commands (pdf-sync-minor-mode))

(after! persp-mode
  (setq persp-emacsclient-init-frame-behaviour-override nil)
  (defun display-workspaces-in-minibuffer ()
    (with-current-buffer " *Minibuf-0*"
      (erase-buffer)
      (insert (+workspace--tabline))))
  (run-with-idle-timer 1 t #'display-workspaces-in-minibuffer)
  (+workspace/display))

(setq +workspaces-switch-project-function #'dired)

(use-package! proced
  :defer t
  :init
  (setq proced-auto-update-flag t
        proced-auto-update-interval 1
        proced-descend t))

(after! projectile
  (setq ;; projectile-switch-project-action 'projectile-dired
        projectile-enable-caching t
        projectile-project-search-path '(("~/Projects" . 1))
        ;; Follow suggestion to reorder root functions to find the .projectile file
        ;; https://old.reddit.com/r/emacs/comments/920psp/projectile_ignoring_projectile_files/
        ;; projectile-project-root-files-functions #'(projectile-root-top-down
        ;;                                            projectile-root-top-down-recurring
        ;;                                            projectile-root-bottom-up
        ;;                                            projectile-root-local)
        ))

(use-package! rainbow-mode
  :hook
  ((prog-mode . rainbow-mode)
   (org-mode . rainbow-mode)))

(after! evil-collection
  (after! trashed
    (evil-collection-trashed-setup)))

(setq +treemacs-git-mode 'deferred
      ;; treemacs-collapse-dirs 5
      ;; treemacs-eldoc-display t
      ;; treemacs-is-never-other-window nil
      treemacs-position 'right
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

  (treemacs-follow-mode)
  (treemacs-filewatch-mode))

(use-package! turkish :commands (turkish-mode))

(after! vterm
  (setq vterm-max-scrollback 100000))

(use-package! vundo
  :bind ("C-x u" . vundo)
  :config
  (setq vundo-glyph-alist vundo-unicode-symbols))

(setq which-key-allow-multiple-replacements t)
(after! which-key
  (pushnew!
   which-key-replacement-alist
   '(("" . "\\`+?evil[-:]?\\(?:a-\\)?\\(.*\\)") . (nil . " \\1"))
   '(("\\`g s" . "\\`evilem--?motion-\\(.*\\)") . (nil . " \\1"))))

;; text mode directory tree
(use-package! ztree
  :defer t
  :init
  (setq ztree-draw-unicode-lines t
        ztree-show-number-of-children t))

;; different configs on different computers
;; (require (intern (system-name)) nil 'noerror)
