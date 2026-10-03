local UIBattleResultStatisticDefeatView = BaseClass("UIBattleResultStatisticDefeatView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CommonResultTabComponent = require("UI.UIBattleResultComponents.CommonResultTabComponent")
local BattleResultGrowthUtils = require("UI.UIBattleResultUtils.BattleResultGrowthUtils")
local BattleResultStatisticUtils = require("UI.UIBattleResultUtils.BattleResultStatisticUtils")
local BattleResultAnimStyle = require("UI.UIBattleResultUtils.BattleResultAnimStyle")
local GrowthWayType = BattleResultGrowthUtils.GrowthWayType
local WantedShowGrowthWays = {
  GrowthWayType.FirstPay,
  GrowthWayType.ArmedUpgrade,
  GrowthWayType.UpgradeHeroStar,
  GrowthWayType.HeroLevelUpgrade,
  GrowthWayType.RecruitHero,
  GrowthWayType.HeroSkill,
  GrowthWayType.CityUpgrade,
  GrowthWayType.TankUpgrade,
  GrowthWayType.HeroEquip,
  GrowthWayType.RadarDetect,
  GrowthWayType.AdjustFormation
}

function UIBattleResultStatisticDefeatView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIBattleResultStatisticDefeatView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBattleResultStatisticDefeatView:ComponentDefine()
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
  self.animatorUIBattleResultStatisticDefeat = self.viewSkin:AddComponent(self, UIAnimator, 10)
  self.textTxtTitle:SetLocalText("311106")
  self.textTxtTryAgain:SetLocalText("134021")
  self.loopListView2Scroll:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
end

function UIBattleResultStatisticDefeatView:ComponentDestroy()
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
  self.animatorUIBattleResultStatisticDefeat = nil
end

function UIBattleResultStatisticDefeatView:DataDefine()
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
  self.wantedShowGrowthWays = WantedShowGrowthWays
  self.battleResultAnimStyle = BattleResultAnimStyle.New()
  self.firstShowDelayAnim = false
  
  function self.growthFuncGo(data)
    self:OnClickGrowthGo(data)
  end
  
  function self.tabGrowthItemCfg.firstLoseGuide()
    self:FirstTimeLoseGrowthGuide()
  end
  
  local hasAni, animTime = self.animatorUIBattleResultStatisticDefeat:GetAnimationReturnTime("CommonPopup_movein")
  if hasAni and 0 < animTime then
    self.interactableBtns = false
    self.aniTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.interactableBtns = true
    end, animTime)
  else
    self.interactableBtns = true
  end
end

function UIBattleResultStatisticDefeatView:DataDestroy()
  self.tabGrowthItemCfg.firstLoseGuide = nil
  self.tabGrowthItemCfg.itemConfigs = nil
  if self.aniTimer then
    self.aniTimer:Stop()
    self.aniTimer = nil
    self.interactableBtns = false
  end
  if self.EscTimer then
    self.EscTimer:Stop()
    self.EscTimer = nil
  end
  self.battleResultAnimStyle:Delete()
  self.battleResultAnimStyle = nil
  self.loopListView2Scroll:ClearAllItems()
  if not IsNull(self.fadeTween) then
    self.fadeTween:Kill()
    self.fadeTween = nil
  end
  if self.fingerDestroyTimer then
    self.fingerDestroyTimer:Stop()
    self.fingerDestroyTimer = nil
  end
  if self.fingerHandle then
    self.fingerHandle:Destroy()
    self.fingerHandle = nil
  end
  if self.delayLoseGuideTimer then
    self.delayLoseGuideTimer:Stop()
    self.delayLoseGuideTimer = nil
  end
  self.itemConfigs = nil
  self.items = {}
  self.prefabIndex = nil
  self.heroLevelUpgradeItem = nil
  self.statisticItemsCfgs = nil
  self.tabItemConfigs = nil
  self.showedGrowthWays = nil
  self.growthFuncGo = nil
  self.firstShowDelayAnim = false
  self.tabGrowthItemCfg = nil
  self.tabDamageMakeItemCfg = nil
  self.tabDamageTakenItemCfg = nil
end

function UIBattleResultStatisticDefeatView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
end

function UIBattleResultStatisticDefeatView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  base.OnRemoveListener(self)
end

function UIBattleResultStatisticDefeatView:RefreshView()
  local param = self:GetUserData()
  local stageId = param.stageId
  local levelTitlePrefixKey = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), stageId, "name")
  local order = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), stageId, "order")
  self.textTxtStage:SetLocalText(levelTitlePrefixKey, order)
  self.compTab:SetActive(true)
  self.loopListView2Scroll:SetActive(true)
  self:ReInitTabCfgs()
  if param.hideTryAgainBtn then
    self.btnTryAgain:SetActive(false)
  else
    self.btnTryAgain:SetActive(true)
  end
