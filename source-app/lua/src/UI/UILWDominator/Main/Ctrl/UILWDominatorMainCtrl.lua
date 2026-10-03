local UILWDominatorMainCtrl = BaseClass("UILWDominatorMainCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local UILWDominatorMainBasicPageComponent = require("UI/UILWDominator/Main/Component/BasicPage/UILWDominatorMainBasicPageComponent")
local UILWDominatorMainAdvancePageComponent = require("UI/UILWDominator/Main/Component/AdvancePage/UILWDominatorMainAdvancePageComponent")
local UILWDominatorMainSkillPageComponent = require("UI/UILWDominator/Main/Component/SkillPage/UILWDominatorMainSkillPageComponent")
local UILWDominatorMainTrainPageComponent = require("UI/UILWDominator/Main/Component/TrainPage/UILWDominatorMainTrainPageComponent")
local UILWDominatorMainRankPreviewPageComponent = require("UI/UILWDominator/Main/Component/RankPreview/UILWDominatorMainRankPreviewPageComponent")
local PHYSICAL_COLOR = Color.New(0.9764706, 0.4352941, 0.4666667, 1)
local ENERGY_COLOR = Color.New(0.7215686, 0.3254902, 0.9254902, 1)
local DEBUFF_COLOR = Color.New(1, 0.3215686, 0.2470588, 1)
local BUFF_COLOR = Color.New(0.454902, 0.8235294, 0.5254902, 1)

function UILWDominatorMainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWDominatorMain)
end

function UILWDominatorMainCtrl:GetPageTagText(tag)
  if tag == UILWDominatorMainPageTag.Basic then
    return Localization:GetString("dominator_overview_button_1")
  elseif tag == UILWDominatorMainPageTag.Rank then
    return Localization:GetString("dominator_overview_button_2")
  elseif tag == UILWDominatorMainPageTag.Train then
    return Localization:GetString("dominator_overview_button_4")
  elseif tag == UILWDominatorMainPageTag.Skill then
    return Localization:GetString("dominator_overview_button_3")
  end
  return ""
end

function UILWDominatorMainCtrl:IsShowPageTag(tag, mainId)
  if mainId == DominatorId.Gorilla then
    local info = DataCenter.DominatorManager:GetInfoById(mainId)
    if info ~= nil then
      if tag == UILWDominatorMainPageTag.Basic then
        return not info:IsInTreatment()
      elseif tag == UILWDominatorMainPageTag.Rank then
        if not info:IsInTreatment() and DataCenter.DominatorManager:IsUpgradeRankAndSkillUnlock() and DataCenter.DominatorGuideManager:IsHasShownUpgradeRankAndSkillUnlockAnim() then
          return true
        end
        return false
      elseif tag == UILWDominatorMainPageTag.Skill then
        if not info:IsInTreatment() and DataCenter.DominatorManager:IsUpgradeRankAndSkillUnlock() and DataCenter.DominatorGuideManager:IsHasShownUpgradeRankAndSkillUnlockAnim() then
          return true
        end
        return false
      end
      return true
    end
  elseif mainId == DominatorId.Cockatrice then
    local info = DataCenter.DominatorManager:GetInfoById(mainId)
    if info ~= nil then
      if tag == UILWDominatorMainPageTag.Rank then
        if DataCenter.DominatorManager:IsUpgradeRankAndSkillUnlock() and DataCenter.DominatorGuideManager:IsHasShownUpgradeRankAndSkillUnlockAnim() then
          return true
        end
        return false
      elseif tag == UILWDominatorMainPageTag.Skill then
        if DataCenter.DominatorManager:IsUpgradeRankAndSkillUnlock() and DataCenter.DominatorGuideManager:IsHasShownUpgradeRankAndSkillUnlockAnim() then
          return true
        end
        return false
      end
      return true
    end
  end
  return true
end

function UILWDominatorMainCtrl:GetPagePrefabPath(tag)
  if tag == UILWDominatorMainPageTag.Basic then
    return "Assets/Main/Prefabs/UI/LWDominator/Main/UILWDominatorMainBasicPage.prefab"
  elseif tag == UILWDominatorMainPageTag.Rank then
    return "Assets/Main/Prefabs/UI/LWDominator/Main/UILWDominatorMainAdvancePage.prefab"
  elseif tag == UILWDominatorMainPageTag.Train then
    return "Assets/Main/Prefabs/UI/LWDominator/Main/UILWDominatorMainTrainPage.prefab"
  elseif tag == UILWDominatorMainPageTag.Skill then
    return "Assets/Main/Prefabs/UI/LWDominator/Main/UILWDominatorMainSkillPage.prefab"
  elseif tag == UILWDominatorMainPageTag.RankPreview then
    return "Assets/Main/Prefabs/UI/LWDominator/Main/UILWDominatorMainRankPreviewPage.prefab"
  end
  return ""
end

function UILWDominatorMainCtrl:GetPageClass(tag)
  if tag == UILWDominatorMainPageTag.Basic then
    return UILWDominatorMainBasicPageComponent
  elseif tag == UILWDominatorMainPageTag.Rank then
    return UILWDominatorMainAdvancePageComponent
  elseif tag == UILWDominatorMainPageTag.Train then
    return UILWDominatorMainTrainPageComponent
  elseif tag == UILWDominatorMainPageTag.Skill then
    return UILWDominatorMainSkillPageComponent
  elseif tag == UILWDominatorMainPageTag.RankPreview then
    return UILWDominatorMainRankPreviewPageComponent
  end
  return nil
