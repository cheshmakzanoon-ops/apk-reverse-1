local UIAllianceDetailView = BaseClass("UIAllianceDetailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local p_trans_root_alliance_war_state_icon_path = "UICommonPopUpTitle/p_trans_root_alliance_war_state_icon"
local season_alliance_war_state_icon_path = "Assets/Main/SeasonRes/S5/Prefabs/UI/AllianceWarTime/SeasonAllianceWarTimeStateIconComp.prefab"
local SeasonAllianceWarTimeStateIconComp = require("UI/LWSeason5/UILWSeasonAllianceWarTime/Common/SeasonAllianceWarTimeStateIconComp")
local AllianceRateStarItem = require("UI.UIAlliance.UIAllianceInfo.Component.AllianceRateStarItem")
local txt_title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local return_btn_path = "UICommonPopUpTitle/panel"
local name_path = "ImgBg/TopInfo/name"
local power_txt_path = "ImgBg/TopInfo/powerTxt"
local star_text_path = "ImgBg/TopInfo/StarContent/StarText"
local star_item_list_path = "ImgBg/TopInfo/StarContent/AllianceRateStarItem"
local cp_txt_path = "ImgBg/TopInfo/CPContent/CPTxt"
local leader_path = "ImgBg/TopInfo/LeaderContent/leader"
local leader_txt_path = "ImgBg/TopInfo/LeaderContent/leaderTxt"
local land_path = "ImgBg/TopInfo/LanguageContent/language"
local land_txt_path = "ImgBg/TopInfo/LanguageContent/languageTxt"
local gift_path = "ImgBg/TopInfo/GiftContent/gift"
local gift_txt_path = "ImgBg/TopInfo/GiftContent/giftNum"
local people_path = "ImgBg/TopInfo/PeopleContent/people"
local people_txt_path = "ImgBg/TopInfo/PeopleContent/peopleTxt"
local des_title_txt_path = "ImgBg/Align/ScrollView/Viewport/Content/descTitle"
local des_txt_path = "ImgBg/Align/ScrollView/Viewport/Content/desTxt"
local comment_btn_path = "ImgBg/Align/Btns/commentButton"
local comment_txt_path = "ImgBg/Align/Btns/commentButton/commentText"
local mail_btn_path = "ImgBg/Align/Btns/mailButton"
local mail_txt_path = "ImgBg/Align/Btns/mailButton/mailText"
local mem_btn_path = "ImgBg/Align/Btns/memberButton"
local mem_txt_path = "ImgBg/Align/Btns/memberButton/memberText"
local join_set_tip_path = "ImgBg/Align/joinSet/joinSetTip"
local level_set_txt_path = "ImgBg/Align/joinSet/levelSetTxt"
local power_set_txt_path = "ImgBg/Align/joinSet/powerSetTxt"
local career_set_tip_path = "ImgBg/Align/joinSet/careerSetTip"
local career_set_txt_path = "ImgBg/Align/joinSet/careerSetTxt"
local allianceFlag_path = "ImgBg/TopInfo/flagIcon"
local countryFlag_path = "ImgBg/TopInfo/LanguageContent/languageTxt/countryFlag"
local invite_button_path = "ImgBg/Align/Btns/inviteButton"
local invite_text_path = "ImgBg/Align/Btns/inviteButton/inviteText"
local invite_icon_path = "ImgBg/Align/Btns/inviteButton/inviteIcon"
local defaultAnnounceScroll_root_path = "ImgBg/Align/ScrollView"
local translateScroll_root_path = "ImgBg/Align/TranslateScroll"
local tranlateBtn_path = "ImgBg/Align/TranslateBtnRoot/TranslateBtn"
local translateFinishBtn_path = "ImgBg/Align/TranslateBtnRoot/TranslateFinishBtn"
local transBtnRoot_path = "ImgBg/Align/TranslateBtnRoot"
local translateDescribe_path = "ImgBg/Align/TranslateScroll/Viewport/Content/transDescTxt"
local translatingScroll_root_path = "ImgBg/Align/TranslatingScroll"
local translatingText_path = "ImgBg/Align/TranslatingScroll/Viewport/Content/TranslatingText"
local translateDescTitle_Path = "ImgBg/Align/TranslateScroll/Viewport/Content/transDescTitle"

local function OnCreate(self)
  base.OnCreate(self)
  local allianceName, allianceId, serverId = self:GetUserData()
  self.serverId = serverId
  self.allianceId = allianceId
  self.p_trans_root_alliance_war_state_icon = self:AddComponent(UIBaseContainer, p_trans_root_alliance_war_state_icon_path)
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.txt_title:SetLocalText(GameDialogDefine.ALLIANCE)
  self.name = self:AddComponent(UIText, name_path)
  self.textStar = self:AddComponent(UIText, star_text_path)
  self.starItem = self:AddComponent(AllianceRateStarItem, star_item_list_path)
  self.cp_txt = self:AddComponent(UIText, cp_txt_path)
  self.leader = self:AddComponent(UIText, leader_path)
  self.leader_txt = self:AddComponent(UIText, leader_txt_path)
  self.land = self:AddComponent(UIText, land_path)
  self.land_txt = self:AddComponent(UIText, land_txt_path)
  self.gift = self:AddComponent(UIText, gift_path)
  self.gift_txt = self:AddComponent(UIText, gift_txt_path)
  self.people = self:AddComponent(UIText, people_path)
  self.people_txt = self:AddComponent(UIText, people_txt_path)
  self.des_txt = self:AddComponent(UITextMeshProUGUIEx, des_txt_path)
  self.des_title_txt = self:AddComponent(UITextMeshProUGUIEx, des_title_txt_path)
  self.textStar:SetLocalText("alliance_invite_point_average")
  self.leader:SetLocalText(390006)
  self.land:SetLocalText(100101)
  self.gift:SetLocalText(390445)
  self.people:SetLocalText(390098)
  self.des_title_txt:SetLocalText(390513)
  self.join_set_tip = self:AddComponent(UIText, join_set_tip_path)
  self.join_set_tip:SetLocalText(390846)
  self.level_set_txt = self:AddComponent(UIText, level_set_txt_path)
  self.power_set_txt = self:AddComponent(UIText, power_set_txt_path)
  self.career_set_tip = self:AddComponent(UIText, career_set_tip_path)
  self.career_set_tip:SetLocalText(395405)
  self.career_set_txt = self:AddComponent(UIText, career_set_txt_path)
  self.AllianceFlag = self:AddComponent(UIImage, allianceFlag_path)
  self.countryFlagN = self:AddComponent(UIImage, countryFlag_path)
  self.countryFlagN:SetActive(not LuaEntry.GlobalData:IsChina() and not LuaEntry.Player:IsFromBIGCHINAorUsingLangZH())
  self.reportBtn = self:AddComponent(UIButton, "ImgBg/TopInfo/reportBtn")
  self.reportBtn:SetActive(true)
  self.commentBtnImg = self:AddComponent(UIImage, comment_btn_path)
  self.comment_btn = self:AddComponent(UIButton, comment_btn_path)
  self.comment_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickCommentBtn()
  end)
  self.comment_txt = self:AddComponent(UIText, comment_txt_path)
  self.comment_txt:SetLocalText(455000)
  self.mail_btn = self:AddComponent(UIButton, mail_btn_path)
  self.mail_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnMailClick()
  end)
  self.mail_txt = self:AddComponent(UIText, mail_txt_path)
  self.mail_txt:SetLocalText(390086)
  self.mem_btn = self:AddComponent(UIButton, mem_btn_path)
  self.mem_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnMemberClick()
  end)
  self.mem_txt = self:AddComponent(UIText, mem_txt_path)
  self.mem_txt:SetLocalText(390199)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.reportBtn:SetOnClick(function()
    self:OnReportBtnClick()
  end)
  self.defaultAnnounceScroll = self.transform:Find(defaultAnnounceScroll_root_path).gameObject
  self.translateScroll = self.transform:Find(translateScroll_root_path).gameObject
  self.translateBtn = self:AddComponent(UIButton, tranlateBtn_path)
  self.translateFinishBtn = self:AddComponent(UIButton, translateFinishBtn_path)
  self.transBtnRoot = self.transform:Find(transBtnRoot_path).gameObject
  self.translateDescribe = self:AddComponent(UIText, translateDescribe_path)
  self.translatingScroll = self.transform:Find(translatingScroll_root_path).gameObject
  self.translatingText = self:AddComponent(UIText, translatingText_path)
  self.translateDescTitle = self:AddComponent(UIText, translateDescTitle_Path)
  self.translatingText:SetText(CS.GameEntry.Localization:GetString("120039"))
  self.translateBtn:SetOnClick(function()
    self:OnTranslateBtnClick()
  end)
  self.translateFinishBtn:SetOnClick(function()
    self:CancleTranslate()
  end)
  self:RefreshTranslateBtnUIShow(true)
  self:RefreshTranslateBtnRootUIShow(true)
  self.invite_button = self:AddComponent(UIButton, invite_button_path)
  self.invite_text = self:AddComponent(UITextMeshProUGUIEx, invite_text_path)
  self.invite_button:SetOnClick(function()
    self:OnInviteBtnClick()
  end)
  self.invite_icon = self:AddComponent(UIImage, invite_icon_path)
  self.data = self.view.ctrl:GetAllianceData(self.allianceId)
  if self.data then
    self:OnRefresh()
  else
    self.invite_button:SetActive(false)
  end
  self:InitAllianceWarTime()
  SFSNetwork.SendMessage(MsgDefines.GetAllianceInfo, allianceId)
