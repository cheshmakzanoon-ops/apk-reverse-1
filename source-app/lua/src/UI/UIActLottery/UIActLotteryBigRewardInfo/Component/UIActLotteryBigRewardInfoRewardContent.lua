local base = UIBaseContainer
local UIActLotteryBigRewardInfoRewardContent = BaseClass("UIActLotteryBigRewardInfoRewardContent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIActLotteryBigRewardInfoRewardItem = require("UI.UIActLottery.UIActLotteryBigRewardInfo.Component.UIActLotteryBigRewardInfoRewardItem")
local lottery_reward_scroll_path = "LotteryRewardShowScroll"
local content_path = "LotteryRewardShowScroll/viewPort/Content"

function UIActLotteryBigRewardInfoRewardContent:OnCreate()
  base.OnCreate(self)
  self.itemIndex = 0
  self:ComponentDefine()
  self:DataDefine()
end

function UIActLotteryBigRewardInfoRewardContent:OnDestroy()
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
  local item = loopScroll:NewListViewItem("LotteryRewardShowItem")
  local script = self.content:GetComponent(item.gameObject.name, UIActLotteryBigRewardInfoRewardItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.content:AddComponent(UIActLotteryBigRewardInfoRewardItem, objectName)
  end
  script:SetActive(true)
  script:SetData(self.activityId, packData, self.lottery_reward_scroll, index - 1)
  return item
end

function UIActLotteryBigRewardInfoRewardContent:ComponentDefine()
  self.lottery_reward_scroll = self:AddComponent(UILoopListView2, lottery_reward_scroll_path)
  self.lottery_reward_scroll:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

function UIActLotteryBigRewardInfoRewardContent:ComponentDestroy()
  self.icon = nil
  self.textProbability = nil
  self.btn = nil
end

function UIActLotteryBigRewardInfoRewardContent:DataDefine()
end

function UIActLotteryBigRewardInfoRewardContent:DataDestroy()
end

function UIActLotteryBigRewardInfoRewardContent:OnAddListener()
  base.OnAddListener(self)
end

function UIActLotteryBigRewardInfoRewardContent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActLotteryBigRewardInfoRewardContent:SetData(activityId)
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
  self.showData = {}
  local targetId = self.activityTemp.big_reward[1]
  table.insert(self.showData, {
    rank = 0,
    rate = 0,
    rewardId = targetId,
    reward = DataCenter.ActLotteryDataManager:GetRewardDataById(targetId)
  })
  local totalRate = 0
  for i, data in ipairs(self.activityTemp.draw_weight) do
    totalRate = totalRate + data[1]
  end
  for i, data in ipairs(self.activityTemp.draw_weight) do
    local rate = data[1] / totalRate
    local rewardId = data[2]
    table.insert(self.showData, {
      rank = i,
      rate = rate,
      rewardId = rewardId,
      reward = DataCenter.ActLotteryDataManager:GetRewardDataById(rewardId)
    })
  end
  self:RefreshView()
end

function UIActLotteryBigRewardInfoRewardContent:RefreshView()
  self:RefreshItemView()
end

function UIActLotteryBigRewardInfoRewardContent:RefreshItemView()
  if not table.IsNullOrEmpty(self.showData) then
    self.lottery_reward_scroll:SetListItemCount(#self.showData, false, false)
    self.lottery_reward_scroll:RefreshAllShownItem()
  end
end

function UIActLotteryBigRewardInfoRewardContent:ClearContent()
  self.content:RemoveComponents(UIActLotteryBigRewardInfoRewardItem)
  self.lottery_reward_scroll:ClearAllItems()
end

return UIActLotteryBigRewardInfoRewardContent
