local UIGhostreconGiftRewardPanel = BaseClass("UIGhostreconGiftRewardPanel", UIBaseContainer)
local base = UIBaseContainer
local scrollView_path = "Bg/ScrollView"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.scrollView = self:AddComponent(UIScrollView, scrollView_path)
  self.scrollView:SetFixedItemSize(90, 90)
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.scrollView = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.rewardList = nil
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(UICommonResItem, itemObj)
  cellItem:SetLocalScaleXYZ(0.6, 0.6, 0.6)
  local buildAddNum, itemId = DataCenter.ActDispatchTaskDataManager:GetBuildAddRewardInfo()
  local cellData = self.rewardList[index]
  if 0 < buildAddNum and cellData.itemId == itemId then
    cellData = DeepCopy(cellData)
    cellData.count = cellData.count + buildAddNum
    cellData.isShowArrow = true
  end
  cellItem:ReInit(cellData)
end

local function OnItemMoveOut(self, itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, UICommonResItem)
end

local function ClearScroll(self)
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UICommonResItem)
end

local function SetData(self, rewardList)
  self:ClearScroll()
  self.rewardList = rewardList
  self.scrollView:SetTotalCount(#rewardList)
  self.scrollView:RefillCells()
end

UIGhostreconGiftRewardPanel.OnCreate = OnCreate
UIGhostreconGiftRewardPanel.OnDestroy = OnDestroy
UIGhostreconGiftRewardPanel.OnEnable = OnEnable
UIGhostreconGiftRewardPanel.OnDisable = OnDisable
UIGhostreconGiftRewardPanel.ComponentDefine = ComponentDefine
UIGhostreconGiftRewardPanel.ComponentDestroy = ComponentDestroy
UIGhostreconGiftRewardPanel.DataDefine = DataDefine
UIGhostreconGiftRewardPanel.DataDestroy = DataDestroy
UIGhostreconGiftRewardPanel.OnAddListener = OnAddListener
UIGhostreconGiftRewardPanel.OnRemoveListener = OnRemoveListener
UIGhostreconGiftRewardPanel.SetData = SetData
UIGhostreconGiftRewardPanel.OnItemMoveIn = OnItemMoveIn
UIGhostreconGiftRewardPanel.OnItemMoveOut = OnItemMoveOut
UIGhostreconGiftRewardPanel.ClearScroll = ClearScroll
return UIGhostreconGiftRewardPanel
