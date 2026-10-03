local UIBattleResultJeepAdventureVictoryView = BaseClass("UIBattleResultJeepAdventureVictoryView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local autoWaitTime = 5000
local CommonResultTabComponent = require("UI.UIBattleResultComponents.CommonResultTabComponent")
local BattleResultStatisticUtils = require("UI.UIBattleResultUtils.BattleResultStatisticUtils")
local BattleResultAnimStyle = require("UI.UIBattleResultUtils.BattleResultAnimStyle")

function UIBattleResultJeepAdventureVictoryView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIBattleResultJeepAdventureVictoryView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBattleResultJeepAdventureVictoryView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTxtTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTxtStage = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnNext = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnNext:SetOnClick(function()
    self:OnBtnNextClick()
  end)
  self.btnReturn = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnReturn:SetOnClick(function()
    self:OnBtnReturnClick()
  end)
  self.textTxtNext = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compStatisticContent = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.loopListView2StatisticScroll = self.viewSkin:AddComponent(self, UILoopListView2, 7)
  self.compTab = self.viewSkin:AddComponent(self, CommonResultTabComponent, 8)
  self.canvasGroupStatisticContent = self.viewSkin:AddComponent(self, UICanvasGroup, 9)
  self.scrollViewScroll = self.viewSkin:AddComponent(self, UIScrollView, 10)
  self.compRewardContent = self.viewSkin:AddComponent(self, UIBaseContainer, 11)
  self.toggleBack = self.viewSkin:AddComponent(self, UIToggle, 12)
  self.textToggle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.canvasGroupRewardContent = self.viewSkin:AddComponent(self, UICanvasGroup, 14)
  self.animatorUIBattleResultJeepAdventureVictory = self.viewSkin:AddComponent(self, UIAnimator, 15)
  self.textTxtTitle:SetLocalText("311105")
  self.textToggle:SetLocalText("456810")
  self.compStatisticContent:SetActive(false)
  self.compRewardContent:SetActive(false)
  self.toggleBack:SetIsOn(false)
  self.toggleBack:SetOnValueChanged(function(value)
    self:OnToggerChangeFunc(value)
  end)
  self.scrollViewScroll:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.scrollViewScroll:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
  self.loopListView2StatisticScroll:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
end

function UIBattleResultJeepAdventureVictoryView:ComponentDestroy()
  self.viewSkin = nil
  self.textTxtTitle = nil
  self.textTxtStage = nil
  self.btnNext = nil
  self.btnReturn = nil
  self.textTxtNext = nil
  self.compStatisticContent = nil
  self.loopListView2StatisticScroll = nil
  self.compTab = nil
  self.canvasGroupStatisticContent = nil
  self.scrollViewScroll = nil
  self.compRewardContent = nil
  self.toggleBack = nil
  self.textToggle = nil
  self.canvasGroupRewardContent = nil
  self.animatorUIBattleResultJeepAdventureVictory = nil
end

function UIBattleResultJeepAdventureVictoryView:DataDefine()
  self.tabRewardItemCfg = {
    activeTxt = Localization:GetString("456808"),
    inActiveTxt = Localization:GetString("456808")
  }
  self.tabDamageMakeItemCfg = {
    activeTxt = Localization:GetString("800800"),
    inActiveTxt = Localization:GetString("800800")
  }
  self.tabDamageTakenItemCfg = {
    activeTxt = Localization:GetString("800801"),
    inActiveTxt = Localization:GetString("800801")
  }
  self.battleManagerParam = self:GetUserData()
  self.rewardScrollCellPool = {}
  self.rewardItemIndex = 1
  self.rewardFlyReward = {}
  self.rewardDatalist = {}
  self.autoNextStageStartTime = -1
  self.itemConfigs = {}
  self.items = {}
  self.prefabIndex = 0
  self.statisticItemsCfgs = {}
  self.tabItemConfigs = {
    self.tabRewardItemCfg,
    self.tabDamageMakeItemCfg,
    self.tabDamageTakenItemCfg
  }
  self.firstShowDelayAnim = false
  self.rewardAnimStyle = BattleResultAnimStyle.New()
  self.statisticAnimStyle = BattleResultAnimStyle.New()
  local hasAni, animTime = self.animatorUIBattleResultJeepAdventureVictory:GetAnimationReturnTime("CommonPopup_movein")
  if hasAni and 0 < animTime then
    self.interactableBtns = false
    self.aniTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.interactableBtns = true
    end, animTime)
  else
    self.interactableBtns = true
  end
end

