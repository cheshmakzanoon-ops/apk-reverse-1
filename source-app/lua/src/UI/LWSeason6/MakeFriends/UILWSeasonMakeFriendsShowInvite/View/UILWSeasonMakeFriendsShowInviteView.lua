local UILWSeasonMakeFriendsShowInviteView = BaseClass("UILWSeasonMakeFriendsShowInviteView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local ShowInviteItem = require("UI.LWSeason6.MakeFriends.UILWSeasonMakeFriendsShowInvite.Component.UILWSeasonMakeFriendsShowInviteItem")
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
local condition_list_path = "PopUpTitle/ScrollView/Viewport/Content/ConditionList"
local condition1_path = "PopUpTitle/ScrollView/Viewport/Content/Condition1"
local tick1_path = "PopUpTitle/ScrollView/Viewport/Content/Condition1/tick1"
local title1_path = "PopUpTitle/ScrollView/Viewport/Content/Condition1/title1"
local condition2_path = "PopUpTitle/ScrollView/Viewport/Content/Condition2"
local tick2_path = "PopUpTitle/ScrollView/Viewport/Content/Condition2/tick2"
local title2_path = "PopUpTitle/ScrollView/Viewport/Content/Condition2/title2"
local condition3_path = "PopUpTitle/ScrollView/Viewport/Content/Condition3"
local tick3_path = "PopUpTitle/ScrollView/Viewport/Content/Condition3/tick3"
local title3_path = "PopUpTitle/ScrollView/Viewport/Content/Condition3/title3"
local condition4_path = "PopUpTitle/ScrollView/Viewport/Content/Condition4"
local tick4_path = "PopUpTitle/ScrollView/Viewport/Content/Condition4/tick4"
local title4_path = "PopUpTitle/ScrollView/Viewport/Content/Condition4/title4"
local do_btn_cancel_path = "PopUpTitle/DoBtnCancel"
local do_btn_no_path = "PopUpTitle/DoBtnNo"
local do_btn_yes_path = "PopUpTitle/DoBtnYes"
local text_no_path = "PopUpTitle/DoBtnNo/TextNo"
local pop_no_path = "PopUpTitle/DoBtnNo/popNo"
local num_no_path = "PopUpTitle/DoBtnNo/popNo/numNo"
local text_yes_path = "PopUpTitle/DoBtnYes/TextYes"
local pop_yes_path = "PopUpTitle/DoBtnYes/popYes"
local num_yes_path = "PopUpTitle/DoBtnYes/popYes/numYes"
local tips_c_d_path = "PopUpTitle/TipsCD"
local like_btn_path = "PopUpTitle/ScrollView/Viewport/Content/likeContent/likeBtn"
local like_num_path = "PopUpTitle/ScrollView/Viewport/Content/likeContent/likeBtn/likeNum"
local dislike_btn_path = "PopUpTitle/ScrollView/Viewport/Content/likeContent/dislikeBtn"
local dislike_num_path = "PopUpTitle/ScrollView/Viewport/Content/likeContent/dislikeBtn/dislikeNum"

function UILWSeasonMakeFriendsShowInviteView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.title1:SetLocalText("s6_alliance_ally_tips16")
  self.title2:SetLocalText("s6_alliance_ally_tips17")
  self.title3:SetLocalText("s6_alliance_ally_tips18")
  self.title4:SetLocalText("s6_alliance_ally_tips19")
  self.dataType, self.data = self:GetUserData()
  if self.data ~= nil and (self.dataType == 1 or self.dataType == 2) then
    self.allianceId = self.data.allianceUid
    self.applyUuid = self.data.applyBaseInfo.applyUuid
    self.do_btn_no:SetActive(self.dataType == 2)
    self.do_btn_yes:SetActive(self.dataType == 2)
    self.do_btn_cancel:SetActive(self.dataType == 1)
    self.like_btn:SetActive(self.dataType == 2)
    self.dislike_btn:SetActive(self.dataType == 2)
    if self.dataType == 1 then
      local _officialPos = DataCenter.AllianceMemberDataManager:GetOfficialPosByUid(LuaEntry.Player.uid)
      if DataCenter.AllianceBaseDataManager:IsR5() or _officialPos == LWAlMemberOffcialType.Al_Goddess then
        CS.UIGray.SetGray(self.do_btn_cancel.transform, false, true)
      else
        CS.UIGray.SetGray(self.do_btn_cancel.transform, true, true)
      end
      self.tips_c_d:SetLocalPositionXYZ(0, -483)
    else
      self.tips_c_d:SetLocalPositionXYZ(155, -483)
    end
    DataCenter.SeasonAllyFriendManager:GetRequestDetail(self.applyUuid, true, true)
    local allianceInfo = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(self.allianceId)
    if allianceInfo == nil then
      SFSNetwork.SendMessage(MsgDefines.GetAllianceInfo, self.allianceId)
    else
      self:UpdateData()
    end
  end
end

function UILWSeasonMakeFriendsShowInviteView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMakeFriendsShowInviteView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SearchAllianceSuccess, self.UpdateData)
  self:AddUIListener(EventId.MFAllyRequestDetailUpdate, self.UpdateData)
