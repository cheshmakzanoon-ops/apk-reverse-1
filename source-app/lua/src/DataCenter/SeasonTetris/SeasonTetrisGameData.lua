local rapidjson = require("rapidjson")
local SeasonTetrisGameData = BaseClass("SeasonTetrisGameData")

function SeasonTetrisGameData:__init()
  self.GameMap = nil
  self.MapX = DataCenter.SeasonTetrisManager.MapX
  self.MapY = DataCenter.SeasonTetrisManager.MapY
  self.PieceX = DataCenter.SeasonTetrisManager.PieceX
  self.PieceY = DataCenter.SeasonTetrisManager.PieceY
  self.FinishedItems = {}
  self.PieceList = {}
  self.GameCell = nil
  self.PreConfigId = ""
  self.StartTime = 0
  self.PutTimes = 0
  self.DayIndex = 0
  self.DayStageIndex = 0
  self.Target = {}
end

function SeasonTetrisGameData:__delete()
  self.GameMap = nil
  self.MapX = 0
  self.MapY = 0
  self.PieceX = 0
  self.PieceY = 0
  self.FinishedItems = {}
  self.PieceList = {}
  self.GameCell = nil
  self.PreConfigId = ""
  self.StartTime = 0
  self.PutTimes = 0
  self.DayIndex = 0
  self.DayStageIndex = 0
  self.Target = {}
end

function SeasonTetrisGameData:SetData(data)
  self:HandleInfo(data)
  self.GameMap = {}
  for i = 0, self.MapX - 1 do
    self.GameMap[i] = {}
    for j = 0, self.MapY - 1 do
      self.GameMap[i][j] = 0
    end
  end
  local stageData = data.stagedata
  if stageData ~= nil then
    self.IsFail = checknumber(stageData.isFail)
    self.IsWin = checknumber(stageData.isWin)
    for _, blockInfo in pairs(stageData.blocklist) do
      if not string.IsNullOrEmpty(blockInfo.itemid) then
        self.GameMap[blockInfo.x][blockInfo.y] = blockInfo.itemid
      else
        self.GameMap[blockInfo.x][blockInfo.y] = -1
      end
    end
    self:HandlePieceList(stageData.piecelist)
    self:HandleFinishItem(stageData.itemList)
  end
end

function SeasonTetrisGameData:HandleInfo(info)
  if info == nil then
    return
  end
  self.GameCell = LocalController:instance():getLine(TableName.SEASON_S1_BLOCK_GAME, info.stagecfgid)
  self.StartTime = info.stagestarttime
  self.DayIndex = info.dayindex
  self.DayStageIndex = info.daystageindex
  self.PreConfigId = info.prestagecfgid
  self:HandlePutTimes(info.puttimes)
  self.Target = {}
  if self.GameCell ~= nil then
    local targetList = string.string2table_ii_toList(self.GameCell.aim, "|", ";", nil)
    for _, pair in pairs(targetList) do
      local itemId = tostring(pair[1])
      local num = pair[2]
      local targetData = {}
      targetData.ItemId = itemId
      targetData.Target = num
      targetData.Gained = 0
      self.Target[itemId] = targetData
    end
  end
end

function SeasonTetrisGameData:HandlePutTimes(putTimes)
  self.PutTimes = toInt(putTimes)
end

function SeasonTetrisGameData:HandleFinishItem(finishList)
  if self.Target == nil then
    self.Target = {}
  end
  for _, itemInfo in pairs(finishList) do
    if table.containsKey(self.Target, itemInfo.id) then
      self.Target[itemInfo.id].Gained = itemInfo.num
    end
  end
end

