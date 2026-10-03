local base = UIBaseContainer
local UILWDominatorMainCenterSkillItemComponent = BaseClass("UILWDominatorMainCenterSkillItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIHeroSkillStar = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillStar")

function UILWDominatorMainCenterSkillItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWDominatorMainCenterSkillItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorMainCenterSkillItemComponent:ComponentDefine()
  self.compSelected = self:AddComponent(UIBaseContainer, "Selectbg")
  self.btnSkillItemCenter = self:AddComponent(UIButton, "")
  self.btnSkillItemCenter:SetOnClick(function()
    self:OnBtnSkillItemCenterClick()
  end)
  self.imgIcon = self:AddComponent(UIImage, "Icon")
  self.textSkillLevel = self:AddComponent(UIText, "SkillLevelText")
  self.compStars = self:AddComponent(UIBaseContainer, "Stars")
  self.compStarTemplate = self:AddComponent(UIBaseContainer, "Stars/StarTemplate")
  self.compStarTemplate.gameObject:GameObjectCreatePool()
end

function UILWDominatorMainCenterSkillItemComponent:ComponentDestroy()
  self:ClearStars()
  self.btnSkillItemCenter = nil
  self.imgIcon = nil
  self.textSkillLevel = nil
  self.compStars = nil
  self.compStarTemplate = nil
  self.compSelected = nil
end

function UILWDominatorMainCenterSkillItemComponent:ClearStars()
  if self.compStars then
    self.compStars:RemoveComponents(UIHeroSkillStar)
    self.compStarTemplate.gameObject:GameObjectRecycleAll()
  end
end

function UILWDominatorMainCenterSkillItemComponent:ReInit(skillData, clickCallback)
  self.skillData = skillData
  self.clickCallback = clickCallback
  if self.skillData == nil then
    self:SetActive(false)
    return
  else
    self:SetActive(true)
  end
  self.imgIcon:LoadSprite(self.skillData.skillTemplateData.icon)
  if self.skillData:IsReachGroupMaxLevel() then
    self.textSkillLevel:SetLocalText("110000")
  else
    self.textSkillLevel:SetText("Lv." .. self.skillData:GetLevel())
  end
  local showStar = true
  if not self.skillData:IsUnlock() then
    showStar = false
  end
  if showStar then
    self.compStars:SetActive(true)
    self:ClearStars()
    local curStar = self.skillData:GetStar()
    if 0 < curStar then
      local showStarCount = math.min(curStar, 5)
      local leftWindow = math.max(0, curStar - 5)
      for i = 1, showStarCount do
        local item = self.compStarTemplate.gameObject:GameObjectSpawn(self.compStars.transform)
        item.name = "star" .. i
        local viewStarIndex = leftWindow + i
        local cell = self.compStars:AddComponent(UIHeroSkillStar, item.name)
        cell:SetFilled(true)
        cell:SetStarIndex(viewStarIndex)
      end
    end
  else
    self.compStars:SetActive(false)
  end
end

function UILWDominatorMainCenterSkillItemComponent:SetSelected(value)
  self.compSelected:SetActive(value)
end

function UILWDominatorMainCenterSkillItemComponent:DataDefine()
end

function UILWDominatorMainCenterSkillItemComponent:DataDestroy()
end

function UILWDominatorMainCenterSkillItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWDominatorMainCenterSkillItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWDominatorMainCenterSkillItemComponent:OnBtnSkillItemCenterClick()
  if self.clickCallback and self.skillData then
    self.clickCallback(self.skillData, self)
  end
end

return UILWDominatorMainCenterSkillItemComponent