end

function UILWSeasonMakeFriendsShowInviteView:OnRemoveListener()
  self:RemoveUIListener(EventId.SearchAllianceSuccess, self.UpdateData)
  self:RemoveUIListener(EventId.MFAllyRequestDetailUpdate, self.UpdateData)
  base.OnRemoveListener(self)
end

function UILWSeasonMakeFriendsShowInviteView:ComponentDefine()
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
  self.tips_c_d = self:AddComponent(UITextMeshProUGUIEx, tips_c_d_path)
  self.do_btn_cancel = self:AddComponent(UIButton, do_btn_cancel_path)
  self.condition_list = self:AddComponent(UITextMeshProUGUIEx, condition_list_path)
  self.condition1 = self:AddComponent(UIImage, condition1_path)
  self.tick1 = self:AddComponent(UIImage, tick1_path)
  self.title1 = self:AddComponent(UITextMeshProUGUIEx, title1_path)
  self.condition2 = self:AddComponent(UIImage, condition2_path)
  self.tick2 = self:AddComponent(UIImage, tick2_path)
  self.title2 = self:AddComponent(UITextMeshProUGUIEx, title2_path)
  self.condition3 = self:AddComponent(UIImage, condition3_path)
  self.tick3 = self:AddComponent(UIImage, tick3_path)
  self.title3 = self:AddComponent(UITextMeshProUGUIEx, title3_path)
  self.condition4 = self:AddComponent(UIImage, condition4_path)
  self.tick4 = self:AddComponent(UIImage, tick4_path)
  self.title4 = self:AddComponent(UITextMeshProUGUIEx, title4_path)
  self.do_btn_no = self:AddComponent(UIButton, do_btn_no_path)
  self.do_btn_yes = self:AddComponent(UIButton, do_btn_yes_path)
  self.text_no = self:AddComponent(UITextMeshProUGUIEx, text_no_path)
  self.pop_no = self:AddComponent(UIImage, pop_no_path)
  self.num_no = self:AddComponent(UITextMeshProUGUIEx, num_no_path)
  self.text_yes = self:AddComponent(UITextMeshProUGUIEx, text_yes_path)
  self.pop_yes = self:AddComponent(UIImage, pop_yes_path)
  self.num_yes = self:AddComponent(UITextMeshProUGUIEx, num_yes_path)
  self.do_btn_no:SetOnClick(BindCallback(self, self.OnReject))
  self.do_btn_yes:SetOnClick(BindCallback(self, self.OnAccept))
  self.do_btn_cancel:SetOnClick(BindCallback(self, self.OnCancel))
  self.do_btn_no:SetSafeClickMode(true)
  self.do_btn_yes:SetSafeClickMode(true)
  self.do_btn_cancel:SetSafeClickMode(true)
  CS.UIGray.SetGray(self.do_btn_no.transform, true, false)
  CS.UIGray.SetGray(self.do_btn_yes.transform, true, false)
  self.pop_no:SetActive(false)
  self.pop_yes:SetActive(false)
  self.like_btn:SetActive(false)
  self.dislike_btn:SetActive(false)
  self.like_btn:SetOnClick(BindCallback(self, self.OnClickLike))
  self.dislike_btn:SetOnClick(BindCallback(self, self.OnClickDisLike))
  self.dislike_num:SetText("0")
  self.like_num:SetText("0")
end

function UILWSeasonMakeFriendsShowInviteView:ComponentDestroy()
  self.like_btn = nil
  self.like_num = nil
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
  self.condition_list = nil
  self.condition1 = nil
  self.tick1 = nil
  self.title1 = nil
  self.condition2 = nil
  self.tick2 = nil
  self.title2 = nil
  self.condition3 = nil
  self.tick3 = nil
  self.title3 = nil
  self.condition4 = nil
  self.tick4 = nil
  self.title4 = nil
  self.do_btn_no = nil
  self.do_btn_yes = nil
  self.text_no = nil
  self.pop_no = nil
  self.num_no = nil
  self.text_yes = nil
  self.pop_yes = nil
  self.num_yes = nil
