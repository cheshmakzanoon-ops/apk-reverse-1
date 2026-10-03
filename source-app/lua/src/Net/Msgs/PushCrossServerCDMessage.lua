local PushCrossServerCDMessage = BaseClass("PushCrossServerCDMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushCrossServerCDMessage:OnCreate()
  base.OnCreate(self)
end

function PushCrossServerCDMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t and t.crossMoveCDEnd then
    DataCenter.LeagueMatchManager:SetCrossMoveCDEnd(t.crossMoveCDEnd)
  end
end

return PushCrossServerCDMessage
