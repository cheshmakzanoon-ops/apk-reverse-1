local UIAccountManageView = BaseClass("UIAccountManageView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local SDKManager = CS.SDKManager
local UICommonHead = require("Framework.UI.Component.UICommonHead")
local UIAccountManageSignInComponent = require("UI.UIAccountManage.Component.UIAccountManageSignInComponent")
local UIAccountManageCollectContentComponent = require("UI.UIAccountManage.Component.UIAccountManageCollectContentComponent")
local AccountScoreConst = require("DataCenter.AccountScore.AccountScoreConst")

function UIAccountManageView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function UIAccountManageView:OnDestroy()
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  self:ClearFinger()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAccountManageView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.compUIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 2)
  self.textPlayerName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textAllianceName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textPlayerUid = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.btnCopy = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnCopy:SetOnClick(function()
    self:OnBtnCopyClick()
  end)
  self.btnHide = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnHide:SetOnClick(function()
    self:OnBtnHideClick()
  end)
  self.btnShow = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnShow:SetOnClick(function()
    self:OnBtnShowClick()
  end)
  self.btnActiveCard = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnActiveCard:SetOnClick(function()
    self:OnBtnActiveCardClick()
  end)
  self.btnSignUp = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnSignUp:SetOnClick(function()
    self:OnBtnSignUpClick()
  end)
  self.btnModifyId = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnModifyId:SetOnClick(function()
    self:OnBtnModifyIdClick()
  end)
  self.compSignInArea = self.viewSkin:AddComponent(self, UIBaseContainer, 12)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 13)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnAccount = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnAccount:SetOnClick(function()
    self:OnBtnAccountClick()
  end)
  self.btnDevice = self.viewSkin:AddComponent(self, UIButton, 15)
  self.btnDevice:SetOnClick(function()
    self:OnBtnDeviceClick()
  end)
  self.btnRole = self.viewSkin:AddComponent(self, UIButton, 16)
  self.btnRole:SetOnClick(function()
    self:OnBtnRoleClick()
  end)
  self.compSignIn = self.viewSkin:AddComponent(self, UIBaseContainer, 17)
  self.compUid = self.viewSkin:AddComponent(self, UIBaseContainer, 18)
  self.compCollectContent = self.viewSkin:AddComponent(self, UIAccountManageCollectContentComponent, 19)
  self.textPointNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 20)
  self.textCardId = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 21)
  self.compSignUpRewardNode = self.viewSkin:AddComponent(self, UIBaseContainer, 22)
  self.imgSignUpReward = self.viewSkin:AddComponent(self, UIImage, 23)
  self.textSignUpRewardNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 24)
  self.compSignIn.gameObject:GameObjectCreatePool()
  self.compCollectContent:SetActive(false)
  self.btnActiveCard:SetActive(false)
  self.btnModifyId:SetActive(false)
  self.btnSignUp:SetActive(false)
  self.textPointNum:SetActive(false)
  self.textCardId:SetActive(false)
end

function UIAccountManageView:ComponentDestroy()
  self.compSignInArea:RemoveComponents(UIAccountManageSignInComponent)
  self.compSignIn.gameObject:GameObjectRecycleAll()
  self.guideBind = false
  self.viewSkin = nil
  self.textTitle = nil
  self.compUIPlayerHead = nil
  self.textPlayerName = nil
  self.textAllianceName = nil
  self.textPlayerUid = nil
  self.btnCopy = nil
  self.btnHide = nil
  self.btnShow = nil
  self.btnActiveCard = nil
  self.btnSignUp = nil
  self.btnModifyId = nil
  self.compSignInArea = nil
  self.btnClose = nil
  self.btnAccount = nil
  self.btnDevice = nil
  self.btnRole = nil
  self.compSignIn = nil
  self.compUid = nil
  self.compCollectContent = nil
  self.textPointNum = nil
  self.textCardId = nil
  self.compSignUpRewardNode = nil
  self.imgSignUpReward = nil
  self.textSignUpRewardNum = nil
end

function UIAccountManageView:DataDefine()
  self.accountBindTypeItemList = {}
end

function UIAccountManageView:DataDestroy()
  self.accountBindTypeItemList = nil
end

function UIAccountManageView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AccountWebLogInfoUpdate, self.OnAccountWebLogInfoUpdate)
  self:AddUIListener(EventId.AccountBindOKEvent, self.OnAccountWebLogInfoUpdate)
  self:AddUIListener(EventId.MSG_USER_BIND_OK, self.RefreshSigninArea)
end

