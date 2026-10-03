local MailPageHeroInfoItem = BaseClass("MailPageHeroInfoItem", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
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
  self.sliderRed = self:AddComponent(UISlider, "SliderRed")
  self.sliderGreen = self:AddComponent(UISlider, "SliderGreen")
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, info)
  if not info then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.heroCell:InitWithConfigId(info.heroId, nil, info.heroLevel, info.rankLv, info.weaponLv, info.awakenLv, info.heroSkinId)
  if info.player then
    local armyCfg = DataCenter.LWArmyTemplateManager:TryGetArmyTemplate(info.player.contentId)
    if armyCfg and not string.IsNullOrEmpty(armyCfg.replace_icon) and info.heroInfo and info.heroInfo.meta and info.heroInfo.meta.heroData_type ~= HeroTemplateType.Dominator then
      self.heroCell:SetImgIcon(armyCfg.replace_icon)
    end
  end
  self.sliderRed:SetValue(info.red)
  self.sliderGreen:SetValue(info.green)
end

MailPageHeroInfoItem.OnCreate = OnCreate
MailPageHeroInfoItem.OnDestroy = OnDestroy
MailPageHeroInfoItem.OnEnable = OnEnable
MailPageHeroInfoItem.OnDisable = OnDisable
MailPageHeroInfoItem.ComponentDefine = ComponentDefine
MailPageHeroInfoItem.ComponentDestroy = ComponentDestroy
MailPageHeroInfoItem.DataDefine = DataDefine
MailPageHeroInfoItem.DataDestroy = DataDestroy
MailPageHeroInfoItem.SetData = SetData
return MailPageHeroInfoItem
