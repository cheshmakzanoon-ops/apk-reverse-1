local base = UIBaseView
local UIBuildingPersonalFurnaceView = BaseClass("UIBuildingPersonalFurnaceView", base)
local UIHeroPropertyDetailTipView = require("UI.UILWHero.UIHeroPropertyDetailTip.View.UIHeroPropertyDetailTipView")
local ContentSizeFitter = CS.UnityEngine.UI.ContentSizeFitter
local Localization = CS.GameEntry.Localization
local closeMask_path = "UICommonPopUpTitle/panel"
local closeBtn_path = "UICommonPopUpTitle/CloseBtn"
local titleText_path = "UICommonPopUpTitle/Common_img_title/titleText"
local desText_path = "MiddleBg/BuildInfo/desText"
local maxPowerToggle_path = "MiddleBg/BuildInfo/Work/LimitOn/LimitOnBtn"
local functionSwitchToggle_path = "MiddleBg/BuildInfo/Work/TurnOn/TurnOnBtn"
local temperature_path = "MiddleBg/BuildInfo/temperature/tempCounter"
local speed_path = "MiddleBg/BuildInfo/cost/speed"
local maxCheckmark_path = "MiddleBg/BuildInfo/Work/LimitOn/limitFlag"
local fucntionCheckmark_path = "MiddleBg/BuildInfo/Work/TurnOn/openflag"
local workStatus_path = "MiddleBg/BuildInfo/Power/now"
local flintCount_path = "MiddleBg/BuildInfo/flintCount"
local point_path = "MiddleBg/BuildInfo/Power/point"
local openTemperature_path = "MiddleBg/BuildInfo/Power/middle"
local overTemperature_path = "MiddleBg/BuildInfo/Power/to"
local burnCountdown_path = "MiddleBg/BuildInfo/Work/burnCountdown"
local desBtn_path = "MiddleBg/BuildInfo/DesBtn"
local yellowEfffect_path = "MiddleBg/BuildInfo/Power/Fire/yellow"
local redEffect_path = "MiddleBg/BuildInfo/Power/Fire/red"
local activeSettingBtn_path = "MiddleBg/BuildInfo/setting/activeSetting"
local overloadSettingBtn_path = "MiddleBg/BuildInfo/setting/overloadSetting"
local activtFlag_path = "MiddleBg/BuildInfo/setting/activeSetting/activeSettingFlag"
local overloadFlag_path = "MiddleBg/BuildInfo/setting/overloadSetting/overloadSettingFlag"
local buildingIconAnimator_path = "MiddleBg/BuildInfo/buildingswitch"
local activeiSize_path = "MiddleBg/BuildInfo/setting/activeSetting/activeSettingName"
local overloadSize_path = "MiddleBg/BuildInfo/setting/overloadSetting/overloadSettingName"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshPanel()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.closeMask = self:AddComponent(UIButton, closeMask_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.desText = self:AddComponent(UIText, desText_path)
  self.maxPowerToggle = self:AddComponent(UIButton, maxPowerToggle_path)
  self.functionSwitchToggle = self:AddComponent(UIButton, functionSwitchToggle_path)
  self.temperature = self:AddComponent(UIText, temperature_path)
  self.speed = self:AddComponent(UIText, speed_path)
  self.maxCheckmark = self:AddComponent(UIBaseContainer, maxCheckmark_path)
  self.fucntionCheckmark = self:AddComponent(UIBaseContainer, fucntionCheckmark_path)
  self.workStatus = self:AddComponent(UIText, workStatus_path)
  self.flintCount = self:AddComponent(UIText, flintCount_path)
  self.point = self:AddComponent(UIBaseContainer, point_path)
  self.openTemperature = self:AddComponent(UIText, openTemperature_path)
  self.overTemperature = self:AddComponent(UIText, overTemperature_path)
  self.burnCountdown = self:AddComponent(UIText, burnCountdown_path)
  self.desBtn = self:AddComponent(UIButton, desBtn_path)
  self.yellowEfffect = self:AddComponent(UIBaseContainer, yellowEfffect_path)
  self.redEffect = self:AddComponent(UIBaseContainer, redEffect_path)
  self.activeSettingBtn = self:AddComponent(UIButton, activeSettingBtn_path)
  self.overloadSettingBtn = self:AddComponent(UIButton, overloadSettingBtn_path)
  self.activtFlag = self:AddComponent(UIBaseContainer, activtFlag_path)
  self.overloadFlag = self:AddComponent(UIBaseContainer, overloadFlag_path)
  self.buildingIconAnimator = self:AddComponent(UIAnimator, buildingIconAnimator_path)
  self.activeiSize = self:AddComponent(UIBaseContainer, activeiSize_path)
  self.overloadSize = self:AddComponent(UIBaseContainer, overloadSize_path)
  self.activeSizeFitter = self.activeiSize.rectTransform:GetComponent(typeof(ContentSizeFitter))
  self.overloadSizeFitter = self.overloadSize.rectTransform:GetComponent(typeof(ContentSizeFitter))
  local tmPro = self.activeiSize.rectTransform:GetComponent(typeof(CS.TextMeshProUGUIEx))
  if tmPro then
    local width = tmPro:GetPreferredValues(Localization:GetString("season_build_770000_desc_01"))
    if width.x > 620 then
      self.activeSizeFitter.enabled = false
      self.activeiSize:SetSizeDeltaXY(620, self.activeiSize:GetSizeDelta().y)
    else
      self.activeSizeFitter.enabled = true
    end
  end
  tmPro = self.overloadSize.rectTransform:GetComponent(typeof(CS.TextMeshProUGUIEx))
  if tmPro then
    local width = tmPro:GetPreferredValues(Localization:GetString("season_build_770000_desc_02"))
    if width.x > 620 then
      self.overloadSizeFitter.enabled = false
      self.overloadSize:SetSizeDeltaXY(620, self.activeiSize:GetSizeDelta().y)
    else
      self.overloadSizeFitter.enabled = true
    end
  end
  self.overloadFlag:SetActive(false)
  self.activtFlag:SetActive(false)
  self.point:SetEulerAnglesXYZ(0, 0, 95)
  self.closeMask:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.yellowEfffect:SetActive(false)
  self.redEffect:SetActive(false)
  self.maxPowerToggle:SetSafeClickMode(true)
  self.maxPowerToggle:SetOnClick(function()
    self:OnMaxPowerToggleChange()
  end)
  self.functionSwitchToggle:SetSafeClickMode(true)
  self.functionSwitchToggle:SetOnClick(function()
    self:OnFunctionToggleChange()
  end)
  self.activeSettingBtn:SetSafeClickMode(true)
  self.activeSettingBtn:SetOnClick(function()
    self:OnSettingActiveBtn()
  end)
  self.overloadSettingBtn:SetSafeClickMode(true)
  self.overloadSettingBtn:SetOnClick(function()
    self:OnSettingOverLoadBtn()
  end)
  self.desBtn:SetOnClick(function()
    self:DesBtn()
  end)
end

local function ComponentDestroy(self)
  self.closeMask = nil
  self.closeBtn = nil
  self.titleText = nil
  self.desText = nil
  self.maxPowerToggle = nil
  self.functionSwitchToggle = nil
  self.temperature = nil
  self.speed = nil
  self.maxCheckmark = nil
  self.fucntionCheckmark = nil
  self.workStatus = nil
  self.flintCount = nil
  self.point = nil
  self.openTemperature = nil
  self.overTemperature = nil
  self.burnCountdown = nil
  self.desBtn = nil
  self.yellowEfffect = nil
  self.redEffect = nil
  self.activeSettingBtn = nil
  self.overloadSettingBtn = nil
  self.activtFlag = nil
  self.overloadFlag = nil
  self.buildingIconAnimator = nil
  self.activeiSize = nil
  self.overloadSize = nil
  self.activeSizeFitter = nil
  self.overloadSizeFitter = nil
end

local function DataDefine(self)
  local data = self:GetUserData()
  self.buildUuid = tonumber(data)
  self.buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.buildUuid)
