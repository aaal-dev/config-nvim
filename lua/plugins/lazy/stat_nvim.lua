local modules = {}

function modules.mode()
  local modes = {
    ["n"] = "N", ["no"] = "N", ["nov"] = "N", ["noV"] = "N",
    ["no\22"] = "N", ["niI"] = "N", ["niR"] = "N", ["niV"] = "N",
    ["nt"] = "N", ["ntT"] = "N", ["v"] = "V", ["vs"] = "V", ["V"] = "V",
    ["Vs"] = "V", ["\22"] = "V", ["\22s"] = "V", ["s"] = "S", ["S"] = "S",
    ["CTRL-S"] = "S", ["i"] = "I", ["ic"] = "I", ["ix"] = "I", ["R"] = "R",
    ["Rc"] = "R", ["Rx"] = "R", ["Rvc"] = "R", ["Rvx"] = "R", ["c"] = "C",
    ["cv"] = "E", ["r"] = "N", ["rm"] = "N", ["r?"] = "N", ["!"] = "N",
    ["t"] = "T"
  }
  local mode = modes[vim.api.nvim_get_mode().mode]
  return Stat.lib.set_highlight(mode, " " .. mode .. " ", true)
end

function modules.filetype()
  local filetype = string.upper(vim.bo.filetype)
  if filetype == "" then
    return ""
  end
  return Stat.lib.set_highlight("Filetype", " " .. filetype .. " ", true)
end

return {
    'leath-dub/stat.nvim',
    config = function()
        require('stat').setup({
            statusline = {
                modules.filetype,
                Stat.___,
                modules.mode,
                Stat.___,
            },
            theme = {
                ["N"] = { fg = "#2d353b", bg = "#83c092" },
                ["I"] = { fg = "#2d353b", bg = "#7fbbb3" },
                ["V"] = { fg = "#2d353b", bg = "#dbbc7f" },
                ["C"] = { fg = "#2d353b", bg = "#d699b6" },
                ["T"] = { fg = "#2d353b", bg = "#a7c080" },
                ["S"] = { fg = "#2d353b", bg = "#e67e80" },
                ["File"] = { fg = "#d3c6aa", bg = "#343f44" },
                ["Filetype"] = { fg = "#d3c6aa", bg = "#272e33" },
                ["GitDiffDeletion"] = { fg = "#e67e80", bg = "#232a2e" },
                ["GitDiffInsertion"] = { fg = "#a7c080", bg = "#232a2e" }
            },
        })
    end,
}
