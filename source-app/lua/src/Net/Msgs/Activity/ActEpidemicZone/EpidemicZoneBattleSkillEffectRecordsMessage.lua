local EpidemicZoneBattleSkillEffectRecordsMessage = BaseClass("EpidemicZoneBattleSkillEffectRecordsMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EpidemicZoneBattleSkillEffectRecordsMessage:OnCreate()
  base.OnCreate(self)
end

function EpidemicZoneBattleSkillEffectRecordsMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActEpidemicZoneManager:HandleBattleSkillEffectRecords(t)
end

return EpidemicZoneBattleSkillEffectRecordsMessage
