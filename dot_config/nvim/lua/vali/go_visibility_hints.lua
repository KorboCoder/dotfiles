local M = {}

local ns = vim.api.nvim_create_namespace("go_visibility_hints")
local enabled_bufs = {}

-- Customize visuals here
local SYMBOLS = {
  exported = "◆",
  unexported = "◇",
}
local HLGROUPS = {
  exported = "GoExportedHint",
  unexported = "GoUnexportedHint",
}

-- Create highlight groups (call once)
local function ensure_hlgroups()
  if vim.fn.hlexists(HLGROUPS.exported) == 0 then
    vim.api.nvim_set_hl(0, HLGROUPS.exported, { fg = "#a6da95", default = true })
  end
  if vim.fn.hlexists(HLGROUPS.unexported) == 0 then
    vim.api.nvim_set_hl(0, HLGROUPS.unexported, { fg = "#a6da95", default = true })
  end
end

local function is_go(bufnr)
  return vim.bo[bufnr].filetype == "go"
end

local function is_exported(name)
  local first = name:sub(1, 1)
  return first:match("%u") ~= nil
end

local function place_hints(bufnr)
  if not is_go(bufnr) then return end
  local parser = vim.treesitter.get_parser(bufnr, "go")
  if not parser then return end

  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  local tree = parser:parse()[1]
  if not tree then return end
  local root = tree:root()

  local ok, query = pcall(vim.treesitter.query.parse, "go", [[
;; Go - Package-level exportable identifiers only (excludes function-local declarations)

;; EXPORTED PACKAGE-LEVEL IDENTIFIERS (capitalized, package scope only)

;; Exported package-level functions
(source_file
  (function_declaration
    name: (identifier) @exported.function
    (#match? @exported.function "^[A-Z]")))

;; Exported package-level types
(source_file
  (type_declaration
    (type_spec
      name: (type_identifier) @exported.type
      (#match? @exported.type "^[A-Z]"))))

;; Exported package-level variables
(source_file
  (var_declaration
    (var_spec
      name: (identifier) @exported.variable
      (#match? @exported.variable "^[A-Z]"))))

;; Exported package-level constants
(source_file
  (const_declaration
    (const_spec
      name: (identifier) @exported.constant
      (#match? @exported.constant "^[A-Z]"))))

;; UNEXPORTED PACKAGE-LEVEL IDENTIFIERS (lowercase, package scope only)

;; Unexported package-level functions
(source_file
  (function_declaration
    name: (identifier) @unexported.function
    (#match? @unexported.function "^[a-z_]")))

;; Unexported package-level types
(source_file
  (type_declaration
    (type_spec
      name: (type_identifier) @unexported.type
      (#match? @unexported.type "^[a-z_]"))))

;; Unexported package-level variables
(source_file
  (var_declaration
    (var_spec
      name: (identifier) @unexported.variable
      (#match? @unexported.variable "^[a-z_]"))))

;; Unexported package-level constants
(source_file
  (const_declaration
    (const_spec
      name: (identifier) @unexported.constant
      (#match? @unexported.constant "^[a-z_]"))))

;; METHODS (always associated with types, exportability depends on method name)


;; STRUCT FIELDS AND INTERFACE METHODS (exportability depends on name)

;; Exported struct fields
(field_declaration
  name: (field_identifier) @exported.field
  (#match? @exported.field "^[A-Z]"))

;; Unexported struct fields  
(field_declaration
  name: (field_identifier) @unexported.field
  (#match? @unexported.field "^[a-z_]"))

  ]])
    if not ok or not query then return end

    for id, node in query:iter_captures(root, bufnr, 0, -1) do
        local cap = query.captures[id]
        local sr, sc, er, ec = node:range()
        local name = vim.treesitter.get_node_text(node, bufnr)
        if name and name:match("^[%a_]") then
            local exported = string.sub(cap, 1, 8) == "exported"
            local virt_text = { { (exported and SYMBOLS.exported or SYMBOLS.unexported), exported and HLGROUPS.exported or HLGROUPS.unexported } }
            vim.api.nvim_buf_set_extmark(bufnr, ns, sr, sc, {
                virt_text = virt_text,
                virt_text_pos = "inline",
                hl_mode = "combine",
            })
        end
    end
end

function M.refresh(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if enabled_bufs[bufnr] then
    vim.schedule(function() place_hints(bufnr) end)
  end
end

function M.enable(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  ensure_hlgroups()
  enabled_bufs[bufnr] = true
  M.refresh(bufnr)
end

function M.disable(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  enabled_bufs[bufnr] = nil
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
end

function M.toggle(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if enabled_bufs[bufnr] then
    M.disable(bufnr)
  else
    M.enable(bufnr)
  end
end

function M.setup(opts)
  opts = opts or {}
  if opts.symbols then
    SYMBOLS.exported = opts.symbols.exported or SYMBOLS.exported
    SYMBOLS.unexported = opts.symbols.unexported or SYMBOLS.unexported
  end
  if opts.colors then
    if opts.colors.exported then vim.api.nvim_set_hl(0, HLGROUPS.exported, opts.colors.exported) end
    if opts.colors.unexported then vim.api.nvim_set_hl(0, HLGROUPS.unexported, opts.colors.unexported) end
  end

  ensure_hlgroups()

  local aug = vim.api.nvim_create_augroup("GoVisibilityHints", { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "TextChanged", "TextChangedI" }, {
    group = aug,
    pattern = "*.go",
    callback = function(args)
      M.refresh(args.buf)
    end,
  })
end

return M
