local UIPveActRankItem = BaseClass("UIPveActRankItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local bg_path = "Bg"
local mine_path = "Bg/Mine"
local rank_icon_path = "Bg/RankIcon"
local rank_path = "Bg/Rank"
local player_head_path = "Bg/Head/UIPlayerHead"
local name_path = "Bg/Name"
local alliance_icon_path = "Bg/AllianceIcon"
local alliance_path = "Bg/Alliance"
local score_icon_path = "Bg/Score"
local score_path = "Bg/Score"
local scroll_view_path = "Bg/ScrollView"
local RankIcon = {
  [1] = "Assets/Main/Sprites/UI/UIAlliance/rank/UIalliance_rankingbg01",
  [2] = "Assets/Main/Sprites/UI/UIAlliance/rank/UIalliance_rankingbg02",
  [3] = "Assets/Main/Sprites/UI/UIAlliance/rank/UIalliance_rankingbg03"
}
local BgIcon = {
  [1] = "Assets/Main/Sprites/UI/UIPveAct/UIactivitiesranking_img_ranking01bg",
  [2] = "Assets/Main/Sprites/UI/UIPveAct/UIactivitiesranking_img_ranking02bg",
  [3] = "Assets/Main/Sprites/UI/UIPveAct/UIactivitiesranking_img_ranking03bg",
  [4] = "Assets/Main/Sprites/UI/UIPveAct/UIactivitiesranking_img_ranking04bg"
}

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.bg_btn = self:AddComponent(UIButton, bg_path)
  self.mine_go = self:AddComponent(UIBaseContainer, mine_path)
  self.rank_image = self:AddComponent(UIImage, rank_icon_path)
  self.rank_text = self:AddComponent(UIText, rank_path)
  self.player_head = self:AddComponent(UIPlayerHead, player_head_path)
  self.name_text = self:AddComponent(UIText, name_path)
  self.alliance_image = self:AddComponent(UIImage, alliance_icon_path)
  self.alliance_text = self:AddComponent(UIText, alliance_path)
  self.score_image = self:AddComponent(UIImage, score_icon_path)
  self.score_text = self:AddComponent(UIText, score_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self.bg_btn = nil
  self.mine_go = nil
  self.rank_image = nil
  self.rank_text = nil
  self.player_head = nil
  self.name_text = nil
  self.alliance_image = nil
  self.alliance_text = nil
  self.score_image = nil
  self.score_text = nil
  self.scroll_view = nil
end

local function DataDefine(self)
  self.data = nil
  self.rewardItems = {}
end

local function DataDestroy(self)
  self.data = nil
  self.rewardItems = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnCreateCell(self, itemObj, index)
  local reward = self.rewards[index]
  itemObj.name = tostring(index)
  local item = self.scroll_view:AddComponent(UICommonResItem, itemObj)
  item:ReInit(reward)
  self.rewardItems[index] = item
end

local function OnDeleteCell(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UICommonResItem)
  self.rewardItems[index] = nil
end

local function ShowScroll(self)
  self.scroll_view:SetTotalCount(#self.rewards)
  if #self.rewards > 0 then
    self.scroll_view:SetActive(true)
    self.scroll_view:RefillCells()
  else
    self.scroll_view:SetActive(false)
  end
end

local function SetData(self, data, rewards)
  if data == nil or rewards == nil then
    return
  end
  self.data = data
  self.rewards = DataCenter.RewardManager:ReturnRewardParamForView(rewards) or {}
  local bgIcon = BgIcon[data.rank] or BgIcon[4]
  self.bg_btn:LoadSprite(bgIcon)
  local rankIcon = RankIcon[data.rank]
  if rankIcon then
    self.rank_image:SetActive(true)
    self.rank_image:LoadSprite(rankIcon)
  else
    self.rank_image:SetActive(false)
  end
  self.rank_text:SetText(data.rank)
  self.player_head:SetData(data.uid, data.pic, data.picVer)
  self.name_text:SetText(data.name)
  if string.IsNullOrEmpty(data.alliancename) then
    self.alliance_text:SetText("")
  else
    self.alliance_text:SetText(string.format("[%s]%s", data.abbr, data.alliancename))
  end
  self.score_text:SetText(string.GetFormattedSeperatorNum(data.score))
  self:ShowScroll()
end

local function SetMine(self, isMine)
  self.mine_go:SetActive(isMine)
end

UIPveActRankItem.OnCreate = OnCreate
UIPveActRankItem.OnDestroy = OnDestroy
UIPveActRankItem.ComponentDefine = ComponentDefine
UIPveActRankItem.ComponentDestroy = ComponentDestroy
UIPveActRankItem.DataDefine = DataDefine
UIPveActRankItem.DataDestroy = DataDestroy
UIPveActRankItem.OnEnable = OnEnable
UIPveActRankItem.OnDisable = OnDisable
UIPveActRankItem.OnCreateCell = OnCreateCell
UIPveActRankItem.OnDeleteCell = OnDeleteCell
UIPveActRankItem.ShowScroll = ShowScroll
UIPveActRankItem.SetData = SetData
UIPveActRankItem.SetMine = SetMine
return UIPveActRankItem
