local UIHeroInfoBar = BaseClass("UIHeroInfoBar", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self.quality = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.heroCell = self:AddComponent(UIHeroCellSmall, "UIHeroCellSmall")
  self.levelText = self:AddComponent(UIText, "LevelText")
end

local function ComponentDestroy(self)
  self.heroCell = nil
  self.levelText = nil
  if self.ImgLvUp then
    self.ImgLvUp:SetActive(false)
    self.ImgLvUp = nil
  end
  self.click = nil
  self.heroUuid = nil
end

local function SetData(self, level, heroUuid)
  self.heroUuid = heroUuid
  if level == nil or heroUuid == nil then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.levelText:SetLocalText(320439, level)
  self.heroCell:SetData(heroUuid, nil, false, false, HeroIconType.small_icon)
  self.heroCell:ToggleLevel(false)
  self.heroCell:ToggleRank(false)
end

local function SetDataByHeroInfo(self, heroInfo)
  if heroInfo == nil then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(heroInfo.heroId)
  if heroTemplate and heroTemplate.type == HeroTemplateType.Dominator then
    self.levelText:SetText("")
  else
    self.levelText:SetLocalText(320439, heroInfo.level)
  end
  local uniqueWeaponLv = 0
  if heroInfo.GetUniqueWeaponLv then
    uniqueWeaponLv = heroInfo:GetUniqueWeaponLv()
  end
  local awakenLv = 0
  if heroInfo.GetHeroAwakenRankLevel then
    awakenLv = heroInfo:GetHeroAwakenRankLevel()
  end
  local skinId = 0
  if heroInfo.GetSkinId then
    skinId = heroInfo:GetSkinId()
  end
  self.heroCell:InitWithConfigId(heroInfo.heroId, nil, heroInfo.level, heroInfo:GetRank(), uniqueWeaponLv, awakenLv, skinId)
  self.heroCell:ToggleLevel(false)
  self.heroCell:ToggleRank(false)
end

local function SetDominator(self, dominatorId, rankLv)
  self:SetActive(true)
  self.levelText:SetLocalText("")
  self.heroCell:SetDominatorConfig(dominatorId, rankLv)
end

function UIHeroInfoBar:EnableClick()
  if self.click == nil then
    self.click = self:AddComponent(UIButton, "click")
  end
  self.click:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function UIHeroInfoBar:ShowLvUp(show)
  if self.ImgLvUp == nil then
    self.ImgLvUp = self:AddComponent(UIBaseComponent, "ImgLvUp")
  end
  self.ImgLvUp:SetActive(show)
end

function UIHeroInfoBar:OnBtnClick()
  if self.heroUuid then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, self.heroUuid, {
      self.heroUuid
    })
  end
end

UIHeroInfoBar.OnCreate = OnCreate
UIHeroInfoBar.OnDestroy = OnDestroy
UIHeroInfoBar.OnEnable = OnEnable
UIHeroInfoBar.OnDisable = OnDisable
UIHeroInfoBar.ComponentDefine = ComponentDefine
UIHeroInfoBar.ComponentDestroy = ComponentDestroy
UIHeroInfoBar.SetData = SetData
UIHeroInfoBar.SetDataByHeroInfo = SetDataByHeroInfo
UIHeroInfoBar.SetDominator = SetDominator
return UIHeroInfoBar
