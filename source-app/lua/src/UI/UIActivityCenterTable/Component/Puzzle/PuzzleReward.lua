local PuzzleReward = BaseClass("PuzzleReward", UIBaseContainer)
local base = UIBaseContainer
local PuzzleRewardItem = require("UI.UIActivityCenterTable.Component.Puzzle.PuzzleRewardItem")
local title_path = "RewardInfoTitle1"
local title_1_path = "RewardInfoTitle2"
local scroll_path = "ScrollView"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.title = self:AddComponent(UIText, title_path)
  self.title_1 = self:AddComponent(UIText, title_1_path)
  self.title:SetLocalText(372203)
  self.title_1:SetLocalText(372204)
  self.scrollView = self:AddComponent(UIScrollView, scroll_path)
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.title = nil
  self.title_1 = nil
  self.scrollView = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.data = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, data)
  self.data = data
  self:RefreshView()
end

local function RefreshView(self)
  if self.data == nil then
    return
  end
  self:ClearScroll()
  local total = table.count(self.data)
  if 0 < total then
    self.scrollView:SetTotalCount(total)
    self.scrollView:RefillCells()
  end
end

local function ClearScroll(self)
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(PuzzleRewardItem)
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(PuzzleRewardItem, itemObj)
  cellItem:RefreshData(self.data[index])
end

local function OnItemMoveOut(self, itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, PuzzleRewardItem)
end

local function HideSelf(self)
  self:SetActive(false)
end

PuzzleReward.OnCreate = OnCreate
PuzzleReward.OnDestroy = OnDestroy
PuzzleReward.ComponentDefine = ComponentDefine
PuzzleReward.ComponentDestroy = ComponentDestroy
PuzzleReward.DataDefine = DataDefine
PuzzleReward.DataDestroy = DataDestroy
PuzzleReward.OnAddListener = OnAddListener
PuzzleReward.OnRemoveListener = OnRemoveListener
PuzzleReward.SetData = SetData
PuzzleReward.RefreshView = RefreshView
PuzzleReward.ClearScroll = ClearScroll
PuzzleReward.OnItemMoveIn = OnItemMoveIn
PuzzleReward.OnItemMoveOut = OnItemMoveOut
PuzzleReward.HideSelf = HideSelf
return PuzzleReward
