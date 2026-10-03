local UILWPowerHouseTab1 = BaseClass("UILWPowerHouseTab1", UIAsyncContainer)
local base = UIAsyncContainer
local UIMainResourceProgress = require("UI.LWMainUI.Component.UIMainTop.UIMainResourceProgress")
local BuffIcon = require("UI.LWMainUI.Component.UIMainLeft.BuffIcon")
local LightHouseCtrl = require("UI.LWSeason4.UILWPowerHouse.Component.LightHouse.LightHouseCtrl")
local content_path = "BuffList/Viewport/Content"
local buff_icon_path = "BuffList/Viewport/Content/BuffIcon"
local resource_cell_path = "ResourceCell"
local res_add_btn_path = "ResourceCell/AddBtn"
local control_root_path = "ControlRoot"
local title_path = "ControlRoot/Title"
local sub_title_path = "ControlRoot/SubTitle"
local info_btn_path = "ControlRoot/infoBtn"
local bg1_path = "Bg1"
local bg2_path = "Bg2"
local bg3_path = "Bg3"
local bg4_path = "Bg4"
local bg5_path = "Bg5"
local eff_ui_power_house_tab1_path = "Eff_ui_PowerHouseTab1"
local big_glow_light1_path = "Eff_ui_PowerHouseTab1/big_glow_light1"
local big_glow_light2_path = "Eff_ui_PowerHouseTab1/big_glow_light2"
local big_glow_factory_path = "Eff_ui_PowerHouseTab1/big_glow_factory"
local big_glow_worker_path = "Eff_ui_PowerHouseTab1/big_glow_worker"
local dianliu_factory_path = "Eff_ui_PowerHouseTab1/dianliu_factory"
local dianliu_worker1_path = "Eff_ui_PowerHouseTab1/dianliu_worker1"
local dianliu_worker2_path = "Eff_ui_PowerHouseTab1/dianliu_worker2"
local eff_ui_s4_dengta_light_l01_path = "Eff_ui_S4_dengta_Light_L01"
local eff_ui_s4_dengta_light_l02_path = "Eff_ui_S4_dengta_Light_L02"
local eff_ui_s4_dengta_light_l03_path = "Eff_ui_S4_dengta_Light_L03"
local eff_ui_s4_dengta_light_l04_path = "Eff_ui_S4_dengta_Light_L04"

function UILWPowerHouseTab1:OnCreate()
  base.OnCreate(self)
  self.lightHouseActived = nil
  self.eff_ui_s4_dengta_light_l01 = self:AddComponent(UICanvasGroup, eff_ui_s4_dengta_light_l01_path)
  self.eff_ui_s4_dengta_light_l02 = self:AddComponent(UICanvasGroup, eff_ui_s4_dengta_light_l02_path)
  self.eff_ui_s4_dengta_light_l03 = self:AddComponent(UICanvasGroup, eff_ui_s4_dengta_light_l03_path)
  self.eff_ui_s4_dengta_light_l04 = self:AddComponent(UICanvasGroup, eff_ui_s4_dengta_light_l04_path)
  self.eff_ui_power_house_tab1 = self:AddComponent(UICanvasGroup, eff_ui_power_house_tab1_path)
  self.big_glow_light1 = self:AddComponent(UIBaseContainer, big_glow_light1_path)
  self.big_glow_light2 = self:AddComponent(UIBaseContainer, big_glow_light2_path)
  self.big_glow_factory = self:AddComponent(UIBaseContainer, big_glow_factory_path)
  self.big_glow_worker = self:AddComponent(UIBaseContainer, big_glow_worker_path)
  self.dianliu_factory = self:AddComponent(UIBaseContainer, dianliu_factory_path)
  self.dianliu_worker1 = self:AddComponent(UIBaseContainer, dianliu_worker1_path)
  self.dianliu_worker2 = self:AddComponent(UIBaseContainer, dianliu_worker2_path)
  self.animRoot = self:AddComponent(UIAnimator, "")
  self.bg1 = self:AddComponent(UIRawImage, bg1_path)
  self.bg2 = self:AddComponent(UIRawImage, bg2_path)
  self.bg3 = self:AddComponent(UIRawImage, bg3_path)
  self.bg4 = self:AddComponent(UIRawImage, bg4_path)
  self.bg5 = self:AddComponent(UIRawImage, bg5_path)
  self.theLightHouseCtrl = self:AddComponent(LightHouseCtrl, "LightHouseRoot")
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.resource_cell = self:AddComponent(UIMainResourceProgress, resource_cell_path)
  self.res_add_btn = self:AddComponent(UIButton, res_add_btn_path)
  self.resource_cell:ReInit({
    resourceType = ResourceType.BatteryPower,
    OnClickResourceBtn = function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPowerSource)
    end
  })
  self.res_add_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPowerSource)
    if CS.CommonUtils.IsDebug() then
      SFSNetwork.SendMessage(MsgDefines.GMAddElectricityS4)
    end
  end)
  self.theBuffItem = self.transform:Find(buff_icon_path).gameObject
  self.theBuffItem:GameObjectCreatePool()
  self.control_root = self:AddComponent(UIImage, control_root_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.sub_title = self:AddComponent(UITextMeshProUGUIEx, sub_title_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWLightsOnDetail)
  end)
  self.animRoot:Play("PowerHouseTab1_Open")
