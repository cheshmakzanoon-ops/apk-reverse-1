local UIBattleResultFrontBreakSundayDefeatView = BaseClass("UIBattleResultFrontBreakSundayDefeatView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CommonResultInfoList = require("UI.UIBattleResultComponents.CommonResultInfoListComponent")
local BattleResultAnimStyle = require("UI.UIBattleResultUtils.BattleResultAnimStyle")

function UIBattleResultFrontBreakSundayDefeatView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIBattleResultFrontBreakSundayDefeatView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBattleResultFrontBreakSundayDefeatView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTxtTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTxtStage = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.loopListView2Scroll = self.viewSkin:AddComponent(self, UILoopListView2, 3)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.btnTryAgain = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnTryAgain:SetOnClick(function()
    self:OnBtnTryAgainClick()
  end)
  self.textTxtTryAgain = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.btnReturn = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnReturn:SetOnClick(function()
    self:OnBtnReturnClick()
  end)
  self.btnShare = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnShare:SetOnClick(function()
    self:OnBtnShareClick()
  end)
  self.textRankCriteriaLabel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textCriteriaStageLabel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textCriteriaRemainSolider = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.animatorUIBattleResultFrontBreakSundayDefeat = self.viewSkin:AddComponent(self, UIAnimator, 12)
  self.loopListView2Scroll:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
  self.textTxtTitle:SetLocalText("311106")
  self.textTxtTryAgain:SetLocalText("134021")
  self.textRankCriteriaLabel:SetLocalText("activity_breakthrough_tips_38")
end

function UIBattleResultFrontBreakSundayDefeatView:ComponentDestroy()
  self.viewSkin = nil
  self.textTxtTitle = nil
  self.textTxtStage = nil
  self.loopListView2Scroll = nil
  self.compContent = nil
  self.btnTryAgain = nil
  self.textTxtTryAgain = nil
  self.btnReturn = nil
  self.btnShare = nil
  self.textRankCriteriaLabel = nil
  self.textCriteriaStageLabel = nil
  self.textCriteriaRemainSolider = nil
  self.animatorUIBattleResultFrontBreakSundayDefeat = nil
end

function UIBattleResultFrontBreakSundayDefeatView:DataDefine()
  self.topRankCfgItem = {
    cmp = CommonResultInfoList,
    prefabName = "CommonResultInfoList",
    icon = "Assets/Main/Sprites/UI/UIActivityFrontBreakSunday/zyf_jiesuan_paiming_icon1.png",
    name = Localization:GetString("activity_breakthrough_tips_37"),
    valueStr = ""
  }
  self.alRankCfgItem = {
    cmp = CommonResultInfoList,
    prefabName = "CommonResultInfoList",
    icon = "Assets/Main/Sprites/UI/UIActivityFrontBreakSunday/zyf_jiesuan_paiming_icon2.png",
    name = Localization:GetString("activity_breakthrough_tips_13"),
    valueStr = ""
  }
  self.severRankCfgItem = {
    cmp = CommonResultInfoList,
    prefabName = "CommonResultInfoList",
    icon = "Assets/Main/Sprites/UI/UIActivityFrontBreakSunday/zyf_jiesuan_paiming_icon2.png",
    name = Localization:GetString("activity_breakthrough_tips_14"),
    valueStr = ""
  }
  self.totalRemainItemCfg = {
    cmp = CommonResultInfoList,
    prefabName = "CommonResultInfoList",
    icon = "Assets/Main/Sprites/UI/UIActivityFrontBreakSunday/zyf_jiesuan_xiaolanbing_icon3.png",
    name = Localization:GetString("activity_breakthrough_tips_25"),
    valueStr = ""
  }
  self.items = {}
  self.battleResultAnimStyle = BattleResultAnimStyle.New()
  self.firstShowDelayAnim = false
  local hasAni, animTime = self.animatorUIBattleResultFrontBreakSundayDefeat:GetAnimationReturnTime("CommonPopup_movein")
  if hasAni and 0 < animTime then
    self.interactableBtns = false
    self.aniTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.interactableBtns = true
    end, animTime)
  else
    self.interactableBtns = true
  end
end

function UIBattleResultFrontBreakSundayDefeatView:DataDestroy()
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
  self.items = {}
  self.prefabIndex = nil
  self.itemConfigs = nil
  self.topRankCfgItem = nil
  self.alRankCfgItem = nil
  self.severRankCfgItem = nil
  self.totalRemainItemCfg = nil
end

function UIBattleResultFrontBreakSundayDefeatView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
end

function UIBattleResultFrontBreakSundayDefeatView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  base.OnRemoveListener(self)
end

