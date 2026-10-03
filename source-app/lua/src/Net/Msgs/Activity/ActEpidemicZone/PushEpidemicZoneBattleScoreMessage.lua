local PushEpidemicZoneBattleScoreMessage = BaseClass("PushEpidemicZoneBattleScoreMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushEpidemicZoneBattleScoreMessage:OnCreate()
  base.OnCreate(self)
end

function PushEpidemicZoneBattleScoreMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActEpidemicZoneManager:HandleBattleScore(t)
end

return PushEpidemicZoneBattleScoreMessage
