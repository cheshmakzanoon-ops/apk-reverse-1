local SurvivalVipGiftReceiveFreeMessage = BaseClass("SurvivalVipGiftReceiveFreeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local EventManager = _ENV.EventManager
local EventId = _ENV.EventId
local DataCenter = _ENV.DataCenter
local toInt = _ENV.toInt

local function OnCreate(self, actId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", actId)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    local actId = toInt and toInt(message.activityId) or tonumber(message.activityId) or 0
    EventManager:Broadcast(EventId.SurvivalVipGiftFreeReward, {actId = actId, errCode = errCode})
  else
    DataCenter.VipGiftActDataManager:OnReceiveFree(message)
  end
end

SurvivalVipGiftReceiveFreeMessage.OnCreate = OnCreate
SurvivalVipGiftReceiveFreeMessage.HandleMessage = HandleMessage
return SurvivalVipGiftReceiveFreeMessage
