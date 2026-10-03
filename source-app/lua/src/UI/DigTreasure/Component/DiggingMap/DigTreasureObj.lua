local base = UIBaseContainer
local DiggingTreasure = BaseClass("DiggingTreasure", base)
local Resource = CS.GameEntry.Resource
local icon_root = "iconRoot"
local icon_path = "iconRoot/Icon"
local icon_glow_path = "iconRoot/Icon/Icon_glow"
local fly_path = "fly"

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
  self.icon_root = self:AddComponent(UIBaseContainer, icon_root)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.icon_glow = self:AddComponent(UIImage, icon_glow_path)
  self.fly = self:AddComponent(UIBaseContainer, fly_path)
end

local function ComponentDestroy(self)
  if self.matReq then
    self.matReq:Release()
    self.matReq = nil
  end
  self.icon = nil
  self.icon_glow = nil
  self.fly = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function DiggingTreasure:ReInit(blockInfo)
  local config = blockInfo and DataCenter.DiggingDataTemplateManager:GetConfigDataBlock(blockInfo.bid)
  if config then
    self.icon_root:SetActive(true)
    self.icon_root:SetLocalPositionXYZ(0, 0, 0)
    self.icon_root:SetLocalScaleXYZ(1, 1, 1)
    self.icon:LoadSprite(config.appearance)
    self.icon:SetNativeSize()
    self.icon:SetLocalPositionXYZ(0, 0, 0)
    self.icon_glow:LoadSprite(config.appearance)
    self.icon_glow:SetNativeSize()
    self.icon_glow:SetLocalPositionXYZ(0, 0, 0)
  end
  if self.fly then
    self.fly:SetLocalPositionXYZ(0, 0, 0)
  end
  EventManager:GetInstance():Broadcast(EventId.DiggingGetBlockAnim, {
    blockInfo = blockInfo,
    fly = self.icon_root
  })
end

DiggingTreasure.OnCreate = OnCreate
DiggingTreasure.OnDestroy = OnDestroy
DiggingTreasure.OnEnable = OnEnable
DiggingTreasure.OnDisable = OnDisable
DiggingTreasure.ComponentDefine = ComponentDefine
DiggingTreasure.ComponentDestroy = ComponentDestroy
DiggingTreasure.DataDefine = DataDefine
DiggingTreasure.DataDestroy = DataDestroy
return DiggingTreasure
