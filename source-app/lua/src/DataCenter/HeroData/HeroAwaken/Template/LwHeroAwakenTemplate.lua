local LwHeroAwakenTemplate = BaseClass("LwHeroAwakenTemplate")
local Localization = CS.GameEntry.Localization

function LwHeroAwakenTemplate:__init()
  self.id = 0
  self.awaken_unlock_time = {}
  self.awaken_goods_id = 0
  self.awaken_max_level = 0
  self.new_hero_brief = ""
  self.normal_skin_id = 0
  self.unique_weapon_skin_id = 0
  self.awaken_skin_id = 0
  self.advanced_awaken_skin_id = 0
  self.guide_plot_id = 0
  self.skill_short_desc = ""
  self.spine_preview_pic = ""
  self.spine_preview_key = ""
  self.skill_preview_key = ""
  self.extra_skill_effect_line = ""
end

function LwHeroAwakenTemplate:__delete()
  self.id = nil
  self.awaken_unlock_time = nil
  self.awaken_goods_id = nil
  self.awaken_max_level = nil
  self.new_hero_brief = nil
  self.normal_skin_id = nil
  self.unique_weapon_skin_id = nil
  self.awaken_skin_id = nil
  self.advanced_awaken_skin_id = nil
  self.guide_plot_id = nil
  self.skill_short_desc = nil
  self.spine_preview_pic = nil
  self.spine_preview_key = nil
  self.skill_preview_key = nil
  self.extra_skill_effect_line = nil
end

function LwHeroAwakenTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.awaken_unlock_time = rowData:getValue("awaken_unlock_time") or {}
  self.awaken_goods_id = rowData:getValue("awaken_goods_id") or 0
  self.awaken_max_level = rowData:getValue("awaken_max_level") or 0
  self.new_hero_brief = rowData:getValue("new_hero_brief") or ""
  self.normal_skin_id = rowData:getValue("normal_skin_id") or 0
  self.unique_weapon_skin_id = rowData:getValue("unique_weapon_skin_id") or 0
  self.awaken_skin_id = rowData:getValue("awaken_skin_id") or 0
  self.advanced_awaken_skin_id = rowData:getValue("advanced_awaken_skin_id") or 0
  self.guide_plot_id = rowData:getValue("guide_plot_id") or 0
  self.skill_short_desc = rowData:getValue("skill_short_desc") or ""
  self.spine_preview_pic = rowData:getValue("spine_preview_pic") or ""
  self.spine_preview_key = rowData:getValue("spine_preview_key") or ""
  self.skill_preview_key = rowData:getValue("skill_preview_key") or ""
  self.extra_skill_effect_line = rowData:getValue("extra_skill_effect_line") or ""
end

function LwHeroAwakenTemplate:GetHeroAwakenRankUpgradeCostItemId()
  return self.awaken_goods_id
end

function LwHeroAwakenTemplate:GetHeroAwakenMaxRankLevel()
  return self.awaken_max_level
end

function LwHeroAwakenTemplate:GetAwakenEffectValueLineText(isProcess)
  local text = Localization:GetString("hero_awaken_desc_29", Localization:GetString(self.extra_skill_effect_line))
  if isProcess == nil or isProcess == true then
    text = HeroUtils.ProcessHyperText(text, nil, false)
  end
  return text
end

function LwHeroAwakenTemplate:IsTimeOpen()
  if table.IsNullOrEmpty(self.awaken_unlock_time) then
    return true
  end
  if #self.awaken_unlock_time ~= 2 then
    return false
  end
  local startSeason = tonumber(self.awaken_unlock_time[1])
  local startSeasonDay = tonumber(self.awaken_unlock_time[2])
  local curSeason = SeasonUtil.GetSeason()
  if startSeason < curSeason then
    return true
  end
  if startSeason > curSeason then
    return false
  end
  local seasonDay = SeasonUtil.GetSeasonDay()
  return startSeasonDay <= seasonDay
end

return LwHeroAwakenTemplate
