local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local base = IChatItemPost
local ChatItemPost_AllianceShareNew = BaseClass("ChatItemPost_AllianceShareNew", base)
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local NoticeIconPath = {
  "Assets/Main/Sprites/UI/LWCommon/Sprite/zxl_tongyong_xiangqing_hei.png",
  "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_common_xiangqing.png"
}
local IconBgPath = {
  "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_erji_dichen_yuanjiao_4.png",
  "Assets/Main/Sprites/UI/LWChat_v2/NightSkin/ChatItems/zyf_jijiefengxiang_diban1.png"
}
local TitleTextColor = {
  {
    Color.New(0.639, 0.596, 0.573, 1),
    Color.New(0.476, 0.525, 0.623)
  },
  {
    Color.white,
    Color.white
  }
}
local NameTextColor = {
  Color.New(0.165, 0.157, 0.188, 1),
  Color.white
}
local IconImgColor = {
  {
    Color.white,
    Color.New(0.83, 0.925, 1, 0.8)
  },
  {
    Color.New(0.902, 0.902, 0.902, 1),
    Color.New(0.692, 0.766, 0.991, 1)
  }
}
local InviteBgImgColor = {
  Color.white,
  Color.New(0.902, 0.902, 0.902, 1)
}
local IconBgImgColor = {
  {
    Color.New(0.953, 0.89, 0.871, 1),
    Color.New(0.671, 0.741, 0.902, 0.8)
  },
  {
    Color.white,
    Color.white
  }
}
local NoticeTextColor = {
  Color.New(0.451, 0.408, 0.388, 1),
  Color.white
}
local RedNoticeTextColor = {
  Color.New(0.961, 0.235, 0.239, 1),
  Color.New(0.976, 0.439, 0.467, 1)
}
local InviteTextColor = Color.New(0.588, 0.282, 0.075, 1)
local AllianceRecommendInfo = require("DataCenter.AllianceData.AllianceRecommendInfo")
local UIAllianceInfoHorizontalPanel = require("UI.UIAlliance.UIAllianceInfo.Component.UIAllianceInfoHorizontalPanel")

function ChatItemPost_AllianceShareNew:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitComponent()
end

function ChatItemPost_AllianceShareNew:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ChatItemPost_AllianceShareNew:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgLeftTitleIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textLeftTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compAllianceInfoPanel = self.viewSkin:AddComponent(self, UIAllianceInfoHorizontalPanel, 3)
  self.compInviteTextPanel = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.textInvite = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compInviteBtnPanel = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.btnInviteInfo = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnInviteInfo:SetOnClick(function()
    self:OnBtnInviteInfoClick()
  end)
  self.btnInviteApply = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnInviteApply:SetOnClick(function()
    self:OnBtnInviteApplyClick()
  end)
  self.compNotEligiblePanel = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.textNotEligible = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textPowerNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.textPower = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.compMainLvContent = self.viewSkin:AddComponent(self, UIBaseComponent, 13)
  self.compPowerContent = self.viewSkin:AddComponent(self, UIBaseComponent, 14)
  self.imgInviteInfoBtn = self.viewSkin:AddComponent(self, UIImage, 15)
  self.imgInviteApplyBtn = self.viewSkin:AddComponent(self, UIImage, 16)
  self.imgTextPanelBg = self.viewSkin:AddComponent(self, UIImage, 17)
  self.imgBgTop = self.viewSkin:AddComponent(self, UIImage, 18)
  self.textInfoBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.textApplyBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 20)
  self.imgFlagBg = self.viewSkin:AddComponent(self, UIImage, 21)
  self.imgDescBg = self.viewSkin:AddComponent(self, UIImage, 22)
  self.textBaseLevel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 23)
  self.textBaseLevelNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 24)
  self.compLeftTitle = self.viewSkin:AddComponent(self, UIBaseComponent, 25)
  self.compRightTitle = self.viewSkin:AddComponent(self, UIBaseComponent, 26)
  self.imgRightTitleIcon = self.viewSkin:AddComponent(self, UIImage, 27)
  self.textRightTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 28)
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 29)
  self.imgNoticeIcon = self.viewSkin:AddComponent(self, UIImage, 30)
  self.btnMore = self.viewSkin:AddComponent(self, UIButton, 31)
  self.btnMore:SetOnClick(function()
    self:OnBtnMoreClick()
  end)
  self.textMoreBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 32)
  self.btnFreedBackInner = self.viewSkin:AddComponent(self, UIButton, 33)
  self.btnFreedBackInner:SetOnClick(function()
    self:OnBtnFreedBackInnerClick()
  end)
  self.textFreedInnerBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 34)
  self.btnFreedBackOuter = self.viewSkin:AddComponent(self, UIButton, 35)
  self.btnFreedBackOuter:SetOnClick(function()
    self:OnBtnFreedBackOuterClick()
  end)
  self.textFreedOuterBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 36)
  self.btnInviteTextPanel = self.viewSkin:AddComponent(self, UIButton, 37)
  self.btnInviteTextPanel:SetOnClick(function()
    self:OnBtnInviteTextPanelClick()
  end)
  self.inviteTextPanelVerticalLayout = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, "ShareItemContent/InviteTextPanel")
  ChatInterface.SetEmojiTextProperty(self.textInvite)
  self.textMoreBtn:SetColor(ChatUIThemeConfig.MoreBtnColor[ChatUIThemeConfig.ChatMode.Normal])
  self.textFreedInnerBtn:SetColor(ChatUIThemeConfig.MoreBtnColor[ChatUIThemeConfig.ChatMode.Normal])
  self.textFreedOuterBtn:SetColor(ChatUIThemeConfig.MoreBtnColor[ChatUIThemeConfig.ChatMode.Normal])
