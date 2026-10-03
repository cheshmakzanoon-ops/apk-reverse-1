local BoardData = BaseClass("BoardData")

function BoardData:__init()
  self:reset()
end

function BoardData:__delete()
  self:reset()
end

function BoardData:reset()
  self.uuid = 0
  self.pointId = 0
  self.startTime = 0
  self.endTime = 0
  self.state = 0
  self.inside = 0
  self.x = 0
  self.y = 0
end

function BoardData:UpdateInfo(message)
  if message == nil then
    return
  end
  self.uuid = message.uuid
  if message.pId ~= nil then
    self.pointId = message.pId
  end
  if message.sT ~= nil then
    self.startTime = message.sT
  else
    self.startTime = 0
  end
  if message.eT ~= nil then
    self.endTime = message.eT
  else
    self.endTime = 0
  end
  if message.state ~= nil then
    self.state = message.state
  else
    self.state = 0
  end
  if message.inside ~= nil then
    self.inside = message.inside
  else
    self.inside = 0
  end
  if message.pointId ~= nil then
    self.pointId = message.pointId
  end
  if message.startTime ~= nil then
    self.startTime = message.startTime
  end
  if message.endTime ~= nil then
    self.endTime = message.endTime
  end
  if message.state ~= nil then
    self.state = message.state
  end
  if message.inside ~= nil then
    self.inside = message.inside
  end
  local pos = SceneUtils.IndexToTilePos(self.pointId, ForceChangeScene.City)
  self.x = pos.x
  self.y = pos.y
end

function BoardData:IsMainRoad()
  local pos = DataCenter.BuildManager.main_city_pos
  return self.x == pos.x or self.x == pos.x - 1 or self.y == pos.y or self.y == pos.y - 1
end

function BoardData:IsShowRoad()
  if DataCenter.BuildManager:GetBuildingDataByPointId(self.pointId, false) ~= nil then
    return false
  end
  if not DataCenter.CityDomeManager:IsInDomeByPoint(self.pointId) then
    return false
  end
  return true
end

function BoardData:GetShowRoadModelData()
  if self:IsShowRoad() then
    local result = {}
    if self:IsMainRoad() then
      local pos = DataCenter.BuildManager.main_city_pos
      local shape = ""
      if self.x == pos.x - 1 then
        local left = ""
        local right = ""
        local top = ""
        local down = ""
        if DataCenter.BoardManager:IsHasBoard(SceneUtils.GetIndexByOffset(self.pointId, -1, 0, ForceChangeScene.City)) then
          left = HaveRoad
        else
          left = NoRoad
        end
        if DataCenter.BoardManager:IsHasBoard(SceneUtils.GetIndexByOffset(self.pointId, 2, 0, ForceChangeScene.City)) then
          right = HaveRoad
        else
          right = NoRoad
        end
        down = HaveRoad
        top = HaveRoad
        shape = down .. top .. right .. left
        result.prefabName = string.format(UIAssets.Road_Self_Main_LeftRight, shape)
      elseif self.y == pos.y - 1 then
        local left = ""
        local right = ""
        local top = ""
        local down = ""
        left = HaveRoad
        right = HaveRoad
        if DataCenter.BoardManager:IsHasBoard(SceneUtils.GetIndexByOffset(self.pointId, 0, -1, ForceChangeScene.City)) then
          down = HaveRoad
        else
          down = NoRoad
        end
        if DataCenter.BoardManager:IsHasBoard(SceneUtils.GetIndexByOffset(self.pointId, 0, 2, ForceChangeScene.City)) then
          top = HaveRoad
        else
          top = NoRoad
        end
        shape = down .. top .. right .. left
        result.prefabName = string.format(UIAssets.Road_Self_Main_TopDown, shape)
      end
      local viaductDir = self:GetViaductDirection()
      if viaductDir == RoadDirectType.HORIZONTAL then
        result.lightPrefabName = UIAssets.RoadBridgeLeftRight
      elseif viaductDir == RoadDirectType.PORTRAIT then
        result.lightPrefabName = UIAssets.RoadBridgeTopDown
      elseif shape == "1100" or shape == "0011" then
        local show = false
        local delta = RoadMainDelta
        local range = RoadLightMainRange
        local domeRange = DataCenter.CityDomeManager:GetDomeRadius() / 2 - RoadMainDelta
        if self.x >= pos.x + delta and self.x < pos.x + domeRange then
          if (self.x - pos.x - delta) % range == 0 then
            show = true
          end
        elseif self.x <= pos.x - delta - 1 and self.x > pos.x - domeRange - 1 then
          if (pos.x - delta - 1 - self.x) % range == 0 then
            show = true
          end
        elseif self.y >= pos.y + delta and self.y < pos.y + domeRange then
          if (self.y - pos.y - delta) % range == 0 then
            show = true
          end
        elseif self.y <= pos.y - delta - 1 and self.y > pos.y - domeRange - 1 and (pos.y - delta - 1 - self.y) % range == 0 then
          show = true
        end
        if show then
          result.lightPrefabName = string.format(UIAssets.CityRoadMainLight, shape)
        end
      end
    else
      local left = ""
      local right = ""
      local top = ""
      local down = ""
      if DataCenter.BoardManager:IsHasBoard(SceneUtils.GetIndexByOffset(self.pointId, -1, 0, ForceChangeScene.City)) then
        left = HaveRoad
      else
        left = NoRoad
      end
      if DataCenter.BoardManager:IsHasBoard(SceneUtils.GetIndexByOffset(self.pointId, 1, 0, ForceChangeScene.City)) then
        right = HaveRoad
      else
        right = NoRoad
      end
      if DataCenter.BoardManager:IsHasBoard(SceneUtils.GetIndexByOffset(self.pointId, 0, -1, ForceChangeScene.City)) then
        down = HaveRoad
      else
        down = NoRoad
      end
      if DataCenter.BoardManager:IsHasBoard(SceneUtils.GetIndexByOffset(self.pointId, 0, 1, ForceChangeScene.City)) then
        top = HaveRoad
      else
        top = NoRoad
      end
      local shape = down .. top .. right .. left
      if self.state == RoadState.Updating then
        result.prefabName = string.format(UIAssets.CityRoadUpdating, shape)
      else
        result.prefabName = string.format(UIAssets.CityRoad, shape)
      end
      if shape == "1100" then
        if self.y % 4 == 0 then
          result.lightPrefabName = string.format(UIAssets.CityRoadLight, shape)
        end
      elseif shape == "0011" and self.x % 4 == 0 then
        result.lightPrefabName = string.format(UIAssets.CityRoadLight, shape)
      end
    end
    return result
  end