end

function UIAllianceDetailView:InitAllianceWarTime()
  if DataCenter.UILWSeasonAllianceWarTimeManager:IsFuncOpen(true) and DataCenter.UILWSeasonAllianceWarTimeManager:CanShowOnUI() and IsNotNull(self.p_trans_root_alliance_war_state_icon) then
    self.SeasonWarTimeReq = self:GameObjectInstantiateAsync(season_alliance_war_state_icon_path, function(req)
      local go = req.gameObject
      local transform = go.transform
      local transRoot = self.p_trans_root_alliance_war_state_icon.transform
      transform:SetParent(transRoot)
      transform:Set_localScale(1, 1, 1)
      transform:Set_localPosition(0, 0, 0)
      local comp = self:AddComponent(SeasonAllianceWarTimeStateIconComp, go)
      local data = {}
      data.AllianceId = self.allianceId
      comp:ReInit(data)
    end)
  end
end

function UIAllianceDetailView:OnReportBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatReport, {anim = true}, {
    type = ReportType.alliance,
    allianceId = self.allianceId,
    allinceName = self.data.allianceName
  })
end

local function OnDestroy(self)
  if self.SeasonWarTimeReq ~= nil then
    self:GameObjectDestroy(self.SeasonWarTimeReq)
    self.SeasonWarTimeReq = nil
  end
  self.invite_icon = nil
  self.invite_button = nil
  self.invite_text = nil
  self.name = nil
  self.p_trans_root_alliance_war_state_icon = nil
  self.textStar = nil
  self.starItem = nil
  self.cp_txt = nil
  self.leader = nil
  self.leader_txt = nil
  self.land = nil
  self.land_txt = nil
  self.gift = nil
  self.gift_txt = nil
  self.people = nil
  self.people_txt = nil
  self.des_txt = nil
  self.item_prefab = nil
  self.join_set_tip = nil
  self.level_set_txt = nil
  self.power_set_txt = nil
  self.career_set_tip = nil
  self.career_set_txt = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