function UIAccountManageView:OnRemoveListener()
  self:RemoveUIListener(EventId.AccountWebLogInfoUpdate, self.OnAccountWebLogInfoUpdate)
  self:RemoveUIListener(EventId.AccountBindOKEvent, self.OnAccountWebLogInfoUpdate)
  self:RemoveUIListener(EventId.MSG_USER_BIND_OK, self.RefreshSigninArea)
  base.OnRemoveListener(self)
end

function UIAccountManageView:OnEnable()
  base.OnEnable(self)
  self:InitBindBtnState()
  self:InitCard()
end

function UIAccountManageView:InitView()
  self:RequestAccountScoreData()
  self:InitPlayerInfo()
  self:InitBindBtnState()
  self:RefreshSigninArea()
  self:RefreshInfoHide()
  self:InitCard()
  self:TryGuide()
end

function UIAccountManageView:OnBtnCopyClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  CommonUtil.CopyTextToClipboard(LuaEntry.Player:GetUid())
  UIUtil.ShowTipsId(128031)
end

function UIAccountManageView:OnBtnHideClick()
  local isAnonymity = self.ctrl:GetAccountManageAnonymity()
  self.ctrl:SetAccountManageAnonymity(not isAnonymity)
  self:RefreshInfoHide()
end

function UIAccountManageView:OnBtnShowClick()
  local isAnonymity = self.ctrl:GetAccountManageAnonymity()
  self.ctrl:SetAccountManageAnonymity(not isAnonymity)
  self:RefreshInfoHide()
end

function UIAccountManageView:OnBtnActiveCardClick()
  local bindMail = DataCenter.AccountManager.MailAccount:IsBound()
  if not bindMail then
    DataCenter.AccountManager.MailAccount:OnClick()
    return
  end
  DataCenter.AccountScoreManager:GoToLogInAccountScoreWeb(AccountScoreLogInWebType.AccountView_GoToBtn)
end

function UIAccountManageView:OnBtnSignUpClick()
  DataCenter.AccountManager.MailAccount:OnClick()
end

function UIAccountManageView:OnBtnModifyIdClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAccountIdBind, AccountScoreConst.OpenType.ChangeMail)
end

function UIAccountManageView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIAccountManageView:OnBtnAccountClick()
  local state = DataCenter.AccountManager:GetAccountBindState()
  if state == AccountBandState.Band then
    self:OnBtnSwitchClick()
  else
    self:OnBtnHereClick()
  end
end

function UIAccountManageView:OnBtnSwitchClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAccountIdBind, AccountScoreConst.OpenType.ChangeSignIn)
end

function UIAccountManageView:OnBtnHereClick()
  UIUtil.ShowMessage(Localization:GetString("208218"), 2, nil, nil, function()
    self.ctrl:CloseSelf()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAccountIdBind, AccountScoreConst.OpenType.ChangeSignIn)
  end)
end

function UIAccountManageView:OnBtnDeviceClick()
  if DataCenter.AccountManager:IsDeviceMgrOpen() then
    self:OnClickDeviceMgr()
  else
    self:OnClickLogout()
  end
end

function UIAccountManageView:OnBtnRoleClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIRoles, {anim = true, hideTop = true}, 0)
end

function UIAccountManageView:OnClickDeviceMgr()
  local isBindMail = DataCenter.AccountManager.MailAccount:IsBound()
  if not isBindMail then
    self:GuideToBindMail()
    return
  end
  local expireTime = Setting:GetPrivateString("DeviceManageMailVerifyExpireTime", "")
  if not string.IsNullOrEmpty(expireTime) then
    local now = UITimeManager:GetInstance():GetServerTime()
    local eTime = tonumber(expireTime)
    if now < eTime then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDeviceManage)
      return
    end
  end
  UIUtil.ShowConfirmNew({
    title = Localization:GetString("device_manage_title01"),
    contentText = Localization:GetString("device_manage_desc01"),
    btnNum = 2,
    showToggle = false,
    confirmBtnParam = {
      action = function()
        if isBindMail then
          local account = DataCenter.AccountManager.MailAccount.gameAccount
          DataCenter.AccountManager:SetMailVerifyCodeType("device")
          SFSNetwork.SendMessage(MsgDefines.AccountDeviceSendVerifyCode, {mail = account, oType = "device"})
        else
          Logger.Log("UIAccountManageView OnClickDeviceMgr: \230\156\170\231\187\145\229\174\154\233\130\174\231\174\177\239\188\140\230\151\160\230\179\149\232\191\155\232\161\140\232\174\190\229\164\135\231\174\161\231\144\134")
        end
      end
    }
  })
