local DecorationShopReceiveFreeRewardMessage = BaseClass("DecorationShopReceiveFreeRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DecorationShopReceiveFreeRewardMessage:OnCreate(param)
  base.OnCreate(self)
  if not param or not param.id then
    Logger.LogError("param is wrong")
    return
  end
  self.sfsObj:PutInt("id", param.id)
end

function DecorationShopReceiveFreeRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.DecorationShopDirectPurchaseManager:OnHandleFreeReward(t)
  end
end

return DecorationShopReceiveFreeRewardMessage
