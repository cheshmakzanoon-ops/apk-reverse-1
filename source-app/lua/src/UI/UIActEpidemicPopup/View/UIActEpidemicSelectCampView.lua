local UIActEpidemicSelectCampView = BaseClass("UIActEpidemicSelectCampView", UIBaseView)
local UIActEpidemicSkillItem = require("UI.UIActEpidemicPopup.Component.UIActEpidemicSkillItem")
local UIGray = CS.UIGray
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
  self:RefreshSelection()
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
  self.btnCamp0 = self:AddComponent(UIButton, "Center/Camp0")
  self.btnCamp0:SetOnClick(function()
    self:OnBtnCamp0Click()
  end)
  self.btnCamp1 = self:AddComponent(UIButton, "Center/Camp1")
  self.btnCamp1:SetOnClick(function()
    self:OnBtnCamp1Click()
  end)
  self.btnChoose = self:AddComponent(UIButton, "Center/BtnChoose")
  self.btnChoose:SetOnClick(function()
    self:OnBtnChooseClick()
  end)
  self.btnBackground = self:AddComponent(UIButton, "Background")
  self.btnBackground:SetOnClick(function()
    self:OnBtnBackgroundClick()
  end)
  self.compCamp0skill0 = self:AddComponent(UIActEpidemicSkillItem, "Center/Camp0/Skills/Camp0skill0")
  self.compCamp0skill1 = self:AddComponent(UIActEpidemicSkillItem, "Center/Camp0/Skills/Camp0skill1")
  self.compCamp0skill2 = self:AddComponent(UIActEpidemicSkillItem, "Center/Camp0/Skills/Camp0skill2")
  self.btnCamp1Flag1 = self:AddComponent(UIButton, "Center/Camp1/Camp1Flag1")
  self.btnCamp1Flag1:SetOnClick(function()
    self:OnBtnCamp1Flag1Click()
  end)
  self.btnCamp1Flag0 = self:AddComponent(UIButton, "Center/Camp1/Camp1Flag0")
  self.btnCamp1Flag0:SetOnClick(function()
    self:OnBtnCamp1Flag0Click()
  end)
  self.compOutline0 = self:AddComponent(UIBaseContainer, "Center/Camp0/Outline0")
  self.compOutline1 = self:AddComponent(UIBaseContainer, "Center/Camp1/Outline1")
  UIUtil.SetTextLit(self.transform, "Center/Camp0/TmpCamp0Title", "YiBianJinQu_camp_name_1")
  UIUtil.SetTextLit(self.transform, "Center/Camp1/TmpCamp1Title", "YiBianJinQu_camp_name_2")
  UIUtil.SetTextLit(self.transform, "Center/Camp0/TmpCamp0Detail", "YiBianJinQu_camp_select_tips_3")
  UIUtil.SetTextLit(self.transform, "Center/Camp1/TmpCamp1Detail", "YiBianJinQu_camp_select_tips_4")
  UIUtil.SetTextLit(self.transform, "Center/TmpDesc", "YiBianJinQu_camp_select_tips_5")
end

local function ComponentDestroy(self)
  self.btnCamp0 = nil
  self.btnCamp1 = nil
  self.btnChoose = nil
  self.btnBackground = nil
  self.compCamp0skill0 = nil
  self.compCamp0skill1 = nil
  self.compCamp0skill2 = nil
  self.btnCamp1Flag1 = nil
  self.btnCamp1Flag0 = nil
  self.compOutline0 = nil
  self.compOutline1 = nil
end

local function DataDefine(self)
  local param = self:GetUserData()
  self.group = param and param.group or ActEpidemicUtils.Group1
  self.defaultRole = param and param.role or EpidemicZoneRole.Default
  self.role = self.defaultRole
  self:RefreshBtn()
  ActEpidemicUtils.Log("\229\189\147\229\137\141\233\128\137\228\184\173\239\188\154group:%s, role:%s", self.group, self.role)
  UIUtil.SetTextLit(self.transform, "Center/TmpTitle", self.group == ActEpidemicUtils.Group1 and "YiBianJinQu_camp_select_tips_1" or "YiBianJinQu_camp_select_tips_2")
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function UIActEpidemicSelectCampView:OnBtnBackgroundClick()
  self.ctrl:CloseSelf()
end

function UIActEpidemicSelectCampView:InitView()
  self.compCamp0skill0:Setup(ActEpidemicUtils.GetLordSkillArbiter())
  self.compCamp0skill1:Setup(ActEpidemicUtils.GetLordSkillPassive())
  self.compCamp0skill2:Setup(-1)
end

function UIActEpidemicSelectCampView:RefreshSelection()
  self.compOutline0:SetActive(self.role == EpidemicZoneRole.Lord)
  self.compOutline1:SetActive(self.role == EpidemicZoneRole.Farmer)
  self:RefreshBtn()
end

function UIActEpidemicSelectCampView:OnBtnCamp0Click()
  self.role = EpidemicZoneRole.Lord
  self:RefreshSelection()
end

function UIActEpidemicSelectCampView:OnBtnCamp1Click()
  self.role = EpidemicZoneRole.Farmer
  self:RefreshSelection()
end

function UIActEpidemicSelectCampView:OnBtnChooseClick()
  self.ctrl:CloseSelf()
  EventManager:GetInstance():Broadcast(EventId.EpidemicActTryChangeRole, {
    role = self.role,
    group = self.group,
    bSign = true
  })
end

function UIActEpidemicSelectCampView:RefreshBtn()
  local key = ""
  local gray = false
  if self.defaultRole == EpidemicZoneRole.Default then
    key = "YiBianJinQu_camp_select_button_1"
    gray = self.role == EpidemicZoneRole.Default
  elseif self.defaultRole == self.role then
    key = "YiBianJinQu_event_button_3"
  else
    key = "390102"
  end
  UIUtil.SetTextLit(self.btnChoose.transform, "Button/BtnText", key)
  UIGray.SetGray(self.btnChoose.transform, gray, not gray)
end

function UIActEpidemicSelectCampView:OnBtnCamp1Flag0Click()
end

function UIActEpidemicSelectCampView:OnBtnCamp1Flag1Click()
end

UIActEpidemicSelectCampView.OnCreate = OnCreate
UIActEpidemicSelectCampView.OnDestroy = OnDestroy
UIActEpidemicSelectCampView.OnEnable = OnEnable
UIActEpidemicSelectCampView.OnDisable = OnDisable
UIActEpidemicSelectCampView.ComponentDefine = ComponentDefine
UIActEpidemicSelectCampView.ComponentDestroy = ComponentDestroy
UIActEpidemicSelectCampView.DataDefine = DataDefine
UIActEpidemicSelectCampView.DataDestroy = DataDestroy
UIActEpidemicSelectCampView.OnAddListener = OnAddListener
UIActEpidemicSelectCampView.OnRemoveListener = OnRemoveListener
return UIActEpidemicSelectCampView
