local ActivityDoomsdayQuestInfoMessage = BaseClass("ActivityDoomsdayQuestInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWDoomsdayManager:OnGetQuestInfo(t)
  end
end

ActivityDoomsdayQuestInfoMessage.OnCreate = OnCreate
ActivityDoomsdayQuestInfoMessage.HandleMessage = HandleMessage
return ActivityDoomsdayQuestInfoMessage
