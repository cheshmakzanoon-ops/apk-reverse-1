local BirthPointTemplateManager = BaseClass("BirthPointTemplateManager")

local function __init(self)
  self.curDataServerId = nil
  self.curWorldCityTableName = nil
  self.startX = nil
  self.startY = nil
  self.spaceX = nil
  self.spaceY = nil
  self.genRadius = nil
  self.bornNew = true
  self.blackLandPos = {
    {x = 448, y = 549},
    {x = 551, y = 549},
    {x = 448, y = 446},
    {x = 551, y = 446}
  }
  self.blackLandPosSeasonDic = nil
  self.blackLandDecSpeedArr = {}
  self.kingCityOccupyRange = {
    minX = 489,
    maxX = 509,
    minY = 487,
    maxY = 507
  }
end

local function __delete(self)
  self.bornNew = nil
  self.curDataServerId = nil
  self.curWorldCityTableName = nil
  self.startX = nil
  self.startY = nil
  self.spaceX = nil
  self.spaceY = nil
  self.genRadius = nil
  self.kingCityOccupyRange = nil
end

function BirthPointTemplateManager:InitData()
  local serverId = LuaEntry.Player:GetSelfServerId()
  if self.curDataServerId ~= nil and self.curDataServerId == serverId then
    return
  end
  local worldCityTableName = SeasonUtil.GetWorldCityTableNameByServerId(serverId)
  if self.curWorldCityTableName == worldCityTableName then
    return
  end
  self:InitBornPointList()
  self.curDataServerId = serverId
  self.curWorldCityTableName = worldCityTableName
end

function BirthPointTemplateManager:EnterWorld()
  if self.curWorldCityTableName == nil then
    local serverId = LuaEntry.Player:GetCurServerId()
    self:InitAllBirthPoint(serverId)
  end
end

local function InitAllBirthPoint(self, serverId)
  local worldCityTableName = SeasonUtil.GetWorldCityTableNameByServerId(serverId)
  if self.curWorldCityTableName == worldCityTableName and self.allianceCityFootprint and self.allianceCityField and self.cityDataALL then
    return
  end
  self.curWorldCityTableName = worldCityTableName
  self.allianceCityFootprint = {}
  self.allianceCityField = {}
  self.cityDataALL = DataCenter.AllianceCityTemplateManager:InitTemplateDict(serverId)
end

local function InitBornPointList(self)
  self.startX = LuaEntry.DataConfig:TryGetNum("gen_born_point_param", "k1", 25)
  self.startY = LuaEntry.DataConfig:TryGetNum("gen_born_point_param", "k2", 25)
  self.spaceX = LuaEntry.DataConfig:TryGetNum("gen_born_point_param", "k3", 30)
  self.spaceY = LuaEntry.DataConfig:TryGetNum("gen_born_point_param", "k4", 30)
  self.genRadius = LuaEntry.DataConfig:TryGetNum("gen_born_point_param", "k5", 15)
  self.bornNew = LuaEntry.DataConfig:TryGetNum("gen_born_point_param", "k6") == 1
  self.blackLandPos = self:ParseRockyGround(LuaEntry.DataConfig:TryGetStr("wonder_rocky_ground", "k1"))
  local wonder_rocky_ground_k2 = LuaEntry.DataConfig:TryGetStr("wonder_rocky_ground", "k2", 0.1)
  if wonder_rocky_ground_k2 ~= nil and wonder_rocky_ground_k2 ~= "" then
    self.blackLandDecSpeedArr = {}
    for item in string.gmatch(wonder_rocky_ground_k2, "([^|]+)|?") do
      local serverStr, speedStr = string.match(item, "(%d+-?%d+);(%d+.?%d*)")
      if serverStr ~= nil and speedStr ~= nil then
        local speed = tonumber(speedStr)
        local serverMinStr, serverMaxStr = string.match(serverStr, "(%d+)-(%d+)")
        if serverMinStr ~= nil and serverMaxStr ~= nil then
          table.insert(self.blackLandDecSpeedArr, {
            min = tonumber(serverMinStr),
            max = tonumber(serverMaxStr),
            speed = speed
          })
        else
          local serverId = tonumber(serverStr)
          if serverId ~= nil then
            table.insert(self.blackLandDecSpeedArr, {
              min = serverId,
              max = serverId,
              speed = speed
            })
          end
        end
      end
    end
  end
  local king_city_range = LuaEntry.DataConfig:TryGetNum("NPC_city_range", "k1", 20)
  if king_city_range ~= nil then
    if king_city_range % 2 ~= 1 then
      king_city_range = king_city_range + 1
    end
    local king_city_config = DataCenter.AllianceCityTemplateManager:GetKingCityData()
    local roundSize = (king_city_range - 1) / 2
    local minX = WorldTileCount
    local minY = WorldTileCount
    local maxX = 0
    local maxY = 0
    local baseX = king_city_config.pos.x
    local baseY = king_city_config.pos.y
    for i = -roundSize, roundSize do
      for j = -roundSize, roundSize do
        if i ~= 0 or j ~= 0 then
          minX = math.min(baseX + i, minX)
          minY = math.min(baseY + j, minY)
          maxX = math.max(baseX + i, maxX)
          maxY = math.max(baseY + j, maxY)
        end
      end
    end
    self.kingCityOccupyRange = {
      minX = minX,
      maxX = maxX,
      minY = minY,
      maxY = maxY
    }
  end
