local GAME_WIDTH, GAME_HEIGHT = 14, 18
local GAME_REMOVE_COUNT = 7
local LWSheep = BaseClass("LWSheep")
local SeasonBlockLevelSolutionTemplate = require("DataCenter.LWSheep.SeasonBlockLevelSolutionTemplate")
local LWSheepCard = require("DataCenter.LWSheep.LWSheepCard")
local Stack = require("Common.Stack")
local LWSheepUtil = require("DataCenter.LWSheep.LWSheepUtil")

local function ForEachShowCards(self, callback)
  for _, heightCards in pairs(self.showCards) do
    for _, card in pairs(heightCards) do
      if callback then
        callback(card)
      end
    end
  end
end

local function ForEachMapCards(self, callback)
  for _, card in pairs(self.mapCards) do
    if callback then
      callback(card)
    end
  end
end

local function ToDoAction(self)
  if self.actions[self.gameState] ~= nil then
    if self.gameState == SheepGameState.Exception then
      local serverInfo = DataCenter.LWSheepDataManager.sheepData
      local deg = {
        client = self.removeList,
        server = serverInfo.eliminate
      }
      self.actions[self.gameState](deg)
    else
      self.actions[self.gameState]()
    end
  end
end

function LWSheep:__init()
  self.gameState = SheepGameState.Init
  self.actions = {
    [SheepGameState.Init] = nil,
    [SheepGameState.Build] = nil,
    [SheepGameState.ReBuild] = nil,
    [SheepGameState.Doing] = nil,
    [SheepGameState.Fair] = nil,
    [SheepGameState.Success] = nil,
    [SheepGameState.Exception] = nil,
    [SheepGameState.SyncException] = nil
  }
  self.configMap = {}
  self.configMapData = {}
  self.map = {}
  self.mapCards = {}
  self.stackCards = Stack.New()
  self.showCards = {}
  self.visualList = {}
  self.removeList = {}
  self.temporaryList = {}
  self.maxHeight = 0
  self.cardWidth = 48.0
  self.cardHeight = 49.5
  self.itemIds = {}
  self.max_temporary_count = 0
  self.lastOptAction = ""
  self.removeOp = false
end

function LWSheep:__delete()
  self.gameState = nil
  self.actions = nil
  self.configMapData = nil
  self.map = nil
  self.mapCards = nil
  self.stackCards = nil
  self.showCards = nil
  self.visualList = nil
  self.removeList = nil
  self.temporaryList = nil
  self.maxHeight = nil
  self.cardWidth = nil
  self.itemIds = nil
  self.max_temporary_count = nil
  self.lastOptAction = nil
  self.removeOp = nil
  self.rewardsInfo = nil
end

function LWSheep:Debugger()
  local template = SeasonBlockLevelSolutionTemplate.New()
  self.maxHeight = 1
  local sb = StringBuilder.New()
  LocalController:instance():visitTable(TableName.SEASON_BLOCK_LEVEL_SOLUTION, function(id, lineData)
    table.clear(template.blockMap)
    template:UpdateData(lineData)
    local cardList = {}
    for gridId, v in pairs(template.blockMap) do
      local card = LWSheepCard.New()
      card:Bind(gridId, v.pos.x, v.pos.y, v.pos.z)
      table.insert(cardList, card)
    end
    local occList = {}
    for _, aCard in ipairs(cardList) do
      for k, _ in pairs(aCard.occGridList) do
        if occList[k] then
          sb:AppendLine("id " .. template.id .. "|" .. aCard.pos.x .. "," .. aCard.pos.y .. "||" .. occList[k].pos.x .. "," .. occList[k].pos.y)
          break
        end
        occList[k] = aCard
      end
    end
  end)
  print(sb:ToString())
end