function UIAllianceDetailView:OnAllianceAnnouncementTranslateFinish(data)
  local alInfos = self.view.ctrl:GetAllianceData(self.allianceId)
  if alInfos.uid == data.uid then
    self:OnTranslateFinish(data)
  end
end

function UIAllianceDetailView:OnAllianceAnnouncementTitleTranslateFinish(data)
  local alInfos = self.view.ctrl:GetAllianceData(self.allianceId)
  if alInfos.uid == data.uid then
    self:OnTranslateFinish(data)
  end
end

function UIAllianceDetailView:CancleTranslate()
  self:RefreshTranslateBtnUIShow(true)
  self:RefreshTranslateBtnRootUIShow(true)
  self:RefreshTranslateScrollRootUIShow(1)
end

local function OnRefresh(self)
  self.data = self.view.ctrl:GetAllianceData(self.allianceId)
  if self.data then
    self.name:SetText("<" .. self.data.abbr .. "> " .. self.data.allianceName)
    self.cp_txt:SetText(string.GetFormattedSeperatorNum(self.data.fightPower))
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.data.leaderUid, self.data.leaderName)
    local leaderName = self.data.leaderUid == "" and Localization:GetString("100206") or showName
    self.leader_txt:SetText(leaderName)
    local languageId = self.data.language == "" and 115600 or self.data.language
    self.land_txt:SetLocalText(languageId)
    self.gift_txt:SetLocalText(300665, self.data.giftLevel)
    self.people_txt:SetText(self.data.curMember .. "/" .. self.data.maxMember)
    if self.data.announce ~= nil and self.data.announce ~= "" then
      self.des_txt:SetText(self.data.announce)
    else
      self.des_txt:SetLocalText(390118)
    end
    if self.data.icon then
      self.AllianceFlag:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(self.data.icon)))
    end
    if self.data.comprehensiveScore then
      self.starItem:RefreshByBaseInfo(self.data)
    else
      self.starItem:RefreshByBaseInfo({comprehensiveScore = 0})
    end
    local nationTemplate = self.data:GetCountryFlagTemplate()
    self.countryFlagN:LoadSprite(nationTemplate:GetNationFlagPath())
    if 0 < self.data.castleRestrictionN or 0 < self.data.powerRestrictionN then
      if 0 < self.data.castleRestrictionN then
        self.level_set_txt:SetActive(true)
        self.level_set_txt:SetText(Localization:GetString("100082") .. " > " .. self.data.castleRestrictionN)
      else
        self.level_set_txt:SetActive(false)
      end
      if 0 < self.data.powerRestrictionN then
        self.power_set_txt:SetActive(true)
        self.power_set_txt:SetText(Localization:GetString("100644") .. " > " .. string.GetFormattedSeperatorNum(self.data.powerRestrictionN))
      else
        self.power_set_txt:SetActive(false)
      end
    else
      self.power_set_txt:SetActive(true)
      self.power_set_txt:SetLocalText(390797)
      self.level_set_txt:SetActive(false)
    end
    if DataCenter.PlayerCareerManager:Enabled() and not table.IsNullOrEmpty(self.data.lookForCareers) then
      self.career_set_tip:SetActive(true)
      self.career_set_txt:SetActive(true)
      self.career_set_txt:SetText(DataCenter.PlayerCareerManager:ConvertCareerName(self.data.lookForCareers))
    else
      self.career_set_tip:SetActive(false)
      self.career_set_txt:SetActive(false)
    end
    self.commentBtnImg:SetActive(LuaEntry.Player:IsInSourceServer() and LuaEntry.Player:IsInSelfServer())
    self.commentBtnImg:LoadSprite("Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/zyf_tongmengxinxi_lianmengshenqing.png")
    if LuaEntry.Player:IsInAlliance() then
      self.comment_txt:SetLocalText(390009)
    elseif self.data.applied == 1 then
      self.commentBtnImg:LoadSprite("Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/zyf_tongmengxinxi_lianmengshenqing.png")
      self.comment_txt:SetLocalText(GameDialogDefine.CANCEL)
    elseif self.data.recruitTotal == 0 then
      self.comment_txt:SetLocalText(110037)
    else
      self.comment_txt:SetLocalText(110090)
    end
    self:InitInviteBtn()
  else
    self.name:SetText("")
    self.cp_txt:SetText("0")
    self.leader_txt:SetText("")
    self.land_txt:SetText("")
    self.gift_txt:SetText("")
    self.people_txt:SetText("0/0")
    self.des_txt:SetText("")
    self.level_set_txt:SetText("")
    self.power_set_txt:SetText("")
    local nationTemplate = DataCenter.NationTemplateManager:GetNationTemplate(DefaultNation)
    self.countryFlagN:LoadSprite(nationTemplate:GetNationFlagPath())
  end
  self:JudgeTranslate()
