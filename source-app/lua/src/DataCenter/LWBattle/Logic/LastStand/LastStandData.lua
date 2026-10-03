local LastStandData = BaseClass("LastStandData")
local ConstLW = require("Scene.LWBattle.Const")

local function __init(self, id)
  self:InitData(id)
end

local function __delete(self)
end

local function Contains(self, x, z)
  for _, v in pairs(self.bossRect) do
    if x > v.xMin and x < v.xMax and z > v.zMin and z < v.zMax then
      return true
    end
  end
  return false
end

local DOOR_LEFT = 1
local DOOR_RIGHT = 2
local DOOR_TOP = 3
local DOOR_BOTTOM = 4
local DOOR_STATE_OPEN = 1
local DOOR_STATE_CLOSED = 2

local function InitData(self, stageMetaId)
  self.metaId = stageMetaId
  local line = LocalController:instance():getLine(TableName.lw_last_stand_feature, stageMetaId)
  self.meta = line
  self.meta.id = stageMetaId
  self.optRvo = LuaEntry.Player:GetGrayTestParkourRvoOptEnable(stageMetaId)
  local initPos = string.split(line:getValue("birth_point") or "", "|")
  self.initPosX = tonumber(initPos[1])
  self.initPosY = tonumber(initPos[2])
  self.endLine = line:getValue("boss_line")
  local boss_area_str = line:getValue("boss_area")
  boss_area_str = string.split(boss_area_str, ";")
  self.bossRect = {}
  for _, v in pairs(boss_area_str) do
    local rect = {}
    local boss_area_param = string.split(v, "|")
    rect.xMin = BARRAGE_SCENE_CENTER - tonumber(boss_area_param[2]) * 0.5
    rect.xMax = BARRAGE_SCENE_CENTER + tonumber(boss_area_param[2]) * 0.5
    rect.zMin = tonumber(boss_area_param[1])
    rect.zMax = tonumber(boss_area_param[1]) + tonumber(boss_area_param[3])
    table.insert(self.bossRect, rect)
  end
  local circleRadius = line:getValue("circle_radius")
  local circleRadiusArr = string.split(circleRadius, ";")
  self.circleRadiusList = {}
  for _, v in pairs(circleRadiusArr) do
    local param = string.split(v, "|")
    local radiusInfo = {}
    radiusInfo.maxCount = tonumber(param[2])
    radiusInfo.radius = tonumber(param[1])
    table.insert(self.circleRadiusList, radiusInfo)
  end
  self.wall_ring_str = line:getValue("wall_area")
  self.wallRings = {}
  self:InitWallConfig(self.wall_ring_str)
  self.doorRects = {}
  self.door_config_str = line:getValue("door_area")
  local doorCfgStr = string.split(self.door_config_str, ";")
  for _, doorStr in pairs(doorCfgStr) do
    local params = string.split(doorStr, "|")
    local doorType = tonumber(params[1])
    local doorX = tonumber(params[2])
    local doorZ = tonumber(params[3])
    local doorWidth = tonumber(params[4])
    local doorConfigId = tonumber(params[5])
    if self.wallRings[1] then
      local wallRing = self.wallRings[1]
      local doorRect = {}
      doorRect.posX = doorX
      doorRect.posZ = doorZ
      doorRect.type = doorType
      doorRect.configId = doorConfigId
      if doorType == DOOR_LEFT then
        doorRect.xMin = wallRing.outerXMin
        doorRect.xMax = wallRing.outerXMin + wallRing.thicknessLeft
        doorRect.zMin = doorZ - doorWidth / 2
        doorRect.zMax = doorZ + doorWidth / 2
      elseif doorType == DOOR_RIGHT then
        doorRect.xMin = wallRing.outerXMax - wallRing.thicknessRight
        doorRect.xMax = wallRing.outerXMax
        doorRect.zMin = doorZ - doorWidth / 2
        doorRect.zMax = doorZ + doorWidth / 2
      elseif doorType == DOOR_TOP then
        doorRect.zMin = wallRing.outerZMax - wallRing.thicknessTop
        doorRect.zMax = wallRing.outerZMax
        doorRect.xMin = doorX - doorWidth / 2
        doorRect.xMax = doorX + doorWidth / 2
      elseif doorType == DOOR_BOTTOM then
        doorRect.zMin = wallRing.outerZMin
        doorRect.zMax = wallRing.outerZMin + wallRing.thicknessBottom
        doorRect.xMin = doorX - doorWidth / 2
        doorRect.xMax = doorX + doorWidth / 2
      end
      table.insert(self.doorRects, doorRect)
    end
  end
  self:PrintAllDoorPositions()
  self.doorStates = {}
  for i = 1, #self.doorRects do
    self.doorStates[i] = DOOR_STATE_OPEN
  end
  self.doorContactStatus = {}
  for i = 1, #self.doorRects do
    self.doorContactStatus[i] = false
  end
  local startBuildingStr = line:getValue("start_building")
  self.startBuildingList = {}
  local startBuildingArr = string.split(startBuildingStr, "|")
  for _, v in pairs(startBuildingArr) do
    local building = {}
    local buildingParam = string.split(v, ";")
    building.id = tonumber(buildingParam[1])
    local posStr = buildingParam[2]
    local posArr = string.split(posStr, ",")
    building.pos = {
      x = tonumber(posArr[1]),
      z = tonumber(posArr[2])
    }
    table.insert(self.startBuildingList, building)
  end
  self.allBuildingList = {}
  local allBuildingStr = line:getValue("all_building")
  local allBuildingArr = string.split(allBuildingStr, "|")
  for _, v in pairs(allBuildingArr) do
    local building = {}
    local buildingParam = string.split(v, ";")
    building.id = tonumber(buildingParam[1])
    local posStr = buildingParam[2]
    local posArr = string.split(posStr, ",")
    building.pos = {
      x = tonumber(posArr[1]),
      z = tonumber(posArr[2])
    }
    table.insert(self.allBuildingList, building)
  end
  self.buildingColliders = {}
  self.buildingExistMap = {}
  self.moveSpeedX = line:getValue("speed_x")
  self.moveSpeedZ = line:getValue("speed_z")
  self.moveDeltaMulti = 1
  self.sceneCfgArr = {}
  local sceneIdArray = string.split(line:getValue("scene") or "", ",")
  local offset = 0
  for _, sceneId in ipairs(sceneIdArray) do
    local sceneMeta = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Scene), sceneId)
    local sceneCfg = {}
    sceneCfg.meta = sceneMeta
    sceneCfg.offset = offset
    sceneCfg.isDeco = false
    sceneCfg.hasAnim = sceneMeta.animation == "1"
    table.insert(self.sceneCfgArr, sceneCfg)
    offset = offset + sceneMeta.scene_size
  end
  local sceneMeta = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Scene), line:getValue("scene_tail"))
  local sceneCfg = {}
  sceneCfg.meta = sceneMeta
  sceneCfg.offset = offset
  sceneCfg.isDeco = true
  sceneCfg.hasAnim = sceneMeta.animation == "1"
  table.insert(self.sceneCfgArr, sceneCfg)
  offset = offset + sceneMeta.scene_size
  sceneCfg = {}
  sceneCfg.meta = sceneMeta
  sceneCfg.offset = -1 * sceneMeta.scene_size
  sceneCfg.isDeco = true
  sceneCfg.hasAnim = sceneMeta.animation == "1"
  table.insert(self.sceneCfgArr, sceneCfg)
  self.battleType = line:getValue("type")
  local circle_pos = line:getValue("circle_pos")
  if not string.IsNullOrEmpty(circle_pos) then
    local circlePosArray = string.split(circle_pos, ";")
    self.circlePos = {}
    for i = 1, #circlePosArray do
      local str = circlePosArray[i]
      if not string.IsNullOrEmpty(str) then
        local array = string.split(str, "|")
        if #array == 2 then
          local radius = tonumber(array[1]) or 0
          local count = tonumber(array[2]) or 0
          if 0 < count then
            table.insert(self.circlePos, {radius = radius, count = count})
          end
        end
      end
    end
  end
  local special_circle_pos = line:getValue("special_circle_pos")
  if not string.IsNullOrEmpty(special_circle_pos) then
    local specialCirclePosArray = string.split(special_circle_pos, ";")
    self.specialCirclePos = {}
    for i = 1, #specialCirclePosArray do
      local str = specialCirclePosArray[i]
      if not string.IsNullOrEmpty(str) then
        local array = string.split(str, "|")
        if #array == 2 then
          local x = tonumber(array[1]) or 0
          local y = tonumber(array[2]) or 0
          if i <= 5 or 0 < y then
            table.insert(self.specialCirclePos, {x = x, y = y})
          end
        end
      end
    end
  end
  self.showEnergy = line:getValue("energy_show") == "1"
  self.cameraParams = line:getValue("camera_params")
  self.isBlock = line:getValue("is_block") == "1"
  self.sceneExt = line:getValue("sceneExt")
  local formationSpecialType = line:getValue("formation_special_type")
  if not string.IsNullOrEmpty(formationSpecialType) then
    self.formationSpecialType = tonumber(formationSpecialType)
  else
    self.formationSpecialType = nil
  end
  self.default_hero_add = tonumber(line:getValue("default_hero_add")) or 0
  self.useViewBossHpBar = (tonumber(line:getValue("boss_HPbar")) or 0) == 1
  self.bossCameraZoom = tonumber(line:getValue("boss_camera_zoom")) or 30
  self.start_gold = tonumber(line:getValue("start_gold")) or 0
  self.start_guide = tonumber(line:getValue("start_guide"))
