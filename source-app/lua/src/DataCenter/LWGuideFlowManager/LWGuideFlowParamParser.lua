local parser = {}

function parser.Parse(type, raw)
  local output
  if type == "string" then
    output = tostring(raw)
  elseif type == "number" then
    output = tonumber(raw)
  elseif type == "bool" then
    output = string.lower(raw) == "true"
  else
    return nil, "unknown type [" .. type .. "]"
  end
  return output, nil
end

function parser:ParseEntryWithParams(rawParamsStr, headKey, bodyKey)
  local paramsIdx = string.find(rawParamsStr, "(", 1, true)
  if paramsIdx ~= nil then
    self[headKey] = string.sub(rawParamsStr, 1, paramsIdx - 1)
    self[bodyKey] = {}
    local nextEventParamsArr = string.split(string.sub(rawParamsStr, paramsIdx + 1, -2), ";")
    for i = 1, #nextEventParamsArr do
      local arr = string.split(nextEventParamsArr[i], "_")
      local output, error = parser.Parse(arr[1], arr[2])
      if error ~= nil then
        printError("wait_for_event next event params type error! " .. error)
        return nil
      else
        arr[2] = output
      end
      local paramKey = arr[3] ~= nil and arr[3] or i
      self[bodyKey][paramKey] = arr[2]
    end
  end
end

return parser
