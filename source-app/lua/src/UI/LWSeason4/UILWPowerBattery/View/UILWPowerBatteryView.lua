local UILWPowerBatteryView = BaseClass("UILWPowerBatteryView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UILWPowerBatteryItem = require("UI.LWSeason4.UILWPowerBattery.Component.UILWPowerBatteryItem")
local LWResourceLackTemplate = require("DataCenter.LWResourceLack.LWResourceLackTemplate")
local LWResourceLackCell = require("UI.LWResourceLack.Res.Component.LWResourceLackCell")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local speed_text_path = "Content/SpeedText"
local desc_txt_path = "Content/DescTxt"
local pro_bar_path = "Content/ProBar"
local pro_bar_text_path = "Content/ProBar/ProBarText"
local content_path = "Content/ScrollView/Viewport/Content"
local cell_path = "Content/ScrollView/Viewport/Content/Cell"

function UILWPowerBatteryView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:UpdateData()
  self:Update1000MS()
end

function UILWPowerBatteryView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWPowerBatteryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceBaseDataUpdated, self.UpdateData)
end

function UILWPowerBatteryView:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceBaseDataUpdated, self.UpdateData)
  base.OnRemoveListener(self)
end

function UILWPowerBatteryView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("season_s4_building_ui_info14")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.speed_text = self:AddComponent(UITextMeshProUGUIEx, speed_text_path)
  self.desc_txt = self:AddComponent(UITextMeshProUGUIEx, desc_txt_path)
  self.pro_bar = self:AddComponent(UISlider, pro_bar_path)
  self.pro_bar_text = self:AddComponent(UITextMeshProUGUIEx, pro_bar_text_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.theItem = self.transform:Find(cell_path).gameObject
  self.theItem:GameObjectCreatePool()
end

function UILWPowerBatteryView:ComponentDestroy()
  self.content:RemoveComponents(LWResourceLackCell)
  self.theItem:GameObjectRecycleAll()
  self.btn_back = nil
  self.speed_text = nil
  self.desc_txt = nil
  self.pro_bar = nil
  self.pro_bar_text = nil
  self.content = nil
end

function UILWPowerBatteryView:Update1000MS()
  local mgr = DataCenter.SeasonPowerWorkerManager
  local formationCount = mgr:GetFormationCount()
  local workerCount = mgr:GetPowerWorkerCount()
  local lightHouseStatus = mgr.lightHouseStatus
  if lightHouseStatus == nil or formationCount == 0 or workerCount == 0 then
    self.pro_bar:SetValue(0)
    self.pro_bar_text:SetText("0/6000")
    self.speed_text:SetLocalText("season_s4_building_ui_info37")
    return
  end
  local powerNow, powerMax, powerSpeed = DataCenter.SeasonPowerWorkerManager:GetBatteryPowerResourceInfo()
  if powerNow then
    if powerMax == 0 then
      self.pro_bar:SetValue(0)
      self.pro_bar_text:SetText("")
    else
      self.pro_bar:SetValue(powerNow / powerMax)
      self.pro_bar_text:SetText(string.format("%s/%s", string.GetFormattedSeparatorNum(powerNow), string.GetFormattedSeparatorNum(powerMax)))
    end
    if powerSpeed == 0 then
      self.speed_text:SetLocalText("season_s4_building_ui_info24")
      self.desc_txt:SetText("")
    elseif 0 < powerSpeed then
      local remainTime = (powerMax - powerNow) / powerSpeed
      self.speed_text:SetLocalText("season_s4_building_ui_info20", UIUtil.GetMinuteSpeedStr(powerSpeed * 60))
      self.desc_txt:SetLocalText("season_s4_building_ui_info21", UITimeManager:GetInstance():SecondToFmtString(remainTime))
    else
      local remainTime = powerNow / powerSpeed
      self.speed_text:SetLocalText("season_s4_building_ui_info23", UIUtil.GetMinuteSpeedStr(powerSpeed * 60))
      self.desc_txt:SetLocalText("season_s4_building_ui_info22", UITimeManager:GetInstance():SecondToFmtString(math.abs(remainTime)))
    end
  end
end

function UILWPowerBatteryView:UpdateData()
  local goItem, theItem
  self.content:RemoveComponents(LWResourceLackCell)
  self.theItem:GameObjectRecycleAll()
  self:Update1000MS()
  local mgr = DataCenter.SeasonPowerWorkerManager
  local formationCount = mgr:GetFormationCount()
  local workerCount = mgr:GetPowerWorkerCount()
  local show_pro_bar = true
  if formationCount == 0 or workerCount == 0 then
    show_pro_bar = false
    self:CreateFixNode()
  else
    local lightHouseStatus = mgr.lightHouseStatus
    if lightHouseStatus == nil or not lightHouseStatus.active then
      show_pro_bar = false
      self:CreateActiveNode()
    end
  end
  local configList = {}
  for k, configId in ipairs(configList) do
    local config = LocalController:instance():getLine(TableName.LW_Res_Lack_Tips, configId)
    if config then
      local template = LWResourceLackTemplate.New()
      template:InitData(config)
      goItem = self.theItem:GameObjectSpawn(self.content.transform)
      goItem.name = "item_" .. UIUtil.GetLoopListItemIndex()
      goItem:SetActive(true)
      theItem = self.content:AddComponent(LWResourceLackCell, goItem.name)
      theItem:ParseResourceLackTemplate(template, self.ctrl, {
        SeasonType = SeasonMapType.Darkness,
        ShowItemCount = true,
        MaxUseCount = 100
      })
    end
  end
  self.pro_bar:SetActive(show_pro_bar)
end

function UILWPowerBatteryView:CreateFixNode()
  if self.theNodeFix == nil then
    local luaPath = "UI.LWSeason4.UILWPowerHouse.Component.LightHouse.LightHouseFix"
    local prefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/PowerHouse/LightHouse/LightHouseFix.prefab"
    self.theNodeFix = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.content)
    self.theNodeFix:SetLocalPositionXYZ(0, -77, 0)
  end
  self.desc_txt:SetActive(true)
  self.desc_txt:SetLocalText("season_s4_building_ui_info07")
end

function UILWPowerBatteryView:CreateActiveNode()
  if self.theNodeActive == nil then
    local luaPath = "UI.LWSeason4.UILWPowerHouse.Component.LightHouse.LightHouseActive"
    local prefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/PowerHouse/LightHouse/LightHouseActive.prefab"
    self.theNodeActive = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.content)
    self.theNodeActive:SetLocalPositionXYZ(0, -77, 0)
  end
  if self.theNodeFix ~= nil then
    self.theNodeFix:SetActive(false)
  end
  self.desc_txt:SetActive(true)
  self.desc_txt:SetLocalText("season_s4_building_ui_info08")
end

return UILWPowerBatteryView
