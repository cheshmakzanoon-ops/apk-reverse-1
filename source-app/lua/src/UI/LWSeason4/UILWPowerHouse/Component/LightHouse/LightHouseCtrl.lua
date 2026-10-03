local LightHouseCtrl = BaseClass("LightHouseCtrl", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local worker_txt_path = "workerTxt"
local worker_speed_path = "workerSpeed"
local factory_txt_path = "factoryTxt"
local factory_speed_path = "factorySpeed"
local bubble_path = "bubble/bubble"
local bubble_txt_path = "bubble/bubbleTxt"
local bubble_speed_path = "bubble/bubbleSpeed"
local light_time_txt_path = "btnList/lightTimeTxt"
local light_size_txt_path = "btnList/lightSizeTxt"
local player_count_txt_path = "btnList/playerCountTxt"
local btn_list_path = "btnList"
local icon_time_path = "btnList/lightTimeTxt/iconTimeBtn"
local icon_size_path = "btnList/lightSizeTxt/iconSizeBtn"
local icon_player_path = "btnList/playerCountTxt/iconPlayerBtn"
local worker_icon1_path = "workerIcon1"
local worker_icon2_path = "workerIcon2"
local worker_icon3_path = "workerIcon3"
local worker_icon4_path = "workerIcon4"
local worker_icon5_path = "workerIcon5"
local factory_icon1_path = "factoryIcon1"
local factory_icon2_path = "factoryIcon2"
local factory_icon3_path = "factoryIcon3"
local factory_icon4_path = "factoryIcon4"
local factory_icon5_path = "factoryIcon5"
local build_icon_work1_path = "buildIconWork1"
local build_icon_work2_path = "buildIconWork2"
local build_icon_work3_path = "buildIconWork3"
local build_icon_work4_path = "buildIconWork4"
local build_icon_work5_path = "buildIconWork5"

function LightHouseCtrl:OnCreate()
  base.OnCreate(self)
  self.worker_icon1 = self:AddComponent(UIButton, worker_icon1_path)
  self.worker_icon2 = self:AddComponent(UIButton, worker_icon2_path)
  self.worker_icon3 = self:AddComponent(UIButton, worker_icon3_path)
  self.worker_icon4 = self:AddComponent(UIButton, worker_icon4_path)
  self.worker_icon5 = self:AddComponent(UIButton, worker_icon5_path)
  self.worker_icon1:SetOnClick(function()
    self:OnWorkerClick(self.worker_icon1)
  end)
  self.worker_icon2:SetOnClick(function()
    self:OnWorkerClick(self.worker_icon2)
  end)
  self.worker_icon3:SetOnClick(function()
    self:OnWorkerClick(self.worker_icon3)
  end)
  self.worker_icon4:SetOnClick(function()
    self:OnWorkerClick(self.worker_icon4)
  end)
  self.worker_icon5:SetOnClick(function()
    self:OnWorkerClick(self.worker_icon5)
  end)
  self.factory_icon1 = self:AddComponent(UIButton, factory_icon1_path)
  self.factory_icon2 = self:AddComponent(UIButton, factory_icon2_path)
  self.factory_icon3 = self:AddComponent(UIButton, factory_icon3_path)
  self.factory_icon4 = self:AddComponent(UIButton, factory_icon4_path)
  self.factory_icon5 = self:AddComponent(UIButton, factory_icon5_path)
  self.factory_icon1:SetOnClick(function()
    self:OnFactoryClick(self.factory_icon1)
  end)
  self.factory_icon2:SetOnClick(function()
    self:OnFactoryClick(self.factory_icon2)
  end)
  self.factory_icon3:SetOnClick(function()
    self:OnFactoryClick(self.factory_icon3)
  end)
  self.factory_icon4:SetOnClick(function()
    self:OnFactoryClick(self.factory_icon4)
  end)
  self.factory_icon5:SetOnClick(function()
    self:OnFactoryClick(self.factory_icon5)
  end)
  self.build_icon_work1 = self:AddComponent(UIRawImage, build_icon_work1_path)
  self.build_icon_work2 = self:AddComponent(UIRawImage, build_icon_work2_path)
  self.build_icon_work3 = self:AddComponent(UIRawImage, build_icon_work3_path)
  self.build_icon_work4 = self:AddComponent(UIRawImage, build_icon_work4_path)
  self.build_icon_work5 = self:AddComponent(UIRawImage, build_icon_work5_path)
  self.worker_txt = self:AddComponent(UITextMeshProUGUIEx, worker_txt_path)
  self.worker_speed = self:AddComponent(UITextMeshProUGUIEx, worker_speed_path)
  self.factory_txt = self:AddComponent(UITextMeshProUGUIEx, factory_txt_path)
  self.factory_speed = self:AddComponent(UITextMeshProUGUIEx, factory_speed_path)
  self.bubble = self:AddComponent(UIImage, bubble_path)
  self.bubble_txt = self:AddComponent(UITextMeshProUGUIEx, bubble_txt_path)
  self.bubble_speed = self:AddComponent(UITextMeshProUGUIEx, bubble_speed_path)
  self.btn_list = self:AddComponent(UIBaseContainer, btn_list_path)
  self.light_time_txt = self:AddComponent(UITextMeshProUGUIEx, light_time_txt_path)
  self.light_size_txt = self:AddComponent(UITextMeshProUGUIEx, light_size_txt_path)
  self.player_count_txt = self:AddComponent(UITextMeshProUGUIEx, player_count_txt_path)
  self.icon_time_btn = self:AddComponent(UIButton, icon_time_path)
  self.icon_size_btn = self:AddComponent(UIButton, icon_size_path)
  self.icon_player_btn = self:AddComponent(UIButton, icon_player_path)
  self.icon_time_btn:SetOnClick(function()
    UIUtil.ShowButtonTips(self.icon_time_btn, "", "season_s4_light_on_ui_title07")
  end)
  self.icon_size_btn:SetOnClick(function()
    UIUtil.ShowButtonTips(self.icon_size_btn, "", "season_s4_light_on_ui_title03")
  end)
  self.icon_player_btn:SetOnClick(function()
    UIUtil.ShowButtonTips(self.icon_player_btn, "", "season_s4_light_on_ui_title08")
  end)
end

function LightHouseCtrl:OnWorkerClick(worker_icon)
  local lightHouseStatus = DataCenter.SeasonPowerWorkerManager.lightHouseStatus
  if lightHouseStatus then
    local msg = Localization:GetString("season_s4_building_ui_info59", toInt(lightHouseStatus.otherWorkerNum))
    UIUtil.ShowButtonTips(worker_icon, "", msg, true)
  end
end

function LightHouseCtrl:OnFactoryClick(factory_icon)
  local lightHouseStatus = DataCenter.SeasonPowerWorkerManager.lightHouseStatus
  if lightHouseStatus then
    local msg = Localization:GetString("season_s4_building_ui_info58", toInt(lightHouseStatus.selfWorkerNum))
    UIUtil.ShowButtonTips(factory_icon, "", msg, true)
  end
end

function LightHouseCtrl:OnDestroy()
  self.worker_icon1 = nil
  self.worker_icon2 = nil
  self.worker_icon3 = nil
  self.worker_icon4 = nil
  self.worker_icon5 = nil
  self.factory_icon1 = nil
  self.factory_icon2 = nil
  self.factory_icon3 = nil
  self.factory_icon4 = nil
  self.factory_icon5 = nil
  self.build_icon_work1 = nil
  self.build_icon_work2 = nil
  self.build_icon_work3 = nil
  self.build_icon_work4 = nil
  self.build_icon_work5 = nil
  self.worker_txt = nil
  self.worker_speed = nil
  self.factory_txt = nil
  self.factory_speed = nil
  self.bubble = nil
  self.bubble_txt = nil
  self.bubble_speed = nil
  self.btn_list = nil
  self.light_time_txt = nil
  self.light_size_txt = nil
  self.player_count_txt = nil
  self.icon_time_btn = nil
  self.icon_size_btn = nil
  self.icon_player_btn = nil
  base.OnDestroy(self)
end

function LightHouseCtrl:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BatteryPowerResourceUpdated, self.UpdateBatteryPowerData)
  self:AddUIListener(EventId.LuaEntryEffectRefreshStatus, self.UpdateBatteryPowerData)
