local UILWAlMemberOffcialItem = BaseClass("UILWAlMemberOffcialItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local icon_path = ""
local offcial_name_path = "OffcialName"
local player_go_path = "Head/PlayerBtn/UIPlayerHead"
local player_icon_path = "Head/PlayerBtn/UIPlayerHead"
local player_name_path = "PlayerName"
local empty_icon_path = "Head/PlayerBtn/EmptyIcon"
local empty_text_path = "EmptyText"
local click_btn_path = "ClickBtn"
local EMPTY_TXT = 391071

function UILWAlMemberOffcialItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlMemberOffcialItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlMemberOffcialItem:ComponentDefine()
  self.offcialIcon = self:AddComponent(UIImage, icon_path)
  self.offcialName = self:AddComponent(UIText, offcial_name_path)
  self.playerGo = self:AddComponent(UIButton, player_go_path)
  self.playerGo:SetOnClick(function()
    self:OnClick()
  end)
  self.playerIcon = self:AddComponent(UICommonHead, player_icon_path)
  self.playerName = self:AddComponent(UIText, player_name_path)
  self.emptyIcon = self:AddComponent(UIBaseContainer, empty_icon_path)
  self.emptyText = self:AddComponent(UIText, empty_text_path)
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.clickBtn:SetOnClick(function()
    self:OnClick()
  end)
  self.emptyText:SetLocalText(EMPTY_TXT)
end

function UILWAlMemberOffcialItem:ComponentDestroy()
  self.offcialIcon = nil
  self.offcialName = nil
  self.playerGo = nil
  self.playerIcon = nil
  self.playerName = nil
  self.emptyIcon = nil
  self.emptyText = nil
  self.clickBtn = nil
end

function UILWAlMemberOffcialItem:DataDefine()
  self.type = 0
  self.memberInfo = {}
end

function UILWAlMemberOffcialItem:DataDestroy()
  self.type = nil
  self.memberInfo = nil
end

function UILWAlMemberOffcialItem:OnEnable()
  base.OnEnable(self)
end

function UILWAlMemberOffcialItem:OnDisable()
  base.OnDisable(self)
end

function UILWAlMemberOffcialItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnAllianceOfficialPosChange, self.RefreshContent)
end

function UILWAlMemberOffcialItem:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnAllianceOfficialPosChange, self.RefreshContent)
end

function UILWAlMemberOffcialItem:SetData(type)
  self.type = type
end

function UILWAlMemberOffcialItem:RefreshContent()
  self.offcialName:SetLocalText(LWAlMemberOffcialParam[self.type].Text)
  self.offcialIcon:LoadSprite(LWAlMemberOffcialParam[self.type].Icon)
  self.memberInfo = DataCenter.AllianceMemberDataManager:GetMemberInfoByOfficialPos(self.type)
  if self.memberInfo then
    self.emptyIcon:SetActive(false)
    self.playerGo:SetActive(true)
    self.clickBtn:SetActive(false)
    self.playerIcon:SetData(self.memberInfo.uid, self.memberInfo.pic, self.memberInfo.picVer, nil, self.memberInfo:GetHeadBgImg())
    self.emptyText:SetActive(false)
    self.playerName:SetActive(true)
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.memberInfo.uid, self.memberInfo.name)
    self.playerName:SetText(showName)
  else
    self.emptyIcon:SetActive(true)
    self.playerGo:SetActive(false)
    self.clickBtn:SetActive(true)
    self.emptyText:SetActive(true)
    self.playerName:SetActive(false)
  end
end

function UILWAlMemberOffcialItem:OnClick()
  if DataCenter.AllianceBaseDataManager:IsR5() then
    if self.memberInfo then
      self.view:ShowTipPanel(self.type, false, self:GetPosition())
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlMemberOfficial, {anim = true}, self.type)
    end
  elseif self.memberInfo then
    if self.memberInfo.uid == LuaEntry.Player.uid then
      self.view:ShowTipPanel(self.type, true, self:GetPosition())
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.memberInfo.uid)
    end
  else
    UIUtil.ShowTipsId("alliance_officer_tips_notLeader")
  end
end

return UILWAlMemberOffcialItem
