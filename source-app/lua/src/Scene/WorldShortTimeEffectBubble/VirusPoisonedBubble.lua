local VirusPoisonedBubble = BaseClass("VirusPoisonedBubble")

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
  self.request = nil
  self.gameObject = nil
  self.transform = nil
  self:ComponentDestroy()
  self:DataDestroy()
end

local function ComponentDefine(self)
  self.tween = self.transform:Find("Transform").gameObject
end

local function ComponentDestroy(self)
  self.tween = nil
end

local function DataDefine(self)
  self.param = nil
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param, bUuid)
  self.param = param
  self.bUuid = bUuid
  self:ShowPanel()
end

local function ShowPanel(self)
  self.tween:SetActive(false)
  self.tween:SetActive(true)
end

local function OnLodChange(self, lod)
end

VirusPoisonedBubble.OnCreate = OnCreate
VirusPoisonedBubble.OnDestroy = OnDestroy
VirusPoisonedBubble.ComponentDefine = ComponentDefine
VirusPoisonedBubble.ComponentDestroy = ComponentDestroy
VirusPoisonedBubble.DataDefine = DataDefine
VirusPoisonedBubble.DataDestroy = DataDestroy
VirusPoisonedBubble.ReInit = ReInit
VirusPoisonedBubble.ShowPanel = ShowPanel
VirusPoisonedBubble.OnLodChange = OnLodChange
return VirusPoisonedBubble
