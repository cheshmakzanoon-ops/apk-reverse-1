local PushEpidemicZoneBattleSkillEffectMessage = BaseClass("PushEpidemicZoneBattleSkillEffectMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushEpidemicZoneBattleSkillEffectMessage:OnCreate()
  base.OnCreate(self)
end

function PushEpidemicZoneBattleSkillEffectMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActEpidemicZoneManager:HandleBattleSkillEffect(t)
end

return PushEpidemicZoneBattleSkillEffectMessage
