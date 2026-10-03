local UIDeviceManageDelConfirmView = BaseClass("UIDeviceManageDelConfirmView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIDeviceManageDelConfirmView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIDeviceManageDelConfirmView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDeviceManageDelConfirmView:ComponentDefine()
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "UICommonMiniPopUpTitle/titleText")
  self.btnClose = self:AddComponent(UIButton, "UICommonMiniPopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnLeft = self:AddComponent(UIButton, "BtnGo/LeftBtn")
  self.btnLeft:SetOnClick(function()
    self:OnBtnLeftClick()
  end)
  self.btnRight = self:AddComponent(UIButton, "BtnGo/RightBtn")
  self.btnRight:SetOnClick(function()
    self:OnBtnRightClick()
  end)
  self.textTitleDevice = self:AddComponent(UITextMeshProUGUIEx, "groupDevice/tittlebg/TextTitleDevice")
  self.imgType = self:AddComponent(UIImage, "groupDevice/ImageType")
  self.textPlatform = self:AddComponent(UITextMeshProUGUIEx, "groupDevice/TextPlatform")
  self.textModleName = self:AddComponent(UITextMeshProUGUIEx, "groupDevice/TextPlatform/Scroll View/Viewport/TextModleName")
  self.textDesContent = self:AddComponent(UITextMeshProUGUIEx, "DesContent")
  local data = self:GetUserData()
  local deviceId = CS.GameEntry.Setting:GetString(SettingKeys.DEVICE_ID, "")
  if deviceId == data.deviceId then
    self.textTitle:SetLocalText("device_manage_title03")
    self.textTitleDevice:SetLocalText("device_manage_desc05")
    self.textDesContent:SetLocalText("device_manage_desc07")
  else
    self.textTitle:SetLocalText("device_manage_title03")
    self.textTitleDevice:SetLocalText("device_manage_desc05")
    self.textDesContent:SetLocalText("device_manage_desc06")
  end
  if data.modelInfo ~= nil and not string.IsNullOrEmpty(data.modelInfo.model) then
    self.textModleName:SetText(data.modelInfo.model)
  else
    self.textModleName:SetLocalText(130262)
  end
  if data.modelInfo ~= nil and not string.IsNullOrEmpty(data.modelInfo.pf) then
    if data.modelInfo.pf == "0" then
      self.textPlatform:SetText("iOS")
      self.imgType:LoadSprite("Assets/Main/Sprites/UI/UIDeviceManage/lyt_yunying_qingchushebei_ioshei.png")
    elseif data.modelInfo.pf == "1" then
      self.textPlatform:SetText("Android")
      self.imgType:LoadSprite("Assets/Main/Sprites/UI/UIDeviceManage/lyt_yunying_qingchushebei_anzuohei.png")
    elseif data.modelInfo.pf == "2" then
      self.textPlatform:SetText("PC")
      self.imgType:LoadSprite("Assets/Main/Sprites/UI/UIDeviceManage/lyt_yunying_qingchushebei_diannaohei.png")
    else
      self.textPlatform:SetLocalText(130262)
      self.imgType:LoadSprite("Assets/Main/Sprites/UI/UIDeviceManage/wxy_denglu_wenhao.png")
    end
  else
    self.textPlatform:SetLocalText(130262)
    self.imgType:LoadSprite("Assets/Main/Sprites/UI/UIDeviceManage/wxy_denglu_wenhao.png")
  end
end

function UIDeviceManageDelConfirmView:ComponentDestroy()
  self.textTitle = nil
  self.btnClose = nil
  self.btnLeft = nil
  self.btnRight = nil
  self.textTitleDevice = nil
  self.imgType = nil
  self.textPlatform = nil
  self.textModleName = nil
  self.textDesContent = nil
end

function UIDeviceManageDelConfirmView:DataDefine()
end

function UIDeviceManageDelConfirmView:DataDestroy()
end

function UIDeviceManageDelConfirmView:OnAddListener()
  base.OnAddListener(self)
end

function UIDeviceManageDelConfirmView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIDeviceManageDelConfirmView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIDeviceManageDelConfirmView:OnBtnLeftClick()
  self.ctrl:CloseSelf()
end

function UIDeviceManageDelConfirmView:OnBtnRightClick()
  local data = self:GetUserData()
  SFSNetwork.SendMessage(MsgDefines.AccountDeviceAccountDel, data.deviceId)
  self.ctrl:CloseSelf()
end

return UIDeviceManageDelConfirmView
