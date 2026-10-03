local cmd = {}

function cmd.Help()
  local content = ""
  content = content .. "dump <category> [filter1] [filter2] ... \230\137\147\229\141\176\230\140\135\229\174\154\230\184\184\230\136\143\230\149\176\230\141\174\n"
  content = content .. "<category> \230\149\176\230\141\174\231\177\187\229\136\171\239\188\140\229\143\175\233\128\137\229\128\188\239\188\154\n"
  content = content .. "   - building \229\187\186\231\173\145\230\149\176\230\141\174\n"
  content = content .. "   - item \233\129\147\229\133\183\230\149\176\230\141\174\n"
  content = content .. "   - cityzone \229\159\142\229\184\130\229\140\186\229\159\159\230\149\176\230\141\174\n"
  content = content .. "   - task \228\187\187\229\138\161\230\149\176\230\141\174\n"
  content = content .. "   - radar \233\155\183\232\190\190\228\186\139\228\187\182\230\149\176\230\141\174\n"
  content = content .. "[filter] \232\191\135\230\187\164\230\157\161\228\187\182\239\188\140\229\143\175\233\128\137\239\188\140\229\164\154\228\184\170\230\157\161\228\187\182\233\151\180\228\184\186\228\184\148\233\128\187\232\190\145\239\188\140\230\160\188\229\188\143: <key> <operator> <value>\n"
  content = content .. "   - <key> \229\173\151\230\174\181\229\144\141\239\188\140\233\146\136\229\175\185\229\133\183\228\189\147\231\177\187\229\158\139Data\229\161\171\229\134\153\n"
  content = content .. "   - <operator> \230\175\148\232\190\131\231\172\166\229\143\183\239\188\140\229\143\175\233\128\137\229\128\188\239\188\154=, <, >, <=, >=\n"
  content = content .. "   - <value> \230\175\148\232\190\131\229\128\188\239\188\140\229\143\175\233\128\137\229\128\188\239\188\154\230\149\176\229\173\151\239\188\140\229\173\151\231\172\166\228\184\178\239\188\140\229\184\131\229\176\148\229\128\188\n"
  return content
end

function cmd.Execute(arr)
  local category = arr[2]
  local filters = {}
  for i = 3, #arr do
    local filter, error = cmd.ParseFilter(arr[i])
    if error ~= nil then
      return error
    end
    table.insert(filters, filter)
  end
  if category == "-h" or category == "help" then
    return cmd.HELP
  end
  local datas
  if category == "building" then
    datas = DataCenter.BuildManager.allBuilding
  elseif category == "item" then
    datas = DataCenter.ItemData.ItemInfos
  elseif category == "land" then
    datas = DataCenter.LandLockManager.landLockDataDict
  elseif category == "task" then
    datas = DataCenter.ChapterTaskManager.chapterSubTaskArray
  elseif category == "radar" then
    datas = DataCenter.RadarCenterDataManager.events
  else
    return "unknown category [" .. category .. "]. -h for help"
  end
  return cmd.DumpDatas(datas, filters)
end

function cmd.DumpDatas(datas, filters)
  if datas == nil then
    return "no datas"
  end
  local output = ""
  for _, data in pairs(datas) do
    for _, filter in pairs(filters) do
      local pass, error = cmd.CheckByFilter(data, filter)
      if error ~= nil then
        return error
      elseif not pass then
        goto lbl_32
      end
    end
    output = output .. table.dump(data)
    ::lbl_32::
  end
  return output
end

function cmd.CheckByFilter(data, filter)
  local key = filter[1]
  local operator = filter[2]
  local value = filter[3]
  local pass = false
  if operator == "=" then
    pass = data[key] == value
  elseif operator == "<" then
    pass = value > data[key]
  elseif operator == ">" then
    pass = value < data[key]
  elseif operator == "<=" then
    pass = value >= data[key]
  elseif operator == ">=" then
    pass = value <= data[key]
  else
    return nil, "Unknown operator <" .. operator .. ">. -h for help"
  end
  return pass
end

function cmd.ParseFilter(str)
  str = string.trim(str)
  local operator = string.match(str, "([%<%>%=]+)")
  local key = string.sub(str, 1, string.find(str, operator) - 1)
  local value = string.sub(str, string.find(str, operator) + string.len(operator))
  if string.startswith(value, "\"") and string.endswith(value, "\"") then
    value = string.sub(value, 2, -2)
  elseif string.startswith(value, "'") and string.endswith(value, "'") then
    value = string.sub(value, 2, -2)
  elseif value == "true" then
    value = true
  elseif value == "false" then
    value = false
  else
    nValue = tonumber(value)
    if nValue == nil then
      return nil, "Invalid value (" .. value .. "). -h for help"
    else
      value = nValue
    end
  end
  return {
    key,
    operator,
    value
  }
end

return cmd