end

function UIBattleResultStatisticDefeatView:ReInitTabCfgs()
  self:ConfigGrowthTab()
  self:ConfigMakeDamageTab()
  self:ConfigDamageTakenTab()
  self.compTab:ReInit(self.tabItemConfigs, function(index, data)
    self:OnTabItemClick(index, data)
  end)
end

function UIBattleResultStatisticDefeatView:ConfigGrowthTab()
  local tabGrowthShowedItemsCfgs = {}
  local team = DataCenter.LWBattleManager:GetCurBattleLogic().team.teamInitUnits
  local targetUpgradeLevelHeroUuid, canUpgradeFiveLevelsHeroNum, equipHeroUuid, isEquipHighLight, skillUpHeroUuid, skillUpHeroSlotIndex = BattleResultGrowthUtils:GetTeamGrowthInfoDefault(team)
  local wantedShowGrowthWayCfgs = BattleResultGrowthUtils.GetGrowthWayConfigs(self.wantedShowGrowthWays)
  for i, v in ipairs(wantedShowGrowthWayCfgs) do
    local match = false
    local canHighLight = false
    if v.type == GrowthWayType.FirstPay then
      match = BattleResultGrowthUtils.CanFirstPay()
      self.canFirstPay = match
    elseif v.type == GrowthWayType.ArmedUpgrade then
      match = BattleResultGrowthUtils.CanArmedUpgrade()
      self.canArmedUpgrade = match
    elseif v.type == GrowthWayType.HeroLevelUpgrade then
      match = 0 < targetUpgradeLevelHeroUuid
      self.canLevelUpHero = match
      self.levelUpHeroUuid = targetUpgradeLevelHeroUuid
      local highlightHeroUid = BattleResultGrowthUtils:GetCanHighlightHeroUid(team) or 0
      local isHighlight = 3 <= canUpgradeFiveLevelsHeroNum
      if 0 < highlightHeroUid or isHighlight then
        canHighLight = true
        self.levelUpHeroUuid = 0 < highlightHeroUid and highlightHeroUid or targetUpgradeLevelHeroUuid
      end
    elseif v.type == GrowthWayType.HeroEquip then
      match = 0 < equipHeroUuid
      self.canEquipHero = match
      self.equipHeroUuid = equipHeroUuid
      canHighLight = isEquipHighLight
    elseif v.type == GrowthWayType.UpgradeHeroStar then
      match, self.upStarOnceHeroUid, self.upStarFullHeroUid = BattleResultGrowthUtils:CanTeamSSRHeroesUpgradeStar(team)
      canHighLight = 0 < self.upStarFullHeroUid
    elseif v.type == GrowthWayType.AdjustFormation then
      match = BattleResultGrowthUtils:CanAdjustFormation(team, 1)
      if match then
        canHighLight, self.adjustData = BattleResultGrowthUtils:CanAdjustFormation(team, 2)
      end
    elseif v.type == GrowthWayType.HeroSkill then
      match = false
      self.canSkillUpHero = match
      self.skillUpHeroUuid = skillUpHeroUuid
      self.canUpgradeSkillSlotIndex = skillUpHeroSlotIndex
    elseif v.type == GrowthWayType.CityUpgrade then
      match, canHighLight = BattleResultGrowthUtils:IsLevelNeedCityUpgrade(team)
      self.canCityUpgrade = match
    elseif v.type == GrowthWayType.RecruitHero then
      match = BattleResultGrowthUtils.CanRecruitHeroDefault()
      self.canRecruitHero = match
      canHighLight = BattleResultGrowthUtils.CanHighlightRecruitHero()
    elseif v.type == GrowthWayType.TankUpgrade then
      match, self.tankData, self.heroType = BattleResultGrowthUtils.CanTargetBuildingUpgradeByHeroType(team)
      self.canTankUpgrade = match
    elseif v.type == GrowthWayType.RadarDetect then
      match = BattleResultGrowthUtils.CanRadarDetect()
      self.canShowRadar = match
    end
    if match then
      v.highLight = canHighLight
      v.funcGO = self.growthFuncGo
      table.insert(tabGrowthShowedItemsCfgs, v)
    end
  end
  local finalShowedItemsCfgs = {}
  local fixedFinal = {}
  local otherFinal = {}
  for i, v in ipairs(tabGrowthShowedItemsCfgs) do
    if v.type == GrowthWayType.FirstPay or v.type == GrowthWayType.ArmedUpgrade then
      table.insert(fixedFinal, v)
    else
      table.insert(otherFinal, v)
    end
  end
  table.sort(otherFinal, function(a, b)
    if a.highLight ~= b.highLight then
      return a.highLight
    else
      return a.type < b.type
    end
  end)
  local order = 0
  for i, v in ipairs(fixedFinal) do
    order = order + 1
    v.order = order
    table.insert(finalShowedItemsCfgs, v)
  end
  local canAddCount = 3
  for i, v in ipairs(otherFinal) do
    if canAddCount <= 0 then
      break
    end
    v.DebugHighlight = v.highLight
    if 1 < i then
      v.highLight = false
    end
    order = order + 1
    v.order = order
    table.insert(finalShowedItemsCfgs, v)
    canAddCount = canAddCount - 1
  end
  self.tabGrowthItemCfg.itemConfigs = finalShowedItemsCfgs
  for i, v in ipairs(finalShowedItemsCfgs) do
    print("\230\136\152\229\138\155\229\162\158\229\188\186\230\152\190\231\164\186\231\177\187\229\158\139:" .. tostring(v.type) .. "\230\152\175\229\144\166\233\171\152\228\186\174:" .. tostring(v.DebugHighlight or "false"))
  end
  local battleLogic = DataCenter.LWBattleManager:GetCurBattleLogic()
  local parts = {}
  local idx = 1
  for i, v in ipairs(finalShowedItemsCfgs) do
    parts[idx] = string.format("%d.%s.%d.%d", i, v.type, v.DebugHighlight and 1 or 0, v.highLight and 1 or 0)
    idx = idx + 1
  end
  local str = table.concat(parts, "|")
  PostEventLog.Track(PostEventLog.Defines.c_fail_settle_goto_show, {
    uid = LuaEntry.Player.uid,
    stageid = battleLogic:GetStageId(),
    goto_option = str
  })