end

function UILWPowerHouseTab1:OnDestroy()
  self.content:RemoveComponents(BuffIcon)
  self.theBuffItem:GameObjectRecycleAll()
  self.bg1 = nil
  self.bg2 = nil
  self.bg3 = nil
  self.bg4 = nil
  self.bg5 = nil
  self.eff_ui_s4_dengta_light_l01 = nil
  self.eff_ui_s4_dengta_light_l02 = nil
  self.eff_ui_s4_dengta_light_l03 = nil
  self.eff_ui_s4_dengta_light_l04 = nil
  self.eff_ui_power_house_tab1 = nil
  self.big_glow_light1 = nil
  self.big_glow_light2 = nil
  self.big_glow_factory = nil
  self.big_glow_worker = nil
  self.dianliu_factory = nil
  self.dianliu_worker1 = nil
  self.dianliu_worker2 = nil
  self.content = nil
  self.buff_icon = nil
  self.resource_cell = nil
  self.res_add_btn = nil
  self.control_root = nil
  self.title = nil
  self.sub_title = nil
  self.info_btn = nil
  self.theLightHouseCtrl = nil
  base.OnDestroy(self)
end

function UILWPowerHouseTab1:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BatteryPowerResourceUpdated, self.UpdateData)
  self:AddUIListener(EventId.LuaEntryEffectRefreshStatus, self.UpdateData)
end

function UILWPowerHouseTab1:OnRemoveListener()
  self:RemoveUIListener(EventId.BatteryPowerResourceUpdated, self.UpdateData)
  self:RemoveUIListener(EventId.LuaEntryEffectRefreshStatus, self.UpdateData)
  base.OnRemoveListener(self)
end

