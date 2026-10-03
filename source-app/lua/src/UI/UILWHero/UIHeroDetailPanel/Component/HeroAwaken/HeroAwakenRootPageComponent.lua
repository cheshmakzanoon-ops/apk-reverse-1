local base = UIBaseContainer
local HeroAwakenRootPageComponent = BaseClass("HeroAwakenRootPageComponent", UIBaseContainer)
local HeroAwakenUnlockPageComponent = require("UI/UILWHero/UIHeroDetailPanel/Component/HeroAwaken/HeroAwakenUnlockPageComponent")
local HeroAwakenUpgradePageComponent = require("UI/UILWHero/UIHeroDetailPanel/Component/HeroAwaken/HeroAwakenUpgradePageComponent")
HeroAwakenRootPageComponent.PageType = {UnlockPage = 1, UpgradePage = 2}
HeroAwakenRootPageComponent.RefreshType = {
  Unlock = 1,
  Upgrade = 2,
  FromView = 3
}

function HeroAwakenRootPageComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function HeroAwakenRootPageComponent:OnDestroy()
  self:StopSwitchTimer()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function HeroAwakenRootPageComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compUnlockRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.compUpgradeRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.compEffUiHeroawakenSwitch = self.viewSkin:AddComponent(self, UIVfx, 3)
  self.compHeroSpineContainer = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.compHeroSpineContainerAwaken = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.unlockPage = nil
  self.unlockReq = nil
  self.upgradePage = nil
  self.upgradeReq = nil
end

function HeroAwakenRootPageComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compUnlockRoot = nil
  self.compUpgradeRoot = nil
  self.compEffUiHeroawakenSwitch = nil
  self.compHeroSpineContainer = nil
  self.compHeroSpineContainerAwaken = nil
end

function HeroAwakenRootPageComponent:DataDefine()
  self.heroData = nil
  self.pageType = 0
  self.soundId = nil
end

function HeroAwakenRootPageComponent:DataDestroy()
  self.heroData = nil
  self.pageType = nil
  if self.soundId ~= nil then
    DataCenter.LWSoundManager:StopSound(self.soundId)
    self.soundId = nil
  end
end

function HeroAwakenRootPageComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.HeroAwakenUpgradeSuccess, self.OnHeroAwakenUpgradeSuccess)
end

function HeroAwakenRootPageComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.HeroAwakenUpgradeSuccess, self.OnHeroAwakenUpgradeSuccess)
  base.OnRemoveListener(self)
end

function HeroAwakenRootPageComponent:SetData(heroData)
  if not heroData then
    return
  end
  self.heroData = heroData
  if not self.heroData then
    Logger.LogError("HeroAwakenRootPageComponent:SetData nil")
    return
  end
  local isTemplateHero = self.view:IsTemplateHero()
  if isTemplateHero then
    Logger.LogError("HeroAwakenRootPageComponent:SetData isTemplateHero")
    return
  end
  local isHeroAwakenOpen = DataCenter.HeroAwakenDataManager:IsHeroAwakenOpenByHeroInfo(self.heroData)
  if not isHeroAwakenOpen then
    Logger.LogError("HeroAwakenRootPageComponent:SetData not HeroAwakenOpen")
    return
  end
  self:StopSwitchTimer()
  self:RefreshView(self.RefreshType.FromView)
  local oepnRecordStr = string.format(SettingKeys.HERO_AWAKEN_OPEN, heroData.heroId)
  local prevOpened = Setting:GetPrivateBool(oepnRecordStr, false)
  Setting:SetPrivateBool(oepnRecordStr, true)
  if not prevOpened then
    EventManager:GetInstance():Broadcast(EventId.OpenHeroUniqueWeapon)
    EventManager:GetInstance():Broadcast(EventId.OpenHeroAwakenPage)
  end
end

function HeroAwakenRootPageComponent:RefreshView(refreshType)
  local isAwakened = self.heroData:IsHeroAwakened()
  if not isAwakened then
    self.pageType = HeroAwakenRootPageComponent.PageType.UnlockPage
    self:RefreshUnlockPage(refreshType)
    self:RefreshUpgradePage(refreshType, true)
  else
    self.pageType = HeroAwakenRootPageComponent.PageType.UpgradePage
    self:RefreshUpgradePage(refreshType, false)
  end
  self.compUnlockRoot:SetActive(self.pageType == HeroAwakenRootPageComponent.PageType.UnlockPage)
  self.compUpgradeRoot:SetActive(self.pageType == HeroAwakenRootPageComponent.PageType.UpgradePage)
end

function HeroAwakenRootPageComponent:HideUnlockPage()
  if self.unlockPage ~= nil then
    self.unlockPage:SetActive(false)
  end
end

function HeroAwakenRootPageComponent:RefreshUnlockPage(refreshType)
  if not self.unlockPage and not self.unlockReq then
    local loadPageRequest = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/UIHero/LWHero/HeroAwaken/LWHeroAwakenMain/HeroAwakenUnlockPage.prefab")
    loadPageRequest:completed("+", function(req)
      if req.isError then
        return
      end
      local pageObj = req.gameObject
      local transform = pageObj.transform
      transform:SetParent(self.compUnlockRoot.transform)
      transform:Set_offsetMax(0, 0)
      transform:Set_offsetMin(0, 0)
      transform:Set_anchorMin(0, 0)
      transform:Set_anchorMax(1, 1)
      transform:Set_localScale(1, 1, 1)
      transform:Set_localPosition(0, 0, 0)
      local page = self:AddComponent(HeroAwakenUnlockPageComponent, pageObj)
      self.unlockPage = page
      if self.pageType == HeroAwakenRootPageComponent.PageType.UnlockPage then
        self.unlockPage:SetData(self.heroData)
        if refreshType == self.RefreshType.FromView then
          self.unlockPage:PlayInAnim()
        end
      end
    end)
    self.unlockReq = loadPageRequest
  elseif self.unlockPage and self.pageType == self.PageType.UnlockPage then
    self.unlockPage:SetData(self.heroData)
    if refreshType == self.RefreshType.FromView then
      self.unlockPage:PlayInAnim()
    end
  end
