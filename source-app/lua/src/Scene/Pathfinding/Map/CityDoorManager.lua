local CityDoorManager = BaseClass("CityDoorManager")
local visitorTag = "visitor"
local openAnimName = "open"

local function __init(self)
  self.doorisOpen = false
  self.count = 0
  self.InitComponent(self)
end

local function __delete(self)
  self.triggerHandler.OnTriggerEnterAction = nil
  self.triggerHandler.OnTriggerExitAction = nil
  self.triggerHandler = nil
  self.m_gameObject = nil
  self.simpleAnim = nil
  self.count = nil
  self.doorStartPos = nil
  self.doorEndPos = nil
end

local function InitDoorPos(self)
  if not self.doorStartPos or not self.doorEndPos then
    local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.Building), BuildingTypes.LW_BUILD_GATE)
    local posList = string.split(line.para1, "|")
    local lineStartPos = string.split(posList[1], ";")
    local lineEndPos = string.split(posList[2], ";")
    self.inCityPos = Vector3.New(lineStartPos[1], 0, lineStartPos[2])
    self.outsideCityPos = Vector3.New(lineEndPos[1], 0, lineEndPos[2])
  end
end

local function InitComponent(self)
  if not IsNull(self.m_gameObject) then
    local buildDataList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_GATE)
    if buildDataList and not IsNull(CS.SceneManager.World) then
      self.m_gameObject = CS.SceneManager.World:GetBuildingByPoint(buildDataList[1].pointId)
    end
  end
  if not IsNull(self.m_gameObject) then
    self.triggerHandler = self.m_gameObject:GetComponent(typeof(CS.ColliderEventHandler))
    if self.triggerHandler ~= nil then
      function self.triggerHandler.OnTriggerEnterAction(obj)
        self:OnTriggerEnter(obj)
      end
      
      function self.triggerHandler.OnTriggerExitAction(obj)
        self:OnTriggerExit(obj)
      end
    end
    self.simpleAnim = self.m_gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation))
  end
end

local function OnTriggerEnter(self, obj)
  if obj.tag == visitorTag then
    if self.count == 0 then
      self.simpleAnim:Stop()
      self.simpleAnim:SetStateSpeed(openAnimName, 1)
      self.simpleAnim:Play(openAnimName)
    end
    self.count = self.count + 1
  end
end

local function OnTriggerExit(self, obj)
  if obj.tag == visitorTag then
    self.count = self.count - 1
    if self.count == 0 then
      self.simpleAnim:SetStateSpeed(openAnimName, -1)
      self.simpleAnim:Play(openAnimName)
    end
  end
end

local function GetDoorPos(self)
  InitDoorPos(self)
  return self.inCityPos, self.outsideCityPos
end

local function ClearCount(self)
  if SceneUtils.GetIsInCity() then
    self.count = 0
  end
end

CityDoorManager.__init = __init
CityDoorManager.__delete = __delete
CityDoorManager.GetDoorPos = GetDoorPos
CityDoorManager.InitDoorPos = InitDoorPos
CityDoorManager.OnTriggerEnter = OnTriggerEnter
CityDoorManager.OnTriggerExit = OnTriggerExit
CityDoorManager.InitComponent = InitComponent
CityDoorManager.ClearCount = ClearCount
return CityDoorManager
