local UILWPowerSourceView = BaseClass("UILWPowerSourceView", UIBaseView)
local base = UIBaseView
local dataIndexCache = 3
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UILWPowerSourceItem = require("UI.LWSeason4.UILWPowerSource.Component.UILWPowerSourceItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local input_power_speed_path = "Content/Texts/InputPowerSpeed"
local use_power_speed_path = "Content/Texts/UsePowerSpeed"
local now_power_text_path = "Content/Texts/NowPowerText"
local now_power_speed_path = "Content/Texts/NowPowerSpeed"
local select_mode_path = "Content/SelectMode"
local select_mode_txt_path = "Content/SelectMode/SelectModeTxt"
local item_list_path = "Content/SelectMode/ItemList"
local item1_path = "Content/SelectMode/ItemList/Item1"
local txt1_path = "Content/SelectMode/ItemList/Item1/Txt1"
local item2_path = "Content/SelectMode/ItemList/Item2"
local txt2_path = "Content/SelectMode/ItemList/Item2/Txt2"
local item3_path = "Content/SelectMode/ItemList/Item3"
local txt3_path = "Content/SelectMode/ItemList/Item3/Txt3"
local item1_btn_path = "Content/SelectMode/ItemList/Item1/Item1Btn"
local item2_btn_path = "Content/SelectMode/ItemList/Item2/Item2Btn"
local item3_btn_path = "Content/SelectMode/ItemList/Item3/Item3Btn"
local select_mode_btn1_path = "Content/SelectMode/SelectModeBtn1"
local select_mode_btn2_path = "Content/SelectMode/ItemList/SelectModeBtn2"
local content_path = "Content/ScrollView/Viewport/Content"
local item_path = "Content/ScrollView/Viewport/Content/Item"
local auto_adjust_select_path = "Content/AutoAdjust/AutoAdjustSelect"
local auto_adjust_btn_path = "Content/AutoAdjust/AutoAdjustBtn"
local icon_left_path = "Content/AutoAdjust/AutoAdjustSelect/iconLeft"
local icon_right_path = "Content/AutoAdjust/AutoAdjustSelect/iconRight"
local auto_adjust_info_btn_path = "Content/AutoAdjust/AutoAdjustInfoBtn"
local speed_text_path = "Content/SpeedText"
local power_fill_path = "PopUpTitle/Common_bg_orange2/GameObject/powerFill"
local jiantou3_path = "PopUpTitle/Common_bg_orange2/GameObject/UILWPowerSourceFx/jiantou3"
local jiantou1_path = "PopUpTitle/Common_bg_orange2/GameObject/UILWPowerSourceFx/jiantou1"
local jiantou2_path = "PopUpTitle/Common_bg_orange2/GameObject/UILWPowerSourceFx/jiantou2"
local common_bg_orange_path = "PopUpTitle/Common_bg_orange"

function UILWPowerSourceView:OnCreate()
  base.OnCreate(self)
  SFSNetwork.SendMessage(MsgDefines.FetchPowerWorkerDetail)
  self:ComponentDefine()
  self:UpdateData(false)
end

function UILWPowerSourceView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWPowerSourceView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BatteryPowerResourceUpdated, self.UpdateData)
  self:AddUIListener(EventId.PowerWorkerUpdated, self.UpdateData)
end

function UILWPowerSourceView:OnRemoveListener()
  self:RemoveUIListener(EventId.BatteryPowerResourceUpdated, self.UpdateData)
  self:RemoveUIListener(EventId.PowerWorkerUpdated, self.UpdateData)
  base.OnRemoveListener(self)
end

