local LightHouseWork = BaseClass("LightHouseWork", UIAsyncContainer)
local base = UIAsyncContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local widthList = {
  138,
  308,
  523,
  878
}
local LightValueList = {
  0.145,
  0.35,
  0.6,
  1
}
local light_level_tip_path = "light_level_tip"
local work_info_btn_path = "workInfoBtn"
local slider_path = "Slider"
local debug0_path = "Slider/PosOff/debug0"
local debug1_path = "Slider/PosL1/debug1"
local debug2_path = "Slider/PosL2/debug2"
local debug3_path = "Slider/PosL3/debug3"
local debug4_path = "Slider/PosL4/debug4"
local detail_btn_path = "bg/DetailBtn"
local preview_fill_path = "Slider/PreviewFill"
local input_pointer_path = "bg/bg1/InputPointer"
local electricity1_path = "bg/bg2/electricity1"
local electricity2_path = "bg/bg2/electricity2"
local electricity3_path = "bg/bg2/electricity3"
local electricity4_path = "bg/bg2/electricity4"
local electricity5_path = "bg/bg2/electricity5"
local output_pointer_path = "bg/bg3/OutputPointer"
local txt_power_input_path = "bg/txtPowerInput"
local txt_power_electricity_path = "bg/txtPowerElectricity"
local txt_power_output_path = "bg/txtPowerOutput"
local txt1_path = "Slider/PosL1/txt1"
local txt2_path = "Slider/PosL2/txt2"
local txt3_path = "Slider/PosL3/txt3"
local txt4_path = "Slider/PosL4/txt4"
local preview_content1_path = "Slider/PreviewContent1"
local preview_content2_path = "Slider/PreviewContent2"
local preview_content3_path = "Slider/PreviewContent3"
local preview_content4_path = "Slider/PreviewContent4"
local yibiao_saoguang01_fx_path = "bg/bg1/yibiao_saoguang01_Fx"
local yibiao_saoguang02_fx_path = "bg/bg3/yibiao_saoguang02_Fx"
local season_build_obj_fx00_path = "Slider/PosL1/icon/seasonBuildObjFx00"
local season_build_obj_fx01_path = "Slider/PosL2/icon/seasonBuildObjFx01"
local season_build_obj_fx02_path = "Slider/PosL3/icon/seasonBuildObjFx02"
local season_build_obj_fx03_path = "Slider/PosL4/icon/seasonBuildObjFx03"
local eff_light_house_work_add_fx_path = "Eff_LightHouseWork_Add_Fx"
local eff_light_house_work_reduce_fx_path = "Eff_LightHouseWork_Reduce_Fx"
local auto_adjust_select_path = "AutoAdjust/AutoAdjustSelect"
local auto_adjust_btn_path = "AutoAdjust/AutoAdjustBtn"
local icon_left_path = "AutoAdjust/AutoAdjustSelect/iconLeft"
local icon_right_path = "AutoAdjust/AutoAdjustSelect/iconRight"
local auto_adjust_info_btn_path = "AutoAdjustInfoBtn"
local auto_adjust_path = "AutoAdjust"

