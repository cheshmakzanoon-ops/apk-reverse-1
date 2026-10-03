local Utils = {}
local config = require("DataCenter.LWGateDefenceManager.LWGateDefenceConfig")
local precalc = require("DataCenter.LWGateDefenceManager.LWGateDefencePrecalc")
config.areaOrig = Vector2.New(config.areaOrig_RAW.x, config.areaOrig_RAW.y)
config.fireCover = Vector2.New(config.fireCover_RAW.x, config.fireCover_RAW.y)
config.spawnRange = Vector2.New(config.spawnRange_RAW.x, config.spawnRange_RAW.y)
local runTimeAstarGrid = {}
local GRID_KEY_ROW_MUL_FACTOR = 1000
local AUTO_INC_ZOMBIE_ID = 0

function Utils.GetNewZombieId()
  AUTO_INC_ZOMBIE_ID = AUTO_INC_ZOMBIE_ID + 1
  return AUTO_INC_ZOMBIE_ID
end

local function _GetGrid(row, col)
  if row < 0 or row >= config.areaRows then
    return nil
  end
  if col < 0 or col >= config.areaCols then
    return nil
  end
  local gridKey = row * GRID_KEY_ROW_MUL_FACTOR + col
  if runTimeAstarGrid[gridKey] then
    return runTimeAstarGrid[gridKey]
  end
  local girdRuntimeData = {}
  girdRuntimeData.row = row
  girdRuntimeData.col = col
  runTimeAstarGrid[gridKey] = girdRuntimeData
  if config.AStarGrids[gridKey] then
    girdRuntimeData.isBlock = config.AStarGrids[gridKey] == 1
  else
    girdRuntimeData.isBlock = false
  end
  return girdRuntimeData
end

function Utils.WorldX_2_Col(worldX)
  return math.floor((worldX - config.areaOrig.x) / config.gridSize)
end

function Utils.WorldZ_2_Row(worldZ)
  return math.floor((worldZ - config.areaOrig.y) / config.gridSize)
end

function Utils.World_2_Grid(worldPos)
  if not worldPos then
    return nil
  end
  return _GetGrid(Utils.WorldZ_2_Row(worldPos.z), Utils.WorldX_2_Col(worldPos.x))
end

function Utils.World_2_Grid_XZ(worldX, worldZ)
  if not worldX or not worldZ then
    return nil
  end
  return _GetGrid(Utils.WorldZ_2_Row(worldZ), Utils.WorldX_2_Col(worldX))
end

function Utils.Col_2_WorldX(col)
  return config.areaOrig.x + col * config.gridSize + config.gridSize * 0.5
end

function Utils.Row_2_WorldZ(row)
  return config.areaOrig.y + row * config.gridSize + config.gridSize * 0.5
end

function Utils.Grid_2_World(row, col)
  return Vector3(Utils.Col_2_WorldX(col), 0, Utils.Row_2_WorldZ(row))
end

function Utils.Grid_2_World_XZ(row, col)
  return Utils.Col_2_WorldX(col), Utils.Row_2_WorldZ(row)
end

function Utils.Grid(row, col)
  return _GetGrid(row, col)
end

function Utils.UpdateDestGrids(herosMap)
  for gridKey, gridValue in pairs(config.destGrids) do
    config.destGrids[gridKey] = 0
  end
  for _, heroInst in pairs(herosMap) do
    if heroInst.transform and heroInst.standAlready then
      local fireCoveredColMin = Utils.WorldX_2_Col(heroInst.position.x - config.fireCover.x * 0.5)
      local fireCoveredColMax = Utils.WorldX_2_Col(heroInst.position.x + config.fireCover.x * 0.5)
      for gridKey, gridValue in pairs(config.destGrids) do
        local row = gridKey // GRID_KEY_ROW_MUL_FACTOR
        local col = gridKey - row * GRID_KEY_ROW_MUL_FACTOR
        if gridValue == 0 and fireCoveredColMin <= col and fireCoveredColMax >= col then
          config.destGrids[gridKey] = 1
        end
      end
    end
  end
end

