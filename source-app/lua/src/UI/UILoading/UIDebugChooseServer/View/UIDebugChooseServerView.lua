local UIDebugChooseServerView = BaseClass("UIDebugChooseServerView", UIBaseView)
local base = UIBaseView
local panel_path = "Panel"
local continueBtnPath = "Panel/LeftGameObject/continue"
local newServerBtnPath = "Panel/LeftGameObject/NewServer"
local historyAccountBtnPath = "Panel/LeftGameObject/HistoryAccount"
local ipInputPath = "Panel/LeftGameObject/Inputs/Ip/InputField1"
local portInputPath = "Panel/LeftGameObject/Inputs/Port/InputField2"
local zoneInputPath = "Panel/LeftGameObject/Inputs/Zone/InputField3"
local uidInuptPath = "Panel/LeftGameObject/Inputs/Uid/InputField4"
local searchInuptPath = "Panel/LeftGameObject/Inputs/Search/InputField5"
local accessTokenInputPath = "Panel/LeftGameObject/Inputs/AT/InputField6"
local setting_content_path = "Panel/Scroll View/Viewport/Content"
local show_btn_path = "showBtn"
local show_btnTxt_path = "showBtn/Text"
local choose_url_btn_path = "chooseURLBtn"
local uwa_btn_path = "UWABtn"
local choose_url_btnTxt_path = "chooseURLBtn/chooseURLBtnText"
local token_fill_btn_path = "Panel/LeftGameObject/Inputs/AT/TokenFillBtn"
local bg1_path = "Image1"
local bg2_path = "Image2"
local wsTogglePath = "Panel/LeftGameObject/WsToggle"
local DebugServerItem = require("UI.UILoading.UIDebugChooseServer.Controller.DebugServerItem")
local AccountListManager = require("DataCenter.AccountData.AccountListManager")
local rapidjson = require("rapidjson")
local SDKManager = CS.SDKManager
local serverItems = {}
local Setting = CS.GameEntry.Setting
local SettingKeys = CS.GameDefines.SettingKeys

local function CheckPort(port)
  local nPost = toInt(port)
  if nPost == 0 then
    return 8088
  end
  return nPost
end

local function OnCreate(self)
  base.OnCreate(self)
  if not table.IsNullOrEmpty(self.userData) then
    self.ctrl:SetParam(self.userData[1])
  end
  self.panel = self:AddComponent(UIBaseContainer, panel_path)
  self.continueBtn = self:AddComponent(UIButton, continueBtnPath)
  self.newServerBtn = self:AddComponent(UIButton, newServerBtnPath)
  self.historyAccountBtn = self:AddComponent(UIButton, historyAccountBtnPath)
  self.show_btn = self:AddComponent(UIButton, show_btn_path)
  self.show_btnTxt = self:AddComponent(UIText, show_btnTxt_path)
  self.choose_url_btn = self:AddComponent(UIButton, choose_url_btn_path)
  self.uwa_btn = self:AddComponent(UIButton, uwa_btn_path)
  self.token_fill_btn = self:AddComponent(UIButton, token_fill_btn_path)
  self.ipInput = self:AddComponent(UIInput, ipInputPath)
  self.portInput = self:AddComponent(UIInput, portInputPath)
  self.zoneInput = self:AddComponent(UIInput, zoneInputPath)
  self.uidInput = self:AddComponent(UIInput, uidInuptPath)
  self.searchInuptPath = self:AddComponent(UIInput, searchInuptPath)
  self.searchInuptPath:SetOnValueChange(function(value)
    self:SearchIptOnValueChange(value)
  end)
  self.accessTokenInput = self:AddComponent(UIInput, accessTokenInputPath)
  self._serverCell = self.transform:Find("DebugServerItem").gameObject
  self._serverCell:GameObjectCreatePool()
  self._serverListRoot = self.transform:Find(setting_content_path)
  self.setting_content = self:AddComponent(UIBaseContainer, setting_content_path)
  self.continueBtn:SetOnClick(function()
    self:OnContinueClick()
  end)
  self.newServerBtn:SetOnClick(function()
    UIUtil.ShowMessage("\231\161\174\229\174\154\229\188\128\229\167\139\230\150\176\230\184\184\230\136\143\229\144\151\239\188\159", 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      self:OnNewServerClick()
    end, function()
    end)
  end)
  self.historyAccountBtn:SetOnClick(function()
    self:OnShowHistoryAccount()
  end)
  self.show_btn:SetOnClick(function()
    self.show_btnTxt:SetText(self.panel.activeSelf and "\230\152\190\231\164\186" or "\233\154\144\232\151\143")
    self.panel:SetActive(not self.panel.activeSelf)
  end)
  self.choose_url_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingChooseURL, {anim = true})
  end)
  self.uwa_btn:SetOnClick(function()
    if CommonUtil.IsEditor() then
      UIUtil.ShowTips("\231\188\150\232\190\145\229\153\168\228\184\139\229\176\177\229\136\171uwa\228\186\134\232\161\140\228\185\136\229\174\157\229\132\191")
      return
    end
    SDKManager.InitUWAGotOnline()
  end)
  self.token_fill_btn:SetActive(CS.NetworkURLConfig.IsOnline)
  self.token_fill_btn:SetOnClick(function()
    if CS.GameEntry.Network.IsConnected == false then
      local zone = self.zoneInput:GetText()
      local uid = self.uidInput:GetText()
      if string.IsNullOrEmpty(zone) then
        UIUtil.ShowTips("\232\175\183\229\161\171\229\134\153Zone")
        return
      elseif string.IsNullOrEmpty(uid) then
        UIUtil.ShowTips("\232\175\183\229\161\171\229\134\153Uid")
        return
      end
      local url = "https://lastwar-gm-us-ali.lastwargame.com:13800/scripts/fixToken.php"
      local postData = {
        zone = zone,
        gameuid = uid,
        uuid = CS.GameEntry.Device:GetDeviceUid(),
        opt = "fix"
      }
      CS.GameKit.Base.WebRequestManager.Instance:Post(url, postData, function(ret)
        if ret.isDone then
          local data = rapidjson.decode(ret.downloadHandler.text)
          if data.at and data.at.token then
            self.accessTokenInput:SetText(data.at.token)
          end
        end
      end, 0, 0, nil)
    end
  end)
  self.wsToggle = self:AddComponent(UIToggle, wsTogglePath)
  self:InitView(OnCallBack)
