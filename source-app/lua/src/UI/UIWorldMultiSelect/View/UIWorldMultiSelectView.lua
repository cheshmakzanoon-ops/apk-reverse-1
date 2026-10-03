local UIWorldMultiSelectView = BaseClass("UIWorldMultiSelectView", UIBaseView)
local MultiItem = require("UI.UIWorldMultiSelect.Component.MultiItem")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIWorldMultiSelectView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:Init()
end

function UIWorldMultiSelectView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWorldMultiSelectView:OnEnable()
end

function UIWorldMultiSelectView:OnDisable()
end

function UIWorldMultiSelectView:ComponentDefine()
  local btnPanel = self:AddComponent(UIButton, "Panel")
  btnPanel:SetOnClick(function()
    self.ctrl.CloseSelf()
  end)
  local sv_path = "content/ScrollView"
  self.svLayoutElement = self:AddComponent(UILayoutElement, sv_path)
  self.scrollView = self:AddComponent(UILoopListView2, sv_path)
  self.scrollView:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
  self.scrollContent = self:AddComponent(UIBaseContainer, "content/ScrollView/Viewport/Content")
  self.templateItem = self:AddComponent(MultiItem, "item")
end

function UIWorldMultiSelectView:ComponentDestroy()
  self.templateItem = nil
  self:ClearCells()
  self.scrollContent = nil
  self.scrollView = nil
  self.svLayoutElement = nil
end

function UIWorldMultiSelectView:ClearCells()
  self.scrollContent:RemoveComponents(MultiItem)
  self.scrollView:ClearAllItems()
  self.cells = {}
end

function UIWorldMultiSelectView:PrepareWH()
  self.templateItem:SetActive(true)
  local data = self.dataList
  local l = self.dataCount
  local maxW, maxH = 0, 0
  for i = 1, l do
    self.templateItem:SetData(data[i])
    local w, h = self.templateItem.rectTransform:Get_sizeDelta()
    if maxW < w then
      maxW = w
    end
    if maxH < h then
      maxH = h
    end
  end
  maxW = math.max(maxW, 220)
  self.maxW = maxW
  self.svLayoutElement:SetMinWidth(maxW)
  local showL = math.min(l, 5.5)
  self.svLayoutElement:SetMinHeight(showL * maxH)
  self.templateItem:SetActive(false)
end

function UIWorldMultiSelectView:Init()
  self:ClearCells()
  local dataList = self:GetUserData()
  local dataSort = {}
  local dataCount = dataList.Count
  for i = 0, dataCount - 1 do
    local data = dataList[i]
    if data then
      local nameStr = data.previewName
      local iconPath = data.previewIconPath
      local previewType = WorldPreviewType.Default
      if type(data.GetPreviewType) == "function" then
        previewType = data:GetPreviewType()
      elseif data.PreviewType ~= nil and type(data.PreviewType.ToInt) == "function" then
        previewType = data.PreviewType:ToInt()
      end
      table.insert(dataSort, {
        obj = data,
        name = nameStr,
        icon = iconPath,
        type = previewType
      })
    end
  end
  table.sort(dataSort, function(a, b)
    return (WorldPreviewTypeSort[a.type or 0] or 1000) < (WorldPreviewTypeSort[b.type or 0] or 2000)
  end)
  self.dataList = dataSort
  self.dataCount = #dataSort
  self:PrepareWH()
  self.scrollView:SetListItemCount(self.dataCount, false, false)
  self.scrollView:RefreshAllShownItem()
end

function UIWorldMultiSelectView:TryGetScrollItem(listview, index)
  local dataList = self.dataList
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local csItem = listview:NewListViewItem("item")
  local item = self.cells[csItem]
  if item == nil then
    NameCount = NameCount + 1
    local nameStr = "Cell" .. tostring(NameCount)
    csItem.gameObject.name = nameStr
    item = self.scrollContent:AddComponent(MultiItem, nameStr)
    self.cells[csItem] = item
  end
  if item ~= nil then
    item:SetData(dataList[index], self.maxW)
  end
  return csItem
end

return UIWorldMultiSelectView
