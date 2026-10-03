local SurvivalVipGiftGetInfoMessage = BaseClass("SurvivalVipGiftGetInfoMessage", SFSBaseMessage)
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
    DataCenter.VipGiftActDataManager:OnGetInfo(message)
  end
end

SurvivalVipGiftGetInfoMessage.OnCreate = OnCreate
SurvivalVipGiftGetInfoMessage.HandleMessage = HandleMessage
return SurvivalVipGiftGetInfoMessage
