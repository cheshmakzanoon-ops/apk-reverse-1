local LWPowerOverviewCanFoldItemContent = BaseClass("LWPowerOverviewCanFoldItemContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function LWPowerOverviewCanFoldItemContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWPowerOverviewCanFoldItemContent:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWPowerOverviewCanFoldItemContent:ComponentDefine()
  self.root = self:AddComponent(UIBaseContainer, "")
  self.name = self:AddComponent(UIText, "Content/name")
  self.value = self:AddComponent(UIText, "Content/value")
end

function LWPowerOverviewCanFoldItemContent:ComponentDestroy()
  self.root = nil
  self.name = nil
  self.value = nil
end

function LWPowerOverviewCanFoldItemContent:DataDefine()
end

function LWPowerOverviewCanFoldItemContent:DataDestroy()
end

function LWPowerOverviewCanFoldItemContent:OnBtnClick()
end

function LWPowerOverviewCanFoldItemContent:Refresh(data, type)
  self.data = data
  self.type = type
  self.name:SetText(self:GetNameByType())
  local template = DataCenter.LWEffectOverviewManager:GetTemplate(self.data.id)
  if template then
    local effectValue = self.data:GetEffectValueDataByEffectSourceType(type)
    local effectIds = template:GetEffectIdListByEffectSourceType(type)
    if table.count(effectIds) > 0 then
      local describe, text = WorkerUtil.GetEffectText(effectIds[1], effectValue, true)
      self.value:SetText(text)
    else
      self.value:SetText(effectValue)
    end
  end
end

function LWPowerOverviewCanFoldItemContent:GetNameByType()
  local type = self.type
  local name = ""
  if type == EffectOverviewSourcePoint.Tech then
    name = Localization:GetString("110292")
  elseif type == EffectOverviewSourcePoint.Drone then
    name = Localization:GetString("overview_1")
  elseif type == EffectOverviewSourcePoint.HonorWall then
    name = Localization:GetString("overview_2")
  elseif type == EffectOverviewSourcePoint.Vip then
    name = Localization:GetString("overview_3")
  elseif type == EffectOverviewSourcePoint.Building then
    name = Localization:GetString("110291")
  elseif type == EffectOverviewSourcePoint.AllianceTech then
    name = Localization:GetString("110293")
  elseif type == EffectOverviewSourcePoint.OccupiedCity then
    name = Localization:GetString("overview_4")
  elseif type == EffectOverviewSourcePoint.ProfessionSpecialization then
    name = Localization:GetString("overview_5")
  elseif type == EffectOverviewSourcePoint.SeasonBuilding then
    name = Localization:GetString("overview_6")
  elseif type == EffectOverviewSourcePoint.SuperMonthCard then
    name = Localization:GetString("overview_7")
  elseif type == EffectOverviewSourcePoint.Survivor then
    name = Localization:GetString("overview_8")
  elseif type == EffectOverviewSourcePoint.Decoration then
    name = Localization:GetString("overview_9")
  elseif type == EffectOverviewSourcePoint.Offices then
    name = Localization:GetString("457025")
  elseif type == EffectOverviewSourcePoint.Equip then
    name = Localization:GetString("129024")
  elseif type == EffectOverviewSourcePoint.DominatorRankLevel then
    name = Localization:GetString("overview_21")
  elseif type == EffectOverviewSourcePoint.DominatorTrainLevel then
    name = Localization:GetString("overview_20")
  elseif type == EffectOverviewSourcePoint.TacticalCard then
    name = Localization:GetString("overview_battle_card")
  elseif type == EffectOverviewSourcePoint.Server then
    name = Localization:GetString("overview_24")
  elseif type == EffectOverviewSourcePoint.CampScience then
    name = Localization:GetString("season_camp_science_ui_3")
  end
  return name
end

return LWPowerOverviewCanFoldItemContent
