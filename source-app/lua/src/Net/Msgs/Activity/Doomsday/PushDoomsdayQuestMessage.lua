local PushDoomsdayQuestMessage = BaseClass("PushDoomsdayQuestMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWDoomsdayManager:OnSingleQuestUpdate(t)
  end
end

PushDoomsdayQuestMessage.OnCreate = OnCreate
PushDoomsdayQuestMessage.HandleMessage = HandleMessage
return PushDoomsdayQuestMessage
