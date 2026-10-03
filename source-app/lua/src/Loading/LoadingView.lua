local timer
local Setting = CS.GameEntry.Setting
local Localization = CS.GameEntry.Localization
local time_sec = 5.0
local all_tips = {}
local all_tips_temp = {}
local all_weight = {}
local all_weight_temp = {}
local _txt_tips, _state_text
local loadingUtil = CS.LoadingUtil
local LoadingState = {
  None = 0,
  Logo = 1,
  Permission = 2,
  ChooseLocalUpdate = 3,
  CheckResVersion = 4,
  DownloadManifest = 5,
  DownloadUpdate = 6,
  LoadDataTable = 7,
  GetServerList = 8,
  GetServerStatus = 9,
  ConnectGame = 10,
  Login = 11,
  AppUpdate = 12,
  PushInit = 13,
  AuthPin = 14,
  CNIdentify = 15,
  LoadScene = 16,
  EnterGame = 17,
  LoadingError = 18,
  Maintenance = 19,
  CreditLimit = 20,
  AccountSelect = 21,
  KRAuth = 22
}
local LoadingStateText = {
  [LoadingState.None] = "",
  [LoadingState.Logo] = "",
  [LoadingState.Permission] = "121015",
  [LoadingState.CheckResVersion] = "121016",
  [LoadingState.DownloadManifest] = "121017",
  [LoadingState.DownloadUpdate] = "121018",
  [LoadingState.LoadDataTable] = "121019",
  [LoadingState.GetServerList] = "121020",
  [LoadingState.GetServerStatus] = "121021",
  [LoadingState.ConnectGame] = "121022",
  [LoadingState.Login] = "121023",
  [LoadingState.AppUpdate] = "",
  [LoadingState.PushInit] = "121024",
  [LoadingState.AuthPin] = "121025",
  [LoadingState.CNIdentify] = "121025",
  [LoadingState.LoadScene] = "121026",
  [LoadingState.EnterGame] = "",
  [LoadingState.LoadingError] = "",
  [LoadingState.Maintenance] = "",
  [LoadingState.KRAuth] = "korea_verify1"
}
local __fetching_notice = false
local __server_back_json

local function OnUpdate()
  time_sec = time_sec + Time.deltaTime
  if time_sec < 4.0 or _txt_tips == nil then
    return
  end
  Localization = CS.GameEntry.Localization
  time_sec = 0.0
  local tipsCount = table.count(all_tips_temp)
  if 0 < tipsCount then
    local index = Mathf.GetRandomByWeight(all_weight_temp)
    _txt_tips:SetLocalText(all_tips_temp[index])
    table.remove(all_tips_temp, index)
    table.remove(all_weight_temp, index)
    if table.count(all_tips_temp) == 0 then
      all_weight_temp = {}
      for k, v in pairs(all_tips) do
        all_tips_temp[k] = v
        if all_weight[k] ~= nil then
          all_weight_temp[k] = all_weight[k]
        end
      end
    end
  end
end

local function AddTimer(self, time)
  if timer == nil then
    timer = TimerManager:GetInstance():GetTimer(0.0, OnUpdate, nil, false, false, false)
  end
  timer:Start()
end

