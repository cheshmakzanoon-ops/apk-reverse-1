local base = require("Scene.Monopoly.Performance.Behaviours.MonopolyBehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {"number", "animType"}
}

function behaviour:__Awake()
  if self.animType == 1 then
    self.animType = UIMainAnimType.AllHide
  elseif self.animType == 2 then
    self.animType = UIMainAnimType.AllShow
  else
    self:LogError("invalide animType:" .. self.animType)
  end
end

local BLOCKER_EXPIRE_TIME = 0.5

function behaviour:Begin()
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, BLOCKER_EXPIRE_TIME)
  UIManager:GetInstance():GetWindow(UIWindowNames.UIMain).View:PlayAnim(self.animType, true)
end

function behaviour:OnDestroy()
  UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
  self.__blockerHandleID = nil
end

return behaviour
