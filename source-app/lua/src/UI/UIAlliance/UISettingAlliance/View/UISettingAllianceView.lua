local UISettingAllianceView = BaseClass("UISettingAllianceView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local AllianceFlagItem = require("UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem")
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local txt_title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local return_btn_path = "UICommonPopUpTitle/panel"
local settingTip_path = "ImgBg/change/settingTip"
local abbr_change_btn_path = "ImgBg/change/AllianceAbbrObj/changeAbbrButton"
local abbrChangeBtnEff_path = "ImgBg/change/AllianceAbbrObj/changeAbbrButton/changeAbbrEff"
local cur_abbr_txt_path = "ImgBg/change/AllianceAbbrObj/abbrText"
local abbr_des_txt_path = "ImgBg/change/AllianceAbbrObj/abbrDesText"
local name_change_btn_path = "ImgBg/change/AllianceNameObj/changeNameButton"
local nameChangeBtnEff_path = "ImgBg/change/AllianceNameObj/changeNameButton/changeNameEff"
local cur_name_txt_path = "ImgBg/change/AllianceNameObj/nameText"
local name_des_txt_path = "ImgBg/change/AllianceNameObj/nameDesText"
local announce_btn_path = "ImgBg/change/announceBg/announceBtn"
local announceBtnEff_path = "ImgBg/change/announceBg/announceBtn/announceEff"
local announce_txt_path = "ImgBg/change/announceBg/announceText"
local language_des_txt_path = "ImgBg/change/layout/languageSetObj/languageDesText"
local language_set_txt_path = "ImgBg/change/layout/languageSetObj/languageSetText"
local language_set_btn_path = "ImgBg/change/layout/languageSetObj/setBtn"
local career_obj_path = "ImgBg/change/careerSetObj"
local career_des_txt_path = "ImgBg/change/careerSetObj/careerDesText"
local career_set_txt_path = "ImgBg/change/careerSetObj/careerSetText"
local career_set_btn_path = "ImgBg/change/careerSetObj/careerBtn"
local join_des_path = "ImgBg/change/joinSetDesObj"
local join_des_txt_path = "ImgBg/change/joinSetDesObj/joinDesText"
local level_btn_path = "ImgBg/change/joinSetDesObj/levelBtn"
local level_des_path = "ImgBg/change/joinSetDesObj/levelSetText"
local power_des_path = "ImgBg/change/joinSetDesObj/powerSetText"
local apply_des_path = "ImgBg/change/layout/applySetObj/applyDesText"
local join_img_path = "ImgBg/change/layout/applySetObj/Join"
local apply_img_path = "ImgBg/change/layout/applySetObj/Apply"
local apply_set_btn_path = "ImgBg/change/layout/applySetObj/Button"
local country_path = "ImgBg/change/layout/country"
local countryTxt_path = "ImgBg/change/layout/country/countryTxt"
local countryFlagImg_path = "ImgBg/change/layout/country/countryFlag"
local countrySetBtn_path = "ImgBg/change/layout/country/setCountryBtn"
local allianceFlag_path = "ImgBg/flagBg/icon/AllianceFlag"
local changeAlFlagBtn_path = "ImgBg/flagBg/changeFlagBtn"
local changeAlFlagTxt_path = "ImgBg/flagBg/changeFlagBtn/changeFlagTxt"
local recommend_path = "ImgBg/change/recommendObj"
local recommendDesc_path = "ImgBg/change/recommendObj/recommendDesTxt"
local recommendOn_path = "ImgBg/change/recommendObj/recommendOn"
local recommendOff_path = "ImgBg/change/recommendObj/recommendOff"
local recommendSwitchBtn_path = "ImgBg/change/recommendObj/recommendBtn"
local recommendInfoBtn_path = "ImgBg/change/recommendObj/recommendInfoBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.txt_title:SetLocalText(390189)
  self.cur_abbr_txt = self:AddComponent(UIText, cur_abbr_txt_path)
  self.abbr_des_txt = self:AddComponent(UIText, abbr_des_txt_path)
  self.cur_name_txt = self:AddComponent(UIText, cur_name_txt_path)
  self.name_des_txt = self:AddComponent(UIText, name_des_txt_path)
  self.language_des_txt = self:AddComponent(UIText, language_des_txt_path)
  self.language_set_txt = self:AddComponent(UIText, language_set_txt_path)
  self.career_des_txt = self:AddComponent(UIText, career_des_txt_path)
  self.career_set_txt = self:AddComponent(UIText, career_set_txt_path)
  self.career_obj = self:AddComponent(UIBaseContainer, career_obj_path)
  self.announce_txt = self:AddComponent(UIText, announce_txt_path)
  self.join_des_txt = self:AddComponent(UIText, join_des_txt_path)
  self.apply_des_txt = self:AddComponent(UIText, apply_des_path)
  self.name_des_txt:SetLocalText(390288)
  self.abbr_des_txt:SetLocalText(100548)
  self.join_des_txt:SetLocalText(390095)
  self.language_des_txt:SetLocalText(100101)
  self.career_des_txt:SetLocalText(395405)
  self.apply_des_txt:SetLocalText(390798)
  self.joinSetN = self:AddComponent(UIBaseContainer, join_des_path)
  self.level_des = self:AddComponent(UIText, level_des_path)
  self.power_des = self:AddComponent(UIText, power_des_path)
  self.join_img = self:AddComponent(UIBaseContainer, join_img_path)
  self.apply_img = self:AddComponent(UIBaseContainer, apply_img_path)
  self.announce_btn = self:AddComponent(UIButton, announce_btn_path)
  self.announce_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnIntroClick()
  end)
  self.level_btn = self:AddComponent(UIButton, level_btn_path)
  self.level_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnLevelClick()
  end)
  self.apply_set_btn = self:AddComponent(UIButton, apply_set_btn_path)
  self.apply_set_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnApplySetClick()
  end)
  self.language_set_btn = self:AddComponent(UIButton, language_set_btn_path)
  self.language_set_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnLanguageClick()
  end)
  self.career_set_btn = self:AddComponent(UIButton, career_set_btn_path)
  self.career_set_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnCareerClick()
  end)
  self.settingTip = self:AddComponent(UIText, settingTip_path)
  self.settingTip:SetLocalText(141097)
  self.settingTip:SetActive(false)
  self.abbr_change_btn = self:AddComponent(UIButton, abbr_change_btn_path)
  self.abbr_change_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnChangeAbbrClick()
  end)
  self.name_change_btn = self:AddComponent(UIButton, name_change_btn_path)
  self.name_change_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnChangeNameClick()
  end)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.abbrChangeBtnEff = self:AddComponent(UIBaseContainer, abbrChangeBtnEff_path)
  self.nameChangeBtnEff = self:AddComponent(UIBaseContainer, nameChangeBtnEff_path)
  self.announceBtnEff = self:AddComponent(UIBaseContainer, announceBtnEff_path)
  self.allianceFlagN = self:AddComponent(AllianceFlagItem, allianceFlag_path)
  self.changeAlFlagBtnN = self:AddComponent(UIButton, changeAlFlagBtn_path)
  self.changeAlFlagBtnN:SetOnClick(function()
    self:OnClickChangeAlFlagBtn()
  end)
  self.changeAlFlagTxtN = self:AddComponent(UIText, changeAlFlagTxt_path)
  self.changeAlFlagTxtN:SetLocalText(110108)
  self.countryN = self:AddComponent(UIBaseContainer, country_path)
  self.countryN:SetActive(not LuaEntry.GlobalData:IsChina())
  self.countryTxtN = self:AddComponent(UIText, countryTxt_path)
  self.countryTxtN:SetLocalText(143589)
  self.countryFlagN = self:AddComponent(UIImage, countryFlagImg_path)
  self.countryFlagN:SetActive(not LuaEntry.GlobalData:IsChina())
  self.SetCountryBtnN = self:AddComponent(UIButton, countrySetBtn_path)
  self.SetCountryBtnN:SetOnClick(function()
    self:OnClickSetCoutryBtn()
  end)
  self.recommendN = self:AddComponent(UIBaseContainer, recommend_path)
  self.recommendDescN = self:AddComponent(UIText, recommendDesc_path)
  self.recommendDescN:SetLocalText(391104)
  self.recommendOnN = self:AddComponent(UIBaseContainer, recommendOn_path)
  self.recommendOffN = self:AddComponent(UIBaseContainer, recommendOff_path)
  self.recommendSwitchBtnN = self:AddComponent(UIButton, recommendSwitchBtn_path)
  self.recommendSwitchBtnN:SetOnClick(function()
    self:OnClickRecommendBtn()
  end)
  self.recommendInfoBtnN = self:AddComponent(UIButton, recommendInfoBtn_path)
  self.recommendInfoBtnN:SetOnClick(function()
    self:OnClickRecommendInfoBtn()
  end)
