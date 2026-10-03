local UILWDailyMustBuyPackBackGround = BaseClass("UILWDailyMustBuyPackBackGround", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local image_path = "Image"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.img = self:AddComponent(UIRawImage, image_path)
end

local function ComponentDestroy(self)
  self.img = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetImg(self, path)
  local realPath = string.format(LoadPath.UIDailyMustBuy, path)
  self.img:LoadSprite(realPath)
end

UILWDailyMustBuyPackBackGround.OnCreate = OnCreate
UILWDailyMustBuyPackBackGround.OnDestroy = OnDestroy
UILWDailyMustBuyPackBackGround.ComponentDefine = ComponentDefine
UILWDailyMustBuyPackBackGround.ComponentDestroy = ComponentDestroy
UILWDailyMustBuyPackBackGround.DataDefine = DataDefine
UILWDailyMustBuyPackBackGround.DataDestroy = DataDestroy
UILWDailyMustBuyPackBackGround.SetImg = SetImg
return UILWDailyMustBuyPackBackGround
