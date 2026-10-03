local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {"string", "resPath"},
  {"number", "positionX"},
  {"number", "positionY"},
  {"number", "positionZ"},
  {"number", "eulerX"},
  {"number", "eulerY"},
  {"number", "eulerZ"},
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
  },
  {
    "number",
    "soundId",
    0
  }
}

function behaviour:__Awake()
  self.position = Vector3(self.positionX, self.positionY, self.positionZ)
  self.euler = Vector3(self.eulerX, self.eulerY, self.eulerZ)
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
    self:LogError("load res failed:" .. self.resPath)
    self.done = true
    return
  end
  handle.gameObject.transform.position = self.position
  handle.gameObject.transform.eulerAngles = self.euler
  handle.gameObject.transform.localScale = self.scale
  if self.soundId and self.soundId > 0 then
    DataCenter.LWSoundManager:PlaySound(self.soundId, false)
  end
  if self.exitAtBegin and 0 < self.duration then
    self.done = true
  else
    self.timer = self.duration
  end
  EventManager:GetInstance():Broadcast(EventId.NewbiesChapterVfxPlay, {
    resPath = self.resPath
  })
end

return behaviour