function UILWPowerSourceView:ComponentDefine()
  if CS.CommonUtils.IsDebug() then
    self.common_bg_orange = self:AddComponent(UIButton, common_bg_orange_path)
    self.common_bg_orange:SetOnClick(function()
      SFSNetwork.SendMessage(MsgDefines.GMAddElectricityS4)
    end)
  end
  self.jiantou3 = self:AddComponent(UIBaseContainer, jiantou3_path)
  self.jiantou1 = self:AddComponent(UIBaseContainer, jiantou1_path)
  self.jiantou2 = self:AddComponent(UIBaseContainer, jiantou2_path)
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("season_s4_building_ui_info15")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.theItem = self.transform:Find(item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.power_fill = self:AddComponent(UIRawImage, power_fill_path)
  self.input_power_speed = self:AddComponent(UITextMeshProUGUIEx, input_power_speed_path)
  self.use_power_speed = self:AddComponent(UITextMeshProUGUIEx, use_power_speed_path)
  self.now_power_text = self:AddComponent(UITextMeshProUGUIEx, now_power_text_path)
  self.now_power_speed = self:AddComponent(UITextMeshProUGUIEx, now_power_speed_path)
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
    UIUtil.ShowButtonTips(self.auto_adjust_info_btn, "", "season_s4_building_ui_info49")
  end)
  self.speed_text = self:AddComponent(UITextMeshProUGUIEx, speed_text_path)
  self.select_mode = self:AddComponent(UIBaseContainer, select_mode_path)
  self.select_mode_txt = self:AddComponent(UITextMeshProUGUIEx, select_mode_txt_path)
  self.item_list = self:AddComponent(UIBaseContainer, item_list_path)
  self.item1 = self:AddComponent(UIToggle, item1_path)
  self.txt1 = self:AddComponent(UITextMeshProUGUIEx, txt1_path)
  self.item2 = self:AddComponent(UIToggle, item2_path)
  self.txt2 = self:AddComponent(UITextMeshProUGUIEx, txt2_path)
  self.item3 = self:AddComponent(UIToggle, item3_path)
  self.txt3 = self:AddComponent(UITextMeshProUGUIEx, txt3_path)
  self.item1_btn = self:AddComponent(UIButton, item1_btn_path)
  self.item2_btn = self:AddComponent(UIButton, item2_btn_path)
  self.item3_btn = self:AddComponent(UIButton, item3_btn_path)
  if dataIndexCache == 1 then
    self.select_mode_txt:SetLocalText("season_s4_building_ui_info60")
  elseif dataIndexCache == 2 then
    self.select_mode_txt:SetLocalText("season_s4_building_ui_info61")
  elseif dataIndexCache == 3 then
    self.select_mode_txt:SetLocalText("312093")
  end
  self.item1:SetIsOn(dataIndexCache == 1)
  self.item2:SetIsOn(dataIndexCache == 2)
  self.item3:SetIsOn(dataIndexCache == 3)
  self.item1_btn:SetOnClick(function()
    self.item1:SetIsOn(true)
  end)
  self.item2_btn:SetOnClick(function()
    self.item2:SetIsOn(true)
  end)
  self.item3_btn:SetOnClick(function()
    self.item3:SetIsOn(true)
  end)
  self.item1:SetOnValueChanged(function(isOn)
    if isOn then
      dataIndexCache = 1
      self.select_mode_txt:SetLocalText("season_s4_building_ui_info60")
      self:UpdateData(true)
    end
  end)
  self.item2:SetOnValueChanged(function(isOn)
    if isOn then
      dataIndexCache = 2
      self.select_mode_txt:SetLocalText("season_s4_building_ui_info61")
      self:UpdateData(true)
    end
  end)
  self.item3:SetOnValueChanged(function(isOn)
    if isOn then
      dataIndexCache = 3
      self.select_mode_txt:SetLocalText("312093")
      self:UpdateData(true)
    end
  end)
  self.select_mode_btn1 = self:AddComponent(UIButton, select_mode_btn1_path)
  self.select_mode_btn2 = self:AddComponent(UIButton, select_mode_btn2_path)
  self.select_mode_btn1:SetOnClick(function()
    DOTween.To(function()
      return 0
    end, function(scale)
      self.item_list:SetLocalScaleXYZ(1, scale, 1)
    end, 1, 0.2)
  end)
  self.select_mode_btn2:SetOnClick(function()
    DOTween.To(function()
      return 1
    end, function(scale)
      self.item_list:SetLocalScaleXYZ(1, scale, 1)
    end, 0, 0.2):SetEase(CS.DG.Tweening.Ease.InExpo)
  end)
  self.item_list:SetLocalScaleXYZ(1, 0, 1)
end

function UILWPowerSourceView:ComponentDestroy()
  self.content:RemoveComponents(UILWPowerSourceItem)
  self.theItem:GameObjectRecycleAll()
  self.content = nil
  self.btn_back = nil
  self.speed_text = nil
  self.input_power_speed = nil
  self.use_power_speed = nil
  self.now_power_text = nil
  self.now_power_speed = nil
  self.auto_adjust_info_btn = nil
  self.icon_left = nil
  self.icon_right = nil
  self.select_mode = nil
  self.select_mode_txt = nil
  self.item_list = nil
  self.power_fill = nil
  self.auto_adjust_select = nil
  self.auto_adjust_btn = nil
  self.item1 = nil
  self.item2 = nil
  self.item3 = nil
  self.txt1 = nil
  self.txt2 = nil
  self.txt3 = nil
  self.item1_btn = nil
  self.item2_btn = nil
  self.item3_btn = nil
  self.select_mode_btn1 = nil
  self.select_mode_btn2 = nil
