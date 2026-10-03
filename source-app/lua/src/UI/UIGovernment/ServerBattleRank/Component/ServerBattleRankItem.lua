local ServerBattleRankItem = BaseClass("ServerBattleRankItem", UIBaseContainer)
local base = UIBaseContainer
local bg_path = "bg"
local first_name_txt_path = "firstNameTxt"
local score_txt_path = "scoreTxt"
local second_name_txt_path = "secondNameTxt"
local ui_player_head_path = "playerFlag/UIPlayerHead"
local rank_icon_path = "RankIcon"
local rank_icon_num_path = "RankIconNum"

function ServerBattleRankItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ServerBattleRankItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ServerBattleRankItem:ComponentDefine()
  self.bg = self:AddComponent(UIImage, bg_path)
  self.first_name_txt = self:AddComponent(UIText, first_name_txt_path)
  self.score_txt = self:AddComponent(UIText, score_txt_path)
  self.second_name_txt = self:AddComponent(UIText, second_name_txt_path)
  self.player_head = self:AddComponent(UICommonHead, ui_player_head_path)
  self.rank_icon = self:AddComponent(UIImage, rank_icon_path)
  self.rank_icon_num = self:AddComponent(UIText, rank_icon_num_path)
  self.player_head:SetEnableClickShowInfo(true, true)
end

function ServerBattleRankItem:ComponentDestroy()
  self.bg = nil
  self.first_name_txt = nil
  self.score_txt = nil
  self.second_name_txt = nil
  self.player_head = nil
  self.rank_icon = nil
  self.rank_icon_num = nil
end

function ServerBattleRankItem:ReInit(rankIndex, rankInfo, isSelf)
  self.rankInfo = rankInfo
  if self.rankInfo == nil then
    return
  end
  self.rank_icon_num:SetText(self.rankInfo.rank)
  self.player_head:ParseHeadInfo(rankInfo)
  self:SetRankIcon(self.rank_icon, self.rankInfo.rank)
  local power_color = "#2a2830"
  local first_color = "#2a2830"
  local second_color = "#6d82ad"
  local bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_huisetiao"
  if isSelf or rankInfo.uid == LuaEntry.Player.uid then
    power_color = "#4a9327"
    first_color = "#4a9327"
    second_color = "#14a91b"
    bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_lvsetiao"
  elseif rankInfo.rank == 1 then
    power_color = "#d07b0c"
    first_color = "#d07b0c"
    second_color = "#b78026"
    bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_jinsetiao"
  elseif rankInfo.rank == 2 then
    power_color = "#6674ba"
    first_color = "#6674ba"
    second_color = "#5065cb"
    bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_yinsetiao"
  elseif rankInfo.rank == 3 then
    power_color = "#b77758"
    first_color = "#b77758"
    second_color = "#ba6744"
    bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_tongsetiao"
  end
  self.bg:LoadSprite(bgPath)
  self.score_txt:SetText("<color=" .. power_color .. ">" .. string.GetFormattedSeparatorNum(rankInfo.score or 0) .. "</color>")
  self.first_name_txt:SetText("<color=" .. first_color .. ">" .. rankInfo.name .. "</color>")
  if string.IsNullOrEmpty(self.rankInfo.allianceAbbr) then
    self.second_name_txt:SetText("")
  else
    self.second_name_txt:SetText("<color=" .. second_color .. ">[" .. rankInfo.allianceAbbr .. "]" .. rankInfo.allianceName .. "</color>")
  end
end

function ServerBattleRankItem:SetRankIcon(rank_icon, rank)
  if rank_icon == nil or IsNull(rank_icon.gameObject) then
    return
  end
  if rank <= 3 then
    rank_icon:SetActive(rank <= 3 and 1 <= rank)
    if rank == 1 then
      rank_icon:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_1.png")
    elseif rank == 2 then
      rank_icon:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_2.png")
    elseif rank == 3 then
      rank_icon:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_3.png")
    end
  else
    rank_icon:SetActive(false)
  end
end

return ServerBattleRankItem