end

function UIBattleResultStatisticDefeatView:ConfigMakeDamageTab()
  self.tabDamageMakeItemCfg.itemConfigs = self:GetBattleStatisticDatas(BattleResultStatisticUtils.STATISTIC_FILED_DAMAGE)
end

function UIBattleResultStatisticDefeatView:ConfigDamageTakenTab()
  self.tabDamageTakenItemCfg.itemConfigs = self:GetBattleStatisticDatas(BattleResultStatisticUtils.STATISTIC_FILED_DAMAGE_TAKEN)
end

function UIBattleResultStatisticDefeatView:ConfigMysteryChallengeGrowthItems()
end

function UIBattleResultStatisticDefeatView:GetBattleStatisticDatas(fieldName)
  if self.statisticItemsCfgs[fieldName] then
    return self.statisticItemsCfgs[fieldName]
  end
  local statisticItemsCfg = BattleResultStatisticUtils.GetParkourStatisticCfgs(fieldName)
  self.statisticItemsCfgs[fieldName] = statisticItemsCfg
  return statisticItemsCfg
end

function UIBattleResultStatisticDefeatView:OnTabItemClick(index, tabItemConfig)
  self:RefreshTabContent(index, tabItemConfig)
end

function UIBattleResultStatisticDefeatView:RefreshTabContent(index, tabItemConfig)
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
  if self.delayLoseGuideTimer then
    self.delayLoseGuideTimer:Stop()
    self.delayLoseGuideTimer = nil
  end
  if tabItemConfig and tabItemConfig.firstLoseGuide then
    self.delayLoseGuideTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.delayLoseGuideTimer = nil
      tabItemConfig.firstLoseGuide()
    end, 1.5)
  end
end

function UIBattleResultStatisticDefeatView:TryGetScrollItem(listview, index)
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
  if self.heroLevelUpgradeItem and self.heroLevelUpgradeItem == self.items[csItem] and data.type ~= GrowthWayType.HeroLevelUpgrade then
    self.heroLevelUpgradeItem = nil
  elseif not self.heroLevelUpgradeItem and data.type == GrowthWayType.HeroLevelUpgrade then
    self.heroLevelUpgradeItem = self.items[csItem]
  end
  return csItem
end

function UIBattleResultStatisticDefeatView:FirstTimeLoseGrowthGuide()
  if self.fingerDestroyTimer then
    self.fingerDestroyTimer:Stop()
    self.fingerDestroyTimer = nil
  end
  if self.fingerHandle then
    self.fingerHandle:Destroy()
    self.fingerHandle = nil
  end
  local buildingData = DataCenter.BuildManager:GetBuildingDatasByBuildingId(MAIN_CITY_BUILDING_ID)[1]
  if not buildingData or buildingData.level < 2 then
    return
  end
  if CommonUtil.PlayerPrefsGetInt("STAGE_LOSE_HERO_LV_GUIDE", 0) == 0 then
    CommonUtil.PlayerPrefsSetInt("STAGE_LOSE_HERO_LV_GUIDE", 1)
    self.fingerHandle = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/Guide/UIArrowFinger.prefab")
    self.fingerHandle:completed("+", function(handle)
      if handle.isError then
        return
      end
      local gameObject = handle.gameObject
      local transform = gameObject.transform
      transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.Guide.Name).transform, false)
      transform.position = self.heroLevelUpgradeItem and self.heroLevelUpgradeItem.GetBtnGoPos and self.heroLevelUpgradeItem:GetBtnGoPos() or Vector3.zero
      self.fingerDestroyTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.fingerDestroyTimer = nil
        self.fingerHandle:Destroy()
        self.fingerHandle = nil
      end, 3)
    end)
  end
