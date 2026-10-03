local UIOffSeason1RecaptureBuffLine = BaseClass("UIOffSeason1RecaptureBuffLine", UIBaseContainer)
local base = UIBaseContainer

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

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.textBuff = self:AddComponent(UIText, "BuffText")
end

local function ComponentDestroy(self)
  self.textBuff = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

function UIOffSeason1RecaptureBuffLine:SetData(effectInfo)
  self.textBuff:SetLocalText(effectInfo.cfg.description)
end

UIOffSeason1RecaptureBuffLine.OnCreate = OnCreate
UIOffSeason1RecaptureBuffLine.OnDestroy = OnDestroy
UIOffSeason1RecaptureBuffLine.OnEnable = OnEnable
UIOffSeason1RecaptureBuffLine.OnDisable = OnDisable
UIOffSeason1RecaptureBuffLine.ComponentDefine = ComponentDefine
UIOffSeason1RecaptureBuffLine.ComponentDestroy = ComponentDestroy
UIOffSeason1RecaptureBuffLine.DataDefine = DataDefine
UIOffSeason1RecaptureBuffLine.DataDestroy = DataDestroy
UIOffSeason1RecaptureBuffLine.OnAddListener = OnAddListener
UIOffSeason1RecaptureBuffLine.OnRemoveListener = OnRemoveListener
return UIOffSeason1RecaptureBuffLine
