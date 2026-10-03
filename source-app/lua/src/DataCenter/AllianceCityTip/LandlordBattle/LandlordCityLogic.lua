local base = require("DataCenter.AllianceCityTip.AllianceCityTipBaseClass")
local LandlordCityLogic = BaseClass("LandlordCityLogic", base)
local LandlordCityOccupy = require("DataCenter.AllianceCityTip.LandlordBattle.LandlordCityOccupy")

function LandlordCityLogic:__init(gameObject)
  base.__init(self, gameObject)
  self:OnAddListener()
end

function LandlordCityLogic:__delete()
  if self.occupyRoot then
    self.occupyRoot:Delete()
    self.occupyRoot = nil
  end
  self:OnRemoveListener()
  base.__delete(self)
end

function LandlordCityLogic:OnAddListener()
  if not self.CityPointInfoUpdate then
    function self.CityPointInfoUpdate(pointIndex)
      if self.data then
        local pointInfo = self.data:GetPointInfo()
        
        if pointInfo and pointInfo.pointIndex == pointIndex then
          self:OnPointDateUpdate()
        end
      end
    end
    
    EventManager:GetInstance():AddListener(EventId.LandlordCityPointChangeClientState, self.CityPointInfoUpdate)
  end
end

function LandlordCityLogic:OnRemoveListener()
  if self.CityPointInfoUpdate then
    EventManager:GetInstance():RemoveListener(EventId.LandlordCityPointChangeClientState, self.CityPointInfoUpdate)
    self.CityPointInfoUpdate = nil
  end
end

function LandlordCityLogic:OnPointDateUpdate()
  base.UpdateCityInfo(self)
  self:DoRefresh()
end

function LandlordCityLogic:OnWorldAllianceCityDetail()
  base.UpdateCityInfo(self)
  self:DoRefresh()
end

function LandlordCityLogic:SetLod(lod)
  base.SetLod(self, lod)
  if self.occupyRoot then
    self.occupyRoot:SetLod(lod)
  end
end

function LandlordCityLogic:CheckLod(lod)
  base.CheckLod(self, lod)
  if self.occupyRoot then
    self.occupyRoot:SetLod(lod)
  end
end

function LandlordCityLogic:OnBattleFinish()
  if self.occupyRoot then
    self.occupyRoot:Delete()
    self.occupyRoot = nil
  end
end

function LandlordCityLogic:DoRefresh()
  self:RefreshBattleState()
end

function LandlordCityLogic:RefreshBattleState()
  local info = self.data:GetPointInfo()
  if info then
    if info.curClientState == LLConst.LLBuildingState.Exploding then
      self:OnBattleFinish()
      return
    end
    if self.occupyRoot == nil then
      self.occupyRoot = LandlordCityOccupy.New(self.transform)
    end
    self.occupyRoot:ReInit(self.data)
  end
end

return LandlordCityLogic
