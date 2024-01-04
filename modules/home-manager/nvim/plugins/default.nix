{ lib, ... }: {
  imports = [
    ./coc
    ./fzf
    ./lualine-nvim
    ./nvim-tree
    ./telescope
    ./theme
    ./treesitter
    ./vim-closetag
  ];
}
