local LWEffectOverviewItemContent = BaseClass("LWEffectOverviewItemContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local LWEffectOverviewHeroDetailView = require("UI.LWEffectOverviewHeroDetail.View.LWEffectOverviewHeroDetailView")

function LWEffectOverviewItemContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWEffectOverviewItemContent:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWEffectOverviewItemContent:ComponentDefine()
  self.root = self:AddComponent(UIBaseContainer, "")
  self.name = self:AddComponent(UIText, "Content/name")
  self.value = self:AddComponent(UIText, "Content/value")
  self.detailBtn = self:AddComponent(UIButton, "detailBtn")
  self.detailBtn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function LWEffectOverviewItemContent:ComponentDestroy()
  self.root = nil
  self.name = nil
  self.value = nil
  self.detailBtn = nil
end

function LWEffectOverviewItemContent:DataDefine()
end

function LWEffectOverviewItemContent:DataDestroy()
end

function LWEffectOverviewItemContent:OnBtnClick()
  local param = LWEffectOverviewHeroDetailView.ParamDataClass.New()
  param.content = Localization:GetString("441001", 1)
  param.position = self.detailBtn:GetPosition()
  param.deltaY = 30
  param.data = self.data.cfg.id
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWEffectOverviewHeroDetail, {anim = false}, param)
end

function LWEffectOverviewItemContent:Refresh(data, type)
  self.data = data
  self.type = type
  self.name:SetText(self:GetNameByType())
  self.detailBtn:SetActive(false)
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

function LWEffectOverviewItemContent:GetNameByType()
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
  elseif type == EffectOverviewSourcePoint.DominatorRankLevel then
    name = Localization:GetString("overview_21")
  elseif type == EffectOverviewSourcePoint.DominatorTrainLevelLevel then
    name = Localization:GetString("overview_20")
  end
  return name
end

function LWEffectOverviewItemContent:GetIsopen()
end

function LWEffectOverviewItemContent:GetVal(type)
end

return LWEffectOverviewItemContent
