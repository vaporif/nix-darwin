local bookmarks = {}

local path_sep = package.config:sub(1, 1)
local home_path = os.getenv 'HOME'

require('yamb'):setup {
  -- Optional, the path ending with path seperator represents folder.
  bookmarks = bookmarks,
  -- Optional, recieve notification everytime you jump.
  jump_notify = true,
  -- Optional, the cli of fzf.
  cli = 'fzf',
  -- Optional, a string used for randomly generating keys, where the preceding characters have higher priority.
  keys = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',
  path = home_path .. '/.config/home-manager/yazi/bookmark',
}
