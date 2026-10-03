local UITrainPrepareMemberListView = BaseClass("UITrainPrepareMemberListView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UITrainPrepareMemberListItem = require("UI.UILWRailway.UITrainPrepareMemberList.Component.UITrainPrepareMemberListItem")
local closeBtn_path = "top/btnClose"
local title_path = "top/txtTitle"
local svTask_path = "bg2/MiddleContentContainer/ScrollView"
local black_path = "black"

function UITrainPrepareMemberListView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UITrainPrepareMemberListView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UITrainPrepareMemberListView:OnAddListener()
  base.OnAddListener(self)
end

function UITrainPrepareMemberListView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UITrainPrepareMemberListView:ComponentDefine()
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self:OnCloseBtnClick()
  end)
  self.titleN = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.titleN:SetLocalText("")
  self.svTaskN = self:AddComponent(UIScrollView, svTask_path)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.svTaskN:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.svTaskN:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.black = self:AddComponent(UIButton, black_path)
  self.black:SetOnClick(function()
    self:OnCloseBtnClick()
  end)
  self.titleN:SetText(Localization:GetString("alliance_train_022"))
  self.empty = self:AddComponent(UIBaseContainer, "EmptyGroup")
end

function UITrainPrepareMemberListView:DataDefine()
end

function UITrainPrepareMemberListView:ComponentDestroy()
  self:ClearScroll()
  self.scrollCellPool = nil
  self.empty = nil
  self.closeBtnN = nil
  self.titleN = nil
  self.svTaskN = nil
  self.black = nil
end

function UITrainPrepareMemberListView:DataDestroy()
end

function UITrainPrepareMemberListView:ReInit()
  self.list = self:GetUserData()
  self:RefreshData()
end

function UITrainPrepareMemberListView:RefreshData()
  local recordCount = 0
  if self.list then
    recordCount = #self.list
  end
  self.svTaskN:SetTotalCount(recordCount)
  if 0 < recordCount then
    self.svTaskN:RefillCells()
    self.empty:SetActive(false)
  else
    self.empty:SetActive(true)
  end
end

function UITrainPrepareMemberListView:OnCreateCell(itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.svTaskN:AddComponent(UITrainPrepareMemberListItem, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  local logInfo = self.list[index]
  item:SetItem(logInfo)
end

function UITrainPrepareMemberListView:OnDeleteCell(itemObj, index)
end

function UITrainPrepareMemberListView:ClearScroll()
  self.svTaskN:ClearCells()
  self.svTaskN:RemoveComponents(UITrainPrepareMemberListItem)
end

function UITrainPrepareMemberListView:OnCloseBtnClick()
  self.ctrl:CloseSelf()
end

return UITrainPrepareMemberListView