end

function UILWPowerSourceView:SetAutoAdjustMode(isOn)
  if isOn then
    SFSNetwork.SendMessage(MsgDefines.SetLighthouseBrightnessAutoDowngrade, 1)
  else
    SFSNetwork.SendMessage(MsgDefines.SetLighthouseBrightnessAutoDowngrade, 0)
  end
  self.icon_left:SetActive(not isOn)
  self.icon_right:SetActive(isOn)
end

function UILWPowerSourceView:Update1000MS()
  self:UpdateBatteryPower()
end

function UILWPowerSourceView:UpdateBatteryPower()
  local mgr = DataCenter.SeasonPowerWorkerManager
  local powerNow, powerMax, powerSpeed = mgr:GetBatteryPowerResourceInfo()
  local inputNow, inputMax = mgr:CalcPowerInput()
  local outputNow, outputMax = mgr:CalcPowerOutput()
  local zero = UIUtil.GetMinuteSpeedStr(0)
  local lightHouseStatus = mgr.lightHouseStatus
  self.jiantou1:SetActive(0 < inputNow)
  self.jiantou2:SetActive(0 < powerSpeed and powerNow < powerMax)
  self.jiantou3:SetActive(0 < outputNow)
  if powerMax ~= nil and powerMax ~= 0 then
    self.power_fill:SetLocalScaleXYZ(powerNow / powerMax, 1, 1)
  else
    self.power_fill:SetLocalScaleXYZ(0, 1, 1)
  end
  if inputNow == 0 then
    self.input_power_speed:SetText("+" .. zero)
  else
    self.input_power_speed:SetText(UIUtil.GetMinuteSpeedStr(inputNow * 60))
  end
  if outputNow == 0 then
    self.use_power_speed:SetText("-" .. zero)
  else
    self.use_power_speed:SetText(UIUtil.GetMinuteSpeedStr(outputNow * -60))
  end
  if 99999 < powerNow then
    self.now_power_text:SetText(string.GetFormattedStr2(powerNow) .. "/" .. string.GetFormattedStr2(powerMax))
  else
    self.now_power_text:SetText(string.GetFormattedSeparatorNum(powerNow) .. "/" .. string.GetFormattedSeparatorNum(powerMax))
  end
  if powerSpeed == 0 then
    self.now_power_speed:SetText(string.format("<color=#FFFFFF>+%s</color>", zero))
  elseif 0 < powerSpeed then
    self.now_power_speed:SetText(string.format("<color=#0BFF78>%s</color>", UIUtil.GetMinuteSpeedStr(powerSpeed * 60)))
  elseif powerNow == 0 then
    self.now_power_speed:SetText(string.format("<color=#f97077>-%s</color>", zero))
  else
    self.now_power_speed:SetText(string.format("<color=#f97077>%s</color>", UIUtil.GetMinuteSpeedStr(powerSpeed * 60)))
  end
  local formationCount = mgr:GetFormationCount()
  local workerCount = mgr:GetPowerWorkerCount()
  if lightHouseStatus == nil or formationCount == 0 or workerCount == 0 then
    self.speed_text:SetLocalText("season_s4_building_ui_info37")
  elseif powerSpeed == 0 then
    if powerNow == powerMax and powerMax ~= nil and powerMax ~= 0 then
      self.speed_text:SetLocalText("season_s4_building_ui_info54")
    elseif powerNow ~= powerMax and powerMax ~= nil and powerMax ~= 0 then
      self.speed_text:SetLocalText("season_s4_building_ui_info55")
    else
      self.speed_text:SetLocalText("season_s4_building_ui_info24")
    end
  elseif 0 < powerSpeed then
    local remainTime = (powerMax - powerNow) / powerSpeed
    self.speed_text:SetLocalText("season_s4_building_ui_info21", UITimeManager:GetInstance():SecondToFmtString(remainTime))
  elseif 0 < powerNow then
    local remainTime = powerNow / powerSpeed
    self.speed_text:SetLocalText("season_s4_building_ui_info22", UITimeManager:GetInstance():SecondToFmtString(math.abs(remainTime)))
  end
end