end

function UILWSeasonMakeFriendsShowInviteView:Update1000MS()
  if self.inviteEndTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = self.inviteEndTime - curTime
    if 0 < deltaTime then
      local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
      self.tips_c_d:SetLocalText("s6_alliance_ally_desc30", showTime)
    else
      self.tips_c_d:SetLocalText("390843")
      self.inviteEndTime = nil
    end
  end
end

function UILWSeasonMakeFriendsShowInviteView:UpdateData()
  local allianceInfo = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(self.allianceId)
  if allianceInfo == nil then
    self.tips_c_d:SetText("")
    return
  end
  local dataDetail = DataCenter.SeasonAllyFriendManager:GetRequestDetail(self.applyUuid, false, false)
  if dataDetail == nil then
    self.tips_c_d:SetText("")
    return
  end
  local inviteUserInfo = {
    message = dataDetail.content or Localization:GetString("s6_alliance_ally_desc26"),
    opposeNum = dataDetail.dislikeCount or 0,
    agreeNum = dataDetail.likeCount or 0
  }
  if inviteUserInfo.message == nil or inviteUserInfo.message == "" then
    inviteUserInfo.message = Localization:GetString("s6_alliance_ally_desc26")
  end
  self.inviteEndTime = dataDetail.expireTime
  self.invite_text:SetText(inviteUserInfo.message or "")
  if self.dataType == 1 then
    self.user_text:SetLocalText("s6_alliance_ally_desc23", allianceInfo:GetAllianceServerName())
    self.dialog_title_text:SetLocalText("s6_alliance_ally_desc69", LuaEntry.Player:GetAllianceAbbr())
  else
    self.user_text:SetLocalText("s6_alliance_ally_desc23", LuaEntry.Player:GetFullAllianceName())
    self.dialog_title_text:SetLocalText("s6_alliance_ally_desc69", allianceInfo:GetAllianceServerName())
  end
  for index, status in pairs(dataDetail.condition) do
    local conditionNode = self["condition" .. index]
    local tickNode = self["tick" .. index]
    local textNode = self["title" .. index]
    if conditionNode and tickNode then
      if status then
        textNode:SetColorHex("#099b4a")
        tickNode:SetColorHex("#7dd7aa")
        tickNode:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/AllyFriendS6/mjc_TMJM_biaoji_duigou.png")
      else
        textNode:SetColorHex("#f53c3d")
        tickNode:SetColorHex("#f0a0a0")
        tickNode:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/AllyFriendS6/mjc_TMJM_biaoji_cha.png")
      end
    end
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
  self.num_no:SetText(inviteUserInfo.opposeNum)
  self.pop_no:SetActive(false)
  self.num_yes:SetText(inviteUserInfo.agreeNum)
  self.pop_yes:SetActive(false)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bgInviteTxtRoot.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.user_info.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  if self.dataType == 2 then
    local _officialPos = DataCenter.AllianceMemberDataManager:GetOfficialPosByUid(LuaEntry.Player.uid)
    if DataCenter.AllianceBaseDataManager:IsR5() or _officialPos == LWAlMemberOffcialType.Al_Goddess then
      CS.UIGray.SetGray(self.do_btn_no.transform, false, true)
      CS.UIGray.SetGray(self.do_btn_yes.transform, false, true)
    else
      CS.UIGray.SetGray(self.do_btn_no.transform, true, true)
      CS.UIGray.SetGray(self.do_btn_yes.transform, true, true)
    end
  end
  self:Update1000MS()
end

function UILWSeasonMakeFriendsShowInviteView:OnClickLike()
  local dataDetail = DataCenter.SeasonAllyFriendManager:GetRequestDetail(self.applyUuid, false, false)
  if dataDetail == nil then
    UIUtil.ShowTipsId("avatar_tips006")
    return
  end
  if dataDetail.myVote ~= 1 then
    SFSNetwork.SendMessage(MsgDefines.VoteAllianceAllyApply, self.applyUuid, 1)
    UIUtil.ShowTipsId("s6_alliance_ally_tips21")
  else
    SFSNetwork.SendMessage(MsgDefines.VoteAllianceAllyApply, self.applyUuid, 0)
    UIUtil.ShowTipsId("s6_alliance_ally_tips23")
  end
end