end

function LastStandData:GetAppearanceMap()
  return self.appearanceMap
end

function LastStandData:IsCircleInWallArea(circleX, circleZ, radius)
  for _, wallRing in pairs(self.wallRings) do
    local leftWallRect = {
      xMin = wallRing.outerXMin,
      xMax = wallRing.innerXMin,
      zMin = wallRing.outerZMin,
      zMax = wallRing.outerZMax
    }
    local rightWallRect = {
      xMin = wallRing.innerXMax,
      xMax = wallRing.outerXMax,
      zMin = wallRing.outerZMin,
      zMax = wallRing.outerZMax
    }
    local bottomWallRect = {
      xMin = wallRing.innerXMin,
      xMax = wallRing.innerXMax,
      zMin = wallRing.outerZMin,
      zMax = wallRing.innerZMin
    }
    local topWallRect = {
      xMin = wallRing.innerXMin,
      xMax = wallRing.innerXMax,
      zMin = wallRing.innerZMax,
      zMax = wallRing.outerZMax
    }
    local inLeftWall = self:CircleRectIntersect(circleX, circleZ, radius, leftWallRect.xMin, leftWallRect.zMin, leftWallRect.xMax, leftWallRect.zMax)
    local inRightWall = self:CircleRectIntersect(circleX, circleZ, radius, rightWallRect.xMin, rightWallRect.zMin, rightWallRect.xMax, rightWallRect.zMax)
    local inBottomWall = self:CircleRectIntersect(circleX, circleZ, radius, bottomWallRect.xMin, bottomWallRect.zMin, bottomWallRect.xMax, bottomWallRect.zMax)
    local inTopWall = self:CircleRectIntersect(circleX, circleZ, radius, topWallRect.xMin, topWallRect.zMin, topWallRect.xMax, topWallRect.zMax)
    if inLeftWall or inRightWall or inBottomWall or inTopWall then
      local canPassThroughDoor = false
      for i, doorRect in pairs(self.doorRects) do
        local doorWidth = doorRect.xMax - doorRect.xMin
        local doorHeight = doorRect.zMax - doorRect.zMin
        if doorWidth < doorHeight then
          if circleZ - radius >= doorRect.zMin and circleZ + radius <= doorRect.zMax then
            canPassThroughDoor = true
            break
          end
        elseif circleX - radius >= doorRect.xMin and circleX + radius <= doorRect.xMax then
          canPassThroughDoor = true
          break
        end
      end
      if not canPassThroughDoor then
        return true
      end
    end
  end
  return false