function LWSheep:BuildConfig(blockId)
  LWSheepUtil.GAME_TEMP_WIDTH = tonumber(DataCenter.LWSheepDataManager:GetActivityData().para_4)
  LWSheepUtil.GAME_TEMP_HEIGHT = tonumber(DataCenter.LWSheepDataManager:GetActivityData().para_5)
  self.max_temporary_count = LWSheepUtil.GAME_TEMP_WIDTH * LWSheepUtil.GAME_TEMP_WIDTH
  local actData = DataCenter.LWSheepDataManager:GetActivityData()
  if actData == nil then
    self.gameState = SheepGameState.Exception
    ToDoAction(self)
  end
  local itemIds = string.split(actData.para_6, "|")
  for index, v in ipairs(itemIds) do
    self.itemIds[index] = toInt(v)
  end
  self.configMap = nil
  local cacheConfigMap = self.configMapData[blockId]
  if cacheConfigMap ~= nil then
    self.configMap = cacheConfigMap
    self.maxHeight = cacheConfigMap.maxHeight
    return
  end
  self.configMap = {}
  local layoutPlan = GetTableData(TableName.SEASON_BLOCK_REMOVAL, blockId, "layout_plan")
  local template = SeasonBlockLevelSolutionTemplate.New()
  self.maxHeight = 1
  LocalController:instance():visitTable(TableName.SEASON_BLOCK_LEVEL_SOLUTION, function(id, lineData)
    table.clear(template.blockMap)
    template:UpdateData(lineData)
    if template.group == layoutPlan then
      for k, v in pairs(template.blockMap) do
        self.configMap[k] = v
      end
      self.maxHeight = math.max(self.maxHeight, template.height)
    end
  end)
  self.configMap.maxHeight = self.maxHeight
  self.configMapData[blockId] = self.configMap
end

function LWSheep:BuildCard(stack)
  for _, cardServerInfo in ipairs(stack) do
    local serverPosStr = cardServerInfo.sheepId:split("_")
    local serverX, serverY, serverZ = toInt(serverPosStr[1]), toInt(serverPosStr[2]), toInt(serverPosStr[3])
    local card = self.stackCards:Pop() or LWSheepCard.New()
    local gridId = LWSheepUtil.PosXYZToGridID(serverX, serverY, serverZ)
    local floorId = LWSheepUtil.PosXYToFloorId(serverX, serverY)
    local offsetX = self.configMap.resultSort[floorId][1][gridId]
    local offsetY = self.configMap.resultSort[floorId][2][gridId]
    card:Bind(gridId, serverX, serverY, serverZ, offsetX, offsetY, toInt(cardServerInfo.pictureId), self.cardWidth, self.cardHeight)
    self.mapCards[gridId] = card
    self.showCards[serverZ] = self.showCards[serverZ] or {}
    self.showCards[serverZ][gridId] = card
    card:ForEachSetOcc(function(occGridId)
      local xy = LWSheepUtil.GridIDToXY(occGridId)
      local height = LWSheepUtil.GridIDToHeight(occGridId)
      self.map[height][xy] = true
      return false
    end)
  end
  return visualMap
end

function LWSheep:BuildMap()
  for height = 1, self.maxHeight do
    for x = 0, GAME_WIDTH - 1 do
      for y = 0, GAME_HEIGHT - 1 do
        self.map[height] = self.map[height] or {}
      end
    end
  end
end