end

function BirthPointTemplateManager:IsInKingCityOccupiedRange(x, y)
  local pt = self.kingCityOccupyRange
  return pt ~= nil and x >= pt.minX and x <= pt.maxX and y <= pt.maxY and y >= pt.minY
end

function BirthPointTemplateManager:GetKinCityOccupyRange()
  if not self.kingCityOccupyRange then
    return {}
  end
  return {
    minX = self.kingCityOccupyRange.minX,
    maxX = self.kingCityOccupyRange.maxX,
    minY = self.kingCityOccupyRange.minY,
    maxY = self.kingCityOccupyRange.maxY
  }
end

local function GetBlackLandRange(self, serverId)
  local data = self:GetBlackLandSeasonPos(serverId) or self.blackLandPos
  return data[1], data[2], data[3], data[4]
end

local function GetBlackLandIntersectionWithSegment(self, pointA, pointB, serverA, serverB)
  local data = self:GetBlackLandSeasonPos(serverA) or self.blackLandPos
  local segMinX = math.min(pointA.x, pointB.x)
  local segMaxX = math.max(pointA.x, pointB.x)
  local segMinY = math.min(pointA.y, pointB.y)
  local segMaxY = math.max(pointA.y, pointB.y)
  if not self.blackLandMinX then
    self.blackLandMinX = math.min(data[1].x, data[2].x)
    self.blackLandMaxX = math.max(data[1].x, data[2].x)
    self.blackLandMinY = math.min(data[1].y, data[3].y)
    self.blackLandMaxY = math.max(data[1].y, data[3].y)
  end
  local overMinX = math.max(segMinX, self.blackLandMinX)
  local overMaxX = math.min(segMaxX, self.blackLandMaxX)
  local overMinY = math.max(segMinY, self.blackLandMinY)
  local overMaxY = math.min(segMaxY, self.blackLandMaxY)
  if overMinX > overMaxX or overMinY > overMaxY then
    return 0
  end
  if pointA.x == pointB.x then
    return overMaxY - overMinY
  elseif pointA.y == pointB.y then
    return overMaxX - overMinX
  end
  local a = (pointB.y - pointA.y) / (pointB.x - pointA.x)
  local b = pointA.y - a * pointA.x
  local y1 = a * overMinX + b
  local y2 = a * overMaxX + b
  local newMinY = math.min(y1, y2)
  local newMaxY = math.max(y1, y2)
  local realMinY = math.max(overMinY, newMinY)
  local realMaxY = math.min(overMaxY, newMaxY)
  local yProject = realMaxY - realMinY
  if yProject <= 0 then
    return 0
  end
  local ret = yProject * math.sqrt(1 + 1 / (a * a))
  return ret
end

local function GetBlackLandMaxSpeed(self)
  if self.blackDesertDecMaxSpeed == nil then
    self.blackDesertDecMaxSpeed = LuaEntry.DataConfig:TryGetNum("wonder_rocky_ground", "k3", 0.3)
  end
  return self.blackDesertDecMaxSpeed
end

