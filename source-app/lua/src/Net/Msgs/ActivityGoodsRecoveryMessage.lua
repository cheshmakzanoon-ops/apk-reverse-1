local ActivityGoodsRecoveryMessage = BaseClass("ActivityGoodsRecoveryMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, goodsId, num)
  base.OnCreate(self)
  self.sfsObj:PutInt("goodsId", goodsId)
  self.sfsObj:PutInt("num", num)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.rewards then
    DataCenter.RewardManager:AddRewards(t.rewards)
    DataCenter.RewardManager:ShowCommonReward({
      reward = t.rewards
    })
  end
end

ActivityGoodsRecoveryMessage.OnCreate = OnCreate
ActivityGoodsRecoveryMessage.HandleMessage = HandleMessage
return ActivityGoodsRecoveryMessage
