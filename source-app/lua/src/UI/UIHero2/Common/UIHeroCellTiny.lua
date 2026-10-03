local UIHeroCellTiny = BaseClass("UIHeroCellTiny", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

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
  self.img_quality = self:AddComponent(UIImage, "imgQuality")
  self.img_icon = self:AddComponent(UIImage, "imgIcon")
  self.sliderRed = self:AddComponent(UISlider, "sliderRed")
  self.sliderGreen = self:AddComponent(UISlider, "sliderGreen")
  self.textLevel = self:AddComponent(UIText, "textLevel")
end

local function ComponentDestroy(self)
  self.img_quality = nil
  self.img_icon = nil
  self.sliderRed = nil
  self.sliderGreen = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, heroConfigId, quality, level, weaponLevel, rankLv, skinId)
  if not heroConfigId then
    self:SetEmpty()
    return
  end
  local heroConfig = DataCenter.HeroTemplateManager:GetTemplate(heroConfigId)
  if heroConfig == nil then
    self:SetEmpty()
    return
  end
  self:SetNotEmpty()
  if heroConfig.heroData_type == HeroTemplateType.Dominator then
    self:SetDominatorData(heroConfigId, rankLv)
    return
  end
  if quality == nil then
    quality = heroConfig.quality
  end
  local modelId = heroConfig.appearance
  local _weaponLevel = weaponLevel or 0
  if _weaponLevel ~= nil and 0 < _weaponLevel then
    local weaponInfo = DataCenter.HeroUniqueWeaponTemplateManager:GetTemplateByHeroId(heroConfigId, _weaponLevel)
    if weaponInfo ~= nil then
      modelId = weaponInfo.modelId
    end
  end
  local qualityIcon = HeroUtils.GetQualityIconPath(quality, false)
  self.img_quality:SetActive(true)
  self.img_quality:LoadSprite(qualityIcon)
  local iconPath = HeroUtils.GetHeroIconPath(modelId, nil, skinId)
  self.img_icon:SetActive(true)
  self.img_icon:LoadSpriteAuto(iconPath)
  if level then
    self.textLevel:SetLocalText(GameDialogDefine.LEVEL_NUMBER, level)
  else
    self.textLevel:SetText("")
  end
  self.sliderRed:SetActive(false)
  self.sliderGreen:SetActive(false)
end

local function SetMonsterHeadIcon(self, player, heroData)
  if player == nil then
    return
  end
  local contentId = player.contentId
  local armyCfg = DataCenter.LWArmyTemplateManager:TryGetArmyTemplate(contentId)
  if armyCfg and not string.IsNullOrEmpty(armyCfg.replace_icon) and heroData and heroData.heroInfo and heroData.heroInfo.meta and heroData.heroInfo.meta.heroData_type ~= HeroTemplateType.Dominator then
    self.img_icon:LoadSprite(armyCfg.replace_icon)
  end
end

local function SetEmpty(self)
  self.img_quality:SetActive(false)
  self.img_icon:SetActive(false)
  self.sliderRed:SetActive(false)
  self.sliderGreen:SetActive(false)
  self.textLevel:SetText("")
end

local function SetNotEmpty(self)
  self.img_quality:SetActive(true)
  self.img_icon:SetActive(true)
  self.sliderRed:SetActive(true)
  self.sliderGreen:SetActive(true)
end

local function SetDataForMail(self, data, isWin)
  self:SetData(data.heroId, nil, data.heroLevel, data.weaponLevel, data.rankLv, data.heroSkinId)
  self:SetHP(data.black, data.red, data.green, isWin)
end

local function SetHP(self, black, red, green, isWin)
  self.sliderRed:SetActive(true)
  self.sliderGreen:SetActive(true)
  local redPercent = 0
  if red ~= nil and black ~= nil then
    redPercent = red / black
  end
  local greenPercent = 0
  if green ~= nil and black ~= nil then
    greenPercent = green / black
  end
  if isWin and 0 < greenPercent then
    greenPercent = math.max(0.1, greenPercent)
  end
  self.sliderRed:SetValue(redPercent)
  self.sliderGreen:SetValue(greenPercent)
end

local function OnBtnClick(self)
  if self.callBack then
    self.callBack()
  end
end

function UIHeroCellTiny:SetDominatorData(id, rank)
  local appearanceId = DataCenter.DominatorTemplateManager:GetAppearanceId(id, rank)
  local iconPath = HeroUtils.GetHeroIconPath(appearanceId, HeroIconType.small_icon, nil)
  self.img_icon:LoadSpriteAuto(iconPath)
  self.img_quality:LoadSprite(LoadPath.DominatorIconBg)
  self.textLevel:SetText("")
end

UIHeroCellTiny.OnCreate = OnCreate
UIHeroCellTiny.OnDestroy = OnDestroy
UIHeroCellTiny.OnEnable = OnEnable
UIHeroCellTiny.OnDisable = OnDisable
UIHeroCellTiny.ComponentDefine = ComponentDefine
UIHeroCellTiny.ComponentDestroy = ComponentDestroy
UIHeroCellTiny.DataDefine = DataDefine
UIHeroCellTiny.DataDestroy = DataDestroy
UIHeroCellTiny.SetData = SetData
UIHeroCellTiny.OnBtnClick = OnBtnClick
UIHeroCellTiny.SetEmpty = SetEmpty
UIHeroCellTiny.SetDataForMail = SetDataForMail
UIHeroCellTiny.SetHP = SetHP
UIHeroCellTiny.SetNotEmpty = SetNotEmpty
UIHeroCellTiny.SetMonsterHeadIcon = SetMonsterHeadIcon
return UIHeroCellTiny
