local UIBattleResultFrontBreakSundayVictoryView = BaseClass("UIBattleResultFrontBreakSundayVictoryView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CommonResultInfoList = require("UI.UIBattleResultComponents.CommonResultInfoListComponent")
local BattleResultAnimStyle = require("UI.UIBattleResultUtils.BattleResultAnimStyle")

function UIBattleResultFrontBreakSundayVictoryView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIBattleResultFrontBreakSundayVictoryView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBattleResultFrontBreakSundayVictoryView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTxtTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTxtStage = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.loopListView2Scroll = self.viewSkin:AddComponent(self, UILoopListView2, 3)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.btnReturn = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnReturn:SetOnClick(function()
    self:OnBtnReturnClick()
  end)
  self.textTxtReturn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textRankCriteriaLabel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textCriteriaStageLabel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textCriteriaRemainSolider = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textTxtSoldierNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.btnShare = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnShare:SetOnClick(function()
    self:OnBtnShareClick()
  end)
  self.btnNext = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnNext:SetOnClick(function()
    self:OnBtnNextClick()
  end)
  self.textTxtNext = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.animatorUIBattleResultFrontBreakSundayVictory = self.viewSkin:AddComponent(self, UIAnimator, 14)
  self.loopListView2Scroll:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
  self.textTxtTitle:SetLocalText("311105")
  self.textTxtNext:SetLocalText("activity_breakthrough_tips_27")
  self.textTxtReturn:SetLocalText("800306")
  self.textRankCriteriaLabel:SetLocalText("activity_breakthrough_tips_38")
end

function UIBattleResultFrontBreakSundayVictoryView:ComponentDestroy()
  self.viewSkin = nil
  self.textTxtTitle = nil
  self.textTxtStage = nil
  self.loopListView2Scroll = nil
  self.compContent = nil
  self.btnReturn = nil
  self.textTxtReturn = nil
  self.textRankCriteriaLabel = nil
  self.textCriteriaStageLabel = nil
  self.textCriteriaRemainSolider = nil
  self.textTxtSoldierNum = nil
  self.btnShare = nil
  self.btnNext = nil
  self.textTxtNext = nil
  self.animatorUIBattleResultFrontBreakSundayVictory = nil
end

function UIBattleResultFrontBreakSundayVictoryView:DataDefine()
  self.soliderItemCfg = {
    cmp = CommonResultInfoList,
    prefabName = "CommonResultInfoList",
    icon = "Assets/Main/Sprites/UI/UIActivityFrontBreakSunday/zyf_jiesuan_xiaolanbing_icon3.png",
    name = Localization:GetString("activity_breakthrough_tips_25"),
    valueStr = ""
  }
  self.items = {}
  self.battleResultAnimStyle = BattleResultAnimStyle.New()
  self.firstShowDelayAnim = false
  local hasAni, animTime = self.animatorUIBattleResultFrontBreakSundayVictory:GetAnimationReturnTime("CommonPopup_movein")
  if hasAni and 0 < animTime then
    self.interactableBtns = false
    self.aniTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.interactableBtns = true
    end, animTime)
  else
    self.interactableBtns = true
  end
end

