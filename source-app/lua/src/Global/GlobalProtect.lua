local M = {}
local const_lock_free = 0
local const_lock_log_only = 1
local const_lock_intercept = 2
local locked = const_lock_free
local initialized = false
local whitelist_func = {}

local function AddGlobalWriteWhitelist(fn)
  table.insert(whitelist_func, fn)
end

local function InitWriteWhitelist()
  AddGlobalWriteWhitelist(function(key)
    return key:match("^LuaDatatable%.") ~= nil
  end)
  AddGlobalWriteWhitelist(function(key)
    return key == "NameCount"
  end)
  AddGlobalWriteWhitelist(function(key)
    return key == "RedMat" or key == "WhiteMat"
  end)
end

local function InWhitelist(key)
  for _, fn in ipairs(whitelist_func) do
    if fn(key) then
      return true
    end
  end
  return false
end

function M.Init()
  if initialized then
    return
  end
  initialized = true
  InitWriteWhitelist()
  setmetatable(_G, {
    __newindex = function(t, key, value)
      local key_str = tostring(key)
      if locked == const_lock_free or InWhitelist(key_str) then
        rawset(t, key, value)
      else
        Logger.LogError("Lua \229\133\168\229\177\128\229\143\152\233\135\143 '" .. tostring(key) .. "' \228\184\141\229\143\175<\230\150\176\229\162\158/\228\191\174\230\148\185>")
        if locked == const_lock_log_only then
          rawset(t, key, value)
        end
      end
    end,
    __index = function(t, key)
      return rawget(t, key)
    end
  })
end

function M.LockGlobal(type)
  Logger.LogInfo("Start protect lua global!" .. tostring(locked) .. "->" .. tostring(type))
  locked = type
end

M.const_lock_free = const_lock_free
M.const_lock_log_only = const_lock_log_only
M.const_lock_intercept = const_lock_intercept
return M
