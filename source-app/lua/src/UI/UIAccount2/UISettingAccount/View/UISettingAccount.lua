local UISettingAccount = BaseClass("UISettingAccount", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local SDKManager = CS.SDKManager
local LWUIAccountBindTypeItemRender = require("UI.UIAccount2.UISettingAccount.Component.LWUIAccountBindTypeItemRender")
local btn_copy_path = "Root/Common_bg_orange/TopContent/Content2/BtnCopy"

function UISettingAccount:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UISettingAccount:OnEnable()
  base.OnEnable(self)
  self.guideBind = false
  self:RefreshView()
  self:RefreshReward()
end

function UISettingAccount:OnDestroy()
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  self:ClearFinger()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISettingAccount:ComponentDefine()
  self.textTitle = self:AddComponent(UIText, "Root/Common_bg_orange/Common_img_title/titleText")
  self.textTitle:SetLocalText(280039)
  self.btnClose = self:AddComponent(UIButton, "Root/Common_bg_orange/CloseBtn")
  self.closePanel = self:AddComponent(UIButton, "Root/panel")
  self.player_head = self:AddComponent(UICommonHead, "Root/Common_bg_orange/TopContent/PlayerBtn/UIPlayerHead")
  self.player_level = self:AddComponent(UIText, "Root/Common_bg_orange/TopContent/PlayerBtn/LevelBg/LevelText")
  self.text_name_title_text = self:AddComponent(UITextMeshProUGUIEx, "Root/Common_bg_orange/TopContent/Content1/TextNameTitleText")
  self.text_name_title_text:SetLocalText(208186)
  self.text_name_value_text = self:AddComponent(UITextMeshProUGUIEx, "Root/Common_bg_orange/TopContent/Content1/TextNameValueText")
  self.text_id_title_text = self:AddComponent(UITextMeshProUGUIEx, "Root/Common_bg_orange/TopContent/Content2/TextIdTitleText")
  self.text_id_title_text:SetLocalText(208187)
  self.text_id_value_text = self:AddComponent(UITextMeshProUGUIEx, "Root/Common_bg_orange/TopContent/Content2/TextIdValueText")
  self.text_id_hide_text = self:AddComponent(UITextMeshProUGUIEx, "Root/Common_bg_orange/TopContent/Content2/TextIdHideText")
  self.text_alliance_title_text = self:AddComponent(UITextMeshProUGUIEx, "Root/Common_bg_orange/TopContent/Content3/TextAllianceTitleText")
  self.text_alliance_title_text:SetLocalText(208188)
  self.text_alliance_value_text = self:AddComponent(UITextMeshProUGUIEx, "Root/Common_bg_orange/TopContent/Content3/TextAllianceValueText")
  self.image_duihao = self:AddComponent(UIImage, "Root/Common_bg_orange/groupAnonymity/imageDuihao")
  self.btn_anonymity = self:AddComponent(UIButton, "Root/Common_bg_orange/groupAnonymity/btnAnonymity")
  self.btn_anonymity:SetOnClick(function()
    local isAnonymity = Setting:GetPrivateBool("AccountSettingAnonymity", true)
    Setting:SetPrivateBool("AccountSettingAnonymity", not isAnonymity)
    self:UpdateAccountSettingAnonymity()
    EventManager:GetInstance():Broadcast(EventId.AccountSettingAnonymityChange)
  end)
  self:UpdateAccountSettingAnonymity()
  self.btn_copy = self:AddComponent(UIButton, btn_copy_path)
  self.btn_copy:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    CommonUtil.CopyTextToClipboard(LuaEntry.Player:GetUid())
    UIUtil.ShowTipsId(128031)
  end)
  self.account_bind_type_content = self:AddComponent(UIBaseContainer, "Root/Common_bg_orange/AccountBindTypeContent")
  self.account_bind_type_obj = self.transform:Find("Root/UILWAccountBindTypeItemRender").gameObject
  self.account_bind_type_obj:GameObjectCreatePool()
  self.accountBindTypeItemList = {}
  self.btn_switch = self:AddComponent(UIButton, "Root/Common_bg_orange/BottomContent/Layout/BtnSwitch")
  self.btn_switch:SetOnClick(function()
    local state = DataCenter.AccountManager:GetAccountBindState()
    if state == AccountBandState.Band then
      self:OnBtnSwitchClick()
    else
      self:OnBtnHereClick()
    end
  end)
  self.btn_switch_text = self:AddComponent(UITextMeshProUGUIEx, "Root/Common_bg_orange/BottomContent/Layout/BtnSwitch/BtnSwitchText")
  self.btn_role = self:AddComponent(UIButton, "Root/Common_bg_orange/BottomContent/Layout/BtnRole")
  self.btn_role:SetOnClick(function()
    self:OnClickRole()
  end)
  self.btn_role_text = self:AddComponent(UITextMeshProUGUIEx, "Root/Common_bg_orange/BottomContent/Layout/BtnRole/BtnRoleText")
  self.btn_role_text:SetLocalText(208225)
  self.btn_logout = self:AddComponent(UIButton, "Root/Common_bg_orange/BottomContent/Layout/BtnLogout")
  self.btn_logout_text = self:AddComponent(UITextMeshProUGUIEx, "Root/Common_bg_orange/BottomContent/Layout/BtnLogout/BtnLogoutText")
  if DataCenter.AccountManager:IsDeviceMgrOpen() then
    self.btn_logout_text:SetLocalText("device_manage_title01")
    self.btn_logout:SetOnClick(function()
      self:OnClickDeviceMgr()
    end)
  else
    self.btn_logout_text:SetLocalText("pc_account_tips_08")
    self.btn_logout:SetOnClick(function()
      self:OnClickLogout()
    end)
  end
  self.un_bind_content = self:AddComponent(UIBaseContainer, "Root/Common_bg_orange/UnBindContent")
  self.reward_tips_text = self:AddComponent(UITextMeshProUGUIEx, "Root/Common_bg_orange/UnBindContent/RewardTipsText")
  self.reward_tips_text:SetLocalText(280043)
  self.unbind_tips_text = self:AddComponent(UITextMeshProUGUIEx, "Root/Common_bg_orange/UnBindContent/UnbindTipsText")
  self.unbind_tips_text:SetLocalText(280158)
  self.rewardList = {}
  for i = 1, 2 do
    self.rewardList[i] = {}
    local icon = self:AddComponent(UIImage, "Root/Common_bg_orange/UnBindContent/Rect_Reward/Rect_Reward" .. i)
    local txt = self:AddComponent(UITextMeshProUGUIEx, "Root/Common_bg_orange/UnBindContent/Rect_Reward/Rect_Reward" .. i .. "/TextReward" .. i)
    self.rewardList[i].icon = icon
    self.rewardList[i].txt = txt
  end
  self.btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseAll))
  self.closePanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseAll))
