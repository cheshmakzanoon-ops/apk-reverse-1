local HeroSkillTemplate = BaseClass("HeroSkillTemplate")
local Localization = CS.GameEntry.Localization

function HeroSkillTemplate:__init()
  self.id = 0
  self.skill_cat = 0
  self.name = ""
  self.desc = ""
  self.icon = ""
  self.type = 0
  self.apType = 0
  self.triggerType = 0
  self.actionType = 0
  self.group = 0
  self.maxLevel = 0
  self.levelup_consume_sp = {}
  self.enhance_fragment = 0
  self.level = 0
  self.enhance_desc_pre = {}
  self.sorted_enhance_desc_keys = {}
  self.property = {}
  self.outOfBattleProperties = {}
  self.power = {}
  self.bullet = 0
  self.attack_interval = 0
  self.pre_cd = 0
  self.other_condition = 0
  self.other_condition_para = ""
  self.other_condition_para_buff_count = nil
  self.priority = 0
  self.attack_range = 0
  self.skill_effect = 0
  self.skin_skill_effect = {}
  self.target_type = {}
  self.target_type_bin = 0
  self.damage1 = 0
  self.damage2 = 0
  self.damage3 = 0
  self.buff = 0
  self.damageParams = {}
  self.buffId = {}
  self.effectInCity = nil
  self.star = 0
  self.needRank = 0
  self.maxStar = 0
  self.skill_desc_para = {}
  self.cast_count = 0
  self.cast_interval = 0
  self.firepoint = {}
  self.firelogic = 0
  self.moving_logic = {}
  self.display_type = 0
  self.pve_buff_bullet = 0
  self.pvp_buff_bullet = 0
  self.source_group = 0
  self.effect_pvp = 0
  self.summon_formation = nil
  self.summonFormationList = nil
end

function HeroSkillTemplate:__delete()
  self.id = nil
  self.skill_cat = nil
  self.name = nil
  self.desc = nil
  self.icon = nil
  self.type = nil
  self.group = nil
  self.maxLevel = nil
  self.levelup_consume_sp = nil
  self.enhance_fragment = nil
  self.level = nil
  self.enhance_desc_pre = nil
  self.sorted_enhance_desc_keys = nil
  self.property = nil
  self.outOfBattleProperties = nil
  self.damage1 = nil
  self.damage2 = nil
  self.damage3 = nil
  self.damageParams = nil
  self.power = nil
  self.buff = nil
  self.subSkills = nil
  self.buffId = nil
  self.effectInCity = nil
  self.star = nil
  self.needRank = nil
  self.maxStar = nil
  self.skill_desc_para = nil
  self.cast_count = nil
  self.cast_interval = nil
  self.anim_normal = nil
  self.anim_move = nil
  self.pve_animation = nil
  self.pve_animation_move = nil
  self.matching_animation = nil
  self.matching_animation_move = nil
  self.firepoint = nil
  self.firelogic = nil
  self.moving_logic = nil
  self.display_type = nil
  self.pve_buff_bullet = nil
  self.pvp_buff_bullet = nil
  self.source_group = nil
  self.effect_pvp = nil
  self.summon_formation = nil
  self.summonFormationList = nil
end

