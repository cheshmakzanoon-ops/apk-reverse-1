local EpidemicZoneBattleEffectMessage = BaseClass("EpidemicZoneBattleEffectMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EpidemicZoneBattleEffectMessage:OnCreate(worldType, group)
  base.OnCreate(self)
  self.sfsObj:PutInt("worldType", worldType)
  self.sfsObj:PutInt("group", group)
end

function EpidemicZoneBattleEffectMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  BattleFieldUtil.HandleEffects(t, t.worldType)
end

return EpidemicZoneBattleEffectMessage
