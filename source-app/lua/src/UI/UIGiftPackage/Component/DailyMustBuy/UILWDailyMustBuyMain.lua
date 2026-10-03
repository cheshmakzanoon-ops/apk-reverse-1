local UILWDailyMustBuyMain = BaseClass("UILWDailyMustBuyMain", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWDailyMustBuyPackItem = require("UI.UIGiftPackage.Component.DailyMustBuy.UILWDailyMustBuyPackItem")
local UILWDailyMustBuyTargetItem = require("UI.UIGiftPackage.Component.DailyMustBuy.UILWDailyMustBuyTargetItem")
local emptyTip_path = "Rect_Package/Rect_Bottom/EmptyTipText"
local packageScrollView_path = "Rect_Package/Rect_Bottom/PackageScroll"
local packageContent_path = "Rect_Package/Rect_Bottom/PackageScroll/Viewport/Content"
local descText_path = "Rect_Package/Rect_Top/Txt_Desc"
local titleText_path = "Rect_Package/Rect_Top/Txt_GiftTitle"
local progress_slider_path = "Rect_Package/Rect_Top/TargetArea/Slider"
local progress_text_path = "Rect_Package/Rect_Top/TargetArea/ProgressText"
local progress_rewards_item_path = "Rect_Package/Rect_Top/TargetArea/TargetRewards/TargetItem%d"
local remainTimeText_path = "Rect_Package/Rect_Top/RemainTimeText"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGiftPackData, self.RefreshPackages)
  self:AddUIListener(EventId.RefreshResourceItem, self.RefreshStageInfo)
  self:AddUIListener(EventId.OnDailyMustBuyDataChanged, self.RefreshStageInfo)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.RefreshPackages)
  self:RemoveUIListener(EventId.RefreshResourceItem, self.RefreshStageInfo)
  self:RemoveUIListener(EventId.OnDailyMustBuyDataChanged, self.RefreshStageInfo)
  base.OnRemoveListener(self)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.packageList then
    return nil
  end
  local taskId = self.packageList[index]
  local item = loopScroll:NewListViewItem("DailyMustBuyPackage")
  local script = self.packageContentN:GetComponent(item.gameObject.name, UILWDailyMustBuyPackItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.packageContentN:AddComponent(UILWDailyMustBuyPackItem, objectName)
  end
  script:SetActive(true)
  script:SetItem(taskId, self.buyState, self.actId)
  return item
end

local function ComponentDefine(self)
  self.packageItemsTb = {}
  self.emptyTipN = self:AddComponent(UIText, emptyTip_path)
  self.emptyTipN:SetActive(false)
  self.packageScrollViewN = self:AddComponent(UILoopListView2, packageScrollView_path)
  self.packageScrollViewN:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.packageContentN = self:AddComponent(UIBaseContainer, packageContent_path)
  self.descTextN = self:AddComponent(UIText, descText_path)
  self.titleTextN = self:AddComponent(UIText, titleText_path)
  self.progress_sliderN = self:AddComponent(UISlider, progress_slider_path)
  self.progress_textN = self:AddComponent(UIText, progress_text_path)
  self.progress_rewards_itemN = {}
  for i = 1, 5 do
    self.progress_rewards_itemN[i] = self:AddComponent(UILWDailyMustBuyTargetItem, string.format(progress_rewards_item_path, i))
  end
  self.remainTimeTextN = self:AddComponent(UIText, remainTimeText_path)
  self.remainTimeTextN:SetText("")
end

local function ComponentDestroy(self)
  self.emptyTipN = nil
  self.packageScrollViewN = nil
  self.packageContentN = nil
  self.descTextN = nil
  self.titleTextN = nil
  self.progress_sliderN = nil
  self.progress_textN = nil
  self.progress_rewards_itemN = nil
  self.remainTimeTextN = nil
end

local function DataDefine(self)
  self.itemIndex = 1
  self.hasInitPacks = false
  self.initRewardTargets = false
  
  function self.timer_action()
    self:RefreshTime()
  end
end

local function DataDestroy(self)
  self.itemIndex = nil
  self.hasInitPacks = nil
  self.initRewardTargets = nil
  self.timer_action = nil
end

local function OnRefreshAll(self)
  self:RefreshAll()
end

local function RefreshStageInfo(self)
  self:RefreshStageData()
  self:RefreshSlider()
  self:RefreshTargetText()
  self:SetClaimRewardState()
end

local function RefreshStageData(self)
  self.stages = DataCenter.DailyMustBuyManager:GetStages()
end

local function ReInit(self, rechargeId)
  self.rechargeId = rechargeId
  if self.rechargeId then
    self.rechargeData = WelfareController.getShowTagInfoById(self.rechargeId)
  end
  self:RefreshStageData()
  if table.IsNullOrEmpty(self.stages) then
    DataCenter.DailyMustBuyManager:RequestClaimedReward()
    return
  end
  self:RefreshAll()
end

local function RefreshAll(self)
  self:RefreshStageInfo()
  self:RefreshPackages()
end

local function RefreshPackages(self)
  self.packageList = {}
  if self.rechargeData then
    self.packageList = self.rechargeData:getInfo()
  end
  if #self.packageList == 0 then
    self.packageScrollViewN:SetActive(false)
    self.emptyTipN:SetActive(true)
    return
  else
    self.packageScrollViewN:SetActive(true)
    self.emptyTipN:SetActive(false)
  end
  if self.hasInitPacks then
    self.packageScrollViewN:SetListItemCount(#self.packageList, false, false)
    self.packageScrollViewN:RefreshAllShownItem()
  else
    self.packageScrollViewN:SetListItemCount(#self.packageList, false, false)
    self.hasInitPacks = true
  end
end

local function ClearScroll(self)
  self.packageContentN:RemoveComponents(UILWDailyMustBuyPackItem)
  self.packageScrollViewN:ClearAllItems()
end

local function RefreshTime(self)
  if not self.nextWeekDayTime then
    self.nextWeekDayTime = UITimeManager:GetInstance():GetNextWeekDay(1)
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.nextWeekDayTime - curTime
  if remainTime <= 0 then
    self.nextWeekDayTime = UITimeManager:GetInstance():GetNextWeekDay(1)
    remainTime = self.nextWeekDayTime - curTime
  end
  self.remainTimeTextN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(0.8, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function OnEnable(self)
  base.OnEnable(self)
  self:AddTimer()
  self:RefreshTime()
end

local function OnDisable(self)
  self:DeleteTimer()
  base.OnDisable(self)
end

local function RefreshSlider(self)
  local curScore = DataCenter.DailyMustBuyManager:GetCurScore()
  local progress = 0
  local step = 1 / #self.stages
  for i, v in pairs(self.stages) do
    if curScore < v.score then
      progress = progress + curScore / v.score * step
      break
    else
      progress = progress + step
    end
  end
  progress = 1 < progress and 1 or progress
  self.progress_sliderN:SetValue(progress)
end

local function RefreshTargetText(self)
  if not self.stages then
    self.progress_textN:SetText("")
    return
  end
  local nextStage
  for i, v in pairs(self.stages) do
    if v.state == 0 then
      nextStage = v
      break
    end
  end
  if not nextStage then
    self.progress_textN:SetText("")
    return
  end
  local curScore = DataCenter.DailyMustBuyManager:GetCurScore()
  self.progress_textN:SetText(string.format("%d/%d", curScore, nextStage.score))
end

local function SetClaimRewardState(self)
  if not self.stages then
    for i = 1, #self.progress_rewards_itemN do
      self.progress_rewards_itemN[i]:SetActive(false)
    end
    return
  end
  if not self.initRewardTargets then
    for i = 1, #self.progress_rewards_itemN do
      self.progress_rewards_itemN[i]:SetActive(true)
      self.progress_rewards_itemN[i]:SetItem(self.stages[i])
    end
    self.initRewardTargets = true
  end
  for i, v in pairs(self.progress_rewards_itemN) do
    local stage = self.stages[i]
    self.progress_rewards_itemN[i]:RefreshData(stage)
  end
end

UILWDailyMustBuyMain.OnCreate = OnCreate
UILWDailyMustBuyMain.OnDestroy = OnDestroy
UILWDailyMustBuyMain.OnAddListener = OnAddListener
UILWDailyMustBuyMain.OnRemoveListener = OnRemoveListener
UILWDailyMustBuyMain.ComponentDefine = ComponentDefine
UILWDailyMustBuyMain.ComponentDestroy = ComponentDestroy
UILWDailyMustBuyMain.DataDefine = DataDefine
UILWDailyMustBuyMain.DataDestroy = DataDestroy
UILWDailyMustBuyMain.ReInit = ReInit
UILWDailyMustBuyMain.OnRefreshAll = OnRefreshAll
UILWDailyMustBuyMain.RefreshAll = RefreshAll
UILWDailyMustBuyMain.RefreshPackages = RefreshPackages
UILWDailyMustBuyMain.ClearScroll = ClearScroll
UILWDailyMustBuyMain.OnGetItemByIndex = OnGetItemByIndex
UILWDailyMustBuyMain.OnEnable = OnEnable
UILWDailyMustBuyMain.OnDisable = OnDisable
UILWDailyMustBuyMain.RefreshSlider = RefreshSlider
UILWDailyMustBuyMain.RefreshTargetText = RefreshTargetText
UILWDailyMustBuyMain.RefreshStageData = RefreshStageData
UILWDailyMustBuyMain.SetClaimRewardState = SetClaimRewardState
UILWDailyMustBuyMain.RefreshStageInfo = RefreshStageInfo
UILWDailyMustBuyMain.RefreshTime = RefreshTime
UILWDailyMustBuyMain.AddTimer = AddTimer
UILWDailyMustBuyMain.DeleteTimer = DeleteTimer
return UILWDailyMustBuyMain
