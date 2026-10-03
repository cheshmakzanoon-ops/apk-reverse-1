local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {"string", "resPath"},
  {"string", "uiLayer"},
  {"number", "radarId"},
  {"number", "offsetX"},
  {"number", "offsetY"},
  {"number", "scaleX"},
  {"number", "scaleY"},
  {"number", "scaleZ"},
  {"number", "duration"}
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
  self.vfxHandle = DataCenter.LWGuideVFXManager:InstantiateAsync(self.resPath, self.OnVfxLoaded, self, self.duration, GuideVFXPriority.High)
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

function behaviour:OnVfxLoaded(handle)
  if handle.isError then
    self:LogError("play_radar_vfx load res failed:" .. self.resPath)
    self.done = true
    return
  end
  local Layer = UILayer[self.uiLayer]
  assert(Layer, "play_radar_vfx invalid ui layer:" .. self.uiLayer)
  handle.gameObject.transform:SetParent(UIManager:GetInstance():GetLayer(Layer.Name).transform, false)
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIDetectEvent)
  if not window or window.State ~= 2 then
    self:LogError("play_radar_vfx window not found or not opened:")
    self.done = true
    if not IsNull(handle) then
      handle:Destroy()
    end
    return
  end
  local pos
  if window.View and window.View.GetRadarIdPos then
    pos = window.View:GetRadarIdPos(self.radarId)
  end
  if pos == nil or pos.x == nil then
    self.done = true
    if not IsNull(handle) then
      handle:Destroy()
    end
    return
  end
  handle.gameObject.transform.position = pos + self.offset
  handle.gameObject.transform.localScale = self.scale
  if self.exitAtBegin and self.duration > 0 then
    self.done = true
  else
    self.timer = self.duration
  end
end

return behaviour
