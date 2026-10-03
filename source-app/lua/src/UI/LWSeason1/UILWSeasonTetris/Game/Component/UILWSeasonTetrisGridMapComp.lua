local base = UIBaseContainer
local UILWSeasonTetrisPieceContentComp = require("UI.LWSeason1.UILWSeasonTetris.Game.Component.UILWSeasonTetrisPieceContentComp")
local UILWSeasonTetrisGridMapComp = BaseClass("UILWSeasonTetrisGridMapComp", UIBaseContainer)
local block_prefab_path = "Assets/Main/Prefabs/UI/LWSeason1/Tetris/SeasonTetrisBlockItem.prefab"
local block_script_path = require("UI.LWSeason1.UILWSeasonTetris.Game.Component.UILWSeasonTetrisBlockItemComp")
local target_script_path = require("UI.LWSeason1.UILWSeasonTetris.Game.Component.UILWSeasonTetrisTargetComp")
local ChildBlockNamePrefix = "BlockTemplate_%s_%s_%s"
local ChildShadowNamePrefix = "ShadowTemplate_%s_%s_%s"
local ChildTargetCompNamePrefix = "TargetTemplate_%s"
local ChildDeleteVfxNamePrefix = "DeleteVfx_%s_%s_%s_%s_%s"
local great_vfx_path = "Assets/Main/Prefabs/UI/LWSeason1/Tetris/SeasonTetrisGreat.prefab"
local good_vfx_path = "Assets/Main/Prefabs/UI/LWSeason1/Tetris/SeasonTetrisSpecialTextGood.prefab"
local amazing_vfx_path = "Assets/Main/Prefabs/UI/LWSeason1/Tetris/SeasonTetrisSpecialTextAmazing.prefab"
local perfect_vfx_path = "Assets/Main/Prefabs/UI/LWSeason1/Tetris/SeasonTetrisSpecialTextPerfect.prefab"
local ChildPriseVfxNamePrefix = "PriseVfxTemplate_%s_%s_%s"
local Localization = CS.GameEntry.Localization
local CSVibrator = CS.Vibrator

function UILWSeasonTetrisGridMapComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonTetrisGridMapComp:OnDestroy()
  self:ClearGuide()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonTetrisGridMapComp:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.transContent = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.compPiecePosContent = self.viewSkin:AddComponent(self, UILWSeasonTetrisPieceContentComp, 2)
  self.compTargetTemplate = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.transTargetContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.transVfxColumn = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.transVfxRow = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.transPraiseVfxRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.p_finger_end = self:AddComponent(UIBaseContainer, "p_finger_end")
  self:DefineComp()
end

function UILWSeasonTetrisGridMapComp:ComponentDestroy()
  self:ClearComp()
  self.goTargetTemplate = nil
  self.goVfxRow = nil
  self.goVfxColumn = nil
  self.p_finger_end = nil
  self.viewSkin = nil
  self.transContent = nil
  self.compPiecePosContent = nil
  self.compTargetTemplate = nil
  self.transTargetContent = nil
  self.transVfxColumn = nil
  self.transVfxRow = nil
  self.transPraiseVfxRoot = nil
end

function UILWSeasonTetrisGridMapComp:DataDefine()
  self:ClearData()
end

function UILWSeasonTetrisGridMapComp:DataDestroy()
  self:ClearData()
end

function UILWSeasonTetrisGridMapComp:ClearData()
  self.BlockIndex = 0
  self.ShadowIndex = 0
  self.BlockReq = {}
  self.ShadowReq = {}
  self.MapX = DataCenter.SeasonTetrisManager.MapX
  self.MapY = DataCenter.SeasonTetrisManager.MapY
  for i = 0, self.MapX - 1 do
    self.BlockReq[i] = {}
    self.ShadowReq[i] = {}
    for j = 0, self.MapY - 1 do
      self.BlockReq[i][j] = nil
      self.ShadowReq[i][j] = nil
    end
  end
  self.TargetComps = {}
  self.HasWinOrFail = false
  self.DeleteVfxReq = {}
  self.PriseVfxReq = {}
  self.PriseLevel = {
    Great = 1,
    Good = 2,
    Amazing = 3,
    Perfect = 4,
    None = 5
  }
  self.PriseVfxPath = {
    [self.PriseLevel.Great] = great_vfx_path,
    [self.PriseLevel.Good] = good_vfx_path,
    [self.PriseLevel.Amazing] = amazing_vfx_path,
    [self.PriseLevel.Perfect] = perfect_vfx_path
  }
  self.PriseSound = {
    [self.PriseLevel.Good] = 1000014,
    [self.PriseLevel.Amazing] = 1000015,
    [self.PriseLevel.Perfect] = 1000016
  }
  self.ShockLevel = self.PriseLevel.Amazing
  self.WinData = nil
  self.DisappearDelayBetweenBlock = 0.05
  self.DisappearDelayBetweenLine = 0.1
  self.AutoCheckCd = 3
  self.AutoCheckTime = 0
  if not table.IsNullOrEmpty(self.FlyTimer) then
    for _, timer in ipairs(self.FlyTimer) do
      timer:Stop()
      timer = nil
    end
  end
  self.FlyTimer = {}
  self.PieceEmptyTime = -1
  self.WaitResultTime = -1
  self.GuideCd = 3
  self.GuideTime = 0
  self:SetCanGuide(true)
