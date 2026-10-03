local SurvivorVisitorReceiveScoreMessage = BaseClass("SurvivorVisitorReceiveScoreMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, actId, index)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", actId)
  self.sfsObj:PutInt("index", index)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SurvivorPackManager:OnRecReward(message)
  end
end

SurvivorVisitorReceiveScoreMessage.OnCreate = OnCreate
SurvivorVisitorReceiveScoreMessage.HandleMessage = HandleMessage
return SurvivorVisitorReceiveScoreMessage
