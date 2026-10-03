local base = UIBaseContainer
local GoldTreePrayDetail = BaseClass("GoldTreePrayDetail", base)
local GoldTreePrayPlayerList = require("UI.LWSeason.LWSeasonGoldTree.Component.GoldTreePrayPlayerList")
local listItem_path = "GoldTreePrayPlayerList"
local content_path = "Viewport/Content"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
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
  self.listItem = self:AddComponent(UIBaseContainer, listItem_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.listObj = self.listItem.gameObject
  self.listObj:GameObjectCreatePool()
  self.listObj:SetActive(false)
end

local function ComponentDestroy(self)
  self.content:RemoveComponents(GoldTreePrayPlayerList)
  self.listObj:GameObjectRecycleAll()
  self.listItem = nil
  self.content = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function GoldTreePrayDetail:RefreshView(data)
  data = data or DataCenter.SeasonGoldTreeManager.announceMap[-1]
  self.content:RemoveComponents(GoldTreePrayPlayerList)
  self.listObj:GameObjectRecycleAll()
  if not data or not data.announceArr then
    return
  end
  local trans = self.content.transform
  for i, v in ipairs(data.announceArr) do
    local theItem = self.listObj:GameObjectSpawn(trans)
    theItem.name = string.format("PrayList_%d", i)
    theItem:SetActive(true)
    theItem = self.content:AddComponent(GoldTreePrayPlayerList, theItem.name)
    theItem:ReInit(v)
  end
end

GoldTreePrayDetail.OnCreate = OnCreate
GoldTreePrayDetail.OnDestroy = OnDestroy
GoldTreePrayDetail.OnEnable = OnEnable
GoldTreePrayDetail.OnDisable = OnDisable
GoldTreePrayDetail.ComponentDefine = ComponentDefine
GoldTreePrayDetail.ComponentDestroy = ComponentDestroy
GoldTreePrayDetail.DataDefine = DataDefine
GoldTreePrayDetail.DataDestroy = DataDestroy
return GoldTreePrayDetail