end

function UIBattleResultStatisticDefeatView:TabSwitchFadeIn()
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

function UIBattleResultStatisticDefeatView:OnBtnReturnClick()
  if not self.interactableBtns then
    return
  end
  if self.ctrl then
    self.ctrl:CloseSelf()
  end
  local battleLogic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if not battleLogic then
    return
  end
  local myStageId = tostring(battleLogic:GetStageId())
  PostEventLog.Track(PostEventLog.Defines.BattleParkourSkip, {stageId = myStageId, isSkip = 2})
  DataCenter.LWBattleManager:GetCurBattleLogic():NoticeLose()
  DataCenter.LWBattleManager:Exit(nil, "lose")
end

function UIBattleResultStatisticDefeatView:OnBtnTryAgainClick()
  if not self.interactableBtns then
    return
  end
  self.ctrl:CloseSelf()
  self:DoTryAgain()
end

function UIBattleResultStatisticDefeatView:OnKeyCodeEscape()
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

function UIBattleResultStatisticDefeatView:DoTryAgain()
  local battleLogic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if not battleLogic then
    return
  end
  DataCenter.LWBattleManager:GetCurBattleLogic():NoticeLose()
  DataCenter.LWBattleManager:Restart()
  local myStageId = tostring(battleLogic:GetStageId())
  PostEventLog.Track(PostEventLog.Defines.BattleParkourSkip, {stageId = myStageId, isSkip = 1})
end

function UIBattleResultStatisticDefeatView:OnClickGrowthGo(data)
  if not self.interactableBtns then
    return
  end
  self:PostClickGrowthWayLog(data)
  self.ctrl:CloseSelf()
  local afterSwitchScene
  if data.type == GrowthWayType.FirstPay then
    afterSwitchScene = data.goAction
  elseif data.type == GrowthWayType.ArmedUpgrade then
    afterSwitchScene = data.goAction
  elseif data.type == GrowthWayType.HeroLevelUpgrade then
    function afterSwitchScene()
      data.goAction(self.levelUpHeroUuid)
    end
  elseif data.type == GrowthWayType.HeroEquip then
    function afterSwitchScene()
      data.goAction(self.equipHeroUuid, nil, true)
    end
  elseif data.type == GrowthWayType.HeroSkill then
    function afterSwitchScene()
      data.goAction(self.skillUpHeroUuid, self.canUpgradeSkillSlotIndex)
    end
  elseif data.type == GrowthWayType.CityUpgrade then
    afterSwitchScene = data.goAction
  elseif data.type == GrowthWayType.RecruitHero then
    afterSwitchScene = data.goAction
  elseif data.type == GrowthWayType.TankUpgrade then
    function afterSwitchScene()
      data.goAction(self.tankData, self.heroType)
    end
  elseif data.type == GrowthWayType.RadarDetect then
    afterSwitchScene = data.goAction
  elseif data.type == GrowthWayType.UpgradeHeroStar then
    function afterSwitchScene()
      if self.upStarFullHeroUid and self.upStarFullHeroUid > 0 then
        data.goAction(self.upStarFullHeroUid)
      elseif self.upStarOnceHeroUid and 0 < self.upStarOnceHeroUid then
        data.goAction(self.upStarOnceHeroUid)
      end
    end
  elseif data.type == GrowthWayType.AdjustFormation then
    BattleResultGrowthUtils:ClearNeedAdjustFormationData()
    if not table.IsNullOrEmpty(self.adjustData) then
      BattleResultGrowthUtils:SetNeedAdjustFormationData(self.adjustData)
    end
    self:DoTryAgain()
    return
  end
  DataCenter.LWBattleManager:Exit(afterSwitchScene, "lose")
end

function UIBattleResultStatisticDefeatView:PostClickGrowthWayLog(data)
  local battleLogic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if not battleLogic then
    return
  end
  local uid = LuaEntry.Player.uid
  local stageId = battleLogic:GetStageId()
  local gotoId = data.type
  local order = data.order
  local canhighlight = data.DebugHighlight and 1 or 0
  local highlighted = data.highLight and 1 or 0
  PostEventLog.Track(PostEventLog.Defines.c_fail_settle_goto, {
    uid = uid,
    stageid = stageId,
    gotoid = gotoId,
    order = order,
    canhighlight = canhighlight,
    highlighted = highlighted
  })
end

return UIBattleResultStatisticDefeatView
