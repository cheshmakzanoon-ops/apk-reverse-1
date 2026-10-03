local DominatorTrainLevelTemplate = BaseClass("DominatorTrainLevelTemplate")
local Localization = CS.GameEntry.Localization

function DominatorTrainLevelTemplate:__init()
  self.id = 0
  self.level_group = 0
  self.level_order = 0
  self.pre_level = ""
  self.attr_value_hero = ""
  self.attr_value_dominator = ""
  self.level_cost = ""
  self.level_limit = ""
  self.grade_key = ""
  self.grade_num = 0
  self.key_color = 0
  self.grade_order = ""
  self.march_size = ""
  self.power_adjust_factor = ""
  self.level_limit_key = ""
  self.level_view_limit_key = ""
  self.dominatorEffects = nil
  self.heroEffects = nil
  self.combineEffects = nil
end

function DominatorTrainLevelTemplate:__delete()
  self.id = nil
  self.level_group = nil
  self.level_order = nil
  self.pre_level = nil
  self.attr_value_hero = nil
  self.attr_value_dominator = nil
  self.level_cost = nil
  self.level_limit = nil
  self.grade_key = nil
  self.grade_num = nil
  self.key_color = nil
  self.grade_order = nil
  self.march_size = nil
  self.power_adjust_factor = nil
  self.level_limit_key = nil
  self.level_view_limit_key = nil
  self.dominatorEffects = nil
  self.heroEffects = nil
  self.combineEffects = nil
end

function DominatorTrainLevelTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.level_group = rowData:getValue("level_group") or 0
  self.level_order = rowData:getValue("level_order") or 0
  self.pre_level = rowData:getValue("pre_level") or ""
  self.attr_value_hero = rowData:getValue("attr_value_hero") or ""
  self.attr_value_dominator = rowData:getValue("attr_value_dominator") or ""
  self.level_cost = rowData:getValue("level_cost") or ""
  self.level_limit = rowData:getValue("level_limit") or ""
  self.grade_key = rowData:getValue("grade_key") or ""
  self.grade_num = rowData:getValue("grade_num") or 0
  self.key_color = rowData:getValue("key_color") or 0
  self.grade_order = rowData:getValue("grade_order") or ""
  self.march_size = rowData:getValue("march_size") or ""
  self.power_adjust_factor = rowData:getValue("power_adjust_factor") or ""
  self.level_limit_key = rowData:getValue("level_limit_key") or ""
  self.level_view_limit_key = rowData:getValue("level_view_limit_key") or ""
end

function DominatorTrainLevelTemplate:GetGroupTemplate()
  return DataCenter.DominatorTemplateManager:GetTrainGroupTemplateById(self.level_group)
end

function DominatorTrainLevelTemplate:GetGroupType()
  local groupTemplate = self:GetGroupTemplate()
  if groupTemplate ~= nil then
    return groupTemplate.type
  end
  return 0
end

function DominatorTrainLevelTemplate:GetName(includeLevelNumber)
  if includeLevelNumber == nil then
    includeLevelNumber = true
  end
  if includeLevelNumber and self.level_order > 0 then
    return Localization:GetString(self.grade_key) .. " " .. NumToRoman(self.grade_num)
  else
    return Localization:GetString(self.grade_key)
  end
end

function DominatorTrainLevelTemplate:GetColoredName(includeLevelNumber)
  local name = self:GetName(includeLevelNumber)
  local textColor = self:GetNameTextColor()
  if textColor then
    return string.format("<color=%s>%s</color>", textColor, name)
  else
    return name
  end
end

function DominatorTrainLevelTemplate:GetUpgradeRequireIdList()
  local res = {}
  if not string.IsNullOrEmpty(self.level_limit) then
    local splitStr = string.split(self.level_limit, ";")
    for i, v in pairs(splitStr) do
      table.insert(res, tonumber(v) or 0)
    end
  end
  return res
end

function DominatorTrainLevelTemplate:GetRequireLevelMain()
  local groupTemplate = self:GetGroupTemplate()
  if groupTemplate and groupTemplate.type == DominatorTrainGroupType.Main then
    local requires = self:GetUpgradeRequireIdList()
    for _, levelId in pairs(requires) do
      local levelTemplate = DataCenter.DominatorTemplateManager:GetTrainLevelTemplateById(levelId)
      if levelTemplate and levelTemplate:GetGroupType() == DominatorTrainGroupType.Normal then
        return levelTemplate.level_order
      end
    end
  end
  return 0
end

