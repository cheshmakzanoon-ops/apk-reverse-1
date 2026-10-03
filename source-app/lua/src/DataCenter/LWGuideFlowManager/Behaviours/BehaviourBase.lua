local base = {}
local parser = require("DataCenter.LWGuideFlowManager.LWGuideFlowParamParser")

function base.Instantiate(behaviourName, flowId, paramsStr)
  local success, behaviour = pcall(require, "DataCenter.LWGuideFlowManager.Behaviours." .. behaviourName)
  if not success then
    Logger.LogError(string.format("[\229\188\149\229\175\188\233\148\153\232\175\175]\229\136\155\229\187\186\229\188\149\229\175\188\232\161\140\228\184\186\239\188\154%s\229\164\177\232\180\165\239\188\129\230\151\160\230\179\149\230\137\190\229\136\176\229\175\185\229\186\148\231\154\132\232\132\154\230\156\172~ \229\188\149\229\175\188id = %s", behaviourName, flowId))
    behaviour = nil
  end
  if behaviour == nil then
    Logger.LogError("behaviour<" .. behaviourName .. "> not found! @" .. flowId)
    return nil
  end
  local metatbl = {__index = behaviour}
  local inst = setmetatable({}, metatbl)
  inst.name = behaviourName
  inst.flowId = flowId
  if (behaviour.params == nil or #behaviour.params == 0) and (behaviour.optionalParams == nil or #behaviour.optionalParams == 0) then
    return inst
  end
  if IsNull(paramsStr) then
    paramsStr = ""
  end
  local params = string.split(paramsStr, ",")
  if #params < #behaviour.params then
    Logger.LogError("behaviour<" .. behaviourName .. "> params count error! need " .. #behaviour.params .. " but got " .. #params .. " @" .. flowId .. "|" .. paramsStr)
    return nil
  end
  if behaviour.ParseParams ~= nil then
    params = behaviour.ParseParams(params)
  else
    if behaviour.params ~= nil and #behaviour.params > 0 then
      for i = 1, #behaviour.params do
        local output, error = parser.Parse(behaviour.params[i][1], params[i])
        if error ~= nil then
          printError("behaviour<" .. behaviourName .. "> params type error! " .. error .. " @" .. flowId .. "|" .. paramsStr)
          return nil
        else
          params[i] = output
        end
      end
    end
    if behaviour.optionalParams ~= nil and 0 < #behaviour.optionalParams then
      local idxOffset = behaviour.params ~= nil and #behaviour.params or 0
      for i = 1, #behaviour.optionalParams do
        if params[i + idxOffset] == nil then
          params[i + idxOffset] = behaviour.optionalParams[i][3]
        else
          local output, error = parser.Parse(behaviour.optionalParams[i][1], params[i + idxOffset])
          if error ~= nil then
            printError("behaviour<" .. behaviourName .. "> params type error! " .. error .. " @" .. flowId .. "|" .. paramsStr)
            return nil
          else
            params[i + idxOffset] = output
          end
        end
      end
    end
  end
  if behaviour.params ~= nil and #behaviour.params > 0 then
    for i = 1, #behaviour.params do
      if inst[behaviour.params[i][2]] ~= nil then
        printError("behaviour<" .. behaviourName .. "> params name error! name [" .. behaviour.params[i][2] .. "] already exists @" .. flowId .. "|" .. paramsStr)
        return nil
      end
      inst[behaviour.params[i][2]] = params[i]
    end
  end
  if behaviour.optionalParams ~= nil and 0 < #behaviour.optionalParams then
    local idxOffset = behaviour.params ~= nil and #behaviour.params or 0
    for i = 1, #behaviour.optionalParams do
      if inst[behaviour.optionalParams[i][2]] ~= nil then
        printError("behaviour<" .. behaviourName .. "> params name error! name [" .. behaviour.optionalParams[i][2] .. "] already exists @" .. flowId .. "|" .. paramsStr)
        return nil
      end
      inst[behaviour.optionalParams[i][2]] = params[i + idxOffset]
    end
  end
  if inst.__Awake then
    inst:__Awake()
  end
  return inst
end

function base.LogError(behaviour, msg)
  printError("@" .. behaviour.flowId .. " behaviour<" .. behaviour.name .. "> " .. msg)
end

function base.FormatStringParamWithContext(behaviour, stringParam)
  local text = stringParam
  local paramName = string.match(text, "{(.-)}")
  while paramName do
    local ctx_arr = string.split(paramName, "^")
    local ctx_v = behaviour.context
    for _, ctx_k in ipairs(ctx_arr) do
      ctx_k = tonumber(ctx_k) or ctx_k
      ctx_v = ctx_v[ctx_k]
      if ctx_v == nil then
        behaviour:LogError("BehaviourBase.FormatStringParamWithContext Error! invalid paramName:" .. paramName)
        return nil
      end
    end
    text = string.gsub(text, string.format("{%s}", paramName), ctx_v)
    paramName = string.match(text, "{(.-)}")
  end
  return text
end

return base
