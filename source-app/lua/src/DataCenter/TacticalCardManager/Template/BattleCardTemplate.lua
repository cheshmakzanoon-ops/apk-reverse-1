local BattleCardTemplate = BaseClass("BattleCardTemplate")

function BattleCardTemplate:__init()
  self.id = 0
  self.type = 0
  self.mastery = 0
  self.color = 0
  self.icon = ""
  self.name = ""
  self.attr_base = {}
  self.attr_up = {}
  self.max_lv = 0
  self.max_star = 0
  self.skill = {}
  self.attr_random_count = ""
  self.attr_random = ""
  self.power = {}
  self.attr_random_show = 0
  self.server_can_see = {}
  self.season_can_see = {}
  self.get_more_color = {}
  self.card_group = 0
  self.power_range = {}
  self.card_reward = {}
  self.recommend_id = 0
  self.deck = 0
  self.skill_desc = ""
  self.skill_num = {}
  self.buff_type = ""
  self.icon_new = nil
  self.lvGroup = 0
end

function BattleCardTemplate:__delete()
  self.id = nil
  self.type = nil
  self.mastery = nil
  self.color = nil
  self.icon = nil
  self.name = nil
  self.attr_base = nil
  self.attr_up = nil
  self.max_lv = nil
  self.max_star = nil
  self.skill = nil
  self.attr_random_count = nil
  self.attr_random = nil
  self.power = nil
  self.attr_random_show = nil
  self.server_can_see = nil
  self.season_can_see = nil
  self.get_more_color = nil
  self.card_group = nil
  self.power_range = nil
  self.card_reward = nil
  self.recommend_id = nil
  self.deck = nil
  self.skill_desc = nil
  self.skill_num = nil
  self.buff_type = nil
  self.serverCanSee = nil
  self.icon_new = nil
  self.lvGroup = 0
end

function BattleCardTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.type = rowData:getValue("type") or 0
  self.mastery = rowData:getValue("mastery") or 0
  self.color = rowData:getValue("color") or 0
  self.icon = rowData:getValue("icon") or ""
  self.name = rowData:getValue("name") or ""
  self.attr_base = rowData:getValue("attr_base") or {}
  self.attr_up = rowData:getValue("attr_up") or {}
  self.max_lv = rowData:getValue("max_lv") or 0
  self.max_star = rowData:getValue("max_star") or 0
  self.skill = rowData:getValue("skill") or {}
  self.attr_random_count = rowData:getValue("attr_random_count") or ""
  self.attr_random = rowData:getValue("attr_random") or ""
  self.power = rowData:getValue("power") or {}
  self.attr_random_show = rowData:getValue("attr_random_show") or 0
  self.server_can_see = rowData:getValue("server_can_see") or {}
  self.season_can_see = rowData:getValue("season_can_see") or {}
  self.get_more_color = rowData:getValue("get_more_color") or {}
  self.card_group = rowData:getValue("card_group") or 0
  self.power_range = rowData:getValue("power_range") or {}
  self.card_reward = rowData:getValue("card_reward") or {}
  self.recommend_id = rowData:getValue("recommend_id") or 0
  self.deck = rowData:getValue("deck") or 0
  self.skill_desc = rowData:getValue("skill_desc") or ""
  self.skill_num = rowData:getValue("skill_num") or {}
  self.buff_type = rowData:getValue("buff_type") or ""
  local power = rowData:getValue("power") or {}
  self.basePower = power[1] or 0
  self.upPower = power[2] or 0
  self.recommend_id = rowData:getValue("recommend_id") or 0
  self.serverCanSee = {}
  if self.server_can_see and 0 < #self.server_can_see then
    for i, v in ipairs(self.server_can_see) do
      if not string.IsNullOrEmpty(v) then
        local rangeList = string.split(v, "-")
        if #rangeList == 2 then
          local range = {}
          range.min = tonumber(rangeList[1])
          range.max = tonumber(rangeList[2])
          table.insert(self.serverCanSee, range)
        else
          Logger.LogError("\229\143\130\230\149\176\230\149\176\233\135\143\228\184\141\229\175\185 id:" .. tostring(self.id))
        end
      end
    end
  end
  self.icon_new = rowData:getValue("icon_new") or ""
  self.lvGroup = rowData:getValue("level_group") or 0
end

function BattleCardTemplate:GetBaseAttrs(lv)
  local baseAttrs = {}
  for attrId, value in pairs(self.attr_base) do
    baseAttrs[attrId] = value
  end
  for attrId, value in pairs(self.attr_up) do
    baseAttrs[attrId] = baseAttrs[attrId] + value * lv
  end
  return baseAttrs
end

function BattleCardTemplate:GetSkills()
  return self.skill
end

function BattleCardTemplate:CheckServerCanSee()
  if not self.serverCanSee or #self.serverCanSee == 0 then
    return true
  end
  local serverId = LuaEntry.Player:GetSourceServerId()
  local result = false
  for i, v in ipairs(self.serverCanSee) do
    if v and serverId >= v.min and serverId <= v.max then
      result = true
    end
  end
  return result
end

function BattleCardTemplate:GetBaseSkillDesc(level)
  local descList = self:ParseSkillDescParam()
  if descList == nil or #descList == 0 then
    return self.skill_desc
  end
  local params = descList[level]
  if params == nil then
    params = descList[#descList]
  end
  return self.skill_desc, params
end

function BattleCardTemplate:GetBaseSkillUpgradeDesc(level)
  local desc, params = self:GetBaseSkillDesc(level)
  if params == nil then
    return desc
  end
  local _, paramsUpgrades = self:GetBaseSkillDesc(level + 1)
  if paramsUpgrades == nil then
    return desc
  end
  local paramsCombineList = {}
  for i, v in ipairs(params) do
    local formattedValue = params[i]
    if params[i] and paramsUpgrades[i] and params[i] ~= paramsUpgrades[i] then
      formattedValue = CommonUtil.IsArabic() and string.format("%s (%s<-)", formattedValue, paramsUpgrades[i]) or string.format("%s (->%s)", formattedValue, paramsUpgrades[i])
    end
    table.insert(paramsCombineList, formattedValue)
  end
  return desc, paramsCombineList
end

function BattleCardTemplate:ParseSkillDescParam()
  if self.skill_num == nil or #self.skill_num == 0 then
    return nil
  end
  if self.levelSkillDescList == nil then
    self.levelSkillDescList = {}
    for i, v in ipairs(self.skill_num) do
      if not string.IsNullOrEmpty(v) then
        local paramStringList = string.split(v, ";")
        table.insert(self.levelSkillDescList, paramStringList)
      end
    end
  end
  return self.levelSkillDescList
end

function BattleCardTemplate:IsUseNewSkillDesc()
  return not string.IsNullOrEmpty(self.skill_desc)
end

return BattleCardTemplate
