BoardData = require("DataCenter.Board.BoardData")
local BoardManager = BaseClass("BoardManager")

local function __init(self)
  self.allBoards = {}
  self.posToBoard = {}
  self.deleteRoad = {}
end

local function __delete(self)
  self.allBoards = nil
  self.posToBoard = nil
  self.deleteRoad = nil
end

local function Startup()
end

local function InitData(self, message)
  if message.buildingRoads_new ~= nil then
    self.allBoards = {}
    self.posToBoard = {}
    self:UpdateRoads(message.buildingRoads_new)
  end
end

local function GetBoardData(self, uuid)
  return self.allBoards[uuid]
end

local function GetBoardDataByPointId(self, pointId)
  return self.posToBoard[pointId]
end

local function BuildRoadDestroyNewHandle(self, message)
  local list = self:GetOneAndRemoveDeleteRoads()
  if message.errorCode == nil then
    local roads = message.roads
    self:RemoveRoads(roads)
    if roads ~= nil then
      for k, v in pairs(roads) do
        CS.SceneManager.World:RemoveObjectByPoint(v)
      end
    end
  else
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(DataCenter.BuildManager:ShowBuildErrorCode(errorCode))
    end
    for k, v in ipairs(list) do
      CS.SceneManager.World:ShowObject(v)
    end
  end
end

local function AddOneDeleteRoads(self, list)
  table.insert(self.deleteRoad, list)
end

local function GetOneAndRemoveDeleteRoads(self)
  return table.remove(self.deleteRoad, 1)
end

local function IsHasBoard(self, pointId)
  return self:GetBoardDataByPointId(pointId) ~= nil
end

local function IsHasMainBoard(self, pointId)
  local boardData = self:GetBoardDataByPointId(pointId)
  return boardData ~= nil and boardData:IsMainRoad()
end

local function ResetBoard(self)
  self.allBoards = {}
  self.posToBoard = {}
  self.deleteRoad = {}
end

local function PushInitRoadHandle(self, message)
  if message.roads ~= nil then
    self:UpdateRoads(message.roads)
  end
end

local function UpdateRoads(self, arr)
  if arr ~= nil then
    local firePointId = {}
    local rangeRoad
    for k, v in pairs(arr) do
      local id = v.uuid
      local one = self.allBoards[id]
      if one == nil then
        one = BoardData.New()
        one:UpdateInfo(v)
        self.allBoards[id] = one
      else
        one:UpdateInfo(v)
      end
      self.posToBoard[one.pointId] = one
      EventManager:GetInstance():Broadcast(EventId.UpdateRoadData, id)
      firePointId[one.pointId] = one:GetPathRoadData()
      local list = one:GetRangeRoadPoints()
      if list ~= nil then
        for k1, v1 in ipairs(list) do
          rangeRoad = self:GetBoardDataByPointId(v1)
          if rangeRoad ~= nil and rangeRoad:IsShowRoad() then
            firePointId[v1] = rangeRoad:GetPathRoadData()
          end
        end
      end
    end
    local firData = {}
    for k, v in pairs(firePointId) do
      table.insert(firData, v)
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshCityRoadArr, firData)
  end
end

local function RemoveRoads(self, arr)
  if arr ~= nil then
    local firePointId = {}
    local rangeRoad
    local removeId = {}
    local removePointDic = {}
    for k, v in pairs(arr) do
      local road = self:GetBoardData(v)
      if road ~= nil then
        self.allBoards[v] = nil
        self.posToBoard[road.pointId] = nil
        local list = road:GetRangeRoadPoints()
        if list ~= nil then
          for k1, v1 in ipairs(list) do
            if removePointDic[v1] == nil then
              rangeRoad = self:GetBoardDataByPointId(v1)
              if rangeRoad ~= nil and rangeRoad:IsShowRoad() then
                firePointId[v1] = rangeRoad:GetPathRoadData()
              end
            end
          end
        end
        removePointDic[road.pointId] = true
        table.insert(removeId, road.pointId)
      end
      EventManager:GetInstance():Broadcast(EventId.UpdateRoadData, v)
    end
    EventManager:GetInstance():Broadcast(EventId.DeleteCityRoadArr, removeId)
    local firData = {}
    for k, v in pairs(firePointId) do
      if removePointDic[k] == nil then
        table.insert(firData, v)
      end
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshCityRoadArr, firData)
  end
end

local function GetBuildMaxRadius(self)
  local value = LuaEntry.DataConfig:TryGetNum("radius", "k2") + LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_CAN_BUILD_NUM)
  local x, y = math.modf(value)
  return x
end

