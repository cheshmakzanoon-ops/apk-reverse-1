local base = UIBaseContainer
local DiggingMap = BaseClass("DigMap", base)
local DiggingMapBrick, DiggingMapBlock
local ContentBrick_path = "Content/ContentBrick"
local DiggingMapBrick_path = "Content/ContentBrick/DiggingMapBrick"
local ContentBg_path = "Content/ContentBg"
local BgItem_path = "Content/ContentBg/bgItem"
local ContentItem_path = "Content/ContentItem"
local DiggingMapBlock_path = "Content/ContentItem/DiggingMapBlock"
local Content_path = "Content"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function InitBlockAndBrickScriptByType(self, scriptBrick, scriptBlock)
  if scriptBrick and scriptBlock then
    DiggingMapBrick = scriptBrick
    DiggingMapBlock = scriptBlock
  end
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.ContentBrick = self:AddComponent(UIBaseContainer, ContentBrick_path)
  self.DiggingMapBrick = self:AddComponent(UIBaseContainer, DiggingMapBrick_path)
  self.ContentBg = self:AddComponent(UIBaseContainer, ContentBg_path)
  self.BgItem = self:AddComponent(UIBaseContainer, BgItem_path)
  self.ContentItem = self:AddComponent(UIBaseContainer, ContentItem_path)
  self.DiggingMapBlock = self:AddComponent(UIBaseContainer, DiggingMapBlock_path)
  self.Content = self:AddComponent(UIBaseContainer, Content_path)
  self.BgGrid = self:AddComponent(UIGridLayoutGroup, ContentBg_path)
  self.BgObj = self.BgItem.gameObject
  self.BgObj:GameObjectCreatePool()
  self.BgObj:SetActive(false)
  self.BrickGrid = self:AddComponent(UIGridLayoutGroup, ContentBrick_path)
  self.BrickObj = self.DiggingMapBrick.gameObject
  self.BrickObj:GameObjectCreatePool()
  self.BrickObj:SetActive(false)
  self.ItemObj = self.DiggingMapBlock.gameObject
  self.ItemObj:GameObjectCreatePool()
  self.ItemObj:SetActive(false)
end

local function ComponentDestroy(self)
  self.ContentBg:RemoveComponents(DiggingMapBrick)
  self.BgObj:GameObjectRecycleAll()
  self.ContentBrick:RemoveComponents(DiggingMapBrick)
  self.BrickObj:GameObjectRecycleAll()
  self.ContentItem:RemoveComponents(DiggingMapBlock)
  self.ItemObj:GameObjectRecycleAll()
  self.ContentBrick = nil
  self.DiggingMapBrick = nil
  self.ContentBg = nil
  self.BgItem = nil
  self.ContentItem = nil
  self.DiggingMapBlock = nil
  self.Content = nil
end

local function DataDefine(self)
  self.hideBrick = false
  self.defaultBrickSize = 60
  self.defaultHeadSize = 216
  self.scale = 1
  self.brickItemDic = {}
  self.blockItemDic = {}
  self.headItemDic = {}
end

local function DataDestroy(self)
  self.brickItemDic = nil
  self.blockItemDic = nil
  self.headItemDic = nil
end

function DiggingMap:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DiggingGameOpen, self.OnOpen)
end

function DiggingMap:OnRemoveListener()
  self:RemoveUIListener(EventId.DiggingGameOpen, self.OnOpen)
  base.OnRemoveListener(self)
end

function DiggingMap:OpenBrick(pos)
  if pos then
    local brickItem = self.brickItemDic[pos]
    if brickItem then
      brickItem:OnOpen()
    end
  else
    for i, item in pairs(self.brickItemDic) do
      item:OnOpen()
    end
  end
end

function DiggingMap:HideAllBlock()
  for i, item in pairs(self.blockItemDic) do
    item:HideIcon()
  end
end

function DiggingMap:OnRefresh(mapData, hideBrick)
  self.mapData = mapData
  self.hideBrick = hideBrick
  local levelConfig = DataCenter.DiggingDataTemplateManager:GetConfigData(mapData.mapConfigId)
  if not levelConfig then
    return
  end
  self.levelConfig = levelConfig
  self:InitGridSize(self.levelConfig.num_width, self.levelConfig.num_height)
  self:InitBrick(mapData.mapConfigId, mapData.brickDic)
  self:InitBlock(mapData.mapConfigId, mapData.blockInfo)
end

