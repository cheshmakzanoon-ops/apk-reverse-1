local base = require("DataCenter.AllianceCityTip.AllianceCityTipBaseClass")
local CityCannonLogic = BaseClass("CityCannonLogic", base)
local CityCannonCampBattle = require("DataCenter.AllianceCityTip.Season.CityCannonCampBattle")
local CityType = WorldAllianceCityType.Canon

function CityCannonLogic:__init(gameObject)
  base.__init(self, gameObject)
  self.campRoot = nil
end

function CityCannonLogic:__delete()
  if self.campRoot then
    self.campRoot:Delete()
    self.campRoot = nil
  end
  base.__delete(self)
end

function CityCannonLogic:OnPointDateUpdate()
  if self.cityType == CityType then
    base.UpdateCityInfo(self)
    self:DoRefresh()
  end
end

function CityCannonLogic:OnWorldAllianceCityDetail()
  if self.cityType == CityType then
    base.UpdateCityInfo(self)
    self:DoRefresh()
  end
end

function CityCannonLogic:SetLod(lod)
  base.SetLod(self, lod)
  if self.cityType == CityType and self.campRoot then
    self.campRoot:SetLod(lod)
  end
end

function CityCannonLogic:CheckLod(lod)
  base.CheckLod(self, lod)
  if self.cityType == CityType and self.campRoot then
    self.campRoot:SetLod(lod)
  end
end

function CityCannonLogic:ReInit(data)
  base.ReInit(self, data)
end

function CityCannonLogic:DoRefresh()
  if self.cityType ~= CityType then
    return
  end
  self:RefreshCamp()
end

function CityCannonLogic:OnPointOutView()
  base.OnPointOutView(self)
end

function CityCannonLogic:RefreshCamp()
  if not DataCenter.ZoneWarManager:IsCampBattle() then
    if self.campRoot then
      self.campRoot:Delete()
      self.campRoot = nil
    end
    return
  end
  if self.campRoot == nil then
    self.campRoot = CityCannonCampBattle.New(self.transform, self.serverId)
  end
  self.campRoot:ReInit(self.data, self.theExtraInfo)
end

return CityCannonLogic
