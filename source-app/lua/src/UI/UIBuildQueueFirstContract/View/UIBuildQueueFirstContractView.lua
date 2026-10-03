local UIBuildQueueFirstContractView = BaseClass("UIBuildQueueFirstContractView", UIBaseView)
local base = UIBaseView
local btn_path = "btn"
local effect_path = "effect"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, false)
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    if self.tl then
      self.tl:Resume()
    end
  end)
  self.btn:SetInteractable(false)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function EnableClick(self)
  self.btn:SetInteractable(true)
end

UIBuildQueueFirstContractView.OnCreate = OnCreate
UIBuildQueueFirstContractView.OnDestroy = OnDestroy
UIBuildQueueFirstContractView.OnEnable = OnEnable
UIBuildQueueFirstContractView.OnDisable = OnDisable
UIBuildQueueFirstContractView.ComponentDefine = ComponentDefine
UIBuildQueueFirstContractView.ComponentDestroy = ComponentDestroy
UIBuildQueueFirstContractView.DataDefine = DataDefine
UIBuildQueueFirstContractView.DataDestroy = DataDestroy
UIBuildQueueFirstContractView.EnableClick = EnableClick
return UIBuildQueueFirstContractView
