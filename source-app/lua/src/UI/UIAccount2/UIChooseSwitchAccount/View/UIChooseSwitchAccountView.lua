local UIChooseSwitchAccountView = BaseClass("UIChooseSwitchAccountView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local SDKManager = CS.SDKManager
local Setting = CS.GameEntry.Setting
local LWUIAccountBindTypeItemRender = require("UI.UIAccount2.UISettingAccount.Component.LWUIAccountBindTypeItemRender")

function UIChooseSwitchAccountView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:OnOpen()
end

function UIChooseSwitchAccountView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChooseSwitchAccountView:ComponentDefine()
  self.bgRectComp = self:AddComponent(UIBaseComponent, "UICommonPopUpTitle")
  self.textTips = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/Root/VerLayoutContent/TipsRoot/Tips")
  self.panel = self:AddComponent(UIButton, "panel")
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.account_bind_type1 = self:AddComponent(LWUIAccountBindTypeItemRender, "UICommonPopUpTitle/Root/VerLayoutContent/AccountBindType1")
  self.account_bind_type2 = self:AddComponent(LWUIAccountBindTypeItemRender, "UICommonPopUpTitle/Root/VerLayoutContent/AccountBindType2")
  self.account_bind_type3 = self:AddComponent(LWUIAccountBindTypeItemRender, "UICommonPopUpTitle/Root/VerLayoutContent/AccountBindType3")
  self.title = self:AddComponent(UIText, "UICommonPopUpTitle/Common_img_title/titleText")
  self.textTips:SetLocalText(2700011)
  self.btnClose = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.account_bind_type1:ReInit(AccountBandType.Mail, 2700010, function()
    self:OnBtnEmailClick()
  end, false)
  self.account_bind_type2:SetActive(false)
  self.account_bind_type3:SetActive(false)
  if SDKManager.IS_Android() then
    self.account_bind_type2:SetActive(true)
    self.account_bind_type2:ReInit(AccountBandType.GoogleSign, "googleplay_login_title", function()
      self:OnGoogleSignClick()
    end, false)
    if CS.PlayGamesBridge.IsPlayGamesAvailable() then
      self.account_bind_type3:SetActive(true)
      self.account_bind_type3:ReInit(AccountBandType.PlayGames, "280047", function()
        self:OnPlayGamesClick()
      end, false)
    end
  elseif SDKManager.IS_IPhonePlayer() and CS.GameCenterBridge.IsGameCenterAvailable() then
    self.account_bind_type2:SetActive(true)
    self.account_bind_type3:SetActive(false)
    self.account_bind_type2:ReInit(AccountBandType.GameCenter, "accountBind_gamecenter", function()
      self:OnGameCenterClick()
    end, false)
  end
  local titlekey = self:GetUserData()
  if titlekey then
    self.title:SetLocalText(titlekey)
  else
    self.title:SetLocalText(280050)
  end
  self.objPCTip = self:AddComponent(UIBaseComponent, "UICommonPopUpTitle/Root/VerLayoutContent/PCTip")
  if Config.IsPC() then
    self.objPCTip:SetActive(true)
    self.textPCTip = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/Root/VerLayoutContent/PCTip/desText")
    self.textPCTip:SetLocalText("pc_account_tips_07")
    self.btnDetail = self:AddComponent(UIButton, "UICommonPopUpTitle/Root/VerLayoutContent/PCTip/btnDetail")
    self.btnDetail:SetOnClick(function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBindMailTips)
    end)
  else
    self.objPCTip:SetActive(false)
  end
  self:AdjustHeight()
end

function UIChooseSwitchAccountView:AdjustHeight()
  local activeItemCount = 0
  if self.account_bind_type2.gameObject.activeSelf then
    activeItemCount = activeItemCount + 1
  end
  if self.account_bind_type3.gameObject.activeSelf then
    activeItemCount = activeItemCount + 1
  end
  if self.objPCTip.gameObject.activeSelf then
    activeItemCount = activeItemCount + 1
  end
  local width = self.bgRectComp:GetSizeDelta().x
  self.bgRectComp:SetSizeDeltaXY(width, 480 + activeItemCount * 100)
end

function UIChooseSwitchAccountView:ComponentDestroy()
end

function UIChooseSwitchAccountView:OnOpen()
end

function UIChooseSwitchAccountView:OnEnable()
  base.OnEnable(self)
end

function UIChooseSwitchAccountView:OnDisable()
  base.OnDisable(self)
end

function UIChooseSwitchAccountView:OnBtnEmailClick()
  local title = 280050
  local isLoadingLogin = false
  title, isLoadingLogin = self:GetUserData()
  DataCenter.AccountManager.MailAccount:Login({title = title, isLoadingLogin = isLoadingLogin})
  self.ctrl:CloseSelf()
end

function UIChooseSwitchAccountView:OnGoogleSignClick()
  DataCenter.AccountManager.GoogleSignAccount:Login()
  self.ctrl:CloseSelf()
end

function UIChooseSwitchAccountView:OnPlayGamesClick()
  DataCenter.AccountManager.PlayGamesAccount:Login()
  self.ctrl:CloseSelf()
end

function UIChooseSwitchAccountView:OnGameCenterClick()
  DataCenter.AccountManager.GameCenterAccount:Login()
  self.ctrl:CloseSelf()
end

function UIChooseSwitchAccountView:OnAddListener()
  base.OnAddListener(self)
end

function UIChooseSwitchAccountView:OnRemoveListener()
  base.OnRemoveListener(self)
end

return UIChooseSwitchAccountView