end

function UILWDominatorMainCtrl:GetAdvancePageShowEffects(info)
  if not info then
    return nil
  end
  local curRankTemplate = info:GetCurRankTemplate()
  if not curRankTemplate then
    return nil
  end
  local res = {}
  local showEffectDict = {}
  local curRankEffects = curRankTemplate:GetAllEffectInfo()
  local index = 1
  if not table.IsNullOrEmpty(curRankEffects) then
    for i, v in ipairs(curRankEffects) do
      showEffectDict[i] = {
        index = index,
        curValue = v.effectValue,
        effectId = v.effectId,
        title = Localization:GetString(GetTableData(TableName.LW_Effect_Number, v.effectId, "name", ""))
      }
      index = index + 1
    end
  end
  local nextRankTemplate = curRankTemplate:GetNextRankTemplate()
  if nextRankTemplate then
    local nextRankEffects = nextRankTemplate:GetAllEffectInfo()
    if not table.IsNullOrEmpty(nextRankEffects) then
      for i, v in ipairs(nextRankEffects) do
        if showEffectDict[i] then
          showEffectDict[i].nextValue = v.effectValue
        else
          showEffectDict[i] = {
            index = index,
            curValue = 0,
            nextValue = v.effectValue,
            effectId = v.effectId,
            title = Localization:GetString(GetTableData(TableName.LW_Effect_Number, v.effectId, "name", ""))
          }
          index = index + 1
        end
      end
    end
  end
  for i, v in pairs(showEffectDict) do
    table.insert(res, v)
  end
  table.sort(res, function(a, b)
    return a.index < b.index
  end)
  return res
end

function UILWDominatorMainCtrl:GetSkillDamageTypeIcon(displayType)
  if displayType == SkillDisplayType.PhysicalDamage then
    return "Assets/Main/Sprites/UI/UIHeroCommon/zyf_jinengleixin_wulishanghai.png"
  elseif displayType == SkillDisplayType.EnergyDamage then
    return "Assets/Main/Sprites/UI/UIHeroCommon/zyf_jinengleixin_nengliangshanghai.png"
  elseif displayType == SkillDisplayType.PhysicalDefense then
    return "Assets/Main/Sprites/UI/UIHeroCommon/zyf_jinengleixin_wulifangyu.png"
  elseif displayType == SkillDisplayType.EnergyDefense then
    return "Assets/Main/Sprites/UI/UIHeroCommon/zyf_jinengleixin_nengliangfangyu.png"
  elseif displayType == SkillDisplayType.Buff then
    return "Assets/Main/Sprites/UI/UIHeroCommon/zyf_shibingzhuangtai_injury.png"
  elseif displayType == SkillDisplayType.Debuff then
    return "Assets/Main/Sprites/UI/UIHeroCommon/zyf_shibingzhuangtai_death.png"
  end
  return ""
end

function UILWDominatorMainCtrl:GetSkillDamageTypeText(displayType)
  if displayType == SkillDisplayType.PhysicalDamage then
    return Localization:GetString("skill_detail_panel_5")
  elseif displayType == SkillDisplayType.EnergyDamage then
    return Localization:GetString("skill_detail_panel_6")
  elseif displayType == SkillDisplayType.PhysicalDefense then
    return Localization:GetString("skill_detail_panel_7")
  elseif displayType == SkillDisplayType.EnergyDefense then
    return Localization:GetString("skill_detail_panel_8")
  elseif displayType == SkillDisplayType.Buff then
    return Localization:GetString("skill_detail_panel_10")
  elseif displayType == SkillDisplayType.Debuff then
    return Localization:GetString("skill_detail_panel_11")
  end
  return ""
end

function UILWDominatorMainCtrl:GetSkillDamageTypeTextColor(displayType)
  if displayType == SkillDisplayType.PhysicalDamage then
    return PHYSICAL_COLOR
  elseif displayType == SkillDisplayType.EnergyDamage then
    return ENERGY_COLOR
  elseif displayType == SkillDisplayType.PhysicalDefense then
    return PHYSICAL_COLOR
  elseif displayType == SkillDisplayType.EnergyDefense then
    return ENERGY_COLOR
  elseif displayType == SkillDisplayType.Buff then
    return BUFF_COLOR
  elseif displayType == SkillDisplayType.Debuff then
    return DEBUFF_COLOR
  end
end

function UILWDominatorMainCtrl:GetSkillDamageTypeIconColor(displayType)
  if displayType == SkillDisplayType.PhysicalDamage then
    return WhiteColor
  elseif displayType == SkillDisplayType.EnergyDamage then
    return WhiteColor
  elseif displayType == SkillDisplayType.PhysicalDefense then
    return WhiteColor
  elseif displayType == SkillDisplayType.EnergyDefense then
    return WhiteColor
  elseif displayType == SkillDisplayType.Buff then
    return BUFF_COLOR
  elseif displayType == SkillDisplayType.Debuff then
    return DEBUFF_COLOR
  end
end

function UILWDominatorMainCtrl:ShowDominatorSelectContent(curTag)
  return curTag == UILWDominatorMainPageTag.Basic
end

function UILWDominatorMainCtrl:ShowPageToggles(tag)
  return tag ~= UILWDominatorMainPageTag.RankPreview
end

function UILWDominatorMainCtrl:ShowModel(dominatorId, tag)
  return tag ~= UILWDominatorMainPageTag.Train
end

return UILWDominatorMainCtrl