function UIBattleResultJeepAdventureVictoryView:RefreshView()
  DataCenter.LWSoundManager:PlaySound(10027)
  local param = self.battleManagerParam
  self.cfgId = param.extraData.cfgId
  self.pageType = param.extraData.pageType
  local targetStageMeta = DataCenter.LWJeepAdventureManager:GetStageMetaByType(self.cfgId, self.pageType)
  local stageId = targetStageMeta and targetStageMeta.idle_reward_stageid
  if stageId then
    self.stageTemp = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), stageId)
    self.textTxtStage:SetText(Localization:GetString("800313", GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), stageId, "level")))
  else
    self.textTxtStage:SetText("")
  end
  self.textTxtNext:SetLocalText("800306")
  local nextTemplate = DataCenter.LWJeepAdventureManager:GetStageMetaByType(self.cfgId + 1, self.pageType)
  self.btnNext:SetActive(nextTemplate ~= nil)
  self:RefreshAutoNextStageToggerView()
  self:DeleteTimer()
  self:AddTimer()
  self:ReInitTabCfgs()
end

function UIBattleResultJeepAdventureVictoryView:ReInitTabCfgs()
  self:OnGetReward(DataCenter.TowerUpSaveDataManager.saveData)
  self:ConfigMakeDamageTab()
  self:ConfigDamageTakenTab()
  self.compTab:ReInit(self.tabItemConfigs, function(index, data)
    self:OnTabItemClick(index, data)
  end)
end

function UIBattleResultJeepAdventureVictoryView:OnTabItemClick(index, tabItemConfig)
  self:RefreshTabContent(index, tabItemConfig)
end

function UIBattleResultJeepAdventureVictoryView:RefreshTabContent(index, tabItemConfig)
  self.tabIndex = index
  if self.tabIndex == 1 then
    self:RefreshReward(self.rewardParam)
    self.compRewardContent:SetActive(true)
    self.compStatisticContent:SetActive(false)
  else
    self.compRewardContent:SetActive(false)
    self.compStatisticContent:SetActive(true)
    local newItemConfigs = tabItemConfig and tabItemConfig.itemConfigs or {}
    if not self.itemConfigs or #self.itemConfigs ~= #newItemConfigs then
      self.itemConfigs = newItemConfigs
      self.loopListView2StatisticScroll:SetListItemCount(#self.itemConfigs, true, false)
    else
      self.itemConfigs = newItemConfigs
      self.loopListView2StatisticScroll:RefreshAllShownItem()
    end
  end
  self.firstShowDelayAnim = true
  self:TabSwitchFadeIn()
end

function UIBattleResultJeepAdventureVictoryView:TabSwitchFadeIn()
  if not IsNull(self.fadeTween) then
    self.fadeTween:Kill()
    self.fadeTween = nil
  end
  if self.tabIndex == 1 then
    self.fadeInCanvasGroup = self.canvasGroupRewardContent
  else
    self.fadeInCanvasGroup = self.canvasGroupStatisticContent
  end
  self.fadeInCanvasGroup:SetAlpha(0)
  self.fadeTween = CS.DG.Tweening.DOTween.To(function()
    return self.fadeInCanvasGroup:GetAlpha()
  end, function(value)
    self.fadeInCanvasGroup:SetAlpha(value)
  end, 1, 0.5):SetEase(CS.DG.Tweening.Ease.Linear)
end

function UIBattleResultJeepAdventureVictoryView:ConfigMakeDamageTab()
  self.tabDamageMakeItemCfg.itemConfigs = self:GetBattleStatisticDatas(BattleResultStatisticUtils.STATISTIC_FILED_DAMAGE)
end

function UIBattleResultJeepAdventureVictoryView:ConfigDamageTakenTab()
  self.tabDamageTakenItemCfg.itemConfigs = self:GetBattleStatisticDatas(BattleResultStatisticUtils.STATISTIC_FILED_DAMAGE_TAKEN)
end

function UIBattleResultJeepAdventureVictoryView:GetBattleStatisticDatas(fieldName)
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

function UIBattleResultJeepAdventureVictoryView:TryGetScrollItem(listview, index)
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
    item = self.compStatisticContent:AddComponent(data.cmp, itemName)
    self.items[csItem] = item
  end
  if item ~= nil then
    self.items[csItem]:ReInit(data)
    if not firstCreate then
      self.statisticAnimStyle:StopItemDelayActiveTimer(itemName, item)
    elseif not self.firstShowDelayAnim then
      self.statisticAnimStyle:AddItemNewDelayActiveTimer(itemName, item)
    end
  end
  return csItem
end

function UIBattleResultJeepAdventureVictoryView:OnGetReward(param)
  param = DataCenter.RewardManager:ReturnRewardParamForMessage(param)
  if param == nil then
    return
  end
  self.rewardParam = param
  if self.tabIndex and self.tabIndex == 1 then
    self:RefreshReward(self.rewardParam)
  end
end

function UIBattleResultJeepAdventureVictoryView:DataDestroy()
  if self.EscTimer then
    self.EscTimer:Stop()
    self.EscTimer = nil
  end
  if self.aniTimer then
    self.aniTimer:Stop()
    self.aniTimer = nil
    self.interactableBtns = false
  end
  if not IsNull(self.fadeTween) then
    self.fadeTween:Kill()
    self.fadeTween = nil
  end
  self.firstShowDelayAnim = false
  self.rewardAnimStyle:Delete()
  self.rewardAnimStyle = nil
  self.statisticAnimStyle:Delete()
  self.statisticAnimStyle = nil
  self.loopListView2StatisticScroll:ClearAllItems()
  self.itemConfigs = nil
  self.items = {}
  self.prefabIndex = nil
  self.statisticItemsCfgs = nil
  self:DeleteTimer()
  self:ClearRewardScroll()
  self.cfgId = nil
  self.pageType = nil
  self.battleManagerParam = nil
  self.rewardParam = nil
  self.tabItemConfigs = nil
  self.tabIndex = nil
  self.fadeInCanvasGroup = nil
  self.tabRewardItemCfg = nil
  self.tabDamageMakeItemCfg = nil
  self.tabDamageTakenItemCfg = nil
end

function UIBattleResultJeepAdventureVictoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.TowerupBattleReward, self.OnGetReward)
  self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
