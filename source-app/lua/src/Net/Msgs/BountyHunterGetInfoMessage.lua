local BountyHunterGetInfoMessage = BaseClass("BountyHunterGetInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BountyHunterGetInfoMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

function BountyHunterGetInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.BountyHunterActDataManager:UpdateActData(t)
    EventManager:GetInstance():Broadcast(EventId.BountyHunterReceiveActInfo)
    EventManager:GetInstance():Broadcast(EventId.RefreshCommonExchangeShopPanel)
  end
end

return BountyHunterGetInfoMessage
