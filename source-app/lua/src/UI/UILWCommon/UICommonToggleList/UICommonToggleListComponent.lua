local base = UIBaseContainer
local UICommonToggleListComponent = BaseClass("UICommonToggleListComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UICommonToggleListItemComponent = require("UI.UILWCommon.UICommonToggleList.UICommonToggleListItemComponent")

function UICommonToggleListComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UICommonToggleListComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICommonToggleListComponent:ComponentDefine()
  self.compUICommonToggleItem = self:AddComponent(UICommonToggleListItemComponent, "Viewport/UICommonToggleItem")
  self.scrollRectUICommonToggleList = self:AddComponent(UIScrollRect, "")
  self.compContent = self:AddComponent(UIBaseContainer, "Viewport/Content")
  self.compViewport = self:AddComponent(UIBaseContainer, "Viewport")
  self.compUICommonToggleItem:SetActive(false)
  self.compUICommonToggleItem.gameObject:GameObjectCreatePool()
end

function UICommonToggleListComponent:ComponentDestroy()
  self:ClearContent()
  self.compUICommonToggleItem = nil
  self.scrollRectUICommonToggleList = nil
  self.compContent = nil
  self.compViewport = nil
end

function UICommonToggleListComponent:DataDefine()
  self.data = nil
  self.curSelectIndex = 0
  self.items = nil
end

function UICommonToggleListComponent:DataDestroy()
  self.data = nil
  self.curSelectIndex = nil
  self.items = nil
end

function UICommonToggleListComponent:OnAddListener()
  base.OnAddListener(self)
end

function UICommonToggleListComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UICommonToggleListComponent:ReInit(data)
  self.data = data
  self.curSelectIndex = nil
  if self.data == nil or table.IsNullOrEmpty(self.data.itemsDataList) then
    Logger.LogError("UICommonToggleListComponent reinit data is empty")
    return
  end
  local defaultSelectIndex = self.data.defaultSelectIndex or 1
  self:ClearContent()
  self.items = {}
  for i, v in ipairs(self.data.itemsDataList) do
    local itemData = {}
    itemData.data = v
    itemData.index = i
    
    function itemData.onItemSelect(param)
      self:OnItemSelect(param)
    end
    
    function itemData.isShowRed(param)
      return self:IsShowRed(param)
    end
    
    local item = self.compUICommonToggleItem.gameObject:GameObjectSpawn(self.compContent.transform)
    item.name = "UICommonToggleItem_" .. UIUtil.GetLoopListItemIndex()
    local obj = self.compContent:AddComponent(UICommonToggleListItemComponent, item.name)
    obj:SetActive(true)
    obj:ReInit(itemData)
    table.insert(self.items, obj)
    if i == defaultSelectIndex then
      self:OnItemSelect(itemData)
    end
  end
  self:UpdateSelect()
  self:UpdateRed()
  self:UpdateScroll()
end

function UICommonToggleListComponent:ClearContent()
  self.compContent:RemoveComponents(UICommonToggleListItemComponent)
  self.compUICommonToggleItem.gameObject:GameObjectRecycleAll()
  self.items = nil
end

function UICommonToggleListComponent:UpdateScroll()
  local isCanScroll = true
  if self.data and self.data.isCanScroll == false then
    isCanScroll = false
  end
  self.scrollRectUICommonToggleList:SetEnable(isCanScroll)
  local mask = self.compViewport.transform:GetComponent(typeof(CS.UnityEngine.UI.RectMask2D))
  if IsNotNull(mask) then
    mask.enabled = isCanScroll
  end
end

function UICommonToggleListComponent:UpdateSelect()
  if self.items then
    for i, v in ipairs(self.items) do
      v:UpdateSelect(v:GetIndex() == self.curSelectIndex)
    end
  end
end

function UICommonToggleListComponent:UpdateRed()
  if self.items then
    for i, v in ipairs(self.items) do
      v:UpdateRed()
    end
  end
end

function UICommonToggleListComponent:OnItemSelect(param)
  if self.curSelectIndex == param.index then
    return
  end
  if not self:IsCanSelectItem(param) then
    return
  end
  self.curSelectIndex = param.index
  self:UpdateSelect()
  self.data.onItemSelect(param.index, param.data)
end

function UICommonToggleListComponent:IsCanSelectItem(param)
  if self.data == nil then
    return false
  end
  local isCanSelect = true
  if self.data.isCanSelect ~= nil then
    isCanSelect = self.data.isCanSelect(param.index, param.data)
  end
  return isCanSelect
end

function UICommonToggleListComponent:IsShowRed(param)
  if self.data == nil or self.data.isShowRed == nil then
    return false
  end
  return self.data.isShowRed(param.index, param.data)
end

function UICommonToggleListComponent:GetCurSelectIndex()
  return self.curSelectIndex
end

function UICommonToggleListComponent:SetSelectIndex(index)
  self:OnItemSelect({index = index})
end

function UICommonToggleListComponent:ScrollToIndexTab(index)
  local rootSizeDeltaX, _ = self:GetSizeDeltaXY()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compContent.transform)
  local contentSizeDeltaX, _ = self.compContent:GetSizeDeltaXY()
  if rootSizeDeltaX >= contentSizeDeltaX then
    self.compContent:SetAnchoredPositionXY(0, 0)
    return
  end
  local itemSizeDeltaX, _ = self.compUICommonToggleItem:GetSizeDeltaXY()
  local offset = (index - 1) * itemSizeDeltaX
  if offset > contentSizeDeltaX - rootSizeDeltaX then
    offset = contentSizeDeltaX - rootSizeDeltaX
  end
  self.compContent:SetAnchoredPositionXY(-offset, 0)
end

function UICommonToggleListComponent:ScrollToIndexTabFixY(index)
  local rootSizeDeltaX, _ = self:GetSizeDeltaXY()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compContent.transform)
  local y = self.compContent:GetAnchoredPositionY()
  local contentSizeDeltaX, _ = self.compContent:GetSizeDeltaXY()
  if rootSizeDeltaX >= contentSizeDeltaX then
    self.compContent:SetAnchoredPositionXY(0, y)
    return
  end
  local itemSizeDeltaX, _ = self.compUICommonToggleItem:GetSizeDeltaXY()
  local offset = (index - 1) * itemSizeDeltaX
  if offset > contentSizeDeltaX - rootSizeDeltaX then
    offset = contentSizeDeltaX - rootSizeDeltaX
  end
  self.compContent:SetAnchoredPositionXY(-offset, y)
end

return UICommonToggleListComponent