end

function ChatItemPost_AllianceShareNew:ComponentDestroy()
  self.viewSkin = nil
  self.imgLeftTitleIcon = nil
  self.textLeftTitle = nil
  self.compAllianceInfoPanel = nil
  self.compInviteTextPanel = nil
  self.textInvite = nil
  self.compInviteBtnPanel = nil
  self.btnInviteInfo = nil
  self.btnInviteApply = nil
  self.compNotEligiblePanel = nil
  self.textNotEligible = nil
  self.textPowerNum = nil
  self.textPower = nil
  self.compMainLvContent = nil
  self.compPowerContent = nil
  self.imgInviteInfoBtn = nil
  self.imgInviteApplyBtn = nil
  self.imgTextPanelBg = nil
  self.imgBgTop = nil
  self.textInfoBtn = nil
  self.textApplyBtn = nil
  self.imgFlagBg = nil
  self.imgDescBg = nil
  self.textBaseLevel = nil
  self.textBaseLevelNum = nil
  self.compLeftTitle = nil
  self.compRightTitle = nil
  self.imgRightTitleIcon = nil
  self.textRightTitle = nil
  self.imgBg = nil
  self.imgNoticeIcon = nil
  self.btnMore = nil
  self.textMoreBtn = nil
  self.btnFreedBackInner = nil
  self.textFreedInnerBtn = nil
  self.btnFreedBackOuter = nil
  self.textFreedOuterBtn = nil
  self.btnInviteTextPanel = nil
end

function ChatItemPost_AllianceShareNew:DataDefine()
  self.isMyChat = false
  self.isEligible = true
  self.chatData = {}
  self.allianceData = {}
  self.isTextFolding = true
  self.isShowReadMore = false
  self.showFreedBack = false
end

function ChatItemPost_AllianceShareNew:DataDestroy()
  self.isMyChat = nil
  self.isEligible = nil
  self.chatData = nil
  self.allianceData = nil
  self.seqId = nil
  self.roomId = nil
  self.isTextFolding = nil
  self.isShowReadMore = nil
  self.showFreedBack = nil
end

function ChatItemPost_AllianceShareNew:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
end

function ChatItemPost_AllianceShareNew:OnRemoveListener()
  self:RemoveUIListener(EventId.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
  base.OnRemoveListener(self)
end

function ChatItemPost_AllianceShareNew:OnLoaded()
  local chat_data = self:ChatData()
  if chat_data == nil then
    return
  end
  self.seqId = chat_data:getSeqId()
  self.roomId = chat_data.roomId
  self:RefreshPanel(chat_data)
end

function ChatItemPost_AllianceShareNew:OnUpdateMsg(_chatData)
  if not _chatData then
    return
  end
  if _chatData.seqId ~= self.seqId or _chatData.roomId ~= self.roomId then
    return
  end
  self:RefreshPanel(_chatData)
  self:UpdateSize()
end

function ChatItemPost_AllianceShareNew:OnBtnInviteInfoClick()
  if self.chatData then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true}, self.allianceData.alliancename, self.allianceData.allianceId)
  end
end

function ChatItemPost_AllianceShareNew:OnBtnInviteApplyClick()
  if not DataCenter.BuildManager:HasBuildByIdAndLevel(BuildingTypes.LW_BUILD_ALLIANCE_CENTER, 1) then
    UIUtil.ShowTipsId("alliance_err_building")
    return
  end
  if LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId(393092)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.AlApply, self.allianceData.allianceId, 0, self.allianceData.language)
end

