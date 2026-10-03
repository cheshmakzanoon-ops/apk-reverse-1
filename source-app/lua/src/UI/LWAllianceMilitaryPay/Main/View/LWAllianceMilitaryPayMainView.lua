local LWAllianceMilitaryPayMainView = BaseClass("LWAllianceMilitaryPayMainView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local DailyContentComponent = require("UI.LWAllianceMilitaryPay.Main.Component.DailyContentComponent")
local TaskItem = require("UI/LWAllianceMilitaryPay/Main/Component/TaskItemComponent")
local RewardItem = require("UI/LWAllianceMilitaryPay/Main/Component/MilitaryPayRewardItem")
local BoxItem = require("UI/LWAllianceMilitaryPay/Main/Component/LWBoxRewardComponent")
local BoxItemSpecial = require("UI/LWAllianceMilitaryPay/Main/Component/LWBoxRewardSpecialComponent")
local RewardUtil = require("Util.RewardUtil")
local Setting = CS.GameEntry.Setting
local UIGray = CS.UIGray

function LWAllianceMilitaryPayMainView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:SetRankBtnState()
  DataCenter.AllianceMilitaryPayDataManager:SendAllianceSalaryGainActivityInfo()
end

function LWAllianceMilitaryPayMainView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWAllianceMilitaryPayMainView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnPersonalReward = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnPersonalReward:SetOnClick(function()
    self:OnBtnPersonalRewardClick()
  end)
  self.imgPersonalFill = self.viewSkin:AddComponent(self, UIImage, 4)
  self.textPersonalScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.imgPersonalBox = self.viewSkin:AddComponent(self, UIImage, 6)
  self.compDailyContent = self.viewSkin:AddComponent(self, DailyContentComponent, 7)
  self.loopListView2RewardScroll = self.viewSkin:AddComponent(self, UILoopListView2, 8)
  self.compRewardContent = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.btnLeft = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnLeft:SetOnClick(function()
    self:OnBtnLeftClick()
  end)
  self.btnRight = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnRight:SetOnClick(function()
    self:OnBtnRightClick()
  end)
  self.scrollViewRewardView = self.viewSkin:AddComponent(self, UIScrollView, 13)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 14)
  self.scrollViewTaskView = self.viewSkin:AddComponent(self, UIScrollView, 15)
  self.compTaskContent = self.viewSkin:AddComponent(self, UIBaseContainer, 16)
  self.btnAlliance = self.viewSkin:AddComponent(self, UIButton, 17)
  self.btnAlliance:SetOnClick(function()
    self:OnBtnAllianceClick()
  end)
  self.textBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 19)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.btnRewardPreview = self.viewSkin:AddComponent(self, UIButton, 20)
  self.btnRewardPreview:SetOnClick(function()
    self:OnBtnRewardPreviewClick()
  end)
  self.btnRank = self.viewSkin:AddComponent(self, UIButton, 21)
  self.btnRank:SetOnClick(function()
    self:OnBtnRankClick()
  end)
  self.txtDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 22)
  self.compShareInfo = self.viewSkin:AddComponent(self, UIBaseContainer, 23)
  self.btnShare = self.viewSkin:AddComponent(self, UIButton, 24)
  self.btnShare:SetOnClick(function()
    self:OnBtnShareClick()
  end)
  self.txtShareCountDown = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 25)
  self.btnDailyContentMask = self.viewSkin:AddComponent(self, UIButton, 26)
  self.btnDailyContentMask:SetOnClick(function()
    self:OnBtnDailyContentMaskClick()
  end)
  self.compEffect = self.viewSkin:AddComponent(self, UIBaseContainer, 27)
  self.animatorPersonalReward = self.viewSkin:AddComponent(self, UIAnimator, 28)
  self.textTitle:SetLocalText("alliance_pay_title")
  self.scrollViewTaskView:SetOnItemMoveIn(function(itemObj, index)
    self:OnTaskItemMoveIn(itemObj, index)
  end)
  self.scrollViewTaskView:SetOnItemMoveOut(function(itemObj, index)
    self:OnTaskItemMoveOut(itemObj, index)
  end)
  self.scrollViewRewardView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.scrollViewRewardView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
  self.loopListView2RewardScroll:InitListView(0, function(listView, index)
    return self:OnGetItemByIndex(listView, index)
  end)
  self.loopListView2RewardScroll:SetOnSnapItemFinished(function(listView, item)
    self:OnItemSnapFinish(listView, item)
  end)
  self.loopListView2RewardScroll:SetOnSnapNearestChanged(function(listView, item)
    self:OnItemSnapNearestChanged(listView, item)
  end)
  self.compDailyContent:SetActive(false)
