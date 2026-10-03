local base = UIBaseContainer
local DiggingBlockInfo = BaseClass("DiggingBlockInfo", base)
local icon_path = "Icon"
local iconBtn_path = "Icon"
local Finished_path = "Finished"
local FinishedEffect_path = "FinishedEffect"
local ContentBrick_path = "ContentBrick"
local BrickItem_path = "ContentBrick/BrickItem"
local Symbol_path = "Symbol"

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
  self.icon = self:AddComponent(UIImage, icon_path)
  self.iconBtn = self:AddComponent(UIButton, iconBtn_path)
  self.Finished = self:AddComponent(UIBaseContainer, Finished_path)
  self.FinishedEffect = self:AddComponent(UIBaseContainer, FinishedEffect_path)
  self.ContentBrick = self:AddComponent(UIBaseContainer, ContentBrick_path)
  self.BrickItem = self:AddComponent(UIBaseContainer, BrickItem_path)
  self.Symbol = self:AddComponent(UIImage, Symbol_path)
  self.iconBtn:SetOnClick(BindCallback(self, self.OnClick))
  self.BrickGrid = self:AddComponent(UIGridLayoutGroup, ContentBrick_path)
  self.BrickObj = self.BrickItem.gameObject
  self.BrickObj:GameObjectCreatePool()
  self.FinishedEffect = self:AddComponent(UIVfx, FinishedEffect_path, VfxAssets.DiggingBlockFinished)
end

local function ComponentDestroy(self)
  self.BrickObj:GameObjectRecycleAll()
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
  self.icon = nil
  self.iconBtn = nil
  self.Finished = nil
  self.FinishedEffect = nil
  self.ContentBrick = nil
  self.BrickItem = nil
  self.Symbol = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function DiggingBlockInfo:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DiggingGetBlockAnim, self.OnGetBlockAnim)
end

function DiggingBlockInfo:OnRemoveListener()
  self:RemoveUIListener(EventId.DiggingGetBlockAnim, self.OnGetBlockAnim)
  base.OnRemoveListener(self)
end

function DiggingBlockInfo:ReInit(index, blockId, blockInfo)
  self.index = index
  self.blockId = blockId
  self.blockInfo = blockInfo
  local hasGet = blockInfo and blockInfo.get
  local blockConfig = DataCenter.DiggingDataTemplateManager:GetConfigDataBlock(blockId)
  if not blockConfig then
    return
  end
  if hasGet then
    self.icon:LoadSprite(blockConfig.appearance_s)
  else
    self.icon:LoadSprite(blockConfig.appearance_shadow_s)
  end
  self.Finished:SetActive(hasGet)
  self:ShowBgGrid(blockConfig.size_width, blockConfig.size_height)
end

function DiggingBlockInfo:ShowBgGrid(width, height)
  self.BrickObj:GameObjectRecycleAll()
  local maxSize = math.max(width, height)
  local gridSize = 85 / maxSize
  if width <= 3 and height <= 2 then
    gridSize = math.max(35, gridSize)
  end
  self.BrickGrid:SetCellSize(gridSize, gridSize)
  self.BrickGrid:SetConstraintCount(width)
  local total = width * height
  for i = 2, total do
    self.BrickObj:GameObjectSpawn(self.ContentBrick.transform)
  end
end

function DiggingBlockInfo:SetMax(max)
  if not max then
    self.Symbol:SetActive(false)
    return
  end
  local sprite = self.index == max and "ljq_saijis3_yindiannaqiongsi_denghao" or "ljq_saijis3_yindiannaqiongsi_jiahao"
  self.Symbol:LoadSpriteAuto(string.format(LoadPath.UIDiggingGame, sprite))
  self.Symbol:SetActive(true)
end

function DiggingBlockInfo:OnClick()
  if self.blockInfo and self.blockInfo.get then
    return
  end
  UIUtil.ShowTipsId("season_activity_1000070_desc32")
end

function DiggingBlockInfo:OnGetBlockAnim(param)
  if not (param and param.blockInfo and param.blockInfo.get) or self.blockId ~= param.blockInfo.bid then
    return
  end
  local blockConfig = DataCenter.DiggingDataTemplateManager:GetConfigDataBlock(self.blockId)
  if not blockConfig then
    return
  end
  self.tweenSeq = DOTween.Sequence()
  self.tweenSeq:AppendInterval(1.5)
  if param.fly and param.fly.transform then
    param.fly:SetActive(false)
    self.tweenSeq:AppendCallback(function()
      param.fly:SetActive(true)
    end)
    self.tweenSeq:Append(param.fly.transform:DOMove(self.icon.transform.position, 0.8)):SetEase(CS.DG.Tweening.Ease.InOutCubic)
  end
  self.tweenSeq:AppendCallback(function()
    self.icon:LoadSprite(blockConfig.appearance_s)
    self.FinishedEffect:Replay()
    if param.fly then
      param.fly:SetActive(false)
    end
  end)
  self.tweenSeq:AppendInterval(0.1)
  self.tweenSeq:AppendCallback(function()
    self.Finished:SetActive(true)
  end)
end

DiggingBlockInfo.OnCreate = OnCreate
DiggingBlockInfo.OnDestroy = OnDestroy
DiggingBlockInfo.OnEnable = OnEnable
DiggingBlockInfo.OnDisable = OnDisable
DiggingBlockInfo.ComponentDefine = ComponentDefine
DiggingBlockInfo.ComponentDestroy = ComponentDestroy
DiggingBlockInfo.DataDefine = DataDefine
DiggingBlockInfo.DataDestroy = DataDestroy
return DiggingBlockInfo