function UIBattleResultFrontBreakSundayVictoryView:RefreshView()
  local param = self:GetUserData()
  local stageId = param.stageId
  local stageIdIndex = DataCenter.ActFrontBreakSundayDataManager:GetActData(param.frontBreakSundayActId):GetStageIndex(stageId)
  local stagesCount = #DataCenter.ActFrontBreakSundayDataManager:GetActData(param.frontBreakSundayActId).stageIds
  local levelTitle = Localization:GetString("activity_breakthrough_tips_19", stageIdIndex, stagesCount)
  self.textTxtStage:SetText(levelTitle)
  if self.scoreTween then
    self.scoreTween:Kill()
  end
  self.tempScore = 0
  self.textTxtSoldierNum:SetText("X 0")
  self.scoreTween = CS.DG.Tweening.DOTween.To(function()
    return self.tempScore
  end, function(value)
    self.tempScore = value
    self.textTxtSoldierNum:SetText("X " .. math.floor(value))
  end, param.curLeft, 1):SetEase(CS.DG.Tweening.Ease.OutQuad):SetDelay(0.5):OnComplete(function()
    self.textTxtSoldierNum:SetText("X " .. param.curLeft)
  end)
  local criteriaStage = DataCenter.ActFrontBreakSundayDataManager:GetTopRankCriteriaStage(param.frontBreakSundayActId)
  self.textCriteriaStageLabel:SetLocalText("activity_breakthrough_tips_15", criteriaStage)
  local criteriaRemainSolider = DataCenter.ActFrontBreakSundayDataManager:GetTopRankCriteriaRemainSolider(param.frontBreakSundayActId)
  self.textCriteriaRemainSolider:SetText(string.format("x%d", criteriaRemainSolider))
  self.itemConfigs = {}
  table.insert(self.itemConfigs, self.soliderItemCfg)
  self.soliderItemCfg.valueStr = string.format("x%d", param.totalLeft or 0)
  self.loopListView2Scroll:SetListItemCount(#self.itemConfigs, false, false)
  self.firstShowDelayAnim = true
  self.btnNext:SetActive(stageIdIndex < stagesCount)
  self.btnShare:SetActive(stageIdIndex == stagesCount)
  DataCenter.LWSoundManager:PlaySound(10027)
end

function UIBattleResultFrontBreakSundayVictoryView:DataDestroy()
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
  if self.scoreTween then
    self.scoreTween:Kill()
  end
  self.scoreTween = nil
  self.loopListView2Scroll:ClearAllItems()
  self.items = {}
  self.prefabIndex = nil
  self.itemConfigs = nil
end

function UIBattleResultFrontBreakSundayVictoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
end

function UIBattleResultFrontBreakSundayVictoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  base.OnRemoveListener(self)
end

function UIBattleResultFrontBreakSundayVictoryView:OnBtnReturnClick()
  if not self.interactableBtns then
    return
  end
  self.ctrl:CloseSelf()
  local userdata = self:GetUserData()
  DataCenter.LWBattleManager:Exit(nil, "win")
  DataCenter.LWBattleManager:SetBattleExitStartTime(BattleExitTimeLogType.ActFrontBreakSunday)
  local preLoadAssets = {
    [UIAssets.ActivityTabGroupItem] = true,
    [UIAssets.UIActivityListItem] = true,
    [UIAssets.FrontBreakSunday] = true
  }
  DataCenter.ActFrontBreakSundayDataManager:SetNeedPlaySoliderFlyAnim(true)
  GoToUtil.GotoOpenView_BattleReturnOpt(UIWindowNames.UIActivityCenterTable, preLoadAssets, userdata.frontBreakSundayActId, preLoadAssets)
end

function UIBattleResultFrontBreakSundayVictoryView:OnBtnShareClick()
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
  shareParam.post = PostType.FrontBreakSunday
  shareParam.param.stageId = stageId
  shareParam.param.fromActFrontBreakSunday = true
  shareParam.param.win = true
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

function UIBattleResultFrontBreakSundayVictoryView:OnBtnNextClick()
  if not self.interactableBtns then
    return
  end
  local userdata = self:GetUserData()
  local stageIdIndex = DataCenter.ActFrontBreakSundayDataManager:GetActData(userdata.frontBreakSundayActId):GetStageIndex(userdata.stageId)
  if stageIdIndex then
    self.ctrl:CloseSelf()
    DataCenter.LWBattleManager:Destroy()
    local stages = DataCenter.ActFrontBreakSundayDataManager:GetActData(userdata.frontBreakSundayActId).stageIds
    local nextStageId = stages[math.min(stageIdIndex + 1, #stages)]
    DataCenter.ActFrontBreakSundayDataManager:RequestToEnterStage(nextStageId)
  end
end

function UIBattleResultFrontBreakSundayVictoryView:TryGetScrollItem(listview, index)
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

function UIBattleResultFrontBreakSundayVictoryView:OnKeyCodeEscape()
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

return UIBattleResultFrontBreakSundayVictoryView
