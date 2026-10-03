local Localization = CS.GameEntry.Localization
local LWUIGoldTreeThirdView = BaseClass("LWUIGoldTreeThirdView", UIBaseView)
local base = UIBaseView
local LWUIGoldTreeThirdAuto = require("UI.LWSeason4.LWUIGoldTreeThird.Auto.LWUIGoldTreeThirdAuto")

function LWUIGoldTreeThirdView:OnCreate()
  base.OnCreate(self)
  self.binder = LWUIGoldTreeThirdAuto.New()
  self.binder:bind(self)
  self.btn_infobtn:SetOnClick(BindCallback(self, self.ClickInfo))
  self.g_bottom.btn_recordbtn:SetOnClick(BindCallback(self, self.ClickRank))
  self.g_bottom.btn_btnback:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.g_bottom.btn_LotteryHelp:SetOnClick(BindCallback(self, self.ClickLotteryHelp))
  self.btn_time_info:SetOnClick(BindCallback(self, self.ClickTimeHelp))
  self.btn_spine:SetOnClick(BindCallback(self, self.ClickSpine))
  self.spineBubbleIndex = 1
  self:InitUI()
  DataCenter.SeasonGoldTreeThirdManager:RequestGoldTreeGetAllianceCardView(true)
  UIUtil.CheckEventTrigger(OpMode.ClickGoldTreeThird)
end

function LWUIGoldTreeThirdView:OnDestroy()
  self.binder:unbind(self)
  self.binder = nil
  self.spineBubbleIndex = nil
  self.bubbleList = nil
  base.OnDestroy(self)
end

function LWUIGoldTreeThirdView:OnEnable()
  base.OnEnable(self)
  self:RefreshUI()
end

function LWUIGoldTreeThirdView:OnAddListener()
  self:AddUIListener(EventId.LWUIGoldTreeThirdESC, self.OnLWUIGoldTreeThirdESC)
  self:AddUIListener(EventId.GoldTreeThirdGetCardData, self.OnGoldTreeThirdGetCardData)
  self:AddUIListener(EventId.GoldTreeThirdBuyLottery, self.OnGoldTreeThirdBuyLottery)
  self:AddUIListener(EventId.GoldTreeTreeHideName, self.OnGoldTreeTreeHideName)
  self:AddUIListener(EventId.GoldTreeThirdError, self.OnGoldTreeThirdError)
  self:AddUIListener(EventId.OnUnDelayPassDay, self.OnOnUnDelayPassDay)
  base.OnAddListener(self)
end

function LWUIGoldTreeThirdView:OnRemoveListener()
  self:RemoveUIListener(EventId.LWUIGoldTreeThirdESC, self.OnLWUIGoldTreeThirdESC)
  self:RemoveUIListener(EventId.GoldTreeThirdGetCardData, self.OnGoldTreeThirdGetCardData)
  self:RemoveUIListener(EventId.GoldTreeThirdBuyLottery, self.OnGoldTreeThirdBuyLottery)
  self:RemoveUIListener(EventId.GoldTreeTreeHideName, self.OnGoldTreeTreeHideName)
  self:RemoveUIListener(EventId.GoldTreeThirdError, self.OnGoldTreeThirdError)
  self:RemoveUIListener(EventId.OnUnDelayPassDay, self.OnOnUnDelayPassDay)
  base.OnRemoveListener(self)
end

function LWUIGoldTreeThirdView:OnLWUIGoldTreeThirdESC()
  if self.bind_lwuigoldtreeinfo:GetActive() then
    self.bind_lwuigoldtreeinfo:SetActive(false)
  else
    self.ctrl:CloseSelf()
  end
end

function LWUIGoldTreeThirdView:OnGoldTreeThirdGetCardData(weekIndex)
  self:RefreshUI()
end

function LWUIGoldTreeThirdView:OnGoldTreeThirdBuyLottery()
end

function LWUIGoldTreeThirdView:OnGoldTreeTreeHideName()
end

function LWUIGoldTreeThirdView:OnGoldTreeThirdError(msg)
  if msg == MsgDefines.GoldTreeGetAllianceCardView then
    self.ctrl:CloseSelf()
  end
end

function LWUIGoldTreeThirdView:OnOnUnDelayPassDay()
  local weekIndex = UITimeManager:GetInstance():GetNowWeekdayIndex()
  self.showEndTime = weekIndex ~= 1 and weekIndex ~= 7
  self.timemodule:SetActive(self.showEndTime)
  self.g_bottom.time_tip:SetActive(not self.showEndTime)
end

function LWUIGoldTreeThirdView:CheckBubble()
end

function LWUIGoldTreeThirdView:InitUI()
  local data = DataCenter.SeasonGoldTreeManager:GetActivityData()
  if data == nil then
    return
  end
  self.StartTime = data.startTime
  if DataCenter.SeasonGoldTreeThirdManager:Active() then
    self.weekEndTime = DataCenter.SeasonGoldTreeThirdManager:GetWeekEndTime()
  end
  if SeasonUtil.IsInSeasonPrepareMode() then
    self.EndTime = DataCenter.SeasonDataManager.nextSeasonStartTime
  else
    self.EndTime = data.endTime
  end
  self:Update1000MS()
end

