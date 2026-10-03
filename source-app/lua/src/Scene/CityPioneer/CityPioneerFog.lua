local CityPioneerFog = BaseClass("CityPioneerFog", Singleton)
local FogTileCount = 100
local FogTileSize = 2
local FogData = CS.GameEntry.Data.Fog
local SceneManager = CS.SceneManager

function CityPioneerFog:__init()
  self.loadComplete = false
  self.cityFogCanVisible = false
  self.unlockFogIds = {}
  
  function self.onFogLoadComplete()
    self:OnFogLoadComplete()
  end
end

function CityPioneerFog:GetFogIdsByPoineerId(pId)
  local UnlockFog = GetTableData(TableName.APS_SINGLEMAP_PIONEER, pId, "UnlockFog")
  local _tab = string.split(UnlockFog, ";")
  return _tab
end

function CityPioneerFog:__delete()
  self:RemoveAll()
end

function CityPioneerFog:RemoveAll()
  self.unlockFogIds = {}
end

function CityPioneerFog:InitFog()
  self.unlockFogIds = {}
  if CS.SceneManager.World ~= nil and CS.SceneManager.World.RegisterFogCompleteAction ~= nil then
    self.loadComplete = false
    CS.SceneManager.World:RegisterFogCompleteAction(self.onFogLoadComplete)
  else
    self.loadComplete = true
    self:OnFogLoadComplete()
  end
end

function CityPioneerFog:FogIdToWorldPos(fogId)
  local fogY = (fogId - 1) // FogTileCount
  local fogX = (fogId - 1) % FogTileCount
  return Vector3.New((fogX + 0.5) * FogTileSize, 0, (fogY + 0.5) * FogTileSize)
end

function CityPioneerFog:UnlockAreaFog(poineerId, inLoading)
  local fogIds = GetTableData(TableName.APS_SINGLEMAP_PIONEER, poineerId, "UnclockFog")
  if string.IsNullOrEmpty(fogIds) then
    return
  end
  local tabFogIds = string.split_ii_array(fogIds, ";")
  inLoading = inLoading or false
  for i, fogId in ipairs(tabFogIds) do
    if self.unlockFogIds[fogId] == nil then
      self:UnlockOneFogEx(fogId)
    end
  end
end

function CityPioneerFog:UnlockOneFogEx(fogId)
  self.unlockFogIds[fogId] = true
  FogData:UnlockFog(fogId)
  if self.loadComplete then
    SceneManager.World:UnlockFogOfWar(fogId)
  end
end

function CityPioneerFog:CheckWalkPos(pos, forward, speed, canChange)
  if self:IsUnlock(pos) then
    local newLeftForward
    if forward.x < 0 then
      newLeftForward = DirectionLeft
    else
      newLeftForward = DirectionRight
    end
    local leftUnlock = self:IsUnlock(pos + newLeftForward * speed)
    local newTopForward
    if 0 > forward.z then
      newTopForward = DirectionDown
    else
      newTopForward = DirectionTop
    end
    local topUnlock = self:IsUnlock(pos + newTopForward * speed)
    if leftUnlock then
      if topUnlock then
        return canChange, forward
      elseif canChange then
        return false, newLeftForward
      else
        return false, nil
      end
    elseif topUnlock and canChange then
      return false, newTopForward
    else
      return false, nil
    end
  else
    return canChange, forward
  end
  return false, nil
end

function CityPioneerFog:CityFogCanVisible()
  return self.cityFogCanVisible
end

function CityPioneerFog:SetCityFogCanVisible(visible)
  self.cityFogCanVisible = visible
  self:SetFogVisible(visible)
end

function CityPioneerFog:SetFogVisible(visible)
  if self:CityFogCanVisible() then
    CS.SceneManager.World:SetFogVisible(visible)
  end
end

function CityPioneerFog:OnFogLoadComplete()
  self.loadComplete = true
  for k, v in pairs(self.unlockFogIds) do
    self:UnlockOneFogEx(k)
  end
  if CS.SceneManager.World ~= nil then
    if self:CityFogCanVisible() then
      CS.SceneManager.World:SetFogVisible(true)
    else
      CS.SceneManager.World:SetFogVisible(false)
    end
  end
end

function CityPioneerFog:IsUnlock(worldPos)
  local fogId = self:GetFogIndexByPos(worldPos)
  return self.unlockFogIds[fogId] == true
end

function CityPioneerFog:GetFogIndexByPos(worldPos)
  local x, _ = math.floor(worldPos.x / FogTileSize)
  local y, _ = math.floor(worldPos.z / FogTileSize)
  return x + y * FogTileCount + 1
end

return CityPioneerFog