end

function UILWSeasonTetrisGridMapComp:DefineComp()
  self.goTargetTemplate = self.compTargetTemplate.gameObject
  self.goTargetTemplate:GameObjectCreatePool()
  self.goTargetTemplate:SetActive(false)
  self.goVfxRow = self.transVfxRow.gameObject
  self.goVfxRow:GameObjectCreatePool()
  self.goVfxRow:SetActive(false)
  self.goVfxColumn = self.transVfxColumn.gameObject
  self.goVfxColumn:GameObjectCreatePool()
  self.goVfxColumn:SetActive(false)
end

function UILWSeasonTetrisGridMapComp:ClearComp()
  local x = DataCenter.SeasonTetrisManager.MapX
  local y = DataCenter.SeasonTetrisManager.MapY
  for i = 0, x - 1 do
    for j = 0, y - 1 do
      if self.BlockReq[i][j] ~= nil then
        if IsNotNull(self.BlockReq[i][j].gameObject) then
          self.transContent:RemoveComponent(self.BlockReq[i][j].gameObject.name, block_script_path)
        end
        self.BlockReq[i][j]:Destroy()
        self.BlockReq[i][j] = nil
      end
    end
  end
  self.BlockReq = nil
  self:ClearShadows()
  self.ShadowReq = nil
  self.transTargetContent:RemoveComponents(target_script_path)
  self.goTargetTemplate:GameObjectRecycleAll()
  self:ClearPriseVfx(true)
end

function UILWSeasonTetrisGridMapComp:ClearPriseVfx(force)
  if not table.IsNullOrEmpty(self.PriseVfxReq) then
    for key, reqData in pairs(self.PriseVfxReq) do
      local req = reqData.req
      if req ~= nil and (force or UITimeManager:GetInstance():GetServerTime() - checknumber(reqData.time) >= 2000) then
        local go = req.gameObject
        if IsNotNull(go) then
          req:Destroy()
          req = nil
          self.PriseVfxReq[key] = nil
        end
      end
    end
  end
end

function UILWSeasonTetrisGridMapComp:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonTetrisGameSuccess, self.OnGameSuccessEvt)
  self:AddUIListener(EventId.SeasonTetrisPieceListUpdate, self.OnPieceUpdate)
end

function UILWSeasonTetrisGridMapComp:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonTetrisGameSuccess, self.OnGameSuccessEvt)
  self:RemoveUIListener(EventId.SeasonTetrisPieceListUpdate, self.OnPieceUpdate)
  base.OnRemoveListener(self)
end

function UILWSeasonTetrisGridMapComp:ReInit()
  self:ClearComp()
  self:ClearData()
  self:UpdateData()
  self:UpdateMap()
  self:UpdatePieceContent()
  self:UpdateTargetContent()
  self:CheckGameState(true)
end

function UILWSeasonTetrisGridMapComp:UpdateData()
  self.GameData = DataCenter.SeasonTetrisManager.GameData
  self.GameCell = self.GameData.GameCell
end

function UILWSeasonTetrisGridMapComp:UpdateMap()
  local gameData = DataCenter.SeasonTetrisManager.GameData
  if gameData == nil then
    return
  end
  local map = gameData.GameMap
  if not table.IsNullOrEmpty(map) then
    for i = 0, gameData.MapX - 1 do
      for j = 0, gameData.MapY - 1 do
        local block = map[i][j]
        if block ~= nil and block ~= 0 then
          local index = Vector2.New(i, j)
          local req = self:SetBlock(index, block, false)
          self.BlockReq[index.x][index.y] = req
        end
      end
    end
  end
end

function UILWSeasonTetrisGridMapComp:UpdatePieceContent()
  self.compPiecePosContent:ReInit()
end