end

local function DataDestroy(self)
end

function UIBuildingPersonalFurnaceView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BUILDING_FURNACE_DATA_UPDATE, self.OnStateDataChange)
  self:AddUIListener(EventId.BUILDING_FURNACE_SETTING_DATA_UPDATE, self.OnSettingStateDataChange)
  self:AddUIListener(EventId.RESOURCE_REDUCE_TICK, self.ResoueceUpdate)
  self:AddUIListener(EventId.ResourceUpdated, self.ResoueceUpdate)
end

function UIBuildingPersonalFurnaceView:OnRemoveListener()
  self:RemoveUIListener(EventId.BUILDING_FURNACE_DATA_UPDATE, self.OnStateDataChange)
  self:RemoveUIListener(EventId.RESOURCE_REDUCE_TICK, self.ResoueceUpdate)
  self:RemoveUIListener(EventId.ResourceUpdated, self.ResoueceUpdate)
  self:RemoveUIListener(EventId.BUILDING_FURNACE_SETTING_DATA_UPDATE, self.OnSettingStateDataChange)
  base.OnRemoveListener(self)
end

function UIBuildingPersonalFurnaceView:RefreshPanel()
  local buildId = self.buildData.itemId
  local level = self.buildData.level
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  self.buildCurLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
  local buildName = Localization:GetString(self.buildCurLevelTemplate.name)
  local buildDes = Localization:GetString(buildTemplate.des)
  self.titleText:SetText(buildName)
  self.desText:SetText(buildDes)
  local furnaceData = DataCenter.BuildManager:GetFurnaceData(self.buildData.uuid)
  self.burnCountdown:SetText("")
  self.playerAniName = nil
  self.state = HeatSourceState.None
  self.settingState = HeatSourceState.None
  if furnaceData then
    self.state = furnaceData.state
    if furnaceData.settingState then
      self.settingState = furnaceData.settingState
    end
    if furnaceData.endTime and furnaceData.endTime > 0 then
      self.burnEndTime = furnaceData.endTime
    else
      self.burnEndTime = nil
    end
    self:Update1000MS()
  end
  if self.state == HeatSourceState.Close then
    self.playerAniName = "UIBuildingPersonalFurnaceS2tour01"
  elseif self.state == HeatSourceState.Active then
    self.playerAniName = "UIBuildingPersonalFurnaceS2tour02"
  elseif self.state == HeatSourceState.Overload then
    self.playerAniName = "UIBuildingPersonalFurnaceS2tour03"
  else
    self.playerAniName = "UIBuildingPersonalFurnaceS2tour01"
  end
  local count = LuaEntry.Resource:GetCntByResType(self.buildCurLevelTemplate.coal_overload[1])
  self.flintCount:SetText(count)
  self:RefreshState()
  self.buildingIconAnimator:Play(self.playerAniName)
  self:SetttingStateFlag()
  if self.state == HeatSourceState.None then
    SFSNetwork.SendMessage(MsgDefines.UserBuildingFurnaceInfo)
  end
