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
  go = { ';',':=',';'},
  rust = {';','::',';'},
  -- also support mulitple rules
  go = {
    { ';',':=',';'},
    { '/',':=',';'},
  }
})
```

## Licenese MIT