function UILWSeasonTetrisGridMapComp:UpdateTargetContent()
  self.goTargetTemplate:GameObjectRecycleAll()
  if self.GameCell ~= nil then
    for itemId, targetData in pairs(self.GameData.Target) do
      local goItem = self.goTargetTemplate:GameObjectSpawn(self.transTargetContent.transform)
      goItem.name = string.format(ChildTargetCompNamePrefix, itemId)
      local comp = self.transTargetContent:AddComponent(target_script_path, goItem.name)
      self.TargetComps[itemId] = comp
      comp:ReInit(targetData)
      goItem:SetActive(true)
    end
  end
end

function UILWSeasonTetrisGridMapComp:SetBlock(index, blockState, isShadow, onComplete)
  if index == nil then
    return nil
  end
  local oldReq
  if isShadow then
    oldReq = self.ShadowReq[index.x][index.y]
  else
    oldReq = self.BlockReq[index.x][index.y]
  end
  if oldReq ~= nil then
    if IsNotNull(oldReq.gameObject) then
      self.transContent:RemoveComponent(oldReq.gameObject.name, block_script_path)
    end
    oldReq:Destroy()
    oldReq = nil
  end
  local req = self:GameObjectInstantiateAsync(block_prefab_path, function(req)
    local go = req.gameObject
    local transform = go.transform
    local transRoot = self.transContent.transform
    transform:SetParent(transRoot)
    local scale = DataCenter.SeasonTetrisManager.BlockScale
    local size = DataCenter.SeasonTetrisManager.BlockSizeLarge
    transform:Set_localScale(scale, scale, 1)
    transform:Set_localPosition((index.x + 0.5) * size, (index.y + 0.5) * size, 0)
    if isShadow then
      go.name = string.format(ChildShadowNamePrefix, index.x, index.y, NameCount)
      NameCount = NameCount + 1
    else
      go.name = string.format(ChildBlockNamePrefix, index.x, index.y, NameCount)
      NameCount = NameCount + 1
    end
    local comp = self.transContent:AddComponent(block_script_path, go.name)
    local blockData = {}
    blockData.BlockState = blockState
    blockData.IsShadow = isShadow
    comp:ReInit(blockData)
    go:SetActive(true)
    if onComplete ~= nil then
      onComplete()
    end
  end)
  return req
end

function UILWSeasonTetrisGridMapComp:ShowShadows(piece)
  local lowerLeftIndex = self:GetPieceLeftIndex(piece)
  if lowerLeftIndex == nil then
    return
  end
  local x = DataCenter.SeasonTetrisManager.PieceX
  local y = DataCenter.SeasonTetrisManager.PieceY
  for i = 0, x - 1 do
    for j = 0, y - 1 do
      if piece.PieceData.Map[i][j] ~= 0 then
        local index = lowerLeftIndex + Vector2.New(i, j)
        if self:IsLocInMap(index.x, index.y) then
          local shadowReq = self:SetBlock(index, -1, true)
          self.ShadowReq[index.x][index.y] = shadowReq
        end
      end
    end
  end
  local map = self.GameData.GameMap
  local toDeleteRow = {}
  local toDeleteColumn = {}
  for i = 0, self.GameData.MapX - 1 do
    local isFull = true
    for j = 0, self.GameData.MapY - 1 do
      if map[i][j] == 0 and self.ShadowReq[i][j] == nil then
        isFull = false
        break
      end
    end
    if isFull then
      table.insert(toDeleteColumn, i)
    end
  end
  for j = 0, self.GameData.MapY - 1 do
    local isFull = true
    for i = 0, self.GameData.MapX - 1 do
      if map[i][j] == 0 and self.ShadowReq[i][j] == nil then
        isFull = false
        break
      end
    end
    if isFull then
      table.insert(toDeleteRow, j)
    end
  end
  
  local function getAreaList(arr)
    local ret = {}
    if not table.IsNullOrEmpty(arr) then
      local startY = arr[1]
      local lastY = arr[1]
      for i = 2, #arr do
        if startY == -1 then
          startY = arr[i]
          lastY = arr[i]
        elseif arr[i] == lastY + 1 then
          lastY = arr[i]
        else
          table.insert(ret, {from = startY, to = lastY})
          startY = arr[i]
          lastY = arr[i]
        end
      end
      if startY ~= -1 and lastY ~= -1 then
        table.insert(ret, {from = startY, to = lastY})
      end
    end
    return ret
  end
  
  if 0 < #toDeleteRow then
    local rowList = getAreaList(toDeleteRow)
    for _, row in ipairs(rowList) do
      self:CreateDeleteVfx(self.goVfxRow, 0, row.from, self.GameData.MapX, row.to - row.from + 1)
    end
  end
  if 0 < #toDeleteColumn then
    local columnList = getAreaList(toDeleteColumn)
    for _, column in ipairs(columnList) do
      self:CreateDeleteVfx(self.goVfxColumn, column.from, 0, column.to - column.from + 1, self.GameData.MapY)
    end
  end
