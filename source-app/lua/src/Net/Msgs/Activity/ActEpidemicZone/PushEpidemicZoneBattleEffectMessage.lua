local PushEpidemicZoneBattleEffectMessage = BaseClass("PushEpidemicZoneBattleEffectMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushEpidemicZoneBattleEffectMessage:OnCreate()
  base.OnCreate(self)
end

function PushEpidemicZoneBattleEffectMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local mgr = BattleFieldUtil.GetMgr(t.worldType)
  if mgr then
    mgr:ReqBattleEffect()
  else
    BattleFieldUtil.LogError("[PushEpidemicZoneBattleEffectMessage:HandleMessage]Get battlefield mgr by type %s failed.", t.worldType)
  end
end

return PushEpidemicZoneBattleEffectMessage
