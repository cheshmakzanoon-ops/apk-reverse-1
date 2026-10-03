local UILWSeasonVirusRankItem = BaseClass("UILWSeasonVirusRankItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization

function UILWSeasonVirusRankItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, "bg")
  self.alliance_flag = self:AddComponent(UIImage, "allianceFlag")
  self.playerRoot = self:AddComponent(UIBaseComponent, "playerFlag")
  self.ui_player_head = self:AddComponent(UICommonHead, "playerFlag/UIPlayerHead")
  self.name_txt = self:AddComponent(UITextMeshProUGUIEx, "name")
  self.score_txt = self:AddComponent(UITextMeshProUGUIEx, "scoreTxt")
  self.rank_icon = self:AddComponent(UIImage, "RankIcon")
  self.rank_num = self:AddComponent(UITextMeshProUGUIEx, "RankNum")
  self.playerRoot:SetActive(true)
  self.alliance_flag:SetActive(false)
  self.ui_player_head:SetEnableClickShowInfo(true, true)
end

function UILWSeasonVirusRankItem:OnDestroy()
  self.bg = nil
  self.alliance_flag = nil
  self.player_flag = nil
  self.ui_player_head = nil
  self.name_txt = nil
  self.score_txt = nil
  self.rank_icon = nil
  self.rank_num = nil
  base.OnDestroy(self)
end

function UILWSeasonVirusRankItem:ReInit(rankType, data, isSelf)
  local rankIndex = toInt(data.rank)
  if rankIndex == 1 then
    self.rank_icon:SetActive(true)
    self.rank_icon:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_1.png")
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_1.png")
  elseif rankIndex == 2 then
    self.rank_icon:SetActive(true)
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_2.png")
    self.rank_icon:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_2.png")
  elseif rankIndex == 3 then
    self.rank_icon:SetActive(true)
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_3.png")
    self.rank_icon:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_3.png")
  else
    self.rank_icon:SetActive(false)
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_4.png")
  end
  if rankIndex < 1 then
    self.rank_num:SetText("100+")
  else
    self.rank_num:SetText(rankIndex)
  end
  local myself = LuaEntry.Player
  local name_str
  if isSelf or data.uid == myself.uid then
    isSelf = true
    self.ui_player_head:ParseHeadInfo(myself)
    name_str = myself:GetFullName()
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_5.png")
  else
    self.ui_player_head:ParseHeadInfo(data)
    name_str = UIUtil.FormatServerAllianceName(data.serverId, data.abbr, data.name)
  end
  local first_color = "#2a2830"
  if isSelf then
    first_color = "#4a9327"
  elseif rankIndex == 1 then
    first_color = "#d07b0c"
  elseif rankIndex == 2 then
    first_color = "#6674ba"
  elseif rankIndex == 3 then
    first_color = "#b77758"
  end
  if string.IsNullOrEmpty(name_str) then
    name_str = tostring(rankIndex)
  end
  self.name_txt:SetText("<color=" .. first_color .. ">" .. name_str .. "</color>")
  if rankType == 1 then
    self.score_txt:SetLocalText("season_quest_desc_601020", string.GetFormattedSeparatorNum(toInt(data.score)))
  elseif rankType == 2 then
    self.score_txt:SetLocalText("season_quest_desc_601021", string.GetFormattedSeparatorNum(toInt(data.score)))
  elseif rankType == 3 then
    self.score_txt:SetLocalText("season_quest_desc_601022", string.GetFormattedSeparatorNum(toInt(data.score)))
  end
end

return UILWSeasonVirusRankItem
