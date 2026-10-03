local PushBattleCardCollectRewardMessage = BaseClass("PushBattleCardCollectRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushBattleCardCollectRewardMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushBattleCardCollectRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.TacticalCardDataManager:UpdateCardCollections(t.cardCollects)
  end
end

return PushBattleCardCollectRewardMessage
