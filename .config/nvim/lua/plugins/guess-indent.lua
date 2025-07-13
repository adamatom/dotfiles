return {
  {
    -- Detect tabstop and shiftwidth automatically
    'NMAC427/guess-indent.nvim',
    config = function() require('guess-indent').setup {} end
  },
}
