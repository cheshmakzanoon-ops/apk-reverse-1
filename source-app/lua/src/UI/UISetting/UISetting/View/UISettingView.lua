local UISettingView = BaseClass("UISettingView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UISettingCell = require("UI.UISetting.UISetting.Component.UISettingCell")
local txt_title_path = "Root/Content/UICommonPopBg/bg_3/TitleTxt"
local goback_btn_path = "Panel"
local return_btn_path = "Root/Content/UICommonPopBg/bg_3/CloseBtn"
local world_time_text_path = "Root/Content/WorldTimeBg/WorldTimeText"
local scroll_view_path = "Root/Content/ScrollView"
local fileVersionTxt_path = "Root/Content/fileVersionTxt"
local version1_text_path = "Root/Content/version1"
local version2_text_path = "Root/Content/version2"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:SetAllCellsDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.goback_btn = self:AddComponent(UIButton, goback_btn_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.world_time_text = self:AddComponent(UIText, world_time_text_path)
  self.fileVersionTxt = self:AddComponent(UIText, fileVersionTxt_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.version1 = self:AddComponent(UIText, version1_text_path)
  self.version2 = self:AddComponent(UIText, version2_text_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCellMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnCellMoveOut(itemObj, index)
  end)
  self.goback_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

local function ComponentDestroy(self)
  self.txt_title = nil
  self.return_btn = nil
  self.world_time_text = nil
  self.scroll_view = nil
end

local function DataDefine(self)
  self.worldText = Localization:GetString("800811") .. ": "
  self.timer = nil
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
  
  self.list = {}
  if CS.CommonUtils.IsDebug() then
    self.fileVersionTxt:SetText(LuaEntry.GlobalData:GetFileVersion())
  end
  local resVer = CS.GameEntry.Resource:GetResVersion()
  local ver = CS.GameEntry.Sdk.Version
  local verCode = CS.GameEntry.Sdk.VersionCode
  self.version1:SetText(Localization:GetString("100050") .. ver .. "[* " .. verCode .. " *]")
  self.version2:SetText(Localization:GetString("100051") .. resVer)
end

local function DataDestroy(self)
  self.timer_action = nil
  self:DeleteTimer()
  self.worldText = nil
  self.list = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self.txt_title:SetLocalText(280012)
  self:AddTimer()
  self:RefreshTime()
  self:ShowCells()
end

local function SetAllCellsDestroy(self)
  self:ClearScroll()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.CountryFlagChanged, self.CountryFlagChangedSignal)
  self:AddUIListener(EventId.UpdateAIHelpRedPoint, self.CountryFlagChangedSignal)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.CountryFlagChanged, self.CountryFlagChangedSignal)
  self:RemoveUIListener(EventId.UpdateAIHelpRedPoint, self.CountryFlagChangedSignal)
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function RefreshTime(self)
  self.world_time_text:SetText(self.worldText .. UITimeManager:GetInstance():TimeStampToTimeForServer(UITimeManager:GetInstance():GetServerTime()))
end

local function ShowCells(self)
  self:ClearScroll()
  self.list = self:GetShowList()
  local tempCount = table.count(self.list)
  if 0 < tempCount then
    self.scroll_view:SetTotalCount(tempCount)
    self.scroll_view:RefillCells()
  end
end

local function OnCellMoveIn(self, itemObj, index)
  local tempType = self.list[index]
  itemObj.name = tempType
  local cellItem = self.scroll_view:AddComponent(UISettingCell, itemObj)
  local param = UISettingCell.Param.New()
  param.settingType = tempType
  cellItem:ReInit(param)
  cellItem:SetActive(true)
end

local function OnCellMoveOut(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UISettingCell)
end

local function ClearScroll(self)
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UISettingCell)
end

