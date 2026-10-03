local UILWAlModifyInfoView = BaseClass("UILWAlModifyInfoView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local panel_path = "Panel"
local close_btn_path = "UICommonPopBg/bg_3/CloseBtn"
local flag_icon_path = "Root/ContentCreateHolder/FlagItem/FlagIcon"
local change_flag_btn_path = "Root/ContentCreateHolder/FlagItem/ChangeFlagBtn"
local name_txt_path = "Root/ContentCreateHolder/NameItem/NameInputField/NameTxt"
local change_name_btn_path = "Root/ContentCreateHolder/NameItem/ChangeNameBtn"
local tag_txt_path = "Root/ContentCreateHolder/TagItem/TagInputField/TagTxt"
local change_tag_btn_path = "Root/ContentCreateHolder/TagItem/ChangeTagBtn"
local language_txt_path = "Root/ContentCreateHolder/LanguageItem/LanguageFrame/LanguageTxt"
local change_language_btn_path = "Root/ContentCreateHolder/LanguageItem/ChangeLanguageBtn"
local country_item_path = "Root/ContentCreateHolder/CountryItem"
local country_img_path = "Root/ContentCreateHolder/CountryItem/CountryFrame/CountryImg"
local change_country_btn_path = "Root/ContentCreateHolder/CountryItem/ChangeCountryBtn"
local change_power_btn_path = "Root/ContentCreateHolder/ApplicationConditionItem/PowerContent/ChangePowerBtn"
local power_text_path = "Root/ContentCreateHolder/ApplicationConditionItem/PowerContent/PowerBg/PowerText"
local change_base_level_btn_path = "Root/ContentCreateHolder/ApplicationConditionItem/BaseLevelContent/ChangeBaseLevelBtn"
local base_level_text_path = "Root/ContentCreateHolder/ApplicationConditionItem/BaseLevelContent/BaseLevelBg/BaseLevelText"
local auto_clean_up_inactive_member_slider_path = "Root/ContentCreateHolder/AutoCleanUpInactiveMembersItem/AutoCleanUpInactiveMemberSlider"
local auto_clean_up_inactive_member_switch_btn_path = "Root/ContentCreateHolder/AutoCleanUpInactiveMembersItem/AutoCleanUpInactiveMemberSwitchBtn"

function UILWAlModifyInfoView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlModifyInfoView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlModifyInfoView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.flag_icon = self:AddComponent(UIImage, flag_icon_path)
  self.change_flag_btn = self:AddComponent(UIButton, change_flag_btn_path)
  self.change_flag_btn:SetOnClick(function()
    self:FlagSelectClick()
  end)
  self.name_txt = self:AddComponent(UIText, name_txt_path)
  self.change_name_btn = self:AddComponent(UIButton, change_name_btn_path)
  self.change_name_btn:SetOnClick(function()
    self:ChangeNameClick()
  end)
  self.tag_txt = self:AddComponent(UIText, tag_txt_path)
  self.change_tag_btn = self:AddComponent(UIButton, change_tag_btn_path)
  self.change_tag_btn:SetOnClick(function()
    self:ChangeTagClick()
  end)
  self.language_txt = self:AddComponent(UIText, language_txt_path)
  self.change_language_btn = self:AddComponent(UIButton, change_language_btn_path)
  self.change_language_btn:SetOnClick(function()
    self:LanguageSelectClick()
  end)
  self.country_img = self:AddComponent(UIImage, country_img_path)
  self.change_country_btn = self:AddComponent(UIButton, change_country_btn_path)
  self.change_country_btn:SetOnClick(function()
    self:CountrySelectClick()
  end)
  self.country_item = self:AddComponent(UIBaseContainer, country_item_path)
  self.country_item:SetActive(not LuaEntry.Player:IsFromBIGCHINAorUsingLangZH())
  self.power_text = self:AddComponent(UIText, power_text_path)
  self.change_power_btn = self:AddComponent(UIButton, change_power_btn_path)
  self.change_power_btn:SetOnClick(function()
    self:ChangePowerBtnClick()
  end)
  self.base_level_text = self:AddComponent(UIText, base_level_text_path)
  self.change_base_level_btn = self:AddComponent(UIButton, change_base_level_btn_path)
  self.change_base_level_btn:SetOnClick(function()
    self:ChangeBaseLevelBtnClick()
  end)
  self.auto_clean_up_inactive_member_slider = self:AddComponent(UISlider, auto_clean_up_inactive_member_slider_path)
  self.auto_clean_up_inactive_member_switch_btn = self:AddComponent(UIButton, auto_clean_up_inactive_member_switch_btn_path)
  self.auto_clean_up_inactive_member_switch_btn:SetOnClick(function()
    self:AutoCleanUpInactiveMemberBtnClick()
  end)
end

function UILWAlModifyInfoView:ComponentDestroy()
  self.panel = nil
  self.close_btn = nil
  self.flag_icon = nil
  self.change_flag_btn = nil
  self.name_txt = nil
  self.change_name_btn = nil
  self.name_txt = nil
  self.change_tag_btn = nil
  self.language_txt = nil
  self.change_language_btn = nil
  self.country_item = nil
  self.country_img = nil
  self.change_country_btn = nil
  self.power_text = nil
  self.change_power_btn = nil
  self.base_level_text = nil
  self.change_base_level_btn = nil
  self.auto_clean_up_inactive_member_slider = nil
  self.auto_clean_up_inactive_member_switch_btn = nil
end

function UILWAlModifyInfoView:DataDefine()
end

function UILWAlModifyInfoView:DataDestroy()
  self.cachePower = nil
  self.cacheBaseLevel = nil
  self.cacheAutoCleanUp = nil
end

function UILWAlModifyInfoView:OnEnable()
  base.OnEnable(self)
  self:RefreshAll()
end

function UILWAlModifyInfoView:OnDisable()
  base.OnDisable(self)
end

function UILWAlModifyInfoView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceFlagChanged, self.RefreshAll)
  self:AddUIListener(EventId.AllianceNameChange, self.RefreshAll)
  self:AddUIListener(EventId.AllianceAbbrChange, self.RefreshAll)
  self:AddUIListener(EventId.AllianceLanguage, self.RefreshAll)
  self:AddUIListener(EventId.AllianceCountryChanged, self.RefreshAll)
  self:AddUIListener(EventId.AllianceApplyBaseLevelLimitChange, self.RefreshAll)
  self:AddUIListener(EventId.AllianceApplyPowerLimitChange, self.RefreshAll)
