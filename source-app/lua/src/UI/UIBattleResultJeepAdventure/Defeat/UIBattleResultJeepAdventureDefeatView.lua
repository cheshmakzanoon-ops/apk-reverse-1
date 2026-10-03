local UIBattleResultJeepAdventureDefeatView = BaseClass("UIBattleResultJeepAdventureDefeatView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CommonResultTabComponent = require("UI.UIBattleResultComponents.CommonResultTabComponent")
local BattleResultGrowthUtils = require("UI.UIBattleResultUtils.BattleResultGrowthUtils")
local BattleResultStatisticUtils = require("UI.UIBattleResultUtils.BattleResultStatisticUtils")
local BattleResultAnimStyle = require("UI.UIBattleResultUtils.BattleResultAnimStyle")
local GrowthWayType = BattleResultGrowthUtils.GrowthWayType
local DominatorModeShowGrowthWays = {
  GrowthWayType.FirstPay,
  GrowthWayType.DominatorUpgrade,
  GrowthWayType.WeaponUpgrade,
  GrowthWayType.DecorationUpgrade,
  GrowthWayType.HeroLevelUpgrade,
  GrowthWayType.RecruitHero,
  GrowthWayType.HeroSkill,
  GrowthWayType.CityUpgrade,
  GrowthWayType.TankUpgrade,
  GrowthWayType.HeroEquip,
  GrowthWayType.RadarDetect
}
local NormalModeShowGrowthWays = {
  GrowthWayType.FirstPay,
  GrowthWayType.HeroLevelUpgrade,
  GrowthWayType.RecruitHero,
  GrowthWayType.HeroSkill,
  GrowthWayType.CityUpgrade,
  GrowthWayType.TankUpgrade,
  GrowthWayType.HeroEquip,
  GrowthWayType.RadarDetect
}
local DominatorOnlyModeShowGrowthWays = {
  GrowthWayType.DominatorUpgrade,
  GrowthWayType.WeaponUpgrade,
  GrowthWayType.DecorationUpgrade
}

function UIBattleResultJeepAdventureDefeatView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIBattleResultJeepAdventureDefeatView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBattleResultJeepAdventureDefeatView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTxtTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTxtStage = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compTab = self.viewSkin:AddComponent(self, CommonResultTabComponent, 3)
  self.loopListView2Scroll = self.viewSkin:AddComponent(self, UILoopListView2, 4)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.btnTryAgain = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnTryAgain:SetOnClick(function()
    self:OnBtnTryAgainClick()
  end)
  self.textTxtTryAgain = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnReturn = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnReturn:SetOnClick(function()
    self:OnBtnReturnClick()
  end)
  self.canvasGroupContent = self.viewSkin:AddComponent(self, UICanvasGroup, 9)
  self.animatorUIBattleResultJeepAdventureDefeat = self.viewSkin:AddComponent(self, UIAnimator, 10)
  self.textTxtTitle:SetLocalText("311106")
  self.textTxtTryAgain:SetLocalText("450008")
  self.loopListView2Scroll:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
end

function UIBattleResultJeepAdventureDefeatView:ComponentDestroy()
  self.viewSkin = nil
  self.textTxtTitle = nil
  self.textTxtStage = nil
  self.compTab = nil
  self.loopListView2Scroll = nil
  self.compContent = nil
  self.btnTryAgain = nil
  self.textTxtTryAgain = nil
  self.btnReturn = nil
  self.canvasGroupContent = nil
  self.animatorUIBattleResultJeepAdventureDefeat = nil
end

function UIBattleResultJeepAdventureDefeatView:DataDefine()
  self.tabGrowthItemCfg = {
    activeTxt = Localization:GetString("800799"),
    inActiveTxt = Localization:GetString("800799")
  }
  self.tabDamageMakeItemCfg = {
    activeTxt = Localization:GetString("800800"),
    inActiveTxt = Localization:GetString("800800")
  }
  self.tabDamageTakenItemCfg = {
    activeTxt = Localization:GetString("800801"),
    inActiveTxt = Localization:GetString("800801")
  }
  self.itemConfigs = {}
  self.items = {}
  self.prefabIndex = 0
  self.statisticItemsCfgs = {}
  self.tabItemConfigs = {
    self.tabGrowthItemCfg,
    self.tabDamageMakeItemCfg,
    self.tabDamageTakenItemCfg
  }
  self.battleResultAnimStyle = BattleResultAnimStyle.New()
  self.firstShowDelayAnim = false
  
  function self.growthFuncGo(data)
    self:OnClickGrowthGo(data)
  end
  
  local hasAni, animTime = self.animatorUIBattleResultJeepAdventureDefeat:GetAnimationReturnTime("CommonPopup_movein")
  if hasAni and 0 < animTime then
    self.interactableBtns = false
    self.aniTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.interactableBtns = true
    end, animTime)
  else
    self.interactableBtns = true
  end