end

local function InitView(self, OnCallBack)
  local serverKey = SettingKeys.LAST_SERVER_KEY
  local lastServerID = Setting:GetInt(serverKey, 0)
  self._lastServer = CS.GameEntry.Network:GetServerInfo(lastServerID)
  if self._lastServer ~= nil then
    self.ipInput:SetText(self._lastServer.ip)
    if self._lastServer.port == 0 then
      self.portInput:SetText("8088")
    else
      self.portInput:SetText(CheckPort(self._lastServer.port))
    end
    self.zoneInput:SetText(self._lastServer.zone)
  else
    self.ipInput:SetText("")
    self.portInput:SetText("8088")
    self.zoneInput:SetText("")
  end
  self.zoneInput:SetInteractable(true)
  self.portInput:SetInteractable(true)
  self.uidInput:SetText(CS.AccountCredentialManager.ServerInfo.uid)
  self.accessTokenInput:SetText(CS.AccountCredentialManager.AuthTokens.at)
  self:RefreshServerList()
  local rand = math.floor(UITimeManager:GetInstance():GetServerTime()) % 3 + 1
  self.wsToggle:SetIsOn(false)
end

local function OnShowHistoryAccount(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChooseServerAccountList)
end

local function OnChangeClick(self)
  local ip = self.ipInput:GetText()
  local port = self.portInput:GetText()
  local zone = self.zoneInput:GetText()
  local uid = self.uidInput:GetText()
  local use_ws = self.wsToggle:GetIsOn()
  local connection_type = CS.NetConnectionType.CUSTOM_TCP
  if use_ws then
    connection_type = CS.NetConnectionType.CUSTOM_WEBSOCKET
  end
  local at = self.accessTokenInput:GetText()
  if ip == "" or port == "" or zone == "" then
    return
  end
  port = tonumber(port)
  if use_ws then
    port = 80
  end
  if self._lastServer ~= nil then
    Setting:SetInt(SettingKeys.LAST_SERVER_KEY, tonumber(self._lastServer.id))
  end
  Logger.LogInfo("[AT]SetGUID_DebugChangeClick:" .. tostring(uid) .. " at:" .. at)
  CS.AccountCredentialManager.SetServerNetInfo(ip, port, zone, connection_type)
  CS.AccountCredentialManager.SetUID(uid)
  CS.AccountCredentialManager.SetAT(at)
  CS.AccountCredentialManager.Save()
  if CS.GameEntry.Network.IsConnected == false then
    self.ctrl:GoContinue(ip, port, zone, uid, connection_type)
  else
    CS.ApplicationLaunch.Instance:ReloadGame()
  end
end

local function OnContinueClick(self)
  self:OnChangeClick()
end

local function OnNewServerClick(self)
  local ip = self.ipInput:GetText()
  local port = self.portInput:GetText()
  local zone = self.zoneInput:GetText()
  local use_ws = self.wsToggle:GetIsOn()
  local connection_type = CS.NetConnectionType.CUSTOM_TCP
  if use_ws then
    connection_type = CS.NetConnectionType.CUSTOM_WEBSOCKET
  end
  if ip == "" or port == "" or zone == "" then
    return
  end
  port = tonumber(port)
  local uid = ""
  if self._lastServer ~= nil then
    Setting:SetInt(SettingKeys.LAST_SERVER_KEY, tonumber(self._lastServer.id))
  end
  Logger.LogInfo("[AT]SetGUID_DebugNewSvrClick:" .. tostring(uid))
  CS.AccountCredentialManager.SetServerNetInfo(ip, port, zone, connection_type)
  CS.AccountCredentialManager.SetUID(uid)
  CS.AccountCredentialManager.SetAT(at)
  CS.AccountCredentialManager.Save()
  if CS.GameEntry.Network.IsConnected == false then
    self.ctrl:GoContinue(ip, port, zone, uid, connection_type)
  else
    CS.ApplicationLaunch.Instance:ReloadGame()
  end
