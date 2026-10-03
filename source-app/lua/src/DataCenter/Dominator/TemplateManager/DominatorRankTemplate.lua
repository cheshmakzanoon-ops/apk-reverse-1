local DominatorRankTemplate = BaseClass("DominatorRankTemplate")
local Localization = CS.GameEntry.Localization

function DominatorRankTemplate:__init()
  self.id = 0
  self.group = 0
  self.level_num = 0
  self.star_judge = 0
  self.attr_value = ""
  self.item_cost = 0
  self.level_order = 0
  self.effectDict = {}
  self.effects = {}
end

function DominatorRankTemplate:__delete()
  self.id = nil
  self.group = nil
  self.level_num = nil
  self.star_judge = nil
  self.attr_value = nil
  self.item_cost = nil
  self.level_order = nil
  self.effectDict = nil
  self.effects = nil
end

function DominatorRankTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.group = rowData:getValue("group") or 0
  self.level_num = rowData:getValue("level_num") or 0
  self.star_judge = rowData:getValue("star_judge") or 0
  self.attr_value = rowData:getValue("attr_value") or ""
  self.item_cost = rowData:getValue("item_cost") or 0
  self.level_order = rowData:getValue("level_order") or 0
  self.effects = {}
  if not string.IsNullOrEmpty(self.attr_value) then
    local splitStr = string.split(self.attr_value, "|")
    if 0 < #splitStr then
      for _, v in pairs(splitStr) do
        local splitStrSub = string.split(v, ";")
        if #splitStrSub == 2 then
          local id = tonumber(splitStrSub[1])
          local value = tonumber(splitStrSub[2])
          if id and value then
            table.insert(self.effects, {effectId = id, effectValue = value})
            self.effectDict[id] = value
          end
        end
      end
    end
  end
end

function DominatorRankTemplate:GetLevelCountInBigRank()
  local rankShowTemplate = self:GetRankShowTemplate()
  if rankShowTemplate ~= nil then
    return rankShowTemplate.max_level
  end
  return 0
end

function DominatorRankTemplate:GetLevelOrderInBigRank()
  return self.level_order
end

function DominatorRankTemplate:IsMaxRank()
  local showRankTemplate = self:GetRankShowTemplate()
  if showRankTemplate ~= nil and showRankTemplate:IsMaxBigRank() then
    return self.level_order >= showRankTemplate.max_level
  end
  return false
end

function DominatorRankTemplate:GetRankShowTemplate()
  return DataCenter.DominatorTemplateManager:GetRankShowTemplateById(self.star_judge)
end

function DominatorRankTemplate:GetRankShowAppearanceId()
  local rankShowTemplate = self:GetRankShowTemplate()
  if rankShowTemplate ~= nil then
    return rankShowTemplate.dominator_appearance
  end
  return 0
end

function DominatorRankTemplate:GetEffectValueById(effectId)
  local id = tonumber(effectId)
  if id then
    return self.effectDict[id]
  end
  return 0
end

function DominatorRankTemplate:IsContainsEffect(effectId)
  if self.effectDict and self.effectDict[effectId] then
    return true
  end
  return false
end

function DominatorRankTemplate:IsInitLevel()
  return self.level_num == 0
end

function DominatorRankTemplate:GetFakeEffectInfoForPreview()
  if self:IsInitLevel() then
    return {
      {
        effectId = HeroEffectDefine.DominatorRankAttack,
        effectValue = 0
      },
      {
        effectId = HeroEffectDefine.DominatorRankDefence,
        effectValue = 0
      },
      {
        effectId = HeroEffectDefine.DominatorRankHp,
        effectValue = 0
      }
    }
  else
    return self.effects
  end
end

function DominatorRankTemplate:GetAllEffectInfo()
  return self.effects
end

function DominatorRankTemplate:GetNextRankTemplate()
  if self:IsMaxRank() then
    return nil
  end
  local nextId = self.id + 1
  local next = DataCenter.DominatorTemplateManager:GetRankTemplateById(nextId)
  if next and next.group == self.group then
    return next
  end
end

function DominatorRankTemplate:GetShowLevelText()
  return "Lv." .. tostring(self.level_num)
end

return DominatorRankTemplate
