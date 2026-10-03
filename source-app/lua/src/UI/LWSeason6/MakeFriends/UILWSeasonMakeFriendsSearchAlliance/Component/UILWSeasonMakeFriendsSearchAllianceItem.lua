local UILWSeasonMakeFriendsSearchAllianceItem = BaseClass("UILWSeasonMakeFriendsSearchAllianceItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UILWSeasonMakeFriendsSearchAllianceItem:OnCreate()
  base.OnCreate(self)
  self.inner_panel = self:AddComponent(UIImage, "InnerPanel")
  self.base_panel = self:AddComponent(UIBaseContainer, "InnerPanel/BasePanel")
  self.flag_item = self:AddComponent(UIBaseContainer, "InnerPanel/BasePanel/FlagItem")
  self.flag_bg = self:AddComponent(UIImage, "InnerPanel/BasePanel/FlagItem/FlagBg")
  self.flag_icon = self:AddComponent(UIImage, "InnerPanel/BasePanel/FlagItem/FlagIcon")
  self.best_icon = self:AddComponent(UIImage, "InnerPanel/BasePanel/FlagItem/BestIcon")
  self.name_text = self:AddComponent(UITextMeshProUGUIEx, "InnerPanel/BasePanel/NameText")
  self.language_panel = self:AddComponent(UIBaseContainer, "InnerPanel/BasePanel/LanguagePanel")
  self.country_img = self:AddComponent(UIImage, "InnerPanel/BasePanel/LanguagePanel/CountryImg")
  self.language_text = self:AddComponent(UITextMeshProUGUIEx, "InnerPanel/BasePanel/LanguagePanel/LanguageText")
  self.base_info_btn = self:AddComponent(UIButton, "InnerPanel/BasePanel/BaseInfoBtn")
  self.info_panel = self:AddComponent(UIBaseContainer, "InnerPanel/InfoPanel")
  self.tip_text1 = self:AddComponent(UITextMeshProUGUIEx, "InnerPanel/InfoPanel/InfoPanel1/TipText1")
  self.info_btn1 = self:AddComponent(UIButton, "InnerPanel/InfoPanel/InfoPanel1/InfoBtn1")
  self.tip_text2 = self:AddComponent(UITextMeshProUGUIEx, "InnerPanel/InfoPanel/InfoPanel2/TipText2")
  self.info_btn2 = self:AddComponent(UIButton, "InnerPanel/InfoPanel/InfoPanel2/InfoBtn2")
  self.icon1 = self:AddComponent(UIButton, "InnerPanel/InfoPanel/InfoPanel1/Icon1")
  self.icon2 = self:AddComponent(UIButton, "InnerPanel/InfoPanel/InfoPanel2/Icon2")
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, "BtnSend/TimeText")
  self.btn_send = self:AddComponent(UIButton, "BtnSend")
  self.icon = self:AddComponent(UIImage, "BtnSend/Icon")
  self.go_text = self:AddComponent(UITextMeshProUGUIEx, "BtnSend/GoText")
  self.btn_view = self:AddComponent(UIButton, "BtnView")
  self.time_left = self:AddComponent(UITextMeshProUGUIEx, "BtnView/TimeLeft")
  self.base_info_btn:SetOnClick(function()
    if self.allianceName and self.allianceId then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true}, self.allianceName, self.allianceId)
    end
  end)
  self.icon1:SetOnClick(function()
    UIUtil.ShowButtonTips(self.icon1, "", "season_rules_ui_desc021")
  end)
  self.icon2:SetOnClick(function()
    UIUtil.ShowButtonTips(self.icon2, "", "393066")
  end)
  self.btn_view:SetOnClick(function()
    self:DoBtnClick()
  end)
  self.btn_send:SetOnClick(function()
    self:DoBtnClick()
  end)
  self.info_btn1:SetActive(false)
  self.info_btn2:SetActive(false)
  self.eff_back = self:AddComponent(UIBaseContainer, "InnerPanel/Eff_ui_S6_MakeFriends_saoguang_back")
  self.eff_front = self:AddComponent(UIBaseContainer, "Eff_ui_S6_MakeFriends_saoguang_front")
  self.eff_back:SetActive(false)
  self.eff_front:SetActive(false)
end

function UILWSeasonMakeFriendsSearchAllianceItem:DoBtnClick()
  if self.data then
    local now = UITimeManager:GetInstance():GetServerTime()
    local applyBaseInfo = self.data.applyBaseInfo
    if self.tabIndex == 1 and (applyBaseInfo == nil or now >= applyBaseInfo.expireTime) then
      local officialPos = DataCenter.AllianceMemberDataManager:GetOfficialPosByUid(LuaEntry.Player.uid)
      if not DataCenter.AllianceBaseDataManager:IsR5() and officialPos ~= LWAlMemberOffcialType.Al_Goddess then
        UIUtil.ShowTipsId("s6_alliance_ally_tips15")
        return
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonMakeFriendsSendInvite, {anim = false}, self.data)
    else
      if self.tabIndex == 2 then
        local key = "ReadApply_" .. applyBaseInfo.applyUuid
        local status = Setting:GetPrivateString(key)
        if status ~= "Read" then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonInviteMailPopup, {anim = false}, self.tabIndex, self.data)
          Setting:SetPrivateString(key, "Read")
          return
        end
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonMakeFriendsShowInvite, {anim = false}, self.tabIndex, self.data)
    end
  end
end

