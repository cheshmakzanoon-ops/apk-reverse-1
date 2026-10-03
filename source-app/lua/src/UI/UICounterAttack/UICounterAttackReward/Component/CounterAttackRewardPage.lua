local CounterAttackRewardPage = BaseClass("CounterAttackRewardPage", UIBaseContainer)
local base = UIBaseContainer
local CounterAttackRewardItem = require("UI.UICounterAttack.UICounterAttackReward.Component.CounterAttackRewardItem")

function CounterAttackRewardPage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function CounterAttackRewardPage:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function CounterAttackRewardPage:ComponentDefine()
  self.items = {}
  self.content = self:AddComponent(UIBaseContainer, "ViewPort/Content")
  self.loopListView = self:AddComponent(UILoopListView2, "")
  self.loopListView:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
end

function CounterAttackRewardPage:ComponentDestroy()
  self:RemoveItems()
  self.loopListView = nil
end

function CounterAttackRewardPage:DataDefine()
end

function CounterAttackRewardPage:DataDestroy()
  self.personRankReward = nil
end

function CounterAttackRewardPage:OnAddListener()
  base.OnAddListener(self)
end

function CounterAttackRewardPage:OnRemoveListener()
  base.OnRemoveListener(self)
end

function CounterAttackRewardPage:Refresh()
  self:RefreshData()
  self:RefreshView()
end

function CounterAttackRewardPage:RefreshData()
  self.personRankReward = DataCenter.CounterAttackDataManager:GetPersonRankReward()
end

function CounterAttackRewardPage:RefreshView()
  self:RemoveItems()
  if self.personRankReward and #self.personRankReward > 0 then
    self.loopListView:SetListItemCount(#self.personRankReward, false, false)
    self.loopListView:RefreshAllShownItem()
  end
end

function CounterAttackRewardPage:GetScrollItem(listview, index)
  local dataList = self.personRankReward
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local csItem = listview:NewListViewItem("RewardCell")
  if self.items[csItem] == nil then
    NameCount = NameCount + 1
    local nameStr = "RewardCell" .. NameCount
    csItem.gameObject.name = nameStr
    self.items[csItem] = self.content:AddComponent(CounterAttackRewardItem, nameStr)
  end
  self.items[csItem]:Refresh(dataList[index])
  return csItem
end

function CounterAttackRewardPage:RemoveItems()
  self.items = {}
  self.content:RemoveComponents(CounterAttackRewardItem)
  self.loopListView:ClearAllItems()
end

return CounterAttackRewardPage
