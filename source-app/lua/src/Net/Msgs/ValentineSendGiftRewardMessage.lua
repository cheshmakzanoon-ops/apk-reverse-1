local ValentineSendGiftRewardMessage = BaseClass("ValentineSendGiftRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ValentineDataManager:SetActSendRankRewardData(t)
  EventManager:GetInstance():Broadcast(EventId.ValentineSendGiftRankRewardData)
end

ValentineSendGiftRewardMessage.OnCreate = OnCreate
ValentineSendGiftRewardMessage.HandleMessage = HandleMessage
return ValentineSendGiftRewardMessage
