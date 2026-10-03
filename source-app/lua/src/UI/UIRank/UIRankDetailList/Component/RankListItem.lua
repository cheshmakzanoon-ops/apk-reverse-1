local RankListItem = BaseClass("RankListItem", UIBaseContainer)
local AllianceFlagItem = require("UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local first_name_path = "Name/firstNameTxt"
local second_name_path = "Name/secondNameTxt"
local server_name_path = "Name/serverTxt"
local power_path = "powerTxt"
local num_path = "numTxt"
local first_flag_path = "firstImg"
local second_flag_path = "secondImg"
local third_flag_path = "thirdImg"
local player_flag_path = "player"
local alliance_flag_path = "allianceFlag"
local btn_path = "Button"
local bg_path = "bg"
local no_al_path = "NoAL"
local text_no_al_path = "NoAL/TextNoAL"

function RankListItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.first_txt = self:AddComponent(UIText, first_name_path)
  self.second_txt = self:AddComponent(UIText, second_name_path)
  self.power_txt = self:AddComponent(UIText, power_path)
  self.server_txt = self:AddComponent(UIText, server_name_path)
  self.num_txt = self:AddComponent(UIText, num_path)
  self.first_flag = self:AddComponent(UIBaseContainer, first_flag_path)
  self.second_flag = self:AddComponent(UIBaseContainer, second_flag_path)
  self.third_flag = self:AddComponent(UIBaseContainer, third_flag_path)
  self.player_flag = self:AddComponent(UICommonHead, player_flag_path)
  self.alliance_flag = self:AddComponent(UIImage, alliance_flag_path)
  self.no_al_root = self:AddComponent(UIImage, no_al_path)
  self.text_no_al = self:AddComponent(UIText, text_no_al_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClick()
  end)
end

function RankListItem:SetItemShow(global, data, isSelf)
  local power_color = "#2a2830"
  local first_color = "#2a2830"
  local second_color = "#6d82ad"
  local bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_huisetiao"
  if isSelf or data.isAlliance and LuaEntry.Player.allianceId == data.uid or data.uid == LuaEntry.Player.uid then
    power_color = "#4a9327"
    first_color = "#4a9327"
    second_color = "#14a91b"
    bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_lvsetiao"
  elseif data.rank == 1 then
    power_color = "#d07b0c"
    first_color = "#d07b0c"
    second_color = "#b78026"
    bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_jinsetiao"
  elseif data.rank == 2 then
    power_color = "#6674ba"
    first_color = "#6674ba"
    second_color = "#5065cb"
    bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_yinsetiao"
  elseif data.rank == 3 then
    power_color = "#b77758"
    first_color = "#b77758"
    second_color = "#ba6744"
    bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_tongsetiao"
  end
  self.data = data
  if self.data.isAlliance then
    if isSelf and not LuaEntry.Player:IsInAlliance() then
      self.no_al_root:SetActive(true)
      self.text_no_al:SetLocalText(451033)
      return
    else
      self.no_al_root:SetActive(false)
      self.player_flag:SetActive(false)
      if self.data.icon ~= nil and self.data.icon ~= "" then
        self.alliance_flag:SetActive(true)
        self.alliance_flag:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(self.data.icon)))
      else
        self.alliance_flag:SetActive(false)
      end
      if type(self.data.rank) == "number" and self.data.rank > 0 then
        self.num_txt:SetText(self.data.rank)
      else
        self.num_txt:SetText("50+")
      end
    end
  else
    self.no_al_root:SetActive(false)
    self.alliance_flag:SetActive(false)
    self.player_flag:SetActive(true)
    self.player_flag:SetHead(self.data.uid, self.data.pic, self.data.picVer, nil, self.data.headFrame)
    if type(self.data.rank) == "number" and self.data.rank > 0 then
      self.num_txt:SetText(self.data.rank)
    else
      self.num_txt:SetText(CS.GameEntry.Localization:GetString("361054"))
    end
  end
  self.bg:LoadSprite(bgPath)
  self.first_flag:SetActive(self.data.rank == 1)
  self.second_flag:SetActive(self.data.rank == 2)
  self.third_flag:SetActive(self.data.rank == 3)
  self.power_txt:SetText("<color=" .. power_color .. ">" .. self.data.power .. "</color>")
  self.first_txt:SetText("<color=" .. first_color .. ">" .. self.data.firstName .. "</color>")
  if data.heroId ~= nil and data.type == RankingTypeServer.ONE_HERO_POWER then
    local heroName = HeroUtils.GetHeroNameByConfigId(data.heroId)
    if heroName ~= nil and heroName ~= "" then
      heroName = Localization:GetString(heroName)
      self.second_txt:SetActive(true)
      self.second_txt:SetText("<color=" .. second_color .. ">" .. Localization:GetString("200003") .. " : " .. heroName .. "</color>")
    else
      self.second_txt:SetActive(false)
    end
  else
    self.second_txt:SetActive(false)
  end
  if data.serverId ~= nil and (global == 1 or LuaEntry.Player.serverId ~= data.serverId) then
    self.server_txt:SetActive(true)
    if LuaEntry.Player.serverId == data.serverId then
      self.server_txt:SetText("<color=#5fef87>" .. Localization:GetString("800941") .. " #" .. data.serverId .. "</color>")
    else
      self.server_txt:SetText(Localization:GetString("800941") .. " #" .. data.serverId)
    end
  else
    self.server_txt:SetActive(false)
  end
end

function RankListItem:OnClick()
  local theType = self.data.type
  if theType == RankingTypeServer.KILL or theType == RankingTypeServer.HERO_TOTAL_POWER or theType == RankingTypeServer.PVE_STAGE or theType == RankingTypeServer.ONE_HERO_POWER or theType == RankingTypeServer.POWER or theType == RankingTypeServer.BUILDING or theType == RankingTypeServer.TRIAL_TOWER_TANK or theType == RankingTypeServer.TRIAL_TOWER_AIRPLANE or theType == RankingTypeServer.TRIAL_TOWER_MISSILE or theType == RankingTypeServer.DOMINATOR_UP_PVE or theType == RankingTypeServer.T11_IDLE_GAME then
    self.view:OnPlayerDetailClick(self.data.serverId, self.data.uid)
  elseif theType ~= RankingTypeServer.KILL_ALLIANCE and theType ~= RankingTypeServer.POWER_ALLIANCE or self.data.uid == nil or self.data.uid == "" then
  else
    self.view:OnAllianceDetailClick(self.data.serverId, self.data.uid, self.data.allianceName)
  end
end

function RankListItem:OnDestroy()
  self.first_txt = nil
  self.second_txt = nil
  self.power_txt = nil
  self.server_txt = nil
  self.num_txt = nil
  self.first_flag = nil
  self.second_flag = nil
  self.third_flag = nil
  self.player_flag = nil
  self.alliance_flag = nil
  self.btn = nil
  base.OnDestroy(self)
end

return RankListItem
