local UILWAlMemberOfficialMemberListItem = BaseClass("UILWAlMemberOfficialMemberListItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local rank_icon_path = "TitleContent/RankIcon"
local member_num_path = "TitleContent/MemberText"
local arrow_icon_path = "TitleContent/ArrowIcon"
local arrow_select_icon_path = "TitleContent/ArrowIconSelect"
local click_btn_path = "TitleContent"
local my_pos_icon_path = "TitleContent/MyPosIcon"
local divide_go_path = "Divide"
local tips_content_path = "TipsContent"
local tips_text_path = "TipsContent/TipsText"

function UILWAlMemberOfficialMemberListItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlMemberOfficialMemberListItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlMemberOfficialMemberListItem:ComponentDefine()
  self.rankIcon = self:AddComponent(UIImage, rank_icon_path)
  self.memberNum = self:AddComponent(UIText, member_num_path)
  self.arrowIcon = self:AddComponent(UIBaseContainer, arrow_icon_path)
  self.arrowSelectIcon = self:AddComponent(UIBaseContainer, arrow_select_icon_path)
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.clickBtn:SetOnClick(function()
    self:OnClick()
  end)
  self.my_pos_icon = self:AddComponent(UIBaseContainer, my_pos_icon_path)
  self.divideGo = self:AddComponent(UIBaseContainer, divide_go_path)
  if not IsNull(self.transform:Find(tips_content_path)) then
    self.tips_content = self:AddComponent(UIBaseContainer, tips_content_path)
    self.tips_text = self:AddComponent(UITextMeshProUGUIEx, tips_text_path)
  end
end

function UILWAlMemberOfficialMemberListItem:ComponentDestroy()
  self.rankIcon = nil
  self.memberNum = nil
  self.arrowIcon = nil
  self.arrowSelectIcon = nil
  self.clickBtn = nil
  self.divideGo = nil
  self.my_pos_icon = nil
  self.tips_content = nil
  self.tips_text = nil
end

function UILWAlMemberOfficialMemberListItem:DataDefine()
  self.data = nil
  self.showMember = nil
  self.r4MemberSurplusNum = 0
end

function UILWAlMemberOfficialMemberListItem:DataDestroy()
  self.data = nil
  self.showMember = nil
  self.r4MemberSurplusNum = nil
end

function UILWAlMemberOfficialMemberListItem:OnEnable()
  base.OnEnable(self)
end

function UILWAlMemberOfficialMemberListItem:OnDisable()
  base.OnDisable(self)
end

function UILWAlMemberOfficialMemberListItem:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlMemberOfficialMemberListItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAlMemberOfficialMemberListItem:SetData(data, parent, isTitle)
  self.data = data
  self.parent = parent
  self.isTitle = isTitle
  self:RefreshContent()
end

function UILWAlMemberOfficialMemberListItem:RefreshContent()
  local rank = self.data.rankId
  self.showMember = self.data.showMember
  self.rankIcon:LoadSprite(LWAlMemberRankParam[rank].Icon)
  self.memberNum:SetLocalText(455062, self.data.onlineNum, self.data.allNum)
  local isMyRank = DataCenter.AllianceBaseDataManager:GetSelfRank() == rank
  self.my_pos_icon:SetActive(isMyRank)
  if self.data.rankId then
    local r4MemberMaxNum = DataCenter.AllianceMemberDataManager:GetR4MaxMemberNum()
    local curNum = self.data.originAllNum
    self.r4MemberSurplusNum = r4MemberMaxNum - curNum
  end
  self:JudgeShowMember()
end

function UILWAlMemberOfficialMemberListItem:OnClick()
  self.showMember = not self.showMember
  self.parent:SetRankGroupShowMember(self.data.rankId, self.showMember)
end

function UILWAlMemberOfficialMemberListItem:JudgeShowMember()
  if self.isTitle then
    self.divideGo:SetActive(false)
    self.arrowIcon:SetActive(false)
    self.arrowSelectIcon:SetActive(true)
  elseif self.showMember then
    self.divideGo:SetActive(self.data.allNum <= 0)
    self.arrowIcon:SetActive(false)
    self.arrowSelectIcon:SetActive(true)
  else
    self.divideGo:SetActive(false)
    self.arrowIcon:SetActive(true)
    self.arrowSelectIcon:SetActive(false)
  end
  self:RefreshShowR4MemberTips()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

function UILWAlMemberOfficialMemberListItem:RefreshShowR4MemberTips()
  if self.tips_content then
    if self.data.rankId == 4 then
      self.tips_content:SetActive(self.r4MemberSurplusNum > 0 and self.showMember and not self.isTitle)
      if self.r4MemberSurplusNum > 0 then
        self.tips_text:SetLocalText("alliance_memberlist_needmoreR4", self.r4MemberSurplusNum)
      end
    else
      self.tips_content:SetActive(false)
    end
  end
end

return UILWAlMemberOfficialMemberListItem