function ChatItemPost_AllianceShareNew:OnBtnMoreClick()
  self.isTextFolding = not self.isTextFolding
  self.chatData.isTextFolding = self.isTextFolding
  if self.chatData:GetTranslateState() == TranslateStateType.TranslationCompleted then
    self:RefreshInviteTextPanel(self.chatData:getTranslationMsg())
  else
    self:RefreshInviteTextPanel(self.chatData.extra.introductionEx)
  end
  self:UpdateTextFoldState()
  self:UpdateSize()
end

function ChatItemPost_AllianceShareNew:OnBtnFreedBackInnerClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITransFeedbackView, {anim = true}, self.chatData)
end

function ChatItemPost_AllianceShareNew:OnBtnFreedBackOuterClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITransFeedbackView, {anim = true}, self.chatData)
end

function ChatItemPost_AllianceShareNew:OnBtnInviteTextPanelClick()
  if not self.compInviteTextPanel:GetActive() then
    return
  end
  if self.isMyChat then
    return
  end
  self.frame:ShowChatOperator()
end

function ChatItemPost_AllianceShareNew:InitComponent()
  self.textLeftTitle:SetLocalText("alliance_inviteLink_title")
  self.textRightTitle:SetLocalText("alliance_inviteLink_title")
  self.textInfoBtn:SetLocalText("393089")
  self.textNotEligible:SetLocalText("alliance_system001")
  self.textPower:SetText(Localization:GetString("alliance_system002") .. " \226\137\165 ")
  self.textBaseLevel:SetText(Localization:GetString("alliance_system003") .. " \226\137\165 ")
  self.textFreedInnerBtn:SetLocalText("translate_feedback_btn")
  self.textFreedOuterBtn:SetLocalText("translate_feedback_btn")
end

function ChatItemPost_AllianceShareNew:RefreshPanel(chatData)
  local chat_extra_data = chatData.extra or {}
  self.chatData = chatData
  self.allianceData = chat_extra_data.allianceInfo or {}
  self.isMyChat = chatData:isMyChat()
  if self.chatData.isTextFolding == nil then
    self.chatData.isTextFolding = true
  end
  self.isTextFolding = self.chatData.isTextFolding
  if next(self.allianceData) ~= nil then
    local recommendInfo = AllianceRecommendInfo.New()
    recommendInfo:ParseMsg(chat_extra_data)
    self.compAllianceInfoPanel:SetActive(true)
    self.compAllianceInfoPanel:RefreshByRecommendInfo(recommendInfo, false, 9999)
    self.compInviteBtnPanel:SetActive(false)
    self.compNotEligiblePanel:SetActive(false)
    if not self.isMyChat then
      UIGray.SetGray(self.btnInviteApply.transform, false, true)
      if self.allianceData.recruitTotal and self.allianceData.recruitTotal == 0 then
        self.textApplyBtn:SetLocalText("393090")
      else
        self.textApplyBtn:SetLocalText("390077")
      end
      local playerPower = LuaEntry.Player.power
      local playerMainLv = DataCenter.BuildManager.MainLv
      local isReachPower = playerPower >= (self.allianceData.applyPowerLimit or 0)
      local isReachLv = playerMainLv >= (self.allianceData.applyLevelLimit or 0)
      if not isReachPower or not isReachLv then
        self.isEligible = false
        self.compNotEligiblePanel:SetActive(true)
        UIGray.SetGray(self.btnInviteApply.transform, true, true)
        if not isReachPower then
          self.compPowerContent:SetActive(true)
          self.textPowerNum:SetText(self.allianceData.applyPowerLimit)
        else
          self.compPowerContent:SetActive(false)
        end
        if not isReachLv then
          self.compMainLvContent:SetActive(true)
          self.textBaseLevelNum:SetText(self.allianceData.applyLevelLimit)
        else
          self.compMainLvContent:SetActive(false)
        end
      else
        self.isEligible = true
        self.compInviteBtnPanel:SetActive(true)
      end
    end
  end
  local isSwitchOn = LuaEntry.DataConfig:CheckSwitch("alliance_inviteLinkNew_switch")
  if chat_extra_data.introductionEx and chat_extra_data.introductionEx ~= "" and isSwitchOn then
    self.compInviteTextPanel:SetActive(true)
    if self.chatData:GetTranslateState() == TranslateStateType.TranslationCompleted then
      self.chatData.msg = chat_extra_data.introductionEx or ""
      self:RefreshInviteTextPanel(self.chatData:getTranslationMsg())
      self.showFreedBack = true
    else
      self:RefreshInviteTextPanel(chat_extra_data.introductionEx)
      self.showFreedBack = false
    end
    self:UpdateTextFoldState()
  else
    self.compInviteTextPanel:SetActive(false)
  end
  self:RefreshDarkMode()
