local ActivityRebateNewBuyShopItemMessage = BaseClass("ActivityRebateNewBuyShopItemMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", param.activityId)
  self.sfsObj:PutUtfString("shopId", param.shopId)
  self.sfsObj:PutInt("num", param.num)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityRebateNewManager:OnBuyShopItemSuccess(t)
  end
end

ActivityRebateNewBuyShopItemMessage.OnCreate = OnCreate
ActivityRebateNewBuyShopItemMessage.HandleMessage = HandleMessage
return ActivityRebateNewBuyShopItemMessage
