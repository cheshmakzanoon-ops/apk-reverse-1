local UIZombieBattleResultGrowthList = BaseClass("UIZombieBattleResultGrowthList", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGrowthItem = require("UI.UIZombieBattleLose.Component.UIZombieBattleResultGrowthListItem")
local heroType2BuildingData = {
  [HeroType.Tank] = {
    buildingId = 10116000,
    iconName = "UI_building_10116000",
    buildingName = Localization:GetString("129031")
  },
  [HeroType.Missile] = {
    buildingId = 10117000,
    iconName = "UI_building_10117000",
    buildingName = Localization:GetString("129033")
  },
  [HeroType.Aircraft] = {
    buildingId = 10118000,
    iconName = "UI_building_10213000",
    buildingName = Localization:GetString("129035")
  }
}

function UIZombieBattleResultGrowthList:OnCreate(ctrl, param)
  base.OnCreate(self)
  self:ComponentDefine()
  self.ctrl = ctrl
  self.param = param
end

function UIZombieBattleResultGrowthList:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIZombieBattleResultGrowthList:OnEnable()
  base.OnEnable(self)
  self.active = true
end

function UIZombieBattleResultGrowthList:OnDisable()
  base.OnDisable(self)
  self.active = false
end

function UIZombieBattleResultGrowthList:ComponentDefine()
  self.canvasGroup = self.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.allContents = {}
  self.heroLevelContent = self:AddComponent(UIGrowthItem, "Viewport/Content/HeroLevelContent")
  self.heroLevelContent:RefreshView(Localization:GetString("140062"), "450004", self, self.OnHeroLevelBtnClick)
  table.insert(self.allContents, self.heroLevelContent)
  self.recruitHeroContent = self:AddComponent(UIGrowthItem, "Viewport/Content/RecruitHeroContent")
  self.recruitHeroContent:RefreshView(Localization:GetString("450005"), "450004", self, self.OnRecruitHeroBtnClick)
  table.insert(self.allContents, self.recruitHeroContent)
  self.heroEquipContent = self:AddComponent(UIGrowthItem, "Viewport/Content/HeroEquipContent")
  self.heroEquipContent:RefreshView(Localization:GetString("260000"), "450004", self, self.OnHeroEquipBtnClick)
  table.insert(self.allContents, self.heroEquipContent)
  self.heroSkillContent = self:AddComponent(UIGrowthItem, "Viewport/Content/HeroSkillContent")
  self.heroSkillContent:RefreshView(Localization:GetString("450007"), "450004", self, self.OnHeroSkillBtnClick)
  table.insert(self.allContents, self.heroSkillContent)
  self.firstPayContent = self:AddComponent(UIGrowthItem, "Viewport/Content/FirstPayContent")
  self.firstPayContent:RefreshView(Localization:GetString("2000328"), "450004", self, self.OnFirstPayBtnClick)
  table.insert(self.allContents, self.firstPayContent)
  self.cityUpdateContent = self:AddComponent(UIGrowthItem, "Viewport/Content/CityUpdate")
  self.cityUpdateContent:RefreshView(Localization:GetString("130209", Localization:GetString("135104")), "450004", self, self.OnCityBtnClick)
  table.insert(self.allContents, self.cityUpdateContent)
  self.tankUpdateContent = self:AddComponent(UIGrowthItem, "Viewport/Content/TankUpdate")
  self.tankUpdateContent:RefreshView(Localization:GetString("130209", Localization:GetString("129031")), "450004", self, self.OnTankBtnClick)
  table.insert(self.allContents, self.tankUpdateContent)
  self.radarContent = self:AddComponent(UIGrowthItem, "Viewport/Content/RadarUpdate")
  self.radarContent:RefreshView(Localization:GetString("121289"), "450004", self, self.OnRadarBtnClick)
  table.insert(self.allContents, self.radarContent)
  self.dominatorContent = self:AddComponent(UIGrowthItem, "Viewport/Content/dominatorUpdate")
  self.dominatorContent:RefreshView(Localization:GetString("dominator_pve_dec_12"), "450004", self, self.OnDominatorBtnClick)
  table.insert(self.allContents, self.dominatorContent)
  self.weaponContent = self:AddComponent(UIGrowthItem, "Viewport/Content/weaponUpdate")
  self.weaponContent:RefreshView(Localization:GetString("dominator_pve_dec_13"), "450004", self, self.OnWeaponBtnClick)
  table.insert(self.allContents, self.weaponContent)
  self.decorationContent = self:AddComponent(UIGrowthItem, "Viewport/Content/decorationUpdate")
  self.decorationContent:RefreshView(Localization:GetString("dominator_pve_dec_14"), "450004", self, self.OnDecorationBtnClick)
  table.insert(self.allContents, self.decorationContent)
end

function UIZombieBattleResultGrowthList:ComponentDestroy()
  if not IsNull(self.fadeTween) then
    self.fadeTween:Kill()
    self.fadeTween = nil
  end
end

function UIZombieBattleResultGrowthList:FadeIn()
  if not IsNull(self.fadeTween) then
    self.fadeTween:Kill()
    self.fadeTween = nil
  end
  self.canvasGroup.alpha = 0
  self.fadeTween = CS.DG.Tweening.DOTween.To(function()
    return self.canvasGroup.alpha
  end, function(value)
    self.canvasGroup.alpha = value
  end, 1, 0.5):SetEase(CS.DG.Tweening.Ease.Linear)
end

function UIZombieBattleResultGrowthList:OnCityBtnClick()
  self.ctrl:CloseSelf()
  
  local function afterSwitchScene()
    GoToUtil.GotoCityByBuildId(10100000, WorldTileBtnType.City_Upgrade, nil, true)
  end
  
  self:ExitBattleScene(afterSwitchScene)
end

function UIZombieBattleResultGrowthList:OnTankBtnClick()
  self.ctrl:CloseSelf()
  local tankData = self.tankData
  
  local function afterSwitchScene()
    if tankData == nil then
      GoToUtil.GotoCityByBuildId(self.canBuildBuildingId, WorldTileBtnType.City_Upgrade)
    else
      GoToUtil.GotoCityByBuildId(tankData.itemId, WorldTileBtnType.City_Upgrade, nil, true)
    end
  end
  
  self:ExitBattleScene(afterSwitchScene)
end

function UIZombieBattleResultGrowthList:OnRadarBtnClick()
  self.ctrl:CloseSelf()
  
  local function afterSwitchScene()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent)
  end
  
  self:ExitBattleScene(afterSwitchScene)