end

function UIBattleResultJeepAdventureVictoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.TowerupBattleReward, self.OnGetReward)
  self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  base.OnRemoveListener(self)
end

function UIBattleResultJeepAdventureVictoryView:OnKeyCodeEscape()
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

function UIBattleResultJeepAdventureVictoryView:OnBtnNextClick()
  if not self.interactableBtns then
    return
  end
  if self.cfgId > 0 and self.pageType then
    local curId = DataCenter.LWJeepAdventureManager:GetCurStageIdByType(self.pageType)
    if curId ~= self.cfgId then
      local targetStageMeta = DataCenter.LWJeepAdventureManager:GetStageMetaByType(self.cfgId, self.pageType)
      if targetStageMeta then
        if targetStageMeta.type == TowerupBattleType.Zombie or targetStageMeta.type == TowerupBattleType.Parkour then
          UIUtil.ShowTipsId("towerup_001")
        else
          local serverMsg = self.battleManagerParam.extraData.serverMsg
          local isWin = -1
          local id = -1
          if serverMsg ~= nil then
            isWin = serverMsg.isWin
            id = serverMsg.id
          end
          Logger.LogError("TowerupBattleWinView curId and self.cfgId is diff " .. "curId:" .. tostring(curId) .. "self.cfgId:" .. tostring(self.cfgId) .. "isWin:" .. tostring(isWin) .. "id:" .. tostring(id))
        end
      else
        Logger.LogError("TowerupBattleWinView curId and self.cfgId is diff " .. "curId:" .. tostring(curId) .. "self.cfgId:" .. tostring(self.cfgId) .. " targetStageMeta is nil")
      end
      return
    end
    DataCenter.LWJeepAdventureManager:EnterBattle(curId + 1, self.pageType)
  end
end

function UIBattleResultJeepAdventureVictoryView:OnBtnReturnClick()
  if not self.interactableBtns then
    return
  end
  local battleManagerParam = self:GetUserData()
  DataCenter.TowerUpSaveDataManager:SetAutoNextStage(false)
  if battleManagerParam.type == PVEType.FakePVP or battleManagerParam.type == PVEType.Parkour then
    DataCenter.LWBattleManager:SetBattleExitFlag(true)
    DataCenter.LWBattleManager:Exit(function()
      if self.ctrl then
        self.ctrl:CloseSelf()
      end
    end)
  elseif battleManagerParam.type == PVEType.Barrage then
    DataCenter.ZombieBattleManager:SetBattleExitFlag(true)
    DataCenter.ZombieBattleManager:Exit(function()
      if self.ctrl then
        self.ctrl:CloseSelf()
      end
    end, LWStageType.TowerupAdvanture)
  end
end

