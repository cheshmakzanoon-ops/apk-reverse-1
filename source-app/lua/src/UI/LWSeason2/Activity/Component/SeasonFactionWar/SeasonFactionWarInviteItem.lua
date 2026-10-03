local SeasonFactionWarInviteItem = BaseClass("SeasonFactionWarInviteItem", UIBaseContainer)
local base = UIBaseContainer
local TranslateCache = {}
local Localization = CS.GameEntry.Localization
local SeasonFactionWarAliList = require("UI.LWSeason2.Activity.Component.SeasonFactionWar.SeasonFactionWarAliList")
local title_text_path = "TitleText"
local time_text_path = "TimeText"
local icon1_path = "icon1"
local score1_path = "icon1/score1"
local icon2_path = "icon2"
local score2_path = "icon2/score2"
local ali_list_path = "AliList"
local desc_text_path = "DescText"
local user_info_path = "UserInfo"
local ui_player_head_path = "UserInfo/UIPlayerHead"
local user_text_path = "UserInfo/UserText"
local invite_text_path = "UserInfo/bg/InviteText"
local bg_path = "UserInfo/bg"
local line_trans_path = "UserInfo/bg/lineTrans"
local invite_text_trans_path = "UserInfo/bg/InviteTextTrans"
local translate_root_path = "UserInfo/TranslateRoot"
local translating_path = "UserInfo/TranslateRoot/Translating"
local translate_finish_img_path = "UserInfo/TranslateRoot/TranslateFinishImg"
local translate_btn_path = "UserInfo/TranslateRoot/TranslateBtn"
local translate_refresh_btn_path = "UserInfo/TranslateRoot/TranslateRefreshBtn"
local do_btn_no_path = "DoBtnNo"
local do_btn_yes_path = "DoBtnYes"
local pop_no_path = "DoBtnNo/popNo"
local num_no_path = "DoBtnNo/popNo/numNo"
local pop_yes_path = "DoBtnYes/popYes"
local num_yes_path = "DoBtnYes/popYes/numYes"

function SeasonFactionWarInviteItem:OnCreate()
  base.OnCreate(self)
  self.translate_root = self:AddComponent(UIBaseContainer, translate_root_path)
  self.translating = self:AddComponent(UIImage, translating_path)
  self.translate_finish_img = self:AddComponent(UIImage, translate_finish_img_path)
  self.translate_btn = self:AddComponent(UIButton, translate_btn_path)
  self.translate_refresh_btn = self:AddComponent(UIButton, translate_refresh_btn_path)
  self.translate_root:SetActive(true)
  self.translate_refresh_btn:SetActive(false)
  self.translate_btn:SetOnClick(function()
    self:DoTranslate()
  end)
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
  self.icon1 = self:AddComponent(UIImage, icon1_path)
  self.score1 = self:AddComponent(UIImage, score1_path)
  self.icon2 = self:AddComponent(UIImage, icon2_path)
  self.score2 = self:AddComponent(UIImage, score2_path)
  self.ali_list = self:AddComponent(SeasonFactionWarAliList, ali_list_path)
  self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_text_path)
  self.user_info = self:AddComponent(UIBaseContainer, user_info_path)
  self.ui_player_head = self:AddComponent(UICommonHead, ui_player_head_path)
  self.user_text = self:AddComponent(UITextMeshProUGUIEx, user_text_path)
  self.invite_text = self:AddComponent(UITextMeshProUGUIEx, invite_text_path)
  self.bgInviteTxtRoot = self:AddComponent(UIBaseContainer, bg_path)
  self.line_trans = self:AddComponent(UIImage, line_trans_path)
  self.invite_text_trans = self:AddComponent(UITextMeshProUGUIEx, invite_text_trans_path)
  self.do_btn_no = self:AddComponent(UIButton, do_btn_no_path)
  self.do_btn_yes = self:AddComponent(UIButton, do_btn_yes_path)
  self.pop_no = self:AddComponent(UIImage, pop_no_path)
  self.num_no = self:AddComponent(UITextMeshProUGUIEx, num_no_path)
  self.pop_yes = self:AddComponent(UIImage, pop_yes_path)
  self.num_yes = self:AddComponent(UITextMeshProUGUIEx, num_yes_path)
  self.ui_player_head:SetEnableClickShowInfo(true, true)
  self.do_btn_no:SetOnClick(BindCallback(self, self.OnReject))
  self.do_btn_yes:SetOnClick(BindCallback(self, self.OnAccept))
  if DataCenter.SeasonFactionWarDataManager:CampIsAttacker(1) then
    self.icon1:LoadSprite(DataCenter.SeasonFactionWarDataManager:GetCampIcon(2))
    self.icon2:LoadSprite(DataCenter.SeasonFactionWarDataManager:GetCampIcon(1))
  else
    self.icon1:LoadSprite(DataCenter.SeasonFactionWarDataManager:GetCampIcon(1))
    self.icon2:LoadSprite(DataCenter.SeasonFactionWarDataManager:GetCampIcon(2))
  end
  self.do_btn_no:SetSafeClickMode(true)
  self.do_btn_yes:SetSafeClickMode(true)