function LightHouseWork:OnCreate()
  base.OnCreate(self)
  self.season_build_obj_fx00 = self:AddComponent(UIBaseContainer, season_build_obj_fx00_path)
  self.season_build_obj_fx01 = self:AddComponent(UIBaseContainer, season_build_obj_fx01_path)
  self.season_build_obj_fx02 = self:AddComponent(UIBaseContainer, season_build_obj_fx02_path)
  self.season_build_obj_fx03 = self:AddComponent(UIBaseContainer, season_build_obj_fx03_path)
  self.eff_light_house_work_add_fx = self:AddComponent(UIBaseContainer, eff_light_house_work_add_fx_path)
  self.eff_light_house_work_reduce_fx = self:AddComponent(UIBaseContainer, eff_light_house_work_reduce_fx_path)
  self.yibiao_saoguang01_fx = self:AddComponent(UIBaseContainer, yibiao_saoguang01_fx_path)
  self.yibiao_saoguang02_fx = self:AddComponent(UIBaseContainer, yibiao_saoguang02_fx_path)
  self.preview_content1 = self:AddComponent(UIBaseContainer, preview_content1_path)
  self.preview_content2 = self:AddComponent(UIBaseContainer, preview_content2_path)
  self.preview_content3 = self:AddComponent(UIBaseContainer, preview_content3_path)
  self.preview_content4 = self:AddComponent(UIBaseContainer, preview_content4_path)
  self.theItem = self.transform:Find("Slider/PreviewItem").gameObject
  if self.theItem then
    self.theItem:GameObjectCreatePool()
  end
  self.txt1 = self:AddComponent(UITextMeshProUGUIEx, txt1_path)
  self.txt2 = self:AddComponent(UITextMeshProUGUIEx, txt2_path)
  self.txt3 = self:AddComponent(UITextMeshProUGUIEx, txt3_path)
  self.txt4 = self:AddComponent(UITextMeshProUGUIEx, txt4_path)
  self.preview_fill = self:AddComponent(UIImage, preview_fill_path)
  self.event_trigger = self:AddComponent(UIEventTrigger, slider_path)
  self.light_level_tip = self:AddComponent(UITextMeshProUGUIEx, light_level_tip_path)
  self.work_info_btn = self:AddComponent(UIButton, work_info_btn_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.debug0 = self:AddComponent(UIButton, debug0_path)
  self.debug1 = self:AddComponent(UIButton, debug1_path)
  self.debug2 = self:AddComponent(UIButton, debug2_path)
  self.debug3 = self:AddComponent(UIButton, debug3_path)
  self.debug4 = self:AddComponent(UIButton, debug4_path)
  self.event_trigger:OnBeginDrag(function()
    self.isInDrag = true
  end)
  self.event_trigger:OnEndDrag(function()
    self.isInDrag = false
    self:OnSliderValueChanged(self.slider:GetValue())
  end)
  self.slider:SetOnValueChanged(BindCallback(self, self.OnSliderValueChanged))
  self.debug0:SetOnClick(function()
    if self.isInDrag then
      return
    end
    self:ChangeBrightnessLevel(0, true)
  end)
  self.debug1:SetOnClick(function()
    if self.isInDrag then
      return
    end
    self:ChangeBrightnessLevel(1, true)
  end)
  self.debug2:SetOnClick(function()
    if self.isInDrag then
      return
    end
    self:ChangeBrightnessLevel(2, true)
  end)
  self.debug3:SetOnClick(function()
    if self.isInDrag then
      return
    end
    self:ChangeBrightnessLevel(3, true)
  end)
  self.debug4:SetOnClick(function()
    if self.isInDrag then
      return
    end
    self:ChangeBrightnessLevel(4, true)
  end)
  self.preview_fill:SetSizeDeltaXY(0, 32)
  self.work_info_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPowerHistory)
  end)
  self.input_pointer = self:AddComponent(UIImage, input_pointer_path)
  self.electricity1 = self:AddComponent(UIImage, electricity1_path)
  self.electricity2 = self:AddComponent(UIImage, electricity2_path)
  self.electricity3 = self:AddComponent(UIImage, electricity3_path)
  self.electricity4 = self:AddComponent(UIImage, electricity4_path)
  self.electricity5 = self:AddComponent(UIImage, electricity5_path)
  self.output_pointer = self:AddComponent(UIImage, output_pointer_path)
  self.txt_power_input = self:AddComponent(UITextMeshProUGUIEx, txt_power_input_path)
  self.txt_power_electricity = self:AddComponent(UITextMeshProUGUIEx, txt_power_electricity_path)
  self.txt_power_output = self:AddComponent(UITextMeshProUGUIEx, txt_power_output_path)
  self.detail_btn = self:AddComponent(UIButton, detail_btn_path)
  self.detail_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPowerSource)
  end)
  local cfg1 = LocalController:instance():getLine(TableName.LW_LIGHTS_ON_S4, 1)
  local cfg2 = LocalController:instance():getLine(TableName.LW_LIGHTS_ON_S4, 2)
  local cfg3 = LocalController:instance():getLine(TableName.LW_LIGHTS_ON_S4, 3)
  local cfg4 = LocalController:instance():getLine(TableName.LW_LIGHTS_ON_S4, 4)
  self:UpdateTileCell(self.preview_content1, math.ceil(toInt(cfg1.electricity_use) / 10))
  self:UpdateTileCell(self.preview_content2, math.ceil(toInt(cfg2.electricity_use) / 10))
  self:UpdateTileCell(self.preview_content3, math.ceil(toInt(cfg3.electricity_use) / 10))
  self:UpdateTileCell(self.preview_content4, math.ceil(toInt(cfg4.electricity_use) / 10))
  self.auto_adjust_root = self:AddComponent(UITextMeshProUGUIEx, auto_adjust_path)
  self.auto_adjust_info_btn = self:AddComponent(UIButton, auto_adjust_info_btn_path)
  self.icon_left = self:AddComponent(UIImage, icon_left_path)
  self.icon_right = self:AddComponent(UIImage, icon_right_path)
  self.auto_adjust_select = self:AddComponent(UIToggle, auto_adjust_select_path)
  self.auto_adjust_btn = self:AddComponent(UIButton, auto_adjust_btn_path)
  self.auto_adjust_select:SetIsOnWithoutNotify(false)
  self.auto_adjust_btn:SetOnClick(function()
    local isOn = self.auto_adjust_select:GetIsOn()
    self.auto_adjust_select:SetIsOnWithoutNotify(not isOn)
    self:SetAutoAdjustMode(not isOn)
  end)
  self.auto_adjust_select:SetOnValueChanged(function(isOn)
    self:SetAutoAdjustMode(isOn)
  end)
  self.auto_adjust_info_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWLightsOnDetail)
  end)
  local mgr = DataCenter.SeasonPowerWorkerManager
  local lightHouseStatus = mgr.lightHouseStatus
  if lightHouseStatus then
    self.auto_adjust_select:SetIsOnWithoutNotify(lightHouseStatus.autoDownGrade == 1)
    self.icon_left:SetActive(lightHouseStatus.autoDownGrade ~= 1)
    self.icon_right:SetActive(lightHouseStatus.autoDownGrade == 1)
  end
  local formationCount = mgr:GetFormationCount()
  local workerCount = mgr:GetPowerWorkerCount()
  self.auto_adjust_root:SetActive(2 <= formationCount or 2 <= workerCount)
