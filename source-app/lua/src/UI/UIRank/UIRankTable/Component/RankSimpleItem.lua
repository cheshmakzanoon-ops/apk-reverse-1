local RankSimpleItem = BaseClass("RankSimpleItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local flag_bg_path = "flagBg"
local flag_icon_path = "flagIcon"
local btn_path = "BgButton"
local player_path = "Player"
local title_path = "Title"
local name_path = "Name"
local server_path = "Server"
local country_path = "flagIcon/country"
local otherInfoText_path = "OtherInfoText"

function RankSimpleItem:OnCreate()
  base.OnCreate(self)
  self.title = self:AddComponent(UIText, title_path)
  self.user_name = self:AddComponent(UIText, name_path)
  self.server_name = self:AddComponent(UIText, server_path)
  self.flag_bg = self:AddComponent(UIImage, flag_bg_path)
  self.flag_icon = self:AddComponent(UIImage, flag_icon_path)
  self.player_icon = self:AddComponent(UICommonHead, player_path)
  self.country_img = self:AddComponent(UIImage, country_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClick()
  end)
  self.otherInfoText = self:AddComponent(UIText, otherInfoText_path)
end

function RankSimpleItem:OnClick()
  if self.param == nil or self.param.ranking == nil then
    UIUtil.ShowTipsId(371004)
    return
  end
  self.view.ctrl:OnRankItemClick(self.flagGlobal, self.typeData.type, self.serverId)
end

function RankSimpleItem:OnDestroy()
  self.title = nil
  self.user_name = nil
  self.server_name = nil
  self.flag_bg = nil
  self.flag_icon = nil
  self.btn = nil
  self.typeData = nil
  self.param = nil
  self.player_icon = nil
  self.country_img = nil
  base.OnDestroy(self)
end

function RankSimpleItem:InitByType(data, serverId)
  self.typeData = data
  self.serverId = serverId
  self.title:SetText(data.title)
end

function RankSimpleItem:RefreshShowData(param)
  local nType = param.type
  self.param = param
  if param.ranking == nil then
    self.user_name:SetText("-")
    self.server_name:SetActive(false)
    self.otherInfoText:SetActive(false)
    return
  end
  local ranking = param.ranking[1]
  if ranking == nil then
    self:SetActive(false)
    return
  end
  local allianceName = ranking.alliancename or ""
  local abbr = ranking.abbr
  local name = ranking.name
  local leader = ranking.leader
  local srcServer = ranking.srcServer
  local country = ranking.country
  local icon = ranking.icon
  if nType == RankingTypeServer.KILL_ALLIANCE or nType == RankingTypeServer.POWER_ALLIANCE then
    if allianceName == nil or allianceName == "" then
      self.user_name:SetText("-")
    else
      self.user_name:SetText("[" .. abbr .. "] " .. allianceName)
    end
    if icon ~= nil and icon ~= "" then
      self.flag_icon:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(icon)))
    end
    if LuaEntry.GlobalData:IsChina() or LuaEntry.Player:IsFromBIGCHINAorUsingLangZH() then
      self.country_img:SetActive(false)
    else
      self.country_img:SetActive(true)
      local template = DataCenter.NationTemplateManager:GetNationTemplate(country)
      self.country_img:LoadSprite(template:GetNationFlagPath())
    end
    self.flag_icon:SetActive(true)
    self.player_icon:SetActive(false)
  else
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(ranking.uid, name)
    if abbr == nil or abbr == "" then
      self.user_name:SetText(showName)
    elseif ranking.uid == LuaEntry.Player.uid then
      if LuaEntry.Player:IsInAlliance() then
        self.user_name:SetText("[" .. abbr .. "] " .. showName)
      else
        self.user_name:SetText(showName)
      end
    else
      self.user_name:SetText("[" .. abbr .. "] " .. showName)
    end
    self.flag_icon:SetActive(false)
    self.player_icon:SetActive(true)
    local headFramePath = DataCenter.DecorationDataManager:GetHeadFrame(ranking.headSkinId, ranking.headSkinET, false)
    self.player_icon:SetHead(ranking.uid, ranking.pic, ranking.picVer, nil, headFramePath)
  end
  if srcServer ~= nil and (self.flagGlobal == 1 or LuaEntry.Player.serverId ~= srcServer) then
    self.server_name:SetActive(true)
    if LuaEntry.Player:GetSourceServerId() == srcServer then
      self.server_name:SetText("<color=#5fef87>" .. Localization:GetString("800941") .. " #" .. srcServer .. "</color>")
    else
      self.server_name:SetText(Localization:GetString("800941") .. " #" .. srcServer)
    end
  else
    self.server_name:SetActive(false)
  end
  if RankingTypeServer.TRIAL_TOWER_MISSILE or nType == RankingTypeServer.TRIAL_TOWER_AIRPLANE or nType == RankingTypeServer.TRIAL_TOWER_TANK then
    if ranking.group and ranking.order then
      self.otherInfoText:SetActive(true)
      local group = ranking.group
      local order = ranking.order
      self.otherInfoText:SetText(group .. "-" .. order)
      if self.server_name and self.server_name.activeSelf then
        self.otherInfoText:SetLocalPositionXYZ(0, -138, 0)
      else
        self.otherInfoText:SetLocalPositionXYZ(0, -108, 0)
      end
    else
      self.otherInfoText:SetActive(false)
    end
  else
    self.otherInfoText:SetActive(false)
  end
end

function RankSimpleItem:RefreshData(tabIndex, global, serverId)
  local data = DataCenter.RankDataManager:GetPreviewRankData(global, self.typeData.type, serverId)
  self.tabIndex = tabIndex
  self.serverId = serverId
  self.flagGlobal = global
  if data ~= nil then
    self:RefreshShowData(data)
  else
    self.server_name:SetActive(true)
    self.server_name:SetText(Localization:GetString("800941") .. " #" .. serverId)
    self.otherInfoText:SetActive(false)
  end
end

return RankSimpleItem
