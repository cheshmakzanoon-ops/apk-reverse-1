local UILWPowerSourceItem = BaseClass("UILWPowerSourceItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UILWPowerSourceItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, "")
  self.icon_bg = self:AddComponent(UIImage, "iconBg")
  self.icon = self:AddComponent(UIImage, "iconBg/icon")
  self.player_head = self:AddComponent(UICommonHead, "iconBg/UIPlayerHead")
  self.title = self:AddComponent(UITextMeshProUGUIEx, "title")
  self.desc = self:AddComponent(UITextMeshProUGUIEx, "desc")
  self.speed = self:AddComponent(UITextMeshProUGUIEx, "speed")
  self.player_head:SetEnableClickShowInfo(true, true)
end

function UILWPowerSourceItem:OnDestroy()
  self.bg = nil
  self.icon_bg = nil
  self.icon = nil
  self.player_head = nil
  self.desc = nil
  self.speed = nil
  base.OnDestroy(self)
end

function UILWPowerSourceItem:OnEnable()
  base.OnEnable(self)
end

function UILWPowerSourceItem:OnDisable()
  base.OnDisable(self)
end

function UILWPowerSourceItem:ReInit(data_type, data, isInput)
  local speed_str_with_color, bg_path, icon_bg_color
  if isInput then
    bg_path = "Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_diandeng_dianliang_di01.png"
    speed_str_with_color = "<color=#249bc5>%s</color>"
    icon_bg_color = "98C6E080"
  else
    bg_path = "Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_diandeng_dianliang_di02.png"
    speed_str_with_color = "<color=#fd7156>%s</color>"
    icon_bg_color = "F4BD7A80"
  end
  self.title:SetText("")
  self.bg:LoadSprite(bg_path)
  self.icon_bg:SetColorHex(icon_bg_color)
  if data_type == 1 then
    self.icon:SetActive(true)
    self.player_head:SetActive(false)
    local cfg = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(data.itemId, 1)
    if cfg ~= nil then
      self.speed:SetText(string.format(speed_str_with_color, UIUtil.GetMinuteSpeedStr(toInt(cfg.para1) * 60)))
      self.title:SetText(Localization:GetString(cfg.name))
      self.desc:SetText(Localization:GetString(cfg.des))
      self.icon:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_diandeng_fadianji01.png")
    else
      self.speed:SetText(string.format(speed_str_with_color, UIUtil.GetMinuteSpeedStr(0)))
      self.title:SetText("")
      self.desc:SetText(Localization:GetString("season_s4_building_ui_info08"))
      self.icon:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_diandeng_fadianji01.png")
    end
  elseif data_type == 2 then
    self.speed:SetText(string.format(speed_str_with_color, UIUtil.GetMinuteSpeedStr(toInt(data) * 60)))
    self.icon:SetActive(true)
    self.player_head:SetActive(false)
    local cfg = DataCenter.AllianceMineManager:GetAllianceMineTemplate(400000)
    if cfg == nil then
      self.title:SetText(Localization:GetString("season_s3_alliance_center_name01"))
      self.desc:SetText("")
      self.icon:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_diandeng_dianchi_05.png")
    else
      self.title:SetText(Localization:GetString(cfg.name))
      self.desc:SetText("")
      self.icon:LoadSprite(cfg:GetIconPath())
    end
  elseif data_type == 3 then
    local otherWorkerNum = toInt(data.otherWorkerNum)
    local cfg = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.LW_BUILD_SEASON4_POWER_STATION1, 1)
    if cfg ~= nil then
      self.speed:SetText(string.format(speed_str_with_color, UIUtil.GetMinuteSpeedStr(toInt(cfg.para1) * 60 * otherWorkerNum)))
    else
      self.speed:SetText(string.format(speed_str_with_color, UIUtil.GetMinuteSpeedStr(0)))
    end
    self.title:SetText(Localization:GetString("season_s4_building_ui_info16"))
    self.desc:SetText(Localization:GetString("season_s4_building_ui_info17", otherWorkerNum))
    self.icon:SetActive(true)
    self.player_head:SetActive(false)
    self.icon:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_diandeng_diangong_02.png")
  elseif data_type == 4 then
    local level = toInt(data.lv)
    local brightnessLevel = toInt(data.brightnessLevel)
    local cfg = LocalController:instance():getLine(TableName.LW_LIGHTS_ON_S4, brightnessLevel)
    local buff_add = DataCenter.SeasonLightDataManager:GetBloodyNightElectricityUseBuff()
    if cfg and cfg.electricity_use ~= nil then
      self.speed:SetText(string.format(speed_str_with_color, UIUtil.GetMinuteSpeedStr((toInt(cfg.electricity_use) + buff_add) * -60)))
    else
      self.speed:SetText(string.format(speed_str_with_color, UIUtil.GetMinuteSpeedStr(0)))
    end
    cfg = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.LW_BUILD_SEASON4_LIGHTHOUSE, level)
    if cfg ~= nil then
      self.title:SetText(Localization:GetString(cfg.name))
      self.desc:SetText(Localization:GetString(cfg.des))
    end
    self.icon:SetActive(true)
    self.player_head:SetActive(false)
    self.icon:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_diandeng_dengta_03.png")
  elseif data_type == 5 then
    self.speed:SetText("")
    local userInfo = data.userInfo
    if userInfo then
      self.title:SetText(UIUtil.FormatServerAllianceName(userInfo.serverId, userInfo.abbr, userInfo.name))
    else
      self.title:SetText("")
    end
    self.desc:SetText(Localization:GetString("season_s4_building_ui_info18"))
    self.icon:SetActive(false)
    self.player_head:SetActive(true)
    self.player_head:ParseHeadInfo(userInfo)
  elseif data_type == 6 then
    self.speed:SetText("")
    self.title:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(data.time or data.stateUpdateTime))
    self.desc:SetText(Localization:GetString("season_s4_building_ui_info19"))
    self.icon:SetActive(true)
    self.player_head:SetActive(false)
    self.icon:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_diandeng_diangong_02.png")
  end
end

return UILWPowerSourceItem