end

local function OnDestroy(self)
  self.txt_title = nil
  self.des_title = nil
  self.cur_abbr_txt = nil
  self.abbr_des_txt = nil
  self.cur_name_txt = nil
  self.name_des_txt = nil
  self.announce_des_txt = nil
  self.announce_btn = nil
  self.announce_txt = nil
  self.level_txt = nil
  self.level_btn = nil
  self.level_des_txt = nil
  self.joinSetN = nil
  self.join_des_txt = nil
  self.join_set_txt = nil
  self.language_des_txt = nil
  self.language_set_txt = nil
  self.create_txt = nil
  self.gold_txt = nil
  self.left_btn = nil
  self.right_btn = nil
  self.language_set_btn = nil
  self.abbr_change_btn = nil
  self.name_change_btn = nil
  self.create_btn = nil
  self.close_btn = nil
  self.return_btn = nil
  self.abbrChangeBtnEff = nil
  self.nameChangeBtnEff = nil
  self.announceBtnEff = nil
  self.allianceFlagN = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:OnInitView()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnInitView(self)
  self.data = self.ctrl:GetCurrentAllianceData()
  self:SetCurrentAbbr(self.data.abbr)
  self:SetCurrentName(self.data.name)
  self:SetIntro(self.data.intro)
  self:SetCurrentJoinSetting(self.data.recruitTotal)
  self:SetRecommendSetting(self.data.recommendFunc)
  self:SetLanguage(self.data.language)
  self:SetLookForCareers(self.data.lookForCareers)
  local str = self.data.castleRestrictionN .. ";" .. self.data.powerRestrictionN
  self:SetRestriction(str)
  self:SetFlag(self.data.icon)
  self:SetCountry(self.data.country)
