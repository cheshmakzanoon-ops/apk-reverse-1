local FetchCrossServerListMessage = BaseClass("FetchCrossServerListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchCrossServerListMessage:OnCreate()
  base.OnCreate(self)
end

function FetchCrossServerListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.crossMoveCDEnd then
      DataCenter.LeagueMatchManager:SetCrossMoveCDEnd(t.crossMoveCDEnd)
    end
    if t.list ~= nil then
      CrossServerUtil.SetCrossEnableList(t.list)
    end
  end
end

return FetchCrossServerListMessage
