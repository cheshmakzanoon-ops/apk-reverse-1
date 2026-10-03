local UILWAllianceInviteShareNewView = BaseClass("UILWAllianceInviteShareNewView", UIBaseView)
local UIAllianceInfoHorizontalPanel = require("UI.UIAlliance.UIAllianceInfo.Component.UIAllianceInfoHorizontalPanel")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local alliance_info_path = "PanelRoot/Content/AllianceInfoPanel"

function UILWAllianceInviteShareNewView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitPopup()
end

function UILWAllianceInviteShareNewView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAllianceInviteShareNewView:OnEnable()
  base.OnEnable(self)
  self:RefreshGoldColor()
end

function UILWAllianceInviteShareNewView:OnDisable()
  base.OnDisable(self)
end

function UILWAllianceInviteShareNewView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnBlackMask = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnBlackMask:SetOnClick(function()
    self:OnBtnBlackMaskClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textInputTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textCostDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textItemWorldCount = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.btnShareWorld = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnShareWorld:SetOnClick(function()
    self:OnBtnShareWorldClick()
  end)
  self.textBtnShareWorld = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnShareLang = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnShareLang:SetOnClick(function()
    self:OnBtnShareLangClick()
  end)
  self.textBtnShareLang = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textInputDefault = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.textCharNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.textBtnWorldFree = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.textItemLangCount = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.textBtnLangFree = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.textFreeTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.allianceInfoPanel = self:AddComponent(UIAllianceInfoHorizontalPanel, alliance_info_path)
  self.inputField = self:AddComponent(UIInput, "PanelRoot/Content/InputField")
  self.inputField:SetOnValueChange(function(value)
    self:IptOnValueChange(value)
  end)
  self.inputField:SetOnEndEdit(function(value)
    self:IptOnValueChange(value)
  end)
end

function UILWAllianceInviteShareNewView:ComponentDestroy()
  self.viewSkin = nil
  self.btnBlackMask = nil
  self.textTitle = nil
  self.textInputTip = nil
  self.textCostDesc = nil
  self.textItemWorldCount = nil
  self.btnShareWorld = nil
  self.textBtnShareWorld = nil
  self.btnShareLang = nil
  self.textBtnShareLang = nil
  self.btnClose = nil
  self.textInputDefault = nil
  self.textCharNum = nil
  self.textBtnWorldFree = nil
  self.textItemLangCount = nil
  self.textBtnLangFree = nil
  self.textFreeTip = nil
  self.allianceInfoPanel = nil
end

function UILWAllianceInviteShareNewView:DataDefine()
  self.maxInputCharNum = 0
  self.inputValue = ""
  self.inputCharNum = 0
  self.canFreeShare = false
  self.freeCountDown = 0
  self.sensitiveFixText = ""
  self.allianceUid = LuaEntry.Player:GetAllianceUid()
  self.shakeTextOriginalPos = self.textInputTip.transform.localPosition or Vector3.New(0, -134, 0)
  self.shareCostGoldNum = LuaEntry.DataConfig:TryGetNum("share_crystal", "k1", 200)
end

function UILWAllianceInviteShareNewView:DataDestroy()
  self.maxInputCharNum = nil
  self.inputValue = nil
  self.inputCharNum = nil
  self.canFreeShare = nil
  self.freeCountDown = nil
  self.sensitiveFixText = nil
  self.allianceUid = nil
  self.shakeTextOriginalPos = nil
  self.shareCostGoldNum = nil
  if self.sequence then
    self.sequence:Kill()
  end
  self.sequence = nil
end

function UILWAllianceInviteShareNewView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceInviteFreeMessage, self.OnAllianceInviteFreeMessage)
  self:AddUIListener(EventId.AllianceInviteShareTextCheck, self.OnCheckTextBack)
  self:AddUIListener(EventId.UpdateGold, self.RefreshGoldColor)
end

function UILWAllianceInviteShareNewView:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceInviteFreeMessage, self.OnAllianceInviteFreeMessage)
  self:RemoveUIListener(EventId.AllianceInviteShareTextCheck, self.OnCheckTextBack)
  self:RemoveUIListener(EventId.UpdateGold, self.RefreshGoldColor)
  base.OnRemoveListener(self)
end

function UILWAllianceInviteShareNewView:OnBtnBlackMaskClick()
  self.ctrl:CloseSelf()
end

function UILWAllianceInviteShareNewView:OnBtnShareWorldClick()
  if self:CheckTextLegal() then
    self:SendShareMessage(ChatInterface.getRoomMgr():GetRoomDataByGroup(ChatGroupType.GROUP_COUNTRY):getRoomId())
  end
end

function UILWAllianceInviteShareNewView:OnBtnShareLangClick()
  if self:CheckTextLegal() then
    self:SendShareMessage(ChatInterface.getRoomMgr():GetRoomDataByGroup(ChatGroupType.GROUP_LANGUAGE):getRoomId())
  end
end

function UILWAllianceInviteShareNewView:SendShareMessage(roomId)
  if not self.canFreeShare then
    UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.AllianceInviteShareCostRemind, Localization:GetString("alliance_inviteLink_desc_confirm", self.shareCostGoldNum), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      local chat_data = {}
      chat_data.roomId = roomId
      chat_data.post = PostType.ALLIANCE_INVITE_SHARE_NEW
      chat_data.param = {
        introductionEx = self.inputValue,
        freeEx = self.canFreeShare
      }
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, chat_data)
    end, function()
    end)
  else
    local chat_data = {}
    chat_data.roomId = roomId
    chat_data.post = PostType.ALLIANCE_INVITE_SHARE_NEW
    chat_data.param = {
      introductionEx = self.inputValue,
      freeEx = self.canFreeShare
    }
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, chat_data)
  end
