local UIPVELose = BaseClass("UIPVELose", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local desc_path = "Desc"
local exit_btn_path = "Exit"
local exit_text_path = "Exit/ExitText"
local restart_btn_path = "Restart"
local restart_text_path = "Restart/RestartText"

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

local function ComponentDefine(self)
  self.desc_text = self:AddComponent(UIText, desc_path)
  self.desc_text:SetLocalText(390187)
  self.exit_btn = self:AddComponent(UIButton, exit_btn_path)
  self.exit_btn:SetOnClick(function()
    self:OnExitClick()
  end)
  self.exit_text = self:AddComponent(UIText, exit_text_path)
  self.exit_text:SetLocalText(110043)
  self.restart_btn = self:AddComponent(UIButton, restart_btn_path)
  self.restart_btn:SetOnClick(function()
    self:OnRestartClick()
  end)
  self.restart_text = self:AddComponent(UIText, restart_text_path)
  self.restart_text:SetLocalText(120952)
end

local function ComponentDestroy(self)
  self.desc_text = nil
  self.exit_btn = nil
  self.exit_text = nil
  self.restart_btn = nil
  self.restart_text = nil
end

local function DataDefine(self)
  self.onExitClick = nil
  self.onRestartClick = nil
end

local function DataDestroy(self)
  self.onExitClick = nil
  self.onRestartClick = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self:ReInit()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  self.onExitClick, self.onRestartClick = self:GetUserData()
end

local function OnExitClick(self)
  if self.onExitClick then
    self.onExitClick()
  end
end

local function OnRestartClick(self)
  if self.onRestartClick then
    self.onRestartClick()
  end
end

UIPVELose.OnCreate = OnCreate
UIPVELose.OnDestroy = OnDestroy
UIPVELose.OnEnable = OnEnable
UIPVELose.OnDisable = OnDisable
UIPVELose.ComponentDefine = ComponentDefine
UIPVELose.ComponentDestroy = ComponentDestroy
UIPVELose.DataDefine = DataDefine
UIPVELose.DataDestroy = DataDestroy
UIPVELose.OnAddListener = OnAddListener
UIPVELose.OnRemoveListener = OnRemoveListener
UIPVELose.ReInit = ReInit
UIPVELose.OnExitClick = OnExitClick
UIPVELose.OnRestartClick = OnRestartClick
return UIPVELose
