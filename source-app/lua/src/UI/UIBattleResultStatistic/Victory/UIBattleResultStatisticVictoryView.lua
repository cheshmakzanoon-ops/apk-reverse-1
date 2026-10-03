local UIBattleResultStatisticVictoryView = BaseClass("UIBattleResultStatisticVictoryView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CommonResultTabComponent = require("UI.UIBattleResultComponents.CommonResultTabComponent")
local BattleResultStatisticUtils = require("UI.UIBattleResultUtils.BattleResultStatisticUtils")
local BattleResultAnimStyle = require("UI.UIBattleResultUtils.BattleResultAnimStyle")

function UIBattleResultStatisticVictoryView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIBattleResultStatisticVictoryView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBattleResultStatisticVictoryView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTxtTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTxtStage = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnReturn = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnReturn:SetOnClick(function()
    self:OnBtnReturnClick()
  end)
  self.textTxtReturn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.loopListView2Scroll = self.viewSkin:AddComponent(self, UILoopListView2, 5)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.compTab = self.viewSkin:AddComponent(self, CommonResultTabComponent, 7)
  self.canvasGroupContent = self.viewSkin:AddComponent(self, UICanvasGroup, 8)
  self.animatorUIBattleResultStatisticVictory = self.viewSkin:AddComponent(self, UIAnimator, 9)
  self.loopListView2Scroll:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
  self.textTxtTitle:SetText(Localization:GetString("311105"))
  self.textTxtReturn:SetText(Localization:GetString("800306"))
end

function UIBattleResultStatisticVictoryView:ComponentDestroy()
  self.viewSkin = nil
  self.textTxtTitle = nil
  self.textTxtStage = nil
  self.btnReturn = nil
  self.textTxtReturn = nil
  self.loopListView2Scroll = nil
  self.compContent = nil
  self.compTab = nil
  self.canvasGroupContent = nil
  self.animatorUIBattleResultStatisticVictory = nil
end

function UIBattleResultStatisticVictoryView:DataDefine()
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
    self.tabDamageMakeItemCfg,
    self.tabDamageTakenItemCfg
  }
  self.battleResultAnimStyle = BattleResultAnimStyle.New()
  self.firstShowDelayAnim = false
  local hasAni, animTime = self.animatorUIBattleResultStatisticVictory:GetAnimationReturnTime("CommonPopup_movein")
  if hasAni and 0 < animTime then
    self.interactableBtns = false
    self.aniTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.interactableBtns = true
    end, animTime)
  else
    self.interactableBtns = true
  end
end

function UIBattleResultStatisticVictoryView:DataDestroy()
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
  self.loopListView2Scroll:ClearAllItems()
  if not IsNull(self.fadeTween) then
    self.fadeTween:Kill()
    self.fadeTween = nil
  end
  self.itemConfigs = nil
  self.items = {}
  self.prefabIndex = nil
  self.statisticItemsCfgs = nil
  self.tabItemConfigs = nil
  self.firstShowDelayAnim = false
  self.tabDamageMakeItemCfg = nil
  self.tabDamageTakenItemCfg = nil
end

function UIBattleResultStatisticVictoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
end

function UIBattleResultStatisticVictoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  base.OnRemoveListener(self)
end

function UIBattleResultStatisticVictoryView:RefreshView()
  DataCenter.LWSoundManager:PlaySound(10027)
  local param = self:GetUserData()
  local stageId = param.stageId
  local levelTitlePrefixKey = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), stageId, "name")
  local order = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), stageId, "order")
  self.textTxtStage:SetLocalText(levelTitlePrefixKey, order)
  self.compTab:SetActive(true)
  self.loopListView2Scroll:SetActive(true)
  self:ReInitTabCfgs()
end

function UIBattleResultStatisticVictoryView:ReInitTabCfgs()
  self:ConfigMakeDamageTab()
  self:ConfigDamageTakenTab()
  self.compTab:ReInit(self.tabItemConfigs, function(index, data)
    self:OnTabItemClick(index, data)
  end)
end

function UIBattleResultStatisticVictoryView:ConfigMakeDamageTab()
  self.tabDamageMakeItemCfg.itemConfigs = self:GetBattleStatisticDatas(BattleResultStatisticUtils.STATISTIC_FILED_DAMAGE)
end

function UIBattleResultStatisticVictoryView:ConfigDamageTakenTab()
  self.tabDamageTakenItemCfg.itemConfigs = self:GetBattleStatisticDatas(BattleResultStatisticUtils.STATISTIC_FILED_DAMAGE_TAKEN)
end

function UIBattleResultStatisticVictoryView:GetBattleStatisticDatas(fieldName)
  if self.statisticItemsCfgs[fieldName] then
    return self.statisticItemsCfgs[fieldName]
  end
  local statisticItemsCfg = BattleResultStatisticUtils.GetParkourStatisticCfgs(fieldName)
  self.statisticItemsCfgs[fieldName] = statisticItemsCfg
  return statisticItemsCfg
end

function UIBattleResultStatisticVictoryView:OnTabItemClick(index, tabItemConfig)
  self:RefreshTabContent(index, tabItemConfig)
end

function UIBattleResultStatisticVictoryView:RefreshTabContent(index, tabItemConfig)
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

function UIBattleResultStatisticVictoryView:TabSwitchFadeIn()
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

function UIBattleResultStatisticVictoryView:OnBtnReturnClick()
  if not self.interactableBtns then
    return
  end
  self.ctrl:CloseSelf()
  DataCenter.LWBattleManager:Exit(nil, "win")
end

function UIBattleResultStatisticVictoryView:OnKeyCodeEscape()
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

function UIBattleResultStatisticVictoryView:TryGetScrollItem(listview, index)
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
    item:ReInit(data)
    if not firstCreate then
      self.battleResultAnimStyle:StopItemDelayActiveTimer(itemName, item)
    elseif not self.firstShowDelayAnim then
      self.battleResultAnimStyle:AddItemNewDelayActiveTimer(itemName, item)
    end
  end
  return csItem
end

return UIBattleResultStatisticVictoryView
