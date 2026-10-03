local ZoneItem = BaseClass("ZoneItem", UIBaseContainer)
local base = UIBaseContainer
local city_txt_path = "cityTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self.city_txt = self:AddComponent(UITextMeshProUGUIEx, city_txt_path)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

local function SetData(self, zoneId, zoneMeta, clickFunc)
  self.zoneId = zoneId
  self.zoneMeta = zoneMeta
  self.clickFunc = clickFunc
  local name = zoneMeta:GetName()
  local cityInfo = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(self.zoneId)
  if cityInfo then
    local occupyServerId = cityInfo.occupyServerId
    local mySourceServerId = LuaEntry.Player:GetCurServerId()
    if cityInfo.cityName ~= nil and cityInfo.cityName ~= "" then
      name = cityInfo.cityName
    end
    if cityInfo.abbr ~= nil and cityInfo.abbr ~= "" then
      if mySourceServerId == occupyServerId and LuaEntry.Player:AtHomeNow() then
        name = UIUtil.FormatAllianceAndName(cityInfo.abbr, name)
      else
        name = UIUtil.FormatServerAllianceName(occupyServerId, cityInfo.abbr, name)
      end
    end
  end
  self.city_txt:SetLocalText("alliance_announcement_3", name, zoneMeta.level)
end

local function OnBtnClick(self)
  if self.clickFunc then
    self.clickFunc(self.zoneId)
  end
end

ZoneItem.OnCreate = OnCreate
ZoneItem.SetData = SetData
ZoneItem.OnBtnClick = OnBtnClick
return ZoneItem