end

function UIBuildingPersonalFurnaceView:RefreshState()
  local activeTemperature = 0
  local overTemperature = 0
  local default_temperature = 0
  if not string.IsNullOrEmpty(self.buildCurLevelTemplate.temperature_status) then
    local dataTemperature = DataCenter.HeatSourceTemplateManager:GetTemplate(tonumber(self.buildCurLevelTemplate.temperature_status))
    activeTemperature = dataTemperature.active_temperature
    overTemperature = dataTemperature.overload_temperature
    default_temperature = dataTemperature.default_temperature
  end
  self.openTemperature:SetText(activeTemperature .. "\194\176C")
  self.overTemperature:SetText(overTemperature .. "\194\176C")
  local state, temp, meta, addTable = DataCenter.BuildManager:GetFurnaceStateAndTemp()
  local addValue = 0
  if addTable then
    for key, value in pairs(addTable) do
      addValue = addValue + value
    end
  end
  local x, y, z = self.point:GetEulerAnglesXYZ()
  local oldValue = z
  local newValue = 95
  if 180 < z then
    oldValue = z - 360
  end
  if self.state == HeatSourceState.Close then
    self.temperature:SetText("0\194\176C")
    self.speed:SetText("0")
    newValue = 95
    self.maxCheckmark:SetActive(false)
    self.fucntionCheckmark:SetActive(false)
    self.workStatus:SetLocalText("season_s2_temperature_status_name03")
    self.yellowEfffect:SetActive(false)
    self.redEffect:SetActive(false)
  elseif self.state == HeatSourceState.Active then
    self.maxCheckmark:SetActive(false)
    self.fucntionCheckmark:SetActive(true)
    newValue = 0
    if 0 < addValue then
      self.temperature:SetText(activeTemperature .. "<color=#5FEF87>+" .. tostring(addValue) .. "</color>\194\176C")
    else
      self.temperature:SetText(activeTemperature .. "\194\176C")
    end
    if #self.buildCurLevelTemplate.coal_normal == 2 then
      local cost = self.buildCurLevelTemplate.coal_normal[2]
      local str = Localization:GetString("season_s2_storm_event_32", cost)
      self.speed:SetText(str)
    else
      self.speed:SetText("0")
    end
    self.workStatus:SetLocalText("season_s2_temperature_status_name04")
    self.yellowEfffect:SetActive(true)
    self.redEffect:SetActive(false)
  elseif self.state == HeatSourceState.Overload then
    self.workStatus:SetLocalText("season_s2_temperature_status_name05")
    if 0 < addValue then
      self.temperature:SetText(overTemperature .. "<color=#5FEF87>+" .. tostring(addValue) .. "</color>\194\176C")
    else
      self.temperature:SetText(overTemperature .. "\194\176C")
    end
    newValue = -95
    if #self.buildCurLevelTemplate.coal_overload == 2 then
      local cost = self.buildCurLevelTemplate.coal_overload[2]
      local str = Localization:GetString("season_s2_storm_event_32", cost)
      self.speed:SetText(str)
    else
      self.speed:SetText("0")
    end
    self.yellowEfffect:SetActive(false)
    self.redEffect:SetActive(true)
    self.maxCheckmark:SetActive(true)
    self.fucntionCheckmark:SetActive(true)
  else
    self.maxCheckmark:SetActive(false)
    self.fucntionCheckmark:SetActive(false)
  end
  if math.abs(newValue - oldValue) > 10 then
    if oldValue > newValue then
      DOTween.Sequence():Append(self.point.transform:DOLocalRotate(Vector3.New(0, 0, 0), 0.15)):Append(self.point.transform:DOLocalRotate(Vector3.New(0, 0, newValue - 8), 0.15)):Append(self.point.transform:DOLocalRotate(Vector3.New(0, 0, newValue + 4), 0.1)):Append(self.point.transform:DOLocalRotate(Vector3.New(0, 0, newValue), 0.05))
    else
      DOTween.Sequence():Append(self.point.transform:DOLocalRotate(Vector3.New(0, 0, 0), 0.15)):Append(self.point.transform:DOLocalRotate(Vector3.New(0, 0, newValue + 8), 0.15)):Append(self.point.transform:DOLocalRotate(Vector3.New(0, 0, newValue - 4), 0.1)):Append(self.point.transform:DOLocalRotate(Vector3.New(0, 0, newValue), 0.05))
    end
  end
