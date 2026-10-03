local UITransFeedbackView = BaseClass("UITransFeedbackView", UIBaseView)
local startCount = 5
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local StartItem = require("UI.UITransFeedback.Component.UIStartItem")
local UIGray = CS.UIGray

function UITransFeedbackView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local Theme = {
  {
    startDes = Color.FromHex("#736863"),
    inputTextColor = Color.FromHex("#2A2830"),
    originalContent = Color.FromHex("#818083"),
    bodyTitle = Color.FromHex("#2A2803"),
    lineImgPath = "Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/ChatItems/zyf_tongmengguanli_tiaocao_xuxian.png"
  },
  {
    startDes = Color.FromHex("#828282"),
    inputTextColor = Color.FromHex("#AAAAAA"),
    originalContent = Color.FromHex("#626364"),
    bodyTitle = Color.FromHex("#DCDCDC"),
    lineImgPath = "Assets/Main/Sprites/UI/LWChat_v2/NightSkin/ChatItems/zyf__xuxian_yejian.png"
  }
}

function UITransFeedbackView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITransFeedbackView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compStartCom = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.textOriginalContent = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textPlaceholder = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnCancel = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnCancel:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnSend = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnSend:SetOnClick(function()
    self:OnBtnSendClick()
  end)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnPanel:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textSuggestion = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textOriginal = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textStartTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.inputText = self:AddComponent(UITextMeshProUGUIEx, "ImgBg/reasonIpt/viewport/Text")
  self.reasonIptN = self:AddComponent(UIInput, "ImgBg/reasonIpt")
  self.titleText = self:AddComponent(UITextMeshProUGUIEx, "UICommonMidPopUpTitle/titleText")
  self.reasonIptN:SetOnValueChange(function(value)
    self:OnInputValueChange(value)
  end)
  ChatInterface.SetEmojiTextProperty(self.textOriginalContent)
  ChatInterface.SetEmojiTextProperty(self.inputText, true)
  self.reasonIptN:SetText("")
  self.startCom = self:AddComponent(UIBaseContainer, "ImgBg/TopStart/startCom")
  self.startItem = self.transform:Find("ImgBg/TopStart/startItem").gameObject
  self.startItem:SetActive(false)
  self.startItem:GameObjectCreatePool()
end

function UITransFeedbackView:ComponentDestroy()
  self.viewSkin = nil
  self.compStartCom = nil
  self.textOriginalContent = nil
  self.textPlaceholder = nil
  self.btnCancel = nil
  self.btnSend = nil
  self.btnPanel = nil
  self.btnClose = nil
  self.textDes = nil
  self.textSuggestion = nil
  self.textOriginal = nil
  self.textStartTitle = nil
  self.startItem:GameObjectRecycleAll()
  self.reasonIptN = nil
  self.startCom = nil
  self.startItem = nil
end

function UITransFeedbackView:OnInputValueChange(value)
  self.textPlaceholder:SetActive(value == "")
end

function UITransFeedbackView:DataDefine()
  self.data = self:GetUserData()
  self.startItemList = {}
end

function UITransFeedbackView:DataDestroy()
  self.selectStartIndex = nil
  self.data = nil
  self.startItemList = nil
end

function UITransFeedbackView:ReInit()
  if not self.data then
    self.ctrl:CloseSelf()
    return
  end
  local goItem
  for itemId = 1, startCount do
    goItem = self.startItem:GameObjectSpawn(self.startCom.transform)
    goItem.name = "item_" .. itemId
    goItem:SetActive(true)
    local theItem = self.startCom:AddComponent(StartItem, goItem.name)
    theItem:ReInit(itemId, function(index)
      self:OnStartBtnClick(index)
    end)
    table.insert(self.startItemList, theItem)
  end
  local usingColor = Theme[ChatInterface.GetChatTheme()]
  self.textDes:SetColor(usingColor.startDes)
  self.textSuggestion:SetColor(usingColor.bodyTitle)
  self.textOriginal:SetColor(usingColor.bodyTitle)
  self.textStartTitle:SetColor(usingColor.startDes)
  self.textOriginalContent:SetColor(usingColor.originalContent)
  self.inputText:SetColor(usingColor.inputTextColor)
  self.textOriginalContent:SetText(self.data.msg)
  self:UpdateSendBtnState()
end

function UITransFeedbackView:OnStartBtnClick(index)
  if not index then
    return
  end
  self.selectStartIndex = index
  for i = 1, startCount do
    self.startItemList[i]:SetStartOpen(i <= index)
  end
  self:UpdateSendBtnState()
end

function UITransFeedbackView:UpdateSendBtnState()
  if self.selectStartIndex then
    UIGray.SetGray(self.btnSend.transform, false, true)
  else
    UIGray.SetGray(self.btnSend.transform, true, false)
  end
end

function UITransFeedbackView:OnAddListener()
  base.OnAddListener(self)
end

function UITransFeedbackView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UITransFeedbackView:OnBtnCancelClick()
end

function UITransFeedbackView:OnBtnSendClick()
  if not self.data then
    self.ctrl:CloseSelf()
    return
  end
  if self.data.transJson and type(self.data.transJson) == "table" then
    local param = DeepCopy(self.data.transJson)
    param.source = self.data.msg
    param.score = self.selectStartIndex
    param.suggestion = self.reasonIptN:GetText()
    param.roomGroupType = self.data.group
    local json = rapidjson.encode(param)
    ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.ChatTransLateFeedback, json)
  end
  UIUtil.ShowTipsId("translate_feedback_tips")
  self.ctrl:CloseSelf()
end

function UITransFeedbackView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

return UITransFeedbackView