end

function LWAllianceMilitaryPayMainView:ComponentDestroy()
  self:ClearTaskScroll()
  self:ClearRewardScroll()
  self:ClearBoxScroll()
  self.viewSkin = nil
  self.btnInfo = nil
  self.textTitle = nil
  self.btnPersonalReward = nil
  self.imgPersonalFill = nil
  self.textPersonalScore = nil
  self.imgPersonalBox = nil
  self.compDailyContent = nil
  self.loopListView2RewardScroll = nil
  self.compRewardContent = nil
  self.textName = nil
  self.btnLeft = nil
  self.btnRight = nil
  self.scrollViewRewardView = nil
  self.compContent = nil
  self.scrollViewTaskView = nil
  self.compTaskContent = nil
  self.btnAlliance = nil
  self.textBtn = nil
  self.btnBack = nil
  self.btnRewardPreview = nil
  self.btnRank = nil
  self.txtDesc = nil
  self.compShareInfo = nil
  self.btnShare = nil
  self.txtShareCountDown = nil
  self.btnDailyContentMask = nil
  self.compEffect = nil
  self.animatorPersonalReward = nil
end

function LWAllianceMilitaryPayMainView:DataDefine()
  self.curSelectTemplateId = 0
  self.curSelectIndex = 1
  self.itemIndex = 0
  self.isShowDailyContent = false
  self.isShowEndMessageTips = false
end

function LWAllianceMilitaryPayMainView:DataDestroy()
  self.data = nil
  self.isShowEndMessageTips = nil
end

function LWAllianceMilitaryPayMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnAllianceMilitaryPayGetActivityInfo, self.OnGetAllianceMilitaryPayInfo)
  self:AddUIListener(EventId.OnPassDay, self.OnPassDay)
  self:AddUIListener(EventId.OnAllianceMilitaryPayGetReward, self.OnAllianceMilitaryPayGetReward)
  self:AddUIListener(EventId.OnAllianceMilitaryShareSuccess, self.OnShareSuccess)
  self:AddUIListener(EventId.OnRewardGetPanelClose, self.OnGiftRewardGetClose)
end

function LWAllianceMilitaryPayMainView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnAllianceMilitaryPayGetActivityInfo, self.OnGetAllianceMilitaryPayInfo)
  self:RemoveUIListener(EventId.OnPassDay, self.OnPassDay)
  self:RemoveUIListener(EventId.OnAllianceMilitaryPayGetReward, self.OnAllianceMilitaryPayGetReward)
  self:RemoveUIListener(EventId.OnAllianceMilitaryShareSuccess, self.OnShareSuccess)
  self:RemoveUIListener(EventId.OnRewardGetPanelClose, self.OnGiftRewardGetClose)
  base.OnRemoveListener(self)
end

