local SeasonKingCell = BaseClass("SeasonKingCell", UIBaseContainer)
local base = UIBaseContainer
local king_detail_btn_path = "kingDetailBtn"
local no_king_path = "no_king"
local no_user_path = "no_king/noUser"
local king_path = "king"
local player_path = "king/player"
local name_text_path = "king/NameText"
local title_path = "king/title"
local NO_KING_KEY = {
  [GovOfficialType.Outpost] = "outpost_commander_ui_16",
  [GovOfficialType.Center] = "supreme_president_ui_19",
  [GovOfficialType.Native] = "457017"
}

function SeasonKingCell:OnCreate()
  base.OnCreate(self)
  self.no_king = self:AddComponent(UIBaseComponent, no_king_path)
  self.king_detail_btn = self:AddComponent(UIButton, king_detail_btn_path)
  self.king_detail_btn:SetOnClick(function()
    if SeasonUtil.IsUserInSeason() and LuaEntry.Player:IsDeepLeader(self.serverId, self.buildingId) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonOfficialApply, {anim = true}, self.serverId, self.buildingId, self.config)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonOfficialBuff, {anim = true}, self.serverId, self.buildingId, self.config)
    end
  end)
  self.king_title = self:AddComponent(UIText, title_path)
  self.king = self:AddComponent(UIBaseComponent, king_path)
  self.king_player = self:AddComponent(UICommonHead, player_path)
  self.king_name_text = self:AddComponent(UIText, name_text_path)
  self.king_player:SetEnableClickShowInfo(false, false)
  self.no_user = self:AddComponent(UITextMeshProUGUIEx, no_user_path)
end

function SeasonKingCell:OnDestroy()
  self.no_king = nil
  self.king = nil
  self.king_player = nil
  self.king_name_text = nil
  base.OnDestroy(self)
end

function SeasonKingCell:ReInit(serverId, buildingId, config, info)
  self.config = config
  self.info = info
  self.buildingId = buildingId
  self.serverId = serverId
  self.info = info
  if info == nil or info.uid == 0 or info.uid == "" then
    info = nil
  else
    local presidentName = UIUtil.FormatServerAllianceName(info.serverId, info.abbr, info.name, info.uid)
    self.king_title:SetLocalText(config.name)
    self.king_name_text:SetText(presidentName)
    self.king_player:ParseHeadInfo(info)
  end
  self.no_king:SetActive(info == nil)
  self.king:SetActive(info ~= nil)
  self.no_user:SetLocalText(NO_KING_KEY[config.type])
end

return SeasonKingCell
