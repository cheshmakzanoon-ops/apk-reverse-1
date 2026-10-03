local PushSeasonFactionBattleReadyMessage = BaseClass("PushSeasonFactionBattleReadyMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushSeasonFactionBattleReadyMessage:OnCreate()
  base.OnCreate(self)
end

function PushSeasonFactionBattleReadyMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  DataCenter.SeasonFactionWarDataManager:InitData()
end

return PushSeasonFactionBattleReadyMessage
