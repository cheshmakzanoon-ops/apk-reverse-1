local UIHeroHonorCellBig = BaseClass("UIHeroHonorCellBig", UIBaseContainer)
local base = UIBaseContainer
local LWHeroRankStar = require("UI.UIHero2.Common.LWHeroRankStar")
local UIGray = CS.UIGray
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
  self.layerNormal = self:AddComponent(UIBaseContainer, "LayerNormal")
  self.img_bg = self:AddComponent(UIImage, "LayerNormal")
  self.img_icon1 = self:AddComponent(UIImage, "LayerNormal/Mask/ImgIcon1")
  self.btn_go = self:AddComponent(UIButton, "")
  self.btn_go:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.nodeRedPoint = self:AddComponent(UIBaseContainer, "NodeRedPoint")
  if self.transform:Find("typeLayOut/jobIcon") then
    self.jobIcon = self:AddComponent(UIImage, "typeLayOut/jobIcon")
  end
  self.honorContainer = self:AddComponent(UIBaseContainer, "Honor")
  self.honorLevel = self:AddComponent(UIBaseContainer, "Honor/HonorLevel")
  self.honorLevelText = self:AddComponent(UIText, "Honor/HonorLevel/HonorLevelText")
  self.tipText = self:AddComponent(UIText, "TipText")
end

local function ComponentDestroy(self)
  self.layerNormal = nil
  self.img_bg = nil
  self.img_icon1 = nil
  self.btn_go = nil
  self.nodeRedPoint = nil
  self.honorContainer = nil
  self.honorLevel = nil
  self.honorLevelText = nil
  self.tipText = nil
end

local function DataDefine(self)
  self.param = nil
  self.callBack = nil
end

local function DataDestroy(self)
  self.param = nil
  self.callBack = nil
end

local function SetHeroRank(self, rank)
  if rank == nil then
    self.heroRankStar:SetActive(false)
  else
    self.heroRankStar:SetActive(true)
    self.heroRankStar:ShowRank(rank, self.heroData.meta.maxRank)
  end
end

local function SetData(self, heroUuid, callBack)
  self.param = heroUuid
  self.itemId = nil
  self.callBack = callBack
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
  local quality = heroData.quality
  self.heroData = heroData
  self.quality = heroData.quality
  self.heroId = heroData.heroId
  self:SetQuality(quality, false)
  local iconPath = HeroUtils.GetHeroIconPath(heroData.modelId, HeroIconType.half_portrait, heroData:GetSkinId())
  self.img_icon1:LoadSpriteAuto(iconPath)
  if heroData:IsUnlockHonorWall() then
    self.honorContainer:SetActive(true)
    self.honorLevelText:SetText(heroData.honorLevel)
    self.tipText:SetText("")
  else
    self.honorContainer:SetActive(false)
    self.tipText:SetText("")
  end
  if self.jobIcon then
    self.jobIcon:LoadSprite(HeroUtils.GetHeroJobIcon(heroData.meta.job, 2))
    self.jobIcon:SetActive(true)
  end
end

local function SetQuality(self, quality)
  local iconPath = string.format("Assets/Main/Sprites/UI/UILWHeroHonor/cfm_rongyuqiang_%d.png", quality)
  self.img_bg:LoadSprite(iconPath)
end

local function OnBtnClick(self)
  if self.callBack ~= nil then
    self.callBack(self.transform, self.param)
  end
end

local function UpdateRedPoint(self)
  local heroUuid = self.param
  if not self.enableRedPoint then
    self.nodeRedPoint:SetActive(false)
    return
  end
  if not self.heroData:IsReachMaxHonorLevel() and self.heroData:IsReachMaxRank() then
    local costFragId = self.heroData:GetHeroFragId()
    local costFragNum = self.heroData:GetHonorLevelUpgradeCost()
    local haveFragNum = DataCenter.ItemData:GetItemCount(costFragId)
    local progress = haveFragNum / costFragNum
    if 1 < progress then
      progress = 1
    end
    self.nodeRedPoint:SetActive(1 <= progress)
  else
    self.nodeRedPoint:SetActive(false)
  end
end

local function EnableRedPoint(self)
  self.enableRedPoint = true
  self:UpdateRedPoint()
end

local function DisableRedPoint(self)
  self.enableRedPoint = false
  self.nodeRedPoint:SetActive(false)
end

local function ToggleBlackMask(self, t)
  self.blackMask:SetActive(t)
end

local function ShowEffectTipText(self)
  if self.heroData then
    local unlockEffects = self.heroData:CollectHonorEffect()
    if not table.IsNullOrEmpty(unlockEffects) then
      for effectId, value in pairs(unlockEffects) do
        local str = ""
        local effectName = Localization:GetString(HeroUtils.GetHeroPropertyNameId(effectId))
        local value = HeroUtils.GetFormattedPropertyValue(effectId, value)
        str = string.format("%s:<color=#5FEF87>%s</color>", effectName, value)
        self.tipText:SetText(str)
      end
    end
  end
end

UIHeroHonorCellBig.OnCreate = OnCreate
UIHeroHonorCellBig.OnDestroy = OnDestroy
UIHeroHonorCellBig.OnEnable = OnEnable
UIHeroHonorCellBig.OnDisable = OnDisable
UIHeroHonorCellBig.ComponentDefine = ComponentDefine
UIHeroHonorCellBig.ComponentDestroy = ComponentDestroy
UIHeroHonorCellBig.DataDefine = DataDefine
UIHeroHonorCellBig.DataDestroy = DataDestroy
UIHeroHonorCellBig.SetData = SetData
UIHeroHonorCellBig.SetQuality = SetQuality
UIHeroHonorCellBig.OnBtnClick = OnBtnClick
UIHeroHonorCellBig.EnableRedPoint = EnableRedPoint
UIHeroHonorCellBig.DisableRedPoint = DisableRedPoint
UIHeroHonorCellBig.UpdateRedPoint = UpdateRedPoint
UIHeroHonorCellBig.ShowEffectTipText = ShowEffectTipText
UIHeroHonorCellBig.ToggleBlackMask = ToggleBlackMask
return UIHeroHonorCellBig
