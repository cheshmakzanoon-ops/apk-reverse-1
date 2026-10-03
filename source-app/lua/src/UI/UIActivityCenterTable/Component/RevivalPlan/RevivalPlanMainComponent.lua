local base = UIBaseContainer
local RevivalPlanMainComponent = BaseClass("RevivalPlanMainComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local RevivalPlanMainDayItem = require("UI.UIActivityCenterTable.Component.RevivalPlan.RevivalPlanMainDayItem")
local RevivalPlanMainBoxComponent = require("UI.UIActivityCenterTable.Component.RevivalPlan.RevivalPlanMainBoxComponent")
local RevivalPlanMainBoxPreviewComponent = require("UI.UIActivityCenterTable.Component.RevivalPlan.RevivalPlanMainBoxPreviewComponent")

function RevivalPlanMainComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function RevivalPlanMainComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function RevivalPlanMainComponent:ComponentDefine()
  self.textTitle = self:AddComponent(UIText, "root/title")
  self.textDate = self:AddComponent(UIText, "root/date")
  self.btnInfo = self:AddComponent(UIButton, "root/infoBtn")
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.textTime = self:AddComponent(UIText, "root/timeBg/time")
  self.compDay1 = self:AddComponent(RevivalPlanMainDayItem, "root/dayRoot/day1")
  self.compDay2 = self:AddComponent(RevivalPlanMainDayItem, "root/dayRoot/day2")
  self.compDay3 = self:AddComponent(RevivalPlanMainDayItem, "root/dayRoot/day3")
  self.compDay4 = self:AddComponent(RevivalPlanMainDayItem, "root/dayRoot/day4")
  self.compDay5 = self:AddComponent(RevivalPlanMainDayItem, "root/dayRoot/day5")
  self.compDay6 = self:AddComponent(RevivalPlanMainDayItem, "root/dayRoot/day6")
  self.compDay7 = self:AddComponent(RevivalPlanMainDayItem, "root/dayRoot/day7")
  self.compBoxRoot = self:AddComponent(RevivalPlanMainBoxComponent, "root/boxRoot")
  self.compBoxPreviewRoot = self:AddComponent(RevivalPlanMainBoxPreviewComponent, "root/boxPreviewRoot")
  self.archiveBtn = self:AddComponent(UIButton, "root/archiveBtn")
  self.archiveBtn:SetOnClick(function()
    self:OnArchiveBtnClick()
  end)
  self.day1Pos = self:AddComponent(UIBaseContainer, "root/dayRoot/day1Pos")
  self.day2Pos = self:AddComponent(UIBaseContainer, "root/dayRoot/day2Pos")
  self.day3Pos = self:AddComponent(UIBaseContainer, "root/dayRoot/day3Pos")
  self.day4Pos = self:AddComponent(UIBaseContainer, "root/dayRoot/day4Pos")
  self.day5Pos = self:AddComponent(UIBaseContainer, "root/dayRoot/day5Pos")
  self.day6Pos = self:AddComponent(UIBaseContainer, "root/dayRoot/day6Pos")
  self.day7Pos = self:AddComponent(UIBaseContainer, "root/dayRoot/day7Pos")
  self.dayPosRoot = self:AddComponent(UIBaseContainer, "root/dayRoot")
  self.infoBtnEffect = self:AddComponent(UIBaseContainer, "root/infoBtnEffect")
  self.infoBtnEffect:SetActive(false)
  self.days = {
    self.compDay1,
    self.compDay2,
    self.compDay3,
    self.compDay4,
    self.compDay5,
    self.compDay6,
    self.compDay7
  }
  self.daysPos = {
    self.day1Pos,
    self.day2Pos,
    self.day3Pos,
    self.day4Pos,
    self.day5Pos,
    self.day6Pos,
    self.day7Pos
  }
end

function RevivalPlanMainComponent:ComponentDestroy()
  self.textTitle = nil
  self.textDate = nil
  self.btnInfo = nil
  self.textTime = nil
  self.compDay1 = nil
  self.compDay2 = nil
  self.compDay3 = nil
  self.compDay4 = nil
  self.compDay5 = nil
  self.compDay6 = nil
  self.compDay7 = nil
  self.compBoxRoot = nil
  self.compBoxPreviewRoot = nil
  self.days = nil
  self.daysPos = nil
  self.infoBtnEffect = nil
end

function RevivalPlanMainComponent:DataDefine()
end

function RevivalPlanMainComponent:DataDestroy()
  self:ClearDayTween()
  self:DelCountDownTimer()
  self.countDownTimerAction = nil
  self.activityInfoData = nil
end

function RevivalPlanMainComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnRevivalPlanClaimReward, self.OnRevivalPlanClaimReward)
end

function RevivalPlanMainComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.OnRevivalPlanClaimReward, self.OnRevivalPlanClaimReward)
  base.OnRemoveListener(self)
end