local function InitLoadTips()
  AddTimer()
  local level = Setting:GetInt("FUN_BUILD_MAIN_LEVEL")
  level = level <= 0 and 1 or level
  local objTips = self.transform:Find("Tip")
  if objTips ~= nil then
    _txt_tips = objTips:GetComponent(typeof(CS.TextMeshProUGUIEx))
  end
  all_tips = {}
  LocalController:instance():visitTable(TableName.LoadingTips, function(id, lineData)
    local levelRange = lineData:getValue("level_range")
    local id = lineData:getValue("id")
    local description = lineData:getValue("description")
    local weight = lineData:getValue("rate")
    if weight == nil then
      weight = 1
    end
    if levelRange == "" or id == "" or description == "" then
      return
    end
    local levels = string.split_ii_array(levelRange, ";")
    if table.count(levels) < 2 then
      return
    end
    if level < levels[1] or level > levels[2] then
      return
    end
    local tips = string.split_ss_array(description, ";")
    for k, v in pairs(tips) do
      all_tips[#all_tips + 1] = v
      all_tips_temp[#all_tips_temp + 1] = v
      all_weight[#all_weight + 1] = weight
      all_weight_temp[#all_weight_temp + 1] = weight
    end
  end)
end

local function OnClickServeBtn()
  CS.AIHelp.AIHelpProxy.Show("E002", Localization:GetString("2700006"))
end

local function OnClickNoticeBtn()
  if __server_back_json then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIServerNotice, {anim = false}, __server_back_json)
  elseif not __fetching_notice then
    __fetching_notice = true
    self:FetchNoticeData()
  end
end

local function OnLoadingStateChange(state)
  if loadingUtil.IsLoadingErrorState(state) then
    pcall(function()
      if not CS.ApplicationLaunch.Instance.Loading.isErrorSuccess then
        self.btnHelp.gameObject:SetActive(true)
      end
    end)
  elseif loadingUtil.IsLoadigMaintenanceState(state) then
    self.loadingText.text = Localization:GetString("2700002")
    self.maintenanceDialog:SetActive(true)
    self.maintenanceDialog.transform.localScale = Vector3.one * 0.8
    self.maintenanceDialog.transform:DOScale(Vector3.one, 0.2):SetEase(CS.DG.Tweening.Ease.OutBack)
    TimerManager:GetInstance():DelayInvoke(function()
      OnClickNoticeBtn()
    end, 0.5)
  end
  Logger.Log("OnLoadingStateChange xx " .. tostring(state))
  if not IsNull(_state_text) then
    local text = loadingUtil.GetLoadingStateText(state)
    if not string.IsNullOrEmpty(text) then
      _state_text.text = Localization:GetString(text)
    end
  end
end

local function OnBeginDownloadUpdate()
  OnClickNoticeBtn()
end

local function InitStateText()
  local objState = self.transform:Find("safeArea/State")
  if objState ~= nil then
    _state_text = objState:GetComponent(typeof(CS.TextMeshProUGUIEx))
  end
end

local function InitNotice()
  if not IsNull(self.btnNotice) then
    self.btnNotice.onClick:AddListener(OnClickNoticeBtn)
  end
end

local function DisposeNotice()
  if not IsNull(self.btnNotice) then
    self.btnNotice.onClick:RemoveListener(OnClickNoticeBtn)
  end
end

local function InitServe()
  if not IsNull(self.btnServe) and not IsNull(self.btnHelp) then
    self.btnServe.onClick:AddListener(OnClickServeBtn)
    self.btnHelp.onClick:AddListener(OnClickServeBtn)
  end
end

local function DisposeServe()
  if not IsNull(self.btnServe) and not IsNull(self.btnHelp) then
    self.btnServe.onClick:RemoveListener(OnClickServeBtn)
    self.btnHelp.onClick:RemoveListener(OnClickServeBtn)
  end
end

function OnStart()
  Logger.Log("LoadingView OnStart")
  InitLoadTips()
  InitStateText()
  InitNotice()
  InitServe()
  EventManager:GetInstance():AddListener(EventId.LoadingState, OnLoadingStateChange)
  EventManager:GetInstance():AddListener(EventId.BeginDownloadUpdate, OnBeginDownloadUpdate)
  __fetching_notice = false
  __server_back_json = nil
end

function OnDestroy()
  if timer ~= nil then
    timer:Stop()
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIServerNotice)
  EventManager:GetInstance():RemoveListener(EventId.LoadingState, OnLoadingStateChange)
  EventManager:GetInstance():RemoveListener(EventId.BeginDownloadUpdate, OnBeginDownloadUpdate)
  DisposeNotice()
  DisposeServe()
  __fetching_notice = false
  __server_back_json = nil
end

function OnNoticeDataBack(json)
  if not json then
    return
  end
  __server_back_json = json
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIServerNotice, {anim = false}, __server_back_json)
end