function UIBattleResultFrontBreakSundayDefeatView:RefreshView()
  local param = self:GetUserData()
  local stageId = param.stageId
  local stageIdIndex = DataCenter.ActFrontBreakSundayDataManager:GetActData(param.frontBreakSundayActId):GetStageIndex(stageId) or 0
  local stagesCount = #DataCenter.ActFrontBreakSundayDataManager:GetActData(param.frontBreakSundayActId).stageIds
  local levelTitle = Localization:GetString("activity_breakthrough_tips_19", stageIdIndex, stagesCount)
  self.textTxtStage:SetText(levelTitle)
  self.btnShare:SetActive(1 < stageIdIndex)
  self.itemConfigs = {}
  local topRankOld = param.topRankOld or 0
  local topRankNew = param.topRankNew or 0
  if 0 < topRankNew and (topRankOld == 0 or topRankOld > topRankNew) then
    self.topRankCfgItem.valueStr = topRankOld == 0 and Localization:GetString("activity_breakthrough_tips_16") or string.format("%d", topRankOld)
    self.topRankCfgItem.valueStrNew = string.format("%d", topRankNew)
    table.insert(self.itemConfigs, self.topRankCfgItem)
  end
  local alRankOld = param.alRankOld or 0
  local alRankNew = param.alRankNew or 0
  local isInAlliance = LuaEntry.Player:IsInAlliance()
  if isInAlliance and 0 < alRankNew and (alRankOld == 0 or alRankOld > alRankNew) then
    self.alRankCfgItem.valueStr = alRankOld == 0 and Localization:GetString("activity_breakthrough_tips_16") or string.format("%d", alRankOld)
    self.alRankCfgItem.valueStrNew = string.format("%d", alRankNew)
    table.insert(self.itemConfigs, self.alRankCfgItem)
  end
  local serRankOld = param.serRankOld or 0
  local serRankNew = param.serRankNew or 0
  if 0 < serRankNew and (serRankOld == 0 or serRankOld > serRankNew) then
    self.severRankCfgItem.valueStr = serRankOld == 0 and Localization:GetString("activity_breakthrough_tips_16") or string.format("%d", serRankOld)
    self.severRankCfgItem.valueStrNew = string.format("%d", serRankNew)
    table.insert(self.itemConfigs, self.severRankCfgItem)
  end
  table.insert(self.itemConfigs, self.totalRemainItemCfg)
  self.totalRemainItemCfg.valueStr = string.format("x%d", param.totalLeft or 0)
  local newRecord = param.newRecord and true or false
  if newRecord then
    self.totalRemainItemCfg.tipStr = Localization:GetString("activity_breakthrough_tips_30")
  else
    self.totalRemainItemCfg.tipStr = nil
  end
  local criteriaStage = DataCenter.ActFrontBreakSundayDataManager:GetTopRankCriteriaStage(param.frontBreakSundayActId)
  self.textCriteriaStageLabel:SetLocalText("activity_breakthrough_tips_15", criteriaStage)
  local criteriaRemainSolider = DataCenter.ActFrontBreakSundayDataManager:GetTopRankCriteriaRemainSolider(param.frontBreakSundayActId)
  self.textCriteriaRemainSolider:SetText(string.format("x%d", criteriaRemainSolider))
  self.loopListView2Scroll:SetListItemCount(#self.itemConfigs, false, false)
  self.firstShowDelayAnim = true
end

function UIBattleResultFrontBreakSundayDefeatView:TryGetScrollItem(listview, index)
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

function UIBattleResultFrontBreakSundayDefeatView:OnBtnTryAgainClick()
  if not self.interactableBtns then
    return
  end
  self.ctrl:CloseSelf()
  local battleLogic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if not battleLogic then
    return
  end
  DataCenter.LWBattleManager:GetCurBattleLogic():NoticeLose()
  local param = self:GetUserData()
  DataCenter.LWBattleManager:Destroy()
  local actId = param.frontBreakSundayActId
  local stageId = DataCenter.ActFrontBreakSundayDataManager:GetNextStageId(actId)
  DataCenter.ActFrontBreakSundayDataManager:RequestToEnterStage(stageId)
end

function UIBattleResultFrontBreakSundayDefeatView:OnBtnReturnClick()
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
  local param = self:GetUserData()
  DataCenter.LWBattleManager:SetBattleExitStartTime(BattleExitTimeLogType.ActFrontBreakSunday)
  local preLoadAssets = {
    [UIAssets.ActivityTabGroupItem] = true,
    [UIAssets.UIActivityListItem] = true,
    [UIAssets.FrontBreakSunday] = true
  }
  if param.totalLeft and param.totalLeft > 0 then
    DataCenter.ActFrontBreakSundayDataManager:SetNeedPlaySoliderFlyAnim(true)
  end
  GoToUtil.GotoOpenView_BattleReturnOpt(UIWindowNames.UIActivityCenterTable, preLoadAssets, param.frontBreakSundayActId, preLoadAssets)
  DataCenter.LWBattleManager:GetCurBattleLogic():NoticeLose()
  DataCenter.LWBattleManager:Exit(nil, "lose")
end

function UIBattleResultFrontBreakSundayDefeatView:OnBtnShareClick()
  if not self.interactableBtns then
    return
  end
  local stage_share_time = CommonUtil.PlayerPrefsGetLong(SettingKeys.STAGE_FEATURE_SHARE_TIME, 0)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaMinTime = LuaEntry.DataConfig:TryGetNum("Breakthrough_config", "k3", 0) * 1000
  if curTime <= stage_share_time + deltaMinTime then
    UIUtil.ShowTips(Localization:GetString("breakthough_tips_03"))
    return
  end
  local param = self:GetUserData()
  local shareParam = {}
  shareParam.param = {}
  local stageId = param.stageId or 0
  shareParam.param.stageId = stageId
  shareParam.post = PostType.FrontBreakSunday
  shareParam.param.fromActFrontBreakSunday = true
  shareParam.param.win = false
  shareParam.param.totalLeft = param.totalLeft or 0
  shareParam.param.frontBreakSundayActId = param.frontBreakSundayActId
  shareParam.param.ActFrontBreakTopRankOld = param.topRankOld or 0
  shareParam.param.ActFrontBreakTopRankNew = param.topRankNew or 0
  shareParam.param.ActFrontBreakAlRankOld = param.alRankOld or 0
  shareParam.param.ActFrontBreakAlRankNew = param.alRankNew or 0
  shareParam.param.ActFrontBreakSerRankOld = param.serRankOld or 0
  shareParam.param.ActFrontBreakSerRankNew = param.serRankNew or 0
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, shareParam)
end

function UIBattleResultFrontBreakSundayDefeatView:OnKeyCodeEscape()
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

return UIBattleResultFrontBreakSundayDefeatView
