local ActivityDoomsdayQuestRankInfoMessage = BaseClass("ActivityDoomsdayQuestRankInfoMessage", SFSBaseMessage)
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
    DataCenter.LWDoomsdayManager:OnGetRankInfo(t)
  end
end

ActivityDoomsdayQuestRankInfoMessage.OnCreate = OnCreate
ActivityDoomsdayQuestRankInfoMessage.HandleMessage = HandleMessage
return ActivityDoomsdayQuestRankInfoMessage