end

function UIBattleResultJeepAdventureDefeatView:DataDestroy()
  if self.EscTimer then
    self.EscTimer:Stop()
    self.EscTimer = nil
  end
  if self.aniTimer then
    self.aniTimer:Stop()
    self.aniTimer = nil
    self.interactableBtns = false
  end
  self.battleResultAnimStyle:Delete()
  self.battleResultAnimStyle = nil
  self.firstShowDelayAnim = false
  self.loopListView2Scroll:ClearAllItems()
  if not IsNull(self.fadeTween) then
    self.fadeTween:Kill()
    self.fadeTween = nil
  end
  self.isDominatorOnlyGrowthMode = false
  self.isDominatorMode = false
  self.itemConfigs = nil
  self.items = {}
  self.prefabIndex = nil
  self.statisticItemsCfgs = nil
  self.cfgId = nil
  self.pageType = nil
  self.tabGrowthItemCfg = nil
  self.tabDamageMakeItemCfg = nil
  self.tabDamageTakenItemCfg = nil
end

function UIBattleResultJeepAdventureDefeatView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
end

function UIBattleResultJeepAdventureDefeatView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  base.OnRemoveListener(self)
end

function UIBattleResultJeepAdventureDefeatView:RefreshView()
  local param = self:GetUserData()
  self.cfgId = param.extraData.cfgId
  self.pageType = param.extraData.pageType
  local stageId = 0
  local targetStageMeta = DataCenter.LWJeepAdventureManager:GetStageMetaByType(self.cfgId, self.pageType)
  if targetStageMeta then
    stageId = targetStageMeta.idle_reward_stageid
  end
  if 0 < stageId then
    self.textTxtStage:SetText(Localization:GetString("800313", GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), stageId, "level")))
  else
    self.textTxtStage:SetText("")
  end
  self.compTab:SetActive(true)
  self.loopListView2Scroll:SetActive(true)
  self:ReInitTabCfgs()
  if param.hideTryAgainBtn then
    self.btnTryAgain:SetActive(false)
  else
    self.btnTryAgain:SetActive(true)
  end
  DataCenter.TowerUpSaveDataManager:SetAutoNextStage(false)
end

function UIBattleResultJeepAdventureDefeatView:ReInitTabCfgs()
  self:ConfigGrowthTab()
  self:ConfigMakeDamageTab()
  self:ConfigDamageTakenTab()
  self.compTab:ReInit(self.tabItemConfigs, function(index, data)
    self:OnTabItemClick(index, data)
  end)
end

