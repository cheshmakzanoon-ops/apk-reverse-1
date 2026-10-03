local AttackCityRankContentItem = BaseClass("AttackCityRankContentItem", UIBaseContainer)
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
local player_flag_path = "UIPlayerHead"
local alliance_flag_path = "allianceFlag"
local btn_path = "Button"
local bg_path = "bg"
local countryImg_path = "countryImg"
local no_al_path = "NoAL"
local text_no_al_path = "NoAL/TextNoAL"

function AttackCityRankContentItem:OnCreate()
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
  self.countryImg = self:AddComponent(UIImage, countryImg_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClick()
  end)
end

function AttackCityRankContentItem:SetItemShow(global, data, isSelf)
  local power_color = "#2a2830"
  local first_color = "#2a2830"
  local second_color = "#6d82ad"
  local bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_huisetiao"
  if isSelf or data.isAlliance and LuaEntry.Player.allianceId == data.aid or data.aid == LuaEntry.Player.aid then
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
  if isSelf and not LuaEntry.Player:IsInAlliance() then
    self.no_al_root:SetActive(true)
    self.text_no_al:SetLocalText(451033)
    return
  else
    self.no_al_root:SetActive(false)
    self.player_flag:SetActive(false)
    if self.data.alIcon ~= nil and self.data.alIcon ~= "" then
      self.alliance_flag:SetActive(true)
      self.alliance_flag:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(self.data.alIcon)))
    else
      self.alliance_flag:SetActive(false)
    end
    if type(self.data.rank) == "number" and self.data.rank > 0 then
      self.num_txt:SetText(self.data.rank)
    else
      self.num_txt:SetText("50+")
    end
  end
  self.bg:LoadSprite(bgPath)
  self.first_flag:SetActive(self.data.rank == 1)
  self.second_flag:SetActive(self.data.rank == 2)
  self.third_flag:SetActive(self.data.rank == 3)
  self.power_txt:SetText("<color=" .. power_color .. ">" .. self.data.score .. "</color>")
  self.first_txt:SetText("<color=" .. first_color .. ">" .. "[" .. self.data.alAbbr .. "]" .. self.data.alName .. "</color>")
  self.server_txt:SetActive(false)
  self.second_txt:SetActive(true)
  self.second_txt:SetText(self.data.leaderName)
  local country = self.data.alCountry
  local template = DataCenter.NationTemplateManager:GetNationTemplate(country)
  self.countryImg:LoadSprite(template:GetNationFlagPath())
  self.countryImg:SetActive(not LuaEntry.Player:IsFromBIGCHINAorUsingLangZH())
end

function AttackCityRankContentItem:OnClick()
end

function AttackCityRankContentItem:OnDestroy()
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

return AttackCityRankContentItem
