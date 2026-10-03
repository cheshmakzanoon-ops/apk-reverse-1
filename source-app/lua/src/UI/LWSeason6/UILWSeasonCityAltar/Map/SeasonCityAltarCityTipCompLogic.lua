local base = require("DataCenter.AllianceCityTip.AllianceCityTipBaseClass")
local SeasonCityAltarCityTipCompLogic = BaseClass("SeasonCityAltarCityTipCompLogic", base)

function SeasonCityAltarCityTipCompLogic:__init(gameObject)
  base.__init(self, gameObject)
  self.compHud = nil
end

function SeasonCityAltarCityTipCompLogic:__delete()
  if self.compHud then
    self.compHud:Delete()
    self.compHud = nil
  end
  base.__delete(self)
end

function SeasonCityAltarCityTipCompLogic:OnKingOccupyProgressRefresh()
end

function SeasonCityAltarCityTipCompLogic:OnProtectTimeUpdate()
  if self:IsTypeValid() then
    base.UpdateCityInfo(self)
    self:UpdateUi()
  end
end

function SeasonCityAltarCityTipCompLogic:OnPointDateUpdate()
  if self:IsTypeValid() then
    base.UpdateCityInfo(self)
    self:UpdateUi()
  end
end

function SeasonCityAltarCityTipCompLogic:OnWorldAllianceCityDetail()
  if self:IsTypeValid() then
    base.UpdateCityInfo(self)
    self:UpdateUi()
  end
end

function SeasonCityAltarCityTipCompLogic:SetLod(lod)
  base.SetLod(self, lod)
  if self:IsTypeValid() and self.compHud then
    self.compHud:SetLod(lod)
  end
end

function SeasonCityAltarCityTipCompLogic:CheckLod(lod)
  base.CheckLod(self, lod)
  if self:IsTypeValid() and self.compHud then
    self.compHud:SetLod(lod)
  end
end

function SeasonCityAltarCityTipCompLogic:ReInit(data)
  base.ReInit(self, data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function SeasonCityAltarCityTipCompLogic:InitData(data)
  if data ~= nil then
    self.Data = data
    return true
  end
  return false
end

function SeasonCityAltarCityTipCompLogic:InitUi()
end

function SeasonCityAltarCityTipCompLogic:UpdateData()
  return true
end

function SeasonCityAltarCityTipCompLogic:BelongNobody()
  if self.compHud then
    self.compHud:Delete()
    self.compHud = nil
  end
end

function SeasonCityAltarCityTipCompLogic:UpdateUi()
  if not self:IsTypeValid() then
    self:BelongNobody()
    return
  end
  if self.theExtraInfo == nil or self.thePointInfo == nil then
    self:BelongNobody()
    return
  end
  self.AltarData = DataCenter.SeasonCityAltarManager:GetPointData(self.theExtraInfo, self.thePointInfo.serverId)
  if self.AltarData ~= nil then
    local timeState, _ = self.AltarData:GetTimeState()
    if timeState == AllianceCityShowTimeState.AltarBattle then
      if self.compHud == nil then
        local SeasonCityAltarCityTipComp = require("UI.LWSeason6.UILWSeasonCityAltar.Map.SeasonCityAltarCityTipComp")
        self.compHud = SeasonCityAltarCityTipComp.New(self.transform, self.serverId)
      end
      self.compHud:ReInit(self.data, self.AltarData)
      return
    end
  end
  self:BelongNobody()
end

function SeasonCityAltarCityTipCompLogic:IsTypeValid()
  if self.cityType == nil then
    return false
  end
  return self.cityType == WorldAllianceCityType.Altar
end

return SeasonCityAltarCityTipCompLogic