end

function UIZombieBattleResultGrowthList:OnHeroLevelBtnClick()
  self.ctrl:CloseSelf()
  local heroUuid = self.heroQualityHigh
  
  local function afterSwitchScene()
    local arrowData = {
      arrowType = HeroDetailGuideArrowType.Upgrade,
      heroUid = heroUuid
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, heroUuid, {heroUuid}, nil, arrowData)
  end
  
  self:ExitBattleScene(afterSwitchScene)
end

function UIZombieBattleResultGrowthList:OnRecruitHeroBtnClick()
  self.ctrl:CloseSelf()
  
  local function afterSwitchScene()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruit, {anim = true})
  end
  
  self:ExitBattleScene(afterSwitchScene)
end

function UIZombieBattleResultGrowthList:OnHeroEquipBtnClick()
  self.ctrl:CloseSelf()
  local heroUuid = self.canEquipHero
  
  local function afterSwitchScene()
    local arrowData = {
      arrowType = HeroDetailGuideArrowType.Equip,
      heroUid = heroUuid
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, heroUuid, {heroUuid}, nil, arrowData)
  end
  
  self:ExitBattleScene(afterSwitchScene)
end

function UIZombieBattleResultGrowthList:OnHeroSkillBtnClick()
  self.ctrl:CloseSelf()
  local heroUuid = self.canSkillUpHero
  
  local function afterSwitchScene()
    local arrowData = {
      arrowType = HeroDetailGuideArrowType.Skill,
      heroUid = heroUuid,
      skillSlotIndex = self.canUpgradeSkillSlotIndex
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, heroUuid, {heroUuid}, nil, arrowData)
  end
  
  self:ExitBattleScene(afterSwitchScene)
end

function UIZombieBattleResultGrowthList:FirstTimeLoseGuide()
  local buildingData = DataCenter.BuildManager:GetBuildingDatasByBuildingId(10100000)[1]
  if not buildingData or buildingData.level < 2 then
    return
  end
  if CommonUtil.PlayerPrefsGetInt("STAGE_LOSE_HERO_LV_GUIDE", 0) == 0 then
    CommonUtil.PlayerPrefsSetInt("STAGE_LOSE_HERO_LV_GUIDE", 1)
    local fingerHandle = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/Guide/UIArrowFinger.prefab")
    fingerHandle:completed("+", function(handle)
      if handle.isError then
        return
      end
      CommonUtil.CallAutoArabicMirrorManually(handle)
      local gameObject = handle.gameObject
      local transform = gameObject.transform
      transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.Guide.Name).transform, false)
      transform.position = not (not self.heroLevelContent_gotoBtn or IsNull(self.heroLevelContent_gotoBtn.transform)) and self.heroLevelContent_gotoBtn.transform.position or Vector3.zero
      TimerManager:GetInstance():DelayInvoke(function()
        fingerHandle:Destroy()
      end, 3)
    end)
  end
