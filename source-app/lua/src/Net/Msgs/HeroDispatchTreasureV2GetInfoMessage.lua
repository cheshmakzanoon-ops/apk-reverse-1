local HeroDispatchTreasureV2GetInfoMessage = BaseClass("HeroDispatchTreasureV2GetInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function HeroDispatchTreasureV2GetInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function HeroDispatchTreasureV2GetInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.DigTreasureBoxRewardManager:OnTreasureBoxRewardData(t)
  end
end

return HeroDispatchTreasureV2GetInfoMessage
