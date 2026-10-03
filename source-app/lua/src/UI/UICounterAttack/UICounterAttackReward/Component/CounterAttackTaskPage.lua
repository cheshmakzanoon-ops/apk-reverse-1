local CounterAttackTaskPage = BaseClass("CounterAttackTaskPage", UIBaseContainer)
local base = UIBaseContainer
local CounterAttackTaskItem = require("UI.UICounterAttack.UICounterAttackReward.Component.CounterAttackTaskItem")

function CounterAttackTaskPage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function CounterAttackTaskPage:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function CounterAttackTaskPage:ComponentDefine()
  self.items = {}
  self.content = self:AddComponent(UIBaseContainer, "ViewPort/Content")
  self.loopListView = self:AddComponent(UILoopListView2, "")
  self.loopListView:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self.btn_text = self:AddComponent(UITextMeshProUGUIEx, "BtnAll/AllText")
  self.btn_text:SetLocalText("310104")
  self.allBtn = self:AddComponent(UIButton, "BtnAll")
  self.allBtn:SetOnClick(function()
    DataCenter.CounterAttackDataManager:SendMsgCollectRoundAward()
  end)
end

function CounterAttackTaskPage:ComponentDestroy()
  self:RemoveItems()
  self.loopListView = nil
end

function CounterAttackTaskPage:DataDefine()
end

function CounterAttackTaskPage:DataDestroy()
  self.allianceRoundReward = nil
end

function CounterAttackTaskPage:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnCounterAttackRoundAwardInit, self.Refresh)
end

function CounterAttackTaskPage:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnCounterAttackRoundAwardInit, self.Refresh)
end

function CounterAttackTaskPage:Refresh()
  self:RefreshData()
  self:RefreshView()
end

function CounterAttackTaskPage:RefreshData()
  self.allianceRoundReward = DataCenter.CounterAttackDataManager:GetAllianceRoundReward()
end

function CounterAttackTaskPage:RefreshView()
  self:RemoveItems()
  if self.allianceRoundReward and #self.allianceRoundReward > 0 then
    self.loopListView:SetListItemCount(#self.allianceRoundReward, false, false)
    self.loopListView:RefreshAllShownItem()
  end
end

function CounterAttackTaskPage:GetScrollItem(listview, index)
  local dataList = self.allianceRoundReward
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local csItem = listview:NewListViewItem("TaskCell")
  if self.items[csItem] == nil then
    NameCount = NameCount + 1
    local nameStr = "TaskCell" .. NameCount
    csItem.gameObject.name = nameStr
    self.items[csItem] = self.content:AddComponent(CounterAttackTaskItem, nameStr)
  end
  self.items[csItem]:ReInit(dataList[index])
  return csItem
end

function CounterAttackTaskPage:RemoveItems()
  self.items = {}
  self.content:RemoveComponents(CounterAttackTaskItem)
  self.loopListView:ClearAllItems()
end

return CounterAttackTaskPage
