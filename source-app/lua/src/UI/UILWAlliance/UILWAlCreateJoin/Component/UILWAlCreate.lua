local UILWAlCreate = BaseClass("UILWAlCreate", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local flag_icon_path = "InnerPanel/FlagItem/FlagIcon"
local flag_select_btn_path = "InnerPanel/FlagItem/ChangeFlagBtn"
local flag_select_btn_text_path = "InnerPanel/FlagItem/ChangeFlagBtn/ChangeFlagBtnText"
local name_title_text_path = "InnerPanel/NameItem/NameTitle"
local name_input_path = "InnerPanel/NameItem/NameInputField"
local name_warn_text_path = "InnerPanel/NameItem/NameWarn"
local name_warn_icon_success_path = "InnerPanel/NameItem/NameIcon/NameSuccess"
local name_warn_icon_lose_path = "InnerPanel/NameItem/NameIcon/NameLose"
local name_char_count_warn_text_path = "InnerPanel/NameItem/NameCharCountWarnText"
local tag_title_text_path = "InnerPanel/TagItem/TagTitle"
local tag_input_path = "InnerPanel/TagItem/TagInputField"
local tag_warn_text_path = "InnerPanel/TagItem/TagWarn"
local tag_warn_icon_success_path = "InnerPanel/TagItem/TagIcon/TagSuccess"
local tag_warn_icon_lose_path = "InnerPanel/TagItem/TagIcon/TagLose"
local tag_random_btn_path = "InnerPanel/TagItem/RandomTagBtn"
local language_title_text_path = "InnerPanel/LanguageItem/LanguageTitle"
local language_text_path = "InnerPanel/LanguageItem/LanguageFrame/LanguageTxt"
local language_select_btn_path = "InnerPanel/LanguageItem/ChangeLanguageBtn"
local country_item_path = "InnerPanel/CountryItem"
local country_img_path = "InnerPanel/CountryItem/CountryFrame/CountryImg"
local change_country_btn_path = "InnerPanel/CountryItem/ChangeCountryBtn"
local create_title_text_path = "CreateBtnPanel/CreateBtn/CreateBtnTxt"
local create_cost_icon_path = "CreateBtnPanel/CreateBtn/DiamondNumTxt/DiamondIcon"
local create_cost_text_path = "CreateBtnPanel/CreateBtn/DiamondNumTxt"
local create_btn_path = "CreateBtnPanel/CreateBtn"
local tip_text_path = "TipText"
local NAME_TITLE_TXT = 390288
local TAG_TITLE_TXT = 100548
local LANGUAGE_TITLE_TXT = 100101
local CREATE_TITLE_TXT = 110006
local GOLD_SPRITE = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_gold.png"
local DEFAULT_AL_NAME = LuaEntry.Player.serverName
local DEFAULT_AL_TAG = "001"
local DEFAULT_AL_LANGUAGE = SuportedLanguagesLocalName[Language.English]
local CONST_CREATE_TITLE_Y_FREE = 12
local CONST_CREATE_TITLE_Y_PAY = 30
local AlPostEventLog = require("DataCenter.AllianceData.AlliancePostEventLog")

function UILWAlCreate:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlCreate:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlCreate:ComponentDefine()
  self.flagIcon = self:AddComponent(UIImage, flag_icon_path)
  self.flagSelectBtn = self:AddComponent(UIButton, flag_select_btn_path)
  self.flagSelectBtn:SetOnClick(function()
    self:FlagSelectClick()
  end)
  self.flagSelectBtnText = self:AddComponent(UIText, flag_select_btn_text_path)
  self.flagSelectBtnText:SetLocalText("110108")
  self.nameTitleText = self:AddComponent(UIText, name_title_text_path)
  self.nameInput = self:AddComponent(UIInput, name_input_path)
  self.nameInput:SetOnValueChange(function(value)
    self:NameIptOnValueChange(value)
  end)
  self.nameWarnText = self:AddComponent(UIText, name_warn_text_path)
  self.nameWarnIconS = self:AddComponent(UIBaseContainer, name_warn_icon_success_path)
  self.nameWarnIconL = self:AddComponent(UIBaseContainer, name_warn_icon_lose_path)
  self.name_char_count_warn_text = self:AddComponent(UIText, name_char_count_warn_text_path)
  self.tagTitleText = self:AddComponent(UIText, tag_title_text_path)
  self.tagInput = self:AddComponent(UIInput, tag_input_path)
  self.tagInput:SetOnValueChange(function(value)
    self:TagIptOnValueChange(value)
  end)
  self.tagWarnText = self:AddComponent(UIText, tag_warn_text_path)
  self.tagWarnIconS = self:AddComponent(UIBaseContainer, tag_warn_icon_success_path)
  self.tagWarnIconL = self:AddComponent(UIBaseContainer, tag_warn_icon_lose_path)
  self.tagRandomBtn = self:AddComponent(UIButton, tag_random_btn_path)
  self.tagRandomBtn:SetOnClick(function()
    self:TagRandomClick()
  end)
  self.languageTitleText = self:AddComponent(UIText, language_title_text_path)
  self.languageText = self:AddComponent(UIText, language_text_path)
  self.languageSelectBtn = self:AddComponent(UIButton, language_select_btn_path)
  self.languageSelectBtn:SetOnClick(function()
    self:LanguageSelectClick()
  end)
  self.country_item = self:AddComponent(UIBaseContainer, country_item_path)
  self.country_img = self:AddComponent(UIImage, country_img_path)
  self.change_country_btn = self:AddComponent(UIButton, change_country_btn_path)
  self.change_country_btn:SetOnClick(function()
    self:CountrySelectClick()
  end)
  self.createTitleText = self:AddComponent(UIText, create_title_text_path)
  self.createCostIcon = self:AddComponent(UIImage, create_cost_icon_path)
  self.createCostText = self:AddComponent(UIText, create_cost_text_path)
  self.createBtn = self:AddComponent(UIButton, create_btn_path)
  self.createBtn:SetOnClick(function()
    if CoppaUtil.IsCoppaLimitWithTips() then
      return
    end
    if LuaEntry.Player:IsLoginSourceServer() then
      self:CreateAlClick()
    else
      UIUtil.ShowTipsId("season_tips166")
    end
  end)
  self.nameTitleText:SetLocalText(NAME_TITLE_TXT)
  self.tagTitleText:SetLocalText(TAG_TITLE_TXT)
  self.languageTitleText:SetLocalText(LANGUAGE_TITLE_TXT)
  self.createTitleText:SetLocalText(CREATE_TITLE_TXT)
  self.createCostIcon:LoadSprite(GOLD_SPRITE)
  self.nameInput:SetText("")
  self.nameWarnText:SetText("")
  self.tagInput:SetText("")
  self.tagWarnText:SetText("")
  self.nameWarnIconS:SetActive(false)
  self.nameWarnIconL:SetActive(false)
  self.tagWarnIconS:SetActive(false)
  self.tagWarnIconL:SetActive(false)
  self.country_item:SetActive(not LuaEntry.Player:IsFromBIGCHINAorUsingLangZH())
  self.tipText = self:AddComponent(UIText, tip_text_path)
  self.tipText:SetActive(false)
end

function UILWAlCreate:ComponentDestroy()
  self.flagIcon = nil
  self.flagSelectBtn = nil
  self.nameTitleText = nil
  self.nameInput = nil
  self.nameWarnText = nil
  self.nameWarnIconS = nil
  self.nameWarnIconL = nil
  self.name_char_count_warn_text = nil
  self.tagTitleText = nil
  self.tagInput = nil
  self.tagWarnText = nil
  self.tagWarnIconS = nil
  self.tagWarnIconL = nil
  self.tagRandomBtn = nil
  self.languageTitleText = nil
  self.languageText = nil
  self.languageSelectBtn = nil
  self.country_item = nil
  self.country_img = nil
  self.change_country_btn = nil
  self.createTitleText = nil
  self.createCostIcon = nil
  self.createCostText = nil
  self.createBtn = nil
  self.tipText = nil
end

function UILWAlCreate:DataDefine()
  self.cacheAlAnnounce = ""
  self.cacheCountryFlag = LuaEntry.Player.countryFlag
  self.isChooseLeader = 1
  self.cacheAlFlag = LWAlFlagIcons[LWAlFlags.AlFlag1]
  self.cacheAlName = ""
  self.cacheAlAbbr = ""
  self.cacheAlLanguage = SuportedLanguagesLocalName[Language.English]
  self.isCostEnough = 0
  self.namePass = false
  self.tagPass = false
  self.isShowGray = false
end

function UILWAlCreate:DataDestroy()
  self.cacheAlAnnounce = nil
  self.cacheCountryFlag = nil
  self.isChooseLeader = nil
  self.cacheAlFlag = nil
  self.cacheAlName = nil
  self.cacheAlAbbr = nil
  self.cacheAlLanguage = nil
  self.isCostEnough = nil
  self.namePass = nil
  self.tagPass = nil
  self.isShowGray = nil
end

function UILWAlCreate:OnEnable()
  base.OnEnable(self)
  self:NameIptOnValueChange(self.cacheAlName or "")
  self:TagIptOnValueChange(self.cacheAlAbbr or "")
end

function UILWAlCreate:OnDisable()
  base.OnDisable(self)
end

function UILWAlCreate:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceChangeNameSuccess, self.OnCheckAlNameBack)
  self:AddUIListener(EventId.AllianceChangeAbbrSuccess, self.OnCheckAlTagBack)
  self:AddUIListener(EventId.AllianceCreateSuccess, self.OnAlCreateSuccessBack)
  self:AddUIListener(EventId.UpdateGold, self.CheckCreateAllianceCostEnough)
