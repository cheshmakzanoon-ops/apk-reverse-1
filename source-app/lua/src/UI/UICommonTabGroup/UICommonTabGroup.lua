local base = UIBaseContainer
local UICommonTabGroup = BaseClass("UICommonTabGroup", base)
local TabItem = require("UI.UICommonTabGroup.UICommonTabItem")
local TabItemPath = "Assets/Main/Prefabs/UI/UICommonTabGroup/UICommonTabItem.prefab"
local tabContent_path = "Viewport/Content"
local scrollRect_path = ""
local ITEM_TAB_PATH_CONFIG = {
  [CommonTabGroupItemStyle.Default] = "Assets/Main/Prefabs/UI/UICommonTabGroup/UICommonTabItem.prefab",
  [CommonTabGroupItemStyle.Style1] = "Assets/Main/Prefabs/UI/UICommonTabGroup/UICommonTabItem_Style1.prefab",
  [CommonTabGroupItemStyle.Style2] = "Assets/Main/Prefabs/UI/UICommonTabGroup/UICommonTabItem_Style2.prefab",
  [CommonTabGroupItemStyle.Style3] = "Assets/Main/Prefabs/UI/UICommonTabGroup/UICommonTabItem_Style3.prefab",
  [CommonTabGroupItemStyle.Style4] = "Assets/Main/Prefabs/UI/UICommonTabGroup/UICommonTabItem_Style4.prefab",
  [CommonTabGroupItemStyle.Style5] = "Assets/Main/Prefabs/UI/UICommonTabGroup/UICommonTabItem_Style5.prefab",
  [CommonTabGroupItemStyle.Style4Activity] = "Assets/Main/Prefabs/UI/UICommonTabGroup/UICommonTabItem_Activity.prefab"
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:SetAllCellDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.tabContent = self:AddComponent(UIBaseContainer, tabContent_path)
  self.scrollRect = self:AddComponent(UIScrollRect, scrollRect_path)
end

local function ComponentDestroy(self)
  self.tabContent = nil
  self.scrollRect = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.groupDataList = nil
  self.loadFinshAction = nil
  self.modelTabs = nil
  self.tabItems = nil
  self.lastClickIndex = nil
end

local function RefreshGroup(self, groupDataList, loadFinshAction, clickAction, refreshRedAction)
  self.groupDataList = groupDataList
  self.loadFinshAction = loadFinshAction
  self:RefreshTabs(clickAction, refreshRedAction)
end

local function RefreshTabs(self, clickAction, refreshRedAction)
  self:SetAllCellDestroy()
  local itemPath = self.customItemPath and self.customItemPath or TabItemPath
  self.modelTabs = {}
  self.tabItems = {}
  local length = #self.groupDataList
  for i, v in ipairs(self.groupDataList) do
    self.modelTabs[i] = self:GameObjectInstantiateAsync(itemPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.tabContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = i
      local cell = self.tabContent:AddComponent(TabItem, go.name, v, i)
      cell:SetCallback(BindCallback(self, self.SelectTab), clickAction, refreshRedAction)
      self.tabItems[i] = cell
      if table.count(self.tabItems) == length and self.loadFinshAction then
        self.loadFinshAction()
        self:OnAllItemLoadFinish()
      end
    end)
  end
end

function UICommonTabGroup:OnAllItemLoadFinish()
  self:RefreshAllRedDot()
end

function UICommonTabGroup:Update1000MS()
  if self.redDotDirty then
    if self.refreshItemIndex then
      self:RefreshTargetIndexRedDot(self.refreshItemIndex)
    else
      self:RefreshAllRedDot()
    end
    self.redDotDirty = false
  end
end

function UICommonTabGroup:RefreshRedDotStateDelay(index)
  self.redDotDirty = true
  self.refreshItemIndex = index
end

function UICommonTabGroup:RefreshAllRedDot()
  if not self.tabItems then
    return
  end
  for _, v in ipairs(self.tabItems) do
    v:RefreshRedPoint()
  end
end

function UICommonTabGroup:RefreshTargetIndexRedDot(index)
  if not self.tabItems then
    return
  end
  local targetItem = self.tabItems[index]
  if not targetItem then
    return
  end
  targetItem:RefreshRedPoint()
end

local function SetAllCellDestroy(self)
  self.tabContent:RemoveComponents(TabItem)
  if self.modelTabs ~= nil then
    for k, v in pairs(self.modelTabs) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

local function SelectTab(self, clickIndex, moveToPos)
  local isClickLast = false
  if self.lastClickIndex and self.lastClickIndex == clickIndex then
    isClickLast = true
  end
  self.lastClickIndex = clickIndex
  if self.tabItems and #self.tabItems > 0 then
    for index, value in ipairs(self.tabItems) do
      if clickIndex == index then
        value:SetSelect()
        value:OnClick()
      else
        value:SetUnSelect()
      end
    end
  end
  if moveToPos and self.scrollRect then
    self.scrollRect:AnimHorizontalNormalizedPos(clickIndex / #self.tabItems, 0.2)
  end
  return isClickLast
end

local function SetUnSelect(self, index)
  if self.tabItems and self.tabItems[index] then
    self.tabItems[index]:SetUnSelect()
  end
end

local function SetSelect(self, index)
  if self.tabItems and self.tabItems[index] then
    self.tabItems[index]:SetSelect()
  end
end

local function SetCustomTabItemPath(self, customItemPath)
  self.customItemPath = customItemPath
end

local function SetTabItemStyle(self, tabItemStyle)
  if not table.containsKey(ITEM_TAB_PATH_CONFIG, tabItemStyle) then
    return
  end
  self:SetCustomTabItemPath(ITEM_TAB_PATH_CONFIG[tabItemStyle])
end

UICommonTabGroup.OnCreate = OnCreate
UICommonTabGroup.OnDestroy = OnDestroy
UICommonTabGroup.OnEnable = OnEnable
UICommonTabGroup.OnDisable = OnDisable
UICommonTabGroup.ComponentDefine = ComponentDefine
UICommonTabGroup.ComponentDestroy = ComponentDestroy
UICommonTabGroup.DataDefine = DataDefine
UICommonTabGroup.DataDestroy = DataDestroy
UICommonTabGroup.RefreshGroup = RefreshGroup
UICommonTabGroup.RefreshTabs = RefreshTabs
UICommonTabGroup.SetAllCellDestroy = SetAllCellDestroy
UICommonTabGroup.SelectTab = SelectTab
UICommonTabGroup.SetUnSelect = SetUnSelect
UICommonTabGroup.SetSelect = SetSelect
UICommonTabGroup.SetCustomTabItemPath = SetCustomTabItemPath
UICommonTabGroup.SetTabItemStyle = SetTabItemStyle
return UICommonTabGroup