end

local function SetFlag(self, value)
  self.allianceFlagN:SetData(value)
end

local function SetCountry(self, value)
  local template = DataCenter.NationTemplateManager:GetNationTemplate(value)
  if template then
    self.countryFlagN:LoadSprite(template:GetNationFlagPath())
  end
end

local function SetIntro(self, value)
  self.intro = value
  DataCenter.AllianceBaseDataManager:SetIntro(value)
  self.announce_txt:SetText(value)
  local needSet = DataCenter.AllianceBaseDataManager:CheckIfNeedSettingTip()
  local showEff = false
  if needSet then
    local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if string.IsNullOrEmpty(data.intro) then
      showEff = true
    end
  end
  self.announceBtnEff:SetActive(showEff)
  self.settingTip:SetActive(needSet)
end

local function SetCurrentAbbr(self, value)
  self.curAbbr = value
  self.cur_abbr_txt:SetText(value)
  local needSet = DataCenter.AllianceBaseDataManager:CheckIfNeedSettingTip()
  local showEff = false
  if needSet then
    local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if data.abbrRename == 0 then
      showEff = true
    end
  end
  self.abbrChangeBtnEff:SetActive(showEff)
  self.settingTip:SetActive(needSet)
end

local function SetCurrentName(self, value)
  self.curName = value
  self.cur_name_txt:SetText(value)
  local needSet = DataCenter.AllianceBaseDataManager:CheckIfNeedSettingTip()
  local showEff = false
  if needSet then
    local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if data.rename == 0 then
      showEff = true
    end
  end
  self.nameChangeBtnEff:SetActive(showEff)
  self.settingTip:SetActive(needSet)
end

local function SetRecommendSetting(self, state)
  self.recommendSwitch = state or 0
  self.recommendOnN:SetActive(self.recommendSwitch == 0)
  self.recommendOffN:SetActive(self.recommendSwitch == 1)
end

local function SetCurrentJoinSetting(self, state)
  self.joinSetting = state
  if state == 0 then
    self.join_img:SetActive(true)
    self.apply_img:SetActive(false)
  else
    self.join_img:SetActive(false)
    self.apply_img:SetActive(true)
  end
end

local function SetLanguage(self, language)
  self.language = language
  self.language_set_txt:SetLocalText(language)
end

local function SetLookForCareers(self, careers)
  if DataCenter.PlayerCareerManager:Enabled() then
    self.career_obj:SetActive(true)
    self.career_set_txt:SetText(DataCenter.PlayerCareerManager:ConvertCareerName(careers))
  else
    self.career_obj:SetActive(false)
  end
end

local function SetRestriction(self, str)
  self.joinSetN:SetActive(false)
end

local function OnClickChangeAlFlagBtn(self)
  local param = {}
  local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  param.curFlag = baseData.icon
  local k3 = LuaEntry.DataConfig:TryGetNum("alliance_cost", "k3")
  param.cost = k3
  
  function param.callback(strNew)
    UIUtil.ShowMessage(Localization:GetString("391054"), 2, "", "", function()
      SFSNetwork.SendMessage(MsgDefines.AllianceChangeAttributes, nil, nil, nil, nil, nil, nil, nil, nil, nil, strNew)
      self.ctrl:CloseSelf()
    end, function()
    end)
  end
  
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceFlag, {anim = true}, param)
end

local function OnClickRecommendBtn(self)
  local tempState = self.recommendSwitch == 0 and 1 or 0
  self:SetRecommendSetting(tempState)
  self.ctrl:OnRecommendClick(tempState)
end

local function OnApplySetClick(self)
  if self.joinSetting == 0 then
    self:SetCurrentJoinSetting(1)
  else
    self:SetCurrentJoinSetting(0)
  end
  self.ctrl:OnChangeClick(self.joinSetting)
