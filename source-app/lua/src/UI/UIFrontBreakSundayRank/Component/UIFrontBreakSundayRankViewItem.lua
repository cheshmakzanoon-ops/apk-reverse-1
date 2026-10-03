local UIFrontBreakSundayRankViewItem = BaseClass("UIFrontBreakSundayRankViewItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local bg_self_path = "bgSelf"
local bg_path = "bg"
local txt_rank_path = "txtRank"
local txt_last_rank_path = "txtLastRank"
local head_path = "head"
local txt_name_path = "txtName"
local level_path = "level"
local btn_head_path = "btnHead"
local txt_remainSolider_path = "remainSolider/txtRemainSolider"
local score_span = 1000000
local RankType = {
  ServerRank = 1,
  AllianceRank = 2,
  TopRank = 3
}

function UIFrontBreakSundayRankViewItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIFrontBreakSundayRankViewItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIFrontBreakSundayRankViewItem:ComponentDefine()
  self.bg_self = self:AddComponent(UIImage, bg_self_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.txt_rank = self:AddComponent(UITextMeshProUGUIEx, txt_rank_path)
  self.txt_last_rank = self:AddComponent(UITextMeshProUGUIEx, txt_last_rank_path)
  self.head = self:AddComponent(UICommonHead, head_path)
  self.txt_name = self:AddComponent(UITextMeshProUGUIEx, txt_name_path)
  self.level = self:AddComponent(UITextMeshProUGUIEx, level_path)
  self.btn_head = self:AddComponent(UIButton, btn_head_path)
  self.txt_remainSolider = self:AddComponent(UITextMeshProUGUIEx, txt_remainSolider_path)
  self.btn_head:SetOnClick(function()
    if self.data and self.data.uid then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.data.uid)
    end
  end)
end

function UIFrontBreakSundayRankViewItem:ComponentDestroy()
  self.bg_self = nil
  self.bg = nil
  self.txt_rank = nil
  self.txt_last_rank = nil
  self.head = nil
  self.txt_name = nil
  self.level = nil
  self.btn_head = nil
end

function UIFrontBreakSundayRankViewItem:Refresh(data, tab, totalNum)
  self.data = data
  self.totalNum = totalNum
  self.head:SetData(data.uid, data.pic, data.picver)
  local name = data.name
  if tab == RankType.ServerRank then
    name = UIUtil.FormatAllianceAndName(data.abbr, data.name, data.uid)
  elseif tab == RankType.TopRank then
    name = UIUtil.FormatServerAllianceName(data.serverId, data.abbr, data.name, data.uid)
  end
  self.txt_name:SetText(name)
  local rank = data.rank or 0
  if 0 < rank then
    self.txt_rank:SetText(rank)
  else
    self.txt_rank:SetText(Localization:GetString("activity_breakthrough_tips_16"))
  end
  local score = data.score or 0
  local level = score // score_span
  self.level:SetLocalText("activity_breakthrough_tips_15", level)
  local remainSolider = score - level * score_span
  self.txt_remainSolider:SetText(string.format("x%d", remainSolider))
end

function UIFrontBreakSundayRankViewItem:RefreshSelf(selfRank, selfScore, tab, totalNum)
  self.data = {}
  self.data.uid = LuaEntry.Player.uid
  self.totalNum = totalNum
  self.head:SetData(LuaEntry.Player.uid, LuaEntry.Player.pic, LuaEntry.Player.picVer)
  local name = LuaEntry.Player.name
  if tab == RankType.ServerRank then
    name = LuaEntry.Player:GetFullName()
  elseif tab == RankType.TopRank then
    name = LuaEntry.Player:GetFullNameWithSourceServer()
  end
  self.txt_name:SetText(name)
  local rank = selfRank
  if 0 < rank then
    if self.totalNum and rank > self.totalNum then
      self.txt_rank:SetText(string.format("%d+", self.totalNum))
    else
      self.txt_rank:SetText(rank)
    end
  else
    self.txt_rank:SetText(Localization:GetString("activity_breakthrough_tips_16"))
  end
  local level = selfScore // score_span
  self.level:SetLocalText("activity_breakthrough_tips_15", level)
  local remainSolider = selfScore - level * score_span
  self.txt_remainSolider:SetText(string.format("x%d", remainSolider))
end

return UIFrontBreakSundayRankViewItem