end

function LastStandData:CircleRectIntersect(circleX, circleZ, radius, rectXMin, rectZMin, rectXMax, rectZMax)
  local closestX = math.max(rectXMin, math.min(circleX, rectXMax))
  local closestZ = math.max(rectZMin, math.min(circleZ, rectZMax))
  local distanceX = circleX - closestX
  local distanceZ = circleZ - closestZ
  local distanceSquared = distanceX * distanceX + distanceZ * distanceZ
  return distanceSquared < radius * radius
end

function LastStandData:IsPointInWallArea(x, z)
  for _, wallRing in pairs(self.wallRings) do
    if x > wallRing.innerXMin and x < wallRing.innerXMax and z > wallRing.innerZMin and z < wallRing.innerZMax then
      return true
    end
  end
  return false
end

function LastStandData:DrawWalls(pos, radius)
  for _, wallRing in pairs(self.wallRings) do
    self:DrawRectangle(wallRing.outerXMin, wallRing.outerZMin, wallRing.outerXMax, wallRing.outerZMax, Color.red)
    self:DrawRectangle(wallRing.innerXMin, wallRing.innerZMin, wallRing.innerXMax, wallRing.innerZMax, Color.green)
  end
  for _, doorRect in pairs(self.doorRects) do
    self:DrawRectangle(doorRect.xMin, doorRect.zMin, doorRect.xMax, doorRect.zMax, Color.blue)
  end
  if pos then
    self:DrawCircle(pos.x, pos.z, radius, Color.yellow, 20)
  end
  self:DrawBuildingColliders()
