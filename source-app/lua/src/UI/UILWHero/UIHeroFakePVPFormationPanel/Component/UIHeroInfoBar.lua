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
end

local function SetData(self, level, heroUuid)
  if level == nil or heroUuid == nil then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.levelText:SetText(string.format("lv.%s", level))
  self.heroCell:SetData(heroUuid, nil, false, false, HeroIconType.small_icon)
  self.heroCell:ToggleLevel(false)
  self.heroCell:ToggleRank(false)
end

UIHeroInfoBar.OnCreate = OnCreate
UIHeroInfoBar.OnDestroy = OnDestroy
UIHeroInfoBar.OnEnable = OnEnable
UIHeroInfoBar.OnDisable = OnDisable
UIHeroInfoBar.ComponentDefine = ComponentDefine
UIHeroInfoBar.ComponentDestroy = ComponentDestroy
UIHeroInfoBar.SetData = SetData
return UIHeroInfoBar
