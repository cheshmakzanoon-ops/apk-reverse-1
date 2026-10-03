local BattleEffectList = BaseClass("BattleEffectList")
local BattleEffectInfo = require("DataCenter.MailData.BattleReport.BattleEffectData.BattleEffectInfo")

function BattleEffectList:InitData(battleEffectInfos)
  self.effectDic = {}
  for _, v in pairs(battleEffectInfos) do
    local oneData = BattleEffectInfo.New()
    oneData:InitData(v)
    if oneData.effectId ~= nil then
      self.effectDic[oneData.effectId] = oneData
    end
  end
end

function BattleEffectList:GetValue(effectId)
  if self.effectDic[effectId] ~= nil then
    return self.effectDic[effectId]:GetValue()
  end
  return 0
end

function BattleEffectList:GetReasonList(effectId)
  if self.effectDic[effectId] ~= nil then
    return self.effectDic[effectId]:GetReasonList()
  end
  return {}
end

return BattleEffectList