end

function UIZombieBattleResultGrowthList:OnFirstPayBtnClick()
  self.ctrl:CloseSelf()
  
  local function afterSwitchScene()
    EventManager:GetInstance():Broadcast(EventId.ShowFirstPayUI)
  end
  
  self:ExitBattleScene(afterSwitchScene)
end

function UIZombieBattleResultGrowthList:OnDominatorBtnClick()
  if not self.dominatorId then
    return
  end
  self.ctrl:CloseSelf()
  
  local function afterSwitchScene()
    if self.dominatorId then
      DataCenter.DominatorManager:OpenDominatorMain(self.dominatorId)
    end
  end
  
  self:ExitBattleScene(afterSwitchScene)
end

function UIZombieBattleResultGrowthList:OnWeaponBtnClick()
  self.ctrl:CloseSelf()
  
  local function afterSwitchScene()
    local hasWeapon = false
    local weapons = DataCenter.TacticalWeaponManager:GetTacticalWeaponInfos()
    if not table.IsNullOrEmpty(weapons) then
      for i, v in pairs(weapons) do
        hasWeapon = true
        break
      end
    end
    if not hasWeapon then
      UIUtil.ShowTipsId("develop_guide_tip6")
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeapon, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, TacticalWeaponPageType.Basic)
    end
  end
  
  self:ExitBattleScene(afterSwitchScene)
end

function UIZombieBattleResultGrowthList:OnDecorationBtnClick()
  self.ctrl:CloseSelf()
  
  local function afterSwitchScene()
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWDecorationBook)
  end
  
  self:ExitBattleScene(afterSwitchScene)
end

