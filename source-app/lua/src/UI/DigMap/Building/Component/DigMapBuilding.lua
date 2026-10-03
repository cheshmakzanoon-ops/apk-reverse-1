local base = require("UI.DigMap.DigMap")
local DiggingMap = BaseClass("DigMapBuilding", base)
local DiggingMapBrick = require("UI.DigMap.Building.Component.DigMapBrickBuilding")
local DiggingMapBlock = require("UI.DigMap.DigMapBlock")

local function OnCreate(self)
  self:InitBlockAndBrickScriptByType(DiggingMapBrick, DiggingMapBlock)
  base.OnCreate(self)
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function DataDefine(self)
  base.DataDefine(self)
end

local function DataDestroy(self)
  base.DataDestroy(self)
end

function DiggingMap:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BuildingDigGameOpen, self.OnOpen)
end

function DiggingMap:OnRemoveListener()
  self:RemoveUIListener(EventId.BuildingDigGameOpen, self.OnOpen)
  base.OnRemoveListener(self)
end

function DiggingMap:OnOpen(openData)
  base.OnOpen(self, openData)
end

DiggingMap.OnCreate = OnCreate
DiggingMap.OnDestroy = OnDestroy
DiggingMap.OnEnable = OnEnable
DiggingMap.OnDisable = OnDisable
DiggingMap.DataDefine = DataDefine
DiggingMap.DataDestroy = DataDestroy
return DiggingMap
