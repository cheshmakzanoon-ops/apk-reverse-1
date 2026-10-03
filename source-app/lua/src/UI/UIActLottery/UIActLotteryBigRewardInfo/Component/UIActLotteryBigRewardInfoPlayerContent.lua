local base = UIBaseContainer
local UIActLotteryBigRewardInfoPlayerContent = BaseClass("UIActLotteryBigRewardInfoPlayerContent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIActLotteryBigRewardInfoPlayerItem = require("UI.UIActLottery.UIActLotteryBigRewardInfo.Component.UIActLotteryBigRewardInfoPlayerItem")
local lottery_reward_player_scroll_path = "LotteryRewardPlayerScroll"
local content_path = "LotteryRewardPlayerScroll/viewPort/Content"
local next_time_path = "nextTime"

function UIActLotteryBigRewardInfoPlayerContent:OnCreate()
  base.OnCreate(self)
  self.itemIndex = 0
  self:ComponentDefine()
  self:DataDefine()
end

function UIActLotteryBigRewardInfoPlayerContent:OnDestroy()
  self:ClearContent()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.showData then
    return nil
  end
  local packData = self.showData[index]
  local item = loopScroll:NewListViewItem("LotteryRewardPlayerItem")
  local script = self.content:GetComponent(item.gameObject.name, UIActLotteryBigRewardInfoPlayerItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.content:AddComponent(UIActLotteryBigRewardInfoPlayerItem, objectName)
  end
  script:SetActive(true)
  script:SetData(self.activityId, packData, self.specialRewardData, self.lottery_reward_player_scroll, index - 1)
  return item
end

function UIActLotteryBigRewardInfoPlayerContent:ComponentDefine()
  self.lottery_reward_player_scroll = self:AddComponent(UILoopListView2, lottery_reward_player_scroll_path)
  self.lottery_reward_player_scroll:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.next_time = self:AddComponent(UITextMeshProUGUIEx, next_time_path)
end

function UIActLotteryBigRewardInfoPlayerContent:ComponentDestroy()
  self.next_time = nil
end

function UIActLotteryBigRewardInfoPlayerContent:DataDefine()
end

function UIActLotteryBigRewardInfoPlayerContent:DataDestroy()
end

function UIActLotteryBigRewardInfoPlayerContent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActLotteryTicketHistoryMsg, self.GetActLotteryTicketHistoryMsg)
end

function UIActLotteryBigRewardInfoPlayerContent:OnRemoveListener()
  self:RemoveUIListener(EventId.ActLotteryTicketHistoryMsg, self.GetActLotteryTicketHistoryMsg)
  base.OnRemoveListener(self)
end

function UIActLotteryBigRewardInfoPlayerContent:SetData(activityId)
  self.activityId = activityId
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  self.activityDetailData = DataCenter.ActLotteryDataManager:GetActData(self.activityId)
  if self.activityDetailData == nil then
    return
  end
  self.activityTemp = DataCenter.ActLotteryDataManager:GetTempByActInfo(self.activityInfo)
  self.showData = self.activityDetailData:GetTicketHistory()
  local targetRewardId = self.activityTemp.big_reward[1]
  self.specialRewardData = DataCenter.ActLotteryDataManager:GetRewardDataById(targetRewardId)
  if self.activityDetailData:CheckTicketHistoryExpired() and self.activityDetailData:CheckNeedReqTicketHistory() then
    SFSNetwork.SendMessage(MsgDefines.LottoTicketHistory, self.activityId)
  end
  self:RefreshNextOpenTimeData()
  self:RefreshView()
end

function UIActLotteryBigRewardInfoPlayerContent:RefreshView()
  self:RefreshItemView()
  self:Update1000MS()
end

function UIActLotteryBigRewardInfoPlayerContent:RefreshItemView()
  if not table.IsNullOrEmpty(self.showData) then
    self.lottery_reward_player_scroll:SetListItemCount(#self.showData, false, false)
    self.lottery_reward_player_scroll:RefreshAllShownItem()
  end
end

function UIActLotteryBigRewardInfoPlayerContent:GetActLotteryTicketHistoryMsg()
  self.showData = self.activityDetailData:GetTicketHistory()
  self:RefreshView()
end

function UIActLotteryBigRewardInfoPlayerContent:ClearContent()
  self.content:RemoveComponents(UIActLotteryBigRewardInfoPlayerItem)
  self.lottery_reward_player_scroll:ClearAllItems()
end

function UIActLotteryBigRewardInfoPlayerContent:Update1000MS()
  if self.curDayNum == nil or self.nextOpenTime == nil then
    return
  end
  if self.nextOpenTime == 0 then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.nextOpenTime - curTime
  if leftTime < 0 then
    leftTime = 0
  end
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.next_time:SetLocalText("thxgiv_Lottery_TicAwardTip", countDownTimeStr)
  if leftTime <= 0 then
    self:RefreshNextOpenTimeData()
  end
end

function UIActLotteryBigRewardInfoPlayerContent:RefreshNextOpenTimeData()
  self.curDayNum, self.nextOpenTime = DataCenter.ActLotteryDataManager:GetRealBigRewardTimeData(self.activityId)
end

return UIActLotteryBigRewardInfoPlayerContent
