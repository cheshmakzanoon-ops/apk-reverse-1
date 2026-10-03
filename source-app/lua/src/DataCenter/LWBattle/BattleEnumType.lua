local enums = {}
enums.BattleFormingEffect = {Opposite = 1, Ally = 2}
enums.inverseBattleFormingEffect = {}
for k, v in pairs(enums.BattleFormingEffect) do
  enums.inverseBattleFormingEffect[v] = k
end
enums.BattleFormingEffectClass = {
  [enums.BattleFormingEffect.Opposite] = "DataCenter.LWFakePVPBattle.EffectObject.TargetingEffect",
  [enums.BattleFormingEffect.Ally] = "DataCenter.LWFakePVPBattle.EffectObject.TargetingAllyEffect"
}
enums.ActionCasterState = {normal = 0, stunned = 1}
return enums