function Utils.GetSpawnGrid(heroInst)
  local spawnRowMin = config.spawnRange.x
  local spawnRowMax = config.spawnRange.y
  local spawnColMin = math.max(0, Utils.WorldX_2_Col(heroInst.position.x - config.fireCover.x * 0.5))
  local spawnColMax = math.min(config.areaCols - 1, Utils.WorldX_2_Col(heroInst.position.x + config.fireCover.x * 0.5))
  local tryTimes = 0
  repeat
    local row = math.random(spawnRowMin, spawnRowMax)
    local col = math.random(spawnColMin, spawnColMax)
    local grid = _GetGrid(row, col)
    if grid and not grid.isBlock then
      return grid
    end
    tryTimes = tryTimes + 1
  until 10 <= tryTimes
  return nil
end

local runTimeSpawnGrids = {}

function Utils.GetSpecialEventSpawnGrid()
  local gridKey = config.spawnGrids[math.random(#config.spawnGrids)]
  local runTimeSpawnGrid = runTimeSpawnGrids[gridKey]
  if not runTimeSpawnGrid then
    runTimeSpawnGrid = {}
    local row = gridKey // GRID_KEY_ROW_MUL_FACTOR
    local col = gridKey - row * GRID_KEY_ROW_MUL_FACTOR
    runTimeSpawnGrid.row = row
    runTimeSpawnGrid.col = col
  end
  return runTimeSpawnGrid
end

local runTimeDesGrids = {}

function Utils.GetNearestDestGrid(currGrid, ignoreHero)
  if not currGrid then
    return nil
  end
  local precalcResult = precalc[currGrid.row * GRID_KEY_ROW_MUL_FACTOR + currGrid.col]
  if precalcResult then
    local nearstDestGridKey = precalcResult[#precalcResult]
    local nearstGridRow = nearstDestGridKey // GRID_KEY_ROW_MUL_FACTOR
    local nearstGridCol = nearstDestGridKey - nearstGridRow * GRID_KEY_ROW_MUL_FACTOR
    local nearestDestGrid = _GetGrid(nearstGridRow, nearstGridCol)
    for gridKey, gridValue in pairs(config.destGrids) do
      local row = gridKey // GRID_KEY_ROW_MUL_FACTOR
      local col = gridKey - row * GRID_KEY_ROW_MUL_FACTOR
      local active = gridValue == 1
      if nearestDestGrid.row == row and nearestDestGrid.col == col then
        local runTimeDestGrid = runTimeDesGrids[gridKey]
        if (active or ignoreHero) and not runTimeDestGrid then
          runTimeDestGrid = {}
          runTimeDesGrids[gridKey] = runTimeDestGrid
          runTimeDestGrid.row = row
          runTimeDestGrid.col = col
          runTimeDestGrid.active = active
        end
        return (active or ignoreHero) and runTimeDestGrid or nil
      end
    end
  else
    local minDist = 99999999
    local nearestDestGrid
    for gridKey, gridValue in pairs(config.destGrids) do
      if gridValue == 1 or ignoreHero then
        local row = gridKey // GRID_KEY_ROW_MUL_FACTOR
        local col = gridKey - row * GRID_KEY_ROW_MUL_FACTOR
        local dist = math.abs(row - currGrid.row) + math.abs(col - currGrid.col)
        if minDist > dist then
          minDist = dist
          local runTimeDestGrid = runTimeDesGrids[gridKey]
          if not runTimeDestGrid then
            runTimeDestGrid = {}
            runTimeDesGrids[gridKey] = runTimeDestGrid
            runTimeDestGrid.row = row
            runTimeDestGrid.col = col
            runTimeDestGrid.active = true
          end
          nearestDestGrid = runTimeDestGrid
        end
      end
    end
    return nearestDestGrid
  end
end

function Utils.GetHeroFireCoverArea(heroInst)
  return {
    heroInst.position.x - config.fireCover.x * 0.5,
    heroInst.position.x + config.fireCover.x * 0.5,
    heroInst.position.z - config.fireCover.y,
    heroInst.position.z
  }
end

function Utils.GetHeroFireEffectContext(heroInst)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroInst.heroUuid)
  local skillId = LocalController:instance():getValue("lw_hero", heroData.heroId, "skills")[1]
  local skillTemplate = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
  local skillEffId = 0
  if skillTemplate then
    skillEffId = skillTemplate.skill_effect
  end
  local appearenceId = LocalController:instance():getValue("lw_hero", heroData.heroId, "appearance")
  local fireVfxPath = LocalController:instance():getValue("lw_hero_skill_effect", skillEffId, "fire_effect")
  local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(appearenceId)
  local muzzlePath = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "fire_path")
  local muzzle_1Path = muzzlePath[1] or ""
  local bulletType = tonumber(LocalController:instance():getValue("lw_hero", heroData.heroId, "idle_attack"))
  local fireDelay = tonumber(LocalController:instance():getValue("lw_hero_skill_effect", skillEffId, "fire_delay")) * 0.001
  bulletType = bulletType or math.random() > 0.5 and 1 or 2
  return {
    bullet = bulletType,
    vfxPath = fireVfxPath,
    muzzle = heroInst.transform:Find(muzzle_1Path),
    delay = fireDelay
  }
end

local AStarAdjacentOffsets = {
  {1, 0},
  {0, 1},
  {0, -1},
  {1, -1},
  {1, 1},
  {-1, 0},
  {-1, -1},
  {-1, 1}
}

function Utils.GetAdjacentNodes(srcNode, offsets)
  local adjacentNodes = {}
  local row = srcNode.row
  local col = srcNode.col
  for _, offset in ipairs(offsets) do
    local adjRow = row + offset[1]
    local adjCol = col + offset[2]
    if 0 <= adjRow and adjRow < config.areaRows and 0 <= adjCol and adjCol < config.areaCols then
      local adjNode = _GetGrid(adjRow, adjCol)
      if adjNode and not adjNode.isBlock then
        table.insert(adjacentNodes, adjNode)
      end
    end
  end
  return adjacentNodes
end

local function _PopNodeWithLowestF(nodes, fMap)
  local lowestF, lowestIdx = 99999999
  for i, node in ipairs(nodes) do
    local f = fMap[node]
    if lowestF > f then
      lowestF, lowestIdx = f, i
    end
  end
  return table.remove(nodes, lowestIdx)
end

local function _ContainsNode(nodes, node)
  for _, n in ipairs(nodes) do
    if n.row == node.row and n.col == node.col then
      return true
    end
  end
  return false
end

local function _GetPath(grid, prevMap)
  local path = {}
  local node = grid
  while node do
    local nodeGridKey = node.row * GRID_KEY_ROW_MUL_FACTOR + node.col
    table.insert(path, 1, nodeGridKey)
    node = prevMap[node]
  end
  return path
end

local _FindPathCache = {}

function Utils.FindPath(startGrid, destGrid, canUsePathFind)
  local startNode = _GetGrid(startGrid.row, startGrid.col)
  local destNode = _GetGrid(destGrid.row, destGrid.col)
  if not (startNode and destNode) or startNode.isBlock or destNode.isBlock then
    return nil
  end
  local cacheKey1 = startNode.row * GRID_KEY_ROW_MUL_FACTOR + startNode.col
  local cacheKey2 = destNode.row * GRID_KEY_ROW_MUL_FACTOR + destNode.col
  if precalc[cacheKey1] then
    local result = precalc[cacheKey1]
    local pathDesGridKey = result[#result]
    local pathDesGridRow = pathDesGridKey // GRID_KEY_ROW_MUL_FACTOR
    local pathDesGridCol = pathDesGridKey - pathDesGridRow * GRID_KEY_ROW_MUL_FACTOR
    if pathDesGridCol == destGrid.col and pathDesGridRow == destGrid.row then
      if result[1] and result[1] ~= cacheKey1 then
        table.insert(result, 1, cacheKey1)
      end
      return result, true
    end
  end
  if _FindPathCache[cacheKey1] and _FindPathCache[cacheKey1][cacheKey2] then
    return _FindPathCache[cacheKey1][cacheKey2]
  end
  if not _FindPathCache[cacheKey1] then
    _FindPathCache[cacheKey1] = {}
  end
  if not _FindPathCache[cacheKey1][cacheKey2] then
    _FindPathCache[cacheKey1][cacheKey2] = {cacheKey1, cacheKey2}
  end
  return _FindPathCache[cacheKey1][cacheKey2]
end

function Utils.AStar(startNode, destNode)
  local cacheKey1 = startNode.row * GRID_KEY_ROW_MUL_FACTOR + startNode.col
  local cacheKey2 = destNode.row * GRID_KEY_ROW_MUL_FACTOR + destNode.col
  local openNodes = {}
  local closeNodes = {}
  local prevMap = {}
  local gMap = {}
  local hMap = {}
  local fMap = {}
  gMap[startNode] = 0
  hMap[startNode] = math.abs(startNode.row - destNode.row) + math.abs(startNode.col - destNode.col)
  fMap[startNode] = gMap[startNode] + hMap[startNode]
  table.insert(openNodes, startNode)
  local counter = 0
  while 0 < #openNodes do
    counter = counter + 1
    if 200 < counter then
      Logger.LogError("Utils.AStar counter > 200")
      return nil
    end
    local currNode = _PopNodeWithLowestF(openNodes, fMap)
    if currNode.row == destNode.row and currNode.col == destNode.col then
      local path = _GetPath(currNode, prevMap)
      if not _FindPathCache[cacheKey1] then
        _FindPathCache[cacheKey1] = {}
      end
      _FindPathCache[cacheKey1][cacheKey2] = path
      return path
    end
    table.insert(closeNodes, currNode)
    local adjacentNodes = Utils.GetAdjacentNodes(currNode, AStarAdjacentOffsets)
    for _, adjNode in ipairs(adjacentNodes) do
      if not _ContainsNode(closeNodes, adjNode) then
        local g = gMap[currNode] + 1
        if not _ContainsNode(openNodes, adjNode) or g < gMap[adjNode] then
          prevMap[adjNode] = currNode
          gMap[adjNode] = g
          hMap[adjNode] = math.abs(adjNode.row - destNode.row) + math.abs(adjNode.col - destNode.col)
          fMap[adjNode] = gMap[adjNode] + hMap[adjNode]
          if not _ContainsNode(openNodes, adjNode) then
            table.insert(openNodes, adjNode)
          end
        end
      end
    end
  end
  return nil
end

local _SearchDir = {
  up = {0, 1},
  right = {1, 0},
  left = {-1, 0},
  down = {0, -1},
  right_up = {1, 1},
  left_up = {-1, 1},
  right_down = {1, -1},
  left_down = {-1, -1}
}

local function _GetSearchDirs(currGrid, prevGrid)
  if not prevGrid then
    return {
      _SearchDir.up,
      _SearchDir.left,
      _SearchDir.right,
      _SearchDir.left_up,
      _SearchDir.right_up,
      _SearchDir.down,
      _SearchDir.left_down,
      _SearchDir.right_down
    }
  end
  if currGrid.row == prevGrid.row then
    if currGrid.col > prevGrid.col then
      return {
        _SearchDir.right
      }
    else
      return {
        _SearchDir.left
      }
    end
  elseif currGrid.col == prevGrid.col then
    if currGrid.row > prevGrid.row then
      return {
        _SearchDir.up
      }
    else
      return {
        _SearchDir.down
      }
    end
  elseif currGrid.row > prevGrid.row then
    if currGrid.col > prevGrid.col then
      return {
        _SearchDir.right,
        _SearchDir.up,
        _SearchDir.right_up
      }
    else
      return {
        _SearchDir.left,
        _SearchDir.up,
        _SearchDir.left_up
      }
    end
  elseif currGrid.col > prevGrid.col then
    return {
      _SearchDir.right,
      _SearchDir.down,
      _SearchDir.right_down
    }
  else
    return {
      _SearchDir.left,
      _SearchDir.down,
      _SearchDir.left_down
    }
  end
end

local function _GetForcedNeighbor(currGrid, dir)
  local neighbors = {}
  if dir[2] == 0 then
    local grid = _GetGrid(currGrid.row + 1, currGrid.col)
    if grid and grid.isBlock then
      local neighbor = _GetGrid(currGrid.row + 1, currGrid.col + dir[1])
      if neighbor and not neighbor.isBlock then
        table.insert(neighbors, neighbor)
      end
    end
    grid = _GetGrid(currGrid.row - 1, currGrid.col)
    if grid and grid.isBlock then
      local neighbor = _GetGrid(currGrid.row - 1, currGrid.col + dir[1])
      if neighbor and not neighbor.isBlock then
        table.insert(neighbors, neighbor)
      end
    end
  elseif dir[1] == 0 then
    local grid = _GetGrid(currGrid.row, currGrid.col + 1)
    if grid and grid.isBlock then
      local neighbor = _GetGrid(currGrid.row + dir[2], currGrid.col + 1)
      if neighbor and not neighbor.isBlock then
        table.insert(neighbors, neighbor)
      end
    end
    grid = _GetGrid(currGrid.row, currGrid.col - 1)
    if grid and grid.isBlock then
      local neighbor = _GetGrid(currGrid.row + dir[2], currGrid.col - 1)
      if neighbor and not neighbor.isBlock then
        table.insert(neighbors, neighbor)
      end
    end
  end
  return neighbors
end

local function _SearchStraightly(currGrid, dir, destGrid)
  local grid = currGrid
  local dist = 0
  while not grid.isBlock do
    local nextGrid = _GetGrid(grid.row + dir[2], grid.col + dir[1])
    dist = dist + 1
    if not nextGrid or nextGrid.isBlock then
      break
    end
    if nextGrid.row == destGrid.row and nextGrid.col == destGrid.col then
      return nextGrid, nil, dist
    end
    local neighbors = _GetForcedNeighbor(nextGrid, dir)
    if 0 < #neighbors then
      return nextGrid, neighbors, dist
    end
    grid = nextGrid
  end
end

function Utils.JPS(startNode, destNode)
  local cacheKey1 = startNode.row * GRID_KEY_ROW_MUL_FACTOR + startNode.col
  local cacheKey2 = destNode.row * GRID_KEY_ROW_MUL_FACTOR + destNode.col
  local openNodes = {}
  local closeNodes = {}
  local prevMap = {}
  local neighborsMap = {}
  local gMap = {}
  local hMap = {}
  local fMap = {}
  
  local function AddOpenNode(node, prevNode, dist)
    table.insert(openNodes, node)
    prevMap[node] = prevNode
    gMap[node] = gMap[prevNode] + dist
    hMap[node] = math.abs(node.row - destNode.row) + math.abs(node.col - destNode.col)
    fMap[node] = gMap[node] + hMap[node]
  end
  
  gMap[startNode] = 0
  hMap[startNode] = math.abs(startNode.row - destNode.row) + math.abs(startNode.col - destNode.col)
  fMap[startNode] = gMap[startNode] + hMap[startNode]
  table.insert(openNodes, startNode)
  while 0 < #openNodes do
    local currNode = _PopNodeWithLowestF(openNodes, fMap)
    if currNode.row == destNode.row and currNode.col == destNode.col then
      local path = _GetPath(currNode, prevMap)
      if not _FindPathCache[cacheKey1] then
        _FindPathCache[cacheKey1] = {}
      end
      _FindPathCache[cacheKey1][cacheKey2] = path
      return path
    end
    local neighbors = neighborsMap[currNode]
    if neighbors then
      for _, neighbor in ipairs(neighbors) do
        AddOpenNode(neighbor, currNode, 1)
      end
    end
    local prevNode = prevMap[currNode]
    local searchDirs = _GetSearchDirs(currNode, prevNode)
    while 0 < #searchDirs do
      local dir = table.remove(searchDirs, 1)
      local diagonally = dir[1] ~= 0 and dir[2] ~= 0
      if not diagonally then
        local jumpGrid, neighbors, dist = _SearchStraightly(currNode, dir, destNode)
        if jumpGrid then
          neighborsMap[jumpGrid] = neighbors
          AddOpenNode(jumpGrid, currNode, dist)
        end
      else
        local dist = 0
        local grid = currNode
        while not grid.isBlock do
          local nextGrid = _GetGrid(grid.row + dir[2], grid.col + dir[1])
          dist = dist + 1
          if not nextGrid or nextGrid.isBlock then
            break
          end
          if nextGrid.row == destNode.row and nextGrid.col == destNode.col then
            AddOpenNode(nextGrid, currNode, dist)
            break
          end
          local jumpGrid = _SearchStraightly(nextGrid, {
            0,
            dir[2]
          }, destNode)
          if jumpGrid then
            AddOpenNode(nextGrid, currNode, dist)
          end
          jumpGrid = _SearchStraightly(nextGrid, {
            dir[1],
            0
          }, destNode)
          if jumpGrid then
            AddOpenNode(nextGrid, currNode, dist)
          end
          grid = nextGrid
        end
      end
    end
    table.insert(closeNodes, currNode)
  end
  return nil
end

local _sceneColliders = {}

function Utils.CreateSceneColliders()
  Utils.ClearSceneColliders()
  for _, cfg in ipairs(config.colliders) do
    local collider
    if cfg.type == 0 then
      collider = CS.UnityEngine.GameObject("GateDefence_BoxCollider"):AddComponent(typeof(CS.UnityEngine.BoxCollider))
      collider.center = cfg.center
      collider.size = cfg.size
    elseif cfg.type == 1 then
      collider = CS.UnityEngine.GameObject("GateDefence_SphereCollider"):AddComponent(typeof(CS.UnityEngine.SphereCollider))
      collider.center = cfg.center
      collider.radius = cfg.radius
    else
      collider = CS.UnityEngine.GameObject("GateDefence_CapsuleCollider"):AddComponent(typeof(CS.UnityEngine.CapsuleCollider))
      collider.center = cfg.center
      collider.radius = cfg.radius
      collider.height = cfg.height
      collider.direction = cfg.dir
    end
    collider.transform.position = cfg.pos
    collider.transform.eulerAngles = cfg.euler
    collider.transform.localScale = cfg.scale
    table.insert(_sceneColliders, collider)
  end
end

function Utils.ClearSceneColliders()
  for _, collider in ipairs(_sceneColliders) do
    if not IsNull(collider) and not IsNull(collider.gameObject) then
      CS.UnityEngine.GameObject.Destroy(collider.gameObject)
    end
  end
  _sceneColliders = {}
end

local DEFAULT_BLOCK_STATES = {}

function Utils.AddBlockRangeForGameRange(index, tileX, tileY)
  if index == nil then
    return
  end
  if tileX == nil or tileY == nil then
    return
  end
  local tilePos = SceneUtils.IndexToTilePos(index, ForceChangeScene.City)
  local worldPosX, worldPosZ = (tilePos.x + 0.5) * TileSize, (tilePos.y + 0.5) * TileSize
  local gridPos = Utils.World_2_Grid_XZ(worldPosX, worldPosZ)
  if not gridPos then
    return
  end
  local gridSize = config.gridSize
  local gateDefenceGridSizeRatio = TileSize / gridSize
  for i = 1, tileX * gateDefenceGridSizeRatio do
    for y = 1, tileY * gateDefenceGridSizeRatio do
      local row = gridPos.row - i + 1
      local col = gridPos.col - y + 1
      local grid = _GetGrid(row, col)
      if grid then
        if not DEFAULT_BLOCK_STATES[grid.row] then
          DEFAULT_BLOCK_STATES[grid.row] = {}
        end
        DEFAULT_BLOCK_STATES[grid.row][grid.col] = grid.isBlock
        grid.isBlock = true
      end
    end
  end
end

function Utils.RmoveBlockRangeForGameRange(index, tileX, tileY)
  if index == nil then
    return
  end
  if tileX == nil or tileY == nil then
    return
  end
  local tilePos = SceneUtils.IndexToTilePos(index, ForceChangeScene.City)
  local worldPosX, worldPosZ = (tilePos.x + 0.5) * TileSize, (tilePos.y + 0.5) * TileSize
  local gridPos = Utils.World_2_Grid_XZ(worldPosX, worldPosZ)
  if not gridPos then
    return
  end
  local gridSize = config.gridSize
  local gateDefenceGridSizeRatio = TileSize / gridSize
  for i = 1, tileX * gateDefenceGridSizeRatio do
    for y = 1, tileY * gateDefenceGridSizeRatio do
      local row = gridPos.row - i + 1
      local col = gridPos.col - y + 1
      local grid = _GetGrid(row, col)
      if grid and DEFAULT_BLOCK_STATES[grid.row] and DEFAULT_BLOCK_STATES[grid.row][grid.col] ~= nil then
        grid.isBlock = DEFAULT_BLOCK_STATES[grid.row][grid.col]
      end
    end
  end
end

function Utils.ReSetConfigBySeason(LWGateDefenceConfig, LWGateDefencePrecalc)
  config = require("DataCenter.LWGateDefenceManager." .. LWGateDefenceConfig)
  precalc = require("DataCenter.LWGateDefenceManager." .. LWGateDefencePrecalc)
  config.areaOrig = Vector2.New(config.areaOrig_RAW.x, config.areaOrig_RAW.y)
  config.fireCover = Vector2.New(config.fireCover_RAW.x, config.fireCover_RAW.y)
  config.spawnRange = Vector2.New(config.spawnRange_RAW.x, config.spawnRange_RAW.y)
  for row = 0, config.areaRows - 1 do
    for col = 0, config.areaCols - 1 do
      local blockFlag = false
      if DEFAULT_BLOCK_STATES[row] ~= nil and DEFAULT_BLOCK_STATES[row][col] ~= nil then
        blockFlag = true
      end
      if blockFlag then
        local gridData = _GetGrid(row, col)
        if gridData then
          gridData.isBlock = true
        end
      end
    end
  end
end

Utils.GetGridData = _GetGrid
return Utils
