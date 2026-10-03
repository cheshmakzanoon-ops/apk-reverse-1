local UIFrontBreakOutSundayNewRecordView = BaseClass("UIFrontBreakOutSundayNewRecordView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIFrontBreakOutSundayNewRecordView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIFrontBreakOutSundayNewRecordView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIFrontBreakOutSundayNewRecordView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textLevelName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compNewRecord = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.textTopRankTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textTopRankOld = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textTopRankNew = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textServerRankTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textServerRankOld = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textServerRankNew = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.compTopRank = self.viewSkin:AddComponent(self, UIBaseContainer, 11)
  self.compServerRank = self.viewSkin:AddComponent(self, UIBaseContainer, 12)
  self.compALRank = self.viewSkin:AddComponent(self, UIBaseContainer, 13)
  self.textALRankTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.textALRankOld = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.textALRankNew = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.textLevelRemainTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 17)
  self.textLevelRemainNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.textTotalRemainTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.textTotalRemainNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 20)
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 21)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.btnShare = self.viewSkin:AddComponent(self, UIButton, 22)
  self.btnShare:SetOnClick(function()
    self:OnBtnShareClick()
  end)
  self.textRemainDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 23)
  self.textRemainNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 24)
  self.textTopRankNeedStage = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 25)
  self.textBtnBack = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 26)
  self.textUpNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 27)
  self.textRecordTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 28)
  self.animatorRecord = self.viewSkin:AddComponent(self, UIAnimator, 29)
  self.textTopRankTitle:SetLocalText("activity_breakthrough_tips_37")
  self.textServerRankTitle:SetLocalText("activity_breakthrough_tips_14")
  self.textALRankTitle:SetLocalText("activity_breakthrough_tips_13")
  self.textLevelRemainTitle:SetLocalText("activity_breakthrough_tips_24")
  self.textTotalRemainTitle:SetLocalText("activity_breakthrough_tips_25")
  self.textRemainDes:SetLocalText("activity_breakthrough_tips_38")
  self.textRecordTitle:SetLocalText("activity_breakthrough_tips_30")
  self.textBtnBack:SetLocalText(800306)
  self.textTitle:SetLocalText("frontline_weekend_title_01")
  self.compNewRecord:SetActive(false)
end

function UIFrontBreakOutSundayNewRecordView:ComponentDestroy()
  self:KillTween()
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  self.viewSkin = nil
  self.btnPanel = nil
  self.textLevelName = nil
  self.textTitle = nil
  self.compNewRecord = nil
  self.textTopRankTitle = nil
  self.textTopRankOld = nil
  self.textTopRankNew = nil
  self.textServerRankTitle = nil
  self.textServerRankOld = nil
  self.textServerRankNew = nil
  self.compTopRank = nil
  self.compServerRank = nil
  self.compALRank = nil
  self.textALRankTitle = nil
  self.textALRankOld = nil
  self.textALRankNew = nil
  self.textLevelRemainTitle = nil
  self.textLevelRemainNum = nil
  self.textTotalRemainTitle = nil
  self.textTotalRemainNum = nil
  self.btnBack = nil
  self.btnShare = nil
  self.textRemainDes = nil
  self.textRemainNum = nil
  self.textTopRankNeedStage = nil
  self.textBtnBack = nil
  self.textUpNum = nil
  self.textRecordTitle = nil
  self.animatorRecord = nil
end

function UIFrontBreakOutSundayNewRecordView:DataDefine()
end

function UIFrontBreakOutSundayNewRecordView:DataDestroy()
end

function UIFrontBreakOutSundayNewRecordView:OnAddListener()
  base.OnAddListener(self)
end

function UIFrontBreakOutSundayNewRecordView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIFrontBreakOutSundayNewRecordView:OnBtnPanelClick()
end