end

function UILWSeasonTetrisGridMapComp:CreateDeleteVfx(go, x, y, width, height)
  local goVfx = self.goVfxRow:GameObjectSpawn(go.transform.parent)
  goVfx.name = string.format(ChildDeleteVfxNamePrefix, go.name, x, y, width, height)
  goVfx:SetActive(true)
  local size = DataCenter.SeasonTetrisManager.BlockSizeLarge
  goVfx.transform.localPosition = Vector3.New(size * x, size * y, 0)
  local rectTransform = goVfx.transform:GetComponent(typeof(CS.UnityEngine.RectTransform))
  if IsNotNull(rectTransform) then
    rectTransform.sizeDelta = Vector2.New(size * width, size * height)
  end
end

function UILWSeasonTetrisGridMapComp:ClearShadows()
  local x = DataCenter.SeasonTetrisManager.MapX
  local y = DataCenter.SeasonTetrisManager.MapY
  for i = 0, x - 1 do
    for j = 0, y - 1 do
      if self.ShadowReq[i][j] ~= nil then
        if IsNotNull(self.ShadowReq[i][j].gameObject) then
          self.transContent:RemoveComponent(self.ShadowReq[i][j].gameObject.name, block_script_path)
        end
        self.ShadowReq[i][j]:Destroy()
        self.ShadowReq[i][j] = nil
      end
    end
  end
  self.goVfxRow:GameObjectRecycleAll()
  self.goVfxColumn:GameObjectRecycleAll()
end

function UILWSeasonTetrisGridMapComp:CanPlace(piece)
  local lowerLeftIndex = self:GetPieceLeftIndex(piece)
  if lowerLeftIndex == nil then
    return false
  end
  if GMUtils.GetBool(GMConst.TetrisDisablePlaceCheck) then
    return true
  end
  return self:CanPlaceAtLoc(piece.PieceData.Map, lowerLeftIndex.x, lowerLeftIndex.y)
end

function UILWSeasonTetrisGridMapComp:CanPlaceAtLoc(pieceMap, mapX, mapY)
  for pieceX = 0, self.GameData.PieceX - 1 do
    for pieceY = 0, self.GameData.PieceY - 1 do
      if pieceMap[pieceX][pieceY] ~= nil and pieceMap[pieceX][pieceY] ~= 0 then
        local newX = mapX + pieceX
        local newY = mapY + pieceY
        if not self:IsLocInMap(newX, newY) then
          return false
        end
        if self.GameData.GameMap[newX][newY] ~= 0 then
          return false
        end
      end
    end
  end
  return true
end

function UILWSeasonTetrisGridMapComp:PlacePiece(piece)
  if piece == nil then
    return
  end
  if not self:CanPlace(piece) then
    return
  end
  self:ClearShadows()
  local lowerLeftIndex = self:GetPieceLeftIndex(piece)
  if lowerLeftIndex == nil then
    return
  end
  local toAddBlockCount = piece.PieceData.BlockCount
  local addedBlockCount = 0
  for i = 0, DataCenter.SeasonTetrisManager.PieceX - 1 do
    for j = 0, DataCenter.SeasonTetrisManager.PieceY - 1 do
      if piece.PieceData.Map[i][j] ~= 0 then
        local newX = lowerLeftIndex.x + i
        local newY = lowerLeftIndex.y + j
        if self:IsLocInMap(newX, newY) then
          self.GameData.GameMap[newX][newY] = piece.PieceData.Map[i][j]
          local newReq = self:SetBlock(Vector2.New(newX, newY), piece.PieceData.Map[i][j], false, function()
            addedBlockCount = addedBlockCount + 1
            if addedBlockCount == toAddBlockCount then
              self:OnPieceAdded(piece, lowerLeftIndex.x, lowerLeftIndex.y)
            end
          end)
          self.BlockReq[newX][newY] = newReq
        else
          addedBlockCount = addedBlockCount + 1
          if addedBlockCount == toAddBlockCount then
            self:OnPieceAdded(piece, lowerLeftIndex.x, lowerLeftIndex.y)
          end
        end
      end
    end
  end
end

