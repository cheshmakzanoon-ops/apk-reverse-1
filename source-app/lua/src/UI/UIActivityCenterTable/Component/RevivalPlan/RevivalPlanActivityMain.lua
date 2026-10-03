local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local RevivalPlanActivityMain = BaseClass("RevivalPlanActivityMain", base)
local Localization = CS.GameEntry.Localization
local RevivalPlanMainComponent = require("UI.UIActivityCenterTable.Component.RevivalPlan.RevivalPlanMainComponent")
local RevivalPlanCurrentComponent = require("UI.UIActivityCenterTable.Component.RevivalPlan.RevivalPlanCurrentComponent")
local IdleAnim = "UIRevivalPlanPanelMainLoop"
local ChangeAnim = {
  "UIRevivalPlanPanelMainChange1",
  "UIRevivalPlanPanelMainChange2",
  "UIRevivalPlanPanelMainChange3",
  "UIRevivalPlanPanelMainChange4",
  "UIRevivalPlanPanelMainChange5",
  "UIRevivalPlanPanelMainChange6",
  "UIRevivalPlanPanelMainChange7"
}
local KeyAnim = {
  "UIRevivalPlanPanelMainKey01",
  "UIRevivalPlanPanelMainKey02",
  "UIRevivalPlanPanelMainKey03",
  "UIRevivalPlanPanelMainKey04",
  "UIRevivalPlanPanelMainKey05"
}
local FirstInAnim = "UIRevivalPlanPanelMainFirstIn"
local BoxOpenAnim = "UIRevivalPlanPanelBoxOpen"
local ChangeOutAnim = "UIRevivalPlanPanelMainChangeOut"
local plotGroup1 = 2600
local plotGroup2 = 2601
local plotGroup3 = 2602
local arrowEffect = "Assets/Main/Prefabs/Guide/UIArrowFinger.prefab"

function RevivalPlanActivityMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function RevivalPlanActivityMain:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function RevivalPlanActivityMain:OnDisable()
  self:DataDestroy()
  base.OnDisable(self)
end

function RevivalPlanActivityMain:ComponentDefine()
  self.compRevivalMain = self:AddComponent(RevivalPlanMainComponent, "revivalMain")
  self.compRevivalCurrent = self:AddComponent(RevivalPlanCurrentComponent, "revivalCurrent")
  self.textDetails = self:AddComponent(UIText, "bottom/details")
  self.btnRank = self:AddComponent(UIButton, "bottom/rankBtn")
  self.btnRank:SetOnClick(function()
    self:OnBtnRankClick()
  end)
  self.textRankBtnTitle = self:AddComponent(UIText, "bottom/rankBtn/rankBtnTitle")
  self.btnRecord = self:AddComponent(UIButton, "bottom/recordBtn")
  self.btnRecord:SetOnClick(function()
    self:OnBtnRecordClick()
  end)
  self.textRecordBtnTitle = self:AddComponent(UIText, "bottom/recordBtn/recordBtnTitle")
  self.textRankBtnTitle:SetText(Localization:GetString("revival_plan_025"))
  self.textRecordBtnTitle:SetText(Localization:GetString("revival_plan_026"))
  self.anim = self:AddComponent(UIAnimator, "")
end

function RevivalPlanActivityMain:ComponentDestroy()
  self.compRevivalMain = nil
  self.compRevivalCurrent = nil
  self.textDetails = nil
  self.btnRank = nil
  self.textRankBtnTitle = nil
  self.btnRecord = nil
  self.textRecordBtnTitle = nil
end

function RevivalPlanActivityMain:DataDefine()
  self.showMain = false
end

function RevivalPlanActivityMain:DataDestroy()
  self:ClearChangingInStageTimer()
  self:ClearChangingOutStageTimer()
  self:ClearFirstInSeq()
  self:ClearArrowEffect()
end

function RevivalPlanActivityMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RevivalPlanShowCurPage, self.OnRevivalPlanShowCurPage)
  self:AddUIListener(EventId.RefreshActivityDetailData, self.OnRefreshActivityDetailData)
  self:AddUIListener(EventId.RevivalPlanShowMain, self.OnRevivalPlanShowMain)
  self:AddUIListener(EventId.RevivalPlanShowPlanTaskFromDayItem, self.OnRevivalPlanShowPlanTaskFromDayItem)
  self:AddUIListener(EventId.RevivalPlanTryClaimReward, self.OnRevivalPlanTryClaimReward)
  self:AddUIListener(EventId.RevivalPlanTryChangeKeys, self.OnRevivalPlanTryChangeKeys)
  self:AddUIListener(EventId.RevivalPlanShowArchive, self.OnRevivalPlanShowArchive)
  self:AddUIListener(EventId.RevivalPlanBoxPreview, self.OnRevivalPlanBoxPreview)
  self:AddUIListener(EventId.GF_plot_group_done, self.OnPlotGroupDone)
  self:AddUIListener(EventId.RevivalPlanBoxPreviewClose, self.OnRevivalPlanBoxPreviewClose)
  self:AddUIListener(EventId.GF_window_closed, self.OnWindowClosed)
  self:AddUIListener(EventId.GF_window_opened, self.OnWindowOpen)
  self:AddUIListener(EventId.RevivalPlanShowInfoPage, self.OnRevivalPlanShowInfoPage)
end

function RevivalPlanActivityMain:OnRemoveListener()
  self:RemoveUIListener(EventId.RevivalPlanShowCurPage, self.OnRevivalPlanShowCurPage)
  self:RemoveUIListener(EventId.RefreshActivityDetailData, self.OnRefreshActivityDetailData)
  self:RemoveUIListener(EventId.RevivalPlanShowMain, self.OnRevivalPlanShowMain)
  self:RemoveUIListener(EventId.RevivalPlanShowPlanTaskFromDayItem, self.OnRevivalPlanShowPlanTaskFromDayItem)
  self:RemoveUIListener(EventId.RevivalPlanTryClaimReward, self.OnRevivalPlanTryClaimReward)
  self:RemoveUIListener(EventId.RevivalPlanTryChangeKeys, self.OnRevivalPlanTryChangeKeys)
  self:RemoveUIListener(EventId.RevivalPlanShowArchive, self.OnRevivalPlanShowArchive)
  self:RemoveUIListener(EventId.RevivalPlanBoxPreview, self.OnRevivalPlanBoxPreview)
  self:RemoveUIListener(EventId.GF_plot_group_done, self.OnPlotGroupDone)
  self:RemoveUIListener(EventId.RevivalPlanBoxPreviewClose, self.OnRevivalPlanBoxPreviewClose)
  self:RemoveUIListener(EventId.GF_window_closed, self.OnWindowClosed)
  self:RemoveUIListener(EventId.GF_window_opened, self.OnWindowOpen)
  self:RemoveUIListener(EventId.RevivalPlanShowInfoPage, self.OnRevivalPlanShowInfoPage)
  base.OnRemoveListener(self)
end

function RevivalPlanActivityMain:SetData(activityId)
  base.SetData(self, activityId)
  if not self.activityId then
    return
  end
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if not self.activityData then
    return
  end
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(self.activityId)
  self.compRevivalMain:SetActive(true)
  self.compRevivalCurrent:SetActive(false)
  self.showMain = true
  local hasOpened = CS.GameEntry.Setting:GetBool("OpenedRevivalPlanActivity_" .. LuaEntry.Player.uid, false)
  self:RefreshBaseInfo(hasOpened)
  self.reqActivity = hasOpened
  SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(self.activityId))
  CS.GameEntry.Setting:SetBool("OpenedRevivalPlanActivity_" .. LuaEntry.Player.uid, true)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  self.firstIn = false
  self.waitHowToPlay = nil
  if not hasOpened then
    self:ShowFirstIn()
    Logger.LogInfo("RevivalPlan FirstIn")
  else
    local archiveShowed = CS.GameEntry.Setting:GetBool("RevivalPlanArchive_" .. LuaEntry.Player.uid, false)
    if not archiveShowed then
      self.anim:Play(IdleAnim, 0, 0)
      self.anim:SetSpeed(0)
      self:ShowArchiveGuide()
      Logger.LogInfo("RevivalPlan ShowArchive")
    else
      self.anim:Play(IdleAnim, 0, 0)
      self.anim:SetSpeed(1)
      Logger.LogInfo("RevivalPlan ShowNormal")
    end
  end
end

function RevivalPlanActivityMain:RefreshBaseInfo(showDayEffect)
  self.compRevivalMain:SetData(self.activityData, showDayEffect)
  self:RefreshScoreDetails()
  if self.firstIn or self.waitHowToPlay then
    self.compRevivalMain:SetDayForceCloseEffect()
  end