function UIZombieBattleResultGrowthList:RefreshView()
  self.canLevelUpHero = 0
  self.canEquipHero = 0
  self.canSkillUpHero = 0
  local canShowCityUpdate = false
  local heroQuality = 0
  local heroQualityHigh = 0
  if DataCenter.ZombieBattleManager.squad then
    local squadHeroes = DataCenter.ZombieBattleManager.squad.heroes
    for slotIndex, heroData in pairs(squadHeroes) do
      local hero = heroData
      local heroUuid = hero.uuid
      local canUpgrade, canUpgradeWithoutExpItems, overFinalLevel, reachLevelLimit = DataCenter.HeroDataManager:GetHeroCanUpgradeInfos(heroData)
      canUpgrade = not overFinalLevel and not reachLevelLimit
      if canUpgrade then
        self.canLevelUpHero = heroUuid
      end
      if heroQuality < hero.quality then
        heroQualityHigh = heroUuid
        heroQuality = hero.quality
      end
      if hero.finalLevel == nil and hero.level < 100 or hero.level < hero.finalLevel then
        canShowCityUpdate = true
      end
      local equip = DataCenter.EquipDataManager:GetHeroBetterEquip(hero)
      if equip then
        self.canEquipHero = heroUuid
      end
      local skill = hero:GetCanUpgradeSkill()
      if skill then
        self.canSkillUpHero = heroUuid
        self.canUpgradeSkillSlotIndex = skill.slotIndex
      end
    end
  end
  local canRecruit = false
  local buildData = DataCenter.BuildManager.buildIdBuilding[10120000]
  if buildData ~= nil and 1 <= #buildData and 0 < buildData[1].level then
    local count = DataCenter.ItemData:GetItemCount("230006")
    if count ~= nil and 10 <= count then
      canRecruit = true
    end
  end
  self.heroQualityHigh = heroQualityHigh
  self.recruitHeroContent:SetActive(canRecruit)
  self.heroLevelContent:SetActive(self.canLevelUpHero > 0)
  self.heroEquipContent:SetActive(0 < self.canEquipHero)
  self.heroSkillContent:SetActive(false)
  local isNewFirstPay = DataCenter.FirstPayManager:IsNewFirstPay()
  if isNewFirstPay then
    local firstPayPack = DataCenter.FirstPayManager:GetFirstPayPack()
    local hasFirstPayGift = firstPayPack ~= nil
    self.firstPayContent:SetActive(hasFirstPayGift)
  else
    local firstPayState = DataCenter.FirstPayManager:GetState()
    local hasFirstPayGift = firstPayState >= FirstPayState.Unrepaired and firstPayState < FirstPayState.HasReceivedNormalReward
    self.firstPayContent:SetActive(hasFirstPayGift)
  end
  local tankData = DataCenter.BuildManager.buildIdBuilding[10116000]
  local cityData = DataCenter.BuildManager.buildIdBuilding[10100000]
  local buildingId = 10116000
  local buildingName = Localization:GetString("129031")
  local iconName = "UI_building_10116000"
  if self.param and self.param.enterType == PVEEnterType.TrailTower then
    local targetCamp = DataCenter.LWTrailTowerManager:GetTrailTowerFormationTargetCampType()
    local buildingData = heroType2BuildingData[targetCamp]
    buildingId = buildingData.buildingId
    iconName = buildingData.iconName
    buildingName = buildingData.buildingName
    tankData = DataCenter.BuildManager.buildIdBuilding[buildingId]
  end
  if cityData ~= nil and #cityData == 1 then
    local canShowTank = false
    if tankData ~= nil and 1 <= #tankData then
      if tankData[1].level < cityData[1].level then
        self.tankData = tankData[1]
        canShowTank = true
      else
        canShowTank = false
      end
    else
      local state = DataCenter.BuildManager:GetBuildState(buildingId)
      if state == BuildState.BUILD_LIST_RECEIVED or state == BuildState.BUILD_LIST_STATE_OK then
        self.canBuildBuildingId = buildingId
        canShowTank = true
      else
        canShowTank = false
      end
    end
    self.cityData = cityData[1]
    self.tankUpdateContent:SetActive(canShowTank)
    if canShowTank then
      self.tankUpdateContent:RefreshShowView(Localization:GetString("130209", buildingName), string.format(LoadPath.UILWBattle, iconName))
    end
    self.cityUpdateContent:SetActive(canShowCityUpdate)
  else
    self.tankUpdateContent:SetActive(false)
    self.cityUpdateContent:SetActive(false)
  end
  local count = DataCenter.RadarCenterDataManager:GetUnFinishedDetectEventNum()
  self.radarContent:SetActive(0 < count)
  local showDominator = false
  local showWeapon = false
  local showDecoration = false
  if self.param and self.param.enterType == PVEEnterType.TowerupJeepAdventure and self.param.extraData and self.param.extraData.pageType == JeepAdventurePageType.Domintor and self.param.extraData.cfgId then
    local dominatorUpTemplate = DataCenter.DominatorUpTemplateManager:GetDominatorUpTemplate(self.param.extraData.cfgId)
    if dominatorUpTemplate then
      if self.param.mailExtData and self.param.mailExtData.hero then
        local hasDominator = self.param.mailExtData.hero[PVPBattleSlot.SelfDominator] ~= nil
        if hasDominator then
          self.dominatorId = self.param.mailExtData.hero[PVPBattleSlot.SelfDominator].heroId
          showDominator = true
          showWeapon = true
          showDecoration = true
        end
      end
      if dominatorUpTemplate:GetFormationPositionType() == ArmyFormationPositionType.OnlyDominator then
        self:HideAllContents()
      end
    end
  end
  self.dominatorContent:SetActive(showDominator)
  self.weaponContent:SetActive(showWeapon)
  self.decorationContent:SetActive(showDecoration)
end

function UIZombieBattleResultGrowthList:HideAllContents()
  if self.allContents then
    for i, v in pairs(self.allContents) do
      v:SetActive(false)
    end
  end
end

function UIZombieBattleResultGrowthList:ExitBattleScene(afterSwitchScene)
  if self.param and self.param.enterType == PVEEnterType.TrailTower then
    if self.param.notUseZombieBattleManagerExit ~= nil and self.param.notUseZombieBattleManagerExit then
      afterSwitchScene()
    else
      DataCenter.ZombieBattleManager:Exit(afterSwitchScene, PveExitType.ExitBtn)
    end
  elseif self.param and self.param.enterType == PVEEnterType.TowerupJeepAdventure and self.param.useHummerSceneManagerExit then
    DataCenter.LWHummerSceneManager:Exit(afterSwitchScene)
  elseif self.param and (self.param.type == PVEType.Parkour or self.param.type == PVEType.FakePVP) then
    DataCenter.LWBattleManager:Exit(afterSwitchScene, PveExitType.ExitBtn)
  else
    DataCenter.ZombieBattleManager:Exit(afterSwitchScene, PveExitType.ExitBtn)
  end
end

return UIZombieBattleResultGrowthList
