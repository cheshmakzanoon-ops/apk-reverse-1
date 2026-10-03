local BaseExpansionTemplateManager = BaseClass("BaseExpansionTemplateManager")
local BaseExpansionTemplate = require("DataCenter.BaseExpansion.BaseExpansionTemplate")

local function __init(self)
  self.templateDict = nil
  self.buildInCityCanPutPoint = {}
  self.buildNoPutPoint = {}
  self.roadCanPutPoint = {}
end

local function __delete(self)
  self.templateDict = nil
  self.buildInCityCanPutPoint = nil
  self.buildNoPutPoint = nil
  self.roadCanPutPoint = nil
end

local function Startup(self)
end

local function InitTemplateDict(self)
  self.templateDict = {}
  LocalController:instance():visitTable(TableName.BaseExpansion, function(id, lineData)
    local template = BaseExpansionTemplate.New()
    template:InitData(lineData)
    self.templateDict[id] = template
  end)
end

local function GetTemplate(self, id)
  return self:GetTemplateDict()[tostring(id)]
end

local function GetTemplateDict(self)
  if self.templateDict == nil then
    self:InitTemplateDict()
  end
  return self.templateDict
end

local function InitPositionUnit(self)
  self.buildInCityCanPutPoint = {}
  self.buildNoPutPoint = {}
  self.roadCanPutPoint = {}
  LocalController:instance():visitTable(LuaEntry.Player:GetABTestTableName(TableName.SingleMapPosition), function(id, lineData)
    local unitType = lineData:getValue("UnitType")
    local list
    if unitType == PositionUnitType.DefaultRoad then
      list = self.roadCanPutPoint
    elseif unitType == PositionUnitType.InCityCanBuildPoint then
      list = self.buildInCityCanPutPoint
    elseif unitType == PositionUnitType.NoBuildPoint then
      list = self.buildNoPutPoint
    end
    if list ~= nil then
      local pos = lineData:getValue("Pos")
      local count = table.count(pos)
      if 1 < count then
        self:AddPositionUnit(list, pos[1], pos[2])
      end
    end
  end)
end

local function AddPositionUnit(self, list, x, y)
  if list[x] == nil then
    list[x] = {}
  end
  list[x][y] = true
end

local function IsCanPutBuildInCity(self, point)
  local vecPos = SceneUtils.IndexToTilePos(point)
  local mainPos = DataCenter.BuildManager.main_city_pos
  local x = vecPos.x - mainPos.x
  local y = vecPos.y - mainPos.y
  return self.buildInCityCanPutPoint[x] ~= nil and self.buildInCityCanPutPoint[x][y] ~= nil
end

local function IsPutNoPoint(self, point)
  local vecPos = SceneUtils.IndexToTilePos(point)
  local mainPos = DataCenter.BuildManager.main_city_pos
  local x = vecPos.x - mainPos.x
  local y = vecPos.y - mainPos.y
  return self.buildNoPutPoint[x] ~= nil and self.buildNoPutPoint[x][y] ~= nil
end

local function IsDefaultRoad(self, point)
  local vecPos = SceneUtils.IndexToTilePos(point)
  local mainPos = DataCenter.BuildManager.main_city_pos
  local x = vecPos.x - mainPos.x
  local y = vecPos.y - mainPos.y
  return self.roadCanPutPoint[x] ~= nil and self.roadCanPutPoint[x][y] ~= nil
end

BaseExpansionTemplateManager.__init = __init
BaseExpansionTemplateManager.__delete = __delete
BaseExpansionTemplateManager.Startup = Startup
BaseExpansionTemplateManager.InitTemplateDict = InitTemplateDict
BaseExpansionTemplateManager.GetTemplate = GetTemplate
BaseExpansionTemplateManager.GetTemplateDict = GetTemplateDict
BaseExpansionTemplateManager.InitPositionUnit = InitPositionUnit
BaseExpansionTemplateManager.AddPositionUnit = AddPositionUnit
BaseExpansionTemplateManager.IsCanPutBuildInCity = IsCanPutBuildInCity
BaseExpansionTemplateManager.IsPutNoPoint = IsPutNoPoint
BaseExpansionTemplateManager.IsDefaultRoad = IsDefaultRoad
return BaseExpansionTemplateManager
