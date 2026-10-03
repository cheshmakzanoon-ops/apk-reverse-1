local AlLeaderElectResult_R4 = BaseClass("AlLeaderElectResult_R4", UIBaseContainer)
local AlLeaderElectResultItem = require("UI.UIAlliance.UIAlLeaderElectResult.Component.AlLeaderElectReusltItem")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local desc_path = "ScrollView/NameTxt"
local svPlayers_path = "ScrollView"

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
  self.descN = self:AddComponent(UIText, desc_path)
  self.descN:SetLocalText(390939)
  self.svPlayersN = self:AddComponent(UIScrollView, svPlayers_path)
  self.svPlayersN:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.svPlayersN:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.playerList = {}
end

local function DataDestroy(self)
  self.playerList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetItem(self, r4List)
  self.playerList = r4List
  if self.playerList then
    self.svPlayersN:SetTotalCount(#self.playerList)
    self.svPlayersN:RefillCells()
  end
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.svPlayersN:AddComponent(AlLeaderElectResultItem, itemObj)
  cellItem:SetItem(self.playerList[index])
end

local function OnItemMoveOut(self, itemObj, index)
  self.svPlayersN:RemoveComponent(itemObj.name, AlLeaderElectResultItem)
end

local function ClearScroll(self)
  self.svPlayersN:ClearCells()
  self.svPlayersN:RemoveComponents(AlLeaderElectResultItem)
end

AlLeaderElectResult_R4.OnCreate = OnCreate
AlLeaderElectResult_R4.OnDestroy = OnDestroy
AlLeaderElectResult_R4.OnEnable = OnEnable
AlLeaderElectResult_R4.OnDisable = OnDisable
AlLeaderElectResult_R4.ComponentDefine = ComponentDefine
AlLeaderElectResult_R4.ComponentDestroy = ComponentDestroy
AlLeaderElectResult_R4.DataDefine = DataDefine
AlLeaderElectResult_R4.DataDestroy = DataDestroy
AlLeaderElectResult_R4.OnAddListener = OnAddListener
AlLeaderElectResult_R4.OnRemoveListener = OnRemoveListener
AlLeaderElectResult_R4.SetItem = SetItem
AlLeaderElectResult_R4.OnItemMoveIn = OnItemMoveIn
AlLeaderElectResult_R4.OnItemMoveOut = OnItemMoveOut
AlLeaderElectResult_R4.ClearScroll = ClearScroll
return AlLeaderElectResult_R4
