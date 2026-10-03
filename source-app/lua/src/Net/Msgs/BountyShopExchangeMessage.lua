local BountyShopExchangeMessage = BaseClass("BountyShopExchangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BountyShopExchangeMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", param.activityId)
  self.sfsObj:PutInt("configId", param.configId)
  self.sfsObj:PutInt("num", param.num)
end

function BountyShopExchangeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonBountyShopManager:OnExchangeCallback(t)
  end
end

return BountyShopExchangeMessage
