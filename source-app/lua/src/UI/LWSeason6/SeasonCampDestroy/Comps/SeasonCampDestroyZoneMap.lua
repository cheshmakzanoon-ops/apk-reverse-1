local base = UIAsyncContainer
local SeasonCampDestroyZoneMap = BaseClass("SeasonCampDestroyZoneMap", base)
local Localization = CS.GameEntry.Localization
local MID_INDEX = 5
local SeasonCampDestroyZoneMapIR = require("UI.LWSeason6.SeasonCampDestroy.Comps.SeasonCampDestroyZoneMapIR")

function SeasonCampDestroyZoneMap:OnCreate(view)
  base.OnCreate(self)
  self.view = view
  self:DataDefine()
  self:ComponentDefine()
end

function SeasonCampDestroyZoneMap:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonCampDestroyZoneMap:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compSeasonCampDestroyZoneMap = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.compZone1 = self.viewSkin:AddComponent(self, SeasonCampDestroyZoneMapIR, 2)
  self.compMap = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.compZone2 = self.viewSkin:AddComponent(self, SeasonCampDestroyZoneMapIR, 4)
  self.compZone3 = self.viewSkin:AddComponent(self, SeasonCampDestroyZoneMapIR, 5)
  self.compZone4 = self.viewSkin:AddComponent(self, SeasonCampDestroyZoneMapIR, 6)
  self.compZone5 = self.viewSkin:AddComponent(self, SeasonCampDestroyZoneMapIR, 7)
  self.compZone6 = self.viewSkin:AddComponent(self, SeasonCampDestroyZoneMapIR, 8)
  self.compZone7 = self.viewSkin:AddComponent(self, SeasonCampDestroyZoneMapIR, 9)
  self.compZone8 = self.viewSkin:AddComponent(self, SeasonCampDestroyZoneMapIR, 10)
  self.compZone9 = self.viewSkin:AddComponent(self, SeasonCampDestroyZoneMapIR, 11)
  self.compZoneSelection = self.viewSkin:AddComponent(self, UIBaseComponent, 12)
  self:InitZoneMap()
  self.zones = {
    self.compZone1,
    self.compZone2,
    self.compZone3,
    self.compZone4,
    self.compZone5,
    self.compZone6,
    self.compZone7,
    self.compZone8,
    self.compZone9
  }
  self.serverMode = nil
  self:InitZones()
  self:SetOffsetMinXY(0, 0)
  self:SetOffsetMaxXY(0, 0)
  if self.compZoneSelection then
    self.compZoneSelection:SetActive(false)
  end
  self:RefreshServerMode()
  self:RefreshZones()
end

function SeasonCampDestroyZoneMap:ComponentDestroy()
  self.viewSkin = nil
  self.compSeasonCampDestroyZoneMap = nil
  self.compZone1 = nil
  self.compMap = nil
  self.compZone2 = nil
  self.compZone3 = nil
  self.compZone4 = nil
  self.compZone5 = nil
  self.compZone6 = nil
  self.compZone7 = nil
  self.compZone8 = nil
  self.compZone9 = nil
  self.compZoneSelection = nil
  self.zoneColors = nil
end

function SeasonCampDestroyZoneMap:InitZones()
  for k, v in ipairs(self.zones) do
    v:Init(self, k)
  end
end

function SeasonCampDestroyZoneMap:ChangeMode(serverMode)
  if self.serverMode == serverMode then
    return
  end
  self.serverMode = serverMode
  for k, v in ipairs(self.zones) do
    v:ChangeMode(serverMode)
  end
end

function SeasonCampDestroyZoneMap:DataDefine()
  self.mgr = DataCenter.SeasonCampDestroyManager
  self.selectedZoneIndex = 0
end

function SeasonCampDestroyZoneMap:OnZoneClick(index)
  local zoneIR = self.zones[index]
  if not zoneIR or not zoneIR.serverInfo then
    return
  end
  self.selectedZoneIndex = index
  if self.view and self.view.OnZoneClick then
    self.view:OnZoneClick(index)
  end
  UIUtil.OpenAuto(UIWindowNames.SeasonCampDestroyZoneDetail, zoneIR.serverInfo)
end

function SeasonCampDestroyZoneMap:DataDestroy()
  self.zones = nil
  self.mgr = nil
  self.view = nil
  self.maps = nil
end

function SeasonCampDestroyZoneMap:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.WorldCityOwnerInfoChanged, self.OnWorldCityOwnerInfoChanged)
end

function SeasonCampDestroyZoneMap:OnRemoveListener()
  self:RemoveUIListener(EventId.WorldCityOwnerInfoChanged, self.OnWorldCityOwnerInfoChanged)
  base.OnRemoveListener(self)
end

function SeasonCampDestroyZoneMap:RefreshZones()
  if not self.mgr then
    return
  end
  for k, v in ipairs(self.zones) do
    local idx = k
    local info = self.mgr:GetServerInfoByIndex(idx)
    if info then
      v:Refresh(info)
      v:SetActive(true)
    else
      v:SetActive(false)
    end
  end
end

function SeasonCampDestroyZoneMap:Refresh()
  self:RefreshServerMode()
  self:RefreshZones()
end

function SeasonCampDestroyZoneMap:RefreshServerMode()
  local serverMode = self.view and self.view:IsServerMode()
  self:ChangeMode(serverMode)
end

local function _getCampColor()
  local _1 = LuaEntry.DataConfig:TryGetStr("season6_map_zone_mode", "k3", "")
  local _2 = LuaEntry.DataConfig:TryGetStr("season6_map_zone_mode", "k4", "")
  local _array1 = string.split_ss_array(_1, ";")
  local _array2 = string.split_ss_array(_2, ";")
  local camp1Color = _array1 and _array1[2] or "92E37C"
  local camp2Color = _array2 and _array2[2] or "5EC1FD"
  return UIUtil.HexToColor(camp1Color), UIUtil.HexToColor(camp2Color)
end

function SeasonCampDestroyZoneMap:InitZoneMap()
  self.maps = {}
  local camp1Color, camp2Color = _getCampColor()
  self.zoneColors = {
    UIUtil.HexToColor("005B60"),
    camp1Color,
    camp2Color
  }
  local city2map = DataCenter.SeasonCampDestroyManager:GetCity2Map()
  if not city2map then
    return
  end
  for k, v in pairs(city2map) do
    local tab = self.maps[v]
    if not tab then
      tab = {}
      self.maps[v] = tab
    end
    table.insert(tab, k)
  end
  for k, v in pairs(self.maps) do
    table.sort(v)
  end
end

function SeasonCampDestroyZoneMap:GetCityIdsArray(mapIndex)
  return self.maps and self.maps[mapIndex]
end

function SeasonCampDestroyZoneMap:OnWorldCityOwnerInfoChanged()
  self:RefreshZones()
end

return SeasonCampDestroyZoneMap
