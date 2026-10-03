local base = UIBaseView
local SuppliesShow = BaseClass("SuppliesShow", base)
local SuppliesShowItem = require("UI.LWSeason4.Activity.SeasonSupplies.SuppliesShow.SuppliesShowItem")
local __ShowTime = 3
local root_path = "Bg/Root"
local suppliesShowItem_path = "Bg/Root/SuppliesShowItem"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

local function OnDestroy(self)
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
  self.root = self:AddComponent(UIBaseContainer, root_path)
  self.suppliesShowItem = self:AddComponent(UIBaseContainer, suppliesShowItem_path)
  self.showObj = self.suppliesShowItem.gameObject
  self.showObj:GameObjectCreatePool()
  self.showObj:SetActive(false)
end

local function ComponentDestroy(self)
  self.root:RemoveComponents(SuppliesShowItem)
  self.showObj:GameObjectRecycleAll()
  self.root = nil
  self.suppliesShowItem = nil
end

local function DataDefine(self)
  self.itemIndex = 0
  self.itemList = {}
end

local function DataDestroy(self)
end

function SuppliesShow:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DiscoverSuppliesInfo, self.RefreshView)
end

function SuppliesShow:OnRemoveListener()
  self:RemoveUIListener(EventId.DiscoverSuppliesInfo, self.RefreshView)
  base.OnRemoveListener(self)
end

function SuppliesShow:Update1000MS()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for item, expireTime in pairs(self.itemList) do
    if item and expireTime <= curTime then
      self:OnShowItemEnd(item)
    end
  end
  if table.IsNullOrEmpty(self.itemList) then
    self.ctrl:CloseSelf()
  end
end

function SuppliesShow:RefreshView()
  local list = DataCenter.SeasonSuppliesShareDataManager.discovererList
  if not list or #list == 0 then
    self.ctrl:CloseSelf()
    return
  end
  for i, data in ipairs(list) do
    self:ShowNextItem(data)
  end
  DataCenter.SeasonSuppliesShareDataManager.discovererList = nil
end

function SuppliesShow:ShowNextItem(data)
  if not data then
    return
  end
  self.itemIndex = self.itemIndex + 1
  local showItem = self.showObj:GameObjectSpawn(self.root.transform)
  showItem.name = string.format("SuppliesShow_%d", self.itemIndex)
  showItem = self.root:AddComponent(SuppliesShowItem, showItem.name)
  showItem:ReInit(self.itemIndex, data)
  showItem:ShowFadeInEffect(__ShowTime)
  showItem:SetActive(true)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.itemList[showItem] = curTime + __ShowTime * 1000
end

function SuppliesShow:OnShowItemEnd(item)
  self.root:RemoveComponent(item.name, SuppliesShowItem)
  item.gameObject:GameObjectRecycle()
  self.itemList[item] = nil
end

SuppliesShow.OnCreate = OnCreate
SuppliesShow.OnDestroy = OnDestroy
SuppliesShow.OnEnable = OnEnable
SuppliesShow.OnDisable = OnDisable
SuppliesShow.ComponentDefine = ComponentDefine
SuppliesShow.ComponentDestroy = ComponentDestroy
SuppliesShow.DataDefine = DataDefine
SuppliesShow.DataDestroy = DataDestroy
return SuppliesShow
