local base = require("DataCenter.LWGuideFlowManager.Behaviours.__click_base")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
local parser = require("DataCenter.LWGuideFlowManager.LWGuideFlowParamParser")
behaviour.params = {
  {"string", "windowName"},
  {"string", "funcName"}
}
behaviour.params = table.mergeArray(behaviour.params, base.params)

function behaviour:__Awake()
  base.__Awake(self)
  parser.ParseEntryWithParams(self, self.funcName, "funcName", "funcParams")
end

function behaviour:__SetupMaskParams(maskParams)
  local window = UIManager:GetInstance():GetWindow(self.windowName)
  if window == nil then
    return "window not found:" .. self.windowName
  end
  if window.State ~= 2 then
    return "window not opened:" .. self.windowName
  end
  local func = window.View[self.funcName]
  if func == nil then
    return "view function not found:" .. self.windowName .. "->" .. self.funcName
  end
  local comp
  local nparams = debug.getinfo(func).nparams
  if nparams == 1 then
    comp = func(window.View)
  elseif nparams == 2 then
    comp = func(window.View, self.funcParams[1])
  elseif nparams == 3 then
    comp = func(window.View, self.funcParams[1], self.funcParams[2])
  elseif nparams == 4 then
    comp = func(window.View, self.funcParams[1], self.funcParams[2], self.funcParams[3])
  elseif nparams == 5 then
    comp = func(window.View, self.funcParams[1], self.funcParams[2], self.funcParams[3], self.funcParams[4])
  elseif nparams == 6 then
    comp = func(window.View, self.funcParams[1], self.funcParams[2], self.funcParams[3], self.funcParams[4], self.funcParams[5])
  elseif nparams == 7 then
    comp = func(window.View, self.funcParams[1], self.funcParams[2], self.funcParams[3], self.funcParams[4], self.funcParams[5], self.funcParams[6])
  elseif nparams == 8 then
    comp = func(window.View, self.funcParams[1], self.funcParams[2], self.funcParams[3], self.funcParams[4], self.funcParams[5], self.funcParams[6], self.funcParams[7])
  else
    return "not support more than 8 params:" .. self.windowName .. "->" .. self.funcName .. "(" .. table.concat(self.funcParams, ",") .. ")"
  end
  if IsNull(comp) then
    return "comp not found:" .. self.windowName .. "->" .. self.funcName .. "(" .. table.concat(self.funcParams, ",") .. ")"
  end
  maskParams.target = comp
  return nil
end

return behaviour