end

function RevivalPlanActivityMain:RefreshScoreDetails()
  if self.showMain then
    local score = DataCenter.RevivalPlanManager:GetTotalScore(self.activityId)
    local rank = DataCenter.RevivalPlanManager:GetTotalRank(self.activityId)
    self.textDetails:SetText(Localization:GetString("revival_plan_021", rank, string.GetFormattedSeperatorNum(score)))
  else
    local stageIndex = self.compRevivalCurrent:GetCurStageIndex()
    local curInfo = DataCenter.RevivalPlanManager:GetStageInfo(self.activityId, stageIndex)
    if curInfo then
      local score = curInfo.score or 0
      local rank = curInfo.rank or 0
      self.textDetails:SetText(Localization:GetString("revival_plan_029", rank, string.GetFormattedSeperatorNum(score)))
    end
  end
  self.btnRecord:SetActive(self.showMain)
  self.compRevivalCurrent:RefreshCurStage(self.showMain)
end

function RevivalPlanActivityMain:OnRefreshActivityDetailData(activityId)
  if activityId ~= self.activityId then
    return
  end
  self:RefreshBaseInfo(self.reqActivity)
  self.reqActivity = nil
end

function RevivalPlanActivityMain:OnRevivalPlanShowCurPage(stageId)
  if self:CheckFirstIn() then
    return
  end
  self:ClearArrowEffect()
  self.compRevivalCurrent:SetData(self.activityId, stageId, self.activityData)
  local stageIndex = self.compRevivalCurrent:GetCurStageIndex()
  local changeAnim = ChangeAnim[stageIndex]
  if not string.IsNullOrEmpty(changeAnim) then
    local ret, length = self.anim:PlayAnimationReturnTime(changeAnim)
    if ret and 0 < length then
      self:SetChangingInStage(length, stageIndex)
      return
    end
  end
  self:OnChangingInStageEnd()
end

function RevivalPlanActivityMain:OnRevivalPlanShowPlanTaskFromDayItem(stageData)
  if self.changingInStage or self.changingOutStage then
    return
  end
  if self:CheckFirstIn() then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIRevivalPlanTask, {anim = true}, stageData)
end

function RevivalPlanActivityMain:OnRevivalPlanTryClaimReward(param)
  if self.changingInStage or self.changingOutStage then
    return
  end
  DataCenter.RevivalPlanManager:ClaimReward(param.index, param.stageId)
end

function RevivalPlanActivityMain:OnRevivalPlanShowArchive()
  self:OnRevivalPlanShowInfoPage()
end

function RevivalPlanActivityMain:OnRevivalPlanBoxPreview(requireCount)
  if self:CheckFirstIn() then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonSideTip, {anim = false})
    return
  end
  self.compRevivalMain:ShowBoxPreview(requireCount)
  self:ClearArrowEffect()
end

function RevivalPlanActivityMain:OnRevivalPlanShowInfoPage()
  if self.changingInStage or self.changingOutStage then
    return
  end
  if self:CheckFirstIn() then
    return
  end
  self.compRevivalMain:ShowInfo()
end

function RevivalPlanActivityMain:SetChangingInStage(length, stageIndex)
  self:ClearChangingInStageTimer()
  self:ClearChangingOutStageTimer()
  self.changingInStage = true
  self.changingInStageTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:OnChangingInStageEnd()
  end, length)
  local targetPos = self.compRevivalCurrent:GetDayComponentPos()
  self.compRevivalMain:PlayChangingIn(stageIndex, targetPos)
end

function RevivalPlanActivityMain:ClearChangingInStageTimer()
  self.changingInStage = nil
  if self.changingInStageTimer then
    self.changingInStageTimer:Stop()
    self.changingInStageTimer = nil
  end
end

function RevivalPlanActivityMain:OnChangingInStageEnd()
  Logger.LogInfo("RevivalPlan ShowCurrent")
  self.changingInStage = nil
  self.compRevivalCurrent:SetActive(true)
  self.compRevivalMain:SetActive(false)
  self.compRevivalMain:ClearDayTween()
  self.showMain = false
  self:RefreshScoreDetails()
end

function RevivalPlanActivityMain:SetChangingOutStage(length, changeKeys)
  self:ClearChangingOutStageTimer()
  self.changingOutStage = true
  self.changingOutStageTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:OnChangingOutStageEnd(changeKeys)
  end, length)
