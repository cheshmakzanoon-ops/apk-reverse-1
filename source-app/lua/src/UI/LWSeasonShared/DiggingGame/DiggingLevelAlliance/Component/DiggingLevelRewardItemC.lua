local base = UIBaseContainer
local DiggingLevelRewardItem = BaseClass("DiggingLevelRewardItem", base)
local UICommonResItem = require("UI.UICommonResItem.UICommonResItemGetReward")
local UICommonHead = _ENV.UICommonHead
local Icon_path = "Root/Icon"
local Content1_path = "Root/ScrollView1/Viewport/Content1"
local UICommonResItem_path = "Root/UICommonResItemGetReward"
local ScrollView2_path = "Root/ScrollView2"
local Content2_path = "Root/ScrollView2/Viewport/Content2"
local Head_path = "Root/ScrollView2/Viewport/Content2/Head"
local ContentBrick_path = "Root/ContentBrick"
local BrickItem_path = "Root/BrickItem"
local EffectRed_path = "Root/EffectRed"
local BtnClick_path = "Root/Click"

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
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.Icon = self:AddComponent(UIRawImage, Icon_path)
  self.Content1 = self:AddComponent(UIBaseContainer, Content1_path)
  self.UICommonResItem = self:AddComponent(UIBaseContainer, UICommonResItem_path)
  self.ScrollView2 = self:AddComponent(UIBaseContainer, ScrollView2_path)
  self.Content2 = self:AddComponent(UIBaseContainer, Content2_path)
  self.Head = self:AddComponent(UIBaseContainer, Head_path)
  self.ContentBrick = self:AddComponent(UIBaseContainer, ContentBrick_path)
  self.BrickItem = self:AddComponent(UIBaseContainer, BrickItem_path)
  self.EffectRed = self:AddComponent(UIBaseContainer, EffectRed_path)
  self.BtnClick = self:AddComponent(UIButton, BtnClick_path)
  self.BtnClick:SetOnClick(function()
    self:ClickGetReward()
  end)
  self.root = self:AddComponent(UIBaseContainer, "Root")
  self.canvas = self:AddComponent(UICanvasGroup, "Root")
  self.BrickGrid = self:AddComponent(UIGridLayoutGroup, ContentBrick_path)
  self.BrickObj = self.BrickItem.gameObject
  self.BrickObj:GameObjectCreatePool()
  self.BrickObj:SetActive(false)
  self.ItemObj = self.UICommonResItem.gameObject
  self.ItemObj:GameObjectCreatePool()
  self.ItemObj:SetActive(false)
  self.HeadObj = self.Head.gameObject
  self.HeadObj:GameObjectCreatePool()
  self.HeadObj:SetActive(false)
end

local function ComponentDestroy(self)
  self.BrickObj:GameObjectRecycleAll()
  self.Content1:RemoveComponents(UICommonResItem)
  self.ItemObj:GameObjectRecycleAll()
  self:HideHead()
  self.Icon = nil
  self.Content1 = nil
  self.UICommonResItem = nil
  self.ScrollView2 = nil
  self.Content2 = nil
  self.Head = nil
  self.ContentBrick = nil
  self.BrickItem = nil
  self.EffectRed = nil
  self.BtnClick = nil
end

local function DataDefine(self)
  self.ItemList = {}
  self.HeadList = {}
end

local function DataDestroy(self)
  self.ItemList = nil
  self.HeadList = nil
end

function DiggingLevelRewardItem:ReInit(index, blockId, brickList, uuid, rewardState)
  self.index = index
  self.blockId = blockId
  self.selfPos = nil
  self.uuid = uuid
  self.rewardState = rewardState
  local blockConfig = DataCenter.DiggingDataTemplateManager:GetConfigDataBlock(blockId)
  if not blockConfig then
    return
  end
  self:RefreshReward(blockConfig)
  self:ShowBgGrid(blockConfig.size_width, blockConfig.size_height)
  self:RefreshIcon(blockConfig)
  self:RefreshHead(brickList)
  if self.selfPos and rewardState == 1 then
    if not self.effectGet then
      self.effectGet = self:AddComponent(UIVfx, EffectRed_path, VfxAssets.DiggingRewardGet, {
        lifeType = UIVfxLifeType.Stay
      })
    end
    self.effectGet:Replay()
    self.BtnClick:SetActive(true)
  else
    if self.effectGet then
      self.effectGet:Stop()
    end
    self.BtnClick:SetActive(false)
  end
  return self.selfPos
end

