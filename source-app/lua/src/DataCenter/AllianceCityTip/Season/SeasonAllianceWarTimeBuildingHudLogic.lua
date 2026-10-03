local base = require("DataCenter.AllianceCityTip.AllianceCityTipBaseClass")
local SeasonAllianceWarTimeBuildingHudLogic = BaseClass("SeasonAllianceWarTimeBuildingHudLogic", base)

function SeasonAllianceWarTimeBuildingHudLogic:ComponentDefine()
end

function SeasonAllianceWarTimeBuildingHudLogic:ComponentDestroy()
end

function SeasonAllianceWarTimeBuildingHudLogic:DataDefine()
end

function SeasonAllianceWarTimeBuildingHudLogic:DataDestroy()
end

function SeasonAllianceWarTimeBuildingHudLogic:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonAllianceWarTimeBuildingHudLogic:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonAllianceWarTimeBuildingHudLogic:OnAddListener()
  base.OnAddListener(self)
end

function SeasonAllianceWarTimeBuildingHudLogic:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SeasonAllianceWarTimeBuildingHudLogic:__init(gameObject)
  base.__init(self, gameObject)
  self.compHud = nil
end

function SeasonAllianceWarTimeBuildingHudLogic:__delete()
  if self.compHud then
    self.compHud:Delete()
    self.compHud = nil
  end
  base.__delete(self)
end

function SeasonAllianceWarTimeBuildingHudLogic:OnKingOccupyProgressRefresh()
end

function SeasonAllianceWarTimeBuildingHudLogic:OnProtectTimeUpdate()
  if self:IsTypeValid() then
    base.UpdateCityInfo(self)
    self:UpdateUi()
  end
end

function SeasonAllianceWarTimeBuildingHudLogic:OnPointDateUpdate()
  if self:IsTypeValid() then
    base.UpdateCityInfo(self)
    self:UpdateUi()
  end
end

function SeasonAllianceWarTimeBuildingHudLogic:OnWorldAllianceCityDetail()
  if self:IsTypeValid() then
    base.UpdateCityInfo(self)
    self:UpdateUi()
  end
end

function SeasonAllianceWarTimeBuildingHudLogic:SetLod(lod)
  base.SetLod(self, lod)
  if self:IsTypeValid() and self.compHud then
    self.compHud:SetLod(lod)
  end
end

function SeasonAllianceWarTimeBuildingHudLogic:CheckLod(lod)
  base.CheckLod(self, lod)
  if self:IsTypeValid() and self.compHud then
    self.compHud:SetLod(lod)
  end
end

function SeasonAllianceWarTimeBuildingHudLogic:ReInit(data)
  base.ReInit(self, data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function SeasonAllianceWarTimeBuildingHudLogic:InitData(data)
  if data ~= nil then
    self.Data = data
    return true
  end
  return false
end

function SeasonAllianceWarTimeBuildingHudLogic:InitUi()
end

function SeasonAllianceWarTimeBuildingHudLogic:UpdateData()
  return true
end

function SeasonAllianceWarTimeBuildingHudLogic:BelongNobody()
  if self.compHud then
    self.compHud:Delete()
    self.compHud = nil
  end
end

function SeasonAllianceWarTimeBuildingHudLogic:UpdateUi()
  if not (self:IsTypeValid() and DataCenter.UILWSeasonAllianceWarTimeManager:IsFuncOpen(false)) or not DataCenter.UILWSeasonAllianceWarTimeManager:CanShowOnBuilding() then
    self:BelongNobody()
    return
  end
  if self.theExtraInfo == nil or string.IsNullOrEmpty(self.theExtraInfo.allianceId) then
    self:BelongNobody()
    return
  end
  if self.theExtraInfo.warTimeIndex == nil then
    self:BelongNobody()
    return
  end
  local openTime = 0
  local curTimeSeconds = UITimeManager:GetInstance():GetServerSeconds()
  openTime = math.max(openTime, checknumber(self.theExtraInfo.openTime))
  openTime = math.max(openTime, checknumber(self.theExtraInfo.protectTime))
  if curTimeSeconds > openTime then
    if self.compHud == nil then
      local theWarTimeBuildingHud = require("DataCenter.AllianceCityTip.Season.SeasonAllianceWarTimeBuildingHud")
      self.compHud = theWarTimeBuildingHud.New(self.transform, self.serverId)
    end
    self.compHud:ReInit(self.data, self.theExtraInfo)
  else
    self:BelongNobody()
  end
end

function SeasonAllianceWarTimeBuildingHudLogic:IsTypeValid()
  if self.cityType == nil then
    return false
  end
  return self.cityType == WorldAllianceCityType.City or self.cityType == WorldAllianceCityType.Stronghold
end

return SeasonAllianceWarTimeBuildingHudLogic