end

function RevivalPlanActivityMain:OnChangingOutStageEnd(changeKeys)
  self.changingOutStage = nil
  self.compRevivalCurrent:SetActive(false)
  self.compRevivalMain:SetActive(true)
  self.showMain = true
  self:RefreshBaseInfo()
  self.anim:Play(IdleAnim, 0, 0)
  if 0 < changeKeys then
    self:ShowChangeKeys(changeKeys)
  end
end

function RevivalPlanActivityMain:ClearChangingOutStageTimer()
  self.changingOutStage = nil
  if self.changingOutStageTimer then
    self.changingOutStageTimer:Stop()
    self.changingOutStageTimer = nil
  end
end

function RevivalPlanActivityMain:OnRevivalPlanShowMain()
  self:OnRevivalPlanShowMainImp(0)
end

function RevivalPlanActivityMain:OnRevivalPlanShowMainImp(changeKeys)
  Logger.LogInfo("RevivalPlan ShowMain")
  self:ClearChangingInStageTimer()
  local ret, length = self.anim:PlayAnimationReturnTime(ChangeOutAnim)
  if ret and 0 < length then
    self.compRevivalMain:SetActive(true)
    self:SetChangingOutStage(length, changeKeys)
    return
  end
  self.compRevivalCurrent:SetActive(false)
  self.compRevivalMain:SetActive(true)
  self.showMain = true
  self:RefreshBaseInfo()
  self.anim:Play(IdleAnim, 0, 0)
  if 0 < changeKeys then
    self:ShowChangeKeys(changeKeys)
  end
end

function RevivalPlanActivityMain:OnBtnRankClick()
  if self.changingInStage or self.changingOutStage then
    return
  end
  if self:CheckFirstIn() then
    return
  end
  if self.showMain then
    local curStageCfgId = DataCenter.RevivalPlanManager:GetCurStage(self.activityId)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIRevivalPlanRank, {anim = true}, self.activityId, curStageCfgId, curStageCfgId)
  else
    local maxStageId = DataCenter.RevivalPlanManager:GetCurStage(self.activityId)
    local stageId = self.compRevivalCurrent:GetCurStageId()
    if stageId == nil then
      stageId = maxStageId
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIRevivalPlanRank, {anim = true}, self.activityId, stageId, maxStageId)
  end
end

function RevivalPlanActivityMain:OnBtnRecordClick()
  if self.changingInStage or self.changingOutStage then
    return
  end
  if self:CheckFirstIn() then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIRevivalPlanRecord, {anim = true}, self.activityId)
end

function RevivalPlanActivityMain:OnRevivalPlanTryChangeKeys(tryChangeKeys)
  if self.showMain then
  else
    self:OnRevivalPlanShowMainImp(tryChangeKeys)
  end
end

function RevivalPlanActivityMain:ShowChangeKeys(changeKeys)
  self.compRevivalMain:ShowChangeKeys(changeKeys)
end

function RevivalPlanActivityMain:ShowFirstIn()
  self.firstIn = true
  self.compRevivalMain:SetDayForceCloseEffect()
  self.anim:SampleAnimationAtTime(FirstInAnim, 0.05)
  self.anim:SetSpeed(0)
  self.anim:Play(FirstInAnim, 0, 0.05)
  EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = plotGroup1})
end

function RevivalPlanActivityMain:OnPlotGroupDone(plotGroupId)
  if self.waitToCurStage and plotGroupId == plotGroup3 then
    self:ShowCurStageGuide()
  end
  if not self.firstIn then
    return
  end
  if plotGroupId == plotGroup1 then
    self.anim:SetSpeed(1)
    self.anim:Play(FirstInAnim, 0, 0)
    local ret, dur = self.anim:PlayAnimationReturnTime(FirstInAnim)
    if not ret then
      return
    end
    self:ClearFirstInSeq()
    self:ClearArrowEffect()
    local dataList = self.activityData.para_3
    self.firstInSeq = CS.DG.Tweening.DOTween.Sequence()
    self.firstInSeq:AppendInterval(dur)
    self.firstInSeq:AppendCallback(function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonSideTip, {anim = true, playEffect = false}, dataList)
    end)
    self.firstInSeq:AppendInterval(1)
    self.firstInSeq:AppendCallback(function()
      self.vfxHandle = DataCenter.LWGuideVFXManager:InstantiateAsync(arrowEffect, self.OnVfxLoaded, self, 60, GuideVFXPriority.High)
    end)
  elseif plotGroupId == plotGroup2 then
    self:ShowInfoGuide()
  end
