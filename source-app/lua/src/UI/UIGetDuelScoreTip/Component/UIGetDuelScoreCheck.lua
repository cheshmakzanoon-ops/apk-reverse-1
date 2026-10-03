local UIGetDuelScoreCheck = BaseClass("UIGetDuelScoreCheck", UIBaseContainer)
local base = UIBaseContainer
local toggle_path = "Toggle"
local label_path = "Toggle/Label"

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
  self.toggle = self:AddComponent(UIToggle, toggle_path)
  self.label = self:AddComponent(UIText, label_path)
  self.toggle:SetOnValueChanged(function(tf)
    if self.checkType then
      DataCenter.GetDuelScoreManager:SetIsOnByType(self.checkType, tf)
    end
  end)
  self.label:SetLocalText("scorenotification_switch")
end

local function ComponentDestroy(self)
  self.toggle = nil
  self.label = nil
end

local function DataDefine(self)
  self.checkType = nil
end

local function DataDestroy(self)
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function SetCheckType(self, checkType)
  self.checkType = checkType
  local isOn = DataCenter.GetDuelScoreManager:GetIsOnByType(self.checkType)
  self.toggle:SetIsOn(isOn)
end

UIGetDuelScoreCheck.OnCreate = OnCreate
UIGetDuelScoreCheck.OnDestroy = OnDestroy
UIGetDuelScoreCheck.OnEnable = OnEnable
UIGetDuelScoreCheck.OnDisable = OnDisable
UIGetDuelScoreCheck.ComponentDefine = ComponentDefine
UIGetDuelScoreCheck.ComponentDestroy = ComponentDestroy
UIGetDuelScoreCheck.DataDefine = DataDefine
UIGetDuelScoreCheck.DataDestroy = DataDestroy
UIGetDuelScoreCheck.OnAddListener = OnAddListener
UIGetDuelScoreCheck.OnRemoveListener = OnRemoveListener
UIGetDuelScoreCheck.SetCheckType = SetCheckType
return UIGetDuelScoreCheck