function UIBattleResultJeepAdventureDefeatView:ConfigGrowthTab()
  local tabGrowthShowedItemsCfgs = {}
  local param = self:GetUserData()
  self.isDominatorOnlyGrowthMode = false
  self.isDominatorMode = false
  if param and param.extraData and param.extraData.pageType == JeepAdventurePageType.Domintor and param.extraData.cfgId then
    local dominatorUpTemplate = DataCenter.DominatorUpTemplateManager:GetDominatorUpTemplate(param.extraData.cfgId)
    if dominatorUpTemplate then
      if param.mailExtData and param.mailExtData.hero then
        local hasDominator = param.mailExtData.hero[PVPBattleSlot.SelfDominator] ~= nil
        if hasDominator then
          self.dominatorId = param.mailExtData.hero[PVPBattleSlot.SelfDominator].heroId
          self.isDominatorMode = true
        end
      end
      self.isDominatorOnlyGrowthMode = dominatorUpTemplate:GetFormationPositionType() == ArmyFormationPositionType.OnlyDominator
    end
  end
  if self.isDominatorOnlyGrowthMode then
    self.wantedShowGrowthWays = DominatorOnlyModeShowGrowthWays
  elseif self.isDominatorMode then
    self.wantedShowGrowthWays = DominatorModeShowGrowthWays
  else
    self.wantedShowGrowthWays = NormalModeShowGrowthWays
  end
  local team = DataCenter.ZombieBattleManager.squad and DataCenter.ZombieBattleManager.squad.heroes
  local maxQualityUpgradeLevelHeroUuid, levelNeedCityUpgrade, equipHeroUuid, skillUpHeroUuid, skillUpHeroSlotIndex = BattleResultGrowthUtils.GetTeamGrowthInfo(team)
  local wantedShowGrowthWayCfgs = BattleResultGrowthUtils.GetGrowthWayConfigs(self.wantedShowGrowthWays)
  for i, v in ipairs(wantedShowGrowthWayCfgs) do
    local match = false
    if v.type == GrowthWayType.FirstPay then
      match = BattleResultGrowthUtils.CanFirstPay()
      self.canFirstPay = match
    elseif v.type == GrowthWayType.ArmedUpgrade then
      match = BattleResultGrowthUtils.CanArmedUpgrade()
      self.canArmedUpgrade = match
    elseif v.type == GrowthWayType.HeroLevelUpgrade then
      match = 0 < maxQualityUpgradeLevelHeroUuid
      self.canLevelUpHero = match
      self.levelUpHeroUuid = maxQualityUpgradeLevelHeroUuid
    elseif v.type == GrowthWayType.HeroEquip then
      match = 0 < equipHeroUuid
      self.canEquipHero = match
      self.equipHeroUuid = equipHeroUuid
    elseif v.type == GrowthWayType.HeroSkill then
      match = false
      self.canSkillUpHero = match
      self.skillUpHeroUuid = skillUpHeroUuid
      self.canUpgradeSkillSlotIndex = skillUpHeroSlotIndex
    elseif v.type == GrowthWayType.CityUpgrade then
      match = levelNeedCityUpgrade
      self.canCityUpgrade = match
    elseif v.type == GrowthWayType.RecruitHero then
      match = BattleResultGrowthUtils.CanRecruitHero()
      self.canRecruitHero = match
    elseif v.type == GrowthWayType.TankUpgrade then
      match, self.tankData = BattleResultGrowthUtils.CanTargetBuildingUpgrade(BattleResultGrowthUtils.TANK_BUILDING_ID, BattleResultGrowthUtils.MAIN_CITY_BUILDING_ID)
      self.canTankUpgrade = match
    elseif v.type == GrowthWayType.RadarDetect then
      match = BattleResultGrowthUtils.CanRadarDetect()
      self.canShowRadar = match
    elseif v.type == GrowthWayType.DominatorUpgrade then
      match = true
    elseif v.type == GrowthWayType.WeaponUpgrade then
      match = true
    elseif v.type == GrowthWayType.DecorationUpgrade then
      match = true
    end
    if match then
      v.funcGO = self.growthFuncGo
      table.insert(tabGrowthShowedItemsCfgs, v)
    end
  end
  self.tabGrowthItemCfg.itemConfigs = tabGrowthShowedItemsCfgs
