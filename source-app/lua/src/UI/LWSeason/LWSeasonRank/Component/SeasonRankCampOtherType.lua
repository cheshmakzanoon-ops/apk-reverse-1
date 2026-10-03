local base = UIBaseContainer
local SeasonRankCampOtherType = BaseClass("SeasonRankCampOtherType", base)
local name1_path = "camp1/name1"
local rank1_path = "camp1/value1"
local name2_path = "camp2/name2"
local rank2_path = "camp2/value2"
local openAnimator_path = ""
local icon1_path = "camp1/name1/icon1"
local icon2_path = "camp2/name2/icon2"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.name1 = self:AddComponent(UIText, name1_path)
  self.rank1 = self:AddComponent(UIText, rank1_path)
  self.name2 = self:AddComponent(UIText, name2_path)
  self.rank2 = self:AddComponent(UIText, rank2_path)
  self.openAnimator = self:AddComponent(UIAnimator, openAnimator_path)
  self.icon1 = self:AddComponent(UIImage, icon1_path)
  self.icon2 = self:AddComponent(UIImage, icon2_path)
end

local function ComponentDestroy(self)
  self.red_diban = nil
  self.blue_diban = nil
  self.name1 = nil
  self.rank1 = nil
  self.name2 = nil
  self.rank2 = nil
  self.openAnimator = nil
  self.icon1 = nil
  self.icon2 = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SeasonRankCampOtherType:Refresh(data)
  local mgr = DataCenter.SeasonFactionWarDataManager
  self.rank1:SetText(string.GetFormattedSeparatorNum(data.campScore2))
  self.rank2:SetText(string.GetFormattedSeparatorNum(data.campScore1))
  self.name1:SetText(mgr:GetCampName(SeasonFactionType.Gendarmerie))
  self.name2:SetText(mgr:GetCampName(SeasonFactionType.Rebels))
  local myCampId = mgr.myCampId
  self.icon1:SetActive(myCampId == SeasonFactionType.Gendarmerie)
  self.icon2:SetActive(myCampId == SeasonFactionType.Rebels)
  self.red = data.campScore1 >= data.campScore2
  self:RefreshAnimation()
end

function SeasonRankCampOtherType:RefreshAnimation()
  if self.red then
    self.openAnimator:Play("V_CampRank_red_anim")
  else
    self.openAnimator:Play("V_CampRank_blue_anim")
  end
end

SeasonRankCampOtherType.OnCreate = OnCreate
SeasonRankCampOtherType.OnDestroy = OnDestroy
SeasonRankCampOtherType.OnEnable = OnEnable
SeasonRankCampOtherType.OnDisable = OnDisable
SeasonRankCampOtherType.ComponentDefine = ComponentDefine
SeasonRankCampOtherType.ComponentDestroy = ComponentDestroy
SeasonRankCampOtherType.DataDefine = DataDefine
SeasonRankCampOtherType.DataDestroy = DataDestroy
return SeasonRankCampOtherType
