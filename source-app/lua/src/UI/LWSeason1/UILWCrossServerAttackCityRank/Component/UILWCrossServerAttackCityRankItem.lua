local UILWCrossServerAttackCityRankItem = BaseClass("UILWCrossServerAttackCityRankItem", UIBaseContainer)
local base = UIBaseContainer

function UILWCrossServerAttackCityRankItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, "bg")
  self.alliance_flag = self:AddComponent(UIButton, "allianceFlag")
  self.playerRoot = self:AddComponent(UIBaseComponent, "playerFlag")
  self.ui_player_head = self:AddComponent(UICommonHead, "playerFlag/UIPlayerHead")
  self.name_txt = self:AddComponent(UITextMeshProUGUIEx, "name")
  self.score_txt = self:AddComponent(UITextMeshProUGUIEx, "scoreTxt")
  self.rank_icon = self:AddComponent(UIImage, "RankIcon")
  self.rank_num = self:AddComponent(UITextMeshProUGUIEx, "RankNum")
  self.playerRoot:SetActive(true)
  self.alliance_flag:SetActive(false)
  self.ui_player_head:SetEnableClickShowInfo(true, true)
  self.alliance_flag:SetOnClick(function()
    if self.rank_type == 2 and self.data then
      if self.isSelf then
        local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
        if baseData ~= nil then
          UIUtil.TryShowAllianceInfo(baseData.ownerServerId, baseData.uid, baseData.allianceName)
        end
      else
        UIUtil.TryShowAllianceInfo(self.data.serverId, self.data.allianceId, self.data.name)
      end
    end
  end)
end

function UILWCrossServerAttackCityRankItem:OnDestroy()
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

function UILWCrossServerAttackCityRankItem:ReInit(rank_type, week_index, _, data, isSelf)
  self.rank_type = rank_type
  self.data = data
  self.playerRoot:SetActive(rank_type == 1)
  self.alliance_flag:SetActive(rank_type == 2)
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
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_4.png")
    self.rank_icon:SetActive(false)
  end
  if rankIndex < 1 then
    self.rank_num:SetText("100+")
  else
    self.rank_num:SetText(rankIndex)
  end
  local myself = LuaEntry.Player
  local name_str
  if rank_type == 1 then
    if isSelf or data.uid == myself.uid then
      isSelf = true
      self.ui_player_head:ParseHeadInfo(myself)
      name_str = myself:GetFullName()
      if 3 < rankIndex or rankIndex < 1 then
        self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_5.png")
      end
    else
      self.ui_player_head:ParseHeadInfo(data)
      name_str = UIUtil.FormatServerAllianceName(data.serverId, data.abbr, data.name)
    end
  elseif rank_type == 2 then
    if LuaEntry.Player:IsInAlliance() and LuaEntry.Player.allianceId == data.allianceId then
      isSelf = true
    end
    if isSelf then
      local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      if baseData ~= nil and baseData.icon ~= nil and baseData.icon ~= "" then
        self.alliance_flag:SetActive(true)
        self.alliance_flag:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(baseData.icon)))
      else
        self.alliance_flag:SetActive(false)
      end
      if baseData ~= nil then
        name_str = baseData:GetFullName()
      else
        name_str = "-"
      end
      if 3 < rankIndex or rankIndex < 1 then
        self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_5.png")
      end
    else
      if data.icon ~= nil and data.icon ~= "" then
        self.alliance_flag:SetActive(true)
        self.alliance_flag:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(data.icon)))
      else
        self.alliance_flag:SetActive(false)
      end
      name_str = UIUtil.FormatServerAllianceName(data.serverId, data.abbr, data.name)
    end
  end
  local power_color = "#2a2830"
  local first_color = "#2a2830"
  local second_color = "#6d82ad"
  if isSelf then
    if rankIndex < 1 then
      self.rank_num:SetLocalText("361054")
    end
    power_color = "#4a9327"
    first_color = "#4a9327"
    second_color = "#14a91b"
  elseif rankIndex == 1 then
    power_color = "#d07b0c"
    first_color = "#d07b0c"
    second_color = "#b78026"
  elseif rankIndex == 2 then
    power_color = "#6674ba"
    first_color = "#6674ba"
    second_color = "#5065cb"
  elseif rankIndex == 3 then
    power_color = "#b77758"
    first_color = "#b77758"
    second_color = "#ba6744"
  end
  if string.IsNullOrEmpty(name_str) then
    name_str = tostring(rankIndex)
  end
  self.isSelf = isSelf
  self.score_txt:SetText("<color=" .. power_color .. ">" .. string.GetFormattedSeparatorNum(toInt(data.score)) .. "</color>")
  self.name_txt:SetText("<color=" .. first_color .. ">" .. name_str .. "</color>")
end

return UILWCrossServerAttackCityRankItem
