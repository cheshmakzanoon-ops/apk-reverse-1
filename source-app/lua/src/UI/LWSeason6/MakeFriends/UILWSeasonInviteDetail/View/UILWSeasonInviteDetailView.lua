local UILWSeasonInviteDetailView = BaseClass("UILWSeasonInviteDetailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local TranslateCache = {}
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local content_path = "PopUpTitle/ScrollView/Viewport/Content"
local user_info_path = "PopUpTitle/ScrollView/Viewport/Content/UserInfo"
local user_text_path = "PopUpTitle/ScrollView/Viewport/Content/UserInfo/UserText"
local bg_path = "PopUpTitle/ScrollView/Viewport/Content/UserInfo/bg"
local invite_text_path = "PopUpTitle/ScrollView/Viewport/Content/UserInfo/bg/InviteText"
local line_trans_path = "PopUpTitle/ScrollView/Viewport/Content/UserInfo/bg/lineTrans"
local invite_text_trans_path = "PopUpTitle/ScrollView/Viewport/Content/UserInfo/bg/InviteTextTrans"
local translate_root_path = "PopUpTitle/ScrollView/Viewport/Content/UserInfo/TranslateRoot"
local translating_path = "PopUpTitle/ScrollView/Viewport/Content/UserInfo/TranslateRoot/Translating"
local translate_finish_img_path = "PopUpTitle/ScrollView/Viewport/Content/UserInfo/TranslateRoot/TranslateFinishImg"
local translate_btn_path = "PopUpTitle/ScrollView/Viewport/Content/UserInfo/TranslateRoot/TranslateBtn"
local translate_refresh_btn_path = "PopUpTitle/ScrollView/Viewport/Content/UserInfo/TranslateRoot/TranslateRefreshBtn"
local do_btn_yes_path = "PopUpTitle/DoBtnYes"
local text_yes_path = "PopUpTitle/DoBtnYes/TextYes"
local like_btn_path = "PopUpTitle/ScrollView/Viewport/Content/likeContent/likeBtn"
local like_num_path = "PopUpTitle/ScrollView/Viewport/Content/likeContent/likeBtn/likeNum"
local dislike_btn_path = "PopUpTitle/ScrollView/Viewport/Content/likeContent/dislikeBtn"
local dislike_num_path = "PopUpTitle/ScrollView/Viewport/Content/likeContent/dislikeBtn/dislikeNum"
local like_content_path = "PopUpTitle/ScrollView/Viewport/Content/likeContent"

function UILWSeasonInviteDetailView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.data = self:GetUserData()
  if self.data ~= nil then
    self.applyUuid = self.data.applyId
    self:UpdateData()
  end
end

function UILWSeasonInviteDetailView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonInviteDetailView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("s6_alliance_ally_btn07")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.like_btn = self:AddComponent(UIButton, like_btn_path)
  self.like_num = self:AddComponent(UITextMeshProUGUIEx, like_num_path)
  self.dislike_btn = self:AddComponent(UIButton, dislike_btn_path)
  self.dislike_num = self:AddComponent(UITextMeshProUGUIEx, dislike_num_path)
  self.like_content = self:AddComponent(UIBaseContainer, like_content_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.user_info = self:AddComponent(UIBaseContainer, user_info_path)
  self.user_text = self:AddComponent(UITextMeshProUGUIEx, user_text_path)
  self.bgInviteTxtRoot = self:AddComponent(UIImage, bg_path)
  self.invite_text = self:AddComponent(UITextMeshProUGUIEx, invite_text_path)
  self.line_trans = self:AddComponent(UIImage, line_trans_path)
  self.invite_text_trans = self:AddComponent(UITextMeshProUGUIEx, invite_text_trans_path)
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
  self.do_btn_yes = self:AddComponent(UIButton, do_btn_yes_path)
  self.text_yes = self:AddComponent(UITextMeshProUGUIEx, text_yes_path)
  self.do_btn_yes:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
end

function UILWSeasonInviteDetailView:ComponentDestroy()
  self.like_btn = nil
  self.like_num = nil
  self.like_content = nil
  self.dislike_btn = nil
  self.dislike_num = nil
  self.bgInviteTxtRoot = nil
  self.user_info = nil
  self.content = nil
  self.tips_c_d = nil
  self.do_btn_cancel = nil
  self.user_text = nil
  self.bg = nil
  self.invite_text = nil
  self.line_trans = nil
  self.invite_text_trans = nil
  self.translate_root = nil
  self.translating = nil
  self.translate_finish_img = nil
  self.translate_btn = nil
  self.translate_refresh_btn = nil
  self.do_btn_yes = nil
  self.text_yes = nil
end

function UILWSeasonInviteDetailView:ParseData(mailBody)
  local data = {
    likeCount = 0,
    dislikeCount = 0,
    content = ""
  }
  local rapidjson = require("rapidjson")
  local MailParseHelper = require("DataCenter.MailData.MailParseHelper")
  local tabBody = rapidjson.decode(mailBody)
  if tabBody ~= nil and tabBody.b ~= nil then
    data.content = MailParseHelper:DecodeMessage(tabBody.b.content, tabBody.b.extra)
    if tabBody.b.content and tabBody.b.content.dialog and tabBody.b.content.dialog.params then
      local targetAlliance = tabBody.b.content.dialog.params[1]
      if targetAlliance then
        data.targetAlliance = targetAlliance.alliance
      end
      if tabBody.b.mailId == 80487 then
        local param2 = tabBody.b.content.dialog.params[2]
        if param2 and param2.user then
          data.applyUser = param2.user
        end
      end
    end
  end
  return data
end

function UILWSeasonInviteDetailView:UpdateData()
  local dataDetail = self.data
  local mailBody = dataDetail.mailBody
  local myAllianceId = LuaEntry.Player.allianceId
  local name, applyUserStr, operatorUserStr
  if dataDetail.logData then
    local subType = toInt(dataDetail.logData.subType)
    if subType == 101 then
      self.dialog_title_text:SetLocalText("mail_title_80487")
    elseif subType == 102 or subType == 103 then
      self.dialog_title_text:SetLocalText("mail_title_80489")
    elseif subType == 100 then
      self.dialog_title_text:SetLocalText("mail_title_80486")
    elseif 200 <= subType then
      self.dialog_title_text:SetLocalText("mail_title_80481")
    end
  end
  if mailBody ~= nil and mailBody ~= "" then
    self.like_content:SetActive(false)
    dataDetail = self:ParseData(dataDetail.mailBody)
    name = UIUtil.FormatServerAllianceName(dataDetail.targetAlliance.serverId, dataDetail.targetAlliance.abbr)
    if dataDetail.title then
      self.user_text:SetText(dataDetail.title)
    else
      self.user_text:SetText("")
    end
  else
    local applyUser = dataDetail.applyUser
    if applyUser then
      applyUserStr = Localization:GetString("s6_ally_status_01", UIUtil.FormatAllianceAndName(applyUser.abbr or applyUser.allianceAbbr, applyUser.name))
    end
    local opUser = dataDetail.operatorUser
    if opUser == nil and dataDetail.logData then
      opUser = dataDetail.logData.operatorUser
    end
    if opUser then
      operatorUserStr = Localization:GetString("s6_ally_status_02", UIUtil.FormatAllianceAndName(opUser.abbr or opUser.allianceAbbr, opUser.name))
    end
    name = UIUtil.FormatServerAllianceName(dataDetail.targetAlliance.serverId, dataDetail.targetAlliance.abbr)
    self.like_content:SetActive(false)
    self.dislike_num:SetText(dataDetail.dislikeCount or "0")
    self.like_num:SetText(dataDetail.likeCount or "0")
    self.user_text:SetLocalText("s6_alliance_ally_desc23", name)
  end
  local inviteUserInfo = {
    message = dataDetail.content or Localization:GetString("s6_alliance_ally_desc26"),
    opposeNum = dataDetail.dislikeCount or 0,
    agreeNum = dataDetail.likeCount or 0
  }
  if applyUserStr ~= nil and operatorUserStr ~= nil then
    self.invite_text:SetText(inviteUserInfo.message .. [[


]] .. applyUserStr .. "\n" .. operatorUserStr)
  elseif applyUserStr ~= nil then
    self.invite_text:SetText(inviteUserInfo.message .. [[


]] .. applyUserStr)
  elseif operatorUserStr ~= nil then
    self.invite_text:SetText(inviteUserInfo.message .. [[


]] .. operatorUserStr)
  else
    self.invite_text:SetText(inviteUserInfo.message)
  end
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
  self.dislike_num:SetText(inviteUserInfo.opposeNum)
  self.like_num:SetText(inviteUserInfo.agreeNum)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bgInviteTxtRoot.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.user_info.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
end

function UILWSeasonInviteDetailView:DoTranslate()
  local msg = self.user_invite_message
  if not string.IsNullOrEmpty(msg) then
    self.translating:SetActive(true)
    self.translate_finish_img:SetActive(false)
    self.translate_btn:SetActive(false)
    local sendAllianceId = self.allianceId
    local userLang = CS.GameEntry.Localization:GetLanguage()
    ChatManager2:GetInstance().Translate:Translate(msg, "", "", function(ok, data)
      if data ~= nil and ok == true and self.user_info ~= nil and sendAllianceId == self.allianceId and msg == self.user_invite_message and not string.IsNullOrEmpty(data.translateMsg) then
        self.line_trans:SetActive(true)
        self.invite_text_trans:SetActive(true)
        self.invite_text_trans:SetText(data.translateMsg)
        self.translating:SetActive(false)
        self.translate_finish_img:SetActive(true)
        self.translate_btn:SetActive(false)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bgInviteTxtRoot.rectTransform)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.user_info.rectTransform)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
        if msg and TranslateCache[msg] == nil then
          TranslateCache[msg] = data.translateMsg
        end
      end
    end, userLang, nil)
  end
end

return UILWSeasonInviteDetailView
