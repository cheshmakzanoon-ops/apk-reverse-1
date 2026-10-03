local WorldPointRewardItem = BaseClass("WorldPointRewardItem", UIBaseContainer)
local base = UIBaseContainer

local function OnCreate(self)
  base.OnCreate(self)
  self.item = self:AddComponent(UICommonResItem, "obj")
end

local function OnDestroy(self)
  self.item = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshData(self, data, uIType)
  self.item:ReInit(data)
end

local function ReInit(self, data)
  self.item:ReInit(data)
end

function WorldPointRewardItem:ParseInfo(data)
  self.item:ParseInfo(data)
end

function WorldPointRewardItem:SetSeasonType(seasonType)
  self.item:SetSeasonType(seasonType)
end

local function SetGray(self, gray)
  self.item:SetGray(gray, true)
end

WorldPointRewardItem.OnCreate = OnCreate
WorldPointRewardItem.OnDestroy = OnDestroy
WorldPointRewardItem.OnEnable = OnEnable
WorldPointRewardItem.OnDisable = OnDisable
WorldPointRewardItem.RefreshData = RefreshData
WorldPointRewardItem.SetGray = SetGray
WorldPointRewardItem.ReInit = ReInit
return WorldPointRewardItem
