local UIBFBaseSelectUserItem = BaseClass("UIBFBaseSelectUserItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local rank_icon_path = "TitleContent/RankIcon"
local icon0_path = "TitleContent/Icon0"
local icon_text0_path = "TitleContent/IconText0"
local icon_text1_path = "TitleContent/IconText1"
local icon_text2_path = "TitleContent/IconText2"
local arrow_icon_path = "TitleContent/ArrowIcon"
local arrow_icon_select_path = "TitleContent/ArrowIcon/ArrowIconSelect"
local member_text_path = "TitleContent/MemberText"
local title_content_path = "TitleContent"

function UIBFBaseSelectUserItem:OnCreate()
  base.OnCreate(self)
  self.isCommanderModuleEnable = self.view.ctrl:IsCommanderModuleEnable()
  self.rank_icon = self:AddComponent(UIImage, rank_icon_path)
  self.icon_text1 = self:AddComponent(UIText, icon_text1_path)
  self.icon_text2 = self:AddComponent(UIText, icon_text2_path)
  self.arrow_icon = self:AddComponent(UIImage, arrow_icon_path)
  self.arrow_icon_select = self:AddComponent(UIImage, arrow_icon_select_path)
  self.member_text = self:AddComponent(UIText, member_text_path)
  self.title_content = self:AddComponent(UIButton, title_content_path)
  if self.isCommanderModuleEnable then
    self.icon0 = self:TryAddComponent(UIBaseComponent, icon0_path)
    self.icon_text0 = self:TryAddComponent(UIText, icon_text0_path)
    if self.icon0 then
      self.icon0:SetActive(true)
    end
    if self.icon_text0 then
      self.icon_text0:SetActive(true)
    end
  end
  self.title_content:SetOnClick(function()
    self:OnClick()
  end)
end

function UIBFBaseSelectUserItem:SetData(data)
  self.data = data
  self.rank = data.rankId
  self.selfRank = DataCenter.AllianceBaseDataManager:GetSelfRank()
  self:RefreshContent()
end

function UIBFBaseSelectUserItem:RefreshContent()
  if self.data == nil then
    return
  end
  self.rank_icon:LoadSprite("Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_r" .. self.rank .. ".png")
  self.member_text:SetLocalText(455062, self.data.onlineNum or 0, self.data.allNum or 0)
  self.icon_text1:SetText(tostring(self.data.mainCount or 0))
  self.icon_text2:SetText(tostring(self.data.subCount or 0))
  if self.isCommanderModuleEnable and self.icon_text0 then
    self.icon_text0:SetText(tostring(self.data.comCount or 0))
  end
  local expand = self.data.showMember == true
  self.arrow_icon_select:SetActive(expand)
end

function UIBFBaseSelectUserItem:OnClick()
  if self.data == nil then
    return
  end
  local showMember = self.data.showMember ~= true
  self.view:SetRankGroupShowMember(self.rank, showMember)
end

function UIBFBaseSelectUserItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BattlefieldPlayerListUpdate, self.UpdateData)
end

function UIBFBaseSelectUserItem:OnRemoveListener()
  self:RemoveUIListener(EventId.BattlefieldPlayerListUpdate, self.UpdateData)
  base.OnRemoveListener(self)
end

function UIBFBaseSelectUserItem:OnDestroy()
  base.OnDestroy(self)
end

function UIBFBaseSelectUserItem:FocusTo(uid)
  self.view:FocusTo(uid)
end

function UIBFBaseSelectUserItem:SetPlayerCommander(uid, bCommander)
  return self.view:SetPlayerCommander(uid, bCommander)
end

function UIBFBaseSelectUserItem:SetPlayerState(uid, state)
  self.view:SetPlayerState(uid, state)
end

function UIBFBaseSelectUserItem:UpdateData()
  if self.data and self.data.rankId then
    local titleData = self.view:GetRankTitleData(self.data.rankId)
    if titleData then
      self:SetData(titleData)
    end
  end
end

function UIBFBaseSelectUserItem:UpdateOnlineAndRankTotalNum()
  self:UpdateData()
end

function UIBFBaseSelectUserItem:RefreshRankByFilterCondition(targetExpandRankData)
  local filterBattleTimeData = self.view.ctrl:GetFilterBattleTimeData()
  if filterBattleTimeData == nil then
    self.view:SetRankGroupShowMember(self.rank, self.selfRank == self.rank)
  elseif targetExpandRankData then
    self.view:SetRankGroupShowMember(self.rank, self.rank == targetExpandRankData.targetExpandRank)
  end
end

return UIBFBaseSelectUserItem
