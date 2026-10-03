local UIChatCommanderTips = BaseClass("UIChatCommanderTips", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ChatViewController = require("UI.UIChatNew.Controller.ChatViewUtils")
local _cp_tranInfo = "Info"
local _cp_btnClose = "Info/Top/butClose"
local _cp_txtCommander = "Info/Panel/name"
local _cp_txtCombat = "Info/Panel/Attr1/value1"
local _cp_txtCombat_title = "Info/Panel/Attr1/name1"
local _cp_txtRefugeLv = "Info/Panel/Attr2/value2"
local _cp_txtRefugeLv_title = "Info/Panel/Attr2/name2"
local _cp_txtAlliance = "Info/Panel/Attr3/value3"
local _cp_txtAlliance_title = "Info/Panel/Attr3/name3"
local _cp_butAllianceInfo = "Info/Panel/Attr3/butAllianceInfo"
local _cp_avatorFrame = "Info/Panel/avatorNode"
local _cp_butDetails = "Info/Bottom/btn0"
local _cp_butDetails_title = "Info/Bottom/btn0/txtBtn0"
local _cp_butMessage = "Info/Bottom/btn1"
local _cp_butMessage_title = "Info/Bottom/btn1/txtBtn1"
local _cp_btnInvite_path = "Info/Bottom/btn2"
local _cp_btnInviteTxt_path = "Info/Bottom/btn2/txtBtn2"
local _cp_btnFriend_path = "Info/Bottom/btn3"
local _cp_btnFriendTxt_path = "Info/Bottom/btn3/txtBtn3"
local _cp_btnChatRestrict_path = "Info/Bottom/btn4"
local _cp_btnChatRestrictTxt_path = "Info/Bottom/btn4/txtBtn4"
local _cp_btnChatUnRestrict_path = "Info/Bottom/btn5"
local _cp_btnChatUnRestrictTxt_path = "Info/Bottom/btn5/txtBtn5"
local _cp_btnBg = "butBg"

function UIChatCommanderTips:ComponentDefine()
  self._tranInfo = self:AddComponent(UIBaseContainer, _cp_tranInfo)
  self._btnClose = self:AddComponent(UIButton, _cp_btnClose)
  self._txtCommander = self:AddComponent(UIText, _cp_txtCommander)
  self._txtCombat = self:AddComponent(UIText, _cp_txtCombat)
  self._txtCombat_title = self:AddComponent(UIText, _cp_txtCombat_title)
  self._txtRefugeLv = self:AddComponent(UIText, _cp_txtRefugeLv)
  self._txtRefugeLv_title = self:AddComponent(UIText, _cp_txtRefugeLv_title)
  self._txtAlliance = self:AddComponent(UIText, _cp_txtAlliance)
  self._txtAlliance_title = self:AddComponent(UIText, _cp_txtAlliance_title)
  self._butAllianceInfo = self:AddComponent(UIButton, _cp_butAllianceInfo)
  self._avatorFrame = self:AddComponent(UICommonHead, _cp_avatorFrame)
  self._butDetails = self:AddComponent(UIButton, _cp_butDetails)
  self._butDetails_title = self:AddComponent(UIText, _cp_butDetails_title)
  self._butMessage = self:AddComponent(UIButton, _cp_butMessage)
  self._butMessage_title = self:AddComponent(UIText, _cp_butMessage_title)
  self._btnBg = self:AddComponent(UIButton, _cp_btnBg)
  self._btnClose:SetOnClick(BindCallback(self, self.onClick_butClose))
  self._butAllianceInfo:SetOnClick(BindCallback(self, self.onClick_butAllianceInfo))
  self._butDetails:SetOnClick(BindCallback(self, self.onClick_butDetails))
  self._butMessage:SetOnClick(BindCallback(self, self.onClick_butMessage))
  self._btnBg:SetOnClick(BindCallback(self, self.onClick_butClose))
  self._btnInviteN = self:AddComponent(UIButton, _cp_btnInvite_path)
  self._btnInviteN:SetOnClick(function()
    self:OnClickInviteBtn()
  end)
  self._txtBtnInviteN = self:AddComponent(UIText, _cp_btnInviteTxt_path)
  self._btnFriendN = self:AddComponent(UIButton, _cp_btnFriend_path)
  self._btnFriendN:SetActive(false)
  self._btnFriendTxtN = self:AddComponent(UIText, _cp_btnFriendTxt_path)
  self._btnChatRestrict = self:AddComponent(UIButton, _cp_btnChatRestrict_path)
  self._btnChatRestrict:SetOnClick(function()
    self:OnClickChatRestrict()
  end)
  self._btnChatRestrictTxtN = self:AddComponent(UIText, _cp_btnChatRestrictTxt_path)
  self._btnChatUnRestrict = self:AddComponent(UIButton, _cp_btnChatUnRestrict_path)
  self._btnChatUnRestrict:SetOnClick(function()
    self:OnClickUnChatRestrict()
  end)
  self._btnChatUnRestrictTxtN = self:AddComponent(UIText, _cp_btnChatUnRestrictTxt_path)
  return
end

function UIChatCommanderTips:OnDestroy()
  self._tranInfo = nil
  self._btnClose = nil
  self._txtCommander = nil
  self._txtCombat = nil
  self._txtCombat_title = nil
  self._txtRefugeLv = nil
  self._txtRefugeLv_title = nil
  self._txtAlliance = nil
  self._txtAlliance_title = nil
  self._butAllianceInfo = nil
  self._avatorFrame = nil
  self._butDetails = nil
  self._butDetails_title = nil
  self._butMessage = nil
  self._butMessage_title = nil
  self._btnBg = nil
  self._btnInviteN = nil
  self._txtBtnInviteN = nil
  self._btnFriendTxtN = nil
  base.OnDestroy(self)
end

function UIChatCommanderTips:DialogDefine()
  self._butMessage_title:SetLocalText(110053)
  self._txtCombat_title:SetLocalText(100386)
  self._txtRefugeLv_title:SetLocalText(280036)
  self._txtAlliance_title:SetLocalText(390028)
  self._butDetails_title:SetLocalText(110036)
  self._txtBtnInviteN:SetLocalText(311025)
  self._btnFriendTxtN:SetLocalText(290067)
  self._btnChatRestrictTxtN:SetLocalText(290007)
  self._btnChatUnRestrictTxtN:SetLocalText(141027)
end

function UIChatCommanderTips:DelayInvoke(callback, delayTime)
  local param = {}
  param.timer = TimerManager:GetInstance():GetTimer(delayTime, function()
    if param.timer ~= nil then
      param.timer:Stop()
      param.timer = nil
    end
    param = nil
    callback()
  end, self, true, false, false)
  param.timer:Start()
end

function UIChatCommanderTips:DataDefine()
  local userData = self:GetUserData()
  self._chatData = userData.chatdata
  self._targetPos = userData.targetPos
  self._userInfo = userData.userinfo
end

function UIChatCommanderTips:InitView()
  local info = self._userInfo
  local uid = self._userInfo.uid
  local name = info.userName
  self.blockUuid = 0
  if not string.IsNullOrEmpty(info.allianceSimpleName) then
    local aname = "[" .. info.allianceSimpleName .. "]"
    self._txtAlliance:SetText(aname)
    name = aname .. name
  end
  self._txtCommander:SetText(name)
  self._avatorFrame:SetData(uid, info.headPic, info.headPicVer, nil, info:GetHeadBgImg())
  if DataCenter.AllianceBaseDataManager:IsR4orR5() and string.IsNullOrEmpty(info.allianceId) then
    self._btnInviteN:SetActive(true)
  else
    self._btnInviteN:SetActive(false)
  end
  self.blockUuid = ChatManager2:GetInstance().Restrict:GetRestrictUuid(uid, RestrictType.BLOCK)
  if self.blockUuid ~= nil and self.blockUuid ~= 0 then
    self._btnChatUnRestrict:SetActive(true)
    self._btnChatRestrict:SetActive(false)
  else
    self._btnChatRestrict:SetActive(true)
    self._btnChatUnRestrict:SetActive(false)
  end
end

function UIChatCommanderTips:RefreshData()
  self:InitView()
end

function UIChatCommanderTips:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:DialogDefine()
  self:RefreshData()
  self:DelayInvoke(function()
    self:SetPosition()
  end, 0)
end

function UIChatCommanderTips:SetPosition()
  self._tranInfo.transform.position = self._targetPos.position
  local tmp = self._targetPos.position
end

function UIChatCommanderTips:OnEnable()
  base.OnEnable(self)
end

function UIChatCommanderTips:OnDisable()
  base.OnDisable(self)
end

function UIChatCommanderTips:OnAddListener()
  self:AddUIListener(EventId.PlayerMessageInfo, self.OnPlayerDataCallBack)
end

function UIChatCommanderTips:OnRemoveListener()
  self:RemoveUIListener(EventId.PlayerMessageInfo, self.OnPlayerDataCallBack)
end

function UIChatCommanderTips:OnPlayerDataCallBack()
  self:RefreshData()
end

function UIChatCommanderTips:onClick_butClose()
  self.ctrl:CloseSelf()
end

function UIChatCommanderTips:onClick_butAllianceInfo()
  local uid = self._userInfo.uid
  local info = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(uid)
  if info == nil then
    return
  end
  if string.IsNullOrEmpty(info.allianceId) then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true, hideTop = true}, info.allianceName, info.allianceId)
end

function UIChatCommanderTips:onClick_butDetails()
  local userData = self:GetUserData()
  self.ctrl:CloseSelf()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self._userInfo)
end

function UIChatCommanderTips:onClick_butMessage()
  self.ctrl:CloseSelf()
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_TALK_TO_PRIVATE, self._userInfo)
end

function UIChatCommanderTips:OnClickInviteBtn()
  self.ctrl:CloseSelf()
  SFSNetwork.SendMessage(MsgDefines.AllianceInvitePlayer, nil, self._userInfo.uid)
end

function UIChatCommanderTips:OnClickFriend()
  if not DataCenter.BuildManager:HasBuildByIdAndLevel(BuildingTypes.FUN_BUILD_KONBINI, 1) then
    UIUtil.ShowTipsId(121375)
    return
  end
  self.ctrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChatNew)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFriendMain, self._userInfo.uid)
end

function UIChatCommanderTips:OnClickChatRestrict()
  self.ctrl:CloseSelf()
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_BLOCK_COMMAND, self._userInfo.uid)
end

function UIChatCommanderTips:OnClickUnChatRestrict()
  self.ctrl:CloseSelf()
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_UNBLOCK_COMMAND, self.blockUuid)
end

return UIChatCommanderTips