function UIFrontBreakOutSundayNewRecordView:RefreshView()
  local param = self:GetUserData()
  local stageId = param.stageId
  local stageIdIndex = DataCenter.ActFrontBreakSundayDataManager:GetActData(param.frontBreakSundayActId):GetStageIndex(stageId)
  local stagesCount = #DataCenter.ActFrontBreakSundayDataManager:GetActData(param.frontBreakSundayActId).stageIds
  local levelTitle = Localization:GetString("frontline_weekend_title_02", stageIdIndex, stagesCount)
  self.textLevelName:SetText(levelTitle)
  self.textTotalRemainNum:SetText(param.totalLeft or 0)
  self.textLevelRemainNum:SetText(param.curLeft)
  local isInAlliance = LuaEntry.Player:IsInAlliance()
  local topRankOld = param.topRankOld or 0
  local topRankNew = param.topRankNew or 0
  local isTopRankNew = 0 < topRankNew and (topRankOld == 0 or topRankOld > topRankNew)
  self.compTopRank:SetActive(isTopRankNew)
  self.textTopRankOld:SetText(topRankOld == 0 and Localization:GetString("activity_breakthrough_tips_16") or topRankOld)
  self.textTopRankNew:SetText(topRankNew)
  local alRankOld = param.alRankOld or 0
  local alRankNew = param.alRankNew or 0
  local isAlRankNew = isInAlliance and 0 < alRankNew and (alRankOld == 0 or alRankOld > alRankNew)
  self.compALRank:SetActive(isAlRankNew)
  self.textALRankOld:SetText(alRankOld == 0 and Localization:GetString("activity_breakthrough_tips_16") or alRankOld)
  self.textALRankNew:SetText(alRankNew)
  local serRankOld = param.serRankOld or 0
  local serRankNew = param.serRankNew or 0
  local isSerRankNew = 0 < serRankNew and (serRankOld == 0 or serRankOld > serRankNew)
  self.compServerRank:SetActive(isSerRankNew)
  self.textServerRankOld:SetText(serRankOld == 0 and Localization:GetString("activity_breakthrough_tips_16") or serRankOld)
  self.textServerRankNew:SetText(serRankNew)
  local criteriaStage = DataCenter.ActFrontBreakSundayDataManager:GetTopRankCriteriaStage(param.frontBreakSundayActId)
  self.textTopRankNeedStage:SetLocalText("activity_breakthrough_tips_15", criteriaStage)
  local criteriaRemainSolider = DataCenter.ActFrontBreakSundayDataManager:GetTopRankCriteriaRemainSolider(param.frontBreakSundayActId)
  self.textRemainNum:SetText(string.format("x%d", criteriaRemainSolider))
  local oldRank, newRank
  if isTopRankNew then
    newRank = topRankNew
    if 0 < topRankOld then
      oldRank = topRankOld
    else
      self.textUpNum:SetText(topRankNew)
    end
  elseif isSerRankNew then
    newRank = serRankNew
    if 0 < serRankOld then
      oldRank = serRankOld
    else
      self.textUpNum:SetText(serRankNew)
    end
  elseif isAlRankNew then
    newRank = alRankNew
    if 0 < alRankOld then
      oldRank = alRankOld
    else
      self.textUpNum:SetText(alRankNew)
    end
  end
  self:KillTween()
  if oldRank and newRank then
    self.tween = DOTween.To(function(x)
      self.textUpNum:SetText(math.floor(x))
    end, oldRank, newRank, 1.5)
  elseif newRank then
    self.textUpNum:SetText(newRank)
  else
    self.textUpNum:SetText(0)
  end
  local newRecord = param.newRecord and true or false
  if newRecord then
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.compNewRecord:SetActive(true)
      self.animatorRecord:Play("NewRecord_movein")
    end, 1.2)
  end
end

function UIFrontBreakOutSundayNewRecordView:KillTween()
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
end

function UIFrontBreakOutSundayNewRecordView:OnBtnBackClick()
  local userdata = self:GetUserData()
  self.ctrl:CloseSelf()
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

function UIFrontBreakOutSundayNewRecordView:OnBtnShareClick()
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

return UIFrontBreakOutSundayNewRecordView