function UILWSeasonTetrisGridMapComp:OnPieceAdded(piece, x, y)
  local toDeleteRow = {}
  local toDeleteColumn = {}
  local map = self.GameData.GameMap
  for i = 0, self.GameData.MapX - 1 do
    local isFull = true
    for j = 0, self.GameData.MapY - 1 do
      if map[i][j] == 0 then
        isFull = false
        break
      end
    end
    if isFull then
      table.insert(toDeleteColumn, i)
    end
  end
  for j = 0, self.GameData.MapY - 1 do
    local isFull = true
    for i = 0, self.GameData.MapX - 1 do
      if map[i][j] == 0 then
        isFull = false
        break
      end
    end
    if isFull then
      table.insert(toDeleteRow, j)
    end
  end
  if 0 < #toDeleteRow + #toDeleteColumn then
    DataCenter.LWSoundManager:PlaySound(1000013, false)
  end
  local toBeDelete = {}
  local gainTargetCount = 0
  local rowIndex = 0
  local columnIndex = 0
  for j = #toDeleteRow, 1, -1 do
    local row = toDeleteRow[j]
    for i = 0, self.GameData.MapX - 1 do
      local req = self.BlockReq[i][row]
      if req ~= nil then
        local go = self.BlockReq[i][row].gameObject
        if IsNotNull(go) then
          local cp = self.transContent:GetComponent(go.name, block_script_path)
          if cp ~= nil and self.GameData.GameMap[i][row] ~= -1 then
            gainTargetCount = gainTargetCount + 1
          end
          local animDelay = rowIndex * self.DisappearDelayBetweenLine + i * self.DisappearDelayBetweenBlock
          table.insert(toBeDelete, {
            x = i,
            y = row,
            comp = cp,
            blockState = self.GameData.GameMap[i][row],
            req = self.BlockReq[i][row],
            delay = animDelay
          })
        end
      end
    end
    rowIndex = rowIndex + 1
  end
  for i = 1, #toDeleteColumn do
    local column = toDeleteColumn[i]
    for j = 0, self.GameData.MapY - 1 do
      if not table.hasvalue(toDeleteRow, j) then
        local req = self.BlockReq[column][j]
        if req ~= nil then
          local go = self.BlockReq[column][j].gameObject
          if IsNotNull(go) then
            local cp = self.transContent:GetComponent(go.name, block_script_path)
            if cp ~= nil and self.GameData.GameMap[column][j] ~= -1 then
              gainTargetCount = gainTargetCount + 1
            end
            local animDelay = columnIndex * self.DisappearDelayBetweenLine + j * self.DisappearDelayBetweenBlock
            table.insert(toBeDelete, {
              x = column,
              y = j,
              comp = cp,
              blockState = self.GameData.GameMap[column][j],
              req = self.BlockReq[column][j],
              delay = animDelay
            })
          end
        end
      end
    end
    columnIndex = columnIndex + 1
  end
  self:TryCreatePraiseVfx(piece, #toDeleteRow + #toDeleteColumn, gainTargetCount, self.GameData:IsEmpty(), x, y)
  for _, deleteItem in pairs(toBeDelete) do
    if deleteItem.req ~= nil then
      self.GameData.GameMap[deleteItem.x][deleteItem.y] = 0
    end
    local targetComp = self.TargetComps[deleteItem.blockState]
    if targetComp ~= nil then
      targetComp:IncLogic()
    end
  end
  self.compPiecePosContent:DestroyPiece(piece.Pos)
  self.GameData:RemovePiece(piece)
  if not GMUtils.GetBool(GMConst.TetrisDisableSendPut, false) then
    DataCenter.SeasonTetrisManager:SendPut(piece.PieceData.PieceInfo.id, x, y)
  end
  self.HasWinOrFail = self:CheckGameState(false)
  if self.HasWinOrFail then
    self.view:HideTime()
    Logger.Log("\227\128\144\228\191\132\231\189\151\230\150\175\230\150\185\229\157\151\227\128\145\230\184\184\230\136\143\232\131\156\229\136\169\230\136\150\229\164\177\232\180\165\239\188\140\233\152\187\231\162\141\230\147\141\228\189\156\239\188\140\231\173\137\229\190\133\229\138\168\231\148\187\231\187\147\230\157\159\229\144\142\231\187\147\231\174\151")
  end
  self.GameData:PrintMap()
  if #toBeDelete == 0 then
    self:CheckGameState(true)
  else
    self:ClearAutoCheckTimer()
    local toAnimCount = #toBeDelete
    for _, deleteItem in pairs(toBeDelete) do
      if deleteItem.blockState ~= -1 then
        local targetComp = self.TargetComps[deleteItem.blockState]
        if targetComp ~= nil and not targetComp:HasFinish() then
          toAnimCount = toAnimCount + 1
        end
      end
    end
    local animDoneCount = 0
    local hasSound = false
    for _, deleteItem in pairs(toBeDelete) do
      deleteItem.comp:PlayAnim(deleteItem.delay, function()
        if deleteItem.req ~= nil then
          if IsNotNull(deleteItem.req.gameObject) then
            self.transContent:RemoveComponent(deleteItem.req.gameObject.name, block_script_path)
          end
          deleteItem.req:Destroy()
          deleteItem.req = nil
        end
        animDoneCount = animDoneCount + 1
        if animDoneCount >= toAnimCount then
          self:CheckGameState(true)
        end
      end)
      if deleteItem.blockState ~= -1 then
        local targetComp = self.TargetComps[deleteItem.blockState]
        if targetComp ~= nil then
          if not targetComp:HasFinish() then
            if not hasSound then
              hasSound = true
              local flySoundTimer = TimerManager:GetInstance():DelayInvoke(function()
                DataCenter.LWSoundManager:PlaySound(1000022, false)
              end, 1.35)
              table.insert(self.FlyTimer, flySoundTimer)
            end
            local timer = TimerManager:GetInstance():DelayInvoke(function()
              local sPath = targetComp:GetImagePath()
              Logger.Log("\227\128\144\228\191\132\231\189\151\230\150\175\230\150\185\229\157\151\227\128\145\233\129\147\229\133\183\233\163\158\233\129\147\229\133\183\239\188\140delay: " .. deleteItem.delay)
              UIUtil.DoFlyCustom(sPath, nil, 1, deleteItem.comp.transform.position, targetComp.transform.position, 80, 80, function()
                DataCenter.LWSoundManager:PlaySound(1000023, false)
                targetComp:Inc()
                animDoneCount = animDoneCount + 1
                if animDoneCount >= toAnimCount then
                  self:CheckGameState(true)
                end
              end)
            end, deleteItem.delay * 2)
            table.insert(self.FlyTimer, timer)
          else
            targetComp:Inc()
          end
        end
      end
    end
  end
end

function UILWSeasonTetrisGridMapComp:GetPriseLevel(piece, deleteLineCount, gainTargetCount, isMapEmpty, x, y)
  if isMapEmpty or 10 <= gainTargetCount then
    return self.PriseLevel.Perfect
  end
  if 3 <= deleteLineCount and 4 <= gainTargetCount or 6 <= gainTargetCount then
    return self.PriseLevel.Amazing
  end
  if 1 <= deleteLineCount and 3 <= gainTargetCount then
    return self.PriseLevel.Good
  end
  if 3 <= piece.PieceData.BlockCount then
  end
  local perimeter = 0
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
  for i = 0, self.GameData.PieceX - 1 do
    for j = 0, self.GameData.PieceY - 1 do
      if piece.PieceData.Map[i][j] ~= 0 then
        for k = 1, 4 do
          local neighborX = i + dx[k]
          local neighborY = j + dy[k]
          if neighborX < 0 or neighborX >= self.GameData.PieceX or neighborY < 0 or neighborY >= self.GameData.PieceY or piece.PieceData.Map[neighborX][neighborY] == nil or piece.PieceData.Map[neighborX][neighborY] == 0 then
            local realX = x + neighborX
            local realY = y + neighborY
            if realX < 0 or realX >= self.GameData.MapX or realY < 0 or realY >= self.GameData.MapY or self.GameData.GameMap[realX][realY] ~= 0 then
              perimeter = perimeter + 1
            end
          end
        end
      end
    end
  end
  Logger.Log("\227\128\144\228\191\132\231\189\151\230\150\175\230\150\185\229\157\151\227\128\145\230\150\185\229\157\151\229\145\168\233\149\191\239\188\154" .. piece.PieceData.Perimeter .. ", \232\162\171\229\140\133\229\155\180\231\154\132\232\190\185\233\149\191\239\188\154" .. perimeter)
  if perimeter >= piece.PieceData.Perimeter * 0.75 then
    return self.PriseLevel.Great
  end
  return self.PriseLevel.None
end

function UILWSeasonTetrisGridMapComp:TryCreatePraiseVfx(piece, deleteLineCount, gainTargetCount, isMapEmpty, x, y)
  local level = self:GetPriseLevel(piece, deleteLineCount, gainTargetCount, isMapEmpty, x, y)
  if level == self.PriseLevel.Great then
    local pieceX = self.GameData.PieceX
    local pieceY = self.GameData.PieceY
    for i = 0, pieceX - 1 do
      for j = 0, pieceY - 1 do
        if piece.PieceData.Map[i][j] ~= 0 then
          local mapX = x + i
          local mapY = y + j
          self:CreatePraiseVfx(level, mapX, mapY)
        end
      end
    end
  elseif level == self.PriseLevel.Perfect then
    local centerX = self.MapX / 2.0
    local centerY = self.MapY / 2.0
    self:CreatePraiseVfx(level, centerX, centerY)
  else
    local centerX = self.MapX / 2.0
    local centerY = y + piece.PieceData.CenterY
    if level == self.PriseLevel.Good then
      self:CreatePraiseVfx(level, centerX, centerY)
    elseif level == self.PriseLevel.Amazing then
      self:CreatePraiseVfx(level, centerX, centerY)
    end
  end
  local soundId = self.PriseSound[level]
  if soundId ~= nil then
    DataCenter.LWSoundManager:PlaySound(soundId, false)
  end
end

function UILWSeasonTetrisGridMapComp:CreatePraiseVfx(level, x, y)
  level = Mathf.Clamp(level, 1, 4)
  self:TryShock(level)
  local vfxPath = self.PriseVfxPath[level]
  if vfxPath ~= nil then
    local req = self:GameObjectInstantiateAsync(vfxPath, function(req)
      local go = req.gameObject
      local transform = go.transform
      local transRoot = self.transPraiseVfxRoot
      local size = DataCenter.SeasonTetrisManager.BlockSizeLarge
      local pos = Vector3.New((x + 0.5) * size, (y + 0.5) * size, 0)
      transform:SetParent(transRoot.transform)
      transform:Set_localPosition(pos.x, pos.y, 0)
      go.name = string.format(ChildPriseVfxNamePrefix, level, x, y)
      go:SetActive(true)
    end)
    local praiseReqData = {}
    praiseReqData.req = req
    praiseReqData.level = level
    praiseReqData.time = UITimeManager:GetInstance():GetServerTime()
    table.insert(self.PriseVfxReq, praiseReqData)
  end
end

function UILWSeasonTetrisGridMapComp:TryShock(level)
  if checknumber(level) < self.ShockLevel then
    return
  end
  if CSVibrator and CSVibrator.HapticsSupported() then
    if CS.SDKManager.IS_UNITY_ANDROID() then
      CSVibrator.Warning()
    elseif CS.SDKManager.IS_UNITY_IOS() then
      CSVibrator.Failure()
    end
  end
end

function UILWSeasonTetrisGridMapComp:Update100MS()
  self:ClearPriseVfx(false)
  if self.GameData == nil then
    return
  end
  local resultClient = self.HasWinOrFail
  if resultClient then
    local seasonType = SeasonUtil.GetSeasonType(true, true)
    if seasonType ~= SeasonMapType.NineNation then
      return
    end
    self.PieceEmptyTime = -1
    local resultServer = self.GameData:IsWinOrFail()
    if resultServer then
      self.WaitResultTime = -1
      return
    end
    if self.WaitResultTime == -1 then
      self.WaitResultTime = UITimeManager:GetInstance():GetServerTime()
    end
    local pastTime = UITimeManager:GetInstance():GetServerTime() - self.WaitResultTime
    if 5000 < pastTime then
      self.WaitResultTime = -1
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWSeasonTetrisGame) then
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonTetrisGame)
      end
      EventManager:GetInstance():Broadcast(EventId.UILWSingleActivityContainerClose)
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSingleActivityContainer)
      return
    end
  else
    self.WaitResultTime = -1
    if not self.GameData:IsPieceEmpty() then
      self.PieceEmptyTime = -1
      return
    end
    if self.PieceEmptyTime == -1 then
      self.PieceEmptyTime = UITimeManager:GetInstance():GetServerTime()
    end
    local pastTime = UITimeManager:GetInstance():GetServerTime() - self.PieceEmptyTime
    if 2500 < pastTime then
      self.PieceEmptyTime = -1
      self:TrySendGetInfo()
    end
  end