function UILWPowerSourceView:UpdateData(switch_data)
  if switch_data then
    DOTween.To(function()
      return 1
    end, function(scale)
      self.item_list:SetLocalScaleXYZ(1, scale, 1)
    end, 0, 0.2):SetEase(CS.DG.Tweening.Ease.InExpo)
  else
    self.item_list:SetLocalScaleXYZ(1, 0, 1)
  end
  self:UpdateBatteryPower()
  local data_count = 0
  local goItem, theItem
  self.content:RemoveComponents(UILWPowerSourceItem)
  self.theItem:GameObjectRecycleAll()
  local powerWorkerDict = DataCenter.SeasonPowerWorkerManager.powerWorkerDict
  local powerWorkerCount = table.count(powerWorkerDict)
  if powerWorkerCount == 0 then
  elseif dataIndexCache == 1 or dataIndexCache == 3 then
    for k, v in pairs(powerWorkerDict) do
      if v and v.state == PowerWorkerStatus.CHARGE_SELF then
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(v.buildUuid)
        if buildData ~= nil then
          goItem = self.theItem:GameObjectSpawn(self.content.transform)
          goItem.name = "item_" .. UIUtil.GetLoopListItemIndex()
          goItem:SetActive(true)
          theItem = self.content:AddComponent(UILWPowerSourceItem, goItem.name)
          theItem:ReInit(1, buildData, true)
          data_count = data_count + 1
        end
      end
    end
  end
  local lightHouseStatus = DataCenter.SeasonPowerWorkerManager.lightHouseStatus
  if lightHouseStatus then
    self.auto_adjust_select:SetIsOnWithoutNotify(lightHouseStatus.autoDownGrade == 1)
    self.icon_left:SetActive(lightHouseStatus.autoDownGrade ~= 1)
    self.icon_right:SetActive(lightHouseStatus.autoDownGrade == 1)
  end
  if lightHouseStatus == nil or lightHouseStatus.active ~= true then
  else
    if dataIndexCache == 1 or dataIndexCache == 3 then
      if lightHouseStatus.alBuildSpeed ~= nil and lightHouseStatus.alBuildSpeed ~= 0 then
        goItem = self.theItem:GameObjectSpawn(self.content.transform)
        goItem.name = "item_" .. UIUtil.GetLoopListItemIndex()
        goItem:SetActive(true)
        theItem = self.content:AddComponent(UILWPowerSourceItem, goItem.name)
        theItem:ReInit(2, toInt(lightHouseStatus.alBuildSpeed), true)
        data_count = data_count + 1
      end
      if 0 < toInt(lightHouseStatus.otherWorkerNum) then
        goItem = self.theItem:GameObjectSpawn(self.content.transform)
        goItem.name = "item_" .. UIUtil.GetLoopListItemIndex()
        goItem:SetActive(true)
        theItem = self.content:AddComponent(UILWPowerSourceItem, goItem.name)
        theItem:ReInit(3, lightHouseStatus, true)
        data_count = data_count + 1
      end
    end
    if (dataIndexCache == 2 or dataIndexCache == 3) and 0 < toInt(lightHouseStatus.brightnessLevel) then
      goItem = self.theItem:GameObjectSpawn(self.content.transform)
      goItem.name = "item_" .. UIUtil.GetLoopListItemIndex()
      goItem:SetActive(true)
      theItem = self.content:AddComponent(UILWPowerSourceItem, goItem.name)
      theItem:ReInit(4, lightHouseStatus, false)
      data_count = data_count + 1
    end
  end
  if powerWorkerCount == 0 then
  elseif dataIndexCache == 2 or dataIndexCache == 3 then
    for k, v in pairs(powerWorkerDict) do
      if v and v.state == PowerWorkerStatus.CHARGE_OTHER then
        goItem = self.theItem:GameObjectSpawn(self.content.transform)
        goItem.name = "item_" .. UIUtil.GetLoopListItemIndex()
        goItem:SetActive(true)
        theItem = self.content:AddComponent(UILWPowerSourceItem, goItem.name)
        theItem:ReInit(5, v, false)
        data_count = data_count + 1
      elseif v and v.state == PowerWorkerStatus.MARCH then
        goItem = self.theItem:GameObjectSpawn(self.content.transform)
        goItem.name = "item_" .. UIUtil.GetLoopListItemIndex()
        goItem:SetActive(true)
        theItem = self.content:AddComponent(UILWPowerSourceItem, goItem.name)
        theItem:ReInit(6, v, false)
        data_count = data_count + 1
      end
    end
  end
end

return UILWPowerSourceView