end

function ChatItemPost_AllianceShareNew:RefreshInviteTextPanel(invite_text)
  self.isShowReadMore = false
  self.inviteTextPanelVerticalLayout:ChildControlHeight(true)
  self.textInvite:SetText_NotNative(invite_text)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
  self.textInvite.unity_tmpro:ForceMeshUpdate()
  local textInfo = self.textInvite.unity_tmpro.textInfo
  local lineCount = textInfo and textInfo.lineCount or 0
  if 4 < lineCount then
    if self.isTextFolding then
      self.inviteTextPanelVerticalLayout:ChildControlHeight(false)
      local targetHeight = 0
      for index = 0, 3 do
        targetHeight = targetHeight + textInfo.lineInfo[index].lineHeight
      end
      self.textInvite.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, targetHeight)
    end
    self.isShowReadMore = true
  end
  self.btnMore:SetActive(self.isShowReadMore)
end

function ChatItemPost_AllianceShareNew:UpdateTextFoldState()
  self.textMoreBtn:SetLocalText(self.isTextFolding and "message_show_more" or "message_show_less")
  if self.showFreedBack then
    self.btnFreedBackInner:SetActive(self.isShowReadMore)
    self.btnFreedBackOuter:SetActive(not self.isShowReadMore)
  end
  if self.chatData:GetTranslateState() == 2 then
    if self.isTextFolding and self.isShowReadMore then
      self.hideTranslation = true
    else
      self.hideTranslation = false
    end
  end
  self.frame:UpdateTranslateContent()
end

function ChatItemPost_AllianceShareNew:FreedBack(isShow)
  self.showFreedBack = isShow
  if isShow then
    self.btnFreedBackInner:SetActive(self.isShowReadMore)
    self.btnFreedBackOuter:SetActive(not self.isShowReadMore)
  else
    self.btnFreedBackInner:SetActive(false)
    self.btnFreedBackOuter:SetActive(false)
  end
end

function ChatItemPost_AllianceShareNew:RefreshDarkMode()
  local isMyChat = self.isMyChat
  local chat_theme = ChatInterface.GetChatTheme()
  local chat_mode = isMyChat and 2 or 1
  self.imgBg:LoadSprite(ChatInterface.GetChatUIPath(isMyChat and UIAssets.ChatItemBg_right or UIAssets.ChatItemBg_left))
  self.compLeftTitle:SetActive(not isMyChat)
  self.compRightTitle:SetActive(isMyChat)
  self.textLeftTitle:SetColor(TitleTextColor[chat_theme][chat_mode])
  self.textRightTitle:SetColor(TitleTextColor[chat_theme][chat_mode])
  self.imgLeftTitleIcon:SetColor(IconImgColor[chat_theme][chat_mode])
  self.imgRightTitleIcon:SetColor(IconImgColor[chat_theme][chat_mode])
  self.imgFlagBg:LoadSprite(IconBgPath[chat_theme])
  self.imgFlagBg:SetColor(IconBgImgColor[chat_theme][chat_mode])
  self.compAllianceInfoPanel.textName:SetColor(NameTextColor[chat_theme])
  self.compAllianceInfoPanel.textLanguage:SetColor(NameTextColor[chat_theme])
  self.compAllianceInfoPanel.compInfoMemberPanel.textTip:SetColor(NameTextColor[chat_theme])
  self.compAllianceInfoPanel.compInfoPowerPanel.textTip:SetColor(NameTextColor[chat_theme])
  self.compAllianceInfoPanel.compInfoGiftPanel.textTip:SetColor(NameTextColor[chat_theme])
  self.compAllianceInfoPanel.compInfoEngagementPanel.textTip:SetColor(NameTextColor[chat_theme])
  self.imgTextPanelBg:SetColor(InviteBgImgColor[chat_theme])
  self.imgBgTop:SetColor(InviteBgImgColor[chat_theme])
  self.textInvite:SetColor(InviteTextColor)
  self.imgDescBg:LoadSprite(IconBgPath[chat_theme])
  self.imgDescBg:SetColor(IconBgImgColor[chat_theme][chat_mode])
  self.imgNoticeIcon:LoadSprite(NoticeIconPath[chat_theme])
  self.textNotEligible:SetColor(NoticeTextColor[chat_theme])
  self.textPower:SetColor(NameTextColor[chat_theme])
  self.textBaseLevel:SetColor(NameTextColor[chat_theme])
  self.textPowerNum:SetColor(RedNoticeTextColor[chat_theme])
  self.textBaseLevelNum:SetColor(RedNoticeTextColor[chat_theme])
end

return ChatItemPost_AllianceShareNew