end

function UIAllianceDetailView:JudgeTranslate()
  local alInfos = self.data
  local msg = alInfos.translateMsg
  local transTitle = alInfos:GetAnnounceTitle()
  local defaultTitle = self.des_title_txt:GetOriginalText()
  local titleTranslateFinish = false
  if not string.IsNullOrEmpty(defaultTitle) then
    if string.IsNullOrEmpty(transTitle) then
      titleTranslateFinish = false
    else
      titleTranslateFinish = true
    end
  else
    titleTranslateFinish = true
  end
  if string.IsNullOrEmpty(self.des_txt:GetOriginalText()) then
    self:RefreshTranslateBtnRootUIShow(false)
  end
  if not string.IsNullOrEmpty(msg) and titleTranslateFinish then
    self.translateDescribe:SetText(msg)
    self.translateDescTitle:SetText(transTitle)
    self:RefreshTranslateBtnUIShow(false)
    self:RefreshTranslateBtnRootUIShow(true)
    self:RefreshTranslateScrollRootUIShow(2)
    return
  end
  self:RefreshTranslateScrollRootUIShow(1)
end

function UIAllianceDetailView:OnTranslateFinish(alInfos)
  local transTitle = alInfos:GeTranstAnnounceTitle()
  local transMsg = alInfos:GetTranslationMsg()
  local transTitling = alInfos:GetAnnounceTitleTranslateing()
  local transMsgDoing = alInfos:GetIsTranslating()
  if not transMsgDoing and not transTitling then
    self.translateDescribe:SetText(transMsg)
    self.translateDescTitle:SetText(transTitle)
    self:RefreshTranslateBtnUIShow(false)
    self:RefreshTranslateBtnRootUIShow(true)
    self:RefreshTranslateScrollRootUIShow(2)
    return true
  end
  return false