local function GetBlackLandSpeedByServerId(self, serverId)
  local addRatio = 1 + LuaEntry.Effect:GetGameEffect(EffectDefine.LW_BLACK_MARCH_SPEED_ADD_94055)
  if self.blackLandDecSpeedArr == nil or serverId == nil then
    return 0.3 * addRatio
  end
  if DataCenter.ActivityListDataManager:CheckIfActivityOpen(EnumActivity.ActLandlord.Type) and DataCenter.LandlordMgr:IsInBattle() and DataCenter.LandlordMgr:IsInNewCenterMapPeriod() and serverId == DataCenter.LandlordMgr:GetCenterServerId() then
    local landlordRatio = LuaEntry.DataConfig:TryGetNum("zonewar_landlord", "k12", 1)
    return landlordRatio * addRatio
  end
  local s = toInt(serverId)
  for _, v in ipairs(self.blackLandDecSpeedArr) do
    if v.min and v.max and v.speed and s >= v.min and s <= v.max then
      return v.speed * addRatio
    end
  end
  return addRatio
end

local function GetBlackLandRealSpeed(self, whiteSpeed)
  local BlackLandSpeed = self:GetBlackLandSpeedByServerId(LuaEntry.Player:GetCurServerId())
  local BlackLandMaxSpeed = self:GetBlackLandMaxSpeed()
  return math.min(BlackLandMaxSpeed, whiteSpeed * BlackLandSpeed)
end

local function IsBirthPointInMap(self, x, y, radius)
  local minX = x - radius
  local maxX = x + radius
  local minY = y - radius
  local maxY = y + radius
  return 0 <= minX and maxX < WorldTileCount and 0 <= minY and maxY < WorldTileCount
end

local function IsBirthPoint(self, x, y)
  if self.bornNew then
    local realX = x - self.startX
    local realY = y - self.startY
    if 0 <= realX and realX % self.spaceX == 0 and 0 <= realY and realY % self.spaceY == 0 and self:IsBirthPointInMap(x, y, self.genRadius) then
      return true
    end
    return false
  end
  local xBlock = x % BlockSize
  local yBlock = y % BlockSize
  local realX = xBlock - self.startX
  local realY = yBlock - self.startY
  if 0 <= realX and realX % self.spaceX == 0 and 0 <= realY and realY % self.spaceY == 0 and self:IsBirthPointInMap(x, y, self.genRadius) then
    return true
  end
  return false
end

local function IsInAllianceCityField(self, pointIndex, _serverId)
  if pointIndex then
    if self.allianceCityFootprint ~= nil and self.allianceCityFootprint[pointIndex] ~= nil then
      return true
    end
    if self.allianceCityField ~= nil and self.allianceCityField[pointIndex] ~= nil then
      return true
    end
    local serverId = _serverId or LuaEntry.Player:GetCurServerId()
    local cityId = SceneUtils.GetZoneIdByPosId(pointIndex, serverId)
    if cityId == 0 then
      return false
    end
    local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, serverId)
    if meta ~= nil then
      local tilePos = SceneUtils.IndexToTilePos(pointIndex, ForceChangeScene.World)
      local pos = meta.pos
      local city_field_LRTB = meta.city_field_LRTB
      if city_field_LRTB ~= nil then
        local top = city_field_LRTB[1]
        local bottom = city_field_LRTB[2]
        local left = city_field_LRTB[3]
        local right = city_field_LRTB[4]
        if tilePos.x + left >= pos.x and tilePos.x - right <= pos.x and tilePos.y + bottom >= pos.y and tilePos.y - top <= pos.y then
          if self.allianceCityField == nil then
            self.allianceCityField = {}
          end
          self.allianceCityField[pointIndex] = cityId
          return true
        end
      else
        local city_field = toInt(meta.city_field)
        if city_field > math.abs(tilePos.x - pos.x) and city_field > math.abs(tilePos.y - pos.y) then
          if self.allianceCityField == nil then
            self.allianceCityField = {}
          end
          self.allianceCityField[pointIndex] = cityId
          return true
        end
      end
    end
  end
  return false
end

