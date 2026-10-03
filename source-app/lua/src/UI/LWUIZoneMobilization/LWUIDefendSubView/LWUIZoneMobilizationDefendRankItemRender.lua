local base = UIBaseContainer
local LWUIZoneMobilizationDefendRankItemRender = BaseClass("LWUIZoneMobilizationDefendRankItemRender", base)
local rankBg_path = "RankBg"
local rankIcon_path = "RankIcon"
local rankText_path = "RankIcon/RankText"
local allianceFlag_path = "AllianceFlag"
local allianceNameText_path = "AllianceNameText"
local damageProgressSlider_path = "DamageProgressSlider"
local damageValueText_path = "DamageProgressSlider/DamageValueText"

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
  self.rankIcon = self:AddComponent(UIImage, rankIcon_path)
  self.rankText = self:AddComponent(UIText, rankText_path)
  self.allianceFlag = self:AddComponent(UIImage, allianceFlag_path)
  self.allianceNameText = self:AddComponent(UIText, allianceNameText_path)
  self.damageProgressSlider = self:AddComponent(UISlider, damageProgressSlider_path)
  self.damageValueText = self:AddComponent(UIText, damageValueText_path)
end

local function ComponentDestroy(self)
  self.rankBg = nil
  self.rankIcon = nil
  self.rankText = nil
  self.allianceFlag = nil
  self.allianceNameText = nil
  self.damageProgressSlider = nil
  self.damageValueText = nil
end

local function DataDefine(self)
  self.rankData = nil
end

local function DataDestroy(self)
  self.rankData = nil
end

local function InitData(self, index, data, maxScore)
  self.rankData = data
  local rankIconPath = ""
  local rankBgPath = ""
  local textColor = ""
  self.rankText:SetText(self.rankData.rank)
  if index == 1 then
    rankIconPath = string.format(LoadPath.LWCommonPath, "FX_wordboss_paihangbang_icon_huizhang01")
    rankBgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_1.png"
    textColor = "#ab6100"
  elseif index == 2 then
    rankIconPath = string.format(LoadPath.LWCommonPath, "FX_wordboss_paihangbang_icon_huizhang02")
    rankBgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_2.png"
    textColor = "#3d4d9b"
  elseif index == 3 then
    rankIconPath = string.format(LoadPath.LWCommonPath, "FX_wordboss_paihangbang_icon_huizhang03")
    rankBgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_3.png"
    textColor = "#90624d"
  end
  self.rankBg:LoadSprite(rankBgPath)
  self.rankIcon:LoadSprite(rankIconPath)
  self.allianceFlag:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(self.rankData.icon)))
  self.allianceNameText:SetText("<color=" .. textColor .. ">" .. "[" .. self.rankData.abbr .. "]" .. " " .. self.rankData.allianceName .. "</color>")
  self.damageValueText:SetText(self.rankData.score)
  local progress = Mathf.Clamp01(self.rankData.score / maxScore)
  self.damageProgressSlider:SetValue(progress)
end

LWUIZoneMobilizationDefendRankItemRender.OnCreate = OnCreate
LWUIZoneMobilizationDefendRankItemRender.OnDestroy = OnDestroy
LWUIZoneMobilizationDefendRankItemRender.OnEnable = OnEnable
LWUIZoneMobilizationDefendRankItemRender.OnDisable = OnDisable
LWUIZoneMobilizationDefendRankItemRender.ComponentDefine = ComponentDefine
LWUIZoneMobilizationDefendRankItemRender.ComponentDestroy = ComponentDestroy
LWUIZoneMobilizationDefendRankItemRender.DataDefine = DataDefine
LWUIZoneMobilizationDefendRankItemRender.DataDestroy = DataDestroy
LWUIZoneMobilizationDefendRankItemRender.InitData = InitData
return LWUIZoneMobilizationDefendRankItemRender