function SeasonTetrisGameData:HandlePieceList(pieceList)
  self.PieceList = {}
  if table.IsNullOrEmpty(pieceList) then
    return
  end
  for _, pieceInfo in pairs(pieceList) do
    local pieceData = {}
    pieceData.PieceInfo = pieceInfo
    pieceData.Map = {}
    pieceData.BlockCount = 0
    pieceData.ItemCount = 0
    local pieceX = DataCenter.SeasonTetrisManager.PieceX
    local pieceY = DataCenter.SeasonTetrisManager.PieceY
    for i = 0, pieceX - 1 do
      pieceData.Map[i] = {}
      for j = 0, pieceY - 1 do
        pieceData.Map[i][j] = 0
      end
    end
    local blockCell = LocalController:instance():getLine(TableName.SEASON_S1_BLOCK, pieceInfo.cfgid)
    local blockList = string.string2table_ii_toList(blockCell.composition, "|", ";", nil)
    if not table.IsNullOrEmpty(blockList) then
      for _, pair in pairs(blockList) do
        pieceData.Map[pair[1]][pair[2]] = -1
        pieceData.BlockCount = pieceData.BlockCount + 1
      end
    end
    for i, blockInfo in pairs(pieceInfo.blocklist) do
      if not string.IsNullOrEmpty(blockInfo.itemid) then
        pieceData.Map[blockInfo.x][blockInfo.y] = blockInfo.itemid
        pieceData.ItemCount = pieceData.ItemCount + 1
      else
      end
    end
    pieceData.Perimeter = 0
    local dx = {
      0,
      0,
      1,
      -1
    }
    local dy = {
      1,
      -1,
      0,
      0
    }
    for i = 0, pieceX - 1 do
      for j = 0, pieceY - 1 do
        if pieceData.Map[i][j] ~= 0 then
          for k = 1, 4 do
            local x = i + dx[k]
            local y = j + dy[k]
            if x < 0 or pieceX <= x or y < 0 or pieceY <= y or pieceData.Map[x][y] == 0 then
              pieceData.Perimeter = pieceData.Perimeter + 1
            end
          end
        end
      end
    end
    local minX = self.PieceX
    local maxX = 0
    local minY = self.PieceY
    local maxY = 0
    for i = 0, self.PieceX - 1 do
      for j = 0, self.PieceY - 1 do
        if pieceData.Map[i][j] ~= 0 then
          minX = math.min(minX, i)
          maxX = math.max(maxX, i)
          minY = math.min(minY, j)
          maxY = math.max(maxY, j)
        end
      end
    end
    pieceData.CenterX = (maxX - minX + 1) * 0.5
    pieceData.CenterY = (maxY - minY + 1) * 0.5
    pieceData.Offset = Vector2.New(0.5 - pieceData.CenterX, 0.5)
    local posId = pieceInfo.id
    self.PieceList[posId] = pieceData
  end
end

function SeasonTetrisGameData:GetPiece(pos)
  pos = Mathf.Clamp(pos, 0, 2)
  if self.PieceList[pos] then
    return self.PieceList[pos]
  end
  return nil
end

function SeasonTetrisGameData:IsPieceSame(piece1, piece2)
  if not piece1 or not piece2 then
    return false
  end
  local pieceX = DataCenter.SeasonTetrisManager.PieceX
  local pieceY = DataCenter.SeasonTetrisManager.PieceY
  for i = 0, pieceX - 1 do
    for j = 0, pieceY - 1 do
      if piece1.Map[i][j] ~= piece2.Map[i][j] then
        return false
      end
    end
  end
  return true
end

function SeasonTetrisGameData:RemovePiece(piece)
  if piece == nil then
    return nil
  end
  local posId = piece.PieceData.PieceInfo.id
  self.PieceList[posId] = nil
end

function SeasonTetrisGameData:GetTargetData(itemId)
  if self.Target == nil then
    return nil
  end
  return self.Target[itemId]
end

function SeasonTetrisGameData:IsEmpty()
  if table.IsNullOrEmpty(self.GameMap) then
    return true
  end
  for i = 0, self.MapX - 1 do
    for j = 0, self.MapY - 1 do
      if self.GameMap[i][j] ~= 0 then
        return false
      end
    end
  end
  return true
end

function SeasonTetrisGameData:IsPieceEmpty()
  return table.IsNullOrEmpty(self.PieceList)
end

function SeasonTetrisGameData:IsWinOrFail()
  return self:IsServerWin() or self:IsServerFail()
end

function SeasonTetrisGameData:IsServerWin()
  return checknumber(self.IsWin) == 1
end

function SeasonTetrisGameData:IsServerFail()
  return checknumber(self.IsFail) == 1
end

function SeasonTetrisGameData:PrintMap()
  if CS.CommonUtils.IsDebug() and CS.UnityEngine.Application.isEditor then
    local str = ""
    for j = self.MapY - 1, 0, -1 do
      for i = 0, self.MapX - 1 do
        if self.GameMap[i][j] == 0 then
          str = str .. "\226\150\161 "
        elseif self.GameMap[i][j] == -1 then
          str = str .. "\226\150\160 "
        else
          str = str .. "\226\150\160 "
        end
      end
      str = str .. "\n"
    end
    Logger.Log("\227\128\144\228\191\132\231\189\151\230\150\175\230\150\185\229\157\151\227\128\145\227\128\144GameMap\227\128\145\n" .. str .. "\n")
  end
end

function SeasonTetrisGameData:Debug()
  if CS.CommonUtils.IsDebug() and CS.UnityEngine.Application.isEditor then
    local jsonStr = rapidjson.encode(self.GameMap, {pretty = true, sort_keys = true})
    Logger.Log("\227\128\144\228\191\132\231\189\151\230\150\175\230\150\185\229\157\151\227\128\145\227\128\144GameData\227\128\145\n" .. jsonStr .. "\n")
  end
end

return SeasonTetrisGameData
