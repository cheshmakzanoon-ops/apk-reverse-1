local base = UIBaseContainer
local OffSeasonDiggingLevelReward = BaseClass("OffSeasonDiggingLevelReward", base)
local OffSeasonDiggingLevelRewardItem = require("UI.OffSeasonDiggingGame.OffSeasonDiggingLevelAlliance.Component.OffSeasonDiggingLevelRewardItem")
local Content_path = "ScrollView/Viewport/Content"
local Item_path = "ScrollView/Viewport/Content/OffSeasonDiggingLevelRewardItem"
local ScrollView_path = "ScrollView"

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
  self.Content = self:AddComponent(UIBaseContainer, Content_path)
  self.Item = self:AddComponent(UIBaseContainer, Item_path)
  self.ScrollView = self:AddComponent(UIScrollRect, ScrollView_path)
  self.ItemObj = self.Item.gameObject
  self.ItemObj:GameObjectCreatePool()
  self.ItemObj:SetActive(false)
  self.jumpIndex = 1
end

local function ComponentDestroy(self)
  self.Content:RemoveComponents(OffSeasonDiggingLevelRewardItem)
  self.ItemObj:GameObjectRecycleAll()
  self.Content = nil
  self.Item = nil
  self.ScrollView = nil
end

local function DataDefine(self)
  self.ItemList = {}
  self.levelConfig = nil
end

local function DataDestroy(self)
  self.ItemList = nil
end

function OffSeasonDiggingLevelReward:ReInit(mapData, isInit)
  self.mapData = mapData
  self:OnRefresh(isInit)
end

function OffSeasonDiggingLevelReward:OnRefresh(isInit)
  if not self.mapData then
    return
  end
  local levelConfig = DataCenter.DiggingDataTemplateManager:GetConfigData(self.mapData.mapConfigId)
  if not levelConfig then
    return
  end
  self.levelConfig = levelConfig
  self.Content:RemoveComponents(OffSeasonDiggingLevelRewardItem)
  self.ItemObj:GameObjectRecycleAll()
  self.ItemList = {}
  for i, blockId in ipairs(self.levelConfig.block) do
    self:UpdateItem(blockId, i, DataCenter.DiggingDataManager:GetBlock(blockId, self.mapData.blockInfo))
  end
  if isInit then
    local startIndex = 1
    if self.jumpIndex then
      startIndex = math.max(self.jumpIndex - 3, 1)
    end
    for i = startIndex, #self.ItemList do
      self.ItemList[i]:PlayShowAnim(i - startIndex)
    end
  end
  if self.jumpIndex then
    self.ScrollView:SetVerticalNormalizedPosition(1.0 - (self.jumpIndex - 1) / (#self.ItemList - 1))
    self.jumpIndex = nil
  end
end

function OffSeasonDiggingLevelReward:UpdateItem(bid, i, blockInfo)
  local numWidth = self.levelConfig.num_width
  local theItem = self.ItemList[i]
  if not theItem then
    theItem = self.ItemObj:GameObjectSpawn(self.Content.transform)
    theItem.name = string.format("LevelReward_%d", i)
    theItem:SetActive(true)
    theItem = self.Content:AddComponent(OffSeasonDiggingLevelRewardItem, theItem.name)
    local brickList = blockInfo and DataCenter.DiggingDataManager:GetBrickListByBlock(blockInfo.pos, self.mapData.brickDic, numWidth, bid)
    local selfPos = theItem:ReInit(i, bid, brickList, self.mapData.uuid, self.mapData.rewardState)
    if selfPos and self.mapData.rewardState == 1 then
      self.jumpIndex = i
    end
    self.ItemList[i] = theItem
  end
end

OffSeasonDiggingLevelReward.OnCreate = OnCreate
OffSeasonDiggingLevelReward.OnDestroy = OnDestroy
OffSeasonDiggingLevelReward.OnEnable = OnEnable
OffSeasonDiggingLevelReward.OnDisable = OnDisable
OffSeasonDiggingLevelReward.ComponentDefine = ComponentDefine
OffSeasonDiggingLevelReward.ComponentDestroy = ComponentDestroy
OffSeasonDiggingLevelReward.DataDefine = DataDefine
OffSeasonDiggingLevelReward.DataDestroy = DataDestroy
return OffSeasonDiggingLevelReward
