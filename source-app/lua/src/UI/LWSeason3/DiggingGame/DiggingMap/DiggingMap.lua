local base = UIBaseContainer
local DiggingMap = BaseClass("DiggingMap", base)
local DiggingMapBrick = require("UI.LWSeason3.DiggingGame.DiggingMap.Component.DiggingMapBrick")
local DiggingMapBlock = require("UI.LWSeason3.DiggingGame.DiggingMap.Component.DiggingMapBlock")
local UICommonHead = _ENV.UICommonHead
local ContentBrick_path = "Content/ContentBrick"
local DiggingMapBrick_path = "Content/ContentBrick/DiggingMapBrick"
local ContentBg_path = "Content/ContentBg"
local BgItem_path = "Content/ContentBg/bgItem"
local ContentItem_path = "Content/ContentItem"
local DiggingMapBlock_path = "Content/ContentItem/DiggingMapBlock"
local ContentHead_path = "Content/ContentHead"
local PlayerHead_path = "Content/ContentHead/Head"
local Content_path = "Content"
local Check_path = "Check"
local BtnOk_path = "Check/BtnOk"
local BtnCancel_path = "Check/BtnCancel"
local CheckBg_path = "CheckBg"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
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
  self.ContentHead = self:AddComponent(UIBaseContainer, ContentHead_path)
  self.PlayerHead = self:AddComponent(UIBaseContainer, PlayerHead_path)
  self.Content = self:AddComponent(UIBaseContainer, Content_path)
  self.Check = self:AddComponent(UIBaseContainer, Check_path)
  self.BtnOk = self:AddComponent(UIButton, BtnOk_path)
  self.BtnCancel = self:AddComponent(UIButton, BtnCancel_path)
  self.CheckBg = self:AddComponent(UIButton, CheckBg_path)
  self:CancelDig()
  self.BtnCancel:SetOnClick(BindCallback(self, self.CancelDig))
  self.CheckBg:SetOnClick(BindCallback(self, self.CancelDig))
  self.BtnOk:SetOnClick(BindCallback(self, self.OkDig))
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
  self.HeadObj = self.PlayerHead.gameObject
  self.HeadObj:GameObjectCreatePool()
  self.HeadObj:SetActive(false)
end

local function ComponentDestroy(self)
  self.ContentBg:RemoveComponents(DiggingMapBrick)
  self.BgObj:GameObjectRecycleAll()
  self.ContentBrick:RemoveComponents(DiggingMapBrick)
  self.BrickObj:GameObjectRecycleAll()
  self.ContentItem:RemoveComponents(DiggingMapBlock)
  self.ItemObj:GameObjectRecycleAll()
  self:HideHead()
  self.ContentBrick = nil
  self.DiggingMapBrick = nil
  self.ContentBg = nil
  self.BgItem = nil
  self.ContentItem = nil
  self.DiggingMapBlock = nil
  self.ContentHead = nil
  self.PlayerHead = nil
  self.Content = nil
  self.Check = nil
  self.BtnOk = nil
  self.BtnCancel = nil
  self.CheckBg = nil
end

local function DataDefine(self)
  self.showHead = false
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
  self:AddUIListener(EventId.DiggingGameMapData, self.OnRefresh)
  self:AddUIListener(EventId.DiggingGameOpen, self.OnOpen)
end

function DiggingMap:OnRemoveListener()
  self:RemoveUIListener(EventId.DiggingGameMapData, self.OnRefresh)
  self:RemoveUIListener(EventId.DiggingGameOpen, self.OnOpen)
  base.OnRemoveListener(self)
end

function DiggingMap:ShowOrHideHead(showHead)
  if self.showHead == showHead then
    return
  end
  self.showHead = showHead
  self:InitHead(self.mapData.brickDic)
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

function DiggingMap:CloseBrick(pos)
  if pos then
    local brickItem = self.brickItemDic[pos]
    if brickItem then
      brickItem:OnClose()
    end
  else
    for i, item in pairs(self.brickItemDic) do
      item:OnClose()
    end
  end
end

function DiggingMap:LockBrick(pos)
  if pos then
    local brickItem = self.brickItemDic[pos]
    if brickItem then
      brickItem:SetLock(true)
    end
  else
    for i, item in pairs(self.brickItemDic) do
      item:SetLock(true)
    end
  end
end

function DiggingMap:UnlockBrick(pos)
  if pos then
    local brickItem = self.brickItemDic[pos]
    if brickItem then
      brickItem:SetLock(false)
    end
  else
    for i, item in pairs(self.brickItemDic) do
      item:SetLock(false)
    end
  end
