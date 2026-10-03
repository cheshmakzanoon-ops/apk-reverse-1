local Monitor = {
  called = {},
  originals = {}
}

local function processTable(t, path)
  path = path or ""
  for k, v in pairs(t) do
    local currentPath = path .. "." .. k
    if type(v) == "function" then
      if not Monitor.originals[v] then
        local function proxy(...)
          Monitor.called[v] = true
          
          return v(...)
        end
        
        t[k] = proxy
        Monitor.originals[v] = {
          path = currentPath,
          name = debug.getinfo(v, "n").name or "anonymous"
        }
      end
    elseif type(v) == "table" then
      processTable(v, currentPath)
    end
  end
end

function Monitor.track(moduleTable)
  table.clear(Monitor.called)
  table.clear(Monitor.originals)
  local metaTable = getmetatable(moduleTable)
  if metaTable then
    processTable(metaTable, path)
    return
  end
  processTable(moduleTable, "Root")
end

function Monitor.getUncalled()
  local results = {}
  for func, info in pairs(Monitor.originals) do
    if not Monitor.called[func] then
      table.insert(results, {
        path = info.path,
        name = info.name
      })
    end
  end
  return results
end

function Monitor.print()
  local sb = StringBuilder.New()
  sb:AppendLine("[Uncalled] \230\156\170\232\176\131\231\148\168\229\136\151\232\161\168\239\188\154")
  local uncalled = Monitor.getUncalled()
  for _, func in ipairs(uncalled) do
    sb:AppendLine(("\232\183\175\229\190\132\239\188\154%s"):format(func.path))
  end
  Logger.Log(sb:ToString())
end

return Monitor