function LWSheep:BuildSort(server)
  local sortCardList = {}
  for _, cardServerInfo in ipairs(server.stack) do
    local serverPosStr = cardServerInfo.sheepId:split("_")
    local serverX, serverY, serverZ = toInt(serverPosStr[1]), toInt(serverPosStr[2]), toInt(serverPosStr[3])
    local gridId = LWSheepUtil.PosXYZToGridID(serverX, serverY, serverZ)
    local configCard = self.configMap[gridId]
    table.insert(sortCardList, {
      offset = configCard.offset,
      pos = {
        x = serverX,
        y = serverY,
        z = serverZ
      },
      pictureId = cardServerInfo.pictureId
    })
  end
  local sortList = {}
  for k, v in ipairs(sortCardList) do
    local gridId = LWSheepUtil.PosXYZToGridID(v.pos.x, v.pos.y, v.pos.z)
    local floorId = LWSheepUtil.PosXYToFloorId(v.pos.x, v.pos.y)
    sortList[floorId] = sortList[floorId] or {}
    sortList[floorId][1] = sortList[floorId][1] or {}
    sortList[floorId][2] = sortList[floorId][2] or {}
    table.insert(sortList[floorId][1], {
      gridId = gridId,
      offset = v.offset.x
    })
    table.insert(sortList[floorId][2], {
      gridId = gridId,
      offset = v.offset.y
    })
  end
  for k, v in pairs(sortList) do
    table.sort(v[1], function(a, b)
      return a.offset < b.offset
    end)
    table.sort(v[2], function(a, b)
      return a.offset < b.offset
    end)
  end
  local resultSort = {}
  for floorId, v in pairs(sortList) do
    resultSort[floorId] = resultSort[floorId] or {}
    resultSort[floorId][1] = resultSort[floorId][1] or {}
    resultSort[floorId][2] = resultSort[floorId][2] or {}
    local temp = resultSort[floorId][1]
    local sortIndex, tempValue = -1, -1
    for _, vv in ipairs(v[1]) do
      if tempValue ~= vv.offset then
        sortIndex = sortIndex + 1
        temp[vv.gridId] = sortIndex
        tempValue = vv.offset
      else
        temp[vv.gridId] = sortIndex
      end
    end
    sortIndex, tempValue = -1, -1
    temp = resultSort[floorId][2]
    for _, vv in ipairs(v[2]) do
      if tempValue ~= vv.offset then
        sortIndex = sortIndex + 1
        temp[vv.gridId] = sortIndex
        tempValue = vv.offset
      else
        temp[vv.gridId] = sortIndex
      end
    end
  end
  self.configMap.resultSort = resultSort
end

