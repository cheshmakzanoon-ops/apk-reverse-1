local DominatorMainTemplate = BaseClass("DominatorMainTemplate")
local Localization = CS.GameEntry.Localization

function DominatorMainTemplate:__init()
  self.id = 0
  self.dominator_id = 0
  self.order = 0
  self.dominator_star_id = 0
  self.dominator_skill_cost = 0
  self.rank_goods = 0
  self.select_pic = ""
  self.unselect_pic = ""
  self.default_name = ""
  self.core_skill_show = 0
  self.team_limit_level = 0
  self.default_appearance = 0
  self.small_pic_path = ""
  self.story_group_id = 0
  self.rank_preview = 0
  self.skill_show = {}
  self.main_building_icon = ""
  self.skillUnlockInfo = nil
  self.skillShowInfo = nil
end

function DominatorMainTemplate:__delete()
  self.id = nil
  self.dominator_id = nil
  self.order = nil
  self.dominator_star_id = nil
  self.dominator_skill_cost = nil
  self.rank_goods = nil
  self.select_pic = nil
  self.unselect_pic = nil
  self.default_name = nil
  self.core_skill_show = nil
  self.team_limit_level = nil
  self.default_appearance = nil
  self.small_pic_path = nil
  self.story_group_id = nil
  self.rank_preview = nil
  self.skill_show = nil
  self.main_building_icon = nil
  self.skillUnlockInfo = nil
  self.skillShowInfo = nil
end

function DominatorMainTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.dominator_id = rowData:getValue("dominator_id") or 0
  self.order = rowData:getValue("order") or 0
  self.dominator_star_id = rowData:getValue("dominator_star_id") or 0
  self.dominator_skill_cost = rowData:getValue("dominator_skill_cost") or 0
  self.rank_goods = rowData:getValue("rank_goods") or 0
  self.select_pic = rowData:getValue("select_pic") or ""
  self.unselect_pic = rowData:getValue("unselect_pic") or ""
  self.default_name = rowData:getValue("default_name") or ""
  self.core_skill_show = rowData:getValue("core_skill_show") or 0
  self.team_limit_level = rowData:getValue("team_limit_level") or 0
  self.default_appearance = rowData:getValue("default_appearance") or 0
  self.small_pic_path = rowData:getValue("small_pic_path") or ""
  self.story_group_id = rowData:getValue("story_group_id") or 0
  self.rank_preview = rowData:getValue("rank_preview") or 0
  self.skill_show = rowData:getValue("skill_show") or {}
  self.main_building_icon = rowData:getValue("main_building_icon") or ""
end

function DominatorMainTemplate:GetName()
  return Localization:GetString(self.default_name)
end

function DominatorMainTemplate:GetHeroTemplate()
  return DataCenter.HeroTemplateManager:GetTemplate(self.dominator_id)
end

function DominatorMainTemplate:GetCenterSkillIndex()
  local heroTemplate = self:GetHeroTemplate()
  if heroTemplate and not table.IsNullOrEmpty(heroTemplate.skills) then
    for i, v in pairs(heroTemplate.skills) do
      if v == self.core_skill_show then
        return i
      end
    end
  end
  return 0
end

function DominatorMainTemplate:GetCenterSkillGroupId()
  local heroTemplate = self:GetHeroTemplate()
  if heroTemplate and not table.IsNullOrEmpty(heroTemplate.skills) then
    for i, v in pairs(heroTemplate.skills) do
      if v == self.core_skill_show then
        return v
      end
    end
  end
  return 0
end

function DominatorMainTemplate:GetUpgradeRankCostItemId()
  return self.rank_goods
end

function DominatorMainTemplate:GetSkillUnlockInfo()
  if self.skillUnlockInfo == nil then
    self.skillUnlockInfo = {}
    local heroTemplate = self:GetHeroTemplate()
    if heroTemplate and not table.IsNullOrEmpty(heroTemplate.skills) then
      local centerSkillGroupId = self:GetCenterSkillGroupId()
      for _, skillGroupId in pairs(heroTemplate.skills) do
        local baseSkillTemplate = DataCenter.HeroSkillTemplateManager:GetTemplate(skillGroupId)
        if baseSkillTemplate then
          local maxStar = baseSkillTemplate.maxStar
          for star = 0, maxStar do
            local skillTemplate = DataCenter.HeroSkillTemplateManager:GetTemplateByGroupIdAndStar(skillGroupId, star)
            if skillTemplate and 0 < skillTemplate.needRank then
              if self.skillUnlockInfo[skillTemplate.needRank] == nil then
                self.skillUnlockInfo[skillTemplate.needRank] = {}
              end
              local unlockInfo = {
                skillId = skillGroupId + star,
                isCenter = centerSkillGroupId == skillGroupId,
                skillGroupId = skillGroupId
              }
              table.insert(self.skillUnlockInfo[skillTemplate.needRank], unlockInfo)
            end
          end
        end
      end
    end
  end
  return self.skillUnlockInfo
end

function DominatorMainTemplate:GetSkillUnlockInfoByRankId(rankId)
  local rankTemplate = DataCenter.DominatorTemplateManager:GetRankTemplateById(rankId)
  if rankTemplate then
    local allSkillUnlockInfo = self:GetSkillUnlockInfo()
    if allSkillUnlockInfo then
      return allSkillUnlockInfo[rankTemplate.level_num]
    end
  end
end

function DominatorMainTemplate:GetSkillUpgradeCostItemId()
  return self.dominator_skill_cost
end

function DominatorMainTemplate:GetSmallPicPath()
  if string.IsNullOrEmpty(self.small_pic_path) then
    return LoadPath.DominatorDefaultRoundIcon
  end
  return string.format(LoadPath.DominatorRoundIconPath, self.small_pic_path)
end

function DominatorMainTemplate:IsShowRankPreview()
  return self.rank_preview == 1
end

function DominatorMainTemplate:GetStoryShowGroupId()
  return self.story_group_id
end

function DominatorMainTemplate:GetSkillShowInfo()
  if self.skillShowInfo == nil then
    self.skillShowInfo = {}
    if not table.IsNullOrEmpty(self.skill_show) then
      for i, v in pairs(self.skill_show) do
        self.skillShowInfo[tostring(v)] = true
      end
    end
  end
  return self.skillShowInfo
end

function DominatorMainTemplate:IsShowSkillBySkillGroup(skillGroupId)
  local skillShowInfo = self:GetSkillShowInfo()
  return skillShowInfo[tostring(skillGroupId)] == true
end

return DominatorMainTemplate