end

function UILWAlModifyInfoView:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceFlagChanged, self.RefreshAll)
  self:RemoveUIListener(EventId.AllianceNameChange, self.RefreshAll)
  self:RemoveUIListener(EventId.AllianceAbbrChange, self.RefreshAll)
  self:RemoveUIListener(EventId.AllianceLanguage, self.RefreshAll)
  self:RemoveUIListener(EventId.AllianceCountryChanged, self.RefreshAll)
  self:RemoveUIListener(EventId.AllianceApplyBaseLevelLimitChange, self.RefreshAll)
  self:RemoveUIListener(EventId.AllianceApplyPowerLimitChange, self.RefreshAll)
  base.OnRemoveListener(self)
end

function UILWAlModifyInfoView:RefreshAll()
  local allianceInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  self.cacheAlFlag = allianceInfo.icon
  self.cacheAlName = allianceInfo.allianceName
  self.cacheAlAbbr = allianceInfo.abbr
  self.cacheAlLanguage = allianceInfo.language
  self.cacheCountryFlag = allianceInfo.country
  self.cachePower = allianceInfo.applyPowerLimit
  self.cacheBaseLevel = allianceInfo.applyLevelLimit
  self.cacheAutoCleanUp = allianceInfo.autoKickInactiveMember
  self.flag_icon:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, self.cacheAlFlag))
  self.name_txt:SetText(self.cacheAlName)
  self.tag_txt:SetText(self.cacheAlAbbr)
  self.language_txt:SetLocalText(self.cacheAlLanguage)
  if not LuaEntry.GlobalData:IsChina() then
    self.country_img:SetActive(true)
    local nationTemplate = DataCenter.NationTemplateManager:GetNationTemplate(self.cacheCountryFlag)
    self.country_img:LoadSprite(nationTemplate:GetNationFlagPath())
  else
    self.country_img:SetActive(false)
  end
  self.power_text:SetText(self.cachePower)
  self.base_level_text:SetText(self.cacheBaseLevel)
  self:RefreshAutoCleanUpState(false)