function HeroSkillTemplate:InitConfig(row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.displayCast_type_new = tonumber(row:getValue("displayCast_type_new")) or 0
  self.skill_cat = row:getValue("skill_cat") or 0
  self.name = row:getValue("name") or ""
  self.desc = row:getValue("desc") or ""
  self.icon = row:getValue("icon") or ""
  self.type = tonumber(row:getValue("type")) or 0
  self.apType = tonumber(row:getValue("apType")) or 0
  self.triggerType = tonumber(row:getValue("triggerType")) or 0
  if self.triggerType == SkillTriggerType.Cast then
    self.triggerParam = row:getValue("triggerParam")
    self.triggerParam = tonumber(self.triggerParam) or 0
  elseif self.triggerType == SkillTriggerType.BeHitNew then
    self.triggerParam = {}
    local triggerParamTable = string.split(row:getValue("triggerParam") or "", "|")
    for i, v in ipairs(triggerParamTable) do
      local triggerParamPair = string.split(v, ";")
      if #triggerParamPair == 2 then
        self.triggerParam[i] = {
          checknumber(triggerParamPair[1]),
          checknumber(triggerParamPair[2])
        }
      end
    end
  end
  self.actionType = tonumber(row:getValue("actionType")) or 0
  local split = string.split
  if self.actionType == SkillActionType.Summon then
    local actionParam = row:getValue("actionParam")
    local actionParamList = split(actionParam, "|")
    self.actionParam = {}
    for i = 1, #actionParamList do
      local param = split(actionParamList[i], ";")
      for j = 1, #param do
        param[j] = tonumber(param[j])
      end
      self.actionParam[i] = param
    end
  end
  self.group = tonumber(row:getValue("group")) or 0
  self.maxLevel = tonumber(row:getValue("maxLevel")) or 0
  self.levelup_consume_sp = row:getValue("levelup_consume_sp") or {}
  self.enhance_fragment = tonumber(row:getValue("enhance_fragment")) or 0
  self.level = tonumber(row:getValue("level")) or 0
  self.enhance_desc_pre = row:getValue("enhance_desc_pre") or {}
  self.pvp_damage_type = tonumber(row:getValue("pvp_damage_type")) or 0
  self.damage_delay = tonumber(row:getValue("damage_delay")) or 0
  self.horizontal_speed = tonumber(row:getValue("horizontal_speed")) or 0
  self.pvp_pos_num = tonumber(row:getValue("pvp_pos_num")) or 0
  self.pvp_cast_count = tonumber(row:getValue("pvp_cast_count")) or 0
  self.sorted_enhance_desc_keys = {}
  if self.enhance_desc_pre ~= nil then
    local count = 1
    for k, v in pairs(self.enhance_desc_pre) do
      local enhanceEffect = {}
      enhanceEffect.star = k
      enhanceEffect.effect = Localization:GetString(v)
      self.sorted_enhance_desc_keys[count] = enhanceEffect
      count = count + 1
    end
    table.sort(self.sorted_enhance_desc_keys, function(a, b)
      return a.star < b.star
    end)
  end
  self.buffId = {}
  local buffStr = split(tostring(row:getValue("buff")), "|")
  local count = 1
  for k, v in pairs(buffStr) do
    self.buffId[count] = tonumber(v)
    count = count + 1
  end
  local propertyStr = row:getValue("property")
  self.propertyStr = propertyStr
  if not string.IsNullOrEmpty(propertyStr) then
    local properties = {}
    local propertiesDiffValue = {}
    local propertyArray = split(propertyStr, "|")
    count = 1
    for k, v in pairs(propertyArray) do
      local propertyData = split(v, ";")
      if propertyData ~= nil and not (2 > table.count(propertyData)) then
        local property = {}
        property.id = tonumber(propertyData[1])
        property.value = tonumber(propertyData[2])
        propertiesDiffValue[property.id] = 0
        if propertyData[3] then
          propertiesDiffValue[property.id] = tonumber(propertyData[3])
        end
        properties[count] = property
        count = count + 1
      end
    end
    self.property = properties
    self.propertiesDiffValue = propertiesDiffValue
  end
  local outOfBattlePropertyStr = row:getValue("property_out_of_battle")
  if not string.IsNullOrEmpty(outOfBattlePropertyStr) then
    local properties = {}
    local propertyArray = split(outOfBattlePropertyStr, "|")
    for k, v in pairs(propertyArray) do
      local propertyData = split(v, ";")
      if propertyData ~= nil and not (2 > table.count(propertyData)) then
        local property = {}
        property.id = tonumber(propertyData[1])
        property.value = tonumber(propertyData[2])
        table.insert(properties, property)
      end
    end
    self.outOfBattleProperties = properties
  end
  self.bullet = tonumber(row:getValue("bullet")) or 0
  self.pvp_bullet = tonumber(row:getValue("pvp_bullet")) or 0
  self.pvp_bullet = self.pvp_bullet == 0 and self.bullet or self.pvp_bullet
  self.world_bullet = tonumber(row:getValue("world_bullet")) or 0
  self.world_bullet = self.world_bullet == 0 and self.bullet or self.world_bullet
  self.attack_interval = tonumber(row:getValue("attack_interval")) or 0
  self.attack_interval = self.attack_interval * 0.001
  self.pre_cd = tonumber(row:getValue("pre_cd")) or 0
  self.pre_cd = self.pre_cd * 0.001
  self.priority = tonumber(row:getValue("priority")) or 0
  local strings = split(row:getValue("target_type"), "|")
  count = 1
  for k, v in ipairs(strings) do
    local target_type
    local typeNum = tonumber(v)
    if typeNum == 4 then
      target_type = {1, 3}
    else
      target_type = {typeNum}
    end
    local target_type_bin = 0
    for _, type in ipairs(target_type) do
      target_type_bin = target_type_bin | 1 << type + 1
    end
    if k == 1 then
      self.target_type = target_type
      self.target_type_bin = target_type_bin
    else
      if not self.subSkills then
        self.subSkills = {}
      end
      local subSkill = {}
      subSkill.isSubSkill = true
      setmetatable(subSkill, {__index = self})
      self.subSkills[count] = subSkill
      count = count + 1
      subSkill.target_type = target_type
      subSkill.target_type_bin = target_type_bin
    end
  end
  self:ParseForSubSkill(row, "pos_condition")
  self:ParseForSubSkill(row, "pos_num")
  self:ParseForSubSkill(row, "troop_condition")
  self:ParseForSubSkill(row, "other_condition")
  self:ParseForSubSkill(row, "buff")
  self.buff_condition = tonumber(row:getValue("buff_condition")) or 0
  self.buff_param = tonumber(row:getValue("buff_param")) or 0
  self.attack_range = tonumber(row:getValue("attack_range")) or 0
  self.skill_effect = tonumber(row:getValue("skill_effect")) or 0
  self.skin_skill_effect = row:getValue("skin_skill_effect")
  self.damage_ratio = tonumber(row:getValue("damage_ratio")) or 1
  self.damage_to_monster = tonumber(row:getValue("damage_to_monster")) or 1
  self.damageParams = {}
  self.damageDiffValues = {}
  local damageRateStrArr = row:getValue("bullet_damage_rate")
  count = 1
  if damageRateStrArr and 0 < #damageRateStrArr then
    for _, damageRateStr in ipairs(damageRateStrArr) do
      local damageRateArr = split(damageRateStr, ";")
      local damage = tonumber(damageRateArr[1]) or 0
      local damageDiffValue = tonumber(damageRateArr[2]) or 0
      self.damageParams[count] = damage
      self.damageDiffValues[count] = damageDiffValue
      count = count + 1
    end
  end
  self.power = row:getValue("power") or {}
  self.time_stop_duration = tonumber(row:getValue("cast_effect_delay_duration")) or 0
  self.time_stop_duration = self.time_stop_duration * 0.001
  self.effectInCity = {}
  self.effectInCityDiffValues = {}
  local effectInCityStr = row:getValue("effect_incity")
  count = 1
  if not string.IsNullOrEmpty(effectInCityStr) then
    local effectInCityArray = split(effectInCityStr, "|")
    for k, v in pairs(effectInCityArray) do
      local effectInCityData = split(v, ";")
      if effectInCityData ~= nil and not (table.count(effectInCityData) < 3) then
        local effectInCity = {}
        effectInCity.id = tonumber(effectInCityData[1])
        effectInCity.value = tonumber(effectInCityData[2])
        self.effectInCityDiffValues[effectInCity.id] = 0
        if effectInCityData[3] then
          self.effectInCityDiffValues[effectInCity.id] = tonumber(effectInCityData[3])
        end
        self.effectInCity[count] = effectInCity
        count = count + 1
      end
    end
  end
  self.star = tonumber(row:getValue("star")) or 0
  self.needRank = tonumber(row:getValue("need_rank")) or 0
  self.maxStar = tonumber(row:getValue("maxStar")) or 0
  self.enhanceEffectKey = row:getValue("level_up_desc") or ""
  self.enhanceEffectParams = row:getValue("level_up_desc_param") or {}
  local skill_desc_para = row:getValue("desc_para")
  self.skill_desc_para = {}
  count = 1
  if not string.IsNullOrEmpty(skill_desc_para) then
    local skill_desc_para_array = split(skill_desc_para, "|")
    for k, v in pairs(skill_desc_para_array) do
      local skill_desc_para_data = split(v, ",")
      if skill_desc_para_data ~= nil and not (2 > table.count(skill_desc_para_data)) then
        local skill_desc_para = {}
        skill_desc_para.formatType = tonumber(skill_desc_para_data[1])
        skill_desc_para.baseValue = tonumber(skill_desc_para_data[2])
        skill_desc_para.isConst = string.IsNullOrEmpty(skill_desc_para_data[3])
        if skill_desc_para.isConst == false then
          skill_desc_para.diffValue = tonumber(skill_desc_para_data[3])
        end
        self.skill_desc_para[count] = skill_desc_para
        count = count + 1
      end
    end
  end
  self.cast_count = tonumber(row:getValue("cast_count")) or 0
  self.cast_interval = tonumber(row:getValue("cast_interval")) or 0
  self.cast_interval = self.cast_interval * 0.001
  local animation = row:getValue("animation")
  local animation_move = row:getValue("animation_move")
  local pveAnimation = row:getValue("pve_animation")
  local pveAnimationMove = row:getValue("pve_animation_move")
  local matchingAnimation = row:getValue("matching_animation")
  local matchingAnimationMove = row:getValue("matching_animation_move")
  if table.IsNullOrEmpty(animation) then
    self.anim_normal = nil
  else
    self.anim_normal = animation[1]
    self.anim_normal_transformed = animation[2]
  end
  if table.IsNullOrEmpty(animation_move) then
    self.anim_move = nil
  else
    self.anim_move = animation_move[1]
    self.anim_move_transformed = animation_move[2]
  end
  if table.IsNullOrEmpty(pveAnimation) then
    self.pve_animation = nil
  else
    self.pve_animation = pveAnimation[1]
    self.pve_animation_transformed = pveAnimation[2]
  end
  if table.IsNullOrEmpty(pveAnimationMove) then
    self.pve_animation_move = nil
  else
    self.pve_animation_move = pveAnimationMove[1]
    self.pve_animation_move_transformed = pveAnimationMove[2]
  end
  if table.IsNullOrEmpty(matchingAnimation) then
    self.matching_animation = nil
  else
    self.matching_animation = matchingAnimation[1]
    self.matching_animation_transformed = matchingAnimation[2]
  end
  if table.IsNullOrEmpty(matchingAnimationMove) then
    self.matching_animation_move = nil
  else
    self.matching_animation_move = matchingAnimationMove[1]
    self.matching_animation_move_transformed = matchingAnimationMove[2]
  end
  self.pvp_bullet_critical = tonumber(row:getValue("pvp_bullet_critical")) or 0
  self.bullet_critical = tonumber(row:getValue("bullet_critical")) or 0
  self.firepoint = row:getValue("firepoint") or {}
  self.firelogic = tonumber(row:getValue("firelogic")) or 0
  local moving_logic = row:getValue("moving_logic") or {}
  self.moving_logic = {}
  for i = 1, #moving_logic do
    local time, type, duration, para = string.match(moving_logic[i], "(%d+),(%d+),(%d+),(.+)")
    self.moving_logic[i] = {
      time = (tonumber(time) or 0) / 1000,
      type = tonumber(type) or 0,
      duration = (tonumber(duration) or 0) / 1000,
      para = para
    }
  end
  self.display_type = tonumber(row:getValue("display_type")) or 0
  self.pve_buff_bullet = tonumber(row:getValue("pve_buff_bullet")) or 0
  self.pvp_buff_bullet = tonumber(row:getValue("pvp_buff_bullet")) or 0
  self.pvp_triggerType = tonumber(row:getValue("pvp_triggerType")) or 0
  self.other_condition_para = row:getValue("other_condition_para") or ""
  self.source_group = tonumber(row:getValue("source_group")) or 0
  self.forming_effect = row:getValue("forming_effect")
  self.effect_pvp = row:getValue("effect_pvp")
  self.summon_formation = row:getValue("summon_formation")
  self.awake_not_stop = row:getValue("awake_not_stop")
end

function HeroSkillTemplate:GetSortedEnhanceDescKeys()
  if not DataCenter.HeroSkillTemplateManager:SkillGroupHasNewEnhanceEffect(self.group) then
    return self.sorted_enhance_desc_keys
  else
    return DataCenter.HeroSkillTemplateManager:GetSkillEnhanceEffectByGroup(self.group)
  end
end

function HeroSkillTemplate:ParseForSubSkill(row, fieldStr)
  local _val = tostring(row:getValue(fieldStr))
  if string.IsNullOrEmpty(_val) then
    return
  end
  local split = string.split
  local strings = split(_val, "|")
  for k, v in ipairs(strings) do
    if k == 1 then
      self[fieldStr] = tonumber(v) or 0
    else
      self.subSkills[k - 1][fieldStr] = tonumber(v) or 0
    end
  end
end

function HeroSkillTemplate:GetDescByLevel()
  local data = {}
  local dataCount = 0
  local effectNumberCount = self:GetSkillEffectNumbers()
  if effectNumberCount == 0 then
    return Localization:GetString(self.desc)
  else
    for i = 1, effectNumberCount do
      local value, result = self:GetSkillEffectByIndex(i)
      if value ~= nil and result == true then
        dataCount = dataCount + 1
        data[dataCount] = value
        if self.actionType == SkillActionType.Bullet then
          data[dataCount] = string.format("%s%%", tostring(data[dataCount] * 100))
        elseif self.triggerType == SkillTriggerType.AlwaysInside then
          local propertyId = self:GetPropertyEffectIdByIndex(i)
          data[dataCount] = HeroUtils.GetFormattedPropertyValue(propertyId, data[dataCount])
        end
      end
    end
    local paramArray = CS.System.Array.CreateInstance(typeof(CS.System.String), dataCount)
    for k, v in pairs(data) do
      paramArray[k - 1] = tostring(v)
    end
    local resultStr = Localization:GetString(self.desc, paramArray)
    return resultStr
  end
end

function HeroSkillTemplate:GetSkillEffectNumbers()
  if self.actionType == SkillActionType.Bullet then
    return #self.damageParams
  elseif self.actionType == SkillActionType.Buff then
    return self:GetBuffEffectNumbers()
  elseif self.triggerType == SkillTriggerType.AlwaysInside then
    return table.count(self.property)
  elseif self.triggerType == SkillTriggerType.IdleOutside then
    return table.count(self.effectInCity)
  elseif self.triggerType == SkillTriggerType.AlwaysOutside then
    return table.count(self.property)
  end
end

function HeroSkillTemplate:GetBuffEffectNumbers()
  local ret = 0
  for k, buffId in pairs(self.buffId) do
    local buffMeta = DataCenter.LWBuffTemplateManager:GetTemplate(buffId)
    if buffMeta then
      ret = ret + table.count(buffMeta.para)
    end
  end
  return ret
end

function HeroSkillTemplate:IsCityIdleSkillType()
  local result = self.triggerType == SkillTriggerType.IdleOutside
  return result
end

function HeroSkillTemplate:GetAllDamage()
  local data = {}
  for i = 1, self:GetSkillEffectNumbers() do
    local value, result = self:GetSkillEffectByIndex(i)
    if value ~= nil and result == true then
      data[i] = value
    else
      data[i] = 0
    end
  end
  return data
end

function HeroSkillTemplate:GetSkillEffectByIndex(index)
  if self.actionType == SkillActionType.Bullet then
    return self:GetBulletDamageByLevelAndIndex(index)
  elseif self.actionType == SkillActionType.Buff then
    return self:GetBuff()
  elseif self.actionType == SkillActionType.Halo and self.triggerType == SkillTriggerType.AlwaysInside then
    return self:GetPropertyEffectByIndex(index)
  end
end

function HeroSkillTemplate:GetBuff()
  if self.buff ~= nil and self.buff > 0 then
    return self.buff, true
  else
    return 0, false
  end
end

function HeroSkillTemplate:GetBulletDamageByLevelAndIndex(index)
  if index == 1 then
    return self.damage1, true
  elseif index == 2 then
    return self.damage2, true
  elseif index == 3 then
    return self.damage3, true
  end
end

function HeroSkillTemplate:GetPropertyEffectIdByIndex(index)
  if self.property ~= nil and table.count(self.property) > 0 then
    if table.containsKey(self.property, index) then
      return self.property[index].id, true
    elseif table.containsKey(self.property, 1) then
      return self.property[1].id, true
    end
  else
    return 0, false
  end
end

function HeroSkillTemplate:GetPropertyEffectByIndex(index)
  if self.property ~= nil and table.count(self.property) > 0 then
    if table.containsKey(self.property, index) then
      return self.property[index].value, true
    elseif table.containsKey(self.property, 1) then
      return self.property[1].value, true
    end
  else
    return 0, false
  end
end

function HeroSkillTemplate:GetCostSkillPointCount(level)
  if self.levelup_consume_sp ~= nil and table.containsKey(self.levelup_consume_sp, level) then
    return self.levelup_consume_sp[level]
  end
  return 0
end

function HeroSkillTemplate:GetCostFragmentCount()
  return self.enhance_fragment
end

function HeroSkillTemplate:GetFormattedEffectStr(value, param1)
  if self.actionType == SkillActionType.Bullet then
    return string.format("%.2f%%", value * 1.0 * 100)
  elseif self.actionType == SkillActionType.Halo or self.actionType == SkillActionType.Buff then
    local propertyId = param1
    return HeroUtils.GetFormattedPropertyValue(propertyId, value)
  else
    return tostring(value)
  end
end

function HeroSkillTemplate:GetDamageParam(index, level, formatted)
  if self.damageParams[index] then
    local baseValue = self.damageParams[index]
    local diffValue = self.damageDiffValues[index]
    local value = self.damage_ratio * (baseValue + level * diffValue)
    if formatted then
      return self:GetFormattedEffectStr(value, 0), true
    else
      return value, true
    end
  end
  return 0, false
end

function HeroSkillTemplate:GetBuffParam(index, level, formatted)
  if self.buffId then
    local buffIndex = 0
    local buffMeta
    local startIndex = 0
    for __, buffId in pairs(self.buffId) do
      buffMeta = DataCenter.LWBuffTemplateManager:GetTemplate(buffId)
      if buffMeta then
        local buffParaCount = table.count(buffMeta.para)
        if index > startIndex + buffParaCount then
          startIndex = startIndex + buffParaCount
        else
          buffIndex = index - startIndex
          break
        end
      end
    end
    if buffMeta and buffIndex ~= 0 then
      local para = buffMeta:GetParaByLevelIndex(level, buffIndex)
      if para then
        if formatted then
          return self:GetFormattedEffectStr(para.value, para.key), true
        else
          return para.value, true
        end
      end
    end
  end
  return 0, false
end

function HeroSkillTemplate:GetPropertyParam(index, level, formatted)
  if not table.IsNullOrEmpty(self.property) then
    local property = self.property[index]
    if property then
      local id = property.id
      local value = property.value
      if self.propertiesDiffValue[id] then
        value = value + level * self.propertiesDiffValue[id]
      end
      if formatted then
        return self:GetFormattedEffectStr(value, id), true
      else
        return value, true
      end
    else
      return 0, false
    end
  else
    return 0, false
  end
end

function HeroSkillTemplate:GetPropertyDictByLevel(level)
  level = level or 0
  local ret = {}
  if self.property then
    for k, v in pairs(self.property) do
      local id = v.id
      local value = v.value
      if self.propertiesDiffValue[id] then
        value = value + level * self.propertiesDiffValue[id]
      end
      ret[id] = value
    end
  end
  return ret
end

function HeroSkillTemplate:GetEffectInCityParam(index, level, formatted)
  if not table.IsNullOrEmpty(self.effectInCity) then
    local effect = self.effectInCity[index]
    if effect then
      local value = effect.value
      if self.effectInCityDiffValues[index] then
        value = value + level * self.effectInCityDiffValues[index]
      end
      if formatted then
        return self:GetFormattedEffectStr(value, effect.id), true
      else
        return value, true
      end
    else
      return 0, false
    end
  else
    return 0, false
  end
end

function HeroSkillTemplate:GetSkillEffectByIndexAndLevel(index, level, formatted)
  if self.actionType == SkillActionType.Bullet then
    local value, result = self:GetDamageParam(index, level, formatted)
    return value, result
  elseif self.actionType == SkillActionType.Buff then
    local value, result = self:GetBuffParam(index, level, formatted)
    return value, result
  elseif self.triggerType == SkillTriggerType.AlwaysInside or self.triggerType == SkillTriggerType.AlwaysOutside then
    local value, result = self:GetPropertyParam(index, level, formatted)
    return value, result
  elseif self.triggerType == SkillTriggerType.IdleOutside then
    local value, result = self:GetEffectInCityParam(index, level, formatted)
    return value, result
  end
end

function HeroSkillTemplate:GetSkillEffects(level)
  local effectNumberCount = self:GetSkillEffectNumbers()
  local paras = {}
  local count = 1
  for i = 1, effectNumberCount do
    local value = self:GetSkillEffectByIndexAndLevel(i, level)
    if value ~= nil then
      paras[count] = value
      count = count + 1
    end
  end
  return paras
end

function HeroSkillTemplate:GetTacticalChipDesc(colorStr, customTierSystemEffectValue)
  local paras = {}
  local count = 1
  for k, v in pairs(self.skill_desc_para) do
    local value = v.baseValue
    local diffValueColor = LuaEntry.DataConfig:TryGetStr("battlesystem_chip_skill_format_config", "k2")
    local diffValueLinkId = LuaEntry.DataConfig:TryGetStr("battlesystem_chip_skill_format_config", "k1")
    local valueStr = HeroUtils.GetFormattedValue(v.formatType, value, false)
    local diffValueStr = ""
    if not v.isConst then
      local curSystemEffectValue = DataCenter.TacticalChipManager:GetSystemTierEffectValue()
      if customTierSystemEffectValue and 0 < customTierSystemEffectValue then
        curSystemEffectValue = customTierSystemEffectValue
      end
      local diffValue = v.diffValue * curSystemEffectValue
      diffValueStr = Localization:GetString("battlesystem_main_desc8", HeroUtils.GetFormattedValue(v.formatType, diffValue, false))
    end
    local formattedValue = ""
    if not v.isConst then
      local formattedValue1 = string.format("<color=%s>%s</color>", colorStr, valueStr)
      local formattedValue2 = string.format("<link=\"%s\"><color=%s>%s</color></link>", diffValueLinkId, diffValueColor, diffValueStr)
      formattedValue = formattedValue1 .. formattedValue2
    else
      formattedValue = string.format("<color=%s>%s</color>", colorStr, valueStr)
    end
    paras[count] = formattedValue
    count = count + 1
  end
  local resultStr = Localization:GetString(self.desc, SafeUnpack(paras))
  return resultStr
end

function HeroSkillTemplate:GetSkillDescByLevel(level, containNextLevel, colorStr, maxLevel, customTierSystemEffectValue)
  local skillMaxLevel = maxLevel ~= nil and maxLevel or self.maxLevel
  if not table.IsNullOrEmpty(self.skill_desc_para) then
    if self.skill_cat == 1 then
      return HeroUtils.ProcessHyperText(self:GetTacticalChipDesc(colorStr, customTierSystemEffectValue))
    end
    local paras = {}
    local count = 1
    for k, v in pairs(self.skill_desc_para) do
      local value = v.baseValue
      if not v.isConst then
        value = value + level * v.diffValue
      end
      local valueStr = HeroUtils.GetFormattedValue(v.formatType, value, false)
      local formattedValue = ""
      if containNextLevel and not v.isConst then
        local reachMaxLevel = level >= skillMaxLevel
        if not reachMaxLevel then
          local nextValue = v.baseValue + (level + 1) * v.diffValue
          local nextValueStr = HeroUtils.GetFormattedValue(v.formatType, nextValue, false)
          formattedValue = string.format("<color=%s>%s (->%s)</color>", colorStr, valueStr, nextValueStr)
        else
          formattedValue = string.format("<color=%s>%s</color>", colorStr, valueStr)
        end
      else
        formattedValue = string.format("<color=%s>%s</color>", colorStr, valueStr)
      end
      paras[count] = formattedValue
      count = count + 1
    end
    local resultStr = Localization:GetString(self.desc, SafeUnpack(paras))
    return HeroUtils.ProcessHyperText(resultStr)
  end
  local effectNumberCount = self:GetSkillEffectNumbers()
  if effectNumberCount == 0 or effectNumberCount == nil then
    return HeroUtils.ProcessHyperText(Localization:GetString(self.desc))
  else
    local dataCount = 0
    local data = {}
    for i = 1, effectNumberCount do
      local value, result = self:GetSkillEffectByIndexAndLevel(i, level, true)
      if result then
        dataCount = dataCount + 1
        data[dataCount] = tostring(value)
        if containNextLevel then
          local reachMaxLevel = level >= skillMaxLevel
          if not reachMaxLevel then
            local nextValue = self:GetSkillEffectByIndexAndLevel(i, level + 1, true)
            data[dataCount] = string.format("<color=%s>%s (->%s)</color>", colorStr, value, nextValue)
          else
            data[dataCount] = string.format("<color=%s>%s</color>", colorStr, value)
          end
        else
          data[dataCount] = string.format("<color=%s>%s</color>", colorStr, value)
        end
      end
    end
    if self.actionType == SkillActionType.Bullet then
      if dataCount < 10 then
        for i = dataCount + 1, 10 do
          dataCount = dataCount + 1
          data[dataCount] = "0"
        end
      end
      local buffCount = self:GetBuffEffectNumbers()
      for i = 1, buffCount do
        local value, result = self:GetBuffParam(i, level, true)
        if result then
          dataCount = dataCount + 1
          data[dataCount] = tostring(value)
          if containNextLevel then
            local reachMaxLevel = level >= skillMaxLevel
            if not reachMaxLevel then
              local nextValue = self:GetBuffParam(i, level + 1, true)
              data[dataCount] = string.format("<color=%s>%s (->%s)</color>", colorStr, value, nextValue)
            else
              data[dataCount] = string.format("<color=%s>%s</color>", colorStr, value)
            end
          else
            data[dataCount] = string.format("<color=%s>%s</color>", colorStr, value)
          end
        end
      end
    end
    local paramArray = CS.System.Array.CreateInstance(typeof(CS.System.String), dataCount)
    for k, v in pairs(data) do
      paramArray[k - 1] = tostring(v)
    end
    local resultStr = Localization:GetString(self.desc, paramArray)
    return HeroUtils.ProcessHyperText(resultStr)
  end
end

function HeroSkillTemplate:GetPowerByLevel(level)
  local power = self.power[1]
  local diff = self.power[2]
  power = power or 0
  if diff then
    power = power + diff * level
  end
  return power
end

function HeroSkillTemplate:GetSkillEffect(appearanceId)
  if appearanceId then
    return self.skin_skill_effect[appearanceId] or self.skill_effect
  end
  return self.skill_effect
end

function HeroSkillTemplate:IsFocused()
  local displayCastType = self:GetSkillDisplayCastType()
  return displayCastType == SkillCastType.Talent
end

function HeroSkillTemplate:GetSkillCastType()
  if self:IsFocused() then
    return SkillCastType.Talent
  end
  if self:IsNormalAttack() then
    return SkillCastType.AutoAttack
  end
  if self.apType == 0 then
    return SkillCastType.Active
  elseif self.apType == 1 then
    return SkillCastType.Passive
  end
end

function HeroSkillTemplate:GetSkillDisplayType()
  return self.display_type
end

function HeroSkillTemplate:GetSkillDisplayCastType()
  return self.displayCast_type_new
end

function HeroSkillTemplate:GetOtherConditionPara()
  if self.other_condition == PriorityType.HighestEffect then
    if not string.IsNullOrEmpty(self.other_condition_para) then
      return tonumber(self.other_condition_para) or 0
    end
  elseif self.other_condition == PriorityType.HighestBuffCount or self.other_condition == PriorityType.BoxRandom or self.other_condition == PriorityType.BoxNearest or self.other_condition == PriorityType.BoxFarthest then
    if self.other_condition_para_buff_count == nil then
      self.other_condition_para_buff_count = {}
      if not string.IsNullOrEmpty(self.other_condition_para) then
        local strArr = string.split(self.other_condition_para, ";")
        for i, v in pairs(strArr) do
          local value = tonumber(v)
          if value then
            table.insert(self.other_condition_para_buff_count, value)
          end
        end
      end
    end
    return self.other_condition_para_buff_count
  end
end

function HeroSkillTemplate:GetFormingEffect()
  if self.cachedFormingEffect then
    return self.cachedFormingEffect
  end
  if string.IsNullOrEmpty(self.forming_effect) then
    return nil
  end
  local effects = string.split(self.forming_effect, "|")
  local formingEffect = {}
  for i, v in pairs(effects) do
    local displayType, targetEffect, lineEffect = string.match(v, "(%d+);([^;]*);([^;]*)")
    if displayType and targetEffect then
      formingEffect[i] = {
        displayType = tonumber(displayType),
        targetEffect = targetEffect,
        lineEffect = lineEffect
      }
    end
  end
  self.cachedFormingEffect = formingEffect
  return formingEffect
end

function HeroSkillTemplate:IsShowSkillPreviewBtn()
  if self.actionType == SkillActionType.Bullet or self.actionType == SkillActionType.Buff then
    local hasPerformTemplate = LocalController:instance():hasLine(TableName.LW_Hero_Skill_Perform, self.id)
    return hasPerformTemplate
  end
end

function HeroSkillTemplate:IsNormalAttack()
  return self.displayCast_type_new == SkillCastType.AutoAttack
end

function HeroSkillTemplate:GetSkillCatType()
  return self.skill_cat
end

function HeroSkillTemplate:GetSummonFormationList()
  if string.IsNullOrEmpty(self.summon_formation) then
    return nil
  end
  if self.summonFormationList == nil then
    self.summonFormationList = string.string2array_num(self.summon_formation, ",", ";")
  end
  return self.summonFormationList
end

function HeroSkillTemplate:IsHeroAwakenSkill()
  return self.displayCast_type_new == SkillCastType.HeroAwaken
end

function HeroSkillTemplate:IsTimePauseAwakenSkill()
  return self.awake_not_stop == 0
end

function HeroSkillTemplate:IsUltimateSkill()
  return self.displayCast_type_new == SkillCastType.Active
end

return HeroSkillTemplate