end

function UIBuildingPersonalFurnaceView:OnMaxPowerToggleChange()
  if self.state == HeatSourceState.None then
    Logger.Log("OnFunctionToggleChange.. state: HeatSourceState.None")
    return
  end
  local state = self.state
  if self.state == HeatSourceState.Close then
    UIUtil.ShowTipsId("season_s2_al_furnace_s2_07")
    return
  elseif self.state == HeatSourceState.Active then
    local count = LuaEntry.Resource:GetCntByResType(self.buildCurLevelTemplate.coal_overload[1])
    if count > self.buildCurLevelTemplate.coal_overload[2] then
      state = HeatSourceState.Overload
    else
      UIUtil.ShowTipsId("season_s2_al_furnace_s2_06")
      return
    end
  elseif self.state == HeatSourceState.Overload then
    state = HeatSourceState.Active
  end
  SFSNetwork.SendMessage(MsgDefines.UserBuildingFurnaceSettingState, self.buildData.uuid, state)
end

function UIBuildingPersonalFurnaceView:OnFunctionToggleChange()
  if self.state == HeatSourceState.None then
    Logger.Log("OnFunctionToggleChange.. state: HeatSourceState.None")
    return
  end
  local state = self.state
  if self.state == HeatSourceState.Close then
    local count = LuaEntry.Resource:GetCntByResType(self.buildCurLevelTemplate.coal_normal[1])
    if count > self.buildCurLevelTemplate.coal_normal[2] then
      state = HeatSourceState.Active
    else
      UIUtil.ShowTipsId("season_s2_al_furnace_s2_06")
      return
    end
  elseif self.state == HeatSourceState.Active then
    state = HeatSourceState.Close
  elseif self.state == HeatSourceState.Overload then
    state = HeatSourceState.Close
  end
  SFSNetwork.SendMessage(MsgDefines.UserBuildingFurnaceSettingState, self.buildData.uuid, state)