function UILWSeasonMakeFriendsSearchAllianceItem:OnDestroy()
  self.eff_back = nil
  self.eff_front = nil
  self.btn_view = nil
  self.time_left = nil
  self.inner_panel = nil
  self.base_panel = nil
  self.flag_item = nil
  self.flag_bg = nil
  self.flag_icon = nil
  self.best_icon = nil
  self.name_text = nil
  self.language_panel = nil
  self.country_img = nil
  self.language_text = nil
  self.base_info_btn = nil
  self.icon1 = nil
  self.icon2 = nil
  self.tip_text1 = nil
  self.tip_text2 = nil
  self.info_btn1 = nil
  self.info_btn2 = nil
  self.info_panel = nil
  self.time_text = nil
  self.btn_send = nil
  self.icon = nil
  self.go_text = nil
  base.OnDestroy(self)
end

function UILWSeasonMakeFriendsSearchAllianceItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SearchAllianceSuccess, self.OnSearchAllianceSuccess)
end

function UILWSeasonMakeFriendsSearchAllianceItem:OnRemoveListener()
  self:RemoveUIListener(EventId.SearchAllianceSuccess, self.OnSearchAllianceSuccess)
  base.OnRemoveListener(self)
end

function UILWSeasonMakeFriendsSearchAllianceItem:OnSearchAllianceSuccess()
end

function UILWSeasonMakeFriendsSearchAllianceItem:SetData(tabIndex, index, data)
  self.index = index
  self.tabIndex = tabIndex
  self.data = data
  self.applyBaseInfo = data.applyBaseInfo
  self.time_text:SetText("")
  if tabIndex == 1 then
    self.eff_back:SetActive(false)
    self.eff_front:SetActive(false)
    self.btn_view:SetActive(false)
    self.btn_send:SetActive(true)
    local now = UITimeManager:GetInstance():GetServerTime()
    if data.applyBaseInfo == nil or now >= data.applyBaseInfo.expireTime then
      self.go_text:SetLocalText("390077")
      self.icon:LoadSpriteAuto("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_3.png")
    else
      self.go_text:SetLocalText("455005")
      if data.allyInfo == nil or data.allyInfo.allyAllianceId == nil or data.allyInfo.allyAllianceId == "" then
        self.icon:LoadSpriteAuto("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_2.png")
      else
        self.icon:LoadSpriteAuto("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_5.png")
      end
    end
  else
    local isNewData = false
    if data.applyBaseInfo ~= nil and data.applyBaseInfo.applyUuid ~= nil then
      local applyUuid = tostring(data.applyBaseInfo.applyUuid)
      isNewData = Setting:GetPrivateBool(applyUuid, true)
      Setting:SetPrivateBool(applyUuid, false)
    end
    self.eff_back:SetActive(isNewData)
    self.eff_front:SetActive(isNewData)
    self.btn_view:SetActive(true)
    self.btn_send:SetActive(false)
    self.go_text:SetLocalText("s6_alliance_ally_btn08")
    if data.allyInfo == nil or data.allyInfo.allyAllianceId == nil or data.allyInfo.allyAllianceId == "" then
      self.icon:LoadSpriteAuto("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_3.png")
    else
      self.icon:LoadSpriteAuto("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_5.png")
    end
  end
  self.time_text:SetText("")
  self.time_left:SetText("")
  self:Refresh(data)
  self:Update1000MS()
end

function UILWSeasonMakeFriendsSearchAllianceItem:Update1000MS()
  if self.applyBaseInfo ~= nil then
    local now = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.data.applyBaseInfo.expireTime - now
    if 0 < remainTime then
      local msg = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
      self.time_text:SetText(msg)
      self.time_left:SetText(msg)
    else
      self.applyBaseInfo = nil
      if self.tabIndex == 1 then
        self.time_text:SetText("")
        self.time_left:SetText("")
        self.go_text:SetLocalText("390077")
        self.icon:LoadSpriteAuto("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_3.png")
      else
        self.time_text:SetLocalText("390843")
        self.time_left:SetLocalText("390843")
        self.go_text:SetLocalText("s6_alliance_ally_btn08")
        self.icon:LoadSpriteAuto("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_5.png")
      end
    end
  end
end

function UILWSeasonMakeFriendsSearchAllianceItem:Refresh(allianceInfo)
  self.allianceName = allianceInfo.name
  self.allianceId = allianceInfo.allianceUid
  self.time_text:SetText("")
  self.best_icon:SetActive(false)
  self.name_text:SetText(UIUtil.FormatServerAllianceName(allianceInfo.serverId, allianceInfo.abbr, allianceInfo.name))
  self.country_img:LoadSprite(self:GetCountryFlagPath(allianceInfo))
  self.flag_icon:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, allianceInfo.icon))
  self.language_text:SetText(self:GetLanguageStr(allianceInfo))
  self.tip_text1:SetText(string.GetFormattedStr0(tonumber(allianceInfo.forceValue) or 0))
  self.tip_text2:SetText(string.GetFormattedStr0(tonumber(allianceInfo.power) or 0))
end

function UILWSeasonMakeFriendsSearchAllianceItem:GetCountryFlagPath(allianceInfo)
  local country = string.IsNullOrEmpty(allianceInfo.country) and DefaultNation or allianceInfo.country
  local nationTemplate = DataCenter.NationTemplateManager:GetNationTemplate(country)
  if nationTemplate then
    local flagPath = nationTemplate:GetNationFlagPath()
    return flagPath
  end
  return nil
end

function UILWSeasonMakeFriendsSearchAllianceItem:GetLanguageStr(allianceInfo)
  local text = ""
  local languageId = SuportedLanguagesLocalName[Localization:GetLanguage()] or ""
  if languageId == allianceInfo.language then
    text = "<color=#099b4a>" .. Localization:GetString("migration_activity_interface_10037") .. "</color>"
  else
    for k, v in pairs(SuportedLanguagesLocalName) do
      if v == allianceInfo.language then
        text = SuportedLanguagesName[k]
      end
    end
  end
  return text
end

return UILWSeasonMakeFriendsSearchAllianceItem