end

function UISettingAccount:ComponentDestroy()
  self.accountBindTypeItemList = nil
  self.account_bind_type_content:RemoveComponents(LWUIAccountBindTypeItemRender)
  self.account_bind_type_obj:GameObjectRecycleAll()
  self.guideBind = false
end

function UISettingAccount:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AccountBindEvent, self.RefreshView)
  self:AddUIListener(EventId.AccountBindOKEvent, self.RefreshView)
  self:AddUIListener(EventId.MSG_USER_BIND_OK, self.RefreshView)
end

function UISettingAccount:OnRemoveListener()
  self:RemoveUIListener(EventId.AccountBindEvent, self.RefreshView)
  self:RemoveUIListener(EventId.AccountBindOKEvent, self.RefreshView)
  self:RemoveUIListener(EventId.MSG_USER_BIND_OK, self.RefreshView)
  base.OnRemoveListener(self)
end

function UISettingAccount:UpdateAccountSettingAnonymity()
  local isAnonymity = Setting:GetPrivateBool("AccountSettingAnonymity", true)
  self.image_duihao:SetActive(isAnonymity)
  self.text_id_value_text:SetActive(not isAnonymity)
  self.text_id_hide_text:SetActive(isAnonymity)
end

function UISettingAccount:OnBtnSwitchClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChooseSwitchAccount)
end

function UISettingAccount:OnBtnHereClick()
  UIUtil.ShowMessage(Localization:GetString("208218"), 2, nil, nil, function()
    self.ctrl:CloseSelf()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChooseSwitchAccount, 110008)
  end)
end