end

function DiggingMap:OnRefresh(mapData, hideBrick)
  if self.mapData and self.mapData.uuid ~= mapData.uuid then
    return
  end
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
      if self.mapData.type == SeasonDigGameType.Alliance then
        theItem:SetOnClick(self, self.OnClickBrick)
      end
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
  for i, blockInfo in ipairs(itemList) do
    self:UpdateBlock(blockInfo)
  end
end

function DiggingMap:InitHead(brickDic)
  self:HideHead()
  if not self.padding then
    return
  end
  if not brickDic or not self.showHead then
    return
  end
  local index = 0
  for pos, brick in pairs(brickDic) do
    self:UpdateHead(brick.playerInfo, pos)
  end
end

function DiggingMap:HideHead()
  self.ContentHead:RemoveComponents(UIBaseContainer)
  self.ContentHead:RemoveComponents(UICommonHead)
  self.HeadObj:GameObjectRecycleAll()
  self.headItemDic = {}
end

function DiggingMap:UpdateBlock(blockInfo, isDig)
  local pos = blockInfo.pos
  local theItem = self.blockItemDic[pos]
  if not theItem then
    local goItem = self.ItemObj:GameObjectSpawn(self.ContentItem.transform)
    goItem.name = string.format("DiggingMapBlock_%d", pos)
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

function DiggingMap:UpdateHead(playerInfo, pos)
  if not playerInfo then
    return
  end
  local theItem = self.headItemDic[pos]
  if not theItem then
    local goItem = self.HeadObj:GameObjectSpawn(self.ContentHead.transform)
    goItem.name = string.format("PlayerHead_%d", pos)
    goItem:SetActive(true)
    local headRoot = self.ContentHead:AddComponent(UIBaseContainer, goItem.name)
    theItem = headRoot:AddComponent(UICommonHead, string.format("%s", "UIPlayerHead"))
    theItem.headRoot = headRoot
    theItem:SetEnableClickShowInfo(true, true)
    self.headItemDic[pos] = theItem
  end
  theItem:SetHeadAndFrame(playerInfo.uid, playerInfo.pic, playerInfo.picVer, false, playerInfo.headSkinId)
  local x, y = DataCenter.DiggingDataManager:GetPosByIndex(pos, self.levelConfig.num_width)
  x = x * self.gridSize + self.padding.left
  y = y * self.gridSize + self.padding.top
  theItem.headRoot:SetAnchoredPositionXY(x, -y)
  local scale = self.gridSize / self.defaultHeadSize
  theItem.headRoot:SetLocalScaleXYZ(scale, scale, 1)
  theItem:SetActive(true)
end

function DiggingMap:OnOpen(openData)
  if not openData then
    return
  end
  if openData.uuid ~= self.mapData.uuid then
    return
  end
  self:OpenBrick(openData.pos)
  if self.showHead and openData.playerInfo then
    self:UpdateHead(openData.playerInfo, openData.pos)
  end
  if openData.blockInfo then
    self:UpdateBlock(openData.blockInfo, true)
  end
end

function DiggingMap:OnClickBrick(pos, position)
  if not (pos and position) or pos == self.selectPos then
    return
  end
  self.selectPos = pos
  self.Check:SetActive(false)
  self.Check:SetPositionXYZ(position.x, position.y, 0)
  self.Check:SetActive(true)
  self.CheckBg:SetActive(true)
  EventManager:GetInstance():Broadcast(EventId.DiggingShowOrHideCheck, true)
end

function DiggingMap:CancelDig()
  if not self.selectPos then
    return
  end
  EventManager:GetInstance():Broadcast(EventId.DiggingShowOrHideCheck, false)
  self.Check:SetActive(false)
  self.CheckBg:SetActive(false)
  self.selectPos = nil
end

function DiggingMap:OkDig()
  local brickItem = self.brickItemDic[self.selectPos]
  if brickItem then
    brickItem:OnClick(true)
  end
  self:CancelDig()
end

DiggingMap.OnCreate = OnCreate
DiggingMap.OnDestroy = OnDestroy
DiggingMap.OnEnable = OnEnable
DiggingMap.OnDisable = OnDisable
DiggingMap.ComponentDefine = ComponentDefine
DiggingMap.ComponentDestroy = ComponentDestroy
DiggingMap.DataDefine = DataDefine
DiggingMap.DataDestroy = DataDestroy
return DiggingMap
