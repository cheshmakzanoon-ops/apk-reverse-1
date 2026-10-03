local Localization = CS.GameEntry.Localization
local CommonTabGoupItemTemplate = require("DataCenter.CommonTabGroup.CommonTabGoupItemTemplate")
local LWUIGoldTreeRecordView = BaseClass("LWUIGoldTreeRecordView", UIBaseView)
local base = UIBaseView
local LWUIGoldTreeRecordAuto = require("UI.LWSeason4.LWUIGoldTreeRecord.Auto.LWUIGoldTreeRecordAuto")

function LWUIGoldTreeRecordView:OnCreate()
  base.OnCreate(self)
  self.binder = LWUIGoldTreeRecordAuto.New()
  self.binder:bind(self)
  self.btn_btnback:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btn_helpbtn:SetOnClick(BindCallback(self, self.ClickHelp))
  self:InitUI()
end

function LWUIGoldTreeRecordView:OnDestroy()
  self.binder:unbind(self)
  self.binder = nil
  self.data = nil
  self:OnOnUnDelayPassDay()
  base.OnDestroy(self)
end

function LWUIGoldTreeRecordView:OnAddListener()
  self:AddUIListener(EventId.GoldTreeThirdGetCardData, self.OnGoldTreeThirdGetCardData)
  self:AddUIListener(EventId.GoldTreeThirdError, self.OnGoldTreeThirdError)
  self:AddUIListener(EventId.LWUIGoldTreeRecordESC, self.OnLWUIGoldTreeRecordESC)
  self:AddUIListener(EventId.OnUnDelayPassDay, self.OnOnUnDelayPassDay)
  base.OnAddListener(self)
end

function LWUIGoldTreeRecordView:OnRemoveListener()
  self:RemoveUIListener(EventId.GoldTreeThirdGetCardData, self.OnGoldTreeThirdGetCardData)
  self:RemoveUIListener(EventId.GoldTreeThirdError, self.OnGoldTreeThirdError)
  self:RemoveUIListener(EventId.LWUIGoldTreeRecordESC, self.OnLWUIGoldTreeRecordESC)
  self:RemoveUIListener(EventId.OnUnDelayPassDay, self.OnOnUnDelayPassDay)
  base.OnRemoveListener(self)
end

function LWUIGoldTreeRecordView:InitUI()
  local groupList = {}
  self.curWeek = DataCenter.SeasonGoldTreeThirdManager:GetPrayWeek()
  for index = 1, self.curWeek do
    local temp = CommonTabGoupItemTemplate.New()
    temp.title = Localization:GetString("season_s4_golden_tree_UI_38", index + DataCenter.SeasonGoldTreeThirdManager:GetStartWeek())
    temp.selectBgPath = string.format(LoadPath.LWCommonPath, "cfm_tongyong_yeqian_yiji_1.png")
    temp.arrowPath = string.format(LoadPath.LWCommonPath, "cfm_tongyong_yeqian_yiji_1_1.png")
    groupList[index] = temp
  end
  local bindFunc1 = BindCallback(self, self.OnGroupLoadFinish)
  local bindFunc2 = BindCallback(self, self.OnClickTab)
  self.bind_uicommontabgroup:RefreshGroup(groupList, bindFunc1, bindFunc2)
  self:OnClickTab(self.curWeek)
end

function LWUIGoldTreeRecordView:RefreshUI()
  local canShow = self.data ~= nil and self.data.userCardArr ~= nil and #self.data.userCardArr > 0
  self.txt_emptydes:SetActive(not canShow)
  self.rank_content:SetActive(canShow)
  if canShow then
    local lotteryPoolData = DataCenter.SeasonGoldTreeThirdManager:GetCurrentLotteryPoolData(self.data)
    if lotteryPoolData ~= nil then
      for index = 1, #self.mul_bind_rankcontent do
        self.mul_bind_rankcontent[index]:SetData(index, lotteryPoolData, true)
        self.mul_bind_rankcontent[index]:RefreshHistoryUI()
      end
    end
  end
end

function LWUIGoldTreeRecordView:OnGroupLoadFinish()
  self.bind_uicommontabgroup:SelectTab(self.curWeek, true)
end

function LWUIGoldTreeRecordView:OnClickTab(index)
  self.selectIndex = index or 0
  self.data = DataCenter.SeasonGoldTreeThirdManager:GetHistoryInfoByWeekIndex(index)
  if self.data == nil then
    if DataCenter.SeasonGoldTreeThirdManager:GetIsWeekEnd() then
      DataCenter.SeasonGoldTreeThirdManager:RequestGoldTreeGetAllianceCardView(false, self.selectIndex, self.curWeek - self.selectIndex)
    else
      DataCenter.SeasonGoldTreeThirdManager:RequestGoldTreeGetAllianceCardView(false, self.selectIndex, self.curWeek - self.selectIndex + 1)
    end
  else
    self:RefreshUI()
  end
end

function LWUIGoldTreeRecordView:ClickHelp()
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

function LWUIGoldTreeRecordView:OnGoldTreeThirdGetCardData()
  self.data = DataCenter.SeasonGoldTreeThirdManager:GetHistoryInfoByWeekIndex(self.selectIndex)
  self:RefreshUI()
end

function LWUIGoldTreeRecordView:OnGoldTreeThirdError()
  self.ctrl:CloseSelf()
end

function LWUIGoldTreeRecordView:OnLWUIGoldTreeRecordESC()
  if self.bind_lwuigoldtreeinfo:GetActive() then
    self.bind_lwuigoldtreeinfo:SetActive(false)
  else
    self.ctrl:CloseSelf()
  end
end

function LWUIGoldTreeRecordView:OnOnUnDelayPassDay()
  DataCenter.SeasonGoldTreeThirdManager:ClearHistoryInfoByWeekIndex()
end

function LWUIGoldTreeRecordView:ClickCardHelp(data, index)
  self.bind_lwuigoldtreeinfo:SetData(data, index, true)
  self.bind_lwuigoldtreeinfo:SetActive(true)
end

return LWUIGoldTreeRecordView