function LWAllianceMilitaryPayMainView:OnGetAllianceMilitaryPayInfo()
  self.data = DataCenter.AllianceMilitaryPayDataManager:GetAllianceMilitaryPayInfo()
  if not self.data then
    return
  end
  self.boxList = self.data.weeklySalaryInfo
  local isR4orR5 = DataCenter.AllianceBaseDataManager:IsR4orR5()
  self.showBoxList = {}
  for i, boxData in ipairs(self.boxList) do
    local template = DataCenter.AlliancePayTemplateManager:GetTemplate(boxData.configId)
    if template.show_type == AllianceSalaryRewardShowType.R4orR5 and isR4orR5 then
      table.insert(self.showBoxList, boxData)
    elseif template.show_type == AllianceSalaryRewardShowType.All then
      table.insert(self.showBoxList, boxData)
    end
  end
  if self.curSelectTemplateId == 0 and #self.showBoxList > 0 then
    self.curSelectIndex = self:GetNeedSelectBox()
    self.curSelectTemplateId = self.showBoxList[self.curSelectIndex].configId
  end
  self:RefreshBoxScrollView()
  self.compDailyContent:SetData(self.data)
  self:RefreshDailyProgress()
  self:CheckNeedShowUpgradeWindow()
end

function LWAllianceMilitaryPayMainView:OnBtnInfoClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, {
    howToPlayList = {101011}
  })
end

function LWAllianceMilitaryPayMainView:OnBtnPersonalRewardClick()
  local hasGot = DataCenter.AllianceMilitaryPayDataManager:HasGotDailySalary()
  if hasGot then
    local nextDay = UITimeManager:GetInstance():GetTomorrowZero()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local leftTime = math.max(nextDay - curTime, 0)
    local leftTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
    UIUtil.ShowTips(Localization:GetString("alliance_pay_desc_resetCD", leftTimeStr))
    return
  end
  local canGet = DataCenter.AllianceMilitaryPayDataManager:CanGetDailySalary()
  if canGet then
    self.animatorPersonalReward:Play("V_ui_btnPersonalReward_box_open")
    DataCenter.AllianceMilitaryPayDataManager:GetAllianceSalaryGainReward(101)
    return
  end
  self.isShowDailyContent = not self.isShowDailyContent
  self.compDailyContent:SetActive(self.isShowDailyContent)
  if self.isShowDailyContent then
    self.compDailyContent:RefreshRewardScrollView()
  end
end

function LWAllianceMilitaryPayMainView:OnBtnLeftClick()
  local index = self.curSelectIndex - 1
  if 1 <= index then
    self.loopListView2RewardScroll:SetSnapTargetItemIndex(index - 1)
  end
end

function LWAllianceMilitaryPayMainView:OnBtnRightClick()
  local index = self.curSelectIndex + 1
  if index <= table.count(self.showBoxList) then
    self.loopListView2RewardScroll:SetSnapTargetItemIndex(index - 1)
  end
end

function LWAllianceMilitaryPayMainView:OnBtnAllianceClick()
  if self.isScoreNotEnough then
    GoToUtil.GotoOpenView(UIWindowNames.UILWQuestList, UIQuestTab.Daily)
    return
  end
  EventManager:GetInstance():Broadcast(EventId.OpenAllianceMilitaryBox, self.curSelectTemplateId)
  DataCenter.LWSoundManager:PlaySound(90121)
  TimerManager:DelayInvoke(function()
    DataCenter.AllianceMilitaryPayDataManager:GetAllianceSalaryGainReward(self.curSelectTemplateId)
  end, 0.8)
end

function LWAllianceMilitaryPayMainView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

function LWAllianceMilitaryPayMainView:RefreshDailyProgress()
  local curScore = DataCenter.AllianceMilitaryPayDataManager:GetCurDailySalaryScore()
  local maxScore = DataCenter.AllianceMilitaryPayDataManager:GetMaxDailySalaryScore()
  local progress = math.min(curScore / maxScore, 1)
  self.imgPersonalFill:SetFillAmount(progress)
  if curScore < maxScore then
    self.textPersonalScore:SetText(string.format("<color=#F97077>%d</color>/%d", curScore, maxScore))
    self.imgPersonalBox:LoadSprite(string.format(LoadPath.LWAllianceMilitaryPayIconPath, "item550004"))
    self.animatorPersonalReward:Play("V_ui_btnPersonalReward_box_close_idle")
  else
    self.textPersonalScore:SetText(string.format("<color=#5FEF87>%d</color>/%d", curScore, maxScore))
    local hasGot = DataCenter.AllianceMilitaryPayDataManager:HasGotDailySalary()
    self.imgPersonalBox:LoadSprite(string.format(LoadPath.LWAllianceMilitaryPayIconPath, hasGot and "item550004_kai" or "item550004"))
    if hasGot then
      self.animatorPersonalReward:Play("V_ui_btnPersonalReward_box_open_idle")
    else
      self.animatorPersonalReward:Play("V_ui_btnPersonalReward_box_full")
    end
  end
