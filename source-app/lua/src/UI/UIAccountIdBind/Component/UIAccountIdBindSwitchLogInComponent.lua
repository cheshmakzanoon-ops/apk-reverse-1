local base = UIBaseContainer
local UIAccountIdBindSwitchLogInComponent = BaseClass("UIAccountIdBindSwitchLogInComponent", UIBaseContainer)
local UIAccountManageSignInComponent = require("UI.UIAccountManage.Component.UIAccountManageSignInComponent")
local Localization = CS.GameEntry.Localization
local SDKManager = CS.SDKManager

function UIAccountIdBindSwitchLogInComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAccountIdBindSwitchLogInComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAccountIdBindSwitchLogInComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textContent = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnSignUp = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnSignUp:SetOnClick(function()
    self:OnBtnSignUpClick()
  end)
  self.textSignUpBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compSignInArea = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.compSignIn = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.compSignIn.gameObject:GameObjectCreatePool()
end

function UIAccountIdBindSwitchLogInComponent:ComponentDestroy()
  self.compSignIn:RemoveComponents(UIAccountManageSignInComponent)
  self.compSignIn.gameObject:GameObjectRecycleAll()
  self.viewSkin = nil
  self.textTitle = nil
  self.textContent = nil
  self.btnSignUp = nil
  self.textSignUpBtn = nil
  self.compSignInArea = nil
  self.compSignIn = nil
end

function UIAccountIdBindSwitchLogInComponent:DataDefine()
  self.accountBindTypeItemList = {}
end

function UIAccountIdBindSwitchLogInComponent:DataDestroy()
  self.accountBindTypeItemList = nil
end

function UIAccountIdBindSwitchLogInComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIAccountIdBindSwitchLogInComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAccountIdBindSwitchLogInComponent:OnBtnSignUpClick()
  local title = 280050
  local state = DataCenter.AccountManager:GetAccountBindState()
  if state ~= AccountBandState.Band then
    title = 110008
  end
  DataCenter.AccountManager.MailAccount:Login({title = title})
end

function UIAccountIdBindSwitchLogInComponent:Init(state)
  self.curState = state
  self.compSignIn:SetActive(false)
  self:SetLocalizeText()
  self:InitSignInArea()
end

function UIAccountIdBindSwitchLogInComponent:SetLocalizeText()
  if self.curState then
    local stateLocalization = self.curState.GetStateLocalization and self.curState:GetStateLocalization() or {}
    self.textTitle:SetLocalText(stateLocalization.titleStr)
    self.textContent:SetActive(not string.IsNullOrEmpty(stateLocalization.contentStr))
    self.textContent:SetLocalText(stateLocalization.contentStr)
    self.textSignUpBtn:SetLocalText(stateLocalization.signUpBtnStr)
  end
end

function UIAccountIdBindSwitchLogInComponent:InitSignInArea()
  if table.IsNullOrEmpty(self.accountBindTypeItemList) then
    if SDKManager.IS_Android() then
      self:CreateBindTypeItem("GoogleSignBindType", AccountBandType.GoogleSign, "googleplay_login_title", function()
        DataCenter.AccountManager.GoogleSignAccount:Login()
        self:CloseView()
      end)
      if CS.PlayGamesBridge.IsPlayGamesAvailable() then
        self:CreateBindTypeItem("PlayGamesBindType", AccountBandType.PlayGames, "280047", function()
          DataCenter.AccountManager.PlayGamesAccount:Login()
          self:CloseView()
        end)
      end
    end
    if SDKManager.IS_IPhonePlayer() and CS.GameCenterBridge.IsGameCenterAvailable() then
      self:CreateBindTypeItem("GameCenterBindType", AccountBandType.GameCenter, "accountBind_gamecenter", function()
        Setting:SetInt("GameCenterDeclinedByUser", 0)
        DataCenter.AccountManager.GameCenterAccount:Login()
        self:CloseView()
      end)
    end
  end
end

function UIAccountIdBindSwitchLogInComponent:CreateBindTypeItem(goName, accountBandType, nameKey, clickCallBack)
  local go = self.compSignIn.gameObject:GameObjectSpawn(self.compSignInArea.transform)
  go.name = goName
  go:SetActive(true)
  local itemRender = self.compSignInArea:AddComponent(UIAccountManageSignInComponent, go.name)
  itemRender:ReInit(accountBandType, nameKey, clickCallBack)
  table.insert(self.accountBindTypeItemList, itemRender)
end

function UIAccountIdBindSwitchLogInComponent:CloseView()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAccountIdBind)
end

return UIAccountIdBindSwitchLogInComponent