end

function UIBuildingPersonalFurnaceView:OnSettingActiveBtn()
  if self.settingState == HeatSourceState.None then
    Logger.Log("OnFunctionToggleChange.. state: HeatSourceState.None")
    return
  end
  local state = self.settingState
  if self.settingState == HeatSourceState.Close then
    state = HeatSourceState.Active
  elseif self.settingState == HeatSourceState.Active then
    state = HeatSourceState.Close
  elseif self.settingState == HeatSourceState.Overload then
    state = HeatSourceState.Close
  end
  SFSNetwork.SendMessage(MsgDefines.UserBuildingFurnaceSettingAuto, state)
end

function UIBuildingPersonalFurnaceView:OnSettingOverLoadBtn()
  if self.settingState == HeatSourceState.None then
    Logger.Log("OnSettingOverLoadBtn.. state: HeatSourceState.None")
    return
  end
  local state = self.settingState
  if self.settingState == HeatSourceState.Close then
    state = HeatSourceState.Overload
  elseif self.settingState == HeatSourceState.Active then
    state = HeatSourceState.Overload
  elseif self.settingState == HeatSourceState.Overload then
    state = HeatSourceState.Active
  end
  SFSNetwork.SendMessage(MsgDefines.UserBuildingFurnaceSettingAuto, state)
end

function UIBuildingPersonalFurnaceView:OnStateDataChange()
  local furnaceData = DataCenter.BuildManager:GetFurnaceData(self.buildData.uuid)
  if furnaceData then
    local preState = self.state
    self.state = furnaceData.state
    if furnaceData.endTime and furnaceData.endTime > 0 then
      self.burnEndTime = furnaceData.endTime
      self:Update1000MS()
    else
      self.burnEndTime = nil
      self.burnCountdown:SetText("")
    end
    local flag = false
    if preState == HeatSourceState.Close then
      if self.state == HeatSourceState.Active then
        self.playerAniName = "UIBuildingPersonalFurnaceS2tourswitch01"
        flag = true
      end
    elseif preState == HeatSourceState.Active then
      if self.state == HeatSourceState.Overload then
        self.playerAniName = "UIBuildingPersonalFurnaceS2tourswitch02"
        flag = true
      elseif self.state == HeatSourceState.Close then
        self.playerAniName = "UIBuildingPersonalFurnaceS2tourswitch04"
        flag = true
      end
    elseif preState == HeatSourceState.Overload then
      if self.state == HeatSourceState.Active then
        self.playerAniName = "UIBuildingPersonalFurnaceS2tourswitch03"
        flag = true
      elseif self.state == HeatSourceState.Close then
        self.playerAniName = "UIBuildingPersonalFurnaceS2tourswitch05"
        flag = true
      end
    end
    if not flag then
      if self.state == HeatSourceState.Close then
        self.playerAniName = "UIBuildingPersonalFurnaceS2tour01"
      elseif self.state == HeatSourceState.Active then
        self.playerAniName = "UIBuildingPersonalFurnaceS2tour02"
      elseif self.state == HeatSourceState.Overload then
        self.playerAniName = "UIBuildingPersonalFurnaceS2tour03"
      else
        self.playerAniName = "UIBuildingPersonalFurnaceS2tour01"
      end
      Logger.Log("error transition: preState" .. tostring(preState) .. ", state: " .. tostring(self.state))
    end
    Logger.Log("error transition: preState" .. tostring(preState) .. ", state: " .. tostring(self.state))
    self.buildingIconAnimator:Play(self.playerAniName)
  else
    self.state = HeatSourceState.None
    self.burnCountdown:SetText("")
  end
  self:RefreshState()
