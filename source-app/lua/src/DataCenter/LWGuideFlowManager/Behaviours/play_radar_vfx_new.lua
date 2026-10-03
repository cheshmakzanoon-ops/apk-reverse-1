local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {
    "string",
    "windowNameGuide"
  },
  {"string", "uiLayer"},
  {"number", "radarId"},
  {"number", "offsetX"},
  {"number", "offsetY"},
  {"number", "scaleX"},
  {"number", "scaleY"},
  {"number", "scaleZ"},
  {"number", "duration"},
  {"string", "textKey"}
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
    999
  }
}

function behaviour:__Awake()
  self.offset = Vector3(self.offsetX, self.offsetY, 0)
  self.scale = Vector3(self.scaleX, self.scaleY, self.scaleZ)
end

function behaviour:Begin()
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, self.blockerExpireTime)
  self:LoadScript()
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
  self.vfxHandle = nil
end

function behaviour:LoadScript()
  local Layer = UILayer[self.uiLayer]
  assert(Layer, "play_radar_vfx invalid ui layer:" .. self.uiLayer)
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIDetectEvent)
  if not window or window.State ~= 2 then
    self:LogError("play_radar_vfx window not found or not opened:")
    self.done = true
    return
  end
  local pos
  if window.View and window.View.GetRadarIdPos then
    pos = window.View:GetRadarIdPos(self.radarId)
  end
  if pos == nil or pos.x == nil then
    self.done = true
    return
  end
  if not string.IsNullOrEmpty(self.windowNameGuide) then
    local param = {}
    param.position = pos + self.offset
    param.textKey = self.textKey
    param.scale = self.scale
    UIManager:GetInstance():OpenWindow(self.windowNameGuide, {anim = true}, param)
  end
  if self.exitAtBegin and self.duration > 0 then
    self.done = true
  else
    self.timer = self.duration
  end
end

return behaviour
