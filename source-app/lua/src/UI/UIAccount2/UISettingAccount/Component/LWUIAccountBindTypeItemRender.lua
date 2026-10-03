local LWUIAccountBindTypeItemRender = BaseClass("LWUIAccountBindTypeItemRender", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local icon_path = "HorLayout/NameText/Icon"
local name_text_path = "HorLayout/NameText"
local bind_info_text_path = "groupEyeOpen/BindInfoText"
local btn_path = "Btn"

function LWUIAccountBindTypeItemRender:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWUIAccountBindTypeItemRender:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIAccountBindTypeItemRender:ComponentDefine()
  self.icon = self:AddComponent(UIImage, icon_path)
  self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
  self.bind_info_text = self:AddComponent(UITextMeshProUGUIEx, bind_info_text_path)
  self.group_eye_open = self:AddComponent(UIBaseContainer, "groupEyeOpen")
  self.group_eye_close = self:AddComponent(UIBaseContainer, "groupEyeClose")
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    if self.clickCallBack ~= nil then
      self.clickCallBack()
    end
  end)
  self.group_eye_open:SetActive(false)
  self.group_eye_close:SetActive(false)
end

function LWUIAccountBindTypeItemRender:ComponentDestroy()
  self.icon = nil
  self.name_text = nil
  self.bind_info_text = nil
  self.btn = nil
  self.group_eye_open = nil
end

function LWUIAccountBindTypeItemRender:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AccountSettingAnonymityChange, self.RefreshAnonymityView)
end

function LWUIAccountBindTypeItemRender:OnRemoveListener()
  self:RemoveUIListener(EventId.AccountSettingAnonymityChange, self.RefreshAnonymityView)
  base.OnRemoveListener(self)
end

function LWUIAccountBindTypeItemRender:ReInit(accountBandType, nameKey, clickCallBack, showBindInfo)
  self.accountBandType = accountBandType
  self.clickCallBack = clickCallBack
  if self.accountBandType == AccountBandType.Mail then
    self.icon:LoadSprite(string.format(LoadPath.LWCommonPath, "zyf_wangzhuozhan_zontongguanli_icon6"))
  elseif self.accountBandType == AccountBandType.GoogleSign then
    self.icon:LoadSprite(string.format(LoadPath.LWCommonPath, "mjc_ZHBD_icon_google"))
  elseif self.accountBandType == AccountBandType.PlayGames then
    self.icon:LoadSprite(string.format(LoadPath.LWCommonPath, "zyf_zhbd_google_icon"))
  elseif self.accountBandType == AccountBandType.GameCenter then
    self.icon:LoadSprite(string.format(LoadPath.LWCommonPath, "zyf_zhbd_gamecenter_icon"))
  else
    Logger.LogError("unknown accountBandType:" .. tostring(self.accountBandType))
    self.icon:LoadSprite(string.format(LoadPath.LWCommonPath, "zyf_duozhanghao_apple_icon"))
  end
  self.name_text:SetLocalText(nameKey)
  self.icon:SetNativeSize()
  if showBindInfo then
    self:RefreshShowBindInfo()
  else
    self.bind_info_text:SetText("")
    self:RefreshBtnName_Login(nameKey)
  end
  self:RefreshAnonymityView()
end

function LWUIAccountBindTypeItemRender:RefreshAnonymityView()
  local isAnonymity = Setting:GetPrivateBool("AccountSettingAnonymity", true)
  local bindInfo = self.bind_info_text:GetText()
  if string.IsNullOrEmpty(bindInfo) then
    self.group_eye_open:SetActive(false)
    self.group_eye_close:SetActive(false)
  else
    self.group_eye_open:SetActive(not isAnonymity)
    self.group_eye_close:SetActive(isAnonymity)
  end
end

function LWUIAccountBindTypeItemRender:RefreshShowBindInfo()
  if self.accountBandType == AccountBandType.Mail then
    local account = DataCenter.AccountManager.MailAccount.gameAccount
    if account ~= nil and account ~= "" then
      local status = DataCenter.AccountManager.MailAccount.accountStatus or AccountBandState.UnBand
      if status == AccountBandState.Band then
        self.bind_info_text:SetText(account)
      else
        self.bind_info_text:SetText("")
      end
    else
      self.bind_info_text:SetText("")
    end
  elseif self.accountBandType == AccountBandType.GoogleSign then
    local gpAccount = DataCenter.AccountManager.GoogleSignAccount.userId
    if not string.IsNullOrEmpty(gpAccount) then
      local gpName = DataCenter.AccountManager.GoogleSignAccount.userName
      self.bind_info_text:SetText(gpName)
    else
      self.bind_info_text:SetText("")
    end
  elseif self.accountBandType == AccountBandType.PlayGames then
    local playerId = DataCenter.AccountManager.PlayGamesAccount.userId
    if not string.IsNullOrEmpty(playerId) then
      local playerName = DataCenter.AccountManager.PlayGamesAccount.userName
      self.bind_info_text:SetText(playerName)
      self.name_text:SetLocalText("googleplay_login_title02", playerName)
    else
      self.bind_info_text:SetText("")
      self.name_text:SetLocalText("280047")
    end
  elseif self.accountBandType == AccountBandType.GameCenter then
    local gcAccount = DataCenter.AccountManager.GameCenterAccount.userId
    if not string.IsNullOrEmpty(gcAccount) then
      local gcName = DataCenter.AccountManager.GameCenterAccount.userName
      self.bind_info_text:SetText(gcName)
    else
      self.bind_info_text:SetText("")
    end
  end
end

function LWUIAccountBindTypeItemRender:RefreshBtnName_Login(nameKey)
  if self.accountBandType == AccountBandType.PlayGames then
    local authData = CS.PlayGamesBridge.GetAuthData()
    if authData == nil then
      self.name_text:SetLocalText(nameKey)
      return
    end
    local authCode = authData.authCode
    local playerId = authData.playerId
    local displayName = authData.displayName
    local success = authData.success
    local code = authData.code
    local error = authData.error
    if not string.IsNullOrEmpty(playerId) and not string.IsNullOrEmpty(displayName) then
      self.name_text:SetLocalText("googleplay_login_title01", displayName)
    else
      self.name_text:SetLocalText(nameKey)
    end
  end
end

return LWUIAccountBindTypeItemRender