function RevivalPlanMainComponent:SetData(activityInfo, showDayEffect)
  self.activityInfoData = activityInfo
  local activityId = self.activityInfoData.activityId
  self.textTitle:SetText(Localization:GetString(activityInfo.name))
  local startT = UITimeManager:GetInstance():TimeStampToDayForLocal(activityInfo.startTime)
  local endT = UITimeManager:GetInstance():TimeStampToDayForLocal(activityInfo.endTime)
  self.textDate:SetText(Localization:GetString(activityInfo.desc_info, startT, endT))
  self:AddCountDownTimer()
  self:RefreshRemainTime()
  local curStageCfgId = DataCenter.RevivalPlanManager:GetCurStage(activityId)
  local curStageCfg = DataCenter.ActivityRevivalConfigTemplateManager:GetTemplate(curStageCfgId)
  if curStageCfg == nil then
    Logger.LogError("RevivalPlanMain.SetData get cur stage cfg invalid !")
    return
  end
  local curStageIndex = curStageCfg.day_list
  self.curStageIndex = curStageIndex
  local stages = DataCenter.RevivalPlanManager:GetStages(activityId)
  local stageCount = #stages
  local count = Mathf.Min(#self.days, stageCount)
  for i = 1, count do
    self.days[i]:SetActive(true)
    self.days[i]:SetStage(i, stages[i], curStageIndex, activityId, showDayEffect)
    local x, y = self.daysPos[i].rectTransform:Get_anchoredPosition()
    self.days[i].rectTransform:Set_anchoredPosition(x, y)
  end
  if stageCount > count then
    for i = count + 1, stageCount do
      self.days[i]:SetActive(false)
    end
  end
  self.compBoxRoot:SetData(activityInfo)
  self:ClearDayTween()
  self.infoBtnEffect:SetActive(false)
end

function RevivalPlanMainComponent:AddCountDownTimer()
  if self.countDownTimerAction == nil then
    function self.countDownTimerAction()
      self:RefreshRemainTime()
    end
  end
  if self.countDownTimer ~= nil then
    return
  end
  self.countDownTimer = TimerManager:GetInstance():GetTimer(1, self.countDownTimerAction, self, false, false, false)
  self.countDownTimer:Start()
end

function RevivalPlanMainComponent:RefreshRemainTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.activityInfoData.endTime - curTime
  if 0 < remainTime then
    self.textTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self.textTime:SetText("")
    self:DelCountDownTimer()
  end
end

function RevivalPlanMainComponent:DelCountDownTimer()
  if self.countDownTimer ~= nil then
    self.countDownTimer:Stop()
    self.countDownTimer = nil
  end
end

function RevivalPlanMainComponent:ShowInfo()
  if self.activityInfoData then
    local param = {}
    param.howToPlayList = self.activityInfoData.howtoplay
    param.story = self.activityInfoData.story
    param.defaultTitle = self.activityInfoData.name
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
    self.infoBtnEffect:SetActive(false)
  end
end

function RevivalPlanMainComponent:OnBtnInfoClick()
  EventManager:GetInstance():Broadcast(EventId.RevivalPlanShowInfoPage)
end

function RevivalPlanMainComponent:OnRevivalPlanBoxPreview(requireCount)
  self:ShowBoxPreview(requireCount)
end

function RevivalPlanMainComponent:ShowBoxPreview(requireCount)
  self.compBoxPreviewRoot:SetData(self.activityInfoData, requireCount)
end

function RevivalPlanMainComponent:OnRevivalPlanClaimReward()
  self.compBoxRoot:SetData(self.activityInfoData)
end

function RevivalPlanMainComponent:ShowChangeKeys(changeKeys)
  self.compBoxRoot:ShowChangeKeys(changeKeys)
end

function RevivalPlanMainComponent:OnArchiveBtnClick()
  EventManager:GetInstance():Broadcast(EventId.RevivalPlanShowArchive)
end

function RevivalPlanMainComponent:PlayChangingIn(stageIndex, targetPos)
  local screenPos = PosConverse.WorldToScreenPos(targetPos, CS.GameEntry.UICamera)
  local localPos = PosConverse.ScreenToUIPos(self.dayPosRoot.rectTransform, screenPos)
  localPos.x = localPos.x + 100 * CommonUtil.ArabicAutoMirrorFactor()
  localPos.y = localPos.y - 120
  self:ClearDayTween()
  self.dayTween = self.days[stageIndex].rectTransform:DOAnchorPos(localPos, 0.5):SetEase(CS.DG.Tweening.Ease.OutQuart)
end

function RevivalPlanMainComponent:ClearDayTween()
  if self.dayTween then
    self.dayTween:Kill()
    self.dayTween = nil
  end
end

function RevivalPlanMainComponent:GetBoxArrowPos()
  return self.compBoxRoot:GetArrowPos()
end

function RevivalPlanMainComponent:GetBoxArrowTransform()
  return self.compBoxRoot.transform
end

function RevivalPlanMainComponent:GetInfoArrowPos()
  return self.btnInfo:GetPosition()
end

function RevivalPlanMainComponent:GetInfoArrowTransform()
  return self.archiveBtn.transform
end

function RevivalPlanMainComponent:GetCurStageTransform()
  if self.curStageIndex == nil then
    return nil
  end
  if self.days then
    local day = self.days[self.curStageIndex]
    if day then
      return day.transform
    end
  end
end

function RevivalPlanMainComponent:ShowInfoEffect(show)
end

function RevivalPlanMainComponent:SetDayForceCloseEffect()
  if self.days then
    for _, dayItem in ipairs(self.days) do
      dayItem:ForceCloseEffectNode()
    end
  end
end

return RevivalPlanMainComponent
