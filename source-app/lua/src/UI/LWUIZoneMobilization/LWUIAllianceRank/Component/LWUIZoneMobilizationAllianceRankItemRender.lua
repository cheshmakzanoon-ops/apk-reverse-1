local base = UIBaseContainer
local LWUIZoneMobilizationAllianceRankItemRender = BaseClass("LWUIZoneMobilizationAllianceRankItemRender", base)
local appearAniName = "V_ui_LWUIZoneMobilizationAllianceRankItemRender_in"
local rankBg_path = "RankBg"
local rankText_path = "RankText"
local allianceFlag_path = "AllianceFlag"
local allianceNameText_path = "AllianceNameText"
local scoreText_path = "ScoreText"
local anim_path = ""

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
  self.rankBg = self:AddComponent(UIImage, rankBg_path)
  self.rankText = self:AddComponent(UIText, rankText_path)
  self.allianceFlag = self:AddComponent(UIImage, allianceFlag_path)
  self.allianceNameText = self:AddComponent(UIText, allianceNameText_path)
  self.scoreText = self:AddComponent(UIText, scoreText_path)
  self.anim = self:AddComponent(UIAnimator, anim_path)
end

local function ComponentDestroy(self)
  self.rankBg = nil
  self.rankText = nil
  self.allianceFlag = nil
  self.allianceNameText = nil
  self.scoreText = nil
  self.anim = nil
end

local function DataDefine(self)
  self.rankData = nil
end

local function DataDestroy(self)
  self.rankData = nil
end

local function InitData(self, data)
  self.rankData = data
  if self.rankData == nil then
    self:SetActive(false)
    return
  end
  local isSelfAlliance = self.rankData.uid == LuaEntry.Player.allianceId
  local rankName = isSelfAlliance and "ljq_tongyong_paihangbang_5.png" or "ljq_tongyong_paihangbang_4.png"
  self.rankBg:LoadSpriteAuto(string.format(LoadPath.CommonApsNewPath, rankName))
  if self.rankData.rank == 0 then
    self.rankText:SetLocalText("zone_mobilization_unlisted")
  else
    self.rankText:SetText(self.rankData.rank)
  end
  if not string.IsNullOrEmpty(self.rankData.abbr) then
    self.allianceNameText:SetText("[" .. self.rankData.abbr .. "]" .. self.rankData.allianceName)
  else
    self.allianceNameText:SetText(self.rankData.allianceName)
  end
  self.allianceFlag:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, tostring(self.rankData.icon)))
  self.scoreText:SetText(self.rankData.score)
end

local function PlayAni(self)
  self.anim:SetSpeed(1)
  self.anim:SampleAnimationAtTime(appearAniName, 0)
  self.anim:Play(appearAniName)
end

LWUIZoneMobilizationAllianceRankItemRender.OnCreate = OnCreate
LWUIZoneMobilizationAllianceRankItemRender.OnDestroy = OnDestroy
LWUIZoneMobilizationAllianceRankItemRender.OnEnable = OnEnable
LWUIZoneMobilizationAllianceRankItemRender.OnDisable = OnDisable
LWUIZoneMobilizationAllianceRankItemRender.ComponentDefine = ComponentDefine
LWUIZoneMobilizationAllianceRankItemRender.ComponentDestroy = ComponentDestroy
LWUIZoneMobilizationAllianceRankItemRender.DataDefine = DataDefine
LWUIZoneMobilizationAllianceRankItemRender.DataDestroy = DataDestroy
LWUIZoneMobilizationAllianceRankItemRender.InitData = InitData
LWUIZoneMobilizationAllianceRankItemRender.PlayAni = PlayAni
return LWUIZoneMobilizationAllianceRankItemRender
