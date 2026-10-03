local KingItem = BaseClass("KingItem", UIBaseContainer)
local base = UIBaseContainer
local king_detail_btn_path = "kingDetailBtn"
local no_king_path = "no_king"
local king_path = "king"
local player_path = "king/player"
local name_text_path = "king/NameText"
local title_path = "king/title"

function KingItem:OnCreate()
  base.OnCreate(self)
  self.no_king = self:AddComponent(UIBaseComponent, no_king_path)
  self.king_detail_btn = self:AddComponent(UIButton, king_detail_btn_path)
  self.king_detail_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentPresidentBuff, {anim = true}, 0, nil, self.serverId, self.curPresident)
  end)
  self.king_title = self:AddComponent(UIText, title_path)
  self.king = self:AddComponent(UIBaseComponent, king_path)
  self.king_player = self:AddComponent(UICommonHead, player_path)
  self.king_name_text = self:AddComponent(UIText, name_text_path)
  self.king_player:SetEnableClickShowInfo(false, false)
end

function KingItem:OnDestroy()
  self.no_king = nil
  self.king = nil
  self.king_player = nil
  self.king_name_text = nil
  base.OnDestroy(self)
end

function KingItem:ReInit(curPresident, serverId)
  self.serverId = serverId
  self.curPresident = curPresident
  if curPresident == nil or curPresident.uid == 0 or curPresident.uid == "" then
    curPresident = nil
  else
    local presidentName = UIUtil.FormatAllianceAndName(curPresident.allianceAbbr, curPresident.name, curPresident.uid)
    self.king_title:SetLocalText(457202)
    self.king_name_text:SetText(presidentName .. " Lv." .. curPresident.level)
    self.king_player:ParseHeadInfo(curPresident)
  end
  self.no_king:SetActive(curPresident == nil)
  self.king:SetActive(curPresident ~= nil)
end

return KingItem
