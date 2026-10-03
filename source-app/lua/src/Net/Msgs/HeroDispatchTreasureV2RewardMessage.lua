local HeroDispatchTreasureV2RewardMessage = BaseClass("HeroDispatchTreasureV2RewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function HeroDispatchTreasureV2RewardMessage:OnCreate(param)
  base.OnCreate(self)
end

function HeroDispatchTreasureV2RewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.DigTreasureBoxRewardManager:OnTreasureBoxRewardData(t)
  end
end

return HeroDispatchTreasureV2RewardMessage