function UILWSeasonMakeFriendsShowInviteView:OnClickDisLike()
  local dataDetail = DataCenter.SeasonAllyFriendManager:GetRequestDetail(self.applyUuid, false, false)
  if dataDetail == nil then
    UIUtil.ShowTipsId("avatar_tips006")
    return
  end
  if dataDetail.myVote ~= 2 then
    SFSNetwork.SendMessage(MsgDefines.VoteAllianceAllyApply, self.applyUuid, 2)
    UIUtil.ShowTipsId("s6_alliance_ally_tips22")
  else
    SFSNetwork.SendMessage(MsgDefines.VoteAllianceAllyApply, self.applyUuid, 0)
    UIUtil.ShowTipsId("s6_alliance_ally_tips23")
  end
end

function UILWSeasonMakeFriendsShowInviteView:OnReject()
  local allianceInfo = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(self.allianceId)
  if allianceInfo == nil then
    UIUtil.ShowTipsId("avatar_tips006")
    return
  end
  local dataDetail = DataCenter.SeasonAllyFriendManager:GetRequestDetail(self.applyUuid, false, false)
  if dataDetail == nil then
    UIUtil.ShowTipsId("avatar_tips006")
    return
  end
  local applyId = self.applyUuid
  local isManager = false
  local _officialPos = DataCenter.AllianceMemberDataManager:GetOfficialPosByUid(LuaEntry.Player.uid)
  if DataCenter.AllianceBaseDataManager:IsR5() or _officialPos == LWAlMemberOffcialType.Al_Goddess then
    isManager = true
  else
    UIUtil.ShowTipsId("s6_alliance_ally_tips15")
    return
  end
  local name = UIUtil.FormatServerAllianceName(allianceInfo.createServer or allianceInfo.ownerServerId, allianceInfo.abbr, nil)
  local param = {}
  param.tipText = Localization:GetString("s6_alliance_ally_desc32", name)
  param.btnNum = 2
  param.showToggle = false
  param.delayConfirm = {delayTime = 10}
  
  function param.sureAction()
    SFSNetwork.SendMessage(MsgDefines.ApplyAllianceAllyRequest, applyId, 2)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonMakeFriendsShowInvite)
  end
  
  UIUtil.ShowSecondMessageByParam(param)
end

function UILWSeasonMakeFriendsShowInviteView:OnCancel()
  local applyId = self.applyUuid
  local _officialPos = DataCenter.AllianceMemberDataManager:GetOfficialPosByUid(LuaEntry.Player.uid)
  if DataCenter.AllianceBaseDataManager:IsR5() or _officialPos == LWAlMemberOffcialType.Al_Goddess then
    local msg = Localization:GetString("s6_alliance_ally_desc57")
    UIUtil.ShowMessage(msg, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      SFSNetwork.SendMessage(MsgDefines.CancelAllianceAllyApply, applyId)
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonMakeFriendsShowInvite)
    end)
  else
    UIUtil.ShowTipsId("s6_alliance_ally_tips15")
  end
end

function UILWSeasonMakeFriendsShowInviteView:OnAccept()
  local allianceInfo = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(self.allianceId)
  if allianceInfo == nil then
    UIUtil.ShowTipsId("avatar_tips006")
    return
  end
  local dataDetail = DataCenter.SeasonAllyFriendManager:GetRequestDetail(self.applyUuid, false, false)
  if dataDetail == nil then
    UIUtil.ShowTipsId("avatar_tips006")
    return
  end
  local applyId = self.applyUuid
  local isManager = false
  local _officialPos = DataCenter.AllianceMemberDataManager:GetOfficialPosByUid(LuaEntry.Player.uid)
  if DataCenter.AllianceBaseDataManager:IsR5() or _officialPos == LWAlMemberOffcialType.Al_Goddess then
    isManager = true
  else
    UIUtil.ShowTipsId("s6_alliance_ally_tips15")
    return
  end
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local name1 = UIUtil.FormatServerAllianceName(allianceInfo.createServer or allianceInfo.ownerServerId, allianceInfo.abbr, nil)
  local name2 = LuaEntry.Player:GetFullAllianceName()
  local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if data ~= nil and data.abbr ~= nil and data.abbr ~= "" then
    name2 = UIUtil.FormatServerAllianceName(mySourceServerId, data.abbr)
  end
  local param = {}
  param.tipText = Localization:GetString("s6_alliance_ally_desc33", name1, name2)
  param.btnNum = 2
  param.showToggle = false
  param.delayConfirm = {delayTime = 10}
  
  function param.sureAction()
    SFSNetwork.SendMessage(MsgDefines.ApplyAllianceAllyRequest, applyId, 1)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonMakeFriendsShowInvite)
  end
  
  UIUtil.ShowSecondMessageByParam(param)
end

function UILWSeasonMakeFriendsShowInviteView:DoTranslate()
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

return UILWSeasonMakeFriendsShowInviteView
