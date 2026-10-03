local base = UIBaseContainer
local LWUIRebirthHospitalHistoryItemComponent = BaseClass("LWUIRebirthHospitalHistoryItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUIRebirthHospitalHistoryItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIRebirthHospitalHistoryItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIRebirthHospitalHistoryItemComponent:ComponentDefine()
  self.textTime = self:AddComponent(UIText, "TimeImage/TimeText")
  self.textDead = self:AddComponent(UIText, "DetailContent/Dead/DeadText")
  self.compSoldier = self:AddComponent(UIBaseContainer, "DetailContent/Layout/Soldier")
  self.textSoldier = self:AddComponent(UIText, "DetailContent/Layout/Soldier/SoldierText")
  self.compUseless = self:AddComponent(UIBaseContainer, "DetailContent/Layout/Useless")
  self.textUseless = self:AddComponent(UIText, "DetailContent/Layout/Useless/UselessText")
end

function LWUIRebirthHospitalHistoryItemComponent:ComponentDestroy()
  self.textTime = nil
  self.textDead = nil
  self.compSoldier = nil
  self.textSoldier = nil
  self.compUseless = nil
  self.textUseless = nil
end

function LWUIRebirthHospitalHistoryItemComponent:DataDefine()
end

function LWUIRebirthHospitalHistoryItemComponent:DataDestroy()
end

function LWUIRebirthHospitalHistoryItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function LWUIRebirthHospitalHistoryItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIRebirthHospitalHistoryItemComponent:ReInit(data)
  if data == nil then
    return
  end
  self.textTime:SetText(UITimeManager:GetInstance():TimeStampToTimeForLocal(checknumber(data.recordTime)))
  self.textDead:SetText(tostring(data.totalDead))
  self.textSoldier:SetText(tostring(data.receive))
  local useless = checknumber(data.outDead)
  self.compUseless:SetActive(0 < useless)
  if 0 < useless then
    self.textUseless:SetText(tostring(useless))
  end
  local hideSoldier = 0 < useless and checknumber(data.receive) <= 0
  self.compSoldier:SetActive(not hideSoldier)
end

return LWUIRebirthHospitalHistoryItemComponent
