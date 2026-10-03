local EquipUtil = {}

local function CalculateProperties(templateId, lv, promoteLv)
  local equipTemplate = DataCenter.EquipTemplateManager:GetTemplate(templateId)
  if not equipTemplate then
    return {}
  end
  local properties = {}
  local baseWordId = equipTemplate:GetBaseWordIdByLevel(lv)
  if baseWordId and 0 < baseWordId then
    local baseWord = DataCenter.EquipWordTemplateManager:GetTemplate(baseWordId)
    if baseWord and baseWord.effects then
      for k, v in pairs(baseWord.effects) do
        properties[k] = (properties[k] or 0) + v
      end
    end
  end
  if 0 < promoteLv then
    local promoteWordId = equipTemplate:GetBaseAttrByPromoteLevel(promoteLv)
    if promoteWordId and 0 < promoteWordId then
      local promoteWord = DataCenter.EquipWordTemplateManager:GetTemplate(promoteWordId)
      if promoteWord and promoteWord.effects then
        for k, v in pairs(promoteWord.effects) do
          properties[k] = (properties[k] or 0) + v
        end
      end
    end
  end
  local unlockWords = equipTemplate:GetUnlockWordsByLevel(lv, promoteLv)
  for k, v in pairs(unlockWords) do
    local word = DataCenter.EquipWordTemplateManager:GetTemplate(v)
    if word and word.effects then
      for k, v_word in pairs(word.effects) do
        properties[k] = (properties[k] or 0) + v_word
      end
    end
  end
  return properties
end

local function CalculatePower(templateId, lv, promoteLv)
  local properties = CalculateProperties(templateId, lv, promoteLv)
  local power = 0
  for k, v in pairs(properties) do
    local effectTemplate = DataCenter.EffectNumberTemplateManager:GetEffectNumberTemplateById(k)
    if effectTemplate and 0 < effectTemplate.power then
      power = power + v * effectTemplate.power
    end
  end
  return math.floor(power)
end

EquipUtil.CalculatePower = CalculatePower
EquipUtil.CalculateProperties = CalculateProperties
return EquipUtil