end

function UILWSeasonTetrisGridMapComp:TrySendGetInfo()
  DataCenter.SeasonTetrisManager:SendGetInfo()
end

function UILWSeasonTetrisGridMapComp:ClearAutoCheckTimer()
  self.AutoCheckTime = 0
end

function UILWSeasonTetrisGridMapComp:Update1000MS()
  self.AutoCheckTime = self.AutoCheckTime + 1
  if self.AutoCheckCd > 0 and self.AutoCheckTime >= self.AutoCheckCd then
    self.AutoCheckTime = 0
    self:CheckGameState(true)
  end
  if self.CanGuide then
    self.GuideTime = self.GuideTime + 1
    if self.GuideTime >= self.GuideCd then
      self.GuideTime = 0
      self:PlayGuide()
    end
  end
end

function UILWSeasonTetrisGridMapComp:IsLocInMap(x, y)
  local maxX = DataCenter.SeasonTetrisManager.MapX
  local maxY = DataCenter.SeasonTetrisManager.MapY
  return 0 <= x and x < maxX and 0 <= y and y < maxY
end

function UILWSeasonTetrisGridMapComp:PosToIndex(x, y, offset)
  local size = DataCenter.SeasonTetrisManager.BlockSizeLarge
  local iX, iY = math.floor(x / size + offset.x), math.floor(y / size + offset.y)
  if self:IsLocInMap(iX, iY) then
    return Vector2.New(iX, iY)
  end
  return nil
