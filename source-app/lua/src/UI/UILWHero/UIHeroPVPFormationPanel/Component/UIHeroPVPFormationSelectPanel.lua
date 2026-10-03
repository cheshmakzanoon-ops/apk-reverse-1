local UIHeroPVPFormationSelectPanel = BaseClass("UIHeroPVPFormationSelectPanel", UIBaseContainer)
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
  self.randomToggle = self:AddComponent(UIToggle, "")
  self.randomToggle:SetOnValueChanged(function(isOn)
    self:OnRandomToggleChanged(isOn)
  end)
  self.randomToggleText = self:AddComponent(UIText, "randomToggleText")
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  self:AddUIListener(EventId.UserSettingChanged, self.Refresh)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UserSettingChanged, self.Refresh)
end

local function SetData(self, userSettingKey, tipDialogId)
  self.userSettingKey = userSettingKey
  self.randomToggleText:SetLocalText(tipDialogId)
  self:Refresh(self.userSettingKey)
end

local function Refresh(self, key)
  if key == self.userSettingKey then
    local random = LuaEntry.Player:GetUserSetting(self.userSettingKey)
    self.toggleOn = random ~= nil and random == "1"
    self.randomToggle:SetIsOn(self.toggleOn)
  end
end

local function OnRandomToggleChanged(self, isOn)
  if self.toggleOn == isOn then
    return
  end
  self.toggleOn = isOn
  if isOn then
    SFSNetwork.SendMessage(MsgDefines.UserSetting, self.userSettingKey, "1")
  else
    SFSNetwork.SendMessage(MsgDefines.UserSetting, self.userSettingKey, "0")
  end
end

UIHeroPVPFormationSelectPanel.OnCreate = OnCreate
UIHeroPVPFormationSelectPanel.OnDestroy = OnDestroy
UIHeroPVPFormationSelectPanel.OnEnable = OnEnable
UIHeroPVPFormationSelectPanel.OnDisable = OnDisable
UIHeroPVPFormationSelectPanel.ComponentDefine = ComponentDefine
UIHeroPVPFormationSelectPanel.ComponentDestroy = ComponentDestroy
UIHeroPVPFormationSelectPanel.DataDefine = DataDefine
UIHeroPVPFormationSelectPanel.DataDestroy = DataDestroy
UIHeroPVPFormationSelectPanel.OnAddListener = OnAddListener
UIHeroPVPFormationSelectPanel.OnRemoveListener = OnRemoveListener
UIHeroPVPFormationSelectPanel.SetData = SetData
UIHeroPVPFormationSelectPanel.OnRandomToggleChanged = OnRandomToggleChanged
UIHeroPVPFormationSelectPanel.Refresh = Refresh
return UIHeroPVPFormationSelectPanel
