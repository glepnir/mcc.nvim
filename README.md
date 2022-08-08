<center>
<h1> Magic Char </h1>
</center>

## Install

```lua
packer.use({ 'glepnir/mcc.nvim'})
```

## Usage

config your filetypes with char rules

```lua
require('mcc').setup({
  c = {'-','->','-'},
  -- also like this
  c = {'-','->','-','-----','-------'},
  go = { ';',':=',';'},
  rust = {';','::',';'},
  -- not signal char anything you want change
  rust = { '88','::','88'},
  -- also support mulitple rules
  go = {
    { ';',':=',';'},
    { '/',':=',';'},
  }
})
```

## Show

![image](https://user-images.githubusercontent.com/41671631/182332280-813dd765-6b77-4f56-904d-0053aaa22c80.gif)

## Licenese MIT