end

function BoardData:GetRangeRoadPoints()
  if not self:IsMainRoad() then
    local result = {}
    local pos = DataCenter.BuildManager.main_city_pos
    if self.x == pos.x + 1 then
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, -1, 0, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, -2, 0, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, -3, 0, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, -4, 0, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 1, 0, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, 1, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, -1, ForceChangeScene.City))
    elseif self.x == pos.x + 2 then
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, -1, 0, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, -2, 0, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, -3, 0, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, -4, 0, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, -5, 0, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 1, 0, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, 1, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, -1, ForceChangeScene.City))
    elseif self.x == pos.x - 2 then
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 1, 0, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 2, 0, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 3, 0, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 4, 0, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, -1, 0, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, 1, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, -1, ForceChangeScene.City))
    elseif self.x == pos.x - 3 then
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 1, 0, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 2, 0, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 3, 0, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 4, 0, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 5, 0, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, -1, 0, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, 1, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, -1, ForceChangeScene.City))
    elseif self.y == pos.y + 1 then
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, 1, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, -1, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, -2, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, -3, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, -4, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 1, 0, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, -1, 0, ForceChangeScene.City))
    elseif self.y == pos.y + 2 then
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, 1, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, -1, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, -2, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, -3, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, -4, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, -5, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 1, 0, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, -1, 0, ForceChangeScene.City))
    elseif self.y == pos.y - 2 then
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, -1, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, 1, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, 2, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, 3, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, 4, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 1, 0, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, -1, 0, ForceChangeScene.City))
    elseif self.y == pos.y - 3 then
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, -1, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, 1, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, 2, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, 3, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, 4, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, 5, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 1, 0, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, -1, 0, ForceChangeScene.City))
    else
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, 1, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 0, -1, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, 1, 0, ForceChangeScene.City))
      table.insert(result, SceneUtils.GetIndexByOffset(self.pointId, -1, 0, ForceChangeScene.City))
    end
    return result
  end
end

function BoardData:GetRoadPathTypeAndDirectionType()
  local mainRoadDirection = self:GetMainRoadDirection()
  local viaductDirection = self:GetViaductDirection()
  return mainRoadDirection, viaductDirection
end

function BoardData:GetPathRoadData()
  local result = {}
  result.pointId = self.pointId
  result.mainRoadDirection, result.viaductDirection = self:GetRoadPathTypeAndDirectionType()
  return result
end

function BoardData:GetMainRoadDirection()
  local pos = DataCenter.BuildManager.main_city_pos
  if self.x == pos.x then
    return RoadDirectType.NORTH_TO_SOUTH
  elseif self.x == pos.x - 1 then
    return RoadDirectType.SOUTH_TO_NORTH
  elseif self.y == pos.y then
    return RoadDirectType.WEST_TO_EAST
  elseif self.y == pos.y - 1 then
    return RoadDirectType.EAST_TO_WEST
  end
  return RoadDirectType.None
end

function BoardData:GetViaductDirection()
  return RoadDirectType.None
end

return BoardData