local function IsInAllianceCityRange(self, pointIndex)
  if pointIndex then
    if self.allianceCityFootprint ~= nil and self.allianceCityFootprint[pointIndex] ~= nil then
      return true
    end
    local serverId = LuaEntry.Player:GetCurServerId()
    local cityId = SceneUtils.GetZoneIdByPosId(pointIndex, serverId)
    if cityId == nil or cityId == 0 then
      return false
    end
    local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, serverId)
    if meta ~= nil then
      local tilePos = SceneUtils.IndexToTilePos(pointIndex, ForceChangeScene.World)
      local isInSeason = self.curWorldCityTableName ~= "lw_worldcity"
      local pos = meta.pos
      local size = meta.size
      if isInSeason then
        size = meta.season_tile_size
      end
      local halfSize = math.floor(toInt(size) / 2)
      if halfSize >= math.abs(tilePos.x - pos.x) and halfSize >= math.abs(tilePos.y - pos.y) then
        if self.allianceCityFootprint == nil then
          self.allianceCityFootprint = {}
        end
        self.allianceCityFootprint[pointIndex] = cityId
        return true
      end
    end
  end
  return false
end

local function GetBirthPointsTemplateByRange(self, minX, maxX, minY, maxY)
  local result = {}
  if self.bornNew then
    local temp, durMinX, durMinY, durMaxX, durMaxY, realMinX, realMinY, realMaxX, realMaxY
    durMinX, temp = math.modf((minX - self.startX) / self.spaceX)
    durMinY, temp = math.modf((minY - self.startY) / self.spaceY)
    durMaxX, temp = math.modf((maxX - self.startX) / self.spaceX)
    durMaxY, temp = math.modf((maxY - self.startY) / self.spaceY)
    realMinX = self.startX + durMinX * self.spaceX
    realMinY = self.startY + durMinY * self.spaceY
    realMaxX = self.startX + durMaxX * self.spaceX
    realMaxY = self.startY + durMaxY * self.spaceY
    realMinX = minX <= realMinX and realMinX or realMinX + self.spaceX
    realMinY = minY <= realMinY and realMinY or realMinY + self.spaceY
    realMaxX = maxX >= realMaxX and realMaxX or realMaxX - self.spaceX
    realMaxY = maxY >= realMaxY and realMaxY or realMaxY - self.spaceY
    if realMinX <= realMaxX and realMinY <= realMaxY then
      for i = realMinX, realMaxX, self.spaceX do
        for j = realMinY, realMaxY, self.spaceY do
          if self:IsBirthPoint(i, j) then
            table.insert(result, {x = i, y = j})
          end
        end
      end
    end
  elseif minX <= maxX and minY <= maxY then
    for i = minX, maxX do
      for j = minY, maxY do
        if self:IsBirthPoint(i, j) then
          table.insert(result, {x = i, y = j})
        end
      end
    end
  end
  return result
end

local function GetPointInMyBaseRange(self, x, y)
  return self:GetBirthPointsTemplateByRange(x - self.spaceX, x + self.spaceX, y - self.spaceY, y + self.spaceY)
end

local function GetAllPointsByOffset(self, x, y, offsetX, offsetY)
  if self:IsBirthPoint(x, y) then
    local result = {}
    local curX = x
    local curY = y
    for i = -offsetX, offsetX do
      curX = x + i * self.spaceX
      for j = -offsetY, offsetY do
        curY = y + j * self.spaceY
        table.insert(result, {x = curX, y = curY})
      end
    end
    return result
  end
end

local function GetPointByFakePlayer(self)
  local moveDistanceX = 10
  local moveTrueDistanceX = 6
  local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
  if mainBuild ~= nil then
    local vec2 = SceneUtils.IndexToTilePos(mainBuild.pointId)
    local x = vec2.x
    local y = vec2.y
    local isRight = self:IsBirthPoint(x + self.spaceX * moveDistanceX, y)
    local isTop = self:IsBirthPoint(x, y + self.spaceY * moveDistanceX)
    local isDown = self:IsBirthPoint(x, y - self.spaceY * moveDistanceX)
    if isRight then
      if isTop and isDown then
        return SceneUtils.TileToWorld({
          x = x + self.spaceX * moveTrueDistanceX,
          y = y
        })
      elseif isTop then
        return SceneUtils.TileToWorld({
          x = x + self.spaceX * moveTrueDistanceX,
          y = y + self.spaceY * moveTrueDistanceX
        })
      else
        return SceneUtils.TileToWorld({
          x = x + self.spaceX * moveTrueDistanceX,
          y = y - self.spaceY * moveTrueDistanceX
        })
      end
    elseif isTop and isDown then
      return SceneUtils.TileToWorld({
        x = x - self.spaceX * moveTrueDistanceX,
        y = y
      })
    elseif isTop then
      return SceneUtils.TileToWorld({
        x = x - self.spaceX * moveTrueDistanceX,
        y = y + self.spaceY * moveTrueDistanceX
      })
    else
      return SceneUtils.TileToWorld({
        x = x - self.spaceX * moveTrueDistanceX,
        y = y - self.spaceY * moveTrueDistanceX
      })
    end
  end
