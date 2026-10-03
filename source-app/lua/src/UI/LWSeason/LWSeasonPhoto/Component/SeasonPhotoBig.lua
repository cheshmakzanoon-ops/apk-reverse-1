local base = UIBaseContainer
local SeasonPhotoBig = BaseClass("SeasonPhotoBig", base)
local ImgTitleRight_path = "ImgTitleRight"
local ImgTitleLeft_path = "ImgTitleLeft"
local Frame_path = "Frame"
local Deco_path = "DecoIcon"

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
  self.ImgTitleRight = self:AddComponent(UIRawImage, ImgTitleRight_path)
  self.ImgTitleLeft = self:AddComponent(UIRawImage, ImgTitleLeft_path)
  self.Frame = self:AddComponent(UIImage, Frame_path)
  self.Deco = self:AddComponent(UIImage, Deco_path)
end

local function ComponentDestroy(self)
  self.ImgTitleRight = nil
  self.ImgTitleLeft = nil
  self.Frame = nil
  self.Deco = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SeasonPhotoBig:SetFrameInfo(borderConfig)
  if not borderConfig then
    return
  end
end

SeasonPhotoBig.OnCreate = OnCreate
SeasonPhotoBig.OnDestroy = OnDestroy
SeasonPhotoBig.OnEnable = OnEnable
SeasonPhotoBig.OnDisable = OnDisable
SeasonPhotoBig.ComponentDefine = ComponentDefine
SeasonPhotoBig.ComponentDestroy = ComponentDestroy
SeasonPhotoBig.DataDefine = DataDefine
SeasonPhotoBig.DataDestroy = DataDestroy
return SeasonPhotoBig