end

function UILWSeasonTetrisGridMapComp:GetPieceLeftIndex(piece)
  if piece == nil then
    return nil
  end
  local lowerLeftPos = self.transContent.transform:InverseTransformPoint(piece.transform.position)
  if lowerLeftPos == nil then
    return nil
  end
  return self:PosToIndex(lowerLeftPos.x, lowerLeftPos.y, piece.PieceData.Offset)
end

function UILWSeasonTetrisGridMapComp:HasAnyPosToPlace()
  if self.GameData == nil then
    return false
  end
  if table.IsNullOrEmpty(self.GameData.PieceList) then
    return true
  end
  for mapX = 0, self.GameData.MapX - 1 do
    for mapY = 0, self.GameData.MapY - 1 do
      for _, pieceData in pairs(self.GameData.PieceList) do
        if self:CanPlaceAtLoc(pieceData.Map, mapX, mapY) then
          return true
        end
      end
    end
  end
  return false
end

function UILWSeasonTetrisGridMapComp:HasWin()
  if not table.IsNullOrEmpty(self.TargetComps) then
    for _, comp in pairs(self.TargetComps) do
      if not comp:HasFinishLogic() then
        return false
      end
    end
  end
  return true
end

function UILWSeasonTetrisGridMapComp:CheckGameState(popup)
  if not self:HasAnyPosToPlace() then
    if popup then
      self.AutoCheckCd = -1
      self.GameData.IsFail = 1
      DataCenter.SeasonTetrisManager:OpenFail()
    end
    self:SetCanGuide(false)
    return true
  end
  if self:HasWin() or self.WinData ~= nil then
    if self.WinData ~= nil and popup then
      self.AutoCheckCd = -1
      DataCenter.SeasonTetrisManager:OpenSuccess(self.WinData)
    end
    self:SetCanGuide(false)
    return true
  end
  return false