function DiggingMap:InitGridSize(num_width, num_height)
  local rectSize = self:GetSizeDelta()
  self.padding = self.BrickGrid:GetCellPadding()
  local maxWidth = rectSize.x - self.padding.left - self.padding.right
  local maxHeight = rectSize.y - self.padding.top - self.padding.bottom
  self.gridSize = math.min(maxWidth / num_width, maxHeight / num_height)
  self.scale = self.gridSize / self.defaultBrickSize
  local realWidth = self.gridSize * num_width
  self.Content:SetLocalPositionXYZ((rectSize.x - realWidth) / 2, 0, 0)
  self.BrickGrid:SetConstraintCount(num_width)
  self.BrickGrid:SetCellSize(self.gridSize, self.gridSize)
  self.BgGrid:SetConstraintCount(num_width)
  self.BgGrid:SetCellSize(self.gridSize, self.gridSize)
end

function DiggingMap:InitBrick(mapConfigId, brickDic)
  local num_width = self.levelConfig.num_width
  local num_height = self.levelConfig.num_height
  self.BgObj:GameObjectRecycleAll()
  local index, goItem, theItem = 0
  for i = 1, num_width do
    for j = 1, num_height do
      index = index + 1
      goItem = self.BgObj:GameObjectSpawn(self.ContentBg.transform)
      goItem.name = string.format("DiggingMapBrickBg_%d", index)
      goItem:SetActive(true)
    end
  end
  self.ContentBrick:RemoveComponents(DiggingMapBrick)
  self.BrickObj:GameObjectRecycleAll()
  self.brickItemDic = {}
  if not brickDic or self.hideBrick then
    return
  end
  index, goItem, theItem = 0
  local parent = self.ContentBrick.transform
  for i = 1, num_width do
    for j = 1, num_height do
      index = index + 1
      goItem = self.BrickObj:GameObjectSpawn(parent)
      goItem.name = string.format("DiggingMapBrick_%d", index)
      theItem = self.ContentBrick:AddComponent(DiggingMapBrick, goItem.name)
      theItem:ReInit(index, self.mapData, brickDic[index], self.scale)
      goItem:SetActive(true)
      self.brickItemDic[index] = theItem
    end
  end
end

function DiggingMap:InitBlock(mapConfigId, itemList)
  self.ContentItem:RemoveComponents(DiggingMapBlock)
  self.ItemObj:GameObjectRecycleAll()
  self.blockItemDic = {}
  if not itemList then
    return
  end
  TimerManager:GetInstance():DelayInvoke(function()
    if not itemList or not self.blockItemDic then
      return
    end
    for i, blockInfo in ipairs(itemList) do
      self:UpdateBlock(blockInfo)
    end
  end, 0.25)
end

function DiggingMap:UpdateBlock(blockInfo, isDig)
  local pos = blockInfo.pos
  local theItem = self.blockItemDic[pos]
  if not theItem then
    local goItem = self.ItemObj:GameObjectSpawn(self.ContentItem.transform)
    goItem.name = string.format("DiggingMapBlock_%d_%d", pos, blockInfo.bid)
    goItem:SetActive(true)
    theItem = self.ContentItem:AddComponent(DiggingMapBlock, goItem.name)
    local x, y = DataCenter.DiggingDataManager:GetPosByIndex(pos, self.levelConfig.num_width)
    x = x * self.gridSize + self.padding.left
    y = y * self.gridSize + self.padding.top
    theItem:ReInit(blockInfo, x, -y, self.gridSize, self.scale)
    self.blockItemDic[pos] = theItem
  end
  if isDig then
    theItem:OnOpen(blockInfo)
  end
end

function DiggingMap:OnOpen(openData)
  if not openData then
    return
  end
  if openData.uuid ~= self.mapData.uuid then
    return
  end
  self:OpenBrick(openData.pos)
  if openData.openBlockInfo then
    self:UpdateBlock(openData.openBlockInfo, true)
  end
end

DiggingMap.OnCreate = OnCreate
DiggingMap.OnDestroy = OnDestroy
DiggingMap.OnEnable = OnEnable
DiggingMap.OnDisable = OnDisable
DiggingMap.ComponentDefine = ComponentDefine
DiggingMap.ComponentDestroy = ComponentDestroy
DiggingMap.DataDefine = DataDefine
DiggingMap.DataDestroy = DataDestroy
DiggingMap.InitBlockAndBrickScriptByType = InitBlockAndBrickScriptByType
return DiggingMap
