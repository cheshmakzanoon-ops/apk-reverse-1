local BountyHunterGetShopInfoMessage = BaseClass("BountyHunterGetShopInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BountyHunterGetShopInfoMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

function BountyHunterGetShopInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.BountyHunterActDataManager:OnBountyHunterGetShopInfoSuccess(t)
  end
end

return BountyHunterGetShopInfoMessage
