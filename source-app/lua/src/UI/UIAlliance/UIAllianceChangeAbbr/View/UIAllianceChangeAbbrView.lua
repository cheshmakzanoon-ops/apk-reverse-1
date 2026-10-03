local UIAllianceChangeAbbrView = BaseClass("UIAllianceChangeAbbrView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local input_path = "ImgBg/InputField"
local return_btn_path = "UICommonMiniPopUpTitle/panel"
local close_btn_path = "UICommonMiniPopUpTitle/CloseBtn"
local warn_path = "ImgBg/warnText"
local use_btn_path = "ImgBg/changeBtn"
local gold_cost_txt_path = "ImgBg/changeBtn/DiamondNumTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self.warn = self:AddComponent(UIText, warn_path)
  self.gold_txt = self:AddComponent(UIText, gold_cost_txt_path)
  self.use_btn = self:AddComponent(UIButton, use_btn_path)
  self.use_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnChangeNameClick()
  end)
  self.input = self:AddComponent(UIInput, input_path)
  self.input:SetOnValueChange(function(value)
    self:IptOnValueChange(value)
  end)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

local function OnDestroy(self)
  self.warn = nil
  self.gold_txt = nil
  self.use_btn = nil
  self.input = nil
  self.close_btn = nil
  self.return_btn = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:InitButtonState()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function InitButtonState(self)
  local param = self:GetUserData()
  self.confirmCallBack = param and param.callback or nil
  local cost = param.cost
  self.inputValue = ""
  self.input:SetText("")
  CS.UIGray.SetGray(self.use_btn.transform, true, false)
  self.canChange = false
  self.gold_txt:SetText(tostring(cost))
  self.warn:SetText("<color=#8A7F7B>" .. Localization:GetString("alliance_tag_input_tips") .. "</color>")
end

local function IptOnValueChange(self, value)
  self.inputValue = value
  local state = self.ctrl:CheckName(self.inputValue)
  if state == CheckNameType.None then
    self.ctrl:SendCheckNameMessage(self.inputValue)
  else
    self:CheckNameChangeState(state)
  end
end

local function OnChangeNameClick(self)
  if self.canChange and self.confirmCallBack then
    self.confirmCallBack(self.inputValue)
  end
  self.ctrl:CloseSelf()
end

local function OnCheckNameBack(self, data)
  self:CheckNameChangeState(data)
end

local function CheckNameChangeState(self, type)
  if type == CheckNameType.None then
    CS.UIGray.SetGray(self.use_btn.transform, false, true)
    self.warn:SetText("<color=#8A7F7B>" .. "" .. "</color>")
    self.canChange = true
  else
    CS.UIGray.SetGray(self.use_btn.transform, true, false)
    self.canChange = false
    if type == CheckNameType.MinNameChar or type == CheckNameType.MaxNameChar then
      self.warn:SetText("<color=#F53C3D>" .. Localization:GetString("alliance_tag_input_tips") .. "</color>")
    elseif type == CheckNameType.Exist then
      self.warn:SetText("<color=#F53C3D>" .. Localization:GetString(280038) .. "</color>")
    elseif type == CheckNameType.IllegalChar then
      self.warn:SetText("<color=#F53C3D>" .. Localization:GetString(129082) .. "</color>")
    elseif type == CheckNameType.SensitiveWords then
      self.warn:SetText("<color=#F53C3D>" .. Localization:GetString(280073) .. "</color>")
    else
      self.warn:SetText("<color=#8A7F7B>" .. "" .. "</color>")
    end
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceChangeAbbrSuccess, self.OnCheckNameBack)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceChangeAbbrSuccess, self.OnCheckNameBack)
end

UIAllianceChangeAbbrView.OnCreate = OnCreate
UIAllianceChangeAbbrView.OnDestroy = OnDestroy
UIAllianceChangeAbbrView.InitButtonState = InitButtonState
UIAllianceChangeAbbrView.OnEnable = OnEnable
UIAllianceChangeAbbrView.OnDisable = OnDisable
UIAllianceChangeAbbrView.IptOnValueChange = IptOnValueChange
UIAllianceChangeAbbrView.OnChangeNameClick = OnChangeNameClick
UIAllianceChangeAbbrView.OnCheckNameBack = OnCheckNameBack
UIAllianceChangeAbbrView.CheckNameChangeState = CheckNameChangeState
UIAllianceChangeAbbrView.OnAddListener = OnAddListener
UIAllianceChangeAbbrView.OnRemoveListener = OnRemoveListener
return UIAllianceChangeAbbrView