end

function UILWAlCreate:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceChangeNameSuccess, self.OnCheckAlNameBack)
  self:RemoveUIListener(EventId.AllianceChangeAbbrSuccess, self.OnCheckAlTagBack)
  self:RemoveUIListener(EventId.AllianceCreateSuccess, self.OnAlCreateSuccessBack)
  self:RemoveUIListener(EventId.UpdateGold, self.CheckCreateAllianceCostEnough)
end

function UILWAlCreate:RefreshAll()
  self.flagIcon:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, self.cacheAlFlag))
  self.languageText:SetLocalText(self.cacheAlLanguage)
  self:CheckCreateAllianceCostEnough()
  if not LuaEntry.GlobalData:IsChina() then
    self.country_img:SetActive(true)
    local nationTemplate = DataCenter.NationTemplateManager:GetNationTemplate(self.cacheCountryFlag)
    self.country_img:LoadSprite(nationTemplate:GetNationFlagPath())
  else
    self.country_img:SetActive(false)
  end
end

function UILWAlCreate:CheckCreateAllianceCostEnough()
  local cost = LuaEntry.DataConfig:TryGetNum("alliance_cost", "k5")
  self.isCostEnough = cost <= LuaEntry.Player.gold
  local strCost = self.isCostEnough and cost or string.format("<color=#ff0000>%s</color>", cost)
  self.createCostText:SetText(strCost)
