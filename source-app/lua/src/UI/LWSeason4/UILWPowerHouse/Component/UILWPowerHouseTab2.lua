local UILWPowerHouseTab2 = BaseClass("UILWPowerHouseTab2", UIAsyncContainer)
local base = UIAsyncContainer
local PowerWorkerItem = require("UI.LWSeason4.UILWPowerHouse.Component.LightHouse.PowerWorkerItem")
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local LightHouseStatus = require("UI.LWSeason4.Component.LightHouseStatus")
local close_btn_path = "CloseBtn"
local power_status_path = "BottomRoot/PowerStatus"
local cell1_path = "ScrollView/Viewport/ContentWorker/Cell1"
local cell2_path = "ScrollView/Viewport/ContentWorker/Cell2"
local cell3_path = "ScrollView/Viewport/ContentWorker/Cell3"
local cell4_path = "ScrollView/Viewport/ContentWorker/Cell4"
local help_num_path = "BottomRoot/HelpNum"
local help_speed_path = "BottomRoot/HelpSpeed"
local refuse_it_select_path = "BottomRoot/RefusePowerHelper/RefuseItSelect"
local refuse_it_btn_path = "BottomRoot/RefusePowerHelper/RefuseItBtn"
local no_help_path = "BottomRoot/NoHelp"
local scroll_view_path = "BottomRoot/ScrollView"
local content_help_path = "BottomRoot/ScrollView/Viewport/ContentHelp"
local ui_player_head_path = "BottomRoot/ScrollView/Viewport/ContentHelp/UIPlayerHead"
local icon_left_path = "BottomRoot/RefusePowerHelper/RefuseItSelect/iconLeft"
local icon_right_path = "BottomRoot/RefusePowerHelper/RefuseItSelect/iconRight"
local empty_path = "Empty"

function UILWPowerHouseTab2:OnCreate()
  base.OnCreate(self)
  self.empty = self:AddComponent(UIButton, empty_path)
  self.power_status = self:AddComponent(LightHouseStatus, power_status_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWPowerHouse)
  end)
  self.cell1 = self:AddComponent(PowerWorkerItem, cell1_path)
  self.cell2 = self:AddComponent(PowerWorkerItem, cell2_path)
  self.cell3 = self:AddComponent(PowerWorkerItem, cell3_path)
  self.cell4 = self:AddComponent(PowerWorkerItem, cell4_path)
  self.help_num = self:AddComponent(UITextMeshProUGUIEx, help_num_path)
  self.help_speed = self:AddComponent(UITextMeshProUGUIEx, help_speed_path)
  self.refuse_it_select = self:AddComponent(UIToggle, refuse_it_select_path)
  self.refuse_it_btn = self:AddComponent(UIButton, refuse_it_btn_path)
  self.no_help = self:AddComponent(UITextMeshProUGUIEx, no_help_path)
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.content_help = self:AddComponent(UIBaseContainer, content_help_path)
  self.thePlayerItem = self.transform:Find(ui_player_head_path).gameObject
  self.thePlayerItem:GameObjectCreatePool()
  self.icon_left = self:AddComponent(UIImage, icon_left_path)
  self.icon_right = self:AddComponent(UIImage, icon_right_path)
  self.refuse_it_btn:SetOnClick(function()
    local isOn = self.refuse_it_select:GetIsOn()
    self.refuse_it_select:SetIsOnWithoutNotify(not isOn)
    self:RefusePowerHelper(not isOn)
  end)
  self.refuse_it_select:SetOnValueChanged(function(isOn)
    self:RefusePowerHelper(isOn)
  end)
  self.cell1:ReInit(BuildingTypes.LW_BUILD_SEASON4_POWER_STATION1, 1)
  self.cell2:ReInit(BuildingTypes.LW_BUILD_SEASON4_POWER_STATION2, 2)
  self.cell3:ReInit(BuildingTypes.LW_BUILD_SEASON4_POWER_STATION3, 3)
  self.cell4:ReInit(BuildingTypes.LW_BUILD_SEASON4_POWER_STATION4, 4)
end

