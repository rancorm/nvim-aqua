--
-- Initialize plugin and setup observer
--
local M = {}

function na_bail(job, status, event)
  vim.notify("Observer bailed: " .. status)
end

function na_change(channel, data, name)
  if type(data) == "table" then
    for key, value in pairs(data) do
      -- Only interested in the first key
      if key == 1 then
	-- Call the users change function if set
	if type(M.change) == "function" then
	  M.change(value)
	else
	  vim.notify("UI change detected. No change function set")
	end
      end
    end
  end
end

function na_cmd(command)
  local handle = io.popen(command)
  local result = handle:read("*a")
  handle:close()
  return result
end

function na_macos_major()
  local version = na_cmd("sw_vers -productVersion")
  local major = string.match(version, "(%d+)%.")
  
  return major
end

function setup(opts)
  local opts = opts or {}
  local plugin_path = debug.getinfo(1).source:sub(2):match("(.*/)")
  local observer_path = plugin_path .. "../scripts/observer.swift"
  local major = na_macos_major()

  -- Check if we are running on macOS 14, if so use the sonoma observer
  -- with workarounds for linking issues
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
  if opts.change then
    M.change = opts.change
  end

  -- Convince return module for user to call setup and
  -- get access to module
  return M
end 

M.change = nil
M.setup = setup

return M