end

function UIAccountManageView:GuideToBindMail()
  UIUtil.ShowConfirmNew({
    title = Localization:GetString("device_manage_title02"),
    contentText = Localization:GetString("device_manage_desc02"),
    btnNum = 1,
    showToggle = false,
    confirmBtnParam = {
      action = function()
        TimerManager:GetInstance():DelayInvoke(function()
          if IsNull(self.gameObject) then
            return
          end
          DataCenter.AccountManager.MailAccount:OnClick()
        end, 0.5)
      end
    }
  })
end

function UIAccountManageView:OnClickLogout()
  local state = DataCenter.AccountManager:GetAccountBindState()
  if state ~= AccountBandState.Band then
    UIUtil.ShowTipsId(280097)
    return
  end
  UIUtil.ShowMessage(Localization:GetString("pc_account_tips_09"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    Logger.LogInfo("[AT]ClearGUID&NetUid_Logout")
    CS.AccountCredentialManager.ClearServerInfo()
    CS.ApplicationLaunch.Instance:ReloadGame()
  end, function()
  end, nil, "pc_account_tips_08")
end

function UIAccountManageView:RequestAccountScoreData()
  SFSNetwork.SendMessage(MsgDefines.ScorewebLoginInfo)
end

function UIAccountManageView:InitPlayerInfo()
  local uid = LuaEntry.Player:GetUid()
  local pic = LuaEntry.Player:GetPic()
  local picVer = LuaEntry.Player.picVer
  local headSkinPath = LuaEntry.Player:GetHeadBgImg()
  self.compUIPlayerHead:SetData(uid, pic, picVer, nil, headSkinPath)
  self.textPlayerName:SetText(LuaEntry.Player.name)
  local allianceName = Localization:GetString("140042")
  if LuaEntry.Player:IsInAlliance() then
    local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if allianceData and allianceData.abbr and allianceData.allianceName then
      allianceName = "[" .. allianceData.abbr .. "]" .. allianceData.allianceName
    end
  end
  self.textAllianceName:SetText(allianceName)
end

function UIAccountManageView:InitBindBtnState()
  local state = DataCenter.AccountManager:GetAccountBindState()
  self.btnRole:SetActive(state == AccountBandState.Band)
  if DataCenter.AccountManager:IsDeviceMgrOpen() then
    self.btnDevice:SetActive(true)
  else
    self.btnDevice:SetActive(Config.IsPC())
  end
  local accountScoreData = DataCenter.AccountScoreManager.accountScoreData
  if accountScoreData then
    local haveLogScoreWeb = accountScoreData:GetStatus()
    self.compCollectContent:SetActive(haveLogScoreWeb)
    self.btnActiveCard:SetActive(not haveLogScoreWeb)
    if haveLogScoreWeb then
      self.compCollectContent:Init()
    end
  end
  local bindMail = DataCenter.AccountManager.MailAccount:IsBound()
  self.btnModifyId:SetActive(bindMail)
  self.btnSignUp:SetActive(not bindMail)
  self:RefreshReward()
end

function UIAccountManageView:RefreshInfoHide()
  local isAnonymity = self.ctrl:GetAccountManageAnonymity()
  if isAnonymity then
    self.textPlayerUid:SetText("******")
  else
    self.textPlayerUid:SetText(LuaEntry.Player:GetUid())
  end
  self.btnHide:SetActive(not isAnonymity)
  self.btnShow:SetActive(isAnonymity)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compUid.rectTransform)
  self:RefreshCardId()
end

function UIAccountManageView:InitCard()
  local accountScoreData = DataCenter.AccountScoreManager.accountScoreData
  if not accountScoreData then
    return
  end
  if accountScoreData:GetStatus() then
    local cardPoint = accountScoreData.cardPoint or 0
    self.textPointNum:SetText(cardPoint)
  else
    self.textPointNum:SetText(1000)
  end
  self.textPointNum:SetActive(true)
  self:RefreshCardId()
end

function UIAccountManageView:RefreshCardId()
  local accountScoreData = DataCenter.AccountScoreManager.accountScoreData
  if not accountScoreData then
    self.textCardId:SetActive(false)
    return
  end
  if accountScoreData:GetStatus() then
    local cardId = DataCenter.AccountManager.MailAccount.gameAccount or ""
    local cardIdStr = ""
    local isAnonymity = self.ctrl:GetAccountManageAnonymity()
    if isAnonymity then
      cardIdStr = "******"
    else
      cardIdStr = "ID:" .. cardId
    end
    self.textCardId:SetText(cardIdStr)
    self.textCardId:SetActive(true)
  else
    self.textCardId:SetActive(false)
  end