end

function UIBuildingPersonalFurnaceView:SetttingStateFlag()
  if self.settingState == HeatSourceState.Active then
    self.overloadFlag:SetActive(false)
    self.activtFlag:SetActive(true)
  elseif self.settingState == HeatSourceState.Overload then
    self.overloadFlag:SetActive(true)
    self.activtFlag:SetActive(true)
  else
    self.overloadFlag:SetActive(false)
    self.activtFlag:SetActive(false)
  end
end

function UIBuildingPersonalFurnaceView:OnSettingStateDataChange()
  local furnaceData = DataCenter.BuildManager:GetFurnaceData(self.buildData.uuid)
  if furnaceData and furnaceData.settingState then
    self.settingState = furnaceData.settingState
  else
    self.settingState = HeatSourceState.None
  end
  self:SetttingStateFlag()
end

function UIBuildingPersonalFurnaceView:ResoueceUpdate()
  if self.buildCurLevelTemplate then
    local count = LuaEntry.Resource:GetCntByResType(self.buildCurLevelTemplate.coal_overload[1])
    self.flintCount:SetText(count)
  end
end

function UIBuildingPersonalFurnaceView:Update1000MS()
  if self.burnEndTime and self.burnEndTime > 0 then
    local now = UITimeManager:GetInstance():GetServerTime()
    local time = self.burnEndTime - now
    if 0 <= time then
      local countdownStr = UITimeManager:GetInstance():MilliSecondToFmtString(time)
      local countDown = Localization:GetString("season_s2_alliance_building_ui013") .. " " .. countdownStr
      self.burnCountdown:SetText(countDown)
    else
      self.burnEndTime = nil
      self.burnCountdown:SetText("")
    end
  end
end

function UIBuildingPersonalFurnaceView:DesBtn()
  local state, temp, meta, addTable = DataCenter.BuildManager:GetFurnaceStateAndTemp()
  local total = temp
  local resource = 0
  local add = 0
  if addTable then
    for key, value in pairs(addTable) do
      add = add + value
    end
  end
  resource = total - add
  local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroPropertyDetailTip)
  param.mainPropName = Localization:GetString("season_s2_alliance_building_ui015")
  param.mainPropValue = total
  param.splitProp = {}
  table.insert(param.splitProp, {
    name = Localization:GetString("season_s2_alliance_building_ui020"),
    value = resource
  })
  table.insert(param.splitProp, {
    name = Localization:GetString("season_s2_alliance_building_ui021"),
    value = add
  })
  param.alignObject = self.desBtn
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPropertyDetailTip, {anim = true}, param)
end

UIBuildingPersonalFurnaceView.OnCreate = OnCreate
UIBuildingPersonalFurnaceView.OnDestroy = OnDestroy
UIBuildingPersonalFurnaceView.OnEnable = OnEnable
UIBuildingPersonalFurnaceView.OnDisable = OnDisable
UIBuildingPersonalFurnaceView.ComponentDefine = ComponentDefine
UIBuildingPersonalFurnaceView.ComponentDestroy = ComponentDestroy
UIBuildingPersonalFurnaceView.DataDefine = DataDefine
UIBuildingPersonalFurnaceView.DataDestroy = DataDestroy
return UIBuildingPersonalFurnaceView