end

function LightHouseWork:SetAutoAdjustMode(isOn)
  if isOn then
    SFSNetwork.SendMessage(MsgDefines.SetLighthouseBrightnessAutoDowngrade, 1)
  else
    SFSNetwork.SendMessage(MsgDefines.SetLighthouseBrightnessAutoDowngrade, 0)
  end
  self.icon_left:SetActive(not isOn)
  self.icon_right:SetActive(isOn)
end

function LightHouseWork:UpdateTileCell(preview_content, count)
  if 0 < count then
    local goItem
    preview_content:SetLocalScaleXYZ(1, 1, 1)
    for i = 1, count do
      goItem = self.theItem:GameObjectSpawn(preview_content.transform)
      goItem:SetActive(true)
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(preview_content.transform)
  else
    preview_content:SetLocalScaleXYZ(0, 0, 0)
  end
end

function LightHouseWork:OnDestroy()
  if IsNotNull(self.theItem) then
    self.theItem:GameObjectRecycleAll()
    self.theItem = nil
  end
  if self.anim_tween ~= nil then
    self.anim_tween:Kill()
    self.anim_tween = nil
  end
  self.preview_content1 = nil
  self.preview_content2 = nil
  self.preview_content3 = nil
  self.preview_content4 = nil
  self.last_anim_electricity = nil
  self.anim_electricity = nil
  self.detail_btn = nil
  self.preview_fill = nil
  self.light_level_tip = nil
  self.work_info_btn = nil
  self.slider = nil
  self.debug0 = nil
  self.debug1 = nil
  self.debug2 = nil
  self.debug3 = nil
  self.debug4 = nil
  self.txt1 = nil
  self.txt2 = nil
  self.txt3 = nil
  self.txt4 = nil
  self.event_trigger = nil
  self.input_pointer = nil
  self.electricity1 = nil
  self.electricity2 = nil
  self.electricity3 = nil
  self.electricity4 = nil
  self.electricity5 = nil
  self.output_pointer = nil
  self.txt_power_input = nil
  self.txt_power_electricity = nil
  self.txt_power_output = nil
  self.auto_adjust_root = nil
  base.OnDestroy(self)
end

function LightHouseWork:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OpenUI, self.OnOpenUI)
  self:AddUIListener(EventId.CloseUI, self.OnCloseUI)
  self:AddUIListener(EventId.BatteryPowerResourceUpdated, self.UpdateBatteryPowerData)
  self:AddUIListener(EventId.LuaEntryEffectRefreshStatus, self.RefreshStatus)
end

function LightHouseWork:OnRemoveListener()
  self:RemoveUIListener(EventId.OpenUI, self.OnOpenUI)
  self:RemoveUIListener(EventId.CloseUI, self.OnCloseUI)
  self:RemoveUIListener(EventId.BatteryPowerResourceUpdated, self.UpdateBatteryPowerData)
  self:RemoveUIListener(EventId.LuaEntryEffectRefreshStatus, self.RefreshStatus)
  base.OnRemoveListener(self)
end

function LightHouseWork:OnOpenUI()
  self.isInDrag = false
end

function LightHouseWork:OnCloseUI()
  self.isInDrag = false
end

