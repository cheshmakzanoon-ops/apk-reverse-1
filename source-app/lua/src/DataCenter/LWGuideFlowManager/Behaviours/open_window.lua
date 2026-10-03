local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
local parser = require("DataCenter.LWGuideFlowManager.LWGuideFlowParamParser")
behaviour.params = {
  {"string", "windowName"}
}
behaviour.optionalParams = {
  {
    "string",
    "windowParamsStr",
    "none"
  },
  {
    "bool",
    "unpackParams",
    false
  },
  {
    "bool",
    "windowAnim",
    true
  },
  {
    "string",
    "mainUIAnim",
    "none"
  },
  {
    "bool",
    "closeWhenClear",
    true
  }
}

function behaviour:__Awake()
  if self.windowParamsStr == "none" then
    return
  end
  parser.ParseEntryWithParams(self, self.windowParamsStr, "windowParamsKey", "windowParamsBody")
end

function behaviour:Begin()
  if string.IsNullOrEmpty(self.windowName) then
    self:LogError("windowName is empty")
    return
  end
  UIManager:GetInstance():OpenWindow(self.windowName, {
    anim = self.windowAnim,
    UIMainAnim = UIMainAnimType[self.mainUIAnim]
  }, self.unpackParams and SafeUnpack(self.windowParamsBody) or self.windowParamsBody)
  self.done = true
end

function behaviour:Clear()
  if self.closeWhenClear and not string.IsNullOrEmpty(self.windowName) then
    UIManager:GetInstance():DestroyWindow(self.windowName)
  end
end

return behaviour
