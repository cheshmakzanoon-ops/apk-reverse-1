local ValentineSendGiftRankMessage = BaseClass("ValentineSendGiftRankMessage", SFSBaseMessage)
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
  DataCenter.ValentineDataManager:SetActSendRankData(t)
  EventManager:GetInstance():Broadcast(EventId.ValentineSendGiftRankData)
end

ValentineSendGiftRankMessage.OnCreate = OnCreate
ValentineSendGiftRankMessage.HandleMessage = HandleMessage
return ValentineSendGiftRankMessage
