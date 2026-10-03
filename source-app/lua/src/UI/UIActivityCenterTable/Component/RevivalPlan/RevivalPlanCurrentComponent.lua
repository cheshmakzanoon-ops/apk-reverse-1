local base = UIBaseContainer
local RevivalPlanCurrentComponent = BaseClass("RevivalPlanCurrentComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIRevivalPlanCurrentItemComponent = require("UI.UIActivityCenterTable.Component.RevivalPlan.UIRevivalPlanCurrentItemComponent")

function RevivalPlanCurrentComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function RevivalPlanCurrentComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function RevivalPlanCurrentComponent:ComponentDefine()
  self.textTitle = self:AddComponent(UIText, "title")
  self.textPhase = self:AddComponent(UIText, "phase")
  self.textTime = self:AddComponent(UIText, "time")
  self.textDesc = self:AddComponent(UIText, "desc")
  self.compDay = self:AddComponent(UIBaseContainer, "day")
  self.rawImgIcon = self:AddComponent(UIRawImage, "day/icon")
  self.btnReturn = self:AddComponent(UIButton, "returnBtn")
  self.btnReturn:SetOnClick(function()
    self:OnBtnReturnClick()
  end)
  self.btnReturnTitle = self:AddComponent(UIText, "returnBtn/returnBtnTitle")
  self.btnScore = self:AddComponent(UIButton, "scoreBtn")
  self.btnScore:SetOnClick(function()
    self:OnBtnScoreClick()
  end)
  self.textScore = self:AddComponent(UIText, "scoreBtn/score")
  self.loopListViewScrollView = self:AddComponent(UILoopListView2, "Rect_Bottom/ScrollView")
  self.loopViewContent = self:AddComponent(UIBaseContainer, "Rect_Bottom/ScrollView/Viewport/Content")
  self.slider = self:AddComponent(UISlider, "Rect_Bottom/ScrollView/Viewport/Content/Slider")
  self.btnLeft = self:AddComponent(UIButton, "leftBtn")
  self.btnLeft:SetOnClick(function()
    self:OnBtnLeftClick()
  end)
  self.btnRight = self:AddComponent(UIButton, "rightBtn")
  self.btnRight:SetOnClick(function()
    self:OnBtnRightClick()
  end)
  self.loopListViewScrollView:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.btnReturnTitle:SetText(Localization:GetString("revival_plan_041"))
  self.btnLeft:SetActive(false)
  self.btnRight:SetActive(false)
end

function RevivalPlanCurrentComponent:ComponentDestroy()
  self.textTitle = nil
  self.textPhase = nil
  self.textTime = nil
  self.textDesc = nil
  self.rawImgIcon = nil
  self.btnReturn = nil
  self.btnScore = nil
  self.textScore = nil
  self.loopListViewScrollView = nil
  self.slider = nil
  self.btnLeft = nil
  self.btnRight = nil
  self.loopViewContent = nil
  self.compDay = nil
end

function RevivalPlanCurrentComponent:DataDefine()
  self.itemIndex = 0
end

function RevivalPlanCurrentComponent:DataDestroy()
  self.itemIndex = nil
  self:ClearScroll()
  self:DelCountDownTimer()
  self.countDownTimerAction = nil
end

function RevivalPlanCurrentComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnRevivalPlanClaimReward, self.OnRevivalPlanClaimReward)
end

function RevivalPlanCurrentComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.OnRevivalPlanClaimReward, self.OnRevivalPlanClaimReward)
  base.OnRemoveListener(self)
end

function RevivalPlanCurrentComponent:OnDisable()
  base.OnDisable(self)
  self:DelCountDownTimer()
end

function RevivalPlanCurrentComponent:OnGetItemByIndex(loopView, index)
  index = index + 1
  if index < 1 or index > #self.dataList then
    return nil
  end
  local item = loopView:NewListViewItem("UIRevivalPlanItem")
  local script = self.loopViewContent:GetComponent(item.gameObject.name, UIRevivalPlanCurrentItemComponent)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.loopViewContent:AddComponent(UIRevivalPlanCurrentItemComponent, objectName)
  end
  local showGuide = self.showGuide and self.guideTarget
  self.guideTarget = nil
  script:SetActive(true)
  script:SetData(self.dataList[index], index, self.activityData, self.stageId, self.stageIndex, self.isCurStage, showGuide)
  return item
end

function RevivalPlanCurrentComponent:ClearScroll()
  self.loopViewContent:RemoveComponents(UIRevivalPlanCurrentItemComponent)
  self.loopListViewScrollView:ClearAllItems()
end

