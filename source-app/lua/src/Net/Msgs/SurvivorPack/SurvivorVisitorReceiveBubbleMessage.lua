local SurvivorVisitorReceiveBubbleMessage = BaseClass("SurvivorVisitorReceiveBubbleMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, actId, id)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", actId)
  self.sfsObj:PutInt("id", id)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SurvivorPackManager:OnRecInfo(message)
  end
end

SurvivorVisitorReceiveBubbleMessage.OnCreate = OnCreate
SurvivorVisitorReceiveBubbleMessage.HandleMessage = HandleMessage
return SurvivorVisitorReceiveBubbleMessage