function UILWPowerHouseTab1:UpdateData()
  if IsNull(self.gameObject) then
    return
  end
  self:RefreshBuff()
  local brightnessLevel = 0
  local mgr = DataCenter.SeasonPowerWorkerManager
  local lightHouseStatus = mgr.lightHouseStatus
  if lightHouseStatus and lightHouseStatus.active then
    local selfWorkerNum = math.min(toInt(lightHouseStatus.selfWorkerNum), 4)
    local otherWorkerNum = toInt(lightHouseStatus.otherWorkerNum)
    brightnessLevel = toInt(lightHouseStatus.brightnessLevel)
    if self.lightHouseActived == false then
      self.animRoot:Play("PowerHouseTab1_chadian")
    elseif self.brightnessLevel ~= brightnessLevel then
      if brightnessLevel == 0 then
        self.animRoot:Play("PowerHouseTab1_Glow00")
      elseif brightnessLevel == 1 then
        self.animRoot:Play("PowerHouseTab1_Glow01")
      elseif brightnessLevel == 2 then
        self.animRoot:Play("PowerHouseTab1_Glow02")
      elseif brightnessLevel == 3 then
        self.animRoot:Play("PowerHouseTab1_Glow03")
      elseif brightnessLevel == 4 then
        self.animRoot:Play("PowerHouseTab1_Glow04")
      end
    end
    if 0 < brightnessLevel or 0 < selfWorkerNum or 0 < otherWorkerNum then
      self.eff_ui_power_house_tab1:SetActive(true)
      self.big_glow_light1:SetActive(0 < brightnessLevel)
      self.big_glow_light2:SetActive(0 < brightnessLevel)
      self.big_glow_factory:SetActive(0 < selfWorkerNum)
      self.big_glow_worker:SetActive(0 < otherWorkerNum)
      self.dianliu_factory:SetActive(0 < selfWorkerNum)
      self.dianliu_worker1:SetActive(0 < otherWorkerNum)
      self.dianliu_worker2:SetActive(0 < otherWorkerNum)
      self.eff_ui_s4_dengta_light_l01:SetActive(brightnessLevel == 1)
      self.eff_ui_s4_dengta_light_l02:SetActive(brightnessLevel == 2)
      self.eff_ui_s4_dengta_light_l03:SetActive(brightnessLevel == 3)
      self.eff_ui_s4_dengta_light_l04:SetActive(brightnessLevel == 4)
    else
      self.eff_ui_power_house_tab1:SetActive(false)
      self.eff_ui_s4_dengta_light_l01:SetActive(false)
      self.eff_ui_s4_dengta_light_l02:SetActive(false)
      self.eff_ui_s4_dengta_light_l03:SetActive(false)
      self.eff_ui_s4_dengta_light_l04:SetActive(false)
    end
    self.lightHouseActived = true
    self.brightnessLevel = brightnessLevel
    self:CreateWorkNode()
  else
    local formationCount = mgr:GetFormationCount()
    local workerCount = mgr:GetPowerWorkerCount()
    if formationCount == 0 or workerCount == 0 then
      self:CreateFixNode()
    else
      self:CreateActiveNode()
    end
    self.eff_ui_power_house_tab1:SetActive(false)
    self.eff_ui_s4_dengta_light_l01:SetActive(false)
    self.eff_ui_s4_dengta_light_l02:SetActive(false)
    self.eff_ui_s4_dengta_light_l03:SetActive(false)
    self.eff_ui_s4_dengta_light_l04:SetActive(false)
    self.lightHouseActived = false
  end
  for i = 1, 5 do
    self["bg" .. i]:SetActive(brightnessLevel + 1 == i)
    self["bg" .. i]:LoadSprite(string.format("Assets/Main/SeasonRes/S4/Textures/PowerHouse/ljq_saijis4_diandeng_lv%s_bg_banner.png", i - 1))
  end
  self.resource_cell:CheckBatteryPower()
  self.theLightHouseCtrl:RefreshUI(lightHouseStatus)
end

