local EpidemicZoneBattleScoreMessage = BaseClass("EpidemicZoneBattleScoreMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EpidemicZoneBattleScoreMessage:OnCreate(group)
  base.OnCreate(self)
  self.sfsObj:PutInt("group", group)
end

function EpidemicZoneBattleScoreMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActEpidemicZoneManager:HandleBattleScore(t)
end

return EpidemicZoneBattleScoreMessage