end

function UILWSeasonTetrisGridMapComp:OnGameSuccessEvt(evt)
  self.WinData = evt
end

function UILWSeasonTetrisGridMapComp:OnPieceUpdate(evt)
  self:CheckGameState(true)
end

function UILWSeasonTetrisGridMapComp:PlayGuide()
  self:ClearGuide()
  if not self.CanGuide or self.GameData == nil or self.GameData.PutTimes > 0 then
    return
  end
  local transFrom = self.compPiecePosContent:GetFirstPieceTrans()
  if transFrom == nil then
    return
  end
  self:SetCanGuide(false)
  self.switchFingerHandle = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/Guide/UIArrowFinger_hold.prefab", function(handle)
    if handle.isError then
      return
    end
    CommonUtil.CallAutoArabicMirrorManually(handle)
    local gameObject = handle.gameObject
    local transform = gameObject.transform
    transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.Guide.Name).transform, false)
    transform.position = transFrom.position
    transform.localScale = Vector3.one
    local img = transform:GetComponentInChildren(typeof(CS.UnityEngine.UI.Image))
    self.switchGuideTween = DOTween.Sequence()
    if not IsNull(img) then
      self.switchGuideTween:Append(img:DOFade(0, 0))
      self.switchGuideTween:Append(img:DOFade(1, 0.5))
    end
    self.switchGuideTween:Append(transform:DOMove(self.p_finger_end.transform.position, 0.5))
    if not IsNull(img) then
      self.switchGuideTween:Append(img:DOFade(0, 0.5))
    end
    self.switchGuideTween:SetLoops(2)
    self.switchGuideTween:OnComplete(function()
      self:SetCanGuide(true)
      if not IsNull(self.switchFingerHandle) then
        self.switchFingerHandle:Destroy()
        self.switchFingerHandle = nil
      end
    end)
  end)
end

function UILWSeasonTetrisGridMapComp:ClearGuide()
  if self.switchGuideTween then
    self.switchGuideTween:Kill()
    self.switchGuideTween = nil
  end
  if not IsNull(self.switchFingerHandle) then
    self.switchFingerHandle:Destroy()
    self.switchFingerHandle = nil
  end
end

function UILWSeasonTetrisGridMapComp:SetCanGuide(canGuide)
  self.GuideTime = 0
  self.CanGuide = canGuide
  if not canGuide then
    self:ClearGuide()
  end
end

return UILWSeasonTetrisGridMapComp
