local base = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.UIHeroInfoBar")
local UIHeroInfoBar_ParkourFormation = BaseClass("UIHeroInfoBar_ParkourFormation", base)
local LEVEL_UP_EFFECT_PATH = "Assets/Main/Prefabs/Effect/quick_upgrade/EFF_Battle_HeroInfoBar_up.prefab"

function UIHeroInfoBar_ParkourFormation:ComponentDefine()
  base.ComponentDefine(self)
  self.bgImage = self:TryAddComponent(UIImage, "BgImage")
  self.newLevelUpAnim = self:TryAddComponent(UISimpleAnimation, "NewLevelUpAnim")
  self:SetLevelUpAniShow(false)
  self:SetBgColor(false)
end

function UIHeroInfoBar_ParkourFormation:ComponentDestroy()
  self.bgImage = nil
  self.newLevelUpAnim = nil
  self.heroAtLeastLevelNum = nil
  self.needShowLevelUpEffect = nil
  self.canStarLevel = nil
  self.canUpgradeLevel = nil
  self.canArmedUpgrade = nil
  self.heroId = nil
  self:ClearLevelUpEffect()
  base.ComponentDestroy(self)
end

function UIHeroInfoBar_ParkourFormation:SetData(level, heroUuid)
  base.SetData(self, level, heroUuid)
  local heroInfo = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
  self:TryShowLevelUpEffect(heroInfo)
end

function UIHeroInfoBar_ParkourFormation:SetDataByHeroInfo(heroInfo)
  base.SetDataByHeroInfo(self, heroInfo)
  self:TryShowLevelUpEffect(heroInfo)
end

function UIHeroInfoBar_ParkourFormation:TryShowLevelUpEffect(heroInfo)
  self.canUpgradeLevel = false
  self.canStarLevel = false
  self.canArmedUpgrade = false
  self.needShowLevelUpEffect = false
  local isMonopoly = self.view and self.view.enterType and self.view.enterType == PVEEnterType.Monopoly
  local season = SeasonUtil.GetSeason()
  local inS0 = season == 0
  if not (heroInfo ~= nil and isMonopoly) or not inS0 then
    self:SetLevelUpAniShow(false)
    self:SetBgColor(false)
    self:HideLevelUpEffect()
    return
  end
  self.heroId = heroInfo.heroId
  local targetLevel = self:HeroUpgradeLevelConditionAtLeastNum()
  self.canUpgradeLevel = HeroUtils.CanHeroUpgradeMultipleLevels(heroInfo, targetLevel, false, 5)
  if heroInfo.quality == HeroQualityType.Genius or heroInfo.quality == HeroQualityType.Outstanding then
    self.canStarLevel = heroInfo:CanUpgradeToNextStar()
  end
  if heroInfo.heroId == DataCenter.LWArmedUpgradeManager.monicaHeroId then
    local levelUpCondition, canLevelUp = DataCenter.LWArmedUpgradeManager:GetArmedUpgradeCanLevelUpData()
    self.canArmedUpgrade = canLevelUp
  end
  self.needShowLevelUpEffect = self.canUpgradeLevel or self.canStarLevel or self.canArmedUpgrade
  self:SetLevelUpAniShow(self.needShowLevelUpEffect)
  self:SetBgColor(self.needShowLevelUpEffect)
  if self.needShowLevelUpEffect then
    self:ShowLeveUpEffect()
  else
    self:HideLevelUpEffect()
  end
end

function UIHeroInfoBar_ParkourFormation:HeroUpgradeLevelConditionAtLeastNum()
  if self.heroAtLeastLevelNum == nil then
    self.heroAtLeastLevelNum = LuaEntry.DataConfig:TryGetNum("settlement_upgrade_goto", "k1")
    if self.heroAtLeastLevelNum == nil then
      self.heroAtLeastLevelNum = 5
    end
  end
  return self.heroAtLeastLevelNum
end

function UIHeroInfoBar_ParkourFormation:SetLevelUpAniShow(show)
  if self.newLevelUpAnim then
    self.newLevelUpAnim:SetActive(show)
    if show then
      self.newLevelUpAnim:Play("Default")
    end
  end
end

function UIHeroInfoBar_ParkourFormation:SetBgColor(showGreen)
  if self.bgImage then
    if showGreen then
      self.bgImage:SetColorRGBA(0.03, 0.8, 0.32, 0.58)
    else
      self.bgImage:SetColorRGBA(0, 0, 0, 0.58)
    end
  end
end

function UIHeroInfoBar_ParkourFormation:ShowLeveUpEffect()
  if self.levelUpEffectReq == nil then
    self.levelUpEffectReq = self:GameObjectInstantiateAsync(LEVEL_UP_EFFECT_PATH, function(request)
      if request.isError then
        self:ClearLevelUpEffect()
        return
      end
      if self.bgImage == nil then
        self:ClearLevelUpEffect()
        return
      end
      self.levelUpEffectGo = request.gameObject
      self.levelUpEffectGo:SetActive(self.needShowLevelUpEffect)
      self.levelUpEffectGo.transform:SetParent(self.bgImage.transform)
      self.levelUpEffectGo.transform:Set_localPosition(-30 * CommonUtil.ArabicAutoMirrorFactor(), 0, 0)
      self.levelUpEffectGo.transform:Set_localScale(1, 1, 1)
    end)
  elseif self.levelUpEffectGo then
    self.levelUpEffectGo:SetActive(true)
  end
end

function UIHeroInfoBar_ParkourFormation:HideLevelUpEffect()
  if self.levelUpEffectGo then
    self.levelUpEffectGo:SetActive(false)
  end
end

function UIHeroInfoBar_ParkourFormation:ClearLevelUpEffect()
  if self.levelUpEffectReq then
    self:GameObjectDestroy(self.levelUpEffectReq)
  end
  self.levelUpEffectReq = nil
  self.levelUpEffectGo = nil
end

function UIHeroInfoBar_ParkourFormation:OnBtnClick()
  if self.heroUuid then
    PostEventLog.Track(PostEventLog.Defines.c_quick_upgrade_goto_1, {
      heroid = self.heroId,
      is_upgrade = self.needShowLevelUpEffect
    })
    if self.canArmedUpgrade then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWArmedUpgradeMain)
      return
    end
    local arrowData = {
      arrowType = HeroDetailGuideArrowType.Upgrade,
      heroUid = self.heroUuid
    }
    if not self.canUpgradeLevel and self.canStarLevel then
      arrowData.arrowType = HeroDetailGuideArrowType.Rank
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, self.heroUuid, {
      self.heroUuid
    }, nil, arrowData)
  end
end

return UIHeroInfoBar_ParkourFormation
