local StarItemComponent = BaseClass("StarItemComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local light_path = "Star_light1"

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
  self.lightObj = self:AddComponent(UIBaseContainer, light_path)
  self.lightSimpleAni = self:AddComponent(UISimpleAnimation, light_path)
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

function StarItemComponent:ReInit(isLight)
  self.lightObj:SetActive(isLight)
end

function StarItemComponent:PlayLightAni()
  self.lightSimpleAni:Rewind("Play")
  self.lightSimpleAni:Play("Play")
  if self.lightSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.lightSoundHandle)
    self.lightSoundHandle = nil
  end
  self.lightSoundHandle = DataCenter.LWSoundManager:PlaySound(202636, false)
end

StarItemComponent.OnCreate = OnCreate
StarItemComponent.OnDestroy = OnDestroy
StarItemComponent.OnEnable = OnEnable
StarItemComponent.OnDisable = OnDisable
StarItemComponent.ComponentDefine = ComponentDefine
StarItemComponent.ComponentDestroy = ComponentDestroy
StarItemComponent.DataDefine = DataDefine
StarItemComponent.DataDestroy = DataDestroy
StarItemComponent.OnAddListener = OnAddListener
StarItemComponent.OnRemoveListener = OnRemoveListener
return StarItemComponent
