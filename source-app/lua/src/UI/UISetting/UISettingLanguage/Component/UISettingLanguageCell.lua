local UISettingLanguageCell = BaseClass("UISettingLanguageCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Param = DataClass("Param", ParamData)
local ParamData = {
  index,
  name,
  isSelect,
  callBack,
  languageIndex
}
local this_path = ""
local select_go_path = "Common_duihao"
local des_path = "Name"
local slider_path = "Slider"
local btn_path = "SwitchBtn"

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
  self.select_go = self:AddComponent(UIBaseContainer, select_go_path)
  self.des = self:AddComponent(UIText, des_path)
  self.btnSelect = self:AddComponent(UIButton, this_path)
  self.btnSelect:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.slider:SetValue(CommonUtil.GetAutoArabicMirrorSwitch() and 1 or 0)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnMirrorBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.select_go = nil
  self.des = nil
  self.btn = nil
  self.btnSelect = nil
  self.slider = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  if param.name ~= nil then
    self.des:SetText(param.name)
  end
  self.slider:SetActive(self.param.languageIndex == Language.Arabic and CommonUtil.IsArabic())
  self.btn:SetActive(self.param.languageIndex == Language.Arabic and CommonUtil.IsArabic())
  self:SetSelect(param.isSelect)
end

local function OnBtnClick(self)
  if self.param.languageIndex ~= Language.English and self.param.languageIndex ~= Language.ChineseSimplified and self.param.languageIndex ~= Language.ChineseTraditional and self.param.languageIndex ~= Language.Korean and self.param.languageIndex ~= Language.Japanese and self.param.languageIndex ~= Language.German and self.param.languageIndex ~= Language.Italian and self.param.languageIndex ~= Language.Thai and self.param.languageIndex ~= Language.Arabic and self.param.languageIndex ~= Language.Turkish and self.param.languageIndex ~= Language.Russian and self.param.languageIndex ~= Language.Spanish and self.param.languageIndex ~= Language.PortuguesePortugal and self.param.languageIndex ~= Language.Vietnamese and self.param.languageIndex ~= Language.French and self.param.languageIndex ~= Language.Indonesian and self.param.languageIndex ~= Language.Polish and self.param.settingType ~= SettingType.ChatTranslateLanguage then
    UIUtil.ShowTips(Localization:GetString(2000120))
    return
  end
  if self.param.callBack ~= nil then
    self.param.callBack(self.param.index)
  end
end

local function SetSelect(self, value)
  if value then
    self.select_go:SetActive(true)
  else
    self.select_go:SetActive(false)
  end
end

local function OnMirrorBtnClick(self)
  local isMirrorNow = CommonUtil.GetAutoArabicMirrorSwitch()
  UIUtil.ShowMessage(Localization:GetString(isMirrorNow and "arabic_UI_open_close_desc" or "arabic_UI_open_desc"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    CommonUtil.SetAutoArabicMirrorSwitch(not isMirrorNow)
    CS.ApplicationLaunch.Instance:ReloadGame()
  end, nil, function()
    self.slider:SetValueWithoutNotify(isMirrorNow and 1 or 0)
  end)
end

UISettingLanguageCell.OnCreate = OnCreate
UISettingLanguageCell.OnDestroy = OnDestroy
UISettingLanguageCell.Param = Param
UISettingLanguageCell.OnEnable = OnEnable
UISettingLanguageCell.OnDisable = OnDisable
UISettingLanguageCell.ComponentDefine = ComponentDefine
UISettingLanguageCell.ComponentDestroy = ComponentDestroy
UISettingLanguageCell.DataDefine = DataDefine
UISettingLanguageCell.DataDestroy = DataDestroy
UISettingLanguageCell.ReInit = ReInit
UISettingLanguageCell.OnBtnClick = OnBtnClick
UISettingLanguageCell.SetSelect = SetSelect
UISettingLanguageCell.OnMirrorBtnClick = OnMirrorBtnClick
return UISettingLanguageCell
