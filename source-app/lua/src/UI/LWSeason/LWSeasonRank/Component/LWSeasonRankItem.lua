local LWSeasonRankItem = BaseClass("LWSeasonRankItem", UIBaseContainer)
local AllianceFlagItem = require("UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local first_name_path = "Name/firstNameTxt"
local second_name_path = "Name/secondNameTxt"
local content_server_path = "Name/content_server"
local server_name_path = "Name/content_server/serverTxt"
local power_path = "powerTxt"
local num_path = "numTxt"
local first_flag_path = "firstImg"
local second_flag_path = "secondImg"
local third_flag_path = "thirdImg"
local player_flag_path = "player"
local alliance_flag_path = "allianceFlag"
local btn_path = "Button"
local bg_path = "bg"
local house_path = "House"
local home_icon_path = "House/homeIcon"
local no_al_path = "NoAL"
local text_no_al_path = "NoAL/TextNoAL"
local rank_change_path = "rankChange"
local change_bg_path = "rankChange/changeBg"
local up_or_down_path = "rankChange/up_or_down"
local change_value_path = "rankChange/changeValue"
local bgPathUp = "Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/Mjc_saiji2_paihangbang_paiming_bg_jia.png"
local bgPathDown = "Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/Mjc_saiji2_paihangbang_paiming_bg_jian.png"
local arrowUp = "Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/Mjc_saiji2_paihangbang_paiming_jia.png"
local arrowDown = "Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/Mjc_saiji2_paihangbang_paiming_jian.png"
local camp_icon_path = "Name/content_server/campIcon"

function LWSeasonRankItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.first_txt = self:AddComponent(UIText, first_name_path)
  self.second_txt = self:AddComponent(UIText, second_name_path)
  self.power_txt = self:AddComponent(UITextMeshProUGUIEx, power_path)
  self.power_txt:OnPointerClick(function(eventData)
    self:OnPowerLinkClicked(eventData.position)
  end)
  self.content_server = self:AddComponent(UIBaseContainer, content_server_path)
  self.server_txt = self:AddComponent(UIText, server_name_path)
  self.camp_icon = self:AddComponent(UIImage, camp_icon_path)
  self.num_txt = self:AddComponent(UIText, num_path)
  self.first_flag = self:AddComponent(UIBaseContainer, first_flag_path)
  self.second_flag = self:AddComponent(UIBaseContainer, second_flag_path)
  self.third_flag = self:AddComponent(UIBaseContainer, third_flag_path)
  self.player_flag = self:AddComponent(UICommonHead, player_flag_path)
  self.alliance_flag = self:AddComponent(UIImage, alliance_flag_path)
  self.house = self:AddComponent(UIBaseComponent, house_path)
  self.home_icon = self:AddComponent(UIImage, home_icon_path)
  self.house:SetActive(false)
  self.no_al_root = self:AddComponent(UIImage, no_al_path)
  self.text_no_al = self:AddComponent(UIText, text_no_al_path)
  self.rank_change = self:AddComponent(UIBaseContainer, rank_change_path)
  self.change_bg = self:AddComponent(UIImage, change_bg_path)
  self.up_or_down = self:AddComponent(UIImage, up_or_down_path)
  self.change_value = self:AddComponent(UITextMeshProUGUIEx, change_value_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClick()
  end)
  self.btn:SetActive(true)
end

function LWSeasonRankItem:OnDestroy()
  self.first_txt = nil
  self.second_txt = nil
  self.power_txt = nil
  self.content_server = nil
  self.server_txt = nil
  self.num_txt = nil
  self.first_flag = nil
  self.second_flag = nil
  self.third_flag = nil
  self.player_flag = nil
  self.alliance_flag = nil
  self.btn = nil
  self.rank_change = nil
  self.change_bg = nil
  self.up_or_down = nil
  self.change_value = nil
  self.camp_icon = nil
  self.house:SetActive(false)
  base.OnDestroy(self)
end

function LWSeasonRankItem:SetItemShow(theType, data, isSelf)
  local isAlliance = SeasonUtil.SesaonRankOfAlliance(theType)
  local isPersonal = SeasonUtil.SesaonRankOfPersaon(theType)
  local isServer = SeasonUtil.SesaonRankOfServer(theType)
  local compId = 0
  if isAlliance then
    if 0 < data.serverId then
      compId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(data.serverId)
    end
  elseif isPersonal then
    if 0 < data.serverId then
      compId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(data.serverId)
    end
  elseif isServer and 0 < data.serverId then
    compId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(data.serverId)
  end
  if 0 < compId then
    self.camp_icon:SetActive(true)
    self.camp_icon:LoadSprite(DataCenter.SeasonFactionWarDataManager:GetCampIcon(compId))
  else
    self.camp_icon:SetActive(false)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content_server.transform)
  local power_color = "#2a2830"
  local first_color = "#2a2830"
  local second_color = "#6d82ad"
  local bgPath = "Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/Mjc_saiji2_paihangbang_list_bg_4.png"
  local uidKey
  if isSelf or isAlliance and LuaEntry.Player.allianceId == data.aid or isPersonal and data.uid == LuaEntry.Player.uid then
    power_color = "#4a9327"
    first_color = "#4a9327"
    second_color = "#14a91b"
    bgPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_common_diban_lv.png"
  elseif data.rank == 1 then
    power_color = "#d07b0c"
    first_color = "#d07b0c"
    second_color = "#b78026"
    bgPath = "Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/Mjc_saiji2_paihangbang_list_bg_1.png"
  elseif data.rank == 2 then
    power_color = "#6674ba"
    first_color = "#6674ba"
    second_color = "#5065cb"
    bgPath = "Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/Mjc_saiji2_paihangbang_list_bg_2.png"
  elseif data.rank == 3 then
    power_color = "#b77758"
    first_color = "#b77758"
    second_color = "#ba6744"
    bgPath = "Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/Mjc_saiji2_paihangbang_list_bg_3.png"
  end
  self.theType = theType
  self.data = data
  if isAlliance then
    uidKey = data.aid
    self.house:SetActive(false)
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
    end
    self.first_txt:SetActive(true)
    self.first_txt:SetText("<color=" .. first_color .. ">" .. string.format("[%s]%s", data.abbr, data.name) .. "</color>")
  elseif isPersonal then
    uidKey = data.uid
    self.house:SetActive(false)
    self.no_al_root:SetActive(false)
    self.alliance_flag:SetActive(false)
    self.player_flag:SetActive(true)
    self.player_flag:ParseHeadInfo(self.data)
    self.first_txt:SetActive(true)
    if string.IsNullOrEmpty(data.abbr) then
      self.first_txt:SetText("<color=" .. first_color .. ">" .. string.format("%s", data.name) .. "</color>")
    else
      self.first_txt:SetText("<color=" .. first_color .. ">" .. string.format("[%s]%s", data.abbr, data.name) .. "</color>")
    end
  elseif isServer then
    uidKey = data.serverId
    local badgesIconPath = DataCenter.ZoneWarManager:GetKingdomBadgesIconPath(data.serverId)
    self.home_icon:SetActive(true)
    self.home_icon:LoadSprite(badgesIconPath)
    self.house:SetActive(true)
    self.no_al_root:SetActive(false)
    self.alliance_flag:SetActive(false)
    self.player_flag:SetActive(false)
    self.first_txt:SetActive(false)
  end
  if self.data.rank and type(data.rank) == "number" and 0 < data.rank then
    self.num_txt:SetText(data.rank)
    self.first_flag:SetActive(data.rank == 1)
    self.second_flag:SetActive(data.rank == 2)
    self.third_flag:SetActive(data.rank == 3)
  else
    self.first_flag:SetActive(false)
    self.second_flag:SetActive(false)
    self.third_flag:SetActive(false)
    self.num_txt:SetText(CS.GameEntry.Localization:GetString("361054"))
  end
  self.bg:LoadSprite(bgPath)
  local powerText = string.GetFormattedSeperatorNum(checknumber(data.score))
  local seasonType = SeasonUtil.GetSeasonType(true, true)
  if seasonType == SeasonMapType.NineNationRainforest then
    local score = checknumber(data.score)
    local destroyScore = checknumber(data.destroyForce)
    local buildingScore = score - destroyScore
    powerText = string.format("<link=%s><u>%s</u></link>", "s6_camp_score_detail", powerText)
  end
  self.power_txt:SetText("<color=" .. power_color .. ">" .. powerText .. "</color>")
  self.second_txt:SetActive(false)
  self.server_txt:SetActive(true)
  self.server_txt:SetText(Localization:GetString("800941") .. " #" .. data.serverId)
  self.server_txt:SetColorHex(first_color)
  local tScore = toInt(data.rank)
  local cacheData = DataCenter.SeasonDataManager:GetSeasonRankDataCache(theType, uidKey)
  local isChange = false
  local changeValue = 0
  if cacheData and tScore ~= cacheData.oldValue then
    if cacheData.newValue == tScore then
      isChange = true
      changeValue = cacheData.oldValue - tScore
    else
      Logger.Log("cache logic is wrong")
    end
  end
  if isChange then
    self.rank_change:SetActive(true)
    if 0 < changeValue then
      self.change_bg:LoadSprite(bgPathUp)
      self.up_or_down:LoadSprite(arrowUp)
      self.change_value:SetText("+" .. changeValue)
      self.change_value:SetColor(Color.New(0.30196078431372547, 0.43529411764705883, 0.12549019607843137, 1))
    else
      self.change_bg:LoadSprite(bgPathDown)
      self.up_or_down:LoadSprite(arrowDown)
      self.change_value:SetText(changeValue)
      self.change_value:SetColor(Color.New(0.4549019607843137, 0.13725490196078433, 0.11764705882352941, 1))
    end
    self.power_txt:SetAnchoredPositionXY(180, 0)
  else
    self.power_txt:SetAnchoredPositionXY(280, 0)
    self.rank_change:SetActive(false)
  end
