local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {"string", "windowName"},
  {"string", "compPath"},
  {"number", "offsetX"},
  {"number", "offsetY"},
  {"number", "scaleX"},
  {"number", "scaleY"},
  {"number", "scaleZ"},
  {"number", "duration"},
  {
    "string",
    "textKey",
    ""
  }
}
behaviour.optionalParams = {
  {
    "bool",
    "exitAtBegin",
    true
  },
  {
    "number",
    "blockerExpireTime",
    2
  }
}

function behaviour:__Awake()
  self.offset = Vector3(self.offsetX, self.offsetY, 0)
  self.scale = Vector3(self.scaleX, self.scaleY, self.scaleZ)
end

function behaviour:Begin()
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, self.blockerExpireTime)
  local window = UIManager:GetInstance():GetWindow(self.windowName)
  if not window or window.State ~= 2 then
    self:LogError("window not found or not opened:" .. self.windowName)
    self.done = true
    return
  end
  local finalCompPath = base.FormatStringParamWithContext(self, self.compPath)
  if not finalCompPath then
    self.done = true
    return
  end
  local comp = window.View.transform:Find(finalCompPath)
  if not comp then
    self:LogError("comp not found:" .. finalCompPath)
    self.done = true
    return
  end
  self:LoadScript(comp)
end

function behaviour:LoadScript(comp)
  if not string.IsNullOrEmpty(UIWindowNames.UIArrowFinger_New) then
    local param = {}
    if CommonUtil.IsArabicAutoMirrorOpen() then
      param.position = comp.position + Vector3.New(-1 * self.offset.x, self.offset.y, 0)
    else
      param.position = comp.position + self.offset
    end
    param.textKey = self.textKey
    param.scale = self.scale
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIArrowFinger_New, {anim = true}, param)
  end
  if self.exitAtBegin and 0 < self.duration then
    self.done = true
  else
    self.timer = self.duration
  end
end

function behaviour:Update(dt)
  if self.timer ~= nil and self.timer > 0 then
    self.timer = self.timer - dt
    if self.timer <= 0 then
      self.done = true
    end
  end
end

function behaviour:End()
  UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
  self.__blockerHandleID = nil
end

return behaviour