end

local function ParseRockyGround(self, str)
  if str ~= nil and str ~= "" then
    local result, index = {}, 1
    for item in string.gmatch(str, "([^|]+)|?") do
      local _x, _y = string.match(item, "(%d+)[,;](%d+)")
      if _x ~= nil and _y ~= nil then
        result[index] = {
          x = toInt(_x),
          y = toInt(_y)
        }
        index = index + 1
      end
    end
    return result
  end
end

local function GetBlackLandSeasonPos(self, _serverId)
  local serverId = _serverId or LuaEntry.Player:GetCurServerId()
  local info = SeasonUtil.GetSeasonInfo(serverId)
  if info == nil or info.seasonId == nil then
    return self.blackLandPos
  end
  local seasonId = info.seasonId
  local mapIndex = info:GetNinePalacesIndex(serverId)
  if self.blackLandPosSeasonDic ~= nil and self.blackLandPosSeasonDic[seasonId] ~= nil then
    return self.blackLandPosSeasonDic[seasonId][mapIndex] or self.blackLandPosSeasonDic[seasonId][1] or self.blackLandPos
  end
  local cfg = info.currentSeasonConfig or info.seasonConfig
  if cfg == nil then
    return self.blackLandPos
  end
  local season_rocky_ground = cfg.season_rocky_ground
  if self.blackLandPosSeasonDic == nil then
    self.blackLandPosSeasonDic = {}
  end
  if string.IsNullOrEmpty(season_rocky_ground) then
    self.blackLandPosSeasonDic[seasonId] = {
      self.blackLandPos
    }
    return self.blackLandPos
  end
  local ground_list = string.split_ss_array(season_rocky_ground, "#")
  local ground_list_count = #ground_list
  if ground_list_count == 1 then
    mapIndex = 1
    self.blackLandPosSeasonDic[seasonId] = {
      self:ParseRockyGround(ground_list[1])
    }
  elseif 1 < ground_list_count then
    self.blackLandPosSeasonDic[seasonId] = {}
    for index, rocky_ground in ipairs(ground_list) do
      self.blackLandPosSeasonDic[seasonId][index] = self:ParseRockyGround(rocky_ground)
    end
  end
  return self.blackLandPosSeasonDic[seasonId][mapIndex] or self.blackLandPosSeasonDic[seasonId][1] or self.blackLandPos
end

BirthPointTemplateManager.__init = __init
BirthPointTemplateManager.__delete = __delete
BirthPointTemplateManager.InitAllBirthPoint = InitAllBirthPoint
BirthPointTemplateManager.IsBirthPoint = IsBirthPoint
BirthPointTemplateManager.GetBirthPointsTemplateByRange = GetBirthPointsTemplateByRange
BirthPointTemplateManager.IsInAllianceCityRange = IsInAllianceCityRange
BirthPointTemplateManager.IsInAllianceCityField = IsInAllianceCityField
BirthPointTemplateManager.GetPointInMyBaseRange = GetPointInMyBaseRange
BirthPointTemplateManager.IsBirthPointInMap = IsBirthPointInMap
BirthPointTemplateManager.InitBornPointList = InitBornPointList
BirthPointTemplateManager.GetAllPointsByOffset = GetAllPointsByOffset
BirthPointTemplateManager.GetPointByFakePlayer = GetPointByFakePlayer
BirthPointTemplateManager.GetBlackLandRange = GetBlackLandRange
BirthPointTemplateManager.GetBlackLandIntersectionWithSegment = GetBlackLandIntersectionWithSegment
BirthPointTemplateManager.GetBlackLandSpeedByServerId = GetBlackLandSpeedByServerId
BirthPointTemplateManager.GetBlackLandMaxSpeed = GetBlackLandMaxSpeed
BirthPointTemplateManager.GetBlackLandRealSpeed = GetBlackLandRealSpeed
BirthPointTemplateManager.ParseRockyGround = ParseRockyGround
BirthPointTemplateManager.GetBlackLandSeasonPos = GetBlackLandSeasonPos
return BirthPointTemplateManager
