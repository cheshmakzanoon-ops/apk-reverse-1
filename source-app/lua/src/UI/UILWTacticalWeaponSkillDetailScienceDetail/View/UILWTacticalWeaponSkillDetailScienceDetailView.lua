local UILWTacticalWeaponSkillDetailView = require("UI.UILWTacticalWeaponSkillDetail.View.UILWTacticalWeaponSkillDetailView")
local UILWTacticalWeaponSkillDetailScienceDetailView = BaseClass("UILWTacticalWeaponSkillDetailScienceDetailView", UILWTacticalWeaponSkillDetailView)
local base = UILWTacticalWeaponSkillDetailView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UIHeroSkillItem = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillItem")
local UIHeroSkillEffectLine = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillEffectLine")
local UIHeroSkillStar = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillStar")
local UIHeroSkillDesc = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillDesc")

function UILWTacticalWeaponSkillDetailScienceDetailView:ComponentDefine()
  base.ComponentDefine(self)
  self.textScienceDesc = self:AddComponent(UIText, "Root/ImgBg/SkillBasicInfo/ScienceDetailText")
end

function UILWTacticalWeaponSkillDetailScienceDetailView:ComponentDestroy()
  base.ComponentDestroy(self)
  self.textScienceDesc = nil
end

function UILWTacticalWeaponSkillDetailScienceDetailView:OnOpen()
  base.OnOpen(self)
  local titleText, skillData, alignObject, clickScreenPos
  skillData, alignObject, clickScreenPos, titleText = self:GetUserData()
  if titleText then
    self.textScienceDesc:SetText(titleText)
  end
end

function UILWTacticalWeaponSkillDetailScienceDetailView:UpdateView()
  self.root.transform:Set_localScale(1, 1, 1)
  self.root.transform:Set_localEulerAngles(0, 0, 0)
  if self.skillData == nil then
    return
  end
  if not self.skillData then
    return
  end
  self.skillItem:SetData(self.skillData, {
    showSkillName = false,
    showSkillLevel = false,
    showLock = false
  }, nil)
  local nameStr = self.skillData:GetName()
  self.nameText:SetText(nameStr)
  self.skillStars:RemoveComponents(UIHeroSkillStar)
  self.skillStarTemplate.gameObject:GameObjectRecycleAll()
  local maxStar = self.skillData:GetMaxStar()
  local curStar = self.skillData:GetStar()
  for i = 1, maxStar do
    local item = self.skillStarTemplate:GameObjectSpawn(self.skillStars.transform)
    item.name = "star" .. i
    local cell = self.skillStars:AddComponent(UIHeroSkillStar, item.name)
    cell:SetFilled(i <= curStar)
    if i <= curStar then
      cell:SetStarIndex(i)
    end
  end
  self.skillDescText:SetText(self.skillData:GetDesc(false, "#5FEF87"))
  self.nextEffectGroup:RemoveComponents(UIHeroSkillEffectLine)
  self.nextEffectLineTemplate.gameObject:GameObjectRecycleAll()
  local effectsDesc = self.skillData:GetEffectsDescWeapon()
  local realSkillLvLimit = self.skillData:GetStar()
  if 0 < #effectsDesc then
    for i = 1, #effectsDesc do
      local effect = effectsDesc[i]
      if not realSkillLvLimit or realSkillLvLimit >= effect.unlockStar then
        self.nextEffectGroup:SetActive(true)
        local item = self.nextEffectLineTemplate:GameObjectSpawn(self.nextEffectGroup.transform)
        item.name = "item" .. i
        local cell = self.nextEffectGroup:AddComponent(UIHeroSkillEffectLine, item.name)
        cell:SetData(effectsDesc[i].isUnlock, effectsDesc[i].outDesc, i)
      end
    end
  else
    self.nextEffectGroup:SetActive(false)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bgRoot.transform)
  self:CheckAlign()
end

return UILWTacticalWeaponSkillDetailScienceDetailView