end

function UIBattleResultJeepAdventureDefeatView:ConfigMakeDamageTab()
  self.tabDamageMakeItemCfg.itemConfigs = self:GetBattleStatisticDatas(BattleResultStatisticUtils.STATISTIC_FILED_DAMAGE)
end

function UIBattleResultJeepAdventureDefeatView:ConfigDamageTakenTab()
  self.tabDamageTakenItemCfg.itemConfigs = self:GetBattleStatisticDatas(BattleResultStatisticUtils.STATISTIC_FILED_DAMAGE_TAKEN)
end

function UIBattleResultJeepAdventureDefeatView:GetBattleStatisticDatas(fieldName)
  if self.statisticItemsCfgs[fieldName] then
    return self.statisticItemsCfgs[fieldName]
  end
  local param = self:GetUserData()
  local statisticItemsCfg
  if param.type == PVEType.Barrage then
    statisticItemsCfg = BattleResultStatisticUtils.GetBarrageStatisticCfgs(fieldName)
  elseif param.type == PVEType.FakePVP then
    statisticItemsCfg = BattleResultStatisticUtils.GetFakePVPStatisticCfgs(fieldName)
  elseif param.type == PVEType.Parkour then
    statisticItemsCfg = BattleResultStatisticUtils.GetParkourStatisticCfgs(fieldName)
  end
  self.statisticItemsCfgs[fieldName] = statisticItemsCfg
  return statisticItemsCfg
end

function UIBattleResultJeepAdventureDefeatView:OnTabItemClick(index, tabItemConfig)
  self:RefreshTabContent(index, tabItemConfig)
end

function UIBattleResultJeepAdventureDefeatView:RefreshTabContent(index, tabItemConfig)
  local newItemConfigs = tabItemConfig and tabItemConfig.itemConfigs or {}
  if not self.itemConfigs or #self.itemConfigs ~= #newItemConfigs then
    self.itemConfigs = newItemConfigs
    self.loopListView2Scroll:SetListItemCount(#self.itemConfigs, true, false)
  else
    self.itemConfigs = newItemConfigs
    self.loopListView2Scroll:RefreshAllShownItem()
  end
  self.firstShowDelayAnim = true
  self:TabSwitchFadeIn()
end

function UIBattleResultJeepAdventureDefeatView:TryGetScrollItem(listview, index)
  if #self.itemConfigs <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #self.itemConfigs then
    return nil
  end
  local data = self.itemConfigs[index]
  local csItem = listview:NewListViewItem(data.prefabName)
  local firstCreate = false
  local itemName = csItem.gameObject.name
  local item = self.items[csItem]
  if item == nil then
    firstCreate = true
    local prefabIndex = self.prefabIndex or 0
    itemName = "Item" .. prefabIndex
    self.prefabIndex = prefabIndex + 1
    csItem.gameObject.name = itemName
    item = self.compContent:AddComponent(data.cmp, itemName)
    self.items[csItem] = item
  end
  if item ~= nil then
    self.items[csItem]:ReInit(data)
    if not firstCreate then
      self.battleResultAnimStyle:StopItemDelayActiveTimer(itemName, item)
    elseif not self.firstShowDelayAnim then
      self.battleResultAnimStyle:AddItemNewDelayActiveTimer(itemName, item)
    end
  end
  return csItem
end

function UIBattleResultJeepAdventureDefeatView:TabSwitchFadeIn()
  if not IsNull(self.fadeTween) then
    self.fadeTween:Kill()
    self.fadeTween = nil
  end
  self.canvasGroupContent:SetAlpha(0)
  self.fadeTween = CS.DG.Tweening.DOTween.To(function()
    return self.canvasGroupContent:GetAlpha()
  end, function(value)
    self.canvasGroupContent:SetAlpha(value)
  end, 1, 0.5):SetEase(CS.DG.Tweening.Ease.Linear)
end

function UIBattleResultJeepAdventureDefeatView:OnBtnReturnClick()
  if not self.interactableBtns then
    return
  end
  local param = self:GetUserData()
  if param.type == PVEType.FakePVP or param.type == PVEType.Parkour then
    DataCenter.LWBattleManager:SetBattleExitFlag(true)
    DataCenter.LWBattleManager:Exit(function()
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBattleResultJeepAdventureDefeat)
    end)
  elseif param.type == PVEType.Barrage then
    DataCenter.ZombieBattleManager:SetBattleExitFlag(true)
    DataCenter.ZombieBattleManager:Exit(function()
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBattleResultJeepAdventureDefeat)
    end, LWStageType.TowerupAdvanture)
  end
