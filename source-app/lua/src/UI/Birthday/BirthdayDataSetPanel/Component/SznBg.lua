local SznBg = BaseClass("SznBg", UIBaseContainer)
local base = UIBaseContainer
local BirthdayNumContent = require("UI.Birthday.BirthdayDataSetPanel.Component.BirthdayNumContent")
local birthday_num_content_path = "mask_root/Icon/Icon2/BirthdayNumContent"

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

local function ComponentDefine(self)
  self.rootAni = self:AddComponent(UISimpleAnimation, "")
  self.birthday_num_content = self:AddComponent(BirthdayNumContent, birthday_num_content_path)
end

local function ComponentDestroy(self)
  self.rootAni = nil
  self.birthday_num_content = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, month, day, sznType)
  self.birthday_num_content:SetData(month, day, sznType)
end

local function SetIdelAni(self)
  self.rootAni:Stop()
  self.rootAni:Play("idle")
end

local function SetChangeAni(self)
  self.rootAni:Stop()
  self.rootAni:Play("Default")
end

SznBg.OnCreate = OnCreate
SznBg.OnDestroy = OnDestroy
SznBg.ComponentDefine = ComponentDefine
SznBg.ComponentDestroy = ComponentDestroy
SznBg.DataDefine = DataDefine
SznBg.DataDestroy = DataDestroy
SznBg.SetData = SetData
SznBg.SetIdelAni = SetIdelAni
SznBg.SetChangeAni = SetChangeAni
return SznBg