function DominatorTrainLevelTemplate:GetRequireText()
  if not string.IsNullOrEmpty(self.level_limit_key) then
    local splitStr = string.split_ss_array(self.level_limit_key, "|")
    if #splitStr == 1 then
      return Localization:GetString(splitStr[1])
    elseif #splitStr == 2 then
      return Localization:GetString(splitStr[1], splitStr[2])
    end
  end
  return ""
end

function DominatorTrainLevelTemplate:GetRequireTextForPreview()
  if not string.IsNullOrEmpty(self.level_view_limit_key) then
    local splitStr = string.split_ss_array(self.level_view_limit_key, "|")
    if #splitStr == 1 then
      return Localization:GetString(splitStr[1])
    elseif #splitStr == 2 then
      return Localization:GetString(splitStr[1], splitStr[2])
    end
  end
  return ""
end

function DominatorTrainLevelTemplate:GetUpgradeCostInfo()
  local res = {}
  if not string.IsNullOrEmpty(self.level_cost) then
    local strSplit = string.split(self.level_cost, "|")
    for i, v in pairs(strSplit) do
      local strSplitSub = string.split(v, ";")
      if #strSplitSub == 2 then
        local info = {
          itemId = tonumber(strSplitSub[1]) or 0,
          count = tonumber(strSplitSub[2]) or 0
        }
        table.insert(res, info)
      end
    end
  end
  return res
end

function DominatorTrainLevelTemplate:GetDominatorEffects()
  if self.dominatorEffects == nil then
    self.dominatorEffects = {}
    if not string.IsNullOrEmpty(self.attr_value_dominator) then
      local splitStr = string.split(self.attr_value_dominator, "|")
      if 0 < #splitStr then
        for _, v in pairs(splitStr) do
          local splitStrSub = string.split(v, ";")
          if #splitStrSub == 2 then
            local id = tonumber(splitStrSub[1])
            local value = tonumber(splitStrSub[2])
            if id and value then
              table.insert(self.dominatorEffects, {effectId = id, effectValue = value})
            end
          end
        end
      end
    end
    local scValue = checknumber(self.march_size)
    if 0 < scValue then
      table.insert(self.dominatorEffects, {
        effectId = HeroEffectDefine.DominatorMainTrainGroupSoldierCapacity,
        effectValue = scValue
      })
    end
  end
  return self.dominatorEffects
end

function DominatorTrainLevelTemplate:GetHeroEffects()
  if self.heroEffects == nil then
    self.heroEffects = {}
    if not string.IsNullOrEmpty(self.attr_value_hero) then
      local splitStr = string.split(self.attr_value_hero, "|")
      if 0 < #splitStr then
        for _, v in pairs(splitStr) do
          local splitStrSub = string.split(v, ";")
          if #splitStrSub == 2 then
            local id = tonumber(splitStrSub[1])
            local value = tonumber(splitStrSub[2])
            if id and value then
              table.insert(self.heroEffects, {effectId = id, effectValue = value})
            end
          end
        end
      end
    end
  end
  return self.heroEffects
end

function DominatorTrainLevelTemplate:GetCombineEffects()
  if self.combineEffects == nil then
    self.combineEffects = {}
    local heroEffects = self:GetHeroEffects()
    local dominatorEffects = self:GetDominatorEffects()
    local effectDictTmp = {}
    for i, v in pairs(heroEffects) do
      if effectDictTmp[v.effectId] then
        effectDictTmp[v.effectId] = effectDictTmp[v.effectId] + v.effectValue
      else
        effectDictTmp[v.effectId] = v.effectValue
      end
    end
    for i, v in pairs(dominatorEffects) do
      if effectDictTmp[v.effectId] then
        effectDictTmp[v.effectId] = effectDictTmp[v.effectId] + v.effectValue
      else
        effectDictTmp[v.effectId] = v.effectValue
      end
    end
    for i, v in pairs(heroEffects) do
      if effectDictTmp[v.effectId] then
        table.insert(self.combineEffects, {
          effectId = v.effectId,
          effectValue = effectDictTmp[v.effectId]
        })
        effectDictTmp[v.effectId] = nil
      end
    end
    for i, v in pairs(dominatorEffects) do
      if effectDictTmp[v.effectId] then
        table.insert(self.combineEffects, {
          effectId = v.effectId,
          effectValue = effectDictTmp[v.effectId]
        })
        effectDictTmp[v.effectId] = nil
      end
    end
  end
  return self.combineEffects
end

function DominatorTrainLevelTemplate:IsContainsEffect(effectId)
  local allEffects = self:GetCombineEffects()
  for i, v in pairs(allEffects) do
    if v.effectId == effectId then
      return true
    end
  end
  return false
end

function DominatorTrainLevelTemplate:IsMaxLevel()
  local groupTemplate = self:GetGroupTemplate()
  if groupTemplate ~= nil then
    return self.level_order >= groupTemplate.max_level
  end
  return false