end

function UIBattleResultJeepAdventureDefeatView:OnBtnTryAgainClick()
  if not self.interactableBtns then
    return
  end
  if self.cfgId > 0 and self.pageType then
    DataCenter.LWJeepAdventureManager:EnterBattle(self.cfgId, self.pageType)
  end
end

function UIBattleResultJeepAdventureDefeatView:OnKeyCodeEscape()
  if not self.interactableBtns then
    return
  end
  if self.EscTimer ~= nil then
    return
  end
  self.EscTimer = TimerManager:GetInstance():DelayFrameInvoke(function()
    self:OnBtnReturnClick()
    self.EscTimer = nil
  end, 1)
end

function UIBattleResultJeepAdventureDefeatView:OnClickGrowthGo(data)
  self.ctrl:CloseSelf()
  local afterSwitchScene
  if data.type == GrowthWayType.FirstPay then
    afterSwitchScene = data.goAction
  elseif data.type == GrowthWayType.ArmedUpgrade then
    afterSwitchScene = data.goAction
  elseif data.type == GrowthWayType.HeroLevelUpgrade then
    function afterSwitchScene()
      data.goAction(self.levelUpHeroUuid, {
        self.levelUpHeroUuid
      })
    end
  elseif data.type == GrowthWayType.HeroEquip then
    function afterSwitchScene()
      data.goAction(self.equipHeroUuid, {
        self.equipHeroUuid
      })
    end
  elseif data.type == GrowthWayType.HeroSkill then
    function afterSwitchScene()
      data.goAction(self.skillUpHeroUuid, self.canUpgradeSkillSlotIndex, {
        self.skillUpHeroUuid
      })
    end
  elseif data.type == GrowthWayType.CityUpgrade then
    afterSwitchScene = data.goAction
  elseif data.type == GrowthWayType.RecruitHero then
    afterSwitchScene = data.goAction
  elseif data.type == GrowthWayType.TankUpgrade then
    function afterSwitchScene()
      data.goAction(self.tankData)
    end
  elseif data.type == GrowthWayType.RadarDetect then
    afterSwitchScene = data.goAction
  elseif data.type == GrowthWayType.DominatorUpgrade then
    function afterSwitchScene()
      data.goAction(self.dominatorId)
    end
  elseif data.type == GrowthWayType.WeaponUpgrade then
    afterSwitchScene = data.goAction
  elseif data.type == GrowthWayType.DecorationUpgrade then
    afterSwitchScene = data.goAction
  end
  self:ExitBattleScene(afterSwitchScene)
end

function UIBattleResultJeepAdventureDefeatView:ExitBattleScene(afterSwitchScene)
  local param = self:GetUserData()
  if param and (param.type == PVEType.Parkour or param.type == PVEType.FakePVP) then
    DataCenter.LWBattleManager:Exit(afterSwitchScene, PveExitType.ExitBtn)
  else
    DataCenter.ZombieBattleManager:Exit(afterSwitchScene, LWStageType.SingleBattle)
  end
end

return UIBattleResultJeepAdventureDefeatView
