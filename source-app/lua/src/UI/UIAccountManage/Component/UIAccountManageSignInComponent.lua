local base = UIBaseContainer
local UIAccountManageSignInComponent = BaseClass("UIAccountManageSignInComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local iconPath = "Assets/Main/Sprites/UI/UIAccountManage/%s.png"

function UIAccountManageSignInComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAccountManageSignInComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAccountManageSignInComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnSignIn = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnSignIn:SetOnClick(function()
    self:OnBtnSignInClick()
  end)
  self.imgSignInIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textSignIn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
end

function UIAccountManageSignInComponent:ComponentDestroy()
  self.btnSignIn = nil
  self.imgSignInIcon = nil
  self.textSignIn = nil
end

function UIAccountManageSignInComponent:DataDefine()
end

function UIAccountManageSignInComponent:DataDestroy()
end

function UIAccountManageSignInComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIAccountManageSignInComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAccountManageSignInComponent:OnBtnSignInClick()
  if self.clickCallBack ~= nil then
    self.clickCallBack()
  end
end

function UIAccountManageSignInComponent:ReInit(accountBandType, nameKey, clickCallBack)
  self.accountBandType = accountBandType
  self.clickCallBack = clickCallBack
  self.unBindText = nameKey
  self:Refresh()
end

function UIAccountManageSignInComponent:Refresh()
  local showStr = ""
  local bindInfoText = ""
  if self.accountBandType == AccountBandType.Mail then
    self.imgSignInIcon:LoadSprite(string.format(LoadPath.LWCommonPath, "zyf_wangzhuozhan_zontongguanli_icon6"))
  elseif self.accountBandType == AccountBandType.GoogleSign then
    self.imgSignInIcon:LoadSprite(string.format(iconPath, "lrb_GAMEID_Google_icon"))
    local gpAccount = DataCenter.AccountManager.GoogleSignAccount.userId
    if not string.IsNullOrEmpty(gpAccount) then
      bindInfoText = DataCenter.AccountManager.GoogleSignAccount.userName
    end
  elseif self.accountBandType == AccountBandType.PlayGames then
    self.imgSignInIcon:LoadSprite(string.format(iconPath, "lrb_GAMEID_Googleplay_icon"))
    bindInfoText = DataCenter.AccountManager.PlayGamesAccount.userName
  elseif self.accountBandType == AccountBandType.GameCenter then
    self.imgSignInIcon:LoadSprite(string.format(iconPath, "lrb_GAMEID_gamecenter_icon"))
    local gcAccount = DataCenter.AccountManager.GameCenterAccount.userId
    if not string.IsNullOrEmpty(gcAccount) then
      bindInfoText = DataCenter.AccountManager.GameCenterAccount.userName
    end
  else
    Logger.LogError("unknown accountBandType:" .. tostring(self.accountBandType))
    self.imgSignInIcon:LoadSprite(string.format(LoadPath.LWCommonPath, "zyf_duozhanghao_apple_icon"))
  end
  if not string.IsNullOrEmpty(bindInfoText) then
    showStr = bindInfoText
  else
    showStr = Localization:GetString(self.unBindText)
  end
  self.textSignIn:SetText(showStr)
  self.imgSignInIcon:SetNativeSize()
end

return UIAccountManageSignInComponent