end

local function OnChooseServer(self, param)
  local use_ws = self.wsToggle:GetIsOn()
  if use_ws and not string.IsNullOrEmpty(param.Data.ws_ip) then
    self.ipInput:SetText(param.Data.ws_ip)
    self.portInput:SetText("80")
  else
    self.ipInput:SetText(param.Data.ip)
    self.portInput:SetText(CheckPort(param.Data.port))
    self.wsToggle:SetIsOn(false)
  end
  self.zoneInput:SetText(param.Data.zone)
  self.uidInput:SetText(nil)
  self._lastServer = param.Data
end

local function ClearItems(self)
  self._serverCell:GameObjectDestroyAll()
end

local function OnDestroy(self)
  base.OnDestroy(self)
  self.continueBtn = nil
  self.newServerBtn = nil
  self.historyAccountBtn = nil
  self.ipInput = nil
  self.portInput = nil
  self.zoneInput = nil
  self.uidInput = nil
  self.searchInuptPath = nil
  self.firstItemData = nil
  self._lastServer = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnGetHistoryAccountData(self, param)
  local accountInfo = param.Data
  if accountInfo == nil then
    return
  end
  self.ipInput:SetText(accountInfo.ip)
  self.portInput:SetText(CheckPort(accountInfo.port))
  self.zoneInput:SetText(accountInfo.zone)
  self.uidInput:SetText(accountInfo.gameUid)
  self.accessTokenInput:SetText(accountInfo.accessToken)
  if self._lastServer ~= nil then
    self._lastServer.id = accountInfo.serverid
  end
  Setting:SetInt(SettingKeys.LAST_SERVER_KEY, accountInfo.serverid)
end

local function SearchIptOnValueChange(self, value)
  self:RefreshServerList(value)
end

local function RefreshServerList(self, searchStr)
  local function nocase(s)
    s = string.gsub(s, "%a", function(c)
      return string.format("[%s%s]", string.lower(c), string.upper(c))
    end)
    return s
  end
  
  local serverList = CS.GameEntry.Network.ServerList
  self.setting_content:RemoveComponents(DebugServerItem)
  self._serverCell:GameObjectRecycleAll()
  for i = 0, serverList.Length - 1 do
    local data = serverList[i]
    local name = data.name or data.zone
    local isSearch = searchStr == nil and true or string.match(name, nocase(searchStr))
    if isSearch then
      local item = self._serverCell:GameObjectSpawn(self._serverCell.transform)
      item.transform:SetParent(self._serverListRoot)
      item.name = name
      item:SetActive(true)
      local param = {}
      if self._lastServer ~= nil and self._lastServer.ip == data.ip then
        param.isOn = true
      else
        param.isOn = false
      end
      param.Data = data
      
      function param.ChooseServer()
        self:OnChooseServer(param)
      end
      
      local cell = self.setting_content:AddComponent(DebugServerItem, item.name, param)
      if self.firstItemData == nil then
        self.firstItemData = param
      end
    end
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.LF_Account_History, self.OnGetHistoryAccountData)
end

local function OnRemoveListener(self)
  base.OnAddListener(self)
  self:RemoveUIListener(EventId.LF_Account_History, self.OnGetHistoryAccountData)
end

UIDebugChooseServerView.OnCreate = OnCreate
UIDebugChooseServerView.OnDestroy = OnDestroy
UIDebugChooseServerView.OnEnable = OnEnable
UIDebugChooseServerView.OnDisable = OnDisable
UIDebugChooseServerView.InitView = InitView
UIDebugChooseServerView.ClearItems = ClearItems
UIDebugChooseServerView.OnChooseServer = OnChooseServer
UIDebugChooseServerView.OnNewServerClick = OnNewServerClick
UIDebugChooseServerView.OnContinueClick = OnContinueClick
UIDebugChooseServerView.OnChangeClick = OnChangeClick
UIDebugChooseServerView.OnShowHistoryAccount = OnShowHistoryAccount
UIDebugChooseServerView.OnAddListener = OnAddListener
UIDebugChooseServerView.OnRemoveListener = OnRemoveListener
UIDebugChooseServerView.OnGetHistoryAccountData = OnGetHistoryAccountData
UIDebugChooseServerView.SearchIptOnValueChange = SearchIptOnValueChange
UIDebugChooseServerView.RefreshServerList = RefreshServerList
return UIDebugChooseServerView