function DiggingLevelRewardItem:RefreshIcon(blockConfig)
  self.Icon:LoadSprite(blockConfig.appearance)
  self.Icon:SetNativeSize()
  local size = self.Icon:GetSizeDelta()
  local maxSize = math.max(size.x, size.y)
  local scale = 200 / maxSize
  self.Icon:SetLocalScaleXYZ(scale, scale, 1)
end

function DiggingLevelRewardItem:RefreshHead(brickList)
  self:HideHead()
  if not brickList then
    return
  end
  local selfUid = LuaEntry.Player.uid
  for i, v in ipairs(brickList) do
    if v.playerInfo then
      local goItem = self.HeadObj:GameObjectSpawn(self.Content2.transform)
      goItem.name = string.format("Head_%d", i)
      goItem:SetActive(true)
      local headRoot = self.Content2:AddComponent(UIBaseContainer, goItem.name)
      local theItem = headRoot:AddComponent(UICommonHead, string.format("%s", "UIPlayerHead"))
      theItem.headRoot = headRoot
      theItem:SetEnableClickShowInfo(true, true)
      theItem:SetHeadAndFrame(v.playerInfo.uid, v.playerInfo.pic, v.playerInfo.picVer, false, v.playerInfo.headSkinId)
      theItem:SetActive(true)
      self.HeadList[i] = theItem
      if v.playerInfo.uid == selfUid then
        self.selfPos = v.pos
      end
    end
  end
end

function DiggingLevelRewardItem:HideHead()
  self.Content2:RemoveComponents(UIBaseContainer)
  self.Content2:RemoveComponents(UICommonHead)
  self.HeadObj:GameObjectRecycleAll()
  self.HeadList = {}
end

function DiggingLevelRewardItem:RefreshReward(blockConfig)
  self.Content1:RemoveComponents(UICommonResItem)
  self.ItemObj:GameObjectRecycleAll()
  self.ItemList = {}
  local rewardList = DataCenter.RewardTemplateManager:GetList(blockConfig.reward)
  if not rewardList then
    return
  end
  for i, v in ipairs(rewardList) do
    local theItem = self.ItemObj:GameObjectSpawn(self.Content1.transform)
    theItem.name = string.format("Item_%d", i)
    theItem:SetActive(true)
    theItem = self.Content1:AddComponent(UICommonResItem, theItem.name)
    theItem:ReInit(v, self.ClickGetReward, self, self.selfPos and self.rewardState)
    self.ItemList[i] = theItem
  end
end

function DiggingLevelRewardItem:ShowBgGrid(width, height)
  self.BrickObj:GameObjectRecycleAll()
  local gridSize = DataCenter.DiggingDataManager:GetGridSize(width, height)
  self.BrickGrid:SetCellSize(gridSize, gridSize)
  self.BrickGrid:SetConstraintCount(width)
  local total = width * height
  for i = 1, total do
    self.BrickObj:GameObjectSpawn(self.ContentBrick.transform)
  end
end

function DiggingLevelRewardItem:ClickGetReward()
  if not self.uuid or not self.selfPos then
    return
  end
  if self.rewardState == 0 or self.rewardState == 2 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.AllianceBossDigGameReward, self.uuid, self.selfPos)
end

function DiggingLevelRewardItem:PlayShowAnim(index)
  self.canvas:SetAlpha(0)
  self:SetLocalScaleXYZ(0.8, 0.8, 1)
  self.root:SetLocalPositionXYZ(0, -80, 0)
  local delayTime = toInt(index - 1) * 0.07 + 0.1
  self.tweenSeq = DOTween.Sequence()
  self.tweenSeq:AppendInterval(delayTime)
  self.tweenSeq:Append(self.transform:DOScale(Vector3.New(1.02, 1.02, 1), 0.133))
  self.tweenSeq:Append(self.transform:DOScale(Vector3.New(1, 1, 1), 0.333))
  self.tweenSeq:Join(self.canvas.unity_canvas_group:DOFade(1, 0.35))
  self.tweenSeq:Join(self.root.transform:DOLocalMoveY(0, 0.3)):SetEase(CS.DG.Tweening.Ease.OutCubic)
end

DiggingLevelRewardItem.OnCreate = OnCreate
DiggingLevelRewardItem.OnDestroy = OnDestroy
DiggingLevelRewardItem.OnEnable = OnEnable
DiggingLevelRewardItem.OnDisable = OnDisable
DiggingLevelRewardItem.ComponentDefine = ComponentDefine
DiggingLevelRewardItem.ComponentDestroy = ComponentDestroy
DiggingLevelRewardItem.DataDefine = DataDefine
DiggingLevelRewardItem.DataDestroy = DataDestroy
return DiggingLevelRewardItem
