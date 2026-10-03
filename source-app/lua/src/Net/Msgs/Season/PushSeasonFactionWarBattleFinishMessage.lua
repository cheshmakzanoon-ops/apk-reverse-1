local PushSeasonFactionWarBattleFinishMessage = BaseClass("PushSeasonFactionWarBattleFinishMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushSeasonFactionWarBattleFinishMessage:OnCreate()
  base.OnCreate(self)
end

function PushSeasonFactionWarBattleFinishMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  DataCenter.SeasonFactionWarDataManager:OnBattleFinish(t)
end

return PushSeasonFactionWarBattleFinishMessage