end

function UIAccountManageView:TryGuide()
  local isArrow, openRolesAfterBind, guideBind = self:GetUserData()
  DataCenter.AccountManager:SetAfterBindOpenRolesList(openRolesAfterBind)
  if guideBind and not self.guideBind then
    self.guideBind = true
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:OnDelayInvoke()
    end, 0.5)
  end
end

function UIAccountManageView:OnDelayInvoke()
  self.delayTimer = nil
  local pos
  if self.btnSignUp then
    pos = self.btnSignUp.transform.position
  end
  if pos then
    local plotId = LuaEntry.DataConfig:TryGetNum("bind_email_alert_config", "k3", 0)
    if 0 < plotId then
      EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = plotId, hideMainUI = false})
    end
    self.fingerHandle = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/Guide/UIArrowFinger.prefab")
    self.fingerHandle:completed("+", function(handle)
      if handle.isError then
        return
      end
      CommonUtil.CallAutoArabicMirrorManually(handle)
      local gameObject = handle.gameObject
      local transform = gameObject.transform
      transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.Guide.Name).transform, false)
      transform:Set_position(pos.x, pos.y, pos.z)
      transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      self.fingerDelay = TimerManager:GetInstance():DelayInvoke(function()
        self.fingerDelay = nil
        if self.fingerHandle then
          self.fingerHandle:Destroy()
          self.fingerHandle = nil
        end
      end, 3)
    end)
  end
end

function UIAccountManageView:ClearFinger()
  if self.fingerDelay then
    self.fingerDelay:Stop()
    self.fingerDelay = nil
  end
  if self.fingerHandle then
    self.fingerHandle:Destroy()
    self.fingerHandle = nil
  end
end

function UIAccountManageView:RefreshSigninArea()
  if table.IsNullOrEmpty(self.accountBindTypeItemList) then
    if SDKManager.IS_Android() then
      self:CreateBindTypeItem("GoogleSignBindType", AccountBandType.GoogleSign, "googleplay_login_title", function()
        DataCenter.AccountManager.GoogleSignAccount:OnClick()
      end)
      if CS.PlayGamesBridge.IsPlayGamesAvailable() then
        self:CreateBindTypeItem("PlayGamesBindType", AccountBandType.PlayGames, "280047", function()
          DataCenter.AccountManager.PlayGamesAccount:OnClick()
        end)
      end
    end
    if SDKManager.IS_IPhonePlayer() and CS.GameCenterBridge.IsGameCenterAvailable() then
      self:CreateBindTypeItem("GameCenterBindType", AccountBandType.GameCenter, "accountBind_gamecenter", function()
        Setting:SetInt("GameCenterDeclinedByUser", 0)
        DataCenter.AccountManager.GameCenterAccount:OnClick()
      end)
    end
  else
    for _, v in pairs(self.accountBindTypeItemList) do
      v:Refresh()
    end
  end
end

function UIAccountManageView:CreateBindTypeItem(goName, accountBandType, nameKey, clickCallBack)
  local go = self.compSignIn.gameObject:GameObjectSpawn(self.compSignInArea.transform)
  go.name = goName
  go:SetActive(true)
  local itemRender = self.compSignInArea:AddComponent(UIAccountManageSignInComponent, go.name)
  itemRender:ReInit(accountBandType, nameKey, clickCallBack)
  table.insert(self.accountBindTypeItemList, itemRender)
end

function UIAccountManageView:OnAccountWebLogInfoUpdate()
  self:InitBindBtnState()
  self:InitCard()
end

function UIAccountManageView:RefreshReward()
  local show = true
  local bindMail = DataCenter.AccountManager.MailAccount:IsBound()
  local rewardList = DataCenter.AccountManager:GetBindAccountReward()
  local reward = rewardList[1]
  if bindMail or not reward then
    show = false
  end
  self.compSignUpRewardNode:SetActive(show)
  if show then
    if reward.type == RewardType.GOLD then
      self.imgSignUpReward:LoadSprite(DataCenter.RewardManager:GetPicByType(reward.type, nil, nil, true))
      self.textSignUpRewardNum:SetText(reward.value)
    else
      self.imgSignUpReward:LoadSprite(DataCenter.RewardManager:GetPicByType(reward.type, reward.value.id, nil, true))
      self.textSignUpRewardNum:SetText(reward.value.num)
    end
  end
end

return UIAccountManageView
