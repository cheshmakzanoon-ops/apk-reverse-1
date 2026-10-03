local SeasonPhotoMessageShare = BaseClass("SeasonPhotoMessageShare", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

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
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

SeasonPhotoMessageShare.OnCreate = OnCreate
SeasonPhotoMessageShare.OnDestroy = OnDestroy
SeasonPhotoMessageShare.OnEnable = OnEnable
SeasonPhotoMessageShare.OnDisable = OnDisable
SeasonPhotoMessageShare.ComponentDefine = ComponentDefine
SeasonPhotoMessageShare.ComponentDestroy = ComponentDestroy
SeasonPhotoMessageShare.DataDefine = DataDefine
SeasonPhotoMessageShare.DataDestroy = DataDestroy
SeasonPhotoMessageShare.OnAddListener = OnAddListener
SeasonPhotoMessageShare.OnRemoveListener = OnRemoveListener
return SeasonPhotoMessageShare