function LightHouseWork:RefreshStatus()
  self:UpdateData()
end

function LightHouseWork:UpdateBatteryPowerData()
  self:UpdateData()
end

function LightHouseWork:ChangeBrightnessLevel(level, byClick)
  local topWindow = UIManager:GetInstance():GetStackTopWindow()
  if topWindow.Name ~= UIWindowNames.UILWPowerHouse then
    self.childDialogShown = false
    self.slider:SetValueWithoutNotify(self.lastBrightnessValue)
    return
  end
  local toLevel = toInt(level)
  if self.brightnessMaxLevel == nil then
    self:UpdateData()
  end
  if toLevel > self.brightnessMaxLevel then
    local buildLevel = DataCenter.SeasonPowerWorkerManager:GetBrightnessNeedBuildLevel(toLevel)
    self.childDialogShown = false
    self.slider:SetValueWithoutNotify(self.lastBrightnessValue)
    UIUtil.ShowTips(Localization:GetString("season_s4_switch_light_tips06", buildLevel))
    return
  end
  if toLevel == nil or toLevel == self.lastBrightnessLevel then
    self.slider:SetValueWithoutNotify(self.lastBrightnessValue)
  elseif toLevel == 0 and self.lastBrightnessLevel ~= 0 then
    local cfg = LocalController:instance():getLine(TableName.LW_LIGHTS_ON_S4, self.lastBrightnessLevel)
    local message = Localization:GetString("season_s4_switch_light_tips04", toInt(cfg.cd) .. "s")
    self.childDialogShown = true
    UIUtil.TryShowConfirm(TodayNoSecondConfirmType.ChangeLightHouseBrightnessLevel, message, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      local lightHouseStatus = DataCenter.SeasonPowerWorkerManager.lightHouseStatus
      if lightHouseStatus and lightHouseStatus.autoDownGrade == 1 then
        self:CloseAutoBrightnessLevel(toLevel)
      else
        self:ModifyBrightnessLevel(0)
      end
    end, function()
      self.childDialogShown = false
      if self.slider then
        self.slider:SetValueWithoutNotify(self.lastBrightnessValue)
      end
    end, nil, Localization:GetString("season_s4_switch_light_tips03"))
  elseif toLevel ~= self.lastBrightnessLevel and 0 < toLevel and toLevel < 5 then
    local canUseTime, canUseTimeStr = DataCenter.SeasonPowerWorkerManager:CalcBatteryPowerTime(toLevel)
    if canUseTime ~= -1 and canUseTime <= 0 then
      UIUtil.ShowTipsId("season_s4_switch_light_tips05")
      self.slider:SetValueWithoutNotify(self.lastBrightnessValue)
      return
    end
    local lightSize = 5
    local cfg = LocalController:instance():getLine(TableName.LW_LIGHTS_ON_S4, toLevel)
    if cfg and cfg.electricity_use ~= nil then
      lightSize = toInt(cfg.size) * 2 + 1
    end
    local lightSizeStr = string.format("%s\195\151%s", lightSize, lightSize)
    local levelStr = Localization:GetString("season_s4_building_ui_info0" .. 1 + toLevel)
    local message = Localization:GetString("season_s4_switch_light_tips02", levelStr, canUseTimeStr, lightSizeStr)
    self.childDialogShown = true
    UIUtil.TryShowConfirm(TodayNoSecondConfirmType.ChangeLightHouseBrightnessLevel, message, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      local lightHouseStatus = DataCenter.SeasonPowerWorkerManager.lightHouseStatus
      if lightHouseStatus and lightHouseStatus.autoDownGrade == 1 then
        self:CloseAutoBrightnessLevel(toLevel)
      else
        self:ModifyBrightnessLevel(toLevel)
      end
    end, function()
      self.childDialogShown = false
      self.slider:SetValueWithoutNotify(self.lastBrightnessValue)
    end, nil, Localization:GetString("season_s4_switch_light_tips01"))
  else
    self.slider:SetValueWithoutNotify(self.lastBrightnessValue)
  end
end