end

function RevivalPlanActivityMain:OnRevivalPlanBoxPreviewClose()
  if self.firstInSeq then
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = plotGroup2})
    self:ClearFirstInSeq()
  end
end

function RevivalPlanActivityMain:ClearFirstInSeq()
  if self.firstInSeq then
    self.firstInSeq:Kill()
    self.firstInSeq = nil
  end
end

function RevivalPlanActivityMain:ClearArrowEffect()
  if self.vfxHandle then
    DataCenter.LWGuideVFXManager:StopCurrent(self.vfxHandle)
    self.vfxHandle = nil
  end
  self.showInfoGuide = nil
end

function RevivalPlanActivityMain:OnVfxLoaded(handle)
  if handle.isError then
    self:LogError("RevivalPlanActivityMain.OnVfxLoaded load res failed")
    return
  end
  if self.showInfoGuide then
    local par = self.compRevivalMain:GetInfoArrowTransform()
    handle.gameObject.transform:SetParent(par)
    handle.gameObject.transform:Set_localPosition(-30, -30, 0)
    handle.gameObject.transform:Set_localScale(-1, ResetScale.y, ResetScale.z)
    handle.gameObject.transform:SetParent(self.transform)
    self.showInfoGuide = nil
  else
    local pos = self.compRevivalMain:GetBoxArrowPos()
    handle.gameObject.transform:SetParent(self.transform)
    handle.gameObject.transform:Set_position(pos.x, pos.y, pos.z)
    handle.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
  end
end

function RevivalPlanActivityMain:OnCurStageVfxLoaded(handle)
  if handle.isError then
    self:LogError("RevivalPlanActivityMain.OnCurStageVfxLoaded load res failed")
    return
  end
  local par = self.compRevivalMain:GetCurStageTransform()
  handle.gameObject.transform:SetParent(par)
  handle.gameObject.transform:Set_localPosition(-30, -30, 0)
  handle.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
  handle.gameObject.transform:SetParent(self.transform)
end

function RevivalPlanActivityMain:ShowArchiveGuide()
  self.compRevivalMain:SetDayForceCloseEffect()
  self:ShowInfoGuide()
end

function RevivalPlanActivityMain:ShowInfoGuide()
  self:ClearArrowEffect()
  self.showInfoGuide = true
  self.vfxHandle = DataCenter.LWGuideVFXManager:InstantiateAsync(arrowEffect, self.OnVfxLoaded, self, 60, GuideVFXPriority.High)
  self.compRevivalMain:ShowInfoEffect(true)
  self.waitHowToPlay = true
end

function RevivalPlanActivityMain:OnWindowOpen(ui_name)
  if ui_name == UIWindowNames.UILWHowToPlay and self.waitHowToPlay then
    self.compRevivalMain:ShowInfoEffect(false)
    self:ClearArrowEffect()
    CS.GameEntry.Setting:SetBool("RevivalPlanArchive_" .. LuaEntry.Player.uid, true)
  end
end

function RevivalPlanActivityMain:OnWindowClosed(ui_name)
  if ui_name == UIWindowNames.UILWHowToPlay and self.waitHowToPlay then
    self.waitHowToPlay = nil
    self.firstIn = false
    self:RefreshBaseInfo(true)
    self.waitToCurStage = true
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = plotGroup3})
  end
end

function RevivalPlanActivityMain:CheckFirstIn()
  if self.firstIn or self.waitHowToPlay then
    if self.waitHowToPlay and self.vfxHandle then
      self.compRevivalMain:ShowInfo()
      self:ClearArrowEffect()
    elseif self.firstIn and self.vfxHandle then
      self.compRevivalMain:ShowBoxPreview(5)
      self:ClearArrowEffect()
    end
    return true
  end
end

function RevivalPlanActivityMain:ShowCurStageGuide()
  self:ClearArrowEffect()
  self.vfxHandle = DataCenter.LWGuideVFXManager:InstantiateAsync(arrowEffect, self.OnCurStageVfxLoaded, self, 2, GuideVFXPriority.High)
end

return RevivalPlanActivityMain
