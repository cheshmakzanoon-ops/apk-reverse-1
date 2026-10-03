local UINpcQABubble = BaseClass("UINpcQABubble")
local icon_path = "Go/Bg/Icon"
local bg_path = "Go/Bg"
local trigger_path = "Go/Trigger"

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
end

local function ComponentDefine(self)
  if not self.defend then
    self.icon_sprite = self.transform:Find(icon_path):GetComponent(typeof(CS.SpriteMeshRenderer))
    self.bg_sprite = self.transform:Find(bg_path):GetComponent(typeof(CS.SpriteMeshRenderer))
    self.bg = self.transform:Find(trigger_path):GetComponent(typeof(CS.TouchObjectEventTrigger))
    
    function self.bg.onPointerClick()
      self:OnClick()
    end
    
    self.defend = true
  end
end

local function ComponentDestroy(self)
  if self.bg ~= nil then
    self.bg.onPointerClick = nil
  end
  self.bg = nil
  self.icon_sprite = nil
  self.bg_sprite = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.defend = nil
end

local function OnClick(self)
  if DataCenter.GuideManager:InGuide() then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UINpcQA)
end

UINpcQABubble.OnCreate = OnCreate
UINpcQABubble.OnDestroy = OnDestroy
UINpcQABubble.ComponentDefine = ComponentDefine
UINpcQABubble.ComponentDestroy = ComponentDestroy
UINpcQABubble.DataDefine = DataDefine
UINpcQABubble.DataDestroy = DataDestroy
UINpcQABubble.OnClick = OnClick
return UINpcQABubble