end

function HeroAwakenRootPageComponent:RefreshUpgradePage(refreshType, isPreload)
  if not self.upgradePage and not self.upgradeReq then
    local loadPriority = isPreload and AssetLoadPriority.UltraHigh or AssetLoadPriority.High
    local loadPageRequest = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/UIHero/LWHero/HeroAwaken/LWHeroAwakenMain/HeroAwakenUpgradePage.prefab", function(request)
      if request.isError then
        return
      end
      local pageObj = request.gameObject
      local transform = pageObj.transform
      transform:SetParent(self.compUpgradeRoot.transform)
      transform:Set_offsetMax(0, 0)
      transform:Set_offsetMin(0, 0)
      transform:Set_anchorMin(0, 0)
      transform:Set_anchorMax(1, 1)
      transform:Set_localScale(1, 1, 1)
      transform:Set_localPosition(0, 0, 0)
      local page = self:AddComponent(HeroAwakenUpgradePageComponent, pageObj)
      self.upgradePage = page
      if self.pageType == self.PageType.UpgradePage then
        self.upgradePage:SetData(self.heroData, refreshType == self.RefreshType.Upgrade)
        if refreshType == self.RefreshType.Unlock then
          self.upgradePage:PlaySwitchInAnim()
        elseif refreshType == self.RefreshType.FromView then
          self.upgradePage:PlayInAnim()
        end
      end
      if isPreload then
        self.upgradePage:PreloadTitleVfx()
      end
    end, loadPriority)
    self.upgradeReq = loadPageRequest
  elseif self.upgradePage then
    if self.pageType == self.PageType.UpgradePage then
      self.upgradePage:SetData(self.heroData, refreshType == self.RefreshType.Upgrade)
      if refreshType == self.RefreshType.Unlock then
        self.upgradePage:PlaySwitchInAnim()
      elseif refreshType == self.RefreshType.FromView then
        self.upgradePage:PlayInAnim()
      end
    end
    if isPreload then
      self.upgradePage:PreloadTitleVfx()
    end
  elseif refreshType == self.RefreshType.Unlock then
    Logger.LogWarning("HeroAwakenRootPageComponent:RefreshUpgradePage UpgradePage is not loaded when play unlock anim")
  end
end

function HeroAwakenRootPageComponent:GetHeroSpineContainer()
  if self.pageType == self.PageType.UnlockPage then
    return self.compHeroSpineContainer
  elseif self.pageType == self.PageType.UpgradePage then
    return self.compHeroSpineContainerAwaken
  end
  return self.compHeroSpineContainer
end

function HeroAwakenRootPageComponent:GetSpineType()
  if self.pageType == self.PageType.UnlockPage then
    return HeroSpineType.Normal
  elseif self.pageType == self.PageType.UpgradePage then
    return HeroSpineType.AwakenUpgrade
  end
  return HeroSpineType.Normal
end

function HeroAwakenRootPageComponent:OnHeroAwakenUpgradeSuccess(uuid)
  self:StopSwitchTimer()
  if self.heroData == nil then
    return
  end
  if self.heroData.uuid ~= uuid then
    return
  end
  local awakenRankLevel = self.heroData:GetHeroAwakenRankLevel()
  local isUnlocking = awakenRankLevel == 1
  if isUnlocking then
    if self.pageType == self.PageType.UnlockPage and self.unlockPage then
      local ret, time = self.unlockPage:PlaySwitchOutAnimReturnTime()
      if ret then
        self.switchTimer = TimerManager:GetInstance():DelayInvoke(function()
          self:RefreshUpgradePage(self.RefreshType.Unlock)
          self.compUnlockRoot:SetActive(self.pageType == HeroAwakenRootPageComponent.PageType.UnlockPage)
          self.compUpgradeRoot:SetActive(self.pageType == HeroAwakenRootPageComponent.PageType.UpgradePage)
        end, time + 0.3)
        self.showSwitchEffectTimer = TimerManager:GetInstance():DelayInvoke(function()
          self.compEffUiHeroawakenSwitch:PlayByOnce(VfxAssets.HeroAwakenUnlockSwitch)
        end, time - 0.2)
        self.pageType = self.PageType.UpgradePage
        self.soundId = DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_Hero_Awaken_Unlock, false)
      end
    end
  else
    self:RefreshView(self.RefreshType.Upgrade)
  end
  if self.pageType == self.PageType.UpgradePage then
    if self.upgradePage then
      self.upgradePage:OnHeroAwakenUpgradeSuccess(uuid)
    end
  elseif self.pageType ~= self.PageType.UnlockPage or self.unlockPage then
  end
end

function HeroAwakenRootPageComponent:StopSwitchTimer()
  if self.switchTimer then
    self.switchTimer:Stop()
    self.switchTimer = nil
  end
  if self.showSwitchEffectTimer then
    self.showSwitchEffectTimer:Stop()
    self.showSwitchEffectTimer = nil
  end
end

return HeroAwakenRootPageComponent
