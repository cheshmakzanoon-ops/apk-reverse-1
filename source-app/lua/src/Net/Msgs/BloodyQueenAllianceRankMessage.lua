local BloodyQueenAllianceRankMessage = BaseClass("BloodyQueenAllianceRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BloodyQueenAllianceRankMessage:OnCreate(activityCount)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityCount", activityCount)
end

function BloodyQueenAllianceRankMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.PushBloodyQueenBattleAllianceRank, t)
  end
end

return BloodyQueenAllianceRankMessage