function UISettingAccount:RefreshView()
  local state = DataCenter.AccountManager:GetAccountBindState()
  local uid = LuaEntry.Player:GetUid()
  local pic = LuaEntry.Player:GetPic()
  local picVer = LuaEntry.Player.picVer
  local headSkinPath = LuaEntry.Player:GetHeadBgImg()
  self.player_head:SetData(uid, pic, picVer, nil, headSkinPath)
  self.player_level:SetText(DataCenter.BuildManager.MainLv)
  self.text_name_value_text:SetText(LuaEntry.Player.name)
  self.text_id_value_text:SetText(LuaEntry.Player:GetUid())
  local allianceName = Localization:GetString("140042")
  if LuaEntry.Player:IsInAlliance() then
    local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if allianceData and allianceData.abbr and allianceData.allianceName then
      allianceName = "[" .. allianceData.abbr .. "]" .. allianceData.allianceName
    end
  end
  self.text_alliance_value_text:SetText(allianceName)
  self.un_bind_content:SetActive(state ~= AccountBandState.Band)
  self.btn_role:SetActive(state == AccountBandState.Band)
  if state == AccountBandState.Band then
    self.btn_switch_text:SetLocalText(280050)
  else
    self.btn_switch_text:SetLocalText(208178)
  end
  self:RefreshShowAccountBindTypeItem()
  local isArrow, openRolesAfterBind, guideBind = self:GetUserData()
  if isArrow then
    local param = {}
    param.position = self.btnBind.transform.position
    param.arrowType = ArrowType.Capacity
    param.positionType = PositionType.Screen
    DataCenter.ArrowManager:ShowArrow(param)
  end
  DataCenter.AccountManager:SetAfterBindOpenRolesList(openRolesAfterBind)
  if guideBind and not self.guideBind then
    self.guideBind = true
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:OnDelayInvoke()
    end, 0.5)
  end
  if DataCenter.AccountManager:IsDeviceMgrOpen() then
    self.btn_logout:SetActive(true)
  else
    self.btn_logout:SetActive(Config.IsPC())
  end
end

function UISettingAccount:OnDelayInvoke()
  self.delayTimer = nil
  if self.accountBindTypeItemList then
    local pos
    for _, v in ipairs(self.accountBindTypeItemList) do
      if v and v.accountBandType and v.accountBandType == AccountBandType.Mail and v.btn and v.btn.transform then
        pos = v.btn.transform.position
        break
      end
    end
    if pos then
      do
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
  end
end

function UISettingAccount:ClearFinger()
  if self.fingerDelay then
    self.fingerDelay:Stop()
    self.fingerDelay = nil
  end
  if self.fingerHandle then
    self.fingerHandle:Destroy()
    self.fingerHandle = nil
  end
end

function UISettingAccount:RefreshReward()
  local reward = DataCenter.AccountManager:GetBindAccountReward()
  if next(reward) then
    for i = 1, 1 do
      if reward[i].type == RewardType.GOLD then
        self.rewardList[i].icon:LoadSprite(DataCenter.RewardManager:GetPicByType(reward[i].type, nil, nil, true))
        self.rewardList[i].txt:SetText(reward[i].value)
      else
        self.rewardList[i].icon:LoadSprite(DataCenter.RewardManager:GetPicByType(reward[i].type, reward[i].value.id, nil, true))
        self.rewardList[i].txt:SetText(reward[i].value.num)
      end
    end
  end
end

function UISettingAccount:RefreshShowAccountBindTypeItem()
  if table.IsNullOrEmpty(self.accountBindTypeItemList) then
    self:CreateBindTypeItem("MailBindType", AccountBandType.Mail, 280041, function()
      DataCenter.AccountManager.MailAccount:OnClick()
      self:ClearFinger()
    end)
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
    local count = table.count(self.accountBindTypeItemList)
    for i = 1, count do
      local itemRender = self.accountBindTypeItemList[i]
      itemRender:RefreshShowBindInfo()
    end
  end
end

function UISettingAccount:CreateBindTypeItem(goName, accountBandType, nameKey, clickCallBack)
  local go = self.account_bind_type_obj:GameObjectSpawn(self.account_bind_type_content.transform)
  go.name = goName
  go:SetActive(true)
  local itemRender = self.account_bind_type_content:AddComponent(LWUIAccountBindTypeItemRender, go.name)
  itemRender:ReInit(accountBandType, nameKey, clickCallBack, true)
  table.insert(self.accountBindTypeItemList, itemRender)
end

function UISettingAccount:OnClickModify()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIModifyPassword)
end

function UISettingAccount:OnClickRole()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIRoles, {anim = true, hideTop = true}, 0)
end

function UISettingAccount:OnClickDeviceMgr()
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
          Logger.Log("UISettingAccount OnClickDeviceMgr: \230\156\170\231\187\145\229\174\154\233\130\174\231\174\177\239\188\140\230\151\160\230\179\149\232\191\155\232\161\140\232\174\190\229\164\135\231\174\161\231\144\134")
        end
      end
    }
  })
end

function UISettingAccount:GuideToBindMail()
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

function UISettingAccount:OnClickLogout()
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

return UISettingAccount