end

function SeasonFactionWarInviteItem:OnReject()
  local allianceId = self.sendAllianceId
  local info = self.sendAllianceInfo
  if info == nil or allianceId == nil then
    return
  end
  if DataCenter.AllianceBaseDataManager:IsR4orR5() then
    local name = UIUtil.FormatServerAllianceName(info.serverId, info.abbr, info.name)
    local msg = Localization:GetString("season_s2_faction_war_90", name)
    UIUtil.ShowMessage(msg, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      SFSNetwork.SendMessage(MsgDefines.SeasonFactionWarInviteFeedback, allianceId, 2)
    end)
  else
    local msg = Localization:GetString("season_s2_faction_war_64")
    UIUtil.ShowMessage(msg, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      SFSNetwork.SendMessage(MsgDefines.SeasonFactionWarInviteVote, allianceId, 2)
    end)
  end
end

function SeasonFactionWarInviteItem:OnAccept()
  local allianceId = self.sendAllianceId
  local info = self.sendAllianceInfo
  if info == nil or allianceId == nil then
    return
  end
  if DataCenter.AllianceBaseDataManager:IsR4orR5() then
    local name = UIUtil.FormatServerAllianceName(info.serverId, info.abbr, info.name)
    local msg = Localization:GetString("season_s2_faction_war_63", name)
    UIUtil.ShowMessage(msg, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      SFSNetwork.SendMessage(MsgDefines.SeasonFactionWarInviteFeedback, allianceId, 1)
    end)
  else
    local msg = Localization:GetString("season_s2_faction_war_64")
    UIUtil.ShowMessage(msg, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      SFSNetwork.SendMessage(MsgDefines.SeasonFactionWarInviteVote, allianceId, 1)
    end)
  end
end

function SeasonFactionWarInviteItem:OnDestroy()
  self.sendAllianceId = nil
  self.title_text = nil
  self.time_text = nil
  self.icon1 = nil
  self.score1 = nil
  self.icon2 = nil
  self.score2 = nil
  self.ali_list = nil
  self.desc_text = nil
  self.user_info = nil
  self.ui_player_head = nil
  self.user_text = nil
  self.invite_text = nil
  self.do_btn_no = nil
  self.do_btn_yes = nil
  self.pop_no = nil
  self.num_no = nil
  self.pop_yes = nil
  self.num_yes = nil
  self.translate_root = nil
  self.translating = nil
  self.translate_finish_img = nil
  self.translate_btn = nil
  self.translate_refresh_btn = nil
  self.bgInviteTxtRoot = nil
  self.line_trans = nil
  self.invite_text_trans = nil
  base.OnDestroy(self)
end

function SeasonFactionWarInviteItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonFactionWarInviteFeedbackUpdate, self.OnFeedbackUpdate)
  self:AddUIListener(EventId.LWSeasonFactionWarInviteVoteUpdate, self.OnVoteUpdate)
end

function SeasonFactionWarInviteItem:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonFactionWarInviteFeedbackUpdate, self.OnFeedbackUpdate)
  self:RemoveUIListener(EventId.LWSeasonFactionWarInviteVoteUpdate, self.OnVoteUpdate)
  base.OnRemoveListener(self)
end

function SeasonFactionWarInviteItem:OnFeedbackUpdate(t)
  SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionWarVsInfo)
end

function SeasonFactionWarInviteItem:OnVoteUpdate(t)
  if t ~= nil and self.sendAllianceId == t.targetAllianceId then
    self.num_no:SetText(t.opposeNum)
    self.pop_no:SetActive(toInt(t.opposeNum) > 0)
    self.num_yes:SetText(t.agreeNum)
    self.pop_yes:SetActive(0 < toInt(t.agreeNum))
    if t.selfChoose == 1 then
      UIUtil.ShowTipsId("season_s2_faction_war_92")
    elseif t.selfChoose == 2 then
      UIUtil.ShowTipsId("season_s2_faction_war_91")
    end
  end
end

