local UIWorldPlayerHead = BaseClass("UIWorldPlayerHead", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local head_path = "UIPlayerHead"

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
  self.head = self:AddComponent(UICommonHead, head_path)
end

local function ComponentDestroy(self)
  self.head = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetHead(self, uid, pic, picVer)
  self.head:SetHead(uid, pic, picVer)
end

UIWorldPlayerHead.OnCreate = OnCreate
UIWorldPlayerHead.OnDestroy = OnDestroy
UIWorldPlayerHead.OnEnable = OnEnable
UIWorldPlayerHead.OnDisable = OnDisable
UIWorldPlayerHead.ComponentDefine = ComponentDefine
UIWorldPlayerHead.ComponentDestroy = ComponentDestroy
UIWorldPlayerHead.DataDefine = DataDefine
UIWorldPlayerHead.DataDestroy = DataDestroy
UIWorldPlayerHead.SetHead = SetHead
return UIWorldPlayerHead
