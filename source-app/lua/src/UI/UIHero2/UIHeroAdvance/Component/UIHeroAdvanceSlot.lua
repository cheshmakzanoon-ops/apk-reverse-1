local UIHeroAdvanceSlot = BaseClass("UIHeroAdvanceSlot", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCell = require("UI.UIHero2.Common.UIHeroCellSmall")
local Localization = CS.GameEntry.Localization
local UIHeroStars = require("UI.UIHero2.Common.UIHeroStars")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self.parent = nil
  self.heroUuid = nil
  self.heroData = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.nodeEmpty = self:AddComponent(UIBaseContainer, "Empty")
  self.imgRequireQuality = self:AddComponent(UIImage, "Empty/HeroNeedItem/LayerPoster/ImgPosterQualityBg")
  self.imgRequireFgQuality = self:AddComponent(UIImage, "Empty/HeroNeedItem/LayerPoster/ImgPosterQualityFg")
  self.imgRequireHeroIcon = self:AddComponent(UIImage, "Empty/HeroNeedItem/LayerPoster/ImgPosterQualityBg/ImgPosterIcon")
  self.imgRequireCamp = self:AddComponent(UIImage, "Empty/HeroNeedItem/imgCamp")
  self.star = self:AddComponent(UIHeroStars, "Empty/HeroNeedItem/NodeArrow")
  self.imgMask = self:AddComponent(UIImage, "Empty/HeroNeedItem/Mask")
  self.addBg = self:AddComponent(UIImage, "Empty/addBg")
  self.heroCell = self:AddComponent(UIHeroCell, "UIHeroCellSmall")
  self.heroCell:ToggleRayCast(false)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
  self.closeBtn = self:AddComponent(UIButton, "Close")
  self.closeBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
  self.closeBtn:SetActive(false)
end

local function ComponentDestroy(self)
  self.imgRequireQuality = nil
  self.imgRequireHeroIcon = nil
  self.imgRequireCamp = nil
  self.heroCell = nil
end

local function SetData(self, heroUuid, requireType, requireQuality)
  self.heroUuid = heroUuid
  self.requireType = requireType
  self.requireQuality = requireQuality
  if heroUuid == nil then
    self:UpdateRequireDogFoodInfo()
  else
    self.heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
    self.heroCell:SetData(heroUuid)
    self.heroCell:SetCampActive(false)
  end
  self.closeBtn:SetActive(heroUuid ~= nil)
  self.nodeEmpty:SetActive(heroUuid == nil)
  self.heroCell:SetActive(heroUuid ~= nil)
end

local function SetParent(self, parent)
  self.parent = parent
end

local function UpdateRequireDogFoodInfo(self)
  local curAdvanceUuid = HeroAdvanceController:GetInstance():GetAdvanceHeroUuid()
  if curAdvanceUuid == nil or curAdvanceUuid == 0 then
    self:SetActive(false)
    return
  end
  local coreHeroData = DataCenter.HeroDataManager:GetHeroByUuid(curAdvanceUuid)
  self.coreHeroData = coreHeroData
  local heroConfig = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), coreHeroData.heroId)
  self.imgMask:LoadSprite(HeroUtils.GetQualityIconPath(self.requireQuality))
  local rarity = heroConfig.rarity
  local param = {}
  param.showStarNum = self.requireQuality
  param.maxStarNum = HeroUtils.GetMaxStarLevel(coreHeroData.heroId)
  self.star:SetData(param)
  self.imgRequireCamp:SetActive(false)
  if self.requireType == 1 then
    self.imgRequireHeroIcon:LoadSpriteAuto(HeroUtils.GetHeroIconPath(coreHeroData.heroId))
    self.imgRequireQuality:LoadSpriteAuto(HeroUtils.GetPosterSelectRarityPath(heroConfig.rarity, true))
    self.imgRequireFgQuality:LoadSpriteAuto(HeroUtils.GetPosterSelectRarityPath(heroConfig.rarity, false))
    self.addBg:LoadSpriteAuto(HeroUtils.GetPosterAddRarityPath(heroConfig.rarity))
  else
  end
  self.imgRequireHeroIcon:SetActive(self.requireType == 1)
end

local function OnBtnClick(self)
  if self.heroUuid ~= nil then
    self.parent:OnToggleDogFood(self.heroUuid)
    self.heroUuid = nil
  else
    local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.btn.transform.position + Vector3.New(0, 30, 0) * scaleFactor
    local reqQualityStr = math.floor(self.requireQuality / 2)
    local heroName = HeroUtils.GetHeroNameByConfigId(self.coreHeroData.heroId)
    local tip = self.requireType == 1 and Localization:GetString("129123", reqQualityStr, heroName) or Localization:GetString("129120", reqQualityStr)
    if reqQualityStr == 0 then
      tip = Localization:GetString("129221", heroName)
    end
    local param = UIHeroTipView.Param.New()
    param.content = Localization:GetString("129119") .. "\n" .. tip
    param.dir = UIHeroTipView.Direction.ABOVE
    param.defWidth = 280
    param.pivot = 0.3
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
  end
end

UIHeroAdvanceSlot.OnCreate = OnCreate
UIHeroAdvanceSlot.OnDestroy = OnDestroy
UIHeroAdvanceSlot.OnEnable = OnEnable
UIHeroAdvanceSlot.OnDisable = OnDisable
UIHeroAdvanceSlot.ComponentDefine = ComponentDefine
UIHeroAdvanceSlot.ComponentDestroy = ComponentDestroy
UIHeroAdvanceSlot.SetData = SetData
UIHeroAdvanceSlot.SetParent = SetParent
UIHeroAdvanceSlot.UpdateRequireDogFoodInfo = UpdateRequireDogFoodInfo
UIHeroAdvanceSlot.OnBtnClick = OnBtnClick
return UIHeroAdvanceSlot
