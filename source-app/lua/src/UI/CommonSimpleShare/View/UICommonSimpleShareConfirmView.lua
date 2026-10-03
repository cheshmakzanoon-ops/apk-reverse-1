local UICommonSimpleShareConfirmView = BaseClass("UICommonSimpleShareConfirmView", UIBaseView)
local base = UIBaseView

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.textName = self:AddComponent(UITextMeshProUGUIEx, "ImgBg/Channel/NameText")
  self.imgFlag = self:AddComponent(UIImage, "ImgBg/Channel/Flag")
  self.textPreview = self:AddComponent(UITextMeshProUGUIEx, "ImgBg/PreviewText")
  self.btnYes = self:AddComponent(UIButton, "ImgBg/BtnYes")
  self.btnYes:SetOnClick(function()
    self:OnBtnYesClick()
  end)
  self.textBtnYes = self:AddComponent(UITextMeshProUGUIEx, "ImgBg/BtnYes/BtnYesText")
  self.btnNo = self:AddComponent(UIButton, "ImgBg/BtnNo")
  self.btnNo:SetOnClick(BindCallback(self, self.OnCloseClick))
  self.textBtnNo = self:AddComponent(UITextMeshProUGUIEx, "ImgBg/BtnNo/BtnNoText")
  self.btnClose = self:AddComponent(UIButton, "UICommonMiniPopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnCloseClick()
  end)
  self.btnPanel = self:AddComponent(UIButton, "UICommonMiniPopUpTitle/panel")
  self.btnPanel:SetOnClick(BindCallback(self, self.OnCloseClick))
  self.textBtnYes:SetLocalText(110073)
  self.textBtnNo:SetLocalText(GameDialogDefine.CANCEL)
  self.chat_channel = ChatInterface.getRoomData(ChatInterface.getAllianceRoomId())
  local roomImg = self.chat_channel:getRoomImg()
  if not string.IsNullOrEmpty(roomImg) then
    self.imgFlag:SetActive(true)
    self.imgFlag:LoadSprite(roomImg)
  else
    self.imgFlag:SetActive(false)
  end
  self.textName:SetText(self.chat_channel:getRoomName())
end

local function ComponentDestroy(self)
  self.textName = nil
  self.imgFlag = nil
  self.textPreview = nil
  self.btnYes = nil
  self.textBtnYes = nil
  self.btnNo = nil
  self.textBtnNo = nil
  self.btnClose = nil
  self.btnPanel = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceQuitOK, self.BeKickedAlliance)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceQuitOK, self.BeKickedAlliance)
  base.OnRemoveListener(self)
end

local function DataDefine(self)
  self.msgName = nil
end

local function DataDestroy(self)
  self.msgName = nil
end

local function OnBtnYesClick(self)
  if not string.IsNullOrEmpty(self.msgName) then
    SFSNetwork.SendMessage(self.msgName)
    self.ctrl:CloseSelf()
  end
end

local function OnCloseClick(self)
  self.ctrl:CloseSelf()
end

local function Init(self)
  local param = self:GetUserData()
  if param then
    self.msgName = param.msgName
    local tipsId = param.tipsId
    self.textPreview:SetLocalText(tipsId)
  end
end

local function BeKickedAlliance(self)
  if not LuaEntry.Player:IsInAlliance() then
    self.ctrl:CloseSelf()
  end
end

UICommonSimpleShareConfirmView.OnCreate = OnCreate
UICommonSimpleShareConfirmView.OnDestroy = OnDestroy
UICommonSimpleShareConfirmView.ComponentDefine = ComponentDefine
UICommonSimpleShareConfirmView.ComponentDestroy = ComponentDestroy
UICommonSimpleShareConfirmView.OnAddListener = OnAddListener
UICommonSimpleShareConfirmView.OnRemoveListener = OnRemoveListener
UICommonSimpleShareConfirmView.DataDefine = DataDefine
UICommonSimpleShareConfirmView.DataDestroy = DataDestroy
UICommonSimpleShareConfirmView.OnBtnYesClick = OnBtnYesClick
UICommonSimpleShareConfirmView.OnCloseClick = OnCloseClick
UICommonSimpleShareConfirmView.Init = Init
UICommonSimpleShareConfirmView.BeKickedAlliance = BeKickedAlliance
return UICommonSimpleShareConfirmView
