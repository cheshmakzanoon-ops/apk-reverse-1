local base = UIBaseContainer
local UILWNewCenterTabList = BaseClass("UILWNewCenterTabList", base)
local UILWNewCenterTabItem = require("UI.UILWNewsCenter.Component.UILWNewCenterTabItem")

function UILWNewCenterTabList:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.tabItemLits = {}
end

function UILWNewCenterTabList:OnDestroy()
  self:ComponentDestroy()
  self.tabItemLits = nil
  base.OnDestroy(self)
end

function UILWNewCenterTabList:ComponentDefine()
  self.tabItem = self.transform:Find("tabItem").gameObject
  self.tabItem:GameObjectCreatePool()
end

function UILWNewCenterTabList:ComponentDestroy()
  self.tabItem = nil
end

function UILWNewCenterTabList:Refresh(dataList, callback)
  self:ClearAllTabItem()
  self.dataList = dataList
  self.tabItemLits = {}
  self.callback = callback
  local item, name, cell
  for i = 1, #dataList do
    item = self.tabItem:GameObjectSpawn(self.transform)
    item.name = tostring(i) .. dataList[i].tabType
    cell = self:AddComponent(UILWNewCenterTabItem, item.name)
    cell:SetActive(true)
    cell:Refresh(dataList[i], function(SwitchTab)
      self:SwitchTab(SwitchTab)
    end)
    table.insert(self.tabItemLits, cell)
  end
end

function UILWNewCenterTabList:ClearAllTabItem()
  self:RemoveComponents(UILWNewCenterTabItem)
  self.tabItem:GameObjectRecycleAll()
end

function UILWNewCenterTabList:SwitchTab(tabType, childTabType)
  local data
  for i = 1, #self.tabItemLits do
    if self.tabItemLits[i].data.tabType == tabType then
      data = self.tabItemLits[i].data
    end
    self.tabItemLits[i]:SetState(tabType)
  end
  if self.callback then
    self.callback(data, childTabType)
  end
end

function UILWNewCenterTabList:GetChild(tabType)
  for i = 1, #self.tabItemLits do
    if self.tabItemLits[i].data.tabType == tabType then
      return self.tabItemLits[i]
    end
  end
end

function UILWNewCenterTabList:SetNewTipActive(tabType, isOn)
  for i = 1, #self.tabItemLits do
    if self.tabItemLits[i].data.tabType == tabType then
      self.tabItemLits[i]:SetActiveNewTip(isOn)
      return
    end
  end
end

function UILWNewCenterTabList:GetTempRed()
  for i = 1, #self.tabItemLits do
    local item = self.tabItemLits[i]
    if item.showNewTip and not item.temRed then
      return true
    end
  end
  return false
end

function UILWNewCenterTabList:RefreshRedNew(tabType)
  for i = 1, #self.tabItemLits do
    if self.tabItemLits[i].data.tabType == tabType then
      self.tabItemLits[i]:RefreshRedNew()
      return
    end
  end
end

function UILWNewCenterTabList:OnClickBtn()
end

return UILWNewCenterTabList
