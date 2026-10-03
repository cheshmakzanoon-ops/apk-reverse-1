local PuzzleRewardInfo = BaseClass("PuzzleRewardInfo", UIBaseContainer)
local base = UIBaseContainer
local PuzzleRewardInfoItem = require("UI.UIPuzzleMonster.UIPuzzleMonsterCreate.Component.PuzzleRewardInfoItem")
local title_path = "RewardInfoTitle"
local scroll_path = "ScrollView"
local left_arrow_path = "left_arrow"
local right_arrow_path = "right_arrow"

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
  self.title:SetLocalText(300131)
  self.scrollView = self:AddComponent(UIScrollView, scroll_path)
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.left_arrow = self:AddComponent(UIImage, left_arrow_path)
  self.right_arrow = self:AddComponent(UIImage, right_arrow_path)
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

local function SetData(self, data, pos, isLeftArrow)
  self.data = data
  self.pos = pos
  self.isLeftArrow = isLeftArrow
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
  local isLeft = self.isLeftArrow
  local rectPos = self.rectTransform.rect
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local diffX = (rectPos.width / 2 + 30) * scaleFactor
  if not isLeft then
    diffX = (-rectPos.width / 2 - 30) * scaleFactor
  end
  self.left_arrow:SetActive(isLeft)
  self.right_arrow:SetActive(not isLeft)
  self.transform.position = Vector3.New(self.pos.x + diffX, self.pos.y, 0)
end

local function ClearScroll(self)
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(PuzzleRewardInfoItem)
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(PuzzleRewardInfoItem, itemObj)
  cellItem:RefreshData(self.data[index])
end

local function OnItemMoveOut(self, itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, PuzzleRewardInfoItem)
end

local function HideSelf(self)
  self:SetActive(false)
end

PuzzleRewardInfo.OnCreate = OnCreate
PuzzleRewardInfo.OnDestroy = OnDestroy
PuzzleRewardInfo.ComponentDefine = ComponentDefine
PuzzleRewardInfo.ComponentDestroy = ComponentDestroy
PuzzleRewardInfo.DataDefine = DataDefine
PuzzleRewardInfo.DataDestroy = DataDestroy
PuzzleRewardInfo.OnAddListener = OnAddListener
PuzzleRewardInfo.OnRemoveListener = OnRemoveListener
PuzzleRewardInfo.SetData = SetData
PuzzleRewardInfo.RefreshView = RefreshView
PuzzleRewardInfo.ClearScroll = ClearScroll
PuzzleRewardInfo.OnItemMoveIn = OnItemMoveIn
PuzzleRewardInfo.OnItemMoveOut = OnItemMoveOut
PuzzleRewardInfo.HideSelf = HideSelf
return PuzzleRewardInfo
