local base = UIBaseContainer
local SkirmishHeroAwakenEnergyComponent = BaseClass("SkirmishHeroAwakenEnergyComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function SkirmishHeroAwakenEnergyComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SkirmishHeroAwakenEnergyComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SkirmishHeroAwakenEnergyComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.rawImgHero = self.viewSkin:AddComponent(self, UIRawImage, 1)
  self.compEffUiHeroawakenEnergyHero = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
end

function SkirmishHeroAwakenEnergyComponent:ComponentDestroy()
  self.viewSkin = nil
  self.rawImgHero = nil
  self.compEffUiHeroawakenEnergyHero = nil
end

function SkirmishHeroAwakenEnergyComponent:DataDefine()
end

function SkirmishHeroAwakenEnergyComponent:DataDestroy()
end

function SkirmishHeroAwakenEnergyComponent:ReInit(skinId, modelId)
  local iconPath = HeroUtils.GetHeroIconPath(modelId, HeroIconType.pvp_hero_awaken_icon, skinId)
  if not string.IsNullOrEmpty(iconPath) then
    self.rawImgHero:LoadSpriteAuto(iconPath)
  else
    Logger.LogError("SkirmishHeroAwakenEnergyComponent:ReInit: iconPath is empty, skinId: " .. tostring(skinId))
  end
end

function SkirmishHeroAwakenEnergyComponent:Hide()
  self.compEffUiHeroawakenEnergyHero:SetActive(false)
end

function SkirmishHeroAwakenEnergyComponent:Show()
  self.compEffUiHeroawakenEnergyHero:SetActive(false)
  self.compEffUiHeroawakenEnergyHero:SetActive(true)
end

return SkirmishHeroAwakenEnergyComponent
