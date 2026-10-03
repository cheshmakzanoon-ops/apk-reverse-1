local SeasonHunterRankItem = BaseClass("SeasonHunterRankItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local first_name_path = "Name/firstNameTxt"
local second_name_path = "Name/secondNameTxt"
local server_name_path = "Name/serverTxt"
local power_path = "ScoreText"
local power_icon_path = "ScoreText/ScoreIcon"
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
local __RankInfo = {
  [-1] = {
    power_color = "#2a2830",
    first_color = "#4a9327",
    second_color = "#14a91b",
    bgPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_common_diban_lv"
  },
  [1] = {
    power_color = "#d07b0c",
    first_color = "#d07b0c",
    second_color = "#b78026",
    bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_jinsetiao"
  },
  [2] = {
    power_color = "#6674ba",
    first_color = "#6674ba",
    second_color = "#5065cb",
    bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_yinsetiao"
  },
  [3] = {
    power_color = "#b77758",
    first_color = "#b77758",
    second_color = "#ba6744",
    bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_tongsetiao"
  }
}

function SeasonHunterRankItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.first_txt = self:AddComponent(UIText, first_name_path)
  self.second_txt = self:AddComponent(UIText, second_name_path)
  self.power_txt = self:AddComponent(UIText, power_path)
  self.power_icon = self:AddComponent(UIImage, power_icon_path)
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

function SeasonHunterRankItem:OnDestroy()
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

function SeasonHunterRankItem:SetItemShow(data, endTime, typeInfo)
  local rank = data.rank or 0
  local power_color = "#2a2830"
  local first_color = "#2a2830"
  local second_color = "#6d82ad"
  local bgPath = "Assets/Main/Sprites/UI/LWActMeteorite/zxl_common_diban_lan"
  local rankInfo = __RankInfo[data.uid == LuaEntry.Player.uid and -1 or rank]
  if rankInfo then
    power_color = rankInfo.power_color
    first_color = rankInfo.first_color
    second_color = rankInfo.second_color
    bgPath = rankInfo.bgPath
  end
  self.data = data
  self.no_al_root:SetActive(false)
  self.alliance_flag:SetActive(false)
  self.player_flag:SetActive(true)
  if type(rank) == "number" and 0 < rank then
    self.num_txt:SetText(rank)
  else
    self.num_txt:SetLocalText("361054")
  end
  self.bg:LoadSprite(bgPath)
  self.first_flag:SetActive(rank == 1)
  self.second_flag:SetActive(rank == 2)
  self.third_flag:SetActive(rank == 3)
  local pos = self.power_txt:GetLocalPosition()
  if typeInfo and typeInfo.icon then
    self.power_icon:LoadSprite(typeInfo.icon)
    self.power_icon:SetNativeSize()
    self.power_icon:SetActive(true)
  else
    self.power_icon:SetActive(false)
  end
  if typeInfo and typeInfo.type == SeasonHunterRankType.Time then
    pos.x = 295
    self.power_txt:SetLocalPosition(pos)
    self.power_txt:SetText(string.format("<color=%s>%s</color>", power_color, UITimeManager:GetInstance():MilliSecondToFmtString(tonumber(self.data.score))))
  else
    self.power_txt:SetLocalPosition(pos)
    local score = string.GetFormattedSeperatorNum(self.data.score)
    if self.power_icon.activeSelf then
      pos.x = 305
      self.power_txt:SetText(string.format("<color=%s>\195\151%s</color>", power_color, score))
    else
      pos.x = 290
      self.power_txt:SetText(string.format("<color=%s>%s</color>", power_color, score))
    end
  end
  self.second_txt:SetActive(false)
  self.isHide = endTime and (not typeInfo or typeInfo.type ~= SeasonHunterRankType.Kill or data.wolf == 1)
  if self.isHide then
    self.first_txt:SetText(string.format("<color=%s>%s</color>", first_color, Localization:GetString("season_s4_activity_1200011_desc39")))
    self.server_txt:SetActive(false)
    self.player_flag:SetHead(data.uid, "", 0)
    return
  end
  self.player_flag:SetHeadAndFrame(data.uid, data.pic, data.picVer, nil, data.headSkinId, data.headSkinET)
  if string.IsNullOrEmpty(data.abbr) then
    self.first_txt:SetText(string.format("<color=%s>%s</color>", first_color, self.data.name))
  else
    self.first_txt:SetText(string.format("<color=%s>[%s]%s</color>", first_color, self.data.abbr, self.data.name))
  end
  if data.serverId then
    self.server_txt:SetActive(true)
    self.server_txt:SetText(Localization:GetString("800941") .. " #" .. data.serverId)
  else
    self.server_txt:SetActive(false)
  end
end

function SeasonHunterRankItem:OnClick()
  if not self.isHide and self.data and self.data.serverId and self.data.uid then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, {
      serverId = self.data.serverId,
      uid = self.data.uid
    })
  end
end

return SeasonHunterRankItem
