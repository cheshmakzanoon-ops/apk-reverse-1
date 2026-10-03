local SurvivorVisitorInfoMessage = BaseClass("SurvivorVisitorInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, actId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", actId)
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

SurvivorVisitorInfoMessage.OnCreate = OnCreate
SurvivorVisitorInfoMessage.HandleMessage = HandleMessage
return SurvivorVisitorInfoMessage
