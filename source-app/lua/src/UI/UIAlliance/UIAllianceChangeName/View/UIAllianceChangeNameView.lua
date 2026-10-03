local UIAllianceChangeNameView = BaseClass("UIAllianceChangeNameView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local input_path = "ImgBg/InputField"
local return_btn_path = "UICommonMiniPopUpTitle/panel"
local close_btn_path = "UICommonMiniPopUpTitle/CloseBtn"
local warn_path = "ImgBg/warnText"
local use_btn_path = "ImgBg/changeBtn"
local gold_cost_txt_path = "ImgBg/changeBtn/DiamondNumTxt"
local freeChangeBtn_path = "ImgBg/freeChangeBtn"
local freeChangeBtnTxt_path = "ImgBg/freeChangeBtn/freeChangeBtnTxt"
local name_char_count_warn_text_path = "ImgBg/NameCharCountWarnText"

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
  self.freeChangeBtn = self:AddComponent(UIButton, freeChangeBtn_path)
  self.freeChangeBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnChangeNameClick()
  end)
  self.freeChangeBtnTxt = self:AddComponent(UIText, freeChangeBtnTxt_path)
  self.freeChangeBtnTxt:SetLocalText(130126)
  self.name_char_count_warn_text = self:AddComponent(UIText, name_char_count_warn_text_path)
end

local function OnDestroy(self)
  self.warn = nil
  self.gold_txt = nil
  self.use_btn = nil
  self.input = nil
  self.close_btn = nil
  self.return_btn = nil
  self.freeChangeBtn = nil
  self.freeChangeBtnTxt = nil
  self.name_char_count_warn_text = nil
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
  CS.UIGray.SetGray(self.freeChangeBtn.transform, true, false)
  self.canChange = false
  self.gold_txt:SetText(tostring(cost))
  self.warn:SetText("<color=#8A7F7B>" .. Localization:GetString(455085) .. "</color>")
  if 0 < cost then
    self.use_btn:SetActive(true)
    self.freeChangeBtn:SetActive(false)
  else
    self.use_btn:SetActive(false)
    self.freeChangeBtn:SetActive(true)
  end
  self.name_char_count_warn_text:SetText("<color=#736863>" .. "0" .. "/" .. MAX_AL_NAME_CHAR .. "</color>")
end

local function IptOnValueChange(self, value)
  self.inputValue = value
  local state = self.ctrl:CheckName(self.inputValue)
  if state == CheckNameType.None then
    self.ctrl:SendCheckNameMessage(self.inputValue)
  else
    self:CheckNameChangeState(state)
  end
  local curCharLength = #value
  if curCharLength > MAX_AL_NAME_CHAR then
    self.name_char_count_warn_text:SetText("<color=#F53C3D>" .. curCharLength .. "/" .. MAX_AL_NAME_CHAR .. "</color>")
  else
    self.name_char_count_warn_text:SetText("<color=#736863>" .. curCharLength .. "/" .. MAX_AL_NAME_CHAR .. "</color>")
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
    CS.UIGray.SetGray(self.freeChangeBtn.transform, false, true)
    self.warn:SetText("<color=#8A7F7B>" .. "" .. "</color>")
    self.canChange = true
  else
    CS.UIGray.SetGray(self.use_btn.transform, true, false)
    CS.UIGray.SetGray(self.freeChangeBtn.transform, true, false)
    self.canChange = false
    if type == CheckNameType.MinNameChar or type == CheckNameType.MaxNameChar then
      self.warn:SetText("<color=#F53C3D>" .. Localization:GetString(120193) .. "</color>")
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
  self:AddUIListener(EventId.AllianceChangeNameSuccess, self.OnCheckNameBack)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceChangeNameSuccess, self.OnCheckNameBack)
end

UIAllianceChangeNameView.OnCreate = OnCreate
UIAllianceChangeNameView.OnDestroy = OnDestroy
UIAllianceChangeNameView.InitButtonState = InitButtonState
UIAllianceChangeNameView.OnEnable = OnEnable
UIAllianceChangeNameView.OnDisable = OnDisable
UIAllianceChangeNameView.IptOnValueChange = IptOnValueChange
UIAllianceChangeNameView.OnChangeNameClick = OnChangeNameClick
UIAllianceChangeNameView.OnCheckNameBack = OnCheckNameBack
UIAllianceChangeNameView.CheckNameChangeState = CheckNameChangeState
UIAllianceChangeNameView.OnAddListener = OnAddListener
UIAllianceChangeNameView.OnRemoveListener = OnRemoveListener
return UIAllianceChangeNameView
