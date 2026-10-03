local base = UIBaseContainer
local DiggingTreasure = BaseClass("DiggingTreasure", base)
local Resource = CS.GameEntry.Resource
local icon_path = "Icon"
local icon_glow_path = "Icon/Icon_glow"
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
  self.icon = self:AddComponent(UIRawImage, icon_path)
  self.icon_glow = self:AddComponent(UIRawImage, icon_glow_path)
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
    self.icon:LoadSprite(config.appearance)
    self.icon:SetNativeSize()
    self.icon_glow:LoadSprite(config.appearance)
    self.icon_glow:SetNativeSize()
    if self.matReq then
      self.matReq:Release()
      self.matReq = nil
    end
    self.matReq = Resource:LoadAssetAsync(config.appearance_mat, typeof(CS.UnityEngine.Material))
    
    function self.matReq.completed(asset)
      if asset == nil then
        Logger.LogError("\229\174\157\232\151\143\232\142\183\229\143\150\229\138\168\231\148\187\229\175\185\229\186\148\231\154\132\230\157\144\232\180\168\229\138\160\232\189\189\229\164\177\232\180\165\239\188\154" .. config.appearance_mat)
        return
      end
      if ComponentIsValid(self.icon_glow) then
        self.icon_glow:SetMaterial(asset.asset)
      end
    end
  end
  if self.fly then
    self.fly:SetLocalPositionXYZ(0, 0, 0)
  end
  EventManager:GetInstance():Broadcast(EventId.DiggingGetBlockAnim, {
    blockInfo = blockInfo,
    fly = self.fly
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