end

function UILWAllianceInviteShareNewView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UILWAllianceInviteShareNewView:OnAllianceInviteFreeMessage(data)
  if data.isFree then
    self.canFreeShare = true
    self.textItemWorldCount:SetActive(false)
    self.textItemLangCount:SetActive(false)
    self.textBtnWorldFree:SetActive(true)
    self.textBtnLangFree:SetActive(true)
    self.textFreeTip:SetActive(false)
    self.freeCountDown = 0
  else
    self.canFreeShare = false
    self.textItemWorldCount:SetActive(true)
    self.textItemLangCount:SetActive(true)
    self.textBtnWorldFree:SetActive(false)
    self.textBtnLangFree:SetActive(false)
    self.textFreeTip:SetActive(true)
    self.freeCountDown = data.endTime
  end
end

function UILWAllianceInviteShareNewView:Update1000MS()
  if self.freeCountDown and self.freeCountDown ~= 0 then
    local diff = self.freeCountDown - UITimeManager:GetInstance():GetServerTime()
    self.textFreeTip:SetText(Localization:GetString("alliance_inviteLink_freeTip_limit_12", UITimeManager:GetInstance():MilliSecondToFmtString(diff)))
    if diff < 0 then
      self:OnAllianceInviteFreeMessage({isFree = true, endTime = 0})
    end
  end
end

function UILWAllianceInviteShareNewView:OnCheckTextBack(data)
  if data.sensitive == true then
    self.inputValue = data.introductionEx
    self.inputCharNum = #self.inputValue
    self.inputField:SetText(self.inputValue)
    self:RefreshInputCharNum()
    self.textInputTip:SetActive(true)
    self.textInputTip:SetLocalText("alliance_inviteLink_illegalChar_limit_12")
  end
end

function UILWAllianceInviteShareNewView:CheckTextLegal()
  if self.inputCharNum > self.maxInputCharNum then
    self:IptOnValueChange(self.inputValue)
    if self.sequence then
      self.sequence:Kill()
    end
    self.textInputTip.transform.localPosition = self.shakeTextOriginalPos
    self.sequence = DOTween.Sequence()
    local trans = self.textInputTip.transform
    self.sequence:Append(trans:DOLocalMoveX(20 * CommonUtil.ArabicAutoMirrorFactor(), 0.1))
    self.sequence:Append(trans:DOLocalMoveX(-20 * CommonUtil.ArabicAutoMirrorFactor(), 0.1))
    self.sequence:Append(trans:DOLocalMoveX(0, 0.1))
    return false
  end
  if self.canFreeShare then
    return true
  end
  if LuaEntry.Player.gold < self.shareCostGoldNum then
    GoToUtil.GotoPayTips(self.shareCostGoldNum)
    return false
  end
  return true
end

function UILWAllianceInviteShareNewView:InitPopup()
  self.textTitle:SetLocalText(393085)
  local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if allianceData then
    self.allianceInfoPanel:RefreshByBaseInfo(allianceData, false, 9999)
  end
  self.inputField:SetText("")
  self.maxInputCharNum = LuaEntry.DataConfig:TryGetNum("share_crystal", "k2", 1000)
  self.textInputDefault:SetText(Localization:GetString("alliance_inviteLink_desc_input"))
  self:RefreshInputCharNum()
  self.textInputTip:SetActive(false)
  self.textCostDesc:SetLocalText("alliance_inviteLink_share_limit_6")
  SFSNetwork.SendMessage(MsgDefines.AllianceShareFreeInfo, {})
  self.textBtnShareWorld:SetLocalText("alliance_inviteLink_btn_wc")
  self.textBtnShareLang:SetText(Localization:GetString("alliance_inviteLink_btn_lan", ChatInterface.getRoomMgr():GetRoomDataByGroup(ChatGroupType.GROUP_LANGUAGE):getRoomName(true)))
  self.textItemWorldCount:SetActive(true)
  self.textItemLangCount:SetActive(true)
  self.textBtnWorldFree:SetActive(false)
  self.textBtnLangFree:SetActive(false)
  self.textItemWorldCount:SetText(self.shareCostGoldNum)
  self.textItemLangCount:SetText(self.shareCostGoldNum)
  self.textBtnWorldFree:SetLocalText(130126)
  self.textBtnLangFree:SetLocalText(130126)
  self:RefreshGoldColor()
end

function UILWAllianceInviteShareNewView:RefreshInputCharNum()
  self.textCharNum:SetText(string.format("%d/%d", self.inputCharNum, self.maxInputCharNum))
  if self.inputCharNum == 0 then
    self.textInputDefault:SetActive(true)
  else
    self.textInputDefault:SetActive(false)
  end
end

function UILWAllianceInviteShareNewView:IptOnValueChange(value)
  self.inputValue = value
  self.inputCharNum = #value
  if self.inputCharNum > self.maxInputCharNum then
    self.textInputTip:SetActive(true)
    self.textInputTip:SetText(Localization:GetString("alliance_inviteLink_tooLong_limit_12"))
  elseif self.inputCharNum > 0 then
    self.textInputTip:SetActive(false)
  end
  self:RefreshInputCharNum()
end

function UILWAllianceInviteShareNewView:RefreshGoldColor()
  if LuaEntry.Player.gold < self.shareCostGoldNum then
    self.textItemWorldCount:SetColor(Color.New(0.91, 0.26, 0.26, 1))
    self.textItemLangCount:SetColor(Color.New(0.91, 0.26, 0.26, 1))
  else
    self.textItemWorldCount:SetColor(WhiteColor)
    self.textItemLangCount:SetColor(WhiteColor)
  end
end

return UILWAllianceInviteShareNewView
