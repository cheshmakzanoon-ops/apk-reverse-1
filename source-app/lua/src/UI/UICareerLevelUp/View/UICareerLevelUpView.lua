local UICareerLevelUp = BaseClass("UICareerLevelUp", UIBaseView)
local base = UIBaseView
local UICareerIcon = require("UI.UIPlayerLevel.Component.UICareerIcon")
local this_path = ""
local title_path = "Title"
local level_path = "Title/Level"
local level_up_path = "Title/LevelUp"
local grats_path = "Title/Grats"
local panel_path = "Panel"
local tap_path = "Panel/Tap"
local list_path = "Panel/List"
local close_path = "Panel/Close"
local caidai_path = "Caidai"
local left_icon_path = "Panel/List/UICareerIconLeft"
local right_icon_path = "Panel/List/UICareerIconRight"
local DURATION = 0.7

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
  self:Refresh()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.anim = self:AddComponent(UIAnimator, this_path)
  self.title_anim = self:AddComponent(UIAnimator, title_path)
  self.panel_anim = self:AddComponent(UIAnimator, panel_path)
  self.level_text = self:AddComponent(UIText, level_path)
  self.level_up_text = self:AddComponent(UIText, level_up_path)
  self.grats_text = self:AddComponent(UIText, grats_path)
  self.grats_text:SetLocalText(104201)
  self.list_go = self:AddComponent(UIBaseContainer, list_path)
  self.close_btn = self:AddComponent(UIButton, close_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.tap_text = self:AddComponent(UIText, tap_path)
  self.tap_text:SetLocalText(129074)
  self.caidai_particle = self.transform:Find(caidai_path):GetComponent(typeof(CS.UnityEngine.ParticleSystem))
  self.left_icon = self:AddComponent(UICareerIcon, left_icon_path)
  self.right_icon = self:AddComponent(UICareerIcon, right_icon_path)
end

local function ComponentDestroy(self)
  self.anim = nil
  self.title_anim = nil
  self.panel_anim = nil
  self.level_text = nil
  self.level_up_text = nil
  self.grats_text = nil
  self.list_go = nil
  self.close_btn = nil
  self.tap_text = nil
  self.caidai_particle = nil
  self.left_icon = nil
  self.right_icon = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function Refresh(self)
  local careerType = DataCenter.PlayerCareerManager:GetCareerType()
  local fromLevel, toLevel = self:GetUserData()
  toLevel = math.max(toLevel, DataCenter.PlayerCareerManager:GetCareerLv())
  self.left_icon:SetData(careerType, fromLevel)
  self.right_icon:SetData(careerType, toLevel)
  self.level_text:SetLocalText(395015)
  self.close_btn:SetActive(false)
  self.tap_text:SetActive(false)
  self.list_go:SetActive(false)
  self.title_anim:Play("V_ui_levelup_grats_xiaoshi", 0, 0)
  self.panel_anim:Play("V_ui_UICareerLevelUp_line", 0, 0)
  self.caidai_particle:Play()
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ue_GetReward, false)
  TimerManager:GetInstance():DelayInvoke(function()
    self.close_btn:SetActive(true)
    self.tap_text:SetActive(true)
    self.list_go:SetActive(true)
  end, DURATION)
end

UICareerLevelUp.OnCreate = OnCreate
UICareerLevelUp.OnDestroy = OnDestroy
UICareerLevelUp.OnEnable = OnEnable
UICareerLevelUp.OnDisable = OnDisable
UICareerLevelUp.ComponentDefine = ComponentDefine
UICareerLevelUp.ComponentDestroy = ComponentDestroy
UICareerLevelUp.DataDefine = DataDefine
UICareerLevelUp.DataDestroy = DataDestroy
UICareerLevelUp.Refresh = Refresh
return UICareerLevelUp