end

function LWSeasonRankItem:OnClick()
  local theType = self.theType
  if SeasonUtil.SesaonRankOfPersaon(theType) then
    if self.data.uid then
      self.view:OnPlayerDetailClick(self.data.serverId, self.data.uid)
    end
  elseif SeasonUtil.SesaonRankOfAlliance(theType) then
    local allianceId = self.data.aid
    if string.IsNullOrEmpty(allianceId) then
      allianceId = self.data.allianceId
    end
    if string.IsNullOrEmpty(allianceId) then
    else
      UIUtil.TryShowAllianceInfo(self.data.serverId, allianceId, self.data.name)
    end
  elseif SeasonUtil.SesaonRankOfServer(theType) and self.data.serverId ~= nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOfficial, {anim = true}, self.data.serverId)
  end
end

function LWSeasonRankItem:OnPowerLinkClicked(clickPos)
  if IsNull(self.power_txt) then
    return
  end
  local linkId = self.power_txt:TryGetPointerClickLinkID(clickPos)
  if linkId == "s6_camp_score_detail" and self.data ~= nil then
    local param = {}
    param.alignObject = self.power_txt
    param.yPosFix = 20
    param.showArrow = true
    param.preferTop = false
    local score = checknumber(self.data.score)
    local destroyScore = checknumber(self.data.destroyForce)
    local buildingScore = score - destroyScore
    param.score = string.GetFormattedSeparatorNum(score)
    param.buildingScore = string.GetFormattedSeparatorNum(buildingScore)
    param.destroyScore = string.GetFormattedSeparatorNum(destroyScore)
    UIManager:GetInstance():OpenWindow(UIWindowNames.S6CampRankScoreTips, {anim = true}, param)
  end
end

return LWSeasonRankItem
