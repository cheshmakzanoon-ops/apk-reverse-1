local base = UIBaseContainer
local LWUIZoneMobilizationPersonalRankItemRender = BaseClass("LWUIZoneMobilizationPersonalRankItemRender", base)
local rankBg_path = "RankBg"
local topThreeIcon_path = "TopThreeIcon"
local topThreeText_path = "TopThreeIcon/TopThreeText"
local rankText_path = "RankText"
local playerHeadObj_path = "UIPlayerHead"
local rImage_path = "RImage"
local nameText_path = "NameText"
local scoreText_path = "ScoreText"

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
  self.topThreeIcon = self:AddComponent(UIImage, topThreeIcon_path)
  self.topThreeText = self:AddComponent(UIText, topThreeText_path)
  self.rankText = self:AddComponent(UIText, rankText_path)
  self.playerHeadObj = self:AddComponent(UIBaseContainer, playerHeadObj_path)
  self.rImage = self:AddComponent(UIImage, rImage_path)
  self.nameText = self:AddComponent(UIText, nameText_path)
  self.scoreText = self:AddComponent(UIText, scoreText_path)
  self.playerHeadItemView = self:AddComponent(UICommonHead, playerHeadObj_path)
end

local function ComponentDestroy(self)
  self.rankBg = nil
  self.topThreeIcon = nil
  self.topThreeText = nil
  self.rankText = nil
  self.playerHeadObj = nil
  self.rImage = nil
  self.nameText = nil
  self.scoreText = nil
  self.playerHeadItemView = nil
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
  local isTopThree = self.rankData.rank > 0 and self.rankData.rank <= 3
  local isSelf = self.rankData.uid == LuaEntry.Player.uid
  self.topThreeIcon:SetActive(isTopThree)
  self.rankText:SetActive(not isTopThree)
  if isTopThree then
    self.topThreeIcon:LoadSprite(string.format(LoadPath.LWCommonPath, string.format("FX_wordboss_paihangbang_icon_huizhang0%s", self.rankData.rank)))
    self.topThreeText:SetText(self.rankData.rank)
  elseif self.rankData.rank == 0 then
    self.rankText:SetLocalText("zone_mobilization_unlisted")
  else
    self.rankText:SetText(self.rankData.rank)
  end
  if isSelf then
    self.rankBg:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_5.png")
  elseif isTopThree then
    self.rankBg:LoadSprite(string.format("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_%s.png", self.rankData.rank))
  else
    self.rankBg:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_4.png")
  end
  self.playerHeadItemView:SetData(self.rankData.uid, self.rankData.pic, self.rankData.picVer, nil, self.rankData:GetHeadBgImg())
  self.rImage:LoadSprite(LWAlMemberRankParam[self.rankData.memberR].Icon)
  self.nameText:SetText(self.rankData.name)
  self.scoreText:SetText(self.rankData.score)
end

LWUIZoneMobilizationPersonalRankItemRender.OnCreate = OnCreate
LWUIZoneMobilizationPersonalRankItemRender.OnDestroy = OnDestroy
LWUIZoneMobilizationPersonalRankItemRender.OnEnable = OnEnable
LWUIZoneMobilizationPersonalRankItemRender.OnDisable = OnDisable
LWUIZoneMobilizationPersonalRankItemRender.ComponentDefine = ComponentDefine
LWUIZoneMobilizationPersonalRankItemRender.ComponentDestroy = ComponentDestroy
LWUIZoneMobilizationPersonalRankItemRender.DataDefine = DataDefine
LWUIZoneMobilizationPersonalRankItemRender.DataDestroy = DataDestroy
LWUIZoneMobilizationPersonalRankItemRender.InitData = InitData
return LWUIZoneMobilizationPersonalRankItemRender
