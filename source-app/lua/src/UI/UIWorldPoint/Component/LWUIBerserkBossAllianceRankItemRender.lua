local base = UIBaseContainer
local LWUIBerserkBossAllianceRankItemRender = BaseClass("LWUIBerserkBossAllianceRankItemRender", base)
local rankText_path = "RankText"
local progress_path = "Progress"
local progressText_path = "Progress/ProgressValueText"

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
  self.rankText = self:AddComponent(UIText, rankText_path)
  self.progress = self:AddComponent(UIImage, progress_path)
  self.progressText = self:AddComponent(UIText, progressText_path)
end

local function ComponentDestroy(self)
  self.rankText = nil
  self.progress = nil
  self.progressText = nil
end

local function DataDefine(self)
  self.oriHpBarSizeWidth = 250
  self.oriHpBarSizeHeight = 20
end

local function DataDestroy(self)
  self.oriHpBarSizeWidth = nil
  self.oriHpBarSizeHeight = nil
end

local function InitData(self, data, maxValue)
  self.rankData = data
  self.rankText:SetText(string.format("%s", self.rankData.rank) .. " " .. self.rankData.allianceAbbr)
  self.progressText:SetText(string.GetFormattedStr(self.rankData.score))
  local progress = Mathf.Clamp(self.rankData.score / maxValue, 0, 1)
  self.progress:SetSizeDeltaXY(progress * self.oriHpBarSizeWidth, self.oriHpBarSizeHeight)
  self.progress:LoadSprite(string.format(LoadPath.UILWBerserkBoss, self:GetRankBgSpriteName(self.rankData.rank)))
end

local function GetRankBgSpriteName(self, rank)
  if rank == 1 then
    return "FX_wordboss_bar_jindutiao_yellow"
  elseif rank == 2 then
    return "FX_wordboss_bar_jindutiao_lan"
  end
  return "FX_wordboss_bar_jindutiao_red"
end

LWUIBerserkBossAllianceRankItemRender.OnCreate = OnCreate
LWUIBerserkBossAllianceRankItemRender.OnDestroy = OnDestroy
LWUIBerserkBossAllianceRankItemRender.OnEnable = OnEnable
LWUIBerserkBossAllianceRankItemRender.OnDisable = OnDisable
LWUIBerserkBossAllianceRankItemRender.ComponentDefine = ComponentDefine
LWUIBerserkBossAllianceRankItemRender.ComponentDestroy = ComponentDestroy
LWUIBerserkBossAllianceRankItemRender.DataDefine = DataDefine
LWUIBerserkBossAllianceRankItemRender.DataDestroy = DataDestroy
LWUIBerserkBossAllianceRankItemRender.InitData = InitData
LWUIBerserkBossAllianceRankItemRender.GetRankBgSpriteName = GetRankBgSpriteName
return LWUIBerserkBossAllianceRankItemRender
