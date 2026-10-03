local base = UIBaseContainer
local UIActLotterySelfInfoBigRewardContent = BaseClass("UIActLotterySelfInfoBigRewardContent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIActLotterySelfInfoBigRewardItem = require("UI.UIActLottery.UIActLotterySelfInfo.Component.UIActLotterySelfInfoBigRewardItem")
local content_path = "LotteryRewardScroll/viewPort/Content"
local lottery_reward_scroll_path = "LotteryRewardScroll"

function UIActLotterySelfInfoBigRewardContent:OnCreate()
  base.OnCreate(self)
  self.itemIndex = 0
  self:ComponentDefine()
  self:DataDefine()
end

function UIActLotterySelfInfoBigRewardContent:OnDestroy()
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
  local item = loopScroll:NewListViewItem("SelfLotteryRewardItem")
  local script = self.content:GetComponent(item.gameObject.name, UIActLotterySelfInfoBigRewardItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.content:AddComponent(UIActLotterySelfInfoBigRewardItem, objectName)
  end
  script:SetActive(true)
  script:SetData(self.activityId, packData, #self.showData, self.lottery_reward_scroll, index - 1)
  return item
end

function UIActLotterySelfInfoBigRewardContent:ComponentDefine()
  self.lottery_reward_scroll = self:AddComponent(UILoopListView2, lottery_reward_scroll_path)
  self.lottery_reward_scroll:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

function UIActLotterySelfInfoBigRewardContent:ComponentDestroy()
  self.lottery_reward_scroll = nil
  self.content = nil
end

function UIActLotterySelfInfoBigRewardContent:DataDefine()
end

function UIActLotterySelfInfoBigRewardContent:DataDestroy()
end

function UIActLotterySelfInfoBigRewardContent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActLotteryOwnerRecordMsg, self.GetActLotteryOwnerRecordMsgMsg)
end

function UIActLotterySelfInfoBigRewardContent:OnRemoveListener()
  self:RemoveUIListener(EventId.ActLotteryOwnerRecordMsg, self.GetActLotteryOwnerRecordMsgMsg)
  base.OnRemoveListener(self)
end

function UIActLotterySelfInfoBigRewardContent:SetData(activityId)
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
  self.showData = self.activityDetailData:GetOwnerRecord()
  if self.activityDetailData:CheckOwnerRecordExpired() then
    SFSNetwork.SendMessage(MsgDefines.LottoOwnerRecord, self.activityId)
  end
  self:RefreshView()
end

function UIActLotterySelfInfoBigRewardContent:RefreshView()
  self:RefreshItemView()
end

function UIActLotterySelfInfoBigRewardContent:RefreshItemView()
  if not table.IsNullOrEmpty(self.showData) then
    self.lottery_reward_scroll:SetListItemCount(#self.showData, false, false)
    self.lottery_reward_scroll:RefreshAllShownItem()
  end
end

function UIActLotterySelfInfoBigRewardContent:GetActLotteryOwnerRecordMsgMsg()
  self.showData = self.activityDetailData:GetOwnerRecord()
  if self.activityDetailData:CheckOwnerRecordExpired() then
    SFSNetwork.SendMessage(MsgDefines.LottoOwnerRecord, self.activityId)
  end
  self:RefreshView()
end

function UIActLotterySelfInfoBigRewardContent:ClearContent()
  self.content:RemoveComponents(UIActLotterySelfInfoBigRewardItem)
  self.lottery_reward_scroll:ClearAllItems()
end

return UIActLotterySelfInfoBigRewardContent
