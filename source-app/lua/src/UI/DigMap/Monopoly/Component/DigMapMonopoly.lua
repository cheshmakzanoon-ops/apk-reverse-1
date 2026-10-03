local base = require("UI.DigMap.DigMap")
local DiggingMap = BaseClass("DigMapMonopoly", base)
local DiggingMapBrick = require("UI.DigMap.Monopoly.Component.DigMapBrickMonopoly")
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
  self:AddUIListener(EventId.MonopolyDigGameOpen, self.OnOpen)
end

function DiggingMap:OnRemoveListener()
  self:RemoveUIListener(EventId.MonopolyDigGameOpen, self.OnOpen)
  base.OnRemoveListener(self)
end

function DiggingMap:OnOpen(openData)
  base.OnOpen(self, openData)
end

function DiggingMap:OnOpen(openData)
  if not openData then
    return
  end
  self:OpenBrick(openData.pos)
  if openData.openBlockInfo then
    self:UpdateBlock(openData.openBlockInfo, true)
  end
end

DiggingMap.OnCreate = OnCreate
DiggingMap.OnDestroy = OnDestroy
DiggingMap.OnEnable = OnEnable
DiggingMap.OnDisable = OnDisable
DiggingMap.DataDefine = DataDefine
DiggingMap.DataDestroy = DataDestroy
return DiggingMap
