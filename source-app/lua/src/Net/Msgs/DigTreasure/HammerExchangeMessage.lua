local HammerExchangeMessage = BaseClass("HammerExchangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function HammerExchangeMessage:OnCreate(nNum)
  base.OnCreate(self)
  self.sfsObj:PutInt("num", nNum)
end

function HammerExchangeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.RewardManager:AddRewardsAndRes(t)
    DataCenter.RewardManager:ShowCommonReward(t)
  end
end

return HammerExchangeMessage