end

function DominatorTrainLevelTemplate:GetNextLevelTemplate()
  if self:IsMaxLevel() then
    return nil
  end
  local nextLevelId = self.level_group + self.level_order + 1
  return DataCenter.DominatorTemplateManager:GetTrainLevelTemplateById(nextLevelId)
end

function DominatorTrainLevelTemplate:GetPreviousLevelTemplate()
  if self:IsInitLevel() then
    return nil
  end
  local preLevelId = self.level_group + self.level_order - 1
  return DataCenter.DominatorTemplateManager:GetTrainLevelTemplateById(preLevelId)
end

function DominatorTrainLevelTemplate:IsRequireOK()
  local requires = self:GetUpgradeRequireIdList()
  for i, v in pairs(requires) do
    local levelTemplate = DataCenter.DominatorTemplateManager:GetTrainLevelTemplateById(v)
    if levelTemplate then
      local groupTemplate = levelTemplate:GetGroupTemplate()
      if groupTemplate then
        local curLevel = DataCenter.DominatorManager:GetTrainLevelByGroupId(groupTemplate.id)
        if curLevel < levelTemplate.level_order then
          return false
        end
      end
    end
  end
  return true
end

function DominatorTrainLevelTemplate:GetNameTextColor()
  if self.key_color == 1 then
    return "#eae6ec"
  elseif self.key_color == 2 then
    return "#5fef87"
  elseif self.key_color == 3 then
    return "#099b4a"
  elseif self.key_color == 4 then
    return "#70e6f1"
  elseif self.key_color == 5 then
    return "#249bc5"
  elseif self.key_color == 6 then
    return "#eb86ff"
  elseif self.key_color == 7 then
    return "#c03ed3"
  elseif self.key_color == 8 then
    return "#844bec"
  elseif self.key_color == 9 then
    return "#ffc976"
  elseif self.key_color == 10 then
    return "#e3752c"
  elseif self.key_color == 11 then
    return "#eb5234"
  elseif self.key_color == 12 then
    return "#f53c3d"
  end
end

function DominatorTrainLevelTemplate:GetQualityImageColorRGBA()
  if self.key_color == 1 then
    return true, 234, 230, 236, 255
  elseif self.key_color == 2 then
    return true, 95, 239, 135, 255
  elseif self.key_color == 3 then
    return true, 9, 155, 74, 255
  elseif self.key_color == 4 then
    return true, 112, 230, 241, 255
  elseif self.key_color == 5 then
    return true, 36, 155, 197, 255
  elseif self.key_color == 6 then
    return true, 235, 134, 255, 255
  elseif self.key_color == 7 then
    return true, 192, 62, 211, 255
  elseif self.key_color == 8 then
    return true, 132, 75, 236, 255
  elseif self.key_color == 9 then
    return true, 255, 201, 118, 255
  elseif self.key_color == 10 then
    return true, 227, 117, 44, 255
  elseif self.key_color == 11 then
    return true, 235, 82, 52, 255
  elseif self.key_color == 12 then
    return true, 245, 60, 61, 255
  end
  return false
end

function DominatorTrainLevelTemplate:GetNumberIconPath()
  if self.grade_num > 0 then
    return string.format(LoadPath.UILWDominatorTrainLevelNumberIconPath, self.grade_num)
  end
  return ""
end

function DominatorTrainLevelTemplate:GetSoldierCapacity()
  return checknumber(self.march_size)
end

function DominatorTrainLevelTemplate:GetBigLevel()
  return checknumber(self.grade_order)
end

function DominatorTrainLevelTemplate:IsInitLevel()
  return self.level_order == 0
end

function DominatorTrainLevelTemplate:IsFinalBigLevel()
  local allTemplates = DataCenter.DominatorTemplateManager:GetAllMainTrainGroupBigLevelTemplates()
  if allTemplates then
    local maxGradeOrder
    for i, v in pairs(allTemplates) do
      if maxGradeOrder == nil or maxGradeOrder < v.grade_order then
        maxGradeOrder = v.grade_order
      end
    end
    return maxGradeOrder and self:GetBigLevel() == maxGradeOrder
  end
  return false
end

function DominatorTrainLevelTemplate:GetMaxLevelTemplateInThisBigLevel()
  local allTemplates = DataCenter.DominatorTemplateManager:GetAllMainTrainGroupBigLevelTemplates()
  if allTemplates then
    local curBigLevel = self:GetBigLevel()
    for i, v in ipairs(allTemplates) do
      if v.grade_order == curBigLevel then
        return v.maxTemplate
      end
    end
  end
end

return DominatorTrainLevelTemplate