end

function UILWAlCreate:NameIptOnValueChange(value)
  self.cacheAlName = value
  local state = self.view.ctrl:CheckAlName(self.cacheAlName)
  if state == CheckNameType.None then
    self.view.ctrl:SendCheckAlNameMessage(self.cacheAlName)
  else
    self:CheckAlNameChangeState(state)
  end
  local curCharLength = self.cacheAlName and #self.cacheAlName or 0
  if curCharLength > MAX_AL_NAME_CHAR then
    self.name_char_count_warn_text:SetText("<color=#F53C3D>" .. curCharLength .. "/" .. MAX_AL_NAME_CHAR .. "</color>")
  else
    self.name_char_count_warn_text:SetText("<color=#736863>" .. curCharLength .. "/" .. MAX_AL_NAME_CHAR .. "</color>")
  end
  self:CheckCreateBtnState()
end

function UILWAlCreate:OnCheckAlNameBack(type)
  if type == CheckNameType.None then
    local state = self.view.ctrl:CheckAlName(self.cacheAlName)
    self:CheckAlNameChangeState(state)
  else
    self:CheckAlNameChangeState(type)
  end
end

function UILWAlCreate:CheckAlNameChangeState(type)
  if type == CheckNameType.None then
    self.namePass = true
    self.nameWarnIconS:SetActive(true)
    self.nameWarnIconL:SetActive(false)
    self.nameWarnText:SetText("")
  else
    self.namePass = false
    self.nameWarnIconS:SetActive(false)
    self.nameWarnIconL:SetActive(true)
    if type == CheckNameType.MinNameChar or type == CheckNameType.MaxNameChar then
      self.nameWarnText:SetLocalText(120193)
    elseif type == CheckNameType.Exist then
      self.nameWarnText:SetLocalText(280038)
    elseif type == CheckNameType.IllegalChar then
      self.nameWarnText:SetLocalText(129082)
    elseif type == CheckNameType.SensitiveWords then
      self.nameWarnText:SetLocalText(280073)
    else
      self.nameWarnText:SetText("")
    end
  end
end

function UILWAlCreate:TagIptOnValueChange(value)
  self.cacheAlAbbr = value
  local state = self.view.ctrl:CheckAlTag(self.cacheAlAbbr)
  if state == CheckNameType.None then
    self.view.ctrl:SendCheckAlTagMessage(self.cacheAlAbbr)
  else
    self:CheckAlTagChangeState(state)
  end
  self:CheckCreateBtnState()
end

function UILWAlCreate:OnCheckAlTagBack(type)
  if type == CheckNameType.None then
    local state = self.view.ctrl:CheckAlTag(self.cacheAlAbbr)
    self:CheckAlTagChangeState(state)
  else
    self:CheckAlTagChangeState(type)
  end
end

