local base = {}
local parser = require("DataCenter.LWGuideFlowManager.LWGuideFlowParamParser")

function base.TakeShot(condition, flowId, paramsStr)
  if condition.params == nil or #condition.params == 0 then
    return nil, nil
  end
  if string.IsNullOrEmpty(paramsStr) then
    return nil, "paramsStr is nil!"
  end
  local params = string.split(paramsStr, ",")
  if #params ~= #condition.params then
    return nil, "params count error. need " .. #condition.params .. " params but got " .. #params
  end
  if 8 < #params then
    return nil, "params count error. only support 8 or less params"
  end
  if condition.ParseParams ~= nil then
    params = condition.ParseParams(params)
  else
    for i = 1, #condition.params do
      local output, error = parser.Parse(condition.params[i], params[i])
      if error ~= nil then
        return nil, "params type error. " .. error
      else
        params[i] = output
      end
    end
  end
  return params, nil
end

function base.Check(condition, params)
  if params == nil or #params == 0 then
    return condition.__Check()
  elseif #params == 1 then
    return condition.__Check(params[1])
  elseif #params == 2 then
    return condition.__Check(params[1], params[2])
  elseif #params == 3 then
    return condition.__Check(params[1], params[2], params[3])
  elseif #params == 4 then
    return condition.__Check(params[1], params[2], params[3], params[4])
  elseif #params == 5 then
    return condition.__Check(params[1], params[2], params[3], params[4], params[5])
  elseif #params == 6 then
    return condition.__Check(params[1], params[2], params[3], params[4], params[5], params[6])
  elseif #params == 7 then
    return condition.__Check(params[1], params[2], params[3], params[4], params[5], params[6], params[7])
  elseif #params == 8 then
    return condition.__Check(params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8])
  else
    printError("condition<" .. condition.name .. "> params count error! too many params @" .. condition.name .. " has " .. #condition.params .. " params")
    return false
  end
end

function base.CompareNumber(condition, src, tar, comparisonType)
  if comparisonType == ComparisonType.Equal then
    return src == tar
  elseif comparisonType == ComparisonType.NotEqual then
    return src ~= tar
  elseif comparisonType == ComparisonType.Greater then
    return tar < src
  elseif comparisonType == ComparisonType.GreaterEqual then
    return tar <= src
  elseif comparisonType == ComparisonType.Less then
    return src < tar
  elseif comparisonType == ComparisonType.LessEqual then
    return src <= tar
  else
    printError("condition<" .. condition.name .. "> comparisonType error! @" .. condition.name .. " has " .. #condition.params .. " params")
    return false
  end
end

return base