function RevivalPlanCurrentComponent:SetData(activityId, stageId, activityData)
  self.activityId = activityId
  self.stageId = stageId
  self.activityData = activityData
  self.textTitle:SetText(Localization:GetString(activityData.name))
  local stages = DataCenter.RevivalPlanManager:GetStages(self.activityId)
  local stageIndex = table.indexof(stages, self.stageId)
  self.stageIndex = stageIndex or 1
  local cfg = DataCenter.ActivityRevivalConfigTemplateManager:GetTemplate(stageId)
  if cfg ~= nil then
    self.dataList = cfg.score_list
  else
    self.dataList = {}
  end
  self.isCurStage = false
  self:RefreshBtn()
  local hasOpened = CS.GameEntry.Setting:GetBool("OpenedRevivalPlanCurrent_" .. LuaEntry.Player.uid, false)
  self.showGuide = not hasOpened
  self.guideTarget = true
  CS.GameEntry.Setting:SetBool("OpenedRevivalPlanCurrent_" .. LuaEntry.Player.uid, true)
  if #self.dataList == 0 then
    self:ClearScroll()
  else
    self.loopListViewScrollView:SetListItemCount(#self.dataList, false, false)
    self.loopListViewScrollView:RefreshAllShownItem()
    local moveToIndex = 0
    local stageInfo = DataCenter.RevivalPlanManager:GetStageInfo(self.activityId, self.stageIndex)
    local indexList = stageInfo.indexList or {}
    for i = 1, #self.dataList do
      local value = indexList[i] or 0
      if i == value then
        moveToIndex = i
      else
        break
      end
    end
    if 0 < moveToIndex then
      moveToIndex = moveToIndex - 1
    end
    self.loopListViewScrollView:MovePanelToItemIndex(moveToIndex)
  end
  self:InitSlider(#self.dataList)
  self:RefreshScore()
  self.textPhase:SetText(Localization:GetString(cfg.phase_name))
  self.textDesc:SetText(Localization:GetString(cfg.phase_des))
  self.rawImgIcon:LoadSprite(cfg.phase_open_pic)
  self.rawImgIcon:SetNativeSize()
  if self.isCurStage then
    self:AddCountDownTimer()
    self:RefreshRemainTime()
  else
    self:DelCountDownTimer()
    self.textTime:SetText(Localization:GetString("revival_plan_039"))
  end
end

function RevivalPlanCurrentComponent:GetCurStageIndex()
  return self.stageIndex or 1
end

function RevivalPlanCurrentComponent:GetCurStageId()
  return self.stageId
end

function RevivalPlanCurrentComponent:OnRevivalPlanClaimReward()
  self.loopListViewScrollView:RefreshAllShownItem()
end

function RevivalPlanCurrentComponent:AddCountDownTimer()
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

function RevivalPlanCurrentComponent:DelCountDownTimer()
  if self.countDownTimer ~= nil then
    self.countDownTimer:Stop()
    self.countDownTimer = nil
  end
end

function RevivalPlanCurrentComponent:RefreshRemainTime()
  local remain = DataCenter.RevivalPlanManager:GetCurStageRemainTime(self.activityId)
  if 0 < remain then
    self.textTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remain))
  else
    self.textTime:SetText("")
    self:DelCountDownTimer()
  end
end

local itemHeight = 136
local itemPad = 8

function RevivalPlanCurrentComponent:InitSlider(count)
  if self.slider then
    local height = count * itemHeight + itemPad * (count - 1) - itemHeight / 2
    height = height < 0 and 0 or height
    self.slider.transform:Set_sizeDelta(36, height)
  end
end

function RevivalPlanCurrentComponent:RefreshScore()
  local progress = 0
  if 0 < self.stageIndex then
    local stageInfo = DataCenter.RevivalPlanManager:GetStageInfo(self.activityId, self.stageIndex)
    local score = stageInfo.score
    self.textScore:SetText(string.GetFormattedSeparatorNum(score))
    local count = #self.dataList
    count = Mathf.Max(1, count)
    local step = 1 / count
    local firstStep = step / 2
    local otherStep = (1 - firstStep) / (count - 1)
    local lastNeedScore = 0
    for i, v in pairs(self.dataList) do
      local curStageStep = i == 1 and firstStep or otherStep
      if score >= v then
        progress = progress + curStageStep
        lastNeedScore = v
      else
        progress = progress + curStageStep * (score - lastNeedScore) / (v - lastNeedScore)
        break
      end
    end
  end
  self.slider:SetValue(progress)
end

function RevivalPlanCurrentComponent:RefreshBtn()
  local stages = DataCenter.RevivalPlanManager:GetStages(self.activityId)
  local cur = DataCenter.RevivalPlanManager:GetCurStage(self.activityId)
  local curIndex = table.indexof(stages, cur)
  if not curIndex then
    self.isCurStage = false
    return
  end
  self.isCurStage = self.stageIndex == curIndex
end

function RevivalPlanCurrentComponent:OnBtnReturnClick()
  EventManager:GetInstance():Broadcast(EventId.RevivalPlanShowMain)
end

function RevivalPlanCurrentComponent:OnBtnScoreClick()
  EventManager:GetInstance():Broadcast(EventId.RevivalPlanShowPlanTaskFromDayItem, {
    stageId = self.stageId,
    hideBtn = not self.isCurStage
  })
end

function RevivalPlanCurrentComponent:OnBtnLeftClick()
  if self.stageIndex > 1 then
    local index = self.stageIndex - 1
    local stages = DataCenter.RevivalPlanManager:GetStages(self.activityId)
    local stageId = stages[index]
    if stageId then
      self:SetData(self.activityId, stageId, self.activityData)
    end
  end
end

function RevivalPlanCurrentComponent:OnBtnRightClick()
  local cur = DataCenter.RevivalPlanManager:GetCurStage(self.activityId)
  local stages = DataCenter.RevivalPlanManager:GetStages(self.activityId)
  local curIndex = table.indexof(stages, cur)
  if not curIndex then
    return
  end
  if curIndex > self.stageIndex then
    local index = self.stageIndex + 1
    local stageId = stages[index]
    if stageId then
      self:SetData(self.activityId, stageId, self.activityData)
    end
  end
end

function RevivalPlanCurrentComponent:GetDayComponentPos()
  return self.compDay:GetPosition()
end

function RevivalPlanCurrentComponent:RefreshCurStage(isMain)
  self.btnReturn:SetActive(not isMain)
end

return RevivalPlanCurrentComponent
