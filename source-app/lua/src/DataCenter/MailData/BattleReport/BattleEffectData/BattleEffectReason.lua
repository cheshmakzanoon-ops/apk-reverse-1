local BattleEffectReason = BaseClass("BattleEffectReason")

function BattleEffectReason:InitData(effectReason)
  self.reason = effectReason.reason or -1
  self.value = effectReason.value or 0
end

return BattleEffectReason
