local PushEpidemicZoneBattleSkillMessage = BaseClass("PushEpidemicZoneBattleSkillMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushEpidemicZoneBattleSkillMessage:OnCreate()
  base.OnCreate(self)
end

function PushEpidemicZoneBattleSkillMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActEpidemicZoneManager:HandleBattleSkill(t)
end

return PushEpidemicZoneBattleSkillMessage
