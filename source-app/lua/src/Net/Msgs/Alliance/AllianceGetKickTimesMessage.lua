local AllianceGetKickTimesMessage = BaseClass("AllianceGetKickTimesMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.remainTimes then
    EventManager:GetInstance():Broadcast(EventId.UpdateAllianceKickTimes, t.remainTimes)
  end
end

AllianceGetKickTimesMessage.OnCreate = OnCreate
AllianceGetKickTimesMessage.HandleMessage = HandleMessage
return AllianceGetKickTimesMessage
