local LWEffectOverviewHeroDetailItem = BaseClass("LWEffectOverviewHeroDetailItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local btn_go_path = ""
local img_quality_path = "imgQuality"
local lock_path = "lock"
local textVal_path = "textVal"
local textInCity_path = "textInCity"
local textLock_path = "textLock"

function LWEffectOverviewHeroDetailItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWEffectOverviewHeroDetailItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWEffectOverviewHeroDetailItem:ComponentDefine()
  self.img_quality = self:AddComponent(UIImage, img_quality_path)
  self.img_icon = self:AddComponent(UIImage, "imgIcon")
  self.heroRankIcon = self:AddComponent(UIImage, "HeroRankIcon")
  self.lock = self:AddComponent(UIBaseContainer, lock_path)
  self.textVal = self:AddComponent(UIText, textVal_path)
  self.textInCity = self:AddComponent(UIText, textInCity_path)
  self.textLock = self:AddComponent(UIText, textLock_path)
  self.btn_go = self:AddComponent(UIButton, btn_go_path)
  self.btn_go:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function LWEffectOverviewHeroDetailItem:ComponentDestroy()
  self.img_quality = nil
  self.img_icon = nil
  self.heroRankIcon = nil
  self.lock = nil
  self.textVal = nil
  self.textInCity = nil
  self.textLock = nil
  self.btn_go.onPointClick = nil
  self.btn_go = nil
end

function LWEffectOverviewHeroDetailItem:DataDefine()
end

function LWEffectOverviewHeroDetailItem:DataDestroy()
end

function LWEffectOverviewHeroDetailItem:OnBtnClick()
  if self.callBack ~= nil then
    self.callBack(self.data)
  end
end

function LWEffectOverviewHeroDetailItem:SetData(data, callBack)
  self.data = data
  self.callBack = callBack
  local icon = HeroUtils.GetQualityIconPath(self.data.heroConfig.quality, false)
  self.img_quality:LoadSprite(icon)
  local iconPath = HeroUtils.GetHeroIconPath(self.data.heroConfig.appearance)
  self.img_icon:LoadSpriteAuto(iconPath)
  self.heroRankIcon:SetActive(false)
  self.lock:SetActive(not self.data.isHave)
  if self.data.isInCity then
    self.textVal:SetActive(true)
    self.textInCity:SetActive(false)
    self.textLock:SetActive(false)
    local describe, text = WorkerUtil.GetEffectText(self.data.effectId, self.data.value, true)
    self.textVal:SetText(text)
  elseif self.data.isHave then
    self.textVal:SetActive(false)
    self.textInCity:SetActive(true)
    self.textLock:SetActive(false)
    self.textInCity:SetLocalText(110296)
  else
    self.textVal:SetActive(false)
    self.textInCity:SetActive(false)
    self.textLock:SetActive(true)
    self.textLock:SetLocalText(120050)
  end
end

return LWEffectOverviewHeroDetailItem
