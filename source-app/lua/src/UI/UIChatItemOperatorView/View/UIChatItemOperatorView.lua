local UIChatItemOperatorView = BaseClass("UIChatItemOperatorView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local _cp_btnBg = "butBg"
local _cp_root = "root"
local _cp_root_arrow = "root/Image"
local btnReport_path = "root/btnReport"
local txtReportBtn_path = "root/btnReport/txtReport"
local _cp_btnTranslate = "root/btnTranslate"
local _cp_txtTranslate = "root/btnTranslate/txtTranslate"
local _cp_btnCopy = "root/btnCopy"
local _cp_txtCopy = "root/btnCopy/txtCopy"
local _cp_btnUp = "root/support"
local _cp_btnDown = "root/opposition"
local compBook = {
  {
    path = "btnClose",
    name = "btnClose",
    type = UIButton,
    onClick = function(self)
      self.ctrl:CloseSelf()
    end
  },
  {
    path = "root",
    name = "root",
    type = UIBaseContainer
  },
  {
    path = "root/arrow",
    name = "arrow",
    type = UIImage
  },
  {
    path = "root/layoutBtns",
    name = "layoutBtns",
    type = UIBaseContainer
  },
  {
    path = "root/layoutLine",
    name = "layoutLine",
    type = UIBaseContainer
  },
  {
    path = "root/layoutLike",
    name = "layoutLike",
    type = UIBaseContainer
  },
  {
    path = "root/layoutBtns/btnTranslate",
    name = "btnTranslate",
    type = UIButton,
    onClick = function(self)
      self:OnClickBtnTranslate()
    end
  },
  {
    path = "root/layoutBtns/btnReply",
    name = "btnReply",
    type = UIButton,
    onClick = function(self)
      self:OnClickBtnReply()
    end
  },
  {
    path = "root/layoutBtns/btnCopy",
    name = "btnCopy",
    type = UIButton,
    onClick = function(self)
      self:OnClickBtnCopy()
    end
  },
  {
    path = "root/layoutBtns/btnReport",
    name = "btnReport",
    type = UIButton,
    onClick = function(self)
      self:OnClickBtnReport()
    end
  },
  {
    path = "root/layoutBtns/btnTranslate/txtTranslate",
    name = "txtTranslate",
    type = UIText,
    textKey = "290042"
  },
  {
    path = "root/layoutBtns/btnReply/txtReply",
    name = "txtReply",
    type = UIText,
    textKey = "2900032"
  },
  {
    path = "root/layoutBtns/btnCopy/txtCopy",
    name = "txtCopy",
    type = UIText,
    textKey = "121069"
  },
  {
    path = "root/layoutBtns/btnReport/txtReport",
    name = "txtReport",
    type = UIText,
    textKey = "208251"
  },
  {
    path = "root/layoutLike/btnLike",
    name = "btnLike",
    type = UIButton,
    onClick = function(self)
      self:OnClickBtnLike()
    end
  },
  {
    path = "root/layoutLike/btnDislike",
    name = "btnDislike",
    type = UIButton,
    onClick = function(self)
      self:OnClickBtnDislike()
    end
  }
}

function UIChatItemOperatorView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  local userData = self:GetUserData()
  self._chatData = userData.chatdata
  self._targetPos = userData.targetPos
  self._userInfo = userData.userinfo
  self._chatItem = userData.chatItem
  if self._chatItem ~= nil and self._chatItem.translateBtn == nil then
    self:UpdateLayout_Self()
  else
    self:UpdateLayout_Other()
  end
end

function UIChatItemOperatorView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChatItemOperatorView:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function UIChatItemOperatorView:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIChatItemOperatorView:UpdateLayout_Self()
  self.btnTranslate:SetActive(false)
  self.btnReply:SetActive(true)
  self.btnCopy:SetActive(true)
  self.btnReport:SetActive(false)
  self.btnLike:SetActive(false)
  self.btnDislike:SetActive(false)
  self.layoutBtns:SetActive(true)
  self.layoutLine:SetActive(false)
  self.layoutLike:SetActive(false)
  self.layoutBtns:SetSizeDeltaXY(270, 120)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.root)
  self.root.transform.position = self._targetPos.position + Vector2.New(0, -70)
  self.arrow.transform.localPosition = Vector2.New(0, 0, 0)
end

function UIChatItemOperatorView:UpdateLayout_Other()
  self.btnTranslate:SetActive(true)
  self.btnReply:SetActive(true)
  self.btnCopy:SetActive(true)
  local isLvEnough = ChatManager2:GetInstance():CheckMainLvEnough()
  self.btnReport:SetActive(isLvEnough)
  local isFromAI = self._chatData ~= nil and self._chatData:isFromAI()
  self.btnLike:SetActive(not isFromAI)
  self.btnDislike:SetActive(not isFromAI)
  self.layoutBtns:SetActive(true)
  self.layoutLine:SetActive(true)
  self.layoutLike:SetActive(true)
  self.layoutBtns:SetSizeDeltaXY(490, 120)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.root)
  self.root.transform.position = self._targetPos.position + Vector2.New(0, -70)
  local localPos = self.root.transform.localPosition
  localPos.x = 0
  self.root.transform.localPosition = localPos
  self.arrow.transform.position = self._targetPos.position + Vector2.New(0, -70)
end

function UIChatItemOperatorView:OnClickBtnTranslate()
  self._chatItem:OnTranslationBtn()
  self.ctrl:CloseSelf()
end

function UIChatItemOperatorView:OnClickBtnReply()
  EventManager:GetInstance():Broadcast(EventId.SetReplyChatMsg, self._chatData)
  self.ctrl:CloseSelf()
end

function UIChatItemOperatorView:OnClickBtnCopy()
  local msg = self._chatData:getMessageWithExtra(false)
  CommonUtil.CopyTextToClipboard(msg)
  UIUtil.ShowTipsId(128031)
  self.ctrl:CloseSelf()
end

function UIChatItemOperatorView:OnClickBtnReport()
  local isLvEnough = ChatManager2:GetInstance():CheckMainLvEnough()
  if not isLvEnough then
    UIUtil.ShowTipsId(208256)
    return
  end
  local reported = ChatManager2:GetInstance():CheckIfReported(self._chatData)
  if reported then
    UIUtil.ShowTipsId(280064)
    return
  end
  if ChatManager2:GetInstance():CheckReportTime() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatReport, {anim = true}, {
      type = ReportType.chat,
      chatData = self._chatData
    })
    self.ctrl:CloseSelf()
  else
    UIUtil.ShowTipsId(208250)
  end
end

function UIChatItemOperatorView:OnClickBtnDislike()
  self._chatItem:OnDown()
  self.ctrl:CloseSelf()
end

function UIChatItemOperatorView:OnClickBtnLike()
  self._chatItem:OnUp()
  self.ctrl:CloseSelf()
end

return UIChatItemOperatorView