function SeasonFactionWarInviteItem:ReInit(inviteInfo)
  self.sendAllianceInfo = nil
  self.inviteEndTime = nil
  self.sendAllianceId = inviteInfo.sendAllianceId
  local actInfo = DataCenter.SeasonFactionWarDataManager:GetDeclareWarActInfo()
  if actInfo then
    self.currStep = actInfo.currStep
    self.stepEndTime = actInfo.stepEndTime
  end
  self.data = inviteInfo
  if inviteInfo and inviteInfo.defence then
    for i, v in ipairs(inviteInfo.defence) do
      if v.allianceId == inviteInfo.sendAllianceId then
        self.sendAllianceInfo = v
        self.sendAllianceId = inviteInfo.sendAllianceId
      end
    end
  end
  if self.sendAllianceInfo and self.sendAllianceInfo.overTime then
    self.title_text:SetLocalText("season_s2_faction_war_46")
    self.inviteEndTime = self.sendAllianceInfo.overTime
    self:Update1000MS()
  else
    self.title_text:SetText("")
    self.time_text:SetText("")
  end
  if self.data.inviteInfo and self.sendAllianceInfo then
    local inviteUserInfo = self.data.inviteInfo
    self.inviteUserInfo = inviteUserInfo
    if string.IsNullOrEmpty(inviteUserInfo.message) then
      self.user_info:SetActive(false)
    else
      local full_name = UIUtil.FormatServerAllianceName(self.sendAllianceInfo.serverId, self.sendAllianceInfo.abbr, inviteUserInfo.senderUserInfo.name)
      self.user_info:SetActive(true)
      self.ui_player_head:ParseHeadInfo(inviteUserInfo.senderUserInfo)
      self.user_text:SetText(full_name)
      self.invite_text:SetText(inviteUserInfo.message or "")
      local msg = inviteUserInfo.messageTranslate or TranslateCache[inviteUserInfo.message]
      if string.IsNullOrEmpty(msg) then
        self.line_trans:SetActive(false)
        self.invite_text_trans:SetActive(false)
        self.translating:SetActive(false)
        self.translate_finish_img:SetActive(false)
        self.translate_btn:SetActive(true)
        self.user_invite_message = inviteUserInfo.message
      else
        self.line_trans:SetActive(true)
        self.invite_text_trans:SetActive(true)
        self.invite_text_trans:SetText(msg)
        self.translating:SetActive(false)
        self.translate_finish_img:SetActive(true)
        self.translate_btn:SetActive(false)
      end
    end
    local ali_name = UIUtil.FormatServerAllianceName(self.sendAllianceInfo.serverId, self.sendAllianceInfo.abbr, "")
    self.desc_text:SetActive(true)
    self.desc_text:SetLocalText("season_s2_faction_war_98", ali_name, inviteUserInfo.senderUserInfo.name)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bgInviteTxtRoot.rectTransform)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.user_info.rectTransform)
  else
    self.desc_text:SetActive(false)
    self.user_info:SetActive(false)
  end
  if DataCenter.SeasonFactionWarDataManager:CampIsAttacker(1) then
    self.icon1:LoadSprite(DataCenter.SeasonFactionWarDataManager:GetCampIcon(2))
    self.icon2:LoadSprite(DataCenter.SeasonFactionWarDataManager:GetCampIcon(1))
  else
    self.icon1:LoadSprite(DataCenter.SeasonFactionWarDataManager:GetCampIcon(1))
    self.icon2:LoadSprite(DataCenter.SeasonFactionWarDataManager:GetCampIcon(2))
  end
  self.num_no:SetText(self.data.inviteInfo.opposeNum)
  self.pop_no:SetActive(toInt(self.data.inviteInfo.opposeNum) > 0)
  self.num_yes:SetText(self.data.inviteInfo.agreeNum)
  self.pop_yes:SetActive(0 < toInt(self.data.inviteInfo.agreeNum))
  local warServerId = self.sendAllianceInfo.serverId
  local warAllianceId = self.sendAllianceInfo.allianceId
  self.ali_list:SetAutoSizeEnable(true)
  self.ali_list:CanShowInviteWhenEmpty(false)
  self.ali_list:ReInit(inviteInfo.defence, inviteInfo.attack, warServerId, warAllianceId)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.ali_list.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

function SeasonFactionWarInviteItem:DoTranslate()
  local msg = self.user_invite_message
  if not string.IsNullOrEmpty(msg) then
    self.translating:SetActive(true)
    self.translate_finish_img:SetActive(false)
    self.translate_btn:SetActive(false)
    local sendAllianceId = self.sendAllianceId
    local userLang = CS.GameEntry.Localization:GetLanguage()
    ChatManager2:GetInstance().Translate:Translate(msg, "", "", function(ok, data)
      if data ~= nil and ok == true and self.user_info ~= nil and self.sendAllianceId ~= nil and self.inviteUserInfo ~= nil and self.user_info:GetActive() and sendAllianceId == self.sendAllianceId and not string.IsNullOrEmpty(data.translateMsg) then
        self.inviteUserInfo.messageTranslate = data.translateMsg
        self.line_trans:SetActive(true)
        self.invite_text_trans:SetActive(true)
        self.invite_text_trans:SetText(data.translateMsg)
        self.translating:SetActive(false)
        self.translate_finish_img:SetActive(true)
        self.translate_btn:SetActive(false)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bgInviteTxtRoot.rectTransform)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.user_info.rectTransform)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.ali_list.rectTransform)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
        if msg and TranslateCache[msg] == nil then
          TranslateCache[msg] = data.translateMsg
        end
      end
    end, userLang, nil)
  end
end

function SeasonFactionWarInviteItem:Update1000MS()
  if self.inviteEndTime then
    local deltaTime = 0
    local curTime = UITimeManager:GetInstance():GetServerTime()
    deltaTime = self.inviteEndTime - curTime
    if 0 < deltaTime then
      local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
      self.time_text:SetText(showTime)
    else
      self.time_text:SetText("00:00:00")
    end
  end
end

return SeasonFactionWarInviteItem
