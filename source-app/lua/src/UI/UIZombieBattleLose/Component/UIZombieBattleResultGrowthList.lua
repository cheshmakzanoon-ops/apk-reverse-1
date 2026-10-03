local UIZombieBattleResultGrowthList = BaseClass("UIZombieBattleResultGrowthList", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGrowthItem = require("UI.UIZombieBattleLose.Component.UIZombieBattleResultGrowthListItem")

function UIZombieBattleResultGrowthList:OnCreate(ctrl, view)
  base.OnCreate(self)
  self:ComponentDefine()
  self.ctrl = ctrl
  self.view = view
end

function UIZombieBattleResultGrowthList:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
  self:ClearAllDelayTimers()
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
  self.heroLevelContent = self:AddComponent(UIGrowthItem, "Viewport/Content/HeroLevelContent")
  self.heroLevelContent:RefreshView(Localization:GetString("140062"), "450004", self, self.OnHeroLevelBtnClick)
  self.recruitHeroContent = self:AddComponent(UIGrowthItem, "Viewport/Content/RecruitHeroContent")
  self.recruitHeroContent:RefreshView(Localization:GetString("450005"), "450004", self, self.OnRecruitHeroBtnClick)
  self.heroEquipContent = self:AddComponent(UIGrowthItem, "Viewport/Content/HeroEquipContent")
  self.heroEquipContent:RefreshView(Localization:GetString("260000"), "450004", self, self.OnHeroEquipBtnClick)
  self.heroSkillContent = self:AddComponent(UIGrowthItem, "Viewport/Content/HeroSkillContent")
  self.heroSkillContent:RefreshView(Localization:GetString("450007"), "450004", self, self.OnHeroSkillBtnClick)
  self.firstPayContent = self:AddComponent(UIGrowthItem, "Viewport/Content/FirstPayContent")
  self.firstPayContent:RefreshView(Localization:GetString("2000328"), "450004", self, self.OnFirstPayBtnClick)
  self.cityUpdateContent = self:AddComponent(UIGrowthItem, "Viewport/Content/CityUpdate")
  self.cityUpdateContent:RefreshView(Localization:GetString("130209", Localization:GetString("135104")), "450004", self, self.OnCityBtnClick)
  self.tankUpdateContent = self:AddComponent(UIGrowthItem, "Viewport/Content/TankUpdate")
  self.tankUpdateContent:RefreshView(Localization:GetString("130209", Localization:GetString("129031")), "450004", self, self.OnTankBtnClick)
  self.radarContent = self:AddComponent(UIGrowthItem, "Viewport/Content/RadarUpdate")
  self.radarContent:RefreshView(Localization:GetString("121289"), "450004", self, self.OnRadarBtnClick)
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
  
  DataCenter.ZombieBattleManager:Exit(afterSwitchScene, PveExitType.ExitBtn)
end

function UIZombieBattleResultGrowthList:OnTankBtnClick()
  self.ctrl:CloseSelf()
  local tankData = self.tankData
  
  local function afterSwitchScene()
    if tankData == nil then
      GoToUtil.GotoCityByBuildId(10116000, WorldTileBtnType.City_Upgrade)
    else
      GoToUtil.GotoCityByBuildId(10116000, WorldTileBtnType.City_Upgrade, nil, true)
    end
  end
  
  DataCenter.ZombieBattleManager:Exit(afterSwitchScene, PveExitType.ExitBtn)
end

function UIZombieBattleResultGrowthList:OnRadarBtnClick()
  self.ctrl:CloseSelf()
  
  local function afterSwitchScene()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent)
  end
  
  DataCenter.ZombieBattleManager:Exit(afterSwitchScene, PveExitType.ExitBtn)
end

function UIZombieBattleResultGrowthList:OnHeroLevelBtnClick()
  self.ctrl:CloseSelf()
  local heroUuid = self.heroQualityHigh
  
  local function afterSwitchScene()
    local arrowData = {
      arrowType = HeroDetailGuideArrowType.Upgrade,
      heroUid = heroUuid,
      pointLevelBtn = true
    }
    local heroList = HeroUtils.GenerateHeroDataList(0)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, heroUuid, heroList, nil, arrowData)
  end
  
  DataCenter.ZombieBattleManager:Exit(afterSwitchScene, PveExitType.ExitBtn)
end

function UIZombieBattleResultGrowthList:OnRecruitHeroBtnClick()
  self.ctrl:CloseSelf()
  
  local function afterSwitchScene()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruit, {anim = true})
  end
  
  DataCenter.ZombieBattleManager:Exit(afterSwitchScene, PveExitType.ExitBtn)
end

function UIZombieBattleResultGrowthList:OnHeroEquipBtnClick()
  self.ctrl:CloseSelf()
  local heroUuid = self.canEquipHero
  
  local function afterSwitchScene()
    local arrowData = {
      arrowType = HeroDetailGuideArrowType.Equip,
      heroUid = heroUuid
    }
    local heroList = HeroUtils.GenerateHeroDataList(0)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, heroUuid, heroList, nil, arrowData)
  end
  
  DataCenter.ZombieBattleManager:Exit(afterSwitchScene, PveExitType.ExitBtn)
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
    local heroList = HeroUtils.GenerateHeroDataList(0)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, heroUuid, heroList, nil, arrowData)
  end
  
  DataCenter.ZombieBattleManager:Exit(afterSwitchScene, PveExitType.ExitBtn)
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
      transform.position = not (not (self.heroLevelContent and self.heroLevelContent.goto_btn) or IsNull(self.heroLevelContent.goto_btn.transform)) and self.heroLevelContent.goto_btn.transform.position or Vector3.zero
      self:CreateDelayTimer(function()
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
  
  DataCenter.ZombieBattleManager:Exit(afterSwitchScene, PveExitType.ExitBtn)
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
      local state = DataCenter.BuildManager:GetBuildState(10116000)
      if state == BuildState.BUILD_LIST_RECEIVED or state == BuildState.BUILD_LIST_STATE_OK then
        canShowTank = true
      else
        canShowTank = false
      end
    end
    self.cityData = cityData[1]
    self.tankUpdateContent:SetActive(canShowTank)
    self.cityUpdateContent:SetActive(canShowCityUpdate)
  else
    self.tankUpdateContent:SetActive(false)
    self.cityUpdateContent:SetActive(false)
  end
  local count = DataCenter.RadarCenterDataManager:GetUnFinishedDetectEventNum()
  self.radarContent:SetActive(0 < count)
  if DataCenter.ZombieBattleManager.param.featureId and DataCenter.ZombieBattleManager.param.enterType == PVEEnterType.StageFeatureBuilding then
    local allhero = DataCenter.HeroDataManager:GetAllHeroList()
    local heroCount = table.count(allhero)
    if 5 < heroCount then
      heroCount = 5
    end
  end
end

function UIZombieBattleResultGrowthList:CreateDelayTimer(callback, delay, timerName)
  if self.delayTimers == nil then
    self.delayTimers = {}
  end
  timerName = timerName or "timer_" .. tostring(#self.delayTimers + 1)
  local timer = TimerManager:GetInstance():DelayInvoke(function()
    if self.delayTimers[timerName] then
      self.delayTimers[timerName] = nil
    end
    callback()
  end, delay)
  self.delayTimers[timerName] = timer
  return timer
end

function UIZombieBattleResultGrowthList:ClearAllDelayTimers()
  if self.delayTimers then
    for name, timer in pairs(self.delayTimers) do
      if timer then
        timer:Stop()
      end
    end
    self.delayTimers = {}
  end
end

return UIZombieBattleResultGrowthList
