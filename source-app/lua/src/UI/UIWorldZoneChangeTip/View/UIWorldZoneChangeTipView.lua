local UIWorldZoneChangeTipView = BaseClass("UIWorldZoneChangeTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIWorldZoneChangeTipView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:ReInit()
end

function UIWorldZoneChangeTipView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWorldZoneChangeTipView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.WorldZoneTipChanged, self.WorldZoneTipChanged)
end

function UIWorldZoneChangeTipView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.WorldZoneTipChanged, self.WorldZoneTipChanged)
end

function UIWorldZoneChangeTipView:WorldZoneTipChanged(zone)
  if zone == "0" then
    return
  end
  self:SetDataAndPlay(zone)
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIWorldZoneChangeTip)
  if window ~= nil then
    UIManager:GetInstance():PlayMoveInAnim(window)
  end
end

function UIWorldZoneChangeTipView:ComponentDefine()
  self.canvasGroup = self:AddComponent(UICanvasGroup, "safeArea/root")
  self.bg = self:AddComponent(UIBaseComponent, "safeArea/root/bg")
  self.snowBg = self:AddComponent(UIImage, "safeArea/root/snowBg")
  self.zoneName = self:AddComponent(UIText, "safeArea/root/bg/name")
  self.alliance = self:AddComponent(UIText, "safeArea/root/alliance")
  self.temp = self:AddComponent(UITextMeshProUGUIEx, "safeArea/root/snowBg/temp")
  self.cityLevel = self:AddComponent(UIText, "safeArea/root/cityLevel")
  self.cityBg = self:AddComponent(UIImage, "safeArea/root/cityBg")
end

function UIWorldZoneChangeTipView:ComponentDestroy()
  if not IsNull(self.sequence) then
    self.sequence:Kill()
    self.sequence = nil
  end
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  self.zoneName = nil
  self.alliance = nil
  self.cityLevel = nil
end

function UIWorldZoneChangeTipView:ReInit()
  self.zone = DataCenter.LWWorldZoneChangeTipManager.lastZone
  if string.IsNullOrEmpty(self.zone) then
    return
  end
  self:SetDataAndPlay(self.zone)
end

function UIWorldZoneChangeTipView:SetDataAndPlay(zone)
  if not IsNull(self.sequence) then
    self.sequence:Kill()
    self.sequence = nil
  end
  if IsNull(self.transform) then
    return
  end
  self.canvasGroup:SetAlpha(1)
  local curServerId = LuaEntry.Player:GetCurServerId()
  local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(zone, curServerId)
  local cityBgPath = "Assets/Main/Sprites/UI/UILWWorld/od_daditu_cityinfoflagbg.png"
  if cityMeta ~= nil and SeasonUtil.IsInSeasonSnowMode() and cityMeta.season_snow_scene_name then
    self.snowBg:SetActive(true)
    self.bg:SetActive(false)
    local temp = DataCenter.TemperatureManager:GetCityHeatSourceTemperature(zone)
    local tempStr = Localization:GetString(cityMeta.season_snow_scene_name) .. " " .. Localization:GetString("season_s2_common_temperature", temp)
    self.temp:SetText(tempStr)
    self.snowBg:LoadSprite(string.format("Assets/Main/Sprites/UI/UISeason/UISeason2/WorldPoint/%s.png", cityMeta.season_snow_scene_name))
    cityBgPath = "Assets/Main/Sprites/UI/UISeason/UISeason2/WorldPoint/mjc_s2_shijie_lv_bg01.png"
  else
    self.snowBg:SetActive(false)
    self.bg:SetActive(true)
    if cityMeta and cityMeta.type == WorldAllianceCityType.Stronghold then
      cityBgPath = "Assets/Main/Sprites/LodIcon/stronghold_level.png"
    end
  end
  self.cityBg:LoadSprite(cityBgPath)
  local nameKey = cityMeta and cityMeta.name
  local name = ""
  if not string.IsNullOrEmpty(nameKey) then
    name = Localization:GetString(nameKey)
  else
  end
  if CS.CommonUtils.IsDebug() then
    self.zoneName:SetText(string.format("#%s %s (id=%s)", curServerId, name, zone))
  else
    self.zoneName:SetText(string.format("#%s %s", curServerId, name))
  end
  self.cityLevel:SetLocalText("140002", tostring(cityMeta and cityMeta.level or 1))
  local cityInfo = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(tonumber(zone))
  local allianceStr
  if cityInfo ~= nil then
    local abbr = cityInfo.abbr
    local allianceName = cityInfo.allianceName
    if abbr ~= nil and allianceName ~= nil and abbr ~= "" and allianceName ~= "" then
      allianceStr = "[" .. abbr .. "] " .. allianceName
    end
  end
  self.alliance:SetText(allianceStr)
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.ctrl:CloseSelf()
  end, 3)
end

return UIWorldZoneChangeTipView
