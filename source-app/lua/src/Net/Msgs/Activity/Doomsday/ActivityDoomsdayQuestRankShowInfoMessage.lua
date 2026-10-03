local ActivityDoomsdayQuestRankShowInfoMessage = BaseClass("ActivityDoomsdayQuestRankShowInfoMessage", SFSBaseMessage)
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
    DataCenter.LWDoomsdayManager:OnGetRankRewards(t)
  end
end

ActivityDoomsdayQuestRankShowInfoMessage.OnCreate = OnCreate
ActivityDoomsdayQuestRankShowInfoMessage.HandleMessage = HandleMessage
return ActivityDoomsdayQuestRankShowInfoMessage
