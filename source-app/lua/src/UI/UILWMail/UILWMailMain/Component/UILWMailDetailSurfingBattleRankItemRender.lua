local base = UIBaseContainer
local UILWMailDetailSurfingBattleRankItemRender = BaseClass("UILWMailDetailSurfingBattleRankItemRender", base)
local Localization = CS.GameEntry.Localization
local bg_path = "bg"
local headItem_path = "HeadNode/head"
local rankText_path = "RankText"
local nameText_path = "NameText"
local scoreText_path = "ScoreText"
local rankIcon1_path = "RankIcon1"
local rankIcon2_path = "RankIcon2"
local rankIcon3_path = "RankIcon3"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.headItem = self:AddComponent(UIBaseContainer, headItem_path)
  self.rankText = self:AddComponent(UITextMeshProUGUIEx, rankText_path)
  self.nameText = self:AddComponent(UITextMeshProUGUIEx, nameText_path)
  self.scoreText = self:AddComponent(UITextMeshProUGUIEx, scoreText_path)
  self.rankIcon1 = self:AddComponent(UIBaseContainer, rankIcon1_path)
  self.rankIcon2 = self:AddComponent(UIBaseContainer, rankIcon2_path)
  self.rankIcon3 = self:AddComponent(UIBaseContainer, rankIcon3_path)
  self.player_head = self:AddComponent(UICommonHead, headItem_path)
end

local function ComponentDestroy(self)
  self.bg = nil
  self.headItem = nil
  self.rankText = nil
  self.nameText = nil
  self.scoreText = nil
  self.rankIcon1 = nil
  self.rankIcon2 = nil
  self.rankIcon3 = nil
  self.player_head = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, data, rankType)
  self.data = data
  self.rankText:SetText(tostring(data.rank))
  self.rankIcon1:SetActive(data.rank == 1)
  self.rankIcon2:SetActive(data.rank == 2)
  self.rankIcon3:SetActive(data.rank == 3)
  self.player_head:SetHeadAndFrame(data.uid, data.headPic, data.headPicVer, nil, data.headSkinId, data.headSkinET)
  local power_color = "#2a2830"
  local name_color = "#2a2830"
  local score_color = "#6d82ad"
  local bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_huisetiao"
  if data.uid == LuaEntry.Player.uid then
    power_color = "#4a9327"
    name_color = "#4a9327"
    score_color = "#14a91b"
    bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_lvsetiao"
  elseif data.rank == 1 then
    power_color = "#d07b0c"
    name_color = "#d07b0c"
    score_color = "#b78026"
    bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_jinsetiao"
  elseif data.rank == 2 then
    power_color = "#6674ba"
    name_color = "#6674ba"
    score_color = "#5065cb"
    bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_yinsetiao"
  elseif data.rank == 3 then
    power_color = "#b77758"
    name_color = "#b77758"
    score_color = "#ba6744"
    bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_tongsetiao"
  end
  self.bg:LoadSprite(bgPath)
  self.nameText:SetText("<color=" .. name_color .. ">" .. data.name .. "</color>")
  local score = data.score
  if rankType == 3 then
    score = UITimeManager:GetInstance():GetCompetitionTimeFormat(data.score)
  end
  self.scoreText:SetText("<color=" .. score_color .. ">" .. score .. "</color>")
end

UILWMailDetailSurfingBattleRankItemRender.OnCreate = OnCreate
UILWMailDetailSurfingBattleRankItemRender.OnDestroy = OnDestroy
UILWMailDetailSurfingBattleRankItemRender.OnEnable = OnEnable
UILWMailDetailSurfingBattleRankItemRender.OnDisable = OnDisable
UILWMailDetailSurfingBattleRankItemRender.ComponentDefine = ComponentDefine
UILWMailDetailSurfingBattleRankItemRender.ComponentDestroy = ComponentDestroy
UILWMailDetailSurfingBattleRankItemRender.DataDefine = DataDefine
UILWMailDetailSurfingBattleRankItemRender.DataDestroy = DataDestroy
UILWMailDetailSurfingBattleRankItemRender.SetData = SetData
return UILWMailDetailSurfingBattleRankItemRender