end

function UIAllianceDetailView:OnTranslateBtnClick(dataInfo)
  local info = dataInfo or self
  local data = info.data
  local id = info.allianceId
  local transTitle = data:GetAnnounceTitle()
  local transDesc = data:GetTranslationMsg()
  local defaultTitle = info.des_title_txt:GetOriginalText()
  local transTitling = data:GetAnnounceTitleTranslateing()
  local transMsgDoing = data:GetIsTranslating()
  if transMsgDoing or transTitling then
    return
  end
  if not string.IsNullOrEmpty(transDesc) then
    self:OnTranslateFinish(data)
    return
  end
  if not string.IsNullOrEmpty(defaultTitle) and string.IsNullOrEmpty(transTitle) then
    self.view.ctrl:TranslateAnnounceDescTitle(id, defaultTitle)
  end
  if string.IsNullOrEmpty(transDesc) then
    local desc
    if data.announce ~= nil and data.announce ~= "" then
      desc = data.announce
    end
    if desc then
      self.view.ctrl:TranslateAnnounceDesc(id, desc)
    end
  end
  self:RefreshTranslateScrollRootUIShow(3)
  self:RefreshTranslateBtnRootUIShow(false)
end

function UIAllianceDetailView:RefreshTranslateScrollRootUIShow(index)
  self.defaultAnnounceScroll.gameObject:SetActive(index == 1)
  self.translateScroll.gameObject:SetActive(index == 2)
  self.translatingScroll.gameObject:SetActive(index == 3)
end

function UIAllianceDetailView:RefreshTranslateBtnRootUIShow(show)
  self.transBtnRoot.gameObject:SetActive(show)
end

function UIAllianceDetailView:RefreshTranslateBtnUIShow(show)
  self.translateBtn.gameObject:SetActive(show)
  self.translateFinishBtn.gameObject:SetActive(not show)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.SearchAllianceSuccess, self.OnRefresh)
  self:AddUIListener(EventId.AllianceBaseDataUpdated, self.OnRefresh)
  self:AddUIListener(EventId.SearchAllianceError, self.onSearchAllianceError)
  self:AddUIListener(EventId.AllianceAnnouncementTranslateFinish, self.OnAllianceAnnouncementTranslateFinish)
  self:AddUIListener(EventId.AllianceAnnouncementTitleTranslateFinish, self.OnAllianceAnnouncementTitleTranslateFinish)
  self:AddUIListener(EventId.CLICK_ALLIANCE_ITEM, self.OnRefresh)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.SearchAllianceSuccess, self.OnRefresh)
  self:RemoveUIListener(EventId.AllianceBaseDataUpdated, self.OnRefresh)
  self:RemoveUIListener(EventId.SearchAllianceError, self.onSearchAllianceError)
  self:RemoveUIListener(EventId.AllianceAnnouncementTranslateFinish, self.OnAllianceAnnouncementTranslateFinish)
  self:RemoveUIListener(EventId.AllianceAnnouncementTitleTranslateFinish, self.OnAllianceAnnouncementTitleTranslateFinish)
  self:RemoveUIListener(EventId.CLICK_ALLIANCE_ITEM, self.OnRefresh)