end

function UILWAlModifyInfoView:FlagSelectClick()
  local param = {}
  param.curFlag = self.cacheAlFlag
  param.cost = LuaEntry.DataConfig:TryGetNum("alliance_cost", "k3")
  
  function param.callback(curFlag)
    UIUtil.ShowMessage(Localization:GetString("391054"), 2, "", "", function()
      SFSNetwork.SendMessage(MsgDefines.AllianceChangeAttributes, nil, nil, nil, nil, nil, nil, nil, nil, nil, curFlag)
    end, function()
    end)
  end
  
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlSelectFlag, {anim = true}, param)
end

function UILWAlModifyInfoView:ChangeNameClick()
  if CoppaUtil.IsCoppaLimitWithTips() then
    return
  end
  local param = {}
  local allianceInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  local isFreeChangeName = allianceInfo.createdByPlayer == false and allianceInfo.rename == 0
  param.curName = self.cacheAlName
  param.cost = isFreeChangeName and 0 or LuaEntry.DataConfig:TryGetNum("alliance_cost", "k1", 500)
  
  function param.callback(value)
    SFSNetwork.SendMessage(MsgDefines.AllianceChangeAttributes, value)
  end
  
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceChangeName, {anim = true}, param)
end

function UILWAlModifyInfoView:ChangeTagClick()
  if CoppaUtil.IsCoppaLimitWithTips() then
    return
  end
  local param = {}
  param.curAbbr = self.cacheAlAbbr
  param.cost = LuaEntry.DataConfig:TryGetNum("alliance_cost", "k2", 200)
  
  function param.callback(value)
    SFSNetwork.SendMessage(MsgDefines.AllianceChangeAttributes, nil, value)
  end
  
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceChangeAbbr, {anim = true}, param)
end

function UILWAlModifyInfoView:LanguageSelectClick()
  local param = {
    curLanguage = self.cacheAlLanguage,
    callback = function(value)
      SFSNetwork.SendMessage(MsgDefines.AllianceChangeAttributes, nil, nil, nil, nil, value)
    end
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlSelectLanguage, {anim = true}, param)
end

function UILWAlModifyInfoView:CountrySelectClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISetPlayerNation, {anim = true}, {
    nation = self.cacheCountryFlag,
    callback = function(tempSelected)
      SFSNetwork.SendMessage(MsgDefines.AllianceChangeAttributes, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, tempSelected)
    end
  })
end

function UILWAlModifyInfoView:ChangePowerBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWChangeEnterAllianceCondition, {anim = true}, self.cachePower, ApplyEnterAllianceConditionType.Power)
end

function UILWAlModifyInfoView:ChangeBaseLevelBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWChangeEnterAllianceCondition, {anim = true}, self.cacheBaseLevel, ApplyEnterAllianceConditionType.BaseLevel)
end

function UILWAlModifyInfoView:AutoCleanUpInactiveMemberBtnClick()
  self.cacheAutoCleanUp = not self.cacheAutoCleanUp
  self:RefreshAutoCleanUpState(true)
end

function UILWAlModifyInfoView:RefreshAutoCleanUpState(sendMsg)
  if self.cacheAutoCleanUp then
    self.auto_clean_up_inactive_member_slider:SetValue(1)
  else
    self.auto_clean_up_inactive_member_slider:SetValue(0)
  end
  if sendMsg then
    local value = self.cacheAutoCleanUp and 1 or 0
    SFSNetwork.SendMessage(MsgDefines.AllianceChangeAttributes, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, value)
  end
end

return UILWAlModifyInfoView