end

local function OnLanguageClick(self)
  self.ctrl:OnLanguageClick(self.language)
end

local function OnCareerClick(self)
  self.ctrl:OnCareerClick()
end

local function OnChangeAbbrClick(self)
  self.ctrl:OnChangeAbbrClick(self.curAbbr)
end

local function OnChangeNameClick(self)
  self.ctrl:OnChangeNameClick(self.curName)
end

local function OnIntroClick(self)
  self.ctrl:OnIntroClick(self.intro)
end

local function OnLevelClick(self)
  self.ctrl:OnLevelClick(self.levelRestriction, self.powerRestriction)
end

local function OnClickSetCoutryBtn(self)
  local tempNation = DefaultNation
  local allianceBase = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if allianceBase and allianceBase.country then
    tempNation = allianceBase.country
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISetPlayerNation, {anim = true}, {
    nation = tempNation,
    callback = function(tempSelected)
      SFSNetwork.SendMessage(MsgDefines.AllianceChangeAttributes, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, tempSelected)
    end
  })
end

local function OnClickRecommendInfoBtn(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.recommendInfoBtnN.transform.position + Vector3.New(-15, 0, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString("391105")
  param.dir = UIHeroTipView.Direction.LEFT
  param.defWidth = 180
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceNameChange, self.SetCurrentName)
  self:AddUIListener(EventId.AllianceAbbrChange, self.SetCurrentAbbr)
  self:AddUIListener(EventId.AllianceLanguage, self.SetLanguage)
  self:AddUIListener(EventId.AllianceIntro, self.SetIntro)
  self:AddUIListener(EventId.AllianceRestriction, self.SetRestriction)
  self:AddUIListener(EventId.AllianceLookForCareers, self.SetLookForCareers)
  self:AddUIListener(EventId.AllianceFlagChanged, self.SetFlag)
  self:AddUIListener(EventId.AllianceCountryChanged, self.SetCountry)
  self:AddUIListener(EventId.OnAllianceRecommendChange, self.SetRecommendSetting)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceNameChange, self.SetCurrentName)
  self:RemoveUIListener(EventId.AllianceAbbrChange, self.SetCurrentAbbr)
  self:RemoveUIListener(EventId.AllianceIntro, self.SetIntro)
  self:RemoveUIListener(EventId.AllianceRestriction, self.SetRestriction)
  self:RemoveUIListener(EventId.AllianceLookForCareers, self.SetLookForCareers)
  self:RemoveUIListener(EventId.AllianceFlagChanged, self.SetFlag)
  self:RemoveUIListener(EventId.AllianceCountryChanged, self.SetCountry)
  self:RemoveUIListener(EventId.OnAllianceRecommendChange, self.SetRecommendSetting)
end

UISettingAllianceView.OnCreate = OnCreate
UISettingAllianceView.OnDestroy = OnDestroy
UISettingAllianceView.OnEnable = OnEnable
UISettingAllianceView.OnDisable = OnDisable
UISettingAllianceView.OnInitView = OnInitView
UISettingAllianceView.SetCurrentAbbr = SetCurrentAbbr
UISettingAllianceView.SetCurrentName = SetCurrentName
UISettingAllianceView.SetCurrentJoinSetting = SetCurrentJoinSetting
UISettingAllianceView.SetRecommendSetting = SetRecommendSetting
UISettingAllianceView.SetLanguage = SetLanguage
UISettingAllianceView.SetLookForCareers = SetLookForCareers
UISettingAllianceView.OnLanguageClick = OnLanguageClick
UISettingAllianceView.OnCareerClick = OnCareerClick
UISettingAllianceView.OnChangeAbbrClick = OnChangeAbbrClick
UISettingAllianceView.OnChangeNameClick = OnChangeNameClick
UISettingAllianceView.OnAddListener = OnAddListener
UISettingAllianceView.OnRemoveListener = OnRemoveListener
UISettingAllianceView.SetIntro = SetIntro
UISettingAllianceView.OnLevelClick = OnLevelClick
UISettingAllianceView.OnIntroClick = OnIntroClick
UISettingAllianceView.SetRestriction = SetRestriction
UISettingAllianceView.OnApplySetClick = OnApplySetClick
UISettingAllianceView.OnClickChangeAlFlagBtn = OnClickChangeAlFlagBtn
UISettingAllianceView.OnClickSetCoutryBtn = OnClickSetCoutryBtn
UISettingAllianceView.OnClickRecommendInfoBtn = OnClickRecommendInfoBtn
UISettingAllianceView.SetFlag = SetFlag
UISettingAllianceView.SetCountry = SetCountry
UISettingAllianceView.OnClickRecommendBtn = OnClickRecommendBtn
return UISettingAllianceView