end

function UIAllianceDetailView:onSearchAllianceError()
  UIUtil.ShowTipsId("E100086")
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceDetail, {anim = true})
end

local function OnMemberClick(self)
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIAllianceMemberDetail) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceMemberDetail)
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceMemberDetail, {anim = true}, self.allianceId, AllianceMemberOpenType.OtherAlMember)
  self.ctrl:CloseSelf()
end

local function OnMailClick(self)
  if not self.data then
    UIUtil.ShowTips(Localization:GetString("E100086"))
    return
  end
  if self.data.leaderUid == LuaEntry.Player.uid then
    UIUtil.ShowTips(Localization:GetString("900508"))
    return
  end
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.data.leaderUid, self.data.leaderName)
  self.ctrl:OnLeaderMailClick(self.data.leaderUid, showName)
end

local function OnClickCommentBtn(self)
  if GMUtils.GetBool(GMConst.DebugClickLogWarning, false) and self.allianceId then
    UIUtil.ShowTips(string.format("\232\129\148\231\155\159id\229\183\178\229\164\141\229\136\182\229\136\176\229\137\170\232\180\180\230\157\191"))
    CommonUtil.CopyTextToClipboard(self.allianceId)
    Logger.Log(self.allianceId)
  end
  if LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId(120018)
  else
    if not self.data then
      UIUtil.ShowTips(Localization:GetString("E100086"))
      return
    end
    if self.data.applied == 1 then
      SFSNetwork.SendMessage(MsgDefines.AlCancelApply, self.allianceId)
      self:OnRefresh()
    else
      local tempType = self.data.recruitTotal == 0 and 0 or 1
      SFSNetwork.SendMessage(MsgDefines.AlApply, self.allianceId, tempType, self.data.language)
      local isEnoughCondition = true
      if 0 < self.data.applyLevelLimit or 0 < self.data.applyPowerLimit then
        local playerPower = LuaEntry.Player.power
        if playerPower < self.data.applyPowerLimit then
          isEnoughCondition = false
        end
        local baseLevel = DataCenter.BuildManager.MainLv
        if baseLevel < self.data.applyLevelLimit then
          isEnoughCondition = false
        end
      end
      if tempType == 1 and isEnoughCondition then
        self:OnRefresh()
      end
    end
  end
end

local function CloseSelf(self)
  self.ctrl:CloseSelf()
end

