local UILWSeasonRainforestKingBattleRankItem = BaseClass("UILWSeasonRainforestKingBattleRankItem", UIBaseContainer)
local base = UIBaseContainer
local bg_path = "bg"
local first_name_txt_path = "firstNameTxt"
local score_txt_path = "scoreTxt"
local second_name_txt_path = "secondNameTxt"
local ui_player_head_path = "playerFlag/UIPlayerHead"
local rank_icon_path = "RankIcon"
local rank_icon_num_path = "RankIconNum"

function UILWSeasonRainforestKingBattleRankItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWSeasonRainforestKingBattleRankItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonRainforestKingBattleRankItem:ComponentDefine()
  self.bg = self:AddComponent(UIImage, bg_path)
  self.first_name_txt = self:AddComponent(UIText, first_name_txt_path)
  self.score_txt = self:AddComponent(UIText, score_txt_path)
  self.second_name_txt = self:AddComponent(UIText, second_name_txt_path)
  self.player_head = self:AddComponent(UICommonHead, ui_player_head_path)
  self.rank_icon = self:AddComponent(UIImage, rank_icon_path)
  self.rank_icon_num = self:AddComponent(UIText, rank_icon_num_path)
  self.player_head:SetEnableClickShowInfo(true, true)
end

function UILWSeasonRainforestKingBattleRankItem:ComponentDestroy()
  self.bg = nil
  self.first_name_txt = nil
  self.score_txt = nil
  self.second_name_txt = nil
  self.player_head = nil
  self.rank_icon = nil
  self.rank_icon_num = nil
end

function UILWSeasonRainforestKingBattleRankItem:ReInit(rankIndex, rankInfo, isSelf)
  self.rankInfo = rankInfo
  self.rank = rankIndex
  if self.rankInfo == nil then
    return
  end
  if rankInfo.rank then
    rankIndex = toInt(rankInfo.rank)
  end
  if rankIndex == 0 then
    self.rank_icon_num:SetLocalText("361054")
  else
    self.rank_icon_num:SetText(rankIndex)
  end
  self:SetRankIcon(self.rank_icon, rankIndex)
  local power_color = "#2A2830"
  local first_color = "#2A2830"
  local second_color = "#2A2830"
  local bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_4.png"
  if isSelf or rankInfo.uid == LuaEntry.Player.uid then
    power_color = "#2A2830"
    first_color = "#2A2830"
    second_color = "#2A2830"
    bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_5.png"
  elseif rankInfo.rank == 1 then
    power_color = "#AB6130"
    first_color = "#AB6130"
    second_color = "#AB6130"
    bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_1.png"
  elseif rankInfo.rank == 2 then
    power_color = "#3D4D9B"
    first_color = "#3D4D9B"
    second_color = "#3D4D9B"
    bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_2.png"
  elseif rankInfo.rank == 3 then
    power_color = "#90624D"
    first_color = "#90624D"
    second_color = "#90624D"
    bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_3.png"
  end
  self.bg:LoadSprite(bgPath)
  local score = toInt(rankInfo.score)
  self.score_txt:SetText("<color=" .. power_color .. ">" .. string.GetFormattedSeparatorNum(score) .. "</color>")
  if isSelf then
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    local player = LuaEntry.Player
    self.player_head:SetAsMyself()
    self.first_name_txt:SetText("<color=" .. first_color .. ">" .. player.name .. "</color>")
    if string.IsNullOrEmpty(player.allianceId) then
      self.second_name_txt:SetText("#" .. mySourceServerId)
    else
      local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      if data ~= nil and data.abbr ~= nil and data.abbr ~= "" then
        local msg = UIUtil.FormatServerAllianceName(mySourceServerId, data.abbr, "")
        self.second_name_txt:SetText("<color=" .. second_color .. ">" .. msg .. "</color>")
      else
        self.second_name_txt:SetText("<color=" .. second_color .. ">#" .. mySourceServerId .. "</color>")
      end
    end
  else
    local msg = UIUtil.FormatServerAllianceName(rankInfo.serverId, rankInfo.abbr, "")
    self.player_head:ParseHeadInfo(rankInfo)
    self.first_name_txt:SetText("<color=" .. first_color .. ">" .. rankInfo.name .. "</color>")
    self.second_name_txt:SetText("<color=" .. second_color .. ">" .. msg .. "</color>")
  end
end

function UILWSeasonRainforestKingBattleRankItem:SetRankIcon(rank_icon, rank)
  if rank_icon == nil or IsNull(rank_icon.gameObject) then
    return
  end
  if rank <= 3 then
    rank_icon:SetActive(rank <= 3 and 1 <= rank)
    if rank == 1 then
      rank_icon:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_1.png")
    elseif rank == 2 then
      rank_icon:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_2.png")
    elseif rank == 3 then
      rank_icon:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_3.png")
    end
  else
    rank_icon:SetActive(false)
  end
end

return UILWSeasonRainforestKingBattleRankItem