end

function LastStandData:DrawCircle(centerX, centerZ, radius, color, segments)
  segments = segments or 20
  local angleStep = 2 * math.pi / segments
  for i = 1, segments do
    local angle1 = (i - 1) * angleStep
    local angle2 = i * angleStep
    local x1 = centerX + radius * math.cos(angle1)
    local z1 = centerZ + radius * math.sin(angle1)
    local x2 = centerX + radius * math.cos(angle2)
    local z2 = centerZ + radius * math.sin(angle2)
    local point1 = Vector3(x1, 0, z1)
    local point2 = Vector3(x2, 0, z2)
    CS.UnityEngine.Debug.DrawLine(point1, point2, color)
  end
end

function LastStandData:DrawRectangle(xMin, zMin, xMax, zMax, color)
  local bottomLeft = Vector3(xMin, 0, zMin)
  local bottomRight = Vector3(xMax, 0, zMin)
  local topRight = Vector3(xMax, 0, zMax)
  local topLeft = Vector3(xMin, 0, zMax)
  CS.UnityEngine.Debug.DrawLine(bottomLeft, bottomRight, color)
  CS.UnityEngine.Debug.DrawLine(bottomRight, topRight, color)
  CS.UnityEngine.Debug.DrawLine(topRight, topLeft, color)
  CS.UnityEngine.Debug.DrawLine(topLeft, bottomLeft, color)
end

function LastStandData:SetDoorState(doorIndex, state)
  if doorIndex and self.doorStates[doorIndex] then
    self.doorStates[doorIndex] = state
    return true
  end
  return false
end

function LastStandData:GetDoorState(doorIndex)
  return self.doorStates[doorIndex] or DOOR_STATE_CLOSED
end

function LastStandData:OpenDoor(doorIndex)
  return self:SetDoorState(doorIndex, DOOR_STATE_OPEN)
end

function LastStandData:CloseDoor(doorIndex)
  return self:SetDoorState(doorIndex, DOOR_STATE_CLOSED)
end

function LastStandData:ToggleDoor(doorIndex)
  local currentState = self:GetDoorState(doorIndex)
  local newState = currentState == DOOR_STATE_OPEN and DOOR_STATE_CLOSED or DOOR_STATE_OPEN
  return self:SetDoorState(doorIndex, newState)
end

function LastStandData:CheckDoorContact(circleX, circleZ, radius)
  local doorType, direction
  for i, doorRect in ipairs(self.doorRects) do
    local isContact = self:CircleRectIntersect(circleX, circleZ, radius, doorRect.xMin, doorRect.zMin, doorRect.xMax, doorRect.zMax)
    local wasContact = self.doorContactStatus[i]
    if isContact ~= wasContact then
      local triggerDirection
      if isContact then
        local doorCenterX = (doorRect.xMin + doorRect.xMax) / 2
        local doorCenterZ = (doorRect.zMin + doorRect.zMax) / 2
        if doorRect.type == LastStandDoorType.Left then
          triggerDirection = circleX > doorCenterX and LastStandDoorContactDirection.FromInside or LastStandDoorContactDirection.FromOutside
        elseif doorRect.type == LastStandDoorType.Right then
          triggerDirection = circleX < doorCenterX and LastStandDoorContactDirection.FromInside or LastStandDoorContactDirection.FromOutside
        elseif doorRect.type == LastStandDoorType.Top then
          triggerDirection = circleZ < doorCenterZ and LastStandDoorContactDirection.FromInside or LastStandDoorContactDirection.FromOutside
        elseif doorRect.type == LastStandDoorType.Bottom then
          triggerDirection = circleZ > doorCenterZ and LastStandDoorContactDirection.FromInside or LastStandDoorContactDirection.FromOutside
        end
      else
        triggerDirection = LastStandDoorContactDirection.Leave
      end
      doorType = doorRect.type
      direction = triggerDirection
      self.doorContactStatus[i] = isContact
      break
    end
  end
  return doorType, direction
end

function LastStandData:GetDoorWorldPosition(doorIndex)
  if self.doorRects[doorIndex] then
    local doorRect = self.doorRects[doorIndex]
    local centerX = (doorRect.xMin + doorRect.xMax) / 2
    local centerZ = (doorRect.zMin + doorRect.zMax) / 2
    return Vector3(centerX, 0, centerZ)
  end
  return nil
end

