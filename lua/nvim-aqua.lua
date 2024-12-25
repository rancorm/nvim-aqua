--
-- Initialize plugin and setup observer
--
local M = {}

local function na_bail(job, status, event)
  vim.notify("Observer job: " .. job .. ", status: " .. status .. ", event: " .. event)
 end

local function na_change(_, data, _)
  if type(data) == "table" then
    for key, value in pairs(data) do
      -- Only interested in the first key
      if key == 1 then
	-- Call the users change function if set
	if M.change then
	  M.change(value)
	else
	  if not M.light and not M.dark then
	    vim.notify("UI change detected. No functions set.")
	  end
	end

	-- Call the light or dark function if set
	if value == "1" then
	  if M.light then
	    M.light()
	  end
	else
	  if M.dark then
	    M.dark()
	  end
	end
      end
    end
  end
end

local function na_cmd(command)
  local handle = io.popen(command)

  if handle ~= nil then
    local result = handle:read("*a")
    handle:close()
    return result
  end
end

local function na_ostype()
  local separator = package.config:sub(1, 1)

  if separator == '\\' then
      return "Windows"
  elseif separator == '/' then
    local os = na_cmd("uname")
    return os
  else
    return "Unknown"
  end
end

local function na_macos_major()
  local version = na_cmd("sw_vers -productVersion")
  local major = string.match(version, "(%d+)%.")

  return major
end

local function setup(opts)
  local opts = opts or {}
  local plugin_path = debug.getinfo(1).source:sub(2):match("(.*/)")
  local observer_path = plugin_path .. "../scripts/observer.swift"
  local os_type = na_ostype()

  -- Check if we are running not on macOS
  if string.find(os_type, "Darwin", 1, true) == nil then
    return
  end

  -- Get the major version of macOS
  local major = na_macos_major()

  -- If running on macOS 14, use Sonoma observer with linking workarounds.
  if major == "14" then
    observer_path = plugin_path .. "../scripts/observer-sonoma.swift"
  end

  -- Start the observer process
  M.observer_jid = vim.fn.jobstart(observer_path, {
      on_stdout = na_change,
      on_stderr = na_change,
      on_exit = na_bail,
      stdout_buffered = false
    })

  -- Set the change function if provided
  if type(opts.change) == "function" then
    M.change = opts.change
  end

  -- Set the light and dark functions if provided
  if type(opts.light) == "function" then
    M.light = opts.light
  end

  if type(opts.dark) == "function" then
    M.dark = opts.dark
  end

  -- Convince return module for user to call setup and
  -- get access to module
  return M
end

M.light = nil
M.dark = nil
M.change = nil
M.setup = setup

return M
