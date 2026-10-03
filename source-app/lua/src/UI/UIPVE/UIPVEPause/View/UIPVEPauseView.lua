local UIPVEPause = BaseClass("UIPVEPause", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local desc_path = "Desc"
local restart_btn_path = "Restart"
local restart_text_path = "Restart/RestartText"
local resume_btn_path = "Resume"
local resume_text_path = "Resume/ResumeText"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.desc_text = self:AddComponent(UIText, desc_path)
  self.desc_text:SetLocalText(400069)
  self.restart_btn = self:AddComponent(UIButton, restart_btn_path)
  self.restart_btn:SetOnClick(function()
    self:OnRestartClick()
  end)
  self.restart_text = self:AddComponent(UIText, restart_text_path)
  self.restart_text:SetLocalText(400050)
  self.resume_btn = self:AddComponent(UIButton, resume_btn_path)
  self.resume_btn:SetOnClick(function()
    self:OnResumeClick()
  end)
  self.resume_text = self:AddComponent(UIText, resume_text_path)
  self.resume_text:SetLocalText(400004)
end

local function ComponentDestroy(self)
  self.desc_text = nil
  self.restart_btn = nil
  self.restart_text = nil
  self.resume_btn = nil
  self.resume_text = nil
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

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnRestartClick(self)
  DataCenter.BattleLevel:Resume()
  DataCenter.BattleLevel:Restart(true)
end

local function OnResumeClick(self)
  DataCenter.BattleLevel:Resume()
  self.ctrl:CloseSelf()
end

UIPVEPause.OnCreate = OnCreate
UIPVEPause.OnDestroy = OnDestroy
UIPVEPause.ComponentDefine = ComponentDefine
UIPVEPause.ComponentDestroy = ComponentDestroy
UIPVEPause.DataDefine = DataDefine
UIPVEPause.DataDestroy = DataDestroy
UIPVEPause.OnEnable = OnEnable
UIPVEPause.OnDisable = OnDisable
UIPVEPause.OnAddListener = OnAddListener
UIPVEPause.OnRemoveListener = OnRemoveListener
UIPVEPause.OnRestartClick = OnRestartClick
UIPVEPause.OnResumeClick = OnResumeClick
return UIPVEPause