function LastStandData:PrintAllDoorPositions()
  for i, doorRect in ipairs(self.doorRects) do
    local centerPos = self:GetDoorWorldPosition(i)
    if centerPos then
      local width = doorRect.xMax - doorRect.xMin
      local height = doorRect.zMax - doorRect.zMin
    else
    end
  end
end

function LastStandData:GetDoorInfo()
  return self.doorRects
end

function LastStandData:InitWallConfig(wallConfigStr)
  local params = string.split(wallConfigStr, "|")
  local wallRing = {}
  local innerBounds = string.split(params[1], ",")
  wallRing.innerXMin = tonumber(innerBounds[1])
  wallRing.innerZMin = tonumber(innerBounds[2])
  wallRing.innerXMax = tonumber(innerBounds[3])
  wallRing.innerZMax = tonumber(innerBounds[4])
  local outerBounds = string.split(params[2], ",")
  wallRing.outerXMin = tonumber(outerBounds[1])
  wallRing.outerZMin = tonumber(outerBounds[2])
  wallRing.outerXMax = tonumber(outerBounds[3])
  wallRing.outerZMax = tonumber(outerBounds[4])
  wallRing.thicknessLeft = wallRing.innerXMin - wallRing.outerXMin
  wallRing.thicknessRight = wallRing.outerXMax - wallRing.innerXMax
  wallRing.thicknessBottom = wallRing.innerZMin - wallRing.outerZMin
  wallRing.thicknessTop = wallRing.outerZMax - wallRing.innerZMax
  table.insert(self.wallRings, wallRing)
end

function LastStandData:CheckBuildingCollision(circleX, circleZ, radius)
  for _, collider in ipairs(self.buildingColliders) do
    local distanceSquared = (circleX - collider.x) ^ 2 + (circleZ - collider.z) ^ 2
    local minDistance = radius + collider.radius
    if distanceSquared <= minDistance ^ 2 then
      return true, collider
    end
  end
  return false, nil
end

function LastStandData:GetBuildingRadius(buildingId)
  return 1
end

function LastStandData:DrawBuildingColliders()
  for _, collider in ipairs(self.buildingColliders) do
    self:DrawCircle(collider.x, collider.z, collider.radius, Color.magenta, 30)
  end
end

function LastStandData:SetBuildingExist(buildingCfg, x, z)
  if buildingCfg.type == LastStandBuildType.Gate or buildingCfg.type == LastStandBuildType.ArmyYard then
    return
  end
  for _, info in ipairs(self.buildingColliders) do
    if info.x == x and info.z == z then
      return
    end
  end
  local info = {
    id = buildingCfg.id,
    x = x,
    z = z,
    radius = self:GetBuildingRadius(buildingCfg.id)
  }
  table.insert(self.buildingColliders, info)
end

function LastStandData:GetBuildingPosInfo(buildingId)
  for _, building in ipairs(self.allBuildingList) do
    if building.id == buildingId then
      return building.pos
    end
  end
  for _, building in ipairs(self.startBuildingList) do
    if building.id == buildingId then
      return building.pos
    end
  end
  return nil
end

function LastStandData:FindNearbyEmptyPosition(x, z, radius, maxSearchRadius)
  radius = radius or 3
  maxSearchRadius = maxSearchRadius or 10
  local directions = {
    {1, 0},
    {0, 1},
    {-1, 0},
    {0, -1},
    {0.707, 0.707},
    {0.707, -0.707},
    {-0.707, 0.707},
    {-0.707, -0.707}
  }
  local searchDistances = {
    2,
    4,
    6,
    8,
    10
  }
  for _, dist in ipairs(searchDistances) do
    if maxSearchRadius < dist then
      break
    end
    for _, dir in ipairs(directions) do
      local testX = x + dir[1] * dist
      local testZ = z + dir[2] * dist
      if self:Contains(testX, testZ) and not self:IsCircleInWallArea(testX, testZ, radius) and not self:CheckBuildingCollision(testX, testZ, radius) then
        return testX, testZ, true
      end
    end
  end
  return x, z, false
end

function LastStandData:GetTeamRadius(curTeamNum)
  if not self.circleRadiusList or #self.circleRadiusList == 0 then
    return 3
  end
  for i, v in ipairs(self.circleRadiusList) do
    if curTeamNum <= v.maxCount then
      return v.radius
    end
  end
  return self.circleRadiusList[#self.circleRadiusList].radius
end

LastStandData.__init = __init
LastStandData.__delete = __delete
LastStandData.InitData = InitData
LastStandData.Contains = Contains
return LastStandData