function LightHouseWork:CloseAutoBrightnessLevel(BrightnessLevel)
  if DataCenter.BloodyNightDataManager:IsBloodyNight() then
    self:ModifyBrightnessLevel(BrightnessLevel)
    self.childDialogShown = false
    return
  end
  UIUtil.ShowMessage(Localization:GetString("season_s4_switch_light_tips09"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    self:ModifyBrightnessLevel(BrightnessLevel)
    self.childDialogShown = false
  end, function()
    self.childDialogShown = false
  end)
end

function LightHouseWork:ModifyBrightnessLevel(BrightnessLevel)
  local toLevel = toInt(BrightnessLevel)
  if toLevel <= 0 then
    self.lastBrightnessLevel = 0
    self.lastBrightnessValue = 0
    self.sliderTween = self.slider:DOValue(0, 0.15, function()
      self.sliderTween = nil
    end)
    SFSNetwork.SendMessage(MsgDefines.SetBrightnessLevel, 0)
  else
    self.lastBrightnessLevel = toLevel
    self.lastBrightnessValue = LightValueList[toLevel]
    self.sliderTween = self.slider:DOValue(self.lastBrightnessValue, 0.15, function()
      self.sliderTween = nil
    end)
    SFSNetwork.SendMessage(MsgDefines.SetBrightnessLevel, toLevel)
  end
  self.childDialogShown = false
end

function LightHouseWork:OnSliderValueChanged(value)
  if self.isInDrag and self.sliderTween then
    self.sliderTween:Kill()
    self.sliderTween = nil
  end
  if self.sliderTween or self.isInDrag then
    return
  end
  if self.childDialogShown then
    self.slider:SetValueWithoutNotify(self.childDialogShownValue)
    return
  end
  local topWindow = UIManager:GetInstance():GetStackTopWindow()
  if topWindow.Name ~= UIWindowNames.UILWPowerHouse then
    return
  end
  local toLevel
  if value < 0.06 then
    toLevel = 0
  elseif value < 0.24 then
    toLevel = 1
  elseif value < 0.48 then
    toLevel = 2
  elseif value < 0.8 then
    toLevel = 3
  else
    toLevel = 4
  end
  if 0 < toLevel then
    self.childDialogShownValue = LightValueList[toLevel]
  else
    self.childDialogShownValue = 0
  end
  self.slider:SetValueWithoutNotify(self.childDialogShownValue)
  self:ChangeBrightnessLevel(toLevel, false)
end

function LightHouseWork:OnEnable()
  base.OnEnable(self)
  self.anim_electricity = nil
  self.last_anim_electricity = nil
end

function LightHouseWork:OnDisable()
  self.anim_electricity = nil
  self.last_anim_electricity = nil
  if self.anim_tween ~= nil then
    self.anim_tween:Kill()
    self.anim_tween = nil
  end
  base.OnDisable(self)
end

function LightHouseWork:UpdateData()
  if IsNull(self.gameObject) then
    self.lastBrightnessLevel = 0
    self.lastBrightnessValue = 0
    return
  end
  self.txt1:SetColorRGBA(0.5, 0.5, 0.5, 1)
  self.txt2:SetColorRGBA(0.5, 0.5, 0.5, 1)
  self.txt3:SetColorRGBA(0.5, 0.5, 0.5, 1)
  self.txt4:SetColorRGBA(0.5, 0.5, 0.5, 1)
  if self.sliderTween then
    self.sliderTween:Kill()
  end
  local lightHouseStatus = DataCenter.SeasonPowerWorkerManager.lightHouseStatus
  self.lightHouseStatus = lightHouseStatus
  if self.lightHouseStatus == nil or self.lightHouseStatus.active ~= true then
    self.lastBrightnessLevel = 0
    self.lastBrightnessValue = 0
    self.slider:SetValueWithoutNotify(0)
    self.preview_fill:SetSizeDeltaXY(0, 32)
    self.input_pointer:SetEulerAnglesXYZ(0, 0, 90)
    self.output_pointer:SetEulerAnglesXYZ(0, 0, 90)
    self.electricity1:SetColorRGBA255(166, 194, 154, 0)
    self.electricity2:SetColorRGBA255(166, 194, 154, 0)
    self.electricity3:SetColorRGBA255(166, 194, 154, 0)
    self.electricity4:SetColorRGBA255(166, 194, 154, 0)
    self.electricity5:SetColorRGBA255(166, 194, 154, 0)
    self.txt_power_input:SetText(UIUtil.GetMinuteSpeedStr(0))
    self.txt_power_electricity:SetText(UIUtil.GetMinuteSpeedStr(0))
    self.txt_power_output:SetText("0/min")
    self.yibiao_saoguang01_fx:SetActive(false)
    self.yibiao_saoguang02_fx:SetActive(false)
    self.season_build_obj_fx00:SetActive(false)
    self.season_build_obj_fx01:SetActive(false)
    self.season_build_obj_fx02:SetActive(false)
    self.season_build_obj_fx03:SetActive(false)
    self.eff_light_house_work_add_fx:SetActive(false)
    self.eff_light_house_work_reduce_fx:SetActive(false)
    return
  end
  local brightnessLevel = toInt(lightHouseStatus.brightnessLevel)
  if brightnessLevel == 0 then
    self.slider:SetValueWithoutNotify(0)
    self.lastBrightnessLevel = 0
    self.lastBrightnessValue = 0
  else
    self.lastBrightnessLevel = brightnessLevel
    self.lastBrightnessValue = LightValueList[brightnessLevel]
    self.slider:SetValueWithoutNotify(self.lastBrightnessValue)
    if brightnessLevel == 1 then
      self.txt1:SetColorRGBA(1, 1, 1, 1)
    elseif brightnessLevel == 2 then
      self.txt2:SetColorRGBA(1, 1, 1, 1)
    elseif brightnessLevel == 3 then
      self.txt3:SetColorRGBA(1, 1, 1, 1)
    elseif brightnessLevel == 4 then
      self.txt4:SetColorRGBA(1, 1, 1, 1)
    end
  end
  self.season_build_obj_fx00:SetActive(brightnessLevel == 1)
  self.season_build_obj_fx01:SetActive(brightnessLevel == 2)
  self.season_build_obj_fx02:SetActive(brightnessLevel == 3)
  self.season_build_obj_fx03:SetActive(brightnessLevel == 4)
  self:CalcPreviewData()
end

function LightHouseWork:Update1000MS()
  self:UpdateData()
  if self.last_anim_electricity ~= self.anim_electricity then
    self.last_anim_electricity = self.anim_electricity
    if self.anim_tween ~= nil then
      self.anim_tween:Kill()
      self.anim_tween = nil
    end
    if self.last_anim_electricity ~= nil then
      local the_anim_node = self.anim_electricity
      local sequence = DOTween.Sequence()
      sequence:Append(DOTween.To(function()
        return 0.1
      end, function(alpha)
        the_anim_node:SetAlpha(alpha)
      end, 0.6, 0.5))
      sequence:Append(DOTween.To(function()
        return 0.6
      end, function(alpha)
        the_anim_node:SetAlpha(alpha)
      end, 0.1, 0.5))
      sequence:SetLoops(-1)
      self.anim_tween = sequence
    end
  end
end

function LightHouseWork:CalcPreviewData()
  self.light_level_tip:SetText("")
  if self.lightHouseStatus == nil or self.lightHouseStatus.active ~= true then
    self.preview_fill:SetSizeDeltaXY(0, 32)
    self.light_level_tip:SetLocalText("season_s4_building_ui_info06")
    self.preview_content1:SetActive(false)
    self.preview_content2:SetActive(false)
    self.preview_content3:SetActive(false)
    self.preview_content4:SetActive(false)
    self.yibiao_saoguang01_fx:SetActive(false)
    self.yibiao_saoguang02_fx:SetActive(false)
    self.season_build_obj_fx00:SetActive(false)
    self.season_build_obj_fx01:SetActive(false)
    self.season_build_obj_fx02:SetActive(false)
    self.season_build_obj_fx03:SetActive(false)
    self.eff_light_house_work_add_fx:SetActive(false)
    self.eff_light_house_work_reduce_fx:SetActive(false)
    return
  end
  local mgr = DataCenter.SeasonPowerWorkerManager
  local powerNow, powerMax, powerSpeed = mgr:GetBatteryPowerResourceInfo()
  local inputNow, inputMax = mgr:CalcPowerInput()
  local outputNow, outputMax = mgr:CalcPowerOutput()
  local level = toInt(self.lightHouseStatus.lv)
  self.yibiao_saoguang01_fx:SetActive(0 < inputNow)
  self.yibiao_saoguang02_fx:SetActive(0 < outputNow)
  self.eff_light_house_work_add_fx:SetActive(0 < powerSpeed and powerNow < powerMax)
  self.eff_light_house_work_reduce_fx:SetActive(powerSpeed < 0)
  self.light_level_tip:SetText("")
  local zero = UIUtil.GetMinuteSpeedStr(0)
  local inputOld = self.inputNow
  local outputOld = self.outputNow
  self.inputNow = inputNow
  self.outputNow = outputNow
  if inputOld == nil or inputOld ~= inputNow then
    if inputNow == 0 then
      self.txt_power_input:SetText("+" .. zero)
      self.input_pointer:SetEulerAnglesXYZ(0, 0, 90)
    else
      local angleFrom = 90
      local targetAngle = 90 - math.min(1, inputNow / inputMax) * 180
      local targetAngleMax = math.max(-90, targetAngle - 10)
      if inputOld ~= nil then
        angleFrom = 90 - math.min(1, inputOld / inputMax) * 180
        if inputNow < inputOld then
          targetAngleMax = math.min(90, targetAngle + 10)
        end
      end
      self.txt_power_input:SetText(UIUtil.GetMinuteSpeedStr(inputNow * 60))
      local sequence = DOTween.Sequence()
      sequence:Append(DOTween.To(function()
        return angleFrom
      end, function(angle)
        if self.input_pointer ~= nil then
          self.input_pointer:SetEulerAnglesXYZ(0, 0, angle)
        end
      end, targetAngleMax, 0.2))
      sequence:Append(DOTween.To(function()
        return targetAngleMax
      end, function(angle)
        if self.input_pointer ~= nil then
          self.input_pointer:SetEulerAnglesXYZ(0, 0, angle)
        end
      end, targetAngle, 0.1))
    end
  elseif inputNow == 0 then
    self.txt_power_input:SetText("+" .. zero)
    self.input_pointer:SetEulerAnglesXYZ(0, 0, 90)
  end
  if powerSpeed == 0 then
    self.txt_power_electricity:SetText("+" .. zero)
  elseif 0 < powerSpeed then
    self.txt_power_electricity:SetText(UIUtil.GetMinuteSpeedStr(powerSpeed * 60))
  elseif powerNow == 0 then
    self.txt_power_electricity:SetText("-" .. zero)
  else
    self.txt_power_electricity:SetText(UIUtil.GetMinuteSpeedStr(powerSpeed * 60))
  end
  if outputOld == nil or outputOld ~= outputNow then
    if outputNow == 0 then
      self.txt_power_output:SetText("-" .. zero)
      self.output_pointer:SetEulerAnglesXYZ(0, 0, 90)
    else
      local angleFrom = 90
      local targetAngle = 90 - math.min(1, outputNow / outputMax) * 180
      local targetAngleMax = math.max(-90, targetAngle - 10)
      if outputOld ~= nil then
        angleFrom = 90 - math.min(1, outputOld / outputMax) * 180
        if outputNow < outputOld then
          targetAngleMax = math.min(90, targetAngle + 10)
        end
      end
      self.txt_power_output:SetText(UIUtil.GetMinuteSpeedStr(outputNow * -60))
      local sequence = DOTween.Sequence()
      sequence:Append(DOTween.To(function()
        return angleFrom
      end, function(angle)
        if self.output_pointer ~= nil then
          self.output_pointer:SetEulerAnglesXYZ(0, 0, angle)
        end
      end, targetAngleMax, 0.2))
      sequence:Append(DOTween.To(function()
        return targetAngleMax
      end, function(angle)
        if self.output_pointer ~= nil then
          self.output_pointer:SetEulerAnglesXYZ(0, 0, angle)
        end
      end, targetAngle, 0.1))
    end
  elseif outputNow == 0 then
    self.txt_power_output:SetText("-" .. zero)
    self.output_pointer:SetEulerAnglesXYZ(0, 0, 90)
  end
  local electricityOld = self.electricityNow
  local deltaOld = self.deltaNow
  local electricityNow = powerNow / powerMax
  local delta = powerSpeed
  self.electricityNow = electricityNow
  self.deltaNow = delta
  if electricityOld == nil or deltaOld ~= delta or 0.1 <= math.abs(electricityOld - electricityNow) then
    if self.anim_tween ~= nil then
      self.anim_tween:Kill()
      self.anim_tween = nil
    end
    if 0.99 <= electricityNow then
      if delta < 0 then
        self.anim_electricity = self.electricity5
        self.electricity5:SetColorRGBA255(229, 167, 118, 255)
      else
        self.electricity5:SetColorRGBA255(166, 194, 154, 255)
      end
      self.electricity4:SetColorRGBA255(166, 194, 154, 255)
      self.electricity3:SetColorRGBA255(166, 194, 154, 255)
      self.electricity2:SetColorRGBA255(166, 194, 154, 255)
      self.electricity1:SetColorRGBA255(166, 194, 154, 255)
    elseif 0.8 <= electricityNow then
      self.electricity5:SetColorRGBA255(166, 194, 154, 0)
      if delta < 0 then
        self.anim_electricity = self.electricity4
        self.electricity4:SetColorRGBA255(229, 167, 118, 255)
      else
        self.anim_electricity = self.electricity5
        self.electricity4:SetColorRGBA255(166, 194, 154, 255)
      end
      self.electricity3:SetColorRGBA255(166, 194, 154, 255)
      self.electricity2:SetColorRGBA255(166, 194, 154, 255)
      self.electricity1:SetColorRGBA255(166, 194, 154, 255)
    elseif 0.6 <= electricityNow then
      self.electricity5:SetColorRGBA(1, 1, 1, 0)
      self.electricity4:SetColorRGBA255(166, 194, 154, 0)
      if delta < 0 then
        self.anim_electricity = self.electricity3
        self.electricity3:SetColorRGBA255(229, 167, 118, 255)
      else
        self.anim_electricity = self.electricity4
        self.electricity3:SetColorRGBA255(166, 194, 154, 255)
      end
      self.electricity2:SetColorRGBA255(166, 194, 154, 255)
      self.electricity1:SetColorRGBA255(166, 194, 154, 255)
    elseif 0.4 <= electricityNow then
      self.electricity5:SetColorRGBA(1, 1, 1, 0)
      self.electricity4:SetColorRGBA(1, 1, 1, 0)
      self.electricity3:SetColorRGBA255(166, 194, 154, 0)
      if delta < 0 then
        self.anim_electricity = self.electricity2
        self.electricity2:SetColorRGBA255(229, 167, 118, 255)
      else
        self.anim_electricity = self.electricity3
        self.electricity2:SetColorRGBA255(166, 194, 154, 255)
      end
      self.electricity1:SetColorRGBA255(166, 194, 154, 255)
    elseif 0.2 <= electricityNow then
      self.electricity5:SetColorRGBA(1, 1, 1, 0)
      self.electricity4:SetColorRGBA(1, 1, 1, 0)
      self.electricity3:SetColorRGBA(1, 1, 1, 0)
      self.electricity2:SetColorRGBA255(166, 194, 154, 0)
      if delta < 0 then
        self.anim_electricity = self.electricity1
        self.electricity1:SetColorRGBA255(229, 167, 118, 255)
      else
        self.anim_electricity = self.electricity2
        self.electricity1:SetColorRGBA255(166, 194, 154, 255)
      end
    else
      self.electricity5:SetColorRGBA(1, 1, 1, 0)
      self.electricity4:SetColorRGBA(1, 1, 1, 0)
      self.electricity3:SetColorRGBA(1, 1, 1, 0)
      self.electricity2:SetColorRGBA(1, 1, 1, 0)
      if delta < 0 then
        if 0 < powerNow then
          self.electricity1:SetColorRGBA255(229, 167, 118, 255)
          self.anim_electricity = self.electricity1
        else
          self.electricity1:SetColorRGBA(1, 1, 1, 0)
          self.anim_electricity = nil
        end
      else
        self.electricity1:SetColorRGBA255(166, 194, 154, 0)
        self.anim_electricity = self.electricity1
      end
    end
  end
  if delta == 0 then
    self.anim_electricity = nil
  end
  local brightnessMaxLevel = DataCenter.SeasonPowerWorkerManager:GetMaxBrightnessLevel()
  local cfg = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.LW_BUILD_SEASON4_LIGHTHOUSE, level)
  if cfg ~= nil then
    powerMax = toInt(cfg.para1)
  end
  self.brightnessMaxLevel = brightnessMaxLevel
  for brightnessLevel = brightnessMaxLevel, 1, -1 do
    cfg = LocalController:instance():getLine(TableName.LW_LIGHTS_ON_S4, brightnessLevel)
    if cfg and cfg.electricity_use ~= nil then
      local buff_add = DataCenter.SeasonLightDataManager:GetBloodyNightElectricityUseBuff()
      local electricity_need = toInt(cfg.electricity_use) + buff_add
      if inputNow >= electricity_need then
        self.preview_content1:SetActive(0 < brightnessLevel)
        self.preview_content2:SetActive(1 < brightnessLevel)
        self.preview_content3:SetActive(2 < brightnessLevel)
        self.preview_content4:SetActive(3 < brightnessLevel)
        self.preview_fill:SetSizeDeltaXY(widthList[brightnessLevel], 32)
        return
      else
        local deltaPerS = electricity_need - inputNow
        if powerNow > deltaPerS * 60 then
          self.preview_content1:SetActive(0 < brightnessLevel)
          self.preview_content2:SetActive(1 < brightnessLevel)
          self.preview_content3:SetActive(2 < brightnessLevel)
          self.preview_content4:SetActive(3 < brightnessLevel)
          self.preview_fill:SetSizeDeltaXY(widthList[brightnessLevel], 32)
          return
        end
      end
    end
  end
  self.preview_fill:SetSizeDeltaXY(0, 32)
  self.preview_content1:SetActive(false)
  self.preview_content2:SetActive(false)
  self.preview_content3:SetActive(false)
  self.preview_content4:SetActive(false)
end

return LightHouseWork
