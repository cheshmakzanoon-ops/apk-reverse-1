local UIPlayerHeadIconSelectView = BaseClass("UIPlayerHeadIconSelect", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local txt_title_path = "UICommonMiniPopUpTitle/titleText"
local close_btn_path = "UICommonMiniPopUpTitle/CloseBtn"
local headIcon_select_panel = "UICommonMiniPopUpTitle/panel"
local headIcon_select_cameraBtn = "CameraBtn"
local headIcon_select_photoBtn = "PhotoBtn"
local photo_description_path = "Photo_description"
local camera_description_path = "Camera_description"

local function OnCreate(self)
  base.OnCreate(self)
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.txt_title:SetLocalText(110055)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.tip_return_btn = self:AddComponent(UIButton, headIcon_select_panel)
  self.tip_return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.tip_select_cameraBtn = self:AddComponent(UIButton, headIcon_select_cameraBtn)
  self.tip_select_cameraBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    InteractiveUtil.OnCameraClick()
  end)
  self.tip_select_photoBtn = self:AddComponent(UIButton, headIcon_select_photoBtn)
  self.tip_select_photoBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    InteractiveUtil.OnPhotoClick()
  end)
  self.photo_description = self:AddComponent(UIText, photo_description_path)
  self.camera_description = self:AddComponent(UIText, camera_description_path)
  self.photo_description:SetLocalText(110057)
  self.camera_description:SetLocalText(110056)
  if UIUtil.UseNewPlayerInfo() and toInt(LuaEntry.GlobalData.serverPicVer) <= 0 then
    SFSNetwork.SendMessage(MsgDefines.FetchNewPicVer, FetchPicVerFuncType.PlayerHeadIcon)
  end
end

local function OnDestroy(self)
  self.txt_title = nil
  self.close_btn = nil
  self.tip_return_btn = nil
  self.tip_select_cameraBtn = nil
  self.tip_select_photoBtn = nil
  base.OnDestroy(self)
end

UIPlayerHeadIconSelectView.OnCreate = OnCreate
UIPlayerHeadIconSelectView.OnDestroy = OnDestroy
return UIPlayerHeadIconSelectView