function UILWPowerHouseTab2:OnDestroy()
  self.content_help:RemoveComponents(UICommonHead)
  self.thePlayerItem:GameObjectRecycleAll()
  self.power_status = nil
  self.empty = nil
  self.close_btn = nil
  self.cell1 = nil
  self.cell2 = nil
  self.cell3 = nil
  self.cell4 = nil
  self.icon_left = nil
  self.icon_right = nil
  self.refuse_it_select = nil
  self.refuse_it_btn = nil
  self.help_num = nil
  self.help_speed = nil
  self.no_help = nil
  self.scroll_view = nil
  self.content_help = nil
  base.OnDestroy(self)
end

function UILWPowerHouseTab2:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BatteryPowerResourceUpdated, self.UpdateData)
  self:AddUIListener(EventId.PowerWorkerUpdated, self.UpdateData)
end

function UILWPowerHouseTab2:OnRemoveListener()
  self:RemoveUIListener(EventId.BatteryPowerResourceUpdated, self.UpdateData)
  self:RemoveUIListener(EventId.PowerWorkerUpdated, self.UpdateData)
  base.OnRemoveListener(self)
end

function UILWPowerHouseTab2:UpdateData()
  if IsNull(self.gameObject) then
    return
  end
  local mgr = DataCenter.SeasonPowerWorkerManager
  local lightHouseStatus = mgr.lightHouseStatus
  self.content_help:RemoveComponents(UICommonHead)
  self.thePlayerItem:GameObjectRecycleAll()
  if lightHouseStatus then
    local otherWorkerNum = toInt(lightHouseStatus.otherWorkerNum)
    local level = toInt(lightHouseStatus.lv)
    if 0 < level then
      local cfg = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.LW_BUILD_SEASON4_LIGHTHOUSE, level)
      if cfg ~= nil then
        local assistanceMaxCount = toInt(cfg.para2)
        self.help_num:SetText(otherWorkerNum .. "/" .. assistanceMaxCount)
      end
    else
      self.help_num:SetText("0/1")
    end
    if otherWorkerNum == 0 or table.count(lightHouseStatus.otherWorkerHead) == 0 then
      self.no_help:SetActive(true)
      self.scroll_view:SetActive(false)
      self.help_speed:SetText(UIUtil.GetMinuteSpeedStr(0))
    else
      self.no_help:SetActive(false)
      self.scroll_view:SetActive(true)
      local goItem, theItem
      self.content_help:RemoveComponents(UICommonHead)
      self.thePlayerItem:GameObjectRecycleAll()
      for k, v in pairs(lightHouseStatus.otherWorkerHead) do
        goItem = self.thePlayerItem:GameObjectSpawn(self.content_help.transform)
        goItem.name = "item_" .. UIUtil.GetLoopListItemIndex()
        goItem:SetActive(true)
        theItem = self.content_help:AddComponent(UICommonHead, goItem.name)
        theItem:SetEnableClickShowInfo(true, true)
        theItem:ParseHeadInfo(v)
      end
      local cfg = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.LW_BUILD_SEASON4_POWER_STATION1, 1)
      if cfg ~= nil then
        local workerSpeed = toInt(cfg.para1)
        self.help_speed:SetText(UIUtil.GetMinuteSpeedStr(otherWorkerNum * workerSpeed * 60))
      end
    end
    self.empty:SetActive(not lightHouseStatus.active)
  else
    self.empty:SetActive(true)
    self.no_help:SetActive(true)
    self.scroll_view:SetActive(false)
    self.help_num:SetText("0/1")
    self.help_speed:SetText(UIUtil.GetMinuteSpeedStr(0))
  end
  local isON = lightHouseStatus and lightHouseStatus.autoCloseOnBloodNight == 1
  self.icon_left:SetActive(not isON)
  self.icon_right:SetActive(isON)
  self.refuse_it_select:SetIsOnWithoutNotify(isON)
end

function UILWPowerHouseTab2:RefusePowerHelper(isOn)
  SFSNetwork.SendMessage(MsgDefines.SetAutoCloseLighthouseWhenBloodNight, isOn)
  self.icon_left:SetActive(not isOn)
  self.icon_right:SetActive(isOn)
end

return UILWPowerHouseTab2