local function GetOtherLimitRadius(self)
  local value = LuaEntry.DataConfig:TryGetNum("radius", "k3")
  local x, y = math.modf(value)
  return x
end

local function GetBuildTime(self)
  local result = 0
  local roadTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.FUN_BUILD_ROAD)
  if roadTemplate ~= nil then
    result = roadTemplate:GetBuildTime()
  end
  if result <= 0 then
    result = 1000
  end
  return result
end

local function PushUserRoadRemoveHandle(self, message)
  self:RemoveRoads(message.roads)
end

local function PushUserRoadStateUpdateHandle(self, message)
  if message.roads ~= nil then
    self:UpdateRoads(message.roads)
  end
end

local function GetAllRoadData(self)
  local result = {}
  for k, v in pairs(self.allBoards) do
    table.insert(result, v)
  end
  return result
end

local function GetBoardCount(self)
  return table.count(self.allBoards)
end

local function BuildRoadCreateNewHandle(self, message)
  local pos = CS.SceneManager.World:UIDestroyRoad()
  if message.errorCode == nil then
    if message.roads ~= nil then
      self:UpdateRoads(message.roads)
    end
    CS.SceneManager.World:StartPrintRoad(pos, false)
  else
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(DataCenter.BuildManager:ShowBuildErrorCode(errorCode))
    end
  end
end

local function GetBoardBuildMaxCount(self)
  local roadTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.FUN_BUILD_ROAD)
  if roadTemplate ~= nil then
    return roadTemplate:GetCurMaxCanBuildNum() + LuaEntry.Effect:GetGameEffect(EffectDefine.BUILD_ROAD_NUM_ADD)
  end
  return 0
end

local function GetBoardBuildTime(self)
  local roadTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.FUN_BUILD_ROAD)
  if roadTemplate ~= nil then
    return roadTemplate:GetBuildTime()
  end
  return 0
end

local function GetShowRoadDataByPointId(self, pointId)
  return nil
end

local function GetAllShowRoadData(self)
  local result = {}
  for k, v in pairs(self.allBoards) do
    if v:IsShowRoad() then
      table.insert(result, v)
    end
  end
  return result
end

local function GetAllPathRoadData(self)
  local result = {}
  for k, v in pairs(self.allBoards) do
    if DataCenter.CityDomeManager:IsInDomeByPoint(v.pointId) then
      table.insert(result, v:GetPathRoadData())
    end
  end
  return result
end

local function GetPathRoadData(self, pointId)
  local road = self:GetBoardDataByPointId(pointId)
  if road ~= nil then
    return road:GetPathRoadData()
  end
end

BoardManager.__init = __init
BoardManager.__delete = __delete
BoardManager.Startup = Startup
BoardManager.InitData = InitData
BoardManager.GetBoardData = GetBoardData
BoardManager.RemoveOneBoard = RemoveOneBoard
BoardManager.GetBoardDataByPointId = GetBoardDataByPointId
BoardManager.BuildRoadDestroyNewHandle = BuildRoadDestroyNewHandle
BoardManager.AddOneDeleteRoads = AddOneDeleteRoads
BoardManager.GetOneAndRemoveDeleteRoads = GetOneAndRemoveDeleteRoads
BoardManager.IsHasBoard = IsHasBoard
BoardManager.IsHasMainBoard = IsHasMainBoard
BoardManager.ResetBoard = ResetBoard
BoardManager.PushInitRoadHandle = PushInitRoadHandle
BoardManager.UpdateRoads = UpdateRoads
BoardManager.GetBuildMaxRadius = GetBuildMaxRadius
BoardManager.GetOtherLimitRadius = GetOtherLimitRadius
BoardManager.GetBuildTime = GetBuildTime
BoardManager.PushUserRoadRemoveHandle = PushUserRoadRemoveHandle
BoardManager.PushUserRoadStateUpdateHandle = PushUserRoadStateUpdateHandle
BoardManager.GetAllRoadData = GetAllRoadData
BoardManager.GetBoardCount = GetBoardCount
BoardManager.BuildRoadCreateNewHandle = BuildRoadCreateNewHandle
BoardManager.GetBoardBuildMaxCount = GetBoardBuildMaxCount
BoardManager.GetBoardBuildTime = GetBoardBuildTime
BoardManager.GetShowRoadDataByPointId = GetShowRoadDataByPointId
BoardManager.GetAllShowRoadData = GetAllShowRoadData
BoardManager.GetAllPathRoadData = GetAllPathRoadData
BoardManager.GetPathRoadData = GetPathRoadData
BoardManager.RemoveRoads = RemoveRoads
return BoardManager
