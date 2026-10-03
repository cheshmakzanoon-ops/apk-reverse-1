local SurvivorVisitorReceiveFreeMessage = BaseClass("SurvivorVisitorReceiveFreeMessage", SFSBaseMessage)
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
    DataCenter.SurvivorPackManager:OnRecReward(message)
  end
end

SurvivorVisitorReceiveFreeMessage.OnCreate = OnCreate
SurvivorVisitorReceiveFreeMessage.HandleMessage = HandleMessage
return SurvivorVisitorReceiveFreeMessage