function UIAllianceDetailView:InitInviteBtn()
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWSeasonMakeFriendsMainUI) then
    self.invite_button:SetActive(false)
    return
  end
  if self.data == nil or LuaEntry.Player.allianceId == self.allianceId then
    self.invite_button:SetActive(false)
    return
  end
  local ownerServerId = self.data.createServer or self.data.ownerServerId
  local seasonInfo = SeasonUtil.GetSeasonInfo(ownerServerId)
  if seasonInfo == nil or not seasonInfo:InNormalMode() then
    self.invite_button:SetActive(false)
    return
  end
  local allyInfo = self.data.allyInfo
  if allyInfo and allyInfo.isAllied and allyInfo.allianceInfo then
    local allianceInfo = allyInfo.allianceInfo
    local name = UIUtil.FormatServerAllianceName(allianceInfo.serverId, allianceInfo.abbr)
    self.invite_text:SetText(name)
    self.invite_icon:SetActive(true)
    self.invite_icon:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, allianceInfo.icon))
    self.invite_button:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/AllyFriendS6/mjc_tongmengxinxi_BG.png")
    self.invite_button:SetActive(true)
    local cfg = DataCenter.SeasonDataManager:GetUserSeasonInfo()
    if cfg then
      local data = cfg:GetWorldChessColorSetting(allianceInfo.serverId, allianceInfo.allianceId)
      if data ~= nil and data.name_color ~= nil then
        self.invite_text:SetColor(data.name_color)
        return
      end
    end
    self.invite_text:SetColor(Color.white)
    return
  end
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local seasonType = seasonInfo:GetServerSubdivisionType(false)
  if seasonInfo:CanAllianceMakeFriends() and seasonInfo:IsInBattleServerGroupInt(mySourceServerId) then
    self.invite_icon:SetActive(false)
    self.invite_button:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/AllyFriendS6/mjc_tongmengxinxi_jiemeng2.png")
    self.invite_text:SetLocalText("s6_alliance_ally_btn01")
    self.invite_text:SetColor(Color.white)
    if SeasonUtil.SeasonHasFactionWar(seasonType) then
      local factionMgr = DataCenter.SeasonFactionWarDataManager
      if ownerServerId == mySourceServerId or factionMgr:IsInSameCampByServer(ownerServerId, mySourceServerId) then
        self.invite_button:SetActive(true)
        DataCenter.SeasonAllyFriendManager:GetAllyCombinedList(true, true, 3000)
      else
        self.invite_button:SetActive(false)
      end
    else
      self.invite_button:SetActive(true)
      DataCenter.SeasonAllyFriendManager:GetAllyCombinedList(true, true, 3000)
    end
  else
    self.invite_button:SetActive(false)
  end
end

function UIAllianceDetailView:OnInviteBtnClick()
  if DataCenter.SeasonAllyFriendManager:HasFriend() then
    if self.allianceId == DataCenter.SeasonAllyFriendManager:GetFriendAllyId() then
      local allyStartTime = DataCenter.SeasonAllyFriendManager.allyStartTime
      if allyStartTime ~= nil and allyStartTime ~= 0 then
        local now = UITimeManager:GetInstance():GetServerTime()
        local day = math.floor((now - allyStartTime) * 0.001 / OneDayTime)
        if 0 < day then
          local strTime = string.format("<size=48>%d</size>", day)
          UIUtil.ShowTips(Localization:GetString("s6_alliance_ally_desc53", strTime))
        end
      end
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceDetail, {anim = true})
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonMakeFriendsMainUI)
      return
    end
    UIUtil.ShowTipsId("season_s6_s_ally_05")
    return
  end
  local allyInfo = self.data.allyInfo
  if allyInfo and allyInfo.isAllied and allyInfo.allianceInfo then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceDetail, {anim = true})
    UIUtil.TryShowAllianceInfo(allyInfo.allianceInfo.serverId, allyInfo.allianceInfo.allianceId, allyInfo.allianceInfo.name)
    return
  end
  local officialPos = DataCenter.AllianceMemberDataManager:GetOfficialPosByUid(LuaEntry.Player.uid)
  if DataCenter.AllianceBaseDataManager:IsR5() or officialPos == LWAlMemberOffcialType.Al_Goddess then
    local applyBaseInfo = DataCenter.SeasonAllyFriendManager:GetRequestData(self.allianceId)
    if applyBaseInfo then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceDetail, {anim = true})
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonMakeFriendsShowInvite, {anim = false}, 1, applyBaseInfo)
      return
    end
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceDetail, {anim = true})
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonMakeFriendsSendInvite, {anim = false}, self.data)
  else
    UIUtil.ShowTipsId("s6_alliance_ally_tips15")
  end
end

UIAllianceDetailView.OnCreate = OnCreate
UIAllianceDetailView.OnDestroy = OnDestroy
UIAllianceDetailView.OnRefresh = OnRefresh
UIAllianceDetailView.OnEnable = OnEnable
UIAllianceDetailView.OnDisable = OnDisable
UIAllianceDetailView.OnAddListener = OnAddListener
UIAllianceDetailView.OnRemoveListener = OnRemoveListener
UIAllianceDetailView.OnMemberClick = OnMemberClick
UIAllianceDetailView.OnMailClick = OnMailClick
UIAllianceDetailView.OnClickCommentBtn = OnClickCommentBtn
UIAllianceDetailView.CloseSelf = CloseSelf
return UIAllianceDetailView