function LWSheep:BuildVisualList()
  ForEachShowCards(self, function(card)
    card:ForEachSetOcc(function(occGridId)
      if occGridId == LWSheepUtil.PosXYZToGridID(7, 2, 7) then
        aaa = 10
      end
      local xy = LWSheepUtil.GridIDToXY(occGridId)
      local height = LWSheepUtil.GridIDToHeight(occGridId)
      if height == self.maxHeight then
        return false
      else
        local occ = false
        for opHeight = height + 1, self.maxHeight do
          occ = self.map[opHeight][xy] or occ
          if occ then
            break
          end
        end
        return occ
      end
    end)
  end)
  ForEachShowCards(self, function(card)
    if card:IsVisual() then
      self.visualList[card.gridId] = card
    end
  end)
  local tempOp = self:TemporaryTo2List()
  for _, tempCards in pairs(tempOp) do
    local visualCard = tempCards[#tempCards]
    if visualCard then
      self.visualList[visualCard.gridId] = visualCard
    end
  end
end

function LWSheep:BuildRemoveList(eliminate)
  for index, cardServerInfo in ipairs(eliminate) do
    local serverPosStr = cardServerInfo.sheepId:split("_")
    local serverX, serverY, serverZ = toInt(serverPosStr[1]), toInt(serverPosStr[2]), toInt(serverPosStr[3])
    local card = self.stackCards:Pop() or LWSheepCard.New()
    local gridId = LWSheepUtil.PosXYZToGridID(serverX, serverY, serverZ)
    card:Bind(gridId, serverX, serverY, serverZ, 0, 0, toInt(cardServerInfo.pictureId), self.cardWidth, self.cardHeight)
    self.mapCards[gridId] = card
    self.removeList[index] = card
  end
end

function LWSheep:BuildTemporaryList(cache)
  for _, cacheInfo in pairs(cache) do
    local serverPosStr = cacheInfo.sheepId:split("_")
    local serverX, serverY, serverZ = toInt(serverPosStr[1]), toInt(serverPosStr[2]), toInt(serverPosStr[3])
    local card = self.stackCards:Pop() or LWSheepCard.New()
    local gridId = LWSheepUtil.PosXYZToGridID(serverX, serverY, serverZ)
    card:Bind(gridId, serverX, serverY, serverZ, 0, 0, toInt(cacheInfo.pictureId), self.cardWidth, self.cardHeight)
    self.mapCards[gridId] = card
    local line = toInt(cacheInfo.line + 1)
    local pos = toInt(cacheInfo.pos)
    local tempId = LWSheepUtil.PosXYToTempID(line, pos)
    self.temporaryList[tempId] = card
    card:BindTempId(tempId)
  end
end

function LWSheep:Build(server)
  self.gameState = SheepGameState.Build
  self.lastOptAction = server.lastOptAction
  self.rewardsInfo = server.rewardsInfo
  self:BuildConfig(server.blockId)
  self:BuildMap()
  self:BuildSort(server)
  self:BuildCard(server.stack)
  self:BuildRemoveList(server.eliminate)
  self:BuildTemporaryList(server.cache)
  self:BuildVisualList()
  ToDoAction(self)
end

function LWSheep:BuildAction(buildAction, reBuildAction, fairAction, successAction, doAction, exceptionAction, syncException)
  self.actions[SheepGameState.Fair] = fairAction
  self.actions[SheepGameState.Success] = successAction
  self.actions[SheepGameState.Build] = buildAction
  self.actions[SheepGameState.ReBuild] = reBuildAction
  self.actions[SheepGameState.Doing] = doAction
  self.actions[SheepGameState.Exception] = exceptionAction
  self.actions[SheepGameState.SyncException] = syncException
end

function LWSheep:ReBuild(server)
  self.gameState = SheepGameState.ReBuild
  table.clear(self.map)
  ForEachMapCards(self, function(card)
    self.stackCards:Push(card)
  end)
  table.clear(self.mapCards)
  table.clear(self.showCards)
  table.clear(self.visualList)
  table.clear(self.removeList)
  table.clear(self.temporaryList)
  self.rewardsInfo = {}
  self.maxHeight = 0
  self.itemIds = {}
  self.max_temporary_count = 0
  self.lastOptAction = ""
  ToDoAction(self)
  self:Build(server)
end

function LWSheep:RefreshGame(server)
  table.clear(self.map)
  ForEachMapCards(self, function(card)
    self.stackCards:Push(card)
  end)
  table.clear(self.mapCards)
  table.clear(self.showCards)
  table.clear(self.visualList)
  table.clear(self.removeList)
  table.clear(self.temporaryList)
  self.rewardsInfo = {}
  self.maxHeight = 0
  self.itemIds = {}
  self.max_temporary_count = 0
  self.lastOptAction = ""
  self.lastOptAction = server.lastOptAction
  self.rewardsInfo = server.rewardsInfo
  self:BuildConfig(server.blockId)
  self:BuildMap()
  self:BuildSort(server)
  self:BuildCard(server.stack)
  self:BuildRemoveList(server.eliminate)
  self:BuildTemporaryList(server.cache)
  self:BuildVisualList()
end

function LWSheep:Enter()
  self.gameState = SheepGameState.Doing
  ToDoAction(self)
end

function LWSheep:GetItemIdByType(itemType)
  return self.itemIds[itemType]
end

function LWSheep:CheckGameState()
  local removeList = table.count(self.removeList)
  if removeList >= GAME_REMOVE_COUNT then
    self.gameState = SheepGameState.Fair
    ToDoAction(self)
  end
  if self.rewardsInfo ~= nil and next(self.rewardsInfo) then
    self.gameState = SheepGameState.Success
    ToDoAction(self)
  end
end

function LWSheep:TemporaryTo2List()
  local tempOp = {}
  for _, card in pairs(self.temporaryList) do
    local x, y = LWSheepUtil.TempIDToPosXY(card.tempId)
    tempOp[x] = tempOp[x] or {}
    tempOp[x][y + 1] = card
  end
  return tempOp
end

function LWSheep:GetTemporaryCount()
  return table.count(self.temporaryList)
end

function LWSheep:GetCard(gridId)
  return self.mapCards[gridId]
end

function LWSheep:IsOcc(gridId)
  local height = LWSheepUtil.GridIDToHeight(gridId)
  local cards = self.showCards[height]
  if cards ~= nil then
    for _, card in pairs(cards) do
      if card:IsOcc(gridId) then
        return true
      end
    end
  end
  return false
end

function LWSheep:GetVisualCardByXYZ(gridId, height, addVisualMap)
  if height == 1 then
    return nil
  end
  local find = false
  for z = height - 1, 1, -1 do
    local nextCards = self.showCards[z]
    if nextCards ~= nil then
      local opIGridId = LWSheepUtil.GridIDToHeightGridID(gridId, z)
      for _, card in pairs(nextCards) do
        find = find or card:IsOcc(opIGridId)
        if card:IsOcc(opIGridId) then
          card:SetOccGridList(opIGridId, false)
          if card:IsVisual() then
            addVisualMap[card.gridId] = card
          end
        end
      end
      if find then
        break
      end
    end
  end
end

function LWSheep:CanClick(gridId)
  return self.visualList[gridId] ~= nil and table.count(self.removeList) < GAME_REMOVE_COUNT
end

function LWSheep:AddToRemoveList(gridId)
  local card = self:GetCard(gridId)
  local count = table.count(self.removeList)
  local insertPos = count + 1
  for index = count, 1, -1 do
    local curPictureId = self.removeList[index].pictureId
    if curPictureId == card.pictureId then
      insertPos = index + 1
      break
    end
  end
  table.insert(self.removeList, insertPos, card)
  return insertPos
end

function LWSheep:RemoveVisualCardByGridID(gridId)
  local card = self.visualList[gridId]
  if card == nil then
    return
  end
  self.visualList[gridId] = nil
  local addVisualMap = {}
  if card.tempId ~= nil then
    local x, y = LWSheepUtil.TempIDToPosXY(card.tempId)
    local canVisualTempId = LWSheepUtil.PosXYToTempID(x, y - 1)
    local newVisCard = self.temporaryList[canVisualTempId]
    if newVisCard ~= nil then
      self.visualList[newVisCard.gridId] = newVisCard
      addVisualMap[newVisCard.gridId] = newVisCard
    end
  else
    for gridId, _ in pairs(card.occGridList) do
      self:RefreshVisualOccupied(gridId, addVisualMap)
    end
  end
  return addVisualMap
end

function LWSheep:RefreshVisualOccupied(gridId, addVisualMap)
  local height = LWSheepUtil.GridIDToHeight(gridId)
  self:GetVisualCardByXYZ(gridId, height, addVisualMap)
end

function LWSheep:MoveToShowCards(gridId, removeVisualMap)
  local height = LWSheepUtil.GridIDToHeight(gridId)
  if height == 1 then
    return nil
  end
  local find = false
  for z = height - 1, 1, -1 do
    local nextCards = self.showCards[z]
    if nextCards ~= nil then
      local opIGridId = LWSheepUtil.GridIDToHeightGridID(gridId, z)
      for _, card in pairs(nextCards) do
        find = find or card:IsOcc(opIGridId)
        if find then
          card:SetOccGridList(opIGridId, true)
          if not card:IsVisual() and self.visualList[card.gridId] ~= nil then
            removeVisualMap[card.gridId] = card
          end
        end
      end
      if find then
        break
      end
    end
  end
end

function LWSheep:CanRemove(pos)
  local removePictureId = self.removeList[pos].pictureId
  for index = pos - 1, pos - 2, -1 do
    if index < 1 then
      return false
    end
    local card = self.removeList[index]
    if removePictureId ~= card.pictureId then
      return false
    end
  end
  return true
end

function LWSheep:CanClickInTemp(card)
  local tempOp = self:TemporaryTo2List()
  local x, y = LWSheepUtil.TempIDToPosXY(card.tempId)
  if tempOp[x] ~= nil then
    return #tempOp[x] == y + 1
  end
  return false
end

function LWSheep:Click(card)
  if self.gameState ~= SheepGameState.Doing then
    return false
  end
  local gridId = card.gridId
  if not self:CanClick(gridId) then
    return false
  end
  local isTemp = card.tempId ~= nil
  local addVisualCards = self:RemoveVisualCardByGridID(gridId)
  for _, visualCard in pairs(addVisualCards) do
    self.visualList[visualCard.gridId] = visualCard
  end
  if not isTemp then
    self.showCards[LWSheepUtil.GridIDToHeight(gridId)][gridId] = nil
  else
    self.temporaryList[card.tempId] = nil
    card.tempId = nil
  end
  local pos = self:AddToRemoveList(gridId)
  local card = self:GetCard(gridId)
  card.firstRemoveIndex = pos
  local canRemove = self:CanRemove(pos)
  if canRemove then
    for index = pos, pos - 2, -1 do
      table.remove(self.removeList, index)
    end
  end
  self.removeOp = canRemove
  return true, pos, canRemove, addVisualCards, isTemp
end

function LWSheep:UseItem(itemType)
  local itemId = self.itemIds[itemType]
  if itemId == nil then
    return false
  end
  local itemCount = DataCenter.ItemData:GetItemCount(itemId)
  if itemCount <= 0 then
    return false
  end
  return true
end

function LWSheep:GetPassRewards()
  return self.rewardsInfo
end

function LWSheep:CanUseItem(type)
  local itemId = self.itemIds[type] or 0
  local itemCount = DataCenter.ItemData:GetItemCount(itemId) or 0
  if itemCount <= 0 then
    return false
  end
  local tip
  if type == SheepGameOpType.Move then
    local canUse = true
    for index = 1, LWSheepUtil.GAME_TEMP_WIDTH do
      canUse = canUse and self.temporaryList[LWSheepUtil.PosXYToTempID(index, LWSheepUtil.GAME_TEMP_HEIGHT - 1)] == nil
    end
    if not canUse then
      tip = "season_s4_activity_1200010_desc19"
    end
    canUse = canUse and 0 < #self.removeList
    if not canUse and not tip then
      tip = "season_s4_activity_1200010_desc18"
    end
    return canUse, tip
  elseif type == SheepGameOpType.Back then
    local canUse = not string.IsNullOrEmpty(self.lastOptAction)
    if not canUse then
      if self.removeOp then
        tip = "season_s4_activity_1200010_desc21"
      else
        tip = "season_s4_activity_1200010_desc20"
      end
    end
    return canUse, tip
  elseif type == SheepGameOpType.Refresh then
    local count = 0
    for _, heightCards in pairs(self.showCards) do
      count = count + table.count(heightCards)
    end
    local canUse = 0 < count
    if not canUse then
      tip = "season_s4_activity_1200010_desc38"
    end
    return canUse, tip
  end
end

function LWSheep:CheckRemoveArena(eliminate)
  for index, cardServerInfo in ipairs(eliminate) do
    local removeCard = self.removeList[index]
    if removeCard == nil then
      return false
    end
    if removeCard:GetPosToServer() ~= cardServerInfo.sheepId then
      return false
    end
  end
  return true
end

function LWSheep:CheckSyncRemoveArena(eliminate, syncData)
  for index, cardServerInfo in ipairs(eliminate) do
    local removeCard = syncData[index]
    if removeCard == nil then
      return false
    end
  end
  return true
end

function LWSheep:OpCheck(userData, syncData)
  local visualCards = {}
  if userData.type == SheepGameOpType.Move then
    local goToTempCards = {}
    local removeIndex = math.min(3, #self.removeList)
    for _ = 1, removeIndex do
      local removeCard = table.remove(self.removeList, 1)
      goToTempCards[removeCard.gridId] = removeCard
    end
    if not self:CheckRemoveArena(userData.eliminate) then
      self.gameState = SheepGameState.Exception
      ToDoAction(self)
      return
    end
    local tempOp = self:TemporaryTo2List()
    for _, cacheInfo in pairs(userData.cache) do
      local serverPosStr = cacheInfo.sheepId:split("_")
      local serverX, serverY, serverZ = toInt(serverPosStr[1]), toInt(serverPosStr[2]), toInt(serverPosStr[3])
      local gridId = LWSheepUtil.PosXYZToGridID(serverX, serverY, serverZ)
      local card = goToTempCards[gridId]
      if card ~= nil then
        local line = toInt(cacheInfo.line + 1)
        local pos = toInt(cacheInfo.pos)
        local tempId = LWSheepUtil.PosXYToTempID(line, pos)
        card:BindTempId(tempId)
        self.temporaryList[tempId] = card
        if tempOp[line] ~= nil and tempOp[line][pos] ~= nil then
          local gridId = tempOp[line][pos].gridId
          self.visualList[gridId] = nil
          visualCards[gridId] = tempOp[line][pos]
        end
        visualCards[gridId] = card
        self.visualList[gridId] = card
      end
    end
    userData.moveCards = goToTempCards
    if self.gameState == SheepGameState.Fair then
      self.gameState = SheepGameState.Doing
    end
  elseif userData.type == SheepGameOpType.Back then
    if string.IsNullOrEmpty(userData.lastOptAction) then
      self.gameState = SheepGameState.Exception
      ToDoAction(self)
      return
    end
    local opInfo = string.split(userData.lastOptAction, "|")
    local goToArena = toInt(opInfo[1])
    local serverPosStr = opInfo[2]:split("_")
    local serverX, serverY, serverZ = toInt(serverPosStr[1]), toInt(serverPosStr[2]), toInt(serverPosStr[3])
    local gridId = LWSheepUtil.PosXYZToGridID(serverX, serverY, serverZ)
    local backCard = self:GetCard(gridId)
    local removeIndex = table.indexof(self.removeList, backCard)
    if not removeIndex then
      self.gameState = SheepGameState.Exception
      ToDoAction(self)
      return
    end
    table.remove(self.removeList, removeIndex)
    if goToArena == 1 then
      self.showCards[LWSheepUtil.GridIDToHeight(gridId)][gridId] = backCard
      for occGridId, _ in pairs(backCard.occGridList) do
        self:MoveToShowCards(occGridId, visualCards)
      end
      for gridId, _ in pairs(visualCards) do
        self.visualList[gridId] = nil
      end
    elseif goToArena == 2 then
      local tempOp = self:TemporaryTo2List()
      local tempX = toInt(opInfo[3]) + 1
      local tempRow = tempOp[tempX]
      local tempId = LWSheepUtil.PosXYToTempID(tempX, tempRow and #tempRow or 0)
      self.temporaryList[tempId] = backCard
      backCard:BindTempId(tempId)
      local notVisual = tempRow and tempRow[#tempRow] or nil
      if notVisual ~= nil then
        self.visualList[notVisual.gridId] = nil
        visualCards[notVisual.gridId] = notVisual
      end
    end
    visualCards[gridId] = backCard
    self.visualList[gridId] = backCard
    userData.backCard = backCard
    userData.backType = goToArena
    userData.lastOptAction = nil
    if self.gameState == SheepGameState.Fair then
      self.gameState = SheepGameState.Doing
    end
  elseif userData.type == SheepGameOpType.Refresh then
  elseif userData.type == SheepGameOpType.Click then
    if syncData ~= nil and not self:CheckSyncRemoveArena(userData.eliminate, syncData) then
      self.gameState = SheepGameState.SyncException
      ToDoAction(self)
      return
    end
    if userData.rewardsInfo ~= nil and next(userData.rewardsInfo) then
      self.gameState = SheepGameState.Success
      ToDoAction(self)
      self.rewardsInfo = userData.rewardsInfo
    end
    userData.clickGridId = userData.opPointId
  end
  self.lastOptAction = userData.lastOptAction
  userData.visualCards = visualCards
  self:CheckGameState()
  return userData
end

return LWSheep
