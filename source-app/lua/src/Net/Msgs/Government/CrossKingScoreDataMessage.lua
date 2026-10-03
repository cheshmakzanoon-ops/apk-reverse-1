local CrossKingScoreDataMessage = BaseClass("CrossKingScoreDataMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CrossKingScoreDataMessage:OnCreate(page, pageSize)
  base.OnCreate(self)
  self.sfsObj:PutInt("page", page or 1)
  self.sfsObj:PutInt("pageSize", pageSize or 10)
end

function CrossKingScoreDataMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  DataCenter.ZoneWarManager:SetCrossKingRoundInfoNowScore(t)
end

return CrossKingScoreDataMessage