local function GetShowList(self)
  local list = {}
  local Player = LuaEntry.Player
  local settings = self.ctrl.GetSettingSort()
  for k, v in ipairs(settings) do
    if v == SettingType.GM then
      if Player.gmFlag > 0 then
        table.insert(list, v)
      end
    elseif v == SettingType.Ping then
      if Player.gmFlag > 0 then
        table.insert(list, v)
      end
    elseif v == SettingType.Language then
      local isOn = CS.CommonUtils.IsDebug()
      if 0 < LuaEntry.Player:GetGMFlag() then
        table.insert(list, v)
      elseif isOn then
        table.insert(list, v)
      elseif 0 >= LuaEntry.Player:GetGMFlag() then
        table.insert(list, v)
      end
    elseif v == SettingType.ChangeId then
      local isOn = CS.CommonUtils.IsDebug()
      if 0 < LuaEntry.Player:GetGMFlag() then
        table.insert(list, v)
      elseif isOn then
        table.insert(list, v)
      end
    elseif v == SettingType.PVE then
      if CS.CommonUtils.IsDebug() then
        table.insert(list, v)
      end
    elseif v == SettingType.PVEFreeCamera then
      if CS.CommonUtils.IsDebug() and CS.SceneManager.CurrSceneID == SceneManagerSceneID.PVE then
        table.insert(list, v)
      end
    elseif v == SettingType.AllowTracking then
      local iphone = CS.SDKManager.IS_IPhonePlayer()
      local allow = CS.GameEntry.Sdk:IsTrackingEnabled()
      if iphone and not allow then
        table.insert(list, v)
      end
    elseif v == SettingType.NewGame then
      table.insert(list, v)
    elseif v == SettingType.Roles then
      local configOpenState = LuaEntry.DataConfig:CheckSwitch("account_switch")
      local state = DataCenter.AccountManager:GetAccountBindState()
      if state == AccountBandState.Band then
        table.insert(list, v)
      end
    elseif v == SettingType.PlayerNation then
      if not LuaEntry.GlobalData:IsChina() and not LuaEntry.Player:IsFromBIGCHINAorUsingLangZH() then
        table.insert(list, v)
      end
    elseif v == SettingType.GameNotice then
      local isShow = DataCenter.WorldNoticeManager:CheckNotice()
      if isShow then
        table.insert(list, v)
      end
    elseif v == SettingType.CustomDecoration then
      table.insert(list, v)
    elseif v == SettingType.DeleteAccount then
      local funcOn = UIUtil.IsOpenDeleteAccountFunc()
      if funcOn then
        table.insert(list, v)
      end
    elseif v == SettingType.PrivacyAgreement then
      table.insert(list, v)
    elseif v == SettingType.UserAgreement then
      table.insert(list, v)
    else
      table.insert(list, v)
    end
  end
  return list
end

local function CountryFlagChangedSignal(self)
  self.scroll_view:RefreshCells()
end

UISettingView.OnCreate = OnCreate
UISettingView.OnDestroy = OnDestroy
UISettingView.OnEnable = OnEnable
UISettingView.OnDisable = OnDisable
UISettingView.OnAddListener = OnAddListener
UISettingView.OnRemoveListener = OnRemoveListener
UISettingView.ComponentDefine = ComponentDefine
UISettingView.ComponentDestroy = ComponentDestroy
UISettingView.DataDefine = DataDefine
UISettingView.DataDestroy = DataDestroy
UISettingView.ReInit = ReInit
UISettingView.SetAllCellsDestroy = SetAllCellsDestroy
UISettingView.RefreshTime = RefreshTime
UISettingView.AddTimer = AddTimer
UISettingView.DeleteTimer = DeleteTimer
UISettingView.ShowCells = ShowCells
UISettingView.OnCellMoveIn = OnCellMoveIn
UISettingView.OnCellMoveOut = OnCellMoveOut
UISettingView.ClearScroll = ClearScroll
UISettingView.GetShowList = GetShowList
UISettingView.CountryFlagChangedSignal = CountryFlagChangedSignal
return UISettingView