function UIBattleResultJeepAdventureVictoryView:RefreshReward(data)
  self.rewardDatalist = data or {}
  self.scrollViewScroll:SetTotalCount(#self.rewardDatalist)
  if #self.rewardDatalist then
    self.scrollViewScroll:RefillCells()
  end
end

function UIBattleResultJeepAdventureVictoryView:OnRewardItemMoveIn(itemObj, index)
  local itemName = itemObj.name
  local item = self.rewardScrollCellPool[itemName]
  local firstCreate = false
  if not item then
    firstCreate = true
    itemName = tostring(self.rewardItemIndex)
    itemObj.name = itemName
    item = self.compRewardContent:AddComponent(UICommonResItem, itemObj)
    self.rewardScrollCellPool[itemName] = item
    self.rewardItemIndex = self.rewardItemIndex + 1
  end
  local data = self.rewardDatalist[index]
  item:ReInit(data)
  if not firstCreate then
    self.rewardAnimStyle:StopItemDelayActiveTimer(itemName, item)
  elseif not self.firstShowDelayAnim then
    self.rewardAnimStyle:AddItemNewDelayActiveTimer(itemName, item)
  end
  if data.rewardType == RewardType.RESOURCE then
    local name = DataCenter.ResourceManager:GetResourceNameByType(data.itemId)
    item:SetNameText(name)
  end
  self.rewardFlyReward[itemObj.transform] = data
end

function UIBattleResultJeepAdventureVictoryView:OnRewardItemMoveOut(itemObj, index)
  self.rewardFlyReward[itemObj.transform] = nil
end

function UIBattleResultJeepAdventureVictoryView:ClearRewardScroll()
  self.scrollViewScroll:ClearCells()
  self.rewardScrollCellPool = nil
  self.rewardItemIndex = nil
  self.rewardFlyReward = nil
  self.rewardDatalist = nil
end

function UIBattleResultJeepAdventureVictoryView:OnToggerChangeFunc(state)
  if not self.battleManagerParam then
    return
  end
  if self.pageType == JeepAdventurePageType.Domintor then
    if state then
      local isCanAuto = DataCenter.TowerUpSaveDataManager:IsCanAutoNextStageDominator()
      if not isCanAuto then
        UIUtil.ShowTipsId("dominator_pve_dec_10")
        self.toggleBack:SetIsOn(false)
        return
      else
        DataCenter.TowerUpSaveDataManager:SetAutoNextStage(true)
        self.autoNextStageStartTime = UITimeManager:GetInstance():GetServerTime()
      end
    else
      DataCenter.TowerUpSaveDataManager:SetAutoNextStage(false)
      self.autoNextStageStartTime = -1
    end
  else
    local isNext = DataCenter.TowerUpSaveDataManager:IsAutoNextStage()
    if isNext ~= state then
      DataCenter.TowerUpSaveDataManager:SetAutoNextStage(state)
      isNext = state
      if isNext then
        self.autoNextStageStartTime = UITimeManager:GetInstance():GetServerTime()
      else
        self.autoNextStageStartTime = -1
      end
    end
  end
end

function UIBattleResultJeepAdventureVictoryView:RefreshAutoNextStageToggerView()
  self.toggleBack:SetActive(true)
  if self.pageType == JeepAdventurePageType.Domintor then
    local isNext = DataCenter.TowerUpSaveDataManager:IsAutoNextStage()
    if not isNext then
      self.toggleBack:SetIsOn(false)
      self.autoNextStageStartTime = -1
    else
      local isCanAuto = DataCenter.TowerUpSaveDataManager:IsCanAutoNextStageDominator()
      if not isCanAuto then
        DataCenter.TowerUpSaveDataManager:SetAutoNextStage(false)
        self.toggleBack:SetIsOn(false)
        self.autoNextStageStartTime = -1
      else
        self.toggleBack:SetIsOn(true)
        self.autoNextStageStartTime = UITimeManager:GetInstance():GetServerTime()
      end
    end
  else
    local isNext = DataCenter.TowerUpSaveDataManager:IsAutoNextStage()
    self.toggleBack:SetIsOn(isNext)
    if isNext then
      self.autoNextStageStartTime = UITimeManager:GetInstance():GetServerTime()
    else
      self.autoNextStageStartTime = -1
    end
  end
end

function UIBattleResultJeepAdventureVictoryView:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(0.5, self.CheckAutoNext, self, false, false, false)
  end
  self.timer:Start()
end

function UIBattleResultJeepAdventureVictoryView:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIBattleResultJeepAdventureVictoryView:CheckAutoNext()
  if self.autoNextStageStartTime == nil or self.autoNextStageStartTime <= 0 then
    self.textTxtNext:SetLocalText("456809")
    return
  else
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime > self.autoNextStageStartTime + autoWaitTime then
      self:OnBtnNextClick()
      self.autoNextStageStartTime = -1
    else
      local btnStr = Localization:GetString("456809")
      local showTime = math.floor((self.autoNextStageStartTime + autoWaitTime - curTime) / 1000)
      local btnTimeStr = btnStr .. string.format(" (%s)", showTime)
      self.textTxtNext:SetText(btnTimeStr)
    end
  end
end

return UIBattleResultJeepAdventureVictoryView
