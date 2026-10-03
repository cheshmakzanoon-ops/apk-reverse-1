local BountyShopExchangeRecordMessage = BaseClass("BountyShopExchangeRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BountyShopExchangeRecordMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", param.activityId)
end

function BountyShopExchangeRecordMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonBountyShopManager:OnGetListCallback(t)
  end
end

return BountyShopExchangeRecordMessage
