local UIHeroFakeInfoBar = BaseClass("UIHeroFakeInfoBar", UIBaseContainer)
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
end

local function SetData(self, level, heroCfgId, weaponLevel)
  if level == nil or heroCfgId == nil then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.levelText:SetLocalText(320439, level)
  self.heroCell:ToggleLevel(false)
  self.heroCell:ToggleRank(false)
  local hero = HeroInfo.New()
  hero:UpdateFromMailData(heroCfgId, level, {}, weaponLevel)
  local iconPath = HeroUtils.GetHeroIconPath(hero.modelId, HeroIconType.small_icon)
  self.heroCell.img_icon:LoadSpriteAuto(iconPath)
  local quality = hero.meta.quality
  local icon = HeroUtils.GetQualityIconPath(quality, false)
  self.heroCell.img_quality:LoadSprite(icon)
end

UIHeroFakeInfoBar.OnCreate = OnCreate
UIHeroFakeInfoBar.OnDestroy = OnDestroy
UIHeroFakeInfoBar.OnEnable = OnEnable
UIHeroFakeInfoBar.OnDisable = OnDisable
UIHeroFakeInfoBar.ComponentDefine = ComponentDefine
UIHeroFakeInfoBar.ComponentDestroy = ComponentDestroy
UIHeroFakeInfoBar.SetData = SetData
return UIHeroFakeInfoBar
