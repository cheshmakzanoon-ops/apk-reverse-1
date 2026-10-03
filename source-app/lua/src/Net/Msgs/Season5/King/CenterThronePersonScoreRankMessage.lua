local CenterThronePersonScoreRankMessage = BaseClass("CenterThronePersonScoreRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CenterThronePersonScoreRankMessage:OnCreate(param)
  base.OnCreate(self)
end

function CenterThronePersonScoreRankMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  EventManager:GetInstance():Broadcast(EventId.NineNationKingBattleRankRefresh, t)
end

return CenterThronePersonScoreRankMessage
