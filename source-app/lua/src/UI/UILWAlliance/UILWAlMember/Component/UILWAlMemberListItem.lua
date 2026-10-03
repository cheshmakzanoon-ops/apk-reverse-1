local UILWAlMemberListItem = BaseClass("UILWAlMemberListItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local MemberItem = require("UI.UILWAlliance.UILWAlMember.Component.UILWAlMemberItem")
local MemeberAwardItem = require("UI.LWSeason.LWSeasonAwards.Component.UILWAllianceMemeberAwardItem")
local rank_icon_path = "TitleContent/RankIcon"
local member_num_path = "TitleContent/MemberText"
local arrow_icon_path = "TitleContent/ArrowIcon"
local arrow_select_icon_path = "TitleContent/ArrowIconSelect"
local click_btn_path = "TitleContent"
local my_pos_icon_path = "TitleContent/MyPosIcon"
local member_content_path = "MemberListContent"
local member_item_path = "UILWAlMemberItem"
local divide_go_path = "Divide"
local tips_content_path = "TipsContent"
local tips_text_path = "TipsContent/TipsText"

function UILWAlMemberListItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlMemberListItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlMemberListItem:ComponentDefine()
  self.rankIcon = self:AddComponent(UIImage, rank_icon_path)
  self.memberNum = self:AddComponent(UIText, member_num_path)
  self.arrowIcon = self:AddComponent(UIBaseContainer, arrow_icon_path)
  self.arrowSelectIcon = self:AddComponent(UIBaseContainer, arrow_select_icon_path)
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.clickBtn:SetOnClick(function()
    self:OnClick()
  end)
  self.my_pos_icon = self:AddComponent(UIBaseContainer, my_pos_icon_path)
  self.listContent = self:AddComponent(UIBaseContainer, member_content_path)
  self.listItemPrefab = self.transform:Find(member_item_path).gameObject
  self.listItemPrefab:GameObjectCreatePool()
  self.divideGo = self:AddComponent(UIBaseContainer, divide_go_path)
  if not IsNull(self.transform:Find(tips_content_path)) then
    self.tips_content = self:AddComponent(UIBaseContainer, tips_content_path)
    self.tips_text = self:AddComponent(UITextMeshProUGUIEx, tips_text_path)
  end
end

function UILWAlMemberListItem:ComponentDestroy()
  self.rankIcon = nil
  self.memberNum = nil
  self.arrowIcon = nil
  self.arrowSelectIcon = nil
  self.clickBtn = nil
  self.listContent = nil
  self.listItemPrefab = nil
  self.divideGo = nil
  self.my_pos_icon = nil
  self.tips_content = nil
  self.tips_text = nil
end

function UILWAlMemberListItem:DataDefine()
  self.type = 0
  self.memberType = nil
  self.showMember = nil
  self.r4MemberSurplusNum = 0
end

function UILWAlMemberListItem:DataDestroy()
  self.type = nil
  self.memberType = nil
  self.showMember = nil
  self.r4MemberSurplusNum = nil
end

function UILWAlMemberListItem:OnEnable()
  base.OnEnable(self)
end

function UILWAlMemberListItem:OnDisable()
  base.OnDisable(self)
end

function UILWAlMemberListItem:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlMemberListItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAlMemberListItem:SetData(type)
  self.type = type
end

function UILWAlMemberListItem:SetMemberType(type)
  self.memberType = type
end

function UILWAlMemberListItem:RefreshContent()
  local rank = self.type
  local list, onlineNum = self.view.ctrl:GetMemberAndOnlineNum(rank)
  self.rankIcon:LoadSprite(LWAlMemberRankParam[rank].Icon)
  self.memberNum:SetLocalText(455062, onlineNum, #list)
  local isMyRank = DataCenter.AllianceBaseDataManager:GetSelfRank() == rank
  if not self.showMember then
    self.showMember = isMyRank
  end
  self.my_pos_icon:SetActive(isMyRank)
  if self.type == 4 then
    local r4MemberMaxNum = DataCenter.AllianceMemberDataManager:GetR4MaxMemberNum()
    local curNum = table.count(list)
    self.r4MemberSurplusNum = r4MemberMaxNum - curNum
  end
  self:JudgeShowMember()
end

function UILWAlMemberListItem:OnClick()
  self.showMember = not self.showMember
  self:JudgeShowMember()
end

function UILWAlMemberListItem:JudgeShowMember()
  if self.showMember then
    self.divideGo:SetActive(false)
    self.listContent:SetActive(true)
    self.arrowIcon:SetActive(false)
    self.arrowSelectIcon:SetActive(true)
    self:RefreshMemberList()
  else
    self.divideGo:SetActive(true)
    self.listContent:SetActive(false)
    self.arrowIcon:SetActive(true)
    self.arrowSelectIcon:SetActive(false)
    self:ClearContent()
  end
  self:RefreshShowR4MemberTips()
end

function UILWAlMemberListItem:ClearContent()
  if self.memberType == nil or self.memberType == 1 then
    self.listContent:RemoveComponents(MemberItem)
  elseif self.memberType == 2 then
    self.listContent:RemoveComponents(MemeberAwardItem)
  end
end

function UILWAlMemberListItem:RefreshMemberList()
  self:ClearContent()
  self.listItemPrefab.gameObject:GameObjectRecycleAll()
  local list = self.view.ctrl:GetMemberListByRank(self.type)
  if list ~= nil and 0 < #list then
    for i = 1, table.length(list) do
      local item = self.listItemPrefab:GameObjectSpawn(self.listContent.transform)
      item.name = "item" .. i
      if self.memberType == nil or self.memberType == 1 then
        local cell = self.listContent:AddComponent(MemberItem, item.name)
        cell:SetData(list[i])
      elseif self.memberType == 2 then
        local cell = self.listContent:AddComponent(MemeberAwardItem, item.name)
        cell:SetData(list[i])
      end
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.listContent.rectTransform)
end

function UILWAlMemberListItem:RefreshShowR4MemberTips()
  if self.tips_content then
    if self.type == 4 then
      self.tips_content:SetActive(self.r4MemberSurplusNum > 0 and self.showMember)
      if self.r4MemberSurplusNum > 0 then
        self.tips_text:SetLocalText("alliance_memberlist_needmoreR4", self.r4MemberSurplusNum)
      end
    else
      self.tips_content:SetActive(false)
    end
  end
end

return UILWAlMemberListItem
