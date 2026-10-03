local ActivityDoomsdayQuestRewardMessage = BaseClass("ActivityDoomsdayQuestRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("uuid", uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWDoomsdayManager:OnRecieveQuests(t)
  end
end

ActivityDoomsdayQuestRewardMessage.OnCreate = OnCreate
ActivityDoomsdayQuestRewardMessage.HandleMessage = HandleMessage
return ActivityDoomsdayQuestRewardMessage