function LWUIGoldTreeThirdView:RefreshUI()
  UIUtil.CheckEventTrigger(OpMode.ClickBtnWorldSupplies)
  local bugCount, rewardCount = DataCenter.SeasonGoldTreeThirdManager:GetNpcNextRewardData()
  local allRewardCount = DataCenter.SeasonGoldTreeThirdManager:GetAllLotteryRewardCount()
  if bugCount ~= nil then
    self.txt_bubble:SetLocalText("season_golden_tree_phase_third_UI_4", bugCount, rewardCount)
  else
    self.txt_bubble:SetLocalText("season_golden_tree_phase_third_UI_5", DataCenter.SeasonGoldTreeThirdManager:GetBugLotteryCount(), allRewardCount)
  end
  local lotteryPoolData = DataCenter.SeasonGoldTreeThirdManager:GetCurrentLotteryPoolData()
  if lotteryPoolData ~= nil then
    for index = 1, #self.g_center.mul_bind_rankcontent do
      self.g_center.mul_bind_rankcontent[index]:SetData(index, lotteryPoolData)
      self.g_center.mul_bind_rankcontent[index]:RefreshUI()
    end
  end
  self.g_center.txt_rewardCount:SetText(allRewardCount)
  local lotteryData, buyData = DataCenter.SeasonGoldTreeThirdManager:GetSelfLottery()
  local buyCount = 0
  for k, v in ipairs(lotteryData) do
    if v.hasBuy then
      buyCount = buyCount + 1
    end
  end
  self.g_bottom.txt_LotteryCount:SetLocalText("season_golden_tree_phase_third_UI_15", buyCount)
  local hasBuy = buyCount ~= 0
  local showBuy = hasBuy or buyData == nil
  self.g_bottom.buy:SetActive(showBuy)
  self.g_bottom.notbuy:SetActive(not showBuy)
  if showBuy then
    for index = 1, #self.g_bottom.mul_bind_content do
      self.g_bottom.mul_bind_content[index]:SetData(lotteryData[index])
      self.g_bottom.mul_bind_content[index]:RefreshUI()
    end
  else
    self.g_bottom.bind_lwuigoldlotteryitem5:SetData(buyData)
    self.g_bottom.bind_lwuigoldlotteryitem5:RefreshUI()
  end
  self.g_bottom.btn_recordbtn:SetActive(1 <= DataCenter.SeasonGoldTreeThirdManager:GetPrayWeek())
  self:OnOnUnDelayPassDay()
  self:CheckBubble()
end

function LWUIGoldTreeThirdView:Update1000MS()
  if self.showEndTime then
    UIUtil.SetLeftTimeText(self.txt_lotterytime, nil, self.weekEndTime)
  end
  if self.StartTime ~= nil and self.EndTime ~= nil then
    UIUtil.SetLeftTimeText(self.txt_remain, self.StartTime, self.EndTime)
  end
end

function LWUIGoldTreeThirdView:ClickInfo()
  if not DataCenter.SeasonGoldTreeThirdManager:Active() then
    UIUtil.ShowTipsId(370100)
    return
  end
  local config = DataCenter.SeasonGoldTreeThirdManager:GetGoldTreeThirdConfig()
  if config ~= nil then
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(config.help)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function LWUIGoldTreeThirdView:ClickRank()
  if not DataCenter.SeasonGoldTreeThirdManager:Active() then
    UIUtil.ShowTipsId(370100)
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIGoldTreeRecord, {anim = true})
end

function LWUIGoldTreeThirdView:ClickLotteryHelp()
  if not DataCenter.SeasonGoldTreeThirdManager:Active() then
    UIUtil.ShowTipsId(370100)
    return
  end
  UIUtil.ShowBubbleTipsAuto(Localization:GetString("season_golden_tree_phase_third_UI_19"), self.g_bottom.btn_LotteryHelp.transform.position, 0, 42, -150, nil, nil, {reversal = true})
end

function LWUIGoldTreeThirdView:ClickTimeHelp()
  if not DataCenter.SeasonGoldTreeThirdManager:Active() then
    UIUtil.ShowTipsId(370100)
    return
  end
  UIUtil.ShowBubbleTipsAuto(Localization:GetString("season_golden_tree_phase_third_UI_40"), self.btn_time_info.transform.position, 15, 42, -150, nil, nil, {reversal = true})
end

function LWUIGoldTreeThirdView:ClickCardHelp(data, index)
  self.bind_lwuigoldtreeinfo:SetData(data, index)
  self.bind_lwuigoldtreeinfo:SetActive(true)
end

function LWUIGoldTreeThirdView:ClickSpine()
  self.spineBubbleIndex = self.spineBubbleIndex + 1
  local config = DataCenter.SeasonGoldTreeThirdManager:GetGoldTreeThirdConfig()
  if #config.dialogueLoop == 0 then
    return
  end
  self.anim_bubble:Stop()
  self.anim_bubble:Play("Default")
  self.spineBubbleIndex = self.spineBubbleIndex % (#config.dialogueLoop + 1)
  if self.spineBubbleIndex == 1 then
    self:SetDefaultBubble()
  elseif self.spineBubbleIndex == 0 then
    self.txt_bubble:SetLocalText(config.dialogueLoop[#config.dialogueLoop])
  else
    self.txt_bubble:SetLocalText(config.dialogueLoop[self.spineBubbleIndex - 1])
  end
end

function LWUIGoldTreeThirdView:SetDefaultBubble()
  local bugCount, rewardCount = DataCenter.SeasonGoldTreeThirdManager:GetNpcNextRewardData()
  local allRewardCount = DataCenter.SeasonGoldTreeThirdManager:GetAllLotteryRewardCount()
  if bugCount ~= nil then
    self.txt_bubble:SetLocalText("season_golden_tree_phase_third_UI_4", bugCount, rewardCount)
  else
    self.txt_bubble:SetLocalText("season_golden_tree_phase_third_UI_5", DataCenter.SeasonGoldTreeThirdManager:GetBugLotteryCount(), allRewardCount)
  end
end

return LWUIGoldTreeThirdView