function UILWAlCreate:CheckAlTagChangeState(type)
  if type == CheckNameType.None then
    self.tagPass = true
    self.tagWarnIconS:SetActive(true)
    self.tagWarnIconL:SetActive(false)
    self.tagWarnText:SetText("")
  else
    self.tagPass = false
    self.tagWarnIconS:SetActive(false)
    self.tagWarnIconL:SetActive(true)
    if type == CheckNameType.MinNameChar or type == CheckNameType.MaxNameChar then
      self.tagWarnText:SetLocalText("alliance_tag_input_tips")
    elseif type == CheckNameType.Exist then
      self.tagWarnText:SetLocalText(280038)
    elseif type == CheckNameType.IllegalChar then
      self.tagWarnText:SetLocalText(129082)
    elseif type == CheckNameType.SensitiveWords then
      self.tagWarnText:SetLocalText(280073)
    else
      self.tagWarnText:SetText("")
    end
  end
end

function UILWAlCreate:FlagSelectClick()
  local param = {
    cost = 0,
    curFlag = self.cacheAlFlag or LWAlFlagIcons[LWAlFlags.AlFlag1],
    callback = function(value)
      self.cacheAlFlag = value
      self:RefreshAll()
    end
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlSelectFlag, {anim = true}, param)
end

function UILWAlCreate:TagRandomClick()
  self.cacheAlAbbr = self.view.ctrl:GetRandomAlTag()
  self.tagInput:SetText(self.cacheAlAbbr)
end

function UILWAlCreate:LanguageSelectClick()
  local param = {
    curLanguage = self.cacheAlLanguage or SuportedLanguagesLocalName[Language.English],
    callback = function(value)
      self.cacheAlLanguage = value
      self:RefreshAll()
    end
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlSelectLanguage, {anim = true}, param)
end

function UILWAlCreate:CountrySelectClick()
  local tempNation = self.cacheCountryFlag
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISetPlayerNation, {anim = true}, {
    nation = tempNation,
    callback = function(tempSelected)
      self.cacheCountryFlag = tempSelected
      self:RefreshAll()
    end
  })
end

function UILWAlCreate:CreateAlClick()
  if not self.cacheAlFlag then
    return
  end
  if not self.namePass then
    return
  end
  if not self.tagPass then
    return
  end
  if not self.cacheAlLanguage then
    return
  end
  if self.isCostEnough then
    if self.isChooseLeader == 1 then
      SFSNetwork.SendMessage(MsgDefines.AlCreate, self.cacheAlName, self.cacheAlAnnounce, self.cacheAlFlag, self.cacheAlLanguage, self.cacheAlAbbr, self.cacheCountryFlag, self.isChooseLeader)
    else
      UIUtil.ShowMessage(Localization:GetString("390864"), 2, nil, nil, function()
        EventManager:GetInstance():Broadcast(EventId.SetMovingUI, UIMovingType.Open)
        SFSNetwork.SendMessage(MsgDefines.AlCreate, self.cacheAlName, self.cacheAlAnnounce, self.cacheAlFlag, self.cacheAlLanguage, self.cacheAlAbbr, self.cacheCountryFlag, self.isChooseLeader)
      end, nil, nil)
    end
  else
    local cost = LuaEntry.DataConfig:TryGetNum("alliance_cost", "k5")
    GoToUtil.GotoPayTips(cost)
  end
end

function UILWAlCreate:OnAlCreateSuccessBack(is_success)
  if is_success then
    if self.view.al_success_callback then
      self.view.al_success_callback()
    else
      self.view.ctrl:CloseSelf()
    end
    AlPostEventLog.PostEventLog_ListCreat_Action(AlPostEventLog.CreatAction.Creat)
  else
    self.view:ContentTrans(true)
    self.view.joinContent:SearchIptOnValueChange(self.cacheAlName)
  end
end

function UILWAlCreate:CheckCreateBtnState()
  local showGray = false
  local nameCharLength = self.cacheAlName and #self.cacheAlName or 0
  if nameCharLength > MAX_AL_NAME_CHAR then
    showGray = true
  end
  local tagCharLength = self.cacheAlAbbr and #self.cacheAlAbbr or 0
  if tagCharLength > MAX_AL_TAG_CHAR then
    showGray = true
  end
  if self.isShowGray ~= showGray then
    self.isShowGray = showGray
    CS.UIGray.SetGray(self.createBtn.transform, showGray, not showGray)
  end
end

function UILWAlCreate:RefreshTipText(tipStr)
  if string.IsNullOrEmpty(tipStr) then
    self.tipText:SetActive(false)
  else
    self.tipText:SetActive(true)
    self.tipText:SetText(tipStr)
  end
end

return UILWAlCreate
