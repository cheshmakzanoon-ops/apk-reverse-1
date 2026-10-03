local base = UIBaseContainer
local SeasonRankCamp = BaseClass("SeasonRankCamp", base)
local name1_path = "camp1/name1"
local rank1_path = "camp1/value1"
local name2_path = "camp2/name2"
local rank2_path = "camp2/value2"
local crown1_path = "camp1/huangguan1"
local crown2_path = "camp2/huangguan2"
local openAnimator_path = ""
local icon1_path = "camp1/name1/icon1"
local icon2_path = "camp2/name2/icon2"
local red_icon_path = "camp1/red_icon"
local blue_icon_path = "camp2/blue_icon"
local red_diban_path = "GameObject/node_diban/red_diban"
local blue_diban_path = "GameObject/node_diban/blue_diban"

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
  self.red_diban = self:AddComponent(UIRawImage, red_diban_path)
  self.blue_diban = self:AddComponent(UIRawImage, blue_diban_path)
  self.name1 = self:AddComponent(UIText, name1_path)
  self.rank1 = self:AddComponent(UIText, rank1_path)
  self.name2 = self:AddComponent(UIText, name2_path)
  self.rank2 = self:AddComponent(UIText, rank2_path)
  self.crown1 = self:AddComponent(UIImage, crown1_path)
  self.crown2 = self:AddComponent(UIImage, crown2_path)
  self.openAnimator = self:AddComponent(UIAnimator, openAnimator_path)
  self.icon1 = self:AddComponent(UIImage, icon1_path)
  self.icon2 = self:AddComponent(UIImage, icon2_path)
  self.red_icon = self:AddComponent(UIImage, red_icon_path)
  self.blue_icon = self:AddComponent(UIImage, blue_icon_path)
end

local function ComponentDestroy(self)
  self.red_diban = nil
  self.blue_diban = nil
  self.name1 = nil
  self.rank1 = nil
  self.name2 = nil
  self.rank2 = nil
  self.crown1 = nil
  self.crown2 = nil
  self.openAnimator = nil
  self.icon1 = nil
  self.icon2 = nil
  self.red_icon = nil
  self.blue_icon = nil
end

local function DataDefine(self)
  local seasonType = SeasonUtil.GetSeasonType()
  if seasonType == SeasonMapType.Mummy then
    self.red_diban:LoadSprite("Assets/Main/SeasonRes/S3/Textures/FactionSelection/wxy_s3_zhenying_diban_01_hong.png")
    self.blue_diban:LoadSprite("Assets/Main/SeasonRes/S3/Textures/FactionSelection/wxy_s3_zhenying_diban_01_lan.png")
    self.crown1:LoadSprite("Assets/Main/SeasonRes/S3/Sprites/UI/LWCommon/wxy_s3_zhenying_huangguan.png")
    self.crown2:LoadSprite("Assets/Main/SeasonRes/S3/Sprites/UI/LWCommon/wxy_s3_zhenying_huangguan.png")
  elseif seasonType == SeasonMapType.Snow then
    self.red_diban:LoadSprite("Assets/Main/TextureEx/Season/S2/SeasonRank/ljq_s2_zhenying_diban_red.png")
    self.blue_diban:LoadSprite("Assets/Main/TextureEx/Season/S2/SeasonRank/ljq_s2_zhenying_diban_blue.png")
    self.crown1:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/ljq_suanshudashi_huangguan.png")
    self.crown2:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/ljq_suanshudashi_huangguan.png")
  end
end

local function DataDestroy(self)
end

function SeasonRankCamp:Refresh(data)
  local mgr = DataCenter.SeasonFactionWarDataManager
  self.rank1:SetText(string.GetFormattedSeparatorNum(data.campScore1))
  self.rank2:SetText(string.GetFormattedSeparatorNum(data.campScore2))
  self.name1:SetText(mgr:GetCampName(SeasonFactionType.Rebels))
  self.name2:SetText(mgr:GetCampName(SeasonFactionType.Gendarmerie))
  self.crown1:SetActive(data.campScore1 > data.campScore2)
  self.crown2:SetActive(data.campScore1 < data.campScore2)
  self.red = data.campScore1 >= data.campScore2
  local myCampId = mgr.myCampId
  self.icon1:SetActive(myCampId == SeasonFactionType.Rebels)
  self.icon2:SetActive(myCampId == SeasonFactionType.Gendarmerie)
  self.red_icon:LoadSprite(mgr:GetCampIcon(1, true))
  self.blue_icon:LoadSprite(mgr:GetCampIcon(2, true))
  self:RefreshAnimation()
end

function SeasonRankCamp:RefreshAnimation()
  if self.red then
    self.openAnimator:Play("V_CampRank_red_anim")
  else
    self.openAnimator:Play("V_CampRank_blue_anim")
  end
end

SeasonRankCamp.OnCreate = OnCreate
SeasonRankCamp.OnDestroy = OnDestroy
SeasonRankCamp.OnEnable = OnEnable
SeasonRankCamp.OnDisable = OnDisable
SeasonRankCamp.ComponentDefine = ComponentDefine
SeasonRankCamp.ComponentDestroy = ComponentDestroy
SeasonRankCamp.DataDefine = DataDefine
SeasonRankCamp.DataDestroy = DataDestroy
return SeasonRankCamp
