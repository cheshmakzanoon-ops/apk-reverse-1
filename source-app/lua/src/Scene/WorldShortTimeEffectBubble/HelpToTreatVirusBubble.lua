local HelpToTreatVirusBubble = BaseClass("HelpToTreatVirusBubble")

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

HelpToTreatVirusBubble.OnCreate = OnCreate
HelpToTreatVirusBubble.OnDestroy = OnDestroy
HelpToTreatVirusBubble.ComponentDefine = ComponentDefine
HelpToTreatVirusBubble.ComponentDestroy = ComponentDestroy
HelpToTreatVirusBubble.DataDefine = DataDefine
HelpToTreatVirusBubble.DataDestroy = DataDestroy
HelpToTreatVirusBubble.ReInit = ReInit
HelpToTreatVirusBubble.ShowPanel = ShowPanel
HelpToTreatVirusBubble.OnLodChange = OnLodChange
return HelpToTreatVirusBubble
