local DestroyerKingCell = BaseClass("DestroyerKingCell", UIBaseContainer)
local base = UIBaseContainer
local fake_king_path = ""
local fake_player_path = "king/headDestroyer"
local fake_name_text_path = "king/NameDestroyer"
local fake_title_path = "titleDestroyer"
local no_king_path = "no_king"
local king_path = "king"
local no_king_icon_path = "no_king/no_king_icon"

function DestroyerKingCell:OnCreate()
  base.OnCreate(self)
  self.destroyer_king_title = self:AddComponent(UIText, fake_title_path)
  self.destroyer_king = self:AddComponent(UIButton, fake_king_path)
  self.destroyer_king:SetOnClick(function()
    if SeasonUtil.IsUserInSeason() and LuaEntry.Player:IsDeepLeader(self.serverId, self.buildingId) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonOfficialApply, {anim = true}, self.serverId, self.buildingId, self.config)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonOfficialBuff, {anim = true}, self.serverId, self.buildingId, self.config)
    end
  end)
  self.destroyer_king_player = self:AddComponent(UICommonHead, fake_player_path)
  self.destroyer_king_name_text = self:AddComponent(UIText, fake_name_text_path)
  self.no_king = self:AddComponent(UIBaseContainer, no_king_path)
  self.king = self:AddComponent(UIBaseContainer, king_path)
  self.no_king_icon = self:AddComponent(UIImage, no_king_icon_path)
end

function DestroyerKingCell:OnDestroy()
  self.destroyer_king_player = nil
  self.destroyer_king_name_text = nil
  self.destroyer_king = nil
  base.OnDestroy(self)
end

function DestroyerKingCell:ReInit(serverId, buildingId, config, info)
  self.serverId, self.buildingId, self.config = serverId, buildingId, config
  self.no_king_icon:LoadSpriteAsync(config.icon)
  self.destroyer_king_title:SetLocalText(config.name)
  if info and not string.IsNullOrEmpty(info.uid) then
    local presidentName = UIUtil.FormatServerAllianceName(info.serverId, info.abbr, info.name, info.uid)
    self.destroyer_king_name_text:SetText(presidentName)
    self.destroyer_king_player:ParseHeadInfo(info)
    self.king:SetActive(true)
    self.no_king:SetActive(false)
  else
    self.king:SetActive(false)
    self.no_king:SetActive(true)
  end
end

return DestroyerKingCell
