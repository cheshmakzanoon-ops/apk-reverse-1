local UILWAlMemberListItemNew = BaseClass("UILWAlMemberListItemNew", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local select_bg_path = "TitleContent/SelectedBgImg"
local normal_bg_path = "TitleContent/NormalBgImg"
local rank_icon_path = "TitleContent/RankIcon"
local list_name_path = "TitleContent/ListNameText"
local member_num_path = "TitleContent/MemberStatePanel/MemberText"
local arrow_icon_path = "TitleContent/ArrowIcon"
local arrow_select_icon_path = "TitleContent/ArrowIconSelect"
local click_btn_path = "TitleContent"
local divide_go_path = "Divide"
local tips_content_path = "TipsContent"
local tips_text_path = "TipsContent/TipsText"

function UILWAlMemberListItemNew:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlMemberListItemNew:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlMemberListItemNew:ComponentDefine()
  self.selectBgImg = self:AddComponent(UIImage, select_bg_path)
  self.normalBgImg = self:AddComponent(UIImage, normal_bg_path)
  self.rankIcon = self:AddComponent(UIImage, rank_icon_path)
  self.listNameText = self:AddComponent(UIText, list_name_path)
  self.memberNum = self:AddComponent(UIText, member_num_path)
  self.arrowIcon = self:AddComponent(UIBaseContainer, arrow_icon_path)
  self.arrowSelectIcon = self:AddComponent(UIBaseContainer, arrow_select_icon_path)
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.clickBtn:SetOnClick(function()
    self:OnClick()
  end)
  self.divideGo = self:AddComponent(UIBaseContainer, divide_go_path)
  if not IsNull(self.transform:Find(tips_content_path)) then
    self.tips_content = self:AddComponent(UIBaseContainer, tips_content_path)
    self.tips_text = self:AddComponent(UITextMeshProUGUIEx, tips_text_path)
  end
  self.tagBg = self:AddComponent(UIImage, "TitleContent/MemberStatePanel/TagBg")
  self.tagText = self:AddComponent(UIText, "TitleContent/MemberStatePanel/TagBg/TagText")
  self.tagText:SetLocalText("alliance_member_desc_inactive")
end

function UILWAlMemberListItemNew:ComponentDestroy()
  self.rankIcon = nil
  self.memberNum = nil
  self.arrowIcon = nil
  self.arrowSelectIcon = nil
  self.clickBtn = nil
  self.divideGo = nil
  self.tips_content = nil
  self.tips_text = nil
  self.tagBg = nil
  self.tagText = nil
end

function UILWAlMemberListItemNew:DataDefine()
  self.data = nil
  self.showMember = nil
  self.r4MemberSurplusNum = 0
end

function UILWAlMemberListItemNew:DataDestroy()
  self.data = nil
  self.showMember = nil
  self.r4MemberSurplusNum = nil
end

function UILWAlMemberListItemNew:OnEnable()
  base.OnEnable(self)
end

function UILWAlMemberListItemNew:OnDisable()
  base.OnDisable(self)
end

function UILWAlMemberListItemNew:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceRefreshMemberHonorState, self.OnAllianceRefreshMemberHonorState)
end

function UILWAlMemberListItemNew:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceRefreshMemberHonorState, self.OnAllianceRefreshMemberHonorState)
  base.OnRemoveListener(self)
end

function UILWAlMemberListItemNew:SetData(data, isTitle)
  self.data = data
  self.isTitle = isTitle
  self:RefreshContent()
end

function UILWAlMemberListItemNew:RefreshContent()
  local rank = self.data.rankId
  self.showMember = self.data.showMember
  self.rankIcon:LoadSprite(LWAlMemberRankParam[rank].Icon)
  if DataCenter.AllianceMemberDataManager:CheckIsRankEditSwitch() then
    self.listNameText:SetText(DataCenter.AllianceMemberDataManager:GetAllianceRankNameByRank(rank))
    self.listNameText:SetActive(true)
  else
    self.listNameText:SetActive(false)
  end
  local isMyRank = DataCenter.AllianceBaseDataManager:GetSelfRank() == rank
  self.selectBgImg:SetActive(isMyRank)
  self.normalBgImg:SetActive(not isMyRank)
  local numTextFormat = isMyRank and "<color=#5FEF87>%d</color>/%d" or "<color=#15D1FF>%d</color>/%d"
  self.memberNum:SetText(string.format(numTextFormat, self.data.onlineNum, self.data.allNum))
  if self.data.rankId then
    local r4MemberMaxNum = DataCenter.AllianceMemberDataManager:GetR4MaxMemberNum()
    local curNum = self.data.originAllNum
    self.r4MemberSurplusNum = r4MemberMaxNum - curNum
  end
  self:JudgeShowMember()
  self:RefreshTag()
end

function UILWAlMemberListItemNew:OnClick()
  self.showMember = not self.showMember
  self.view:SetRankGroupShowMember(self.data.rankId, self.showMember)
end

function UILWAlMemberListItemNew:JudgeShowMember()
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

function UILWAlMemberListItemNew:RefreshShowR4MemberTips()
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

function UILWAlMemberListItemNew:RefreshTag()
  self.tagBg:SetActive(DataCenter.AllianceMemberDataManager:NeedShowInactiveTag(self.data.rankId))
end

function UILWAlMemberListItemNew:OnAllianceRefreshMemberHonorState(uid)
  local memberInfo = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(uid)
  if memberInfo and memberInfo.rank == self.data.rankId then
    self:RefreshTag()
  end
end

return UILWAlMemberListItemNew