end

function LWAllianceMilitaryPayMainView:RefreshTaskScrollView()
  if #self.conditionList > 0 then
    self.scrollViewTaskView:SetTotalCount(#self.conditionList)
    self.scrollViewTaskView:RefillCells()
  end
end

function LWAllianceMilitaryPayMainView:OnTaskItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollViewTaskView:AddComponent(TaskItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(self.conditionList[index], self.data)
  end
end

function LWAllianceMilitaryPayMainView:OnTaskItemMoveOut(itemObj, index)
  self.scrollViewTaskView:RemoveComponent(itemObj.name, TaskItem)
end

function LWAllianceMilitaryPayMainView:ClearTaskScroll()
  self.scrollViewTaskView:ClearCells()
  self.scrollViewTaskView:RemoveComponents(TaskItem)
end

function LWAllianceMilitaryPayMainView:RefreshRewardScrollView()
  if #self.rewardList > 0 then
    self.scrollViewRewardView:SetTotalCount(#self.rewardList)
    self.scrollViewRewardView:RefillCells()
  end
end

function LWAllianceMilitaryPayMainView:OnRewardItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollViewRewardView:AddComponent(RewardItem, itemObj)
  if cellItem ~= nil then
    local hasGot = self.curStatus == SalaryStatus.HasGot
    self.rewardList[index].isShowReceFlag = hasGot
    cellItem:ReInit(self.rewardList[index])
  end
end

function LWAllianceMilitaryPayMainView:OnRewardItemMoveOut(itemObj, index)
  self.scrollViewRewardView:RemoveComponent(itemObj.name, RewardItem)
end

function LWAllianceMilitaryPayMainView:ClearRewardScroll()
  self.scrollViewRewardView:ClearCells()
  self.scrollViewRewardView:RemoveComponents(RewardItem)
end

function LWAllianceMilitaryPayMainView:RefreshBoxScrollView()
  local count = #self.showBoxList
  if 0 < count then
    self.loopListView2RewardScroll:SetListItemCount(count, false, false)
    self.loopListView2RewardScroll:RefreshAllShownItem()
    self.loopListView2RewardScroll:MovePanelToItemIndex(self.curSelectIndex - 1, 0)
    self:RefreshCurBoxInfo()
    self:RefreshLeftRightBtnState()
  end
end

function LWAllianceMilitaryPayMainView:OnGetItemByIndex(loopScroll, index)
  local count = table.count(self.showBoxList)
  index = index + 1
  if index < 1 or count < index then
    return nil
  end
  local templateId = self.showBoxList[index].configId
  local template = DataCenter.AlliancePayTemplateManager:GetTemplate(templateId)
  local color = template.boxColor
  local script, item
  if color == -1 then
    item = loopScroll:NewListViewItem("LWBoxRewardSpecial")
    script = self.compRewardContent:GetComponent(item.gameObject.name, BoxItemSpecial)
  else
    item = loopScroll:NewListViewItem("LWBoxReward")
    script = self.compRewardContent:GetComponent(item.gameObject.name, BoxItem)
  end
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    local boxScriptType = color == -1 and BoxItemSpecial or BoxItem
    script = self.compRewardContent:AddComponent(boxScriptType, objectName)
  end
  script:SetActive(true)
  local isSelect = templateId == self.curSelectTemplateId
  script:SetData(template, isSelect, self.showBoxList[index])
  return item
end

function LWAllianceMilitaryPayMainView:OnItemSnapNearestChanged(loopScroll, item)
  self.curSelectIndex = item.ItemIndex + 1
  self:RefreshCurBoxInfo()
  self:RefreshLeftRightBtnState()
  EventManager:GetInstance():Broadcast(EventId.UpdateAllianceMilitarySelect, self.curSelectTemplateId)
end

function LWAllianceMilitaryPayMainView:OnItemSnapFinish(loopScroll, item)
end

function LWAllianceMilitaryPayMainView:RefreshCurBoxInfo()
  if self.curSelectIndex < 1 or self.curSelectIndex > table.count(self.showBoxList) then
    return
  end
  local curBoxInfo = self.showBoxList[self.curSelectIndex]
  self.curStatus = curBoxInfo.status
  self.curSelectTemplateId = curBoxInfo.configId
  local rewardId = DataCenter.AlliancePayTemplateManager:GetRewardIdByGiftLevel(self.curSelectTemplateId, self.data.giftLevel)
  self.rewardList = RewardUtil.GetRewardItem(rewardId)
  self:RefreshRewardScrollView()
  local template = DataCenter.AlliancePayTemplateManager:GetTemplate(self.curSelectTemplateId)
  self.conditionList = template.conditionTable2
  self:RefreshTaskScrollView()
  self.militaryLevel = DataCenter.AllianceMilitaryPayDataManager:GetMilitaryLevelByGiftLevel(self.data.giftLevel)
  self.textName:SetLocalText(template.name, self.militaryLevel)
  self.isScoreNotEnough = false
  self.isAllianceScoreNotEnough = false
  self.isR4R5DaysNotEnough = false
  self.isGotAllianceSalary = false
  self.btnAlliance:SetActive(false)
  if self.curStatus == SalaryStatus.NotAchieved then
    local conditions = self.conditionList
    for i, condition in ipairs(conditions) do
      local type = condition[1]
      local value = condition[2]
      if type == AllianceSalaryConditionType.WeeklyAllianceScore then
        local curAllianceScore = self.data.weeklyAllianceSalary or 0
        if value > curAllianceScore then
          self.isScoreNotEnough = true
          self.isAllianceScoreNotEnough = true
        end
      elseif type == AllianceSalaryConditionType.WeeklyPersonalScore then
        local curPersonalScore = self.data.weeklyUserSalary or 0
        if value > curPersonalScore then
          self.isScoreNotEnough = true
        end
      elseif type == AllianceSalaryConditionType.R4R5Days then
        local curDutyDays = self.data.dutyDaysPerWeek or 0
        if value > curDutyDays then
          self.isR4R5DaysNotEnough = true
        end
      end
      if self.isScoreNotEnough or self.isR4R5DaysNotEnough then
        break
      end
    end
    if self.isScoreNotEnough then
      self.btnAlliance:SetActive(true)
      self.textBtn:SetLocalText("alliance_pay_btn_getPoint")
    elseif self.isR4R5DaysNotEnough then
      self.txtDesc:SetLocalText("alliance_pay_desc_rankTime")
    end
  elseif self.curStatus == SalaryStatus.CanGet then
    self.textBtn:SetLocalText(2000441)
    self.btnAlliance:SetActive(true)
  elseif self.curStatus == SalaryStatus.HasGot then
    self.isGotAllianceSalary = true
  end
  if not self.isR4R5DaysNotEnough and not self.isGotAllianceSalary then
    self.txtDesc:SetText("")
  end
  if template.share_condition and 0 < template.share_condition and self:IsR5OrWarCommander() and self.isAllianceScoreNotEnough then
    self.compShareInfo:SetActive(true)
    if self.data.canShared then
      UIGray.SetGray(self.btnShare.transform, false, true)
    else
      UIGray.SetGray(self.btnShare.transform, true, false)
    end
  else
    self.compShareInfo:SetActive(false)
  end
  self:Update1000MS()
end

function LWAllianceMilitaryPayMainView:Update1000MS()
  if not self.data then
    return
  end
  if self.isShowEndMessageTips then
    return
  end
  local state = DataCenter.AllianceMilitaryPayDataManager:GetActivityState()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if state == SalaryActivityState.Open then
    local actEndTime = DataCenter.AllianceMilitaryPayDataManager:GetActivityEndTime()
    if actEndTime and curTime >= actEndTime then
      local function closeFunc()
        GoToUtil.CloseAllWindows()
      end
      
      self.isShowEndMessageTips = true
      UIUtil.ShowMessage(Localization:GetString("370100"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, closeFunc, closeFunc, closeFunc, "2900005")
      return
    end
  end
  if self.isR4R5DaysNotEnough then
    local timeTomorrowZero = UITimeManager:GetInstance():GetTomorrowZero()
    local leftTime = math.max(timeTomorrowZero - curTime, 0)
    local leftTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
    self.txtDesc:SetLocalText("alliance_pay_desc_rankTime", leftTimeStr)
  elseif self.isGotAllianceSalary then
    local nextWeek = UITimeManager:GetInstance():GetNextWeekDay(1)
    local leftTime = math.max(nextWeek - curTime, 0)
    local leftTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
    self.txtDesc:SetLocalText("alliance_pay_desc_resetCD", leftTimeStr)
  end
  if self:IsR5OrWarCommander() and not self.data.canShared then
    local refreshTime = UITimeManager:GetInstance():GetTomorrowZero()
    local leftTime = math.max(refreshTime - curTime, 0)
    local leftTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
    self.txtShareCountDown:SetText(leftTimeStr)
  else
    self.txtShareCountDown:SetText("")
  end
end

function LWAllianceMilitaryPayMainView:RefreshLeftRightBtnState()
  if self.curSelectIndex == 1 then
    self.btnLeft:SetActive(false)
    self.btnRight:SetActive(true)
  elseif self.curSelectIndex == table.count(self.showBoxList) then
    self.btnLeft:SetActive(true)
    self.btnRight:SetActive(false)
  else
    self.btnLeft:SetActive(true)
    self.btnRight:SetActive(true)
  end
end

function LWAllianceMilitaryPayMainView:ClearBoxScroll()
  self.compRewardContent:RemoveComponents(BoxItem)
  self.compRewardContent:RemoveComponents(BoxItemSpecial)
  self.loopListView2RewardScroll:ClearAllItems()
end

function LWAllianceMilitaryPayMainView:OnPassDay()
  DataCenter.AllianceMilitaryPayDataManager:OnPassDay()
  DataCenter.AllianceMilitaryPayDataManager:SendAllianceSalaryGainActivityInfo()
  UIGray.SetGray(self.btnShare.transform, false, true)
end

function LWAllianceMilitaryPayMainView:OnAllianceMilitaryPayGetReward(configId)
  local template = DataCenter.AlliancePayTemplateManager:GetTemplate(configId)
  if not template then
    return
  end
  if template.type == AllianceSalaryType.DailySalary then
    self.imgPersonalBox:LoadSprite(string.format(LoadPath.LWAllianceMilitaryPayIconPath, "item550004_kai"))
    self.compEffect:SetActive(false)
    return
  end
  for i, boxData in ipairs(self.showBoxList) do
    if boxData.configId == configId then
      boxData.status = SalaryStatus.HasGot
      break
    end
  end
end

function LWAllianceMilitaryPayMainView:OnBtnRewardPreviewClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.AllianceMilitaryRewardPreviewView, {anim = false}, self.data)
end

function LWAllianceMilitaryPayMainView:OnBtnRankClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.AllianceMilitaryPayRank)
end

function LWAllianceMilitaryPayMainView:CheckNeedShowUpgradeWindow()
  local str = LuaEntry.DataConfig:TryGetStr("alliance_pay_config", "k1")
  local arr = string.string2table_ii_toList(str, ";", "|")
  local curGiftLevel = self.data.giftLevel or 0
  local targetLevel = 0
  for i, v in ipairs(arr) do
    local minLevel = v[1] or 0
    local maxLevel = v[2] or 0
    if curGiftLevel >= minLevel and curGiftLevel <= maxLevel then
      targetLevel = i
      break
    end
  end
  local allianceUid = LuaEntry.Player:GetAllianceUid()
  if not allianceUid or allianceUid == 0 then
    return
  end
  local lastLevel = Setting:GetPrivateInt("MilitaryPay" .. allianceUid, 0)
  local curLevel = targetLevel
  if lastLevel == 0 then
    Setting:SetPrivateInt("MilitaryPay" .. allianceUid, curLevel)
  elseif lastLevel < curLevel then
    Setting:SetPrivateInt("MilitaryPay" .. allianceUid, curLevel)
    TimerManager:GetInstance():DelayInvoke(function()
      if self.data then
        UIManager:GetInstance():OpenWindow(UIWindowNames.AllianceMilitaryRewardUpgrade, {anim = false}, {lastLevel = lastLevel, curLevel = curLevel})
      end
    end, 0.5)
  end
end

function LWAllianceMilitaryPayMainView:SetRankBtnState()
  self.btnRank:SetActive(self:IsR5OrWarCommander())
end

function LWAllianceMilitaryPayMainView:IsR5OrWarCommander()
  local officialType = DataCenter.AllianceMemberDataManager:GetOfficialPosByUid(LuaEntry.Player.uid)
  local isWarCommander = officialType == LWAlMemberOffcialType.War_Commander
  return DataCenter.AllianceBaseDataManager:IsR5() or isWarCommander
end

function LWAllianceMilitaryPayMainView:OnBtnShareClick()
  UIUtil.ShowMessage(Localization:GetString("alliance_pay_desc_share"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    DataCenter.AllianceMilitaryPayDataManager:ShareReminder(self.curSelectTemplateId)
  end)
end

function LWAllianceMilitaryPayMainView:OnShareSuccess()
  UIGray.SetGray(self.btnShare.transform, true, false)
end

function LWAllianceMilitaryPayMainView:OnBtnDailyContentMaskClick()
  self.isShowDailyContent = false
  self.compDailyContent:SetActive(false)
end

function LWAllianceMilitaryPayMainView:GetNeedSelectBox()
  if not self.showBoxList or #self.showBoxList == 0 then
    return 1
  end
  local canGetIndex, notAchievedIndex
  local maxOrderIndex = 1
  local maxOrder = 0
  for i, boxData in ipairs(self.showBoxList) do
    local template = DataCenter.AlliancePayTemplateManager:GetTemplate(boxData.configId)
    if boxData.status == SalaryStatus.CanGet then
      if canGetIndex == nil then
        canGetIndex = i
      else
        local currentTemplate = DataCenter.AlliancePayTemplateManager:GetTemplate(self.showBoxList[canGetIndex].configId)
        if template.order < currentTemplate.order then
          canGetIndex = i
        end
      end
    end
    if boxData.status == SalaryStatus.NotAchieved then
      if notAchievedIndex == nil then
        notAchievedIndex = i
      else
        local currentTemplate = DataCenter.AlliancePayTemplateManager:GetTemplate(self.showBoxList[notAchievedIndex].configId)
        if template.order < currentTemplate.order then
          notAchievedIndex = i
        end
      end
    end
    if maxOrder < template.order then
      maxOrder = template.order
      maxOrderIndex = i
    end
  end
  if canGetIndex ~= nil then
    return canGetIndex
  elseif notAchievedIndex ~= nil then
    return notAchievedIndex
  else
    return maxOrderIndex
  end
end

function LWAllianceMilitaryPayMainView:OnGiftRewardGetClose()
  self.curSelectIndex = self:GetNeedSelectBox()
  self.curSelectTemplateId = self.showBoxList[self.curSelectIndex].configId
  self:RefreshBoxScrollView()
end

return LWAllianceMilitaryPayMainView