function UILWPowerHouseTab1:RefreshBuff()
  local goItem, theItem
  local sort_buff = {}
  local lightBuffDict = DataCenter.SeasonLightDataManager:GetAllLightBuff()
  if lightBuffDict then
    for stateId, lightStatus in pairs(lightBuffDict) do
      local stateMeta = LocalController:instance():getLine(TableName.StatusTab, stateId)
      if stateMeta and not string.IsNullOrEmpty(stateMeta.icon) and (toInt(stateMeta.type3) > 0 or stateId == 704101) then
        lightStatus.meta = stateMeta
        lightStatus.order = toInt(stateMeta.order) + 1
        lightStatus.stateId = stateId
        table.insert(sort_buff, lightStatus)
      end
    end
  end
  local effectList = DataCenter.SeasonFarmerManager:GetCityAttachmentEffectInfo()
  if effectList and effectList.state then
    for _, stateId in pairs(effectList.state) do
      local stateMeta = LocalController:instance():getLine(TableName.StatusTab, stateId)
      if stateMeta then
        table.insert(sort_buff, {
          order = toInt(stateMeta.order) + 1,
          meta = stateMeta,
          stateId = stateId
        })
      end
    end
  end
  table.sort(sort_buff, function(a, b)
    return a.order > b.order
  end)
  local lastBuffDataShown = self.lastBuffDataShown
  if lastBuffDataShown ~= nil and sort_buff ~= nil and #lastBuffDataShown == #sort_buff then
    local is_same = true
    for index, new_data in ipairs(sort_buff) do
      local old = lastBuffDataShown[index]
      if old == nil or old.order ~= new_data.order or old.stateId ~= new_data.stateId then
        is_same = false
        break
      end
    end
    if is_same then
      self.resource_cell:CheckBatteryPower()
      return
    end
  end
  self.resource_cell:CheckBatteryPower()
  self.content:RemoveComponents(BuffIcon)
  self.theBuffItem:GameObjectRecycleAll()
  self.lastBuffDataShown = sort_buff
  for _, theData in ipairs(sort_buff) do
    local lightStatus = theData
    local stateMeta = theData.meta
    goItem = self.theBuffItem:GameObjectSpawn(self.content.transform)
    goItem.name = "effect_" .. UIUtil.GetLoopListItemIndex()
    goItem:SetActive(true)
    theItem = self.content:AddComponent(BuffIcon, goItem.name)
    theItem:SetIcon(stateMeta.icon)
    if lightStatus and lightStatus.lightPlayer then
      theItem:SetPlayerData(lightStatus.lightPlayer, 0.37)
    end
  end
end

function UILWPowerHouseTab1:CreateFixNode()
  if self.theNodeFix == nil then
    local luaPath = "UI.LWSeason4.UILWPowerHouse.Component.LightHouse.LightHouseFix"
    local prefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/PowerHouse/LightHouse/LightHouseFix.prefab"
    self.theNodeFix = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.control_root)
    self.theNodeFix:SetLocalPositionXYZ(0, 145, 0)
  end
  self.sub_title:SetActive(true)
  self.sub_title:SetLocalText("season_s4_building_ui_info07")
  self.control_root:SetSizeDeltaXY(778, 400)
  self.control_root:SetEnable(true)
end

function UILWPowerHouseTab1:CreateActiveNode()
  if self.theNodeActive == nil then
    local luaPath = "UI.LWSeason4.UILWPowerHouse.Component.LightHouse.LightHouseActive"
    local prefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/PowerHouse/LightHouse/LightHouseActive.prefab"
    self.theNodeActive = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.control_root)
    self.theNodeActive:SetLocalPositionXYZ(0, 145, 0)
  end
  if self.theNodeFix ~= nil then
    self.theNodeFix:SetActive(false)
  end
  self.sub_title:SetActive(true)
  self.sub_title:SetLocalText("season_s4_building_ui_info08")
  self.control_root:SetSizeDeltaXY(778, 400)
  self.control_root:SetEnable(true)
end

function UILWPowerHouseTab1:CreateWorkNode()
  if self.theNodeWork == nil then
    local luaPath = "UI.LWSeason4.UILWPowerHouse.Component.LightHouse.LightHouseWork"
    local prefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/PowerHouse/LightHouse/LightHouseWork.prefab"
    self.theNodeWork = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.control_root)
    self.theNodeWork:SetLocalPositionXYZ(0, 210, 0)
  end
  if self.theNodeFix ~= nil then
    self.theNodeFix:SetActive(false)
  end
  if self.theNodeActive ~= nil then
    self.theNodeActive:SetActive(false)
  end
  self.sub_title:SetActive(false)
  self.control_root:SetSizeDeltaXY(778, 450)
  self.control_root:SetEnable(false)
  self.title:SetActive(false)
  self.sub_title:SetActive(false)
  self.info_btn:SetActive(false)
end

return UILWPowerHouseTab1
