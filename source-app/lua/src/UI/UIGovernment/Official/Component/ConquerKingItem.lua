local ConquerKingItem = BaseClass("ConquerKingItem", UIBaseContainer)
local base = UIBaseContainer
local fake_king_path = ""
local fake_player_path = "playerFake"
local fake_name_text_path = "NameTextFake"
local fake_title_path = "titleFake"

function ConquerKingItem:OnCreate()
  base.OnCreate(self)
  self.fake_king_title = self:AddComponent(UIText, fake_title_path)
  self.fake_king = self:AddComponent(UIButton, fake_king_path)
  self.fake_king:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentPresidentBuff, {anim = true}, 0, nil, self.srcServerId, self.fakePresident)
  end)
  self.fake_king_player = self:AddComponent(UICommonHead, fake_player_path)
  self.fake_king_name_text = self:AddComponent(UIText, fake_name_text_path)
  self.fake_king:SetActive(false)
end

function ConquerKingItem:OnDestroy()
  base.OnDestroy(self)
end

function ConquerKingItem:ReInit(serverId)
  self.serverId = serverId
  local fakePresidentInfo = DataCenter.GovernmentManager:GetDummyPresident(serverId)
  self.fakePresident = fakePresidentInfo
  if fakePresidentInfo then
    self.srcServerId = fakePresidentInfo.srcServerId
    local presidentName = UIUtil.FormatServerAllianceName(fakePresidentInfo.srcServerId, fakePresidentInfo.allianceAbbr, fakePresidentInfo.name, fakePresidentInfo.uid)
    self.fake_king_title:SetLocalText(801561)
    self.fake_king_name_text:SetText(presidentName)
    self.fake_king_player:ParseHeadInfo(fakePresidentInfo)
    self.fake_king:SetActive(true)
  else
    self.fake_king:SetActive(false)
  end
end

return ConquerKingItem