end

function LightHouseCtrl:OnRemoveListener()
  self:RemoveUIListener(EventId.BatteryPowerResourceUpdated, self.UpdateBatteryPowerData)
  self:RemoveUIListener(EventId.LuaEntryEffectRefreshStatus, self.UpdateBatteryPowerData)
  base.OnRemoveListener(self)
end

function LightHouseCtrl:UpdateBatteryPowerData()
  self:RefreshUI(DataCenter.SeasonPowerWorkerManager.lightHouseStatus)
end

function LightHouseCtrl:RefreshStatus()
  local data = DataCenter.SeasonLightDataManager:GetLightBuff(704100)
  if data then
    local lightPeople = toInt(data.lightPeople)
    self.player_count_txt:SetText(lightPeople)
  end
end

function LightHouseCtrl:RefreshUI(lightHouseStatus)
  if self.build_icon_work1 == nil then
    return
  end
  if lightHouseStatus == nil then
    self.bubble:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_01.png")
    self.bubble_txt:SetText("")
    self.bubble_speed:SetText("")
    self.btn_list:SetActive(false)
    self.worker_txt:SetActive(false)
    self.worker_speed:SetActive(false)
    self.factory_txt:SetActive(false)
    self.factory_speed:SetActive(false)
  else
    local brightnessLevel = toInt(lightHouseStatus.brightnessLevel)
    local selfWorkerNum = toInt(lightHouseStatus.selfWorkerNum)
    local otherWorkerNum = toInt(lightHouseStatus.otherWorkerNum)
    local workerSpeed = 100
    local cfg = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.LW_BUILD_SEASON4_POWER_STATION1, 1)
    if cfg ~= nil then
      workerSpeed = toInt(cfg.para1) * 60
    end
    self.worker_txt:SetActive(0 < otherWorkerNum)
    self.worker_speed:SetActive(0 < otherWorkerNum)
    self.factory_txt:SetActive(0 < selfWorkerNum)
    self.factory_speed:SetActive(0 < selfWorkerNum)
    self.worker_txt:SetText("\195\151" .. otherWorkerNum)
    self.worker_speed:SetText(UIUtil.GetMinuteSpeedStr(workerSpeed * otherWorkerNum))
    self.factory_txt:SetText("\195\151" .. selfWorkerNum)
    self.factory_speed:SetText(UIUtil.GetMinuteSpeedStr(workerSpeed * selfWorkerNum))
    local lightSize = 0
    local usePower = 0
    if 0 < brightnessLevel then
      cfg = LocalController:instance():getLine(TableName.LW_LIGHTS_ON_S4, brightnessLevel)
      if cfg and cfg.electricity_use ~= nil then
        local buff_add = DataCenter.SeasonLightDataManager:GetBloodyNightElectricityUseBuff()
        usePower = (toInt(cfg.electricity_use) + buff_add) * 60
        lightSize = toInt(cfg.size) * 2 + 1
        self.bubble_speed:SetText(UIUtil.GetMinuteSpeedStr(-usePower))
      else
        self.bubble_speed:SetText("")
      end
    else
      self.bubble_txt:SetText("")
      self.bubble_speed:SetText("")
    end
    local powerNow, powerMax = DataCenter.SeasonPowerWorkerManager:GetBatteryPowerResourceInfo()
    if brightnessLevel == 1 then
      self.bubble_txt:SetText("L1")
      self.bubble:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_04.png")
    elseif brightnessLevel == 2 then
      self.bubble_txt:SetText("L2")
      self.bubble:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_05.png")
    elseif brightnessLevel == 3 then
      self.bubble_txt:SetText("L3")
      self.bubble:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_06.png")
    elseif brightnessLevel == 4 then
      self.bubble_txt:SetText("L4")
      self.bubble:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_07.png")
    elseif lightHouseStatus.active then
      if powerNow ~= powerMax then
        if powerNow > powerMax * 0.1 then
          self.bubble:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_03.png")
        else
          self.bubble:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_02.png")
        end
      end
    else
      self.bubble:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_01.png")
    end
    local factory_icon_scale = math.min(1, selfWorkerNum)
    local worker_icon_scale = math.min(1, otherWorkerNum)
    for i = 1, 5 do
      self["worker_icon" .. i]:SetActive(0 < otherWorkerNum and brightnessLevel + 1 == i)
      self["factory_icon" .. i]:SetActive(0 < selfWorkerNum and brightnessLevel + 1 == i)
      self["build_icon_work" .. i]:SetActive(brightnessLevel + 1 == i)
      if self["worker_icon" .. i] and self["worker_icon" .. i].rectTransform ~= nil then
        self["worker_icon" .. i]:SetLocalScaleXYZ(worker_icon_scale, worker_icon_scale, worker_icon_scale)
      end
      if self["factory_icon" .. i] and self["factory_icon" .. i].rectTransform ~= nil then
        self["factory_icon" .. i]:SetLocalScaleXYZ(factory_icon_scale, factory_icon_scale, factory_icon_scale)
      end
    end
    if lightHouseStatus.active and powerNow == powerMax then
      if 0 < brightnessLevel then
        self.bubble:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_09.png")
      else
        self.bubble:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_08.png")
      end
    end
    if 0 < brightnessLevel then
      local canUseTime, canUseTimeStr = DataCenter.SeasonPowerWorkerManager:CalcBatteryPowerTime(brightnessLevel)
      self.light_time_txt:SetText(canUseTimeStr)
      self.btn_list:SetActive(true)
      self.light_size_txt:SetText(lightSize .. "\195\151" .. lightSize)
      self:RefreshStatus()
      if lightHouseStatus.active and canUseTime == 0 then
        self.bubble:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_02.png")
      end
    else
      self.btn_list:SetActive(false)
    end
  end
end

function LightHouseCtrl:Update1000MS()
  if ComponentIsValid(self.build_icon_work1) then
    self:RefreshUI(DataCenter.SeasonPowerWorkerManager.lightHouseStatus)
  end
end

return LightHouseCtrl
