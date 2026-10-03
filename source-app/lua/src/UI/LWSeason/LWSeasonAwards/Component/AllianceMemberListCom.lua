local AllianceMemberListCom = BaseClass("AllianceMemberListCom", UIScrollRect)
local base = UIScrollRect
local MemberListItem = require("UI.UILWAlliance.UILWAlMember.Component.UILWAlMemberListItem")
local content_title_root_path = "Viewport/TitleContent"
local content_title_rank_icon_path = "Viewport/TitleContent/RankIcon"
local content_title_my_pos_icon_path = "Viewport/TitleContent/MyPosIcon"
local content_title_arrow_icon_path = "Viewport/TitleContent/ArrowIcon"
local content_title_arrow_icon_select_path = "Viewport/TitleContent/ArrowIconSelect"
local content_title_member_text_path = "Viewport/TitleContent/MemberText"
local member_list_content_path = "Viewport/Content"

function AllianceMemberListCom:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:RefreshContent()
end

function AllianceMemberListCom:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllianceMemberListCom:ComponentDefine()
  self.rankMemberList = {}
  for i = 1, #LWAlMemberShowRank do
    self.rankMemberList[i] = self:AddComponent(MemberListItem, member_list_content_path .. "/AllianceMemberListItem" .. i)
    self.rankMemberList[i]:SetData(LWAlMemberShowRank[i])
    self.rankMemberList[i]:SetMemberType(2)
  end
  self.memberContent = self:AddComponent(UIBaseContainer, member_list_content_path)
  self.content_title_root = self:AddComponent(UIButton, content_title_root_path)
  self.content_title_rank_icon = self:AddComponent(UIImage, content_title_rank_icon_path)
  self.content_title_my_pos_icon = self:AddComponent(UIImage, content_title_my_pos_icon_path)
  self.content_title_arrow_icon = self:AddComponent(UIImage, content_title_arrow_icon_path)
  self.content_title_arrow_icon_select = self:AddComponent(UIImage, content_title_arrow_icon_select_path)
  self.content_title_member_text = self:AddComponent(UIText, content_title_member_text_path)
  self.content_title_root:SetActive(false)
  self.Updating = true
  self.topGroupNode = nil
  self:AddValueChangeListener(function(vec)
    self:OnScrollValueChange()
  end)
  self.content_title_root:SetOnClick(function()
    if self.topGroupNode then
      self.Updating = true
      self.topGroupNode:OnClick()
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.memberContent.rectTransform)
      self.Updating = false
      self:OnScrollValueChange()
    end
  end)
end

function AllianceMemberListCom:ComponentDestroy()
  for i = 1, #LWAlMemberShowRank do
    self.rankMemberList[i] = nil
  end
  self.rankMemberList = nil
  self.memberContent = nil
end

function AllianceMemberListCom:OnAddListener()
  base.OnAddListener(self)
end

function AllianceMemberListCom:OnRemoveListener()
  base.OnRemoveListener(self)
end

function AllianceMemberListCom:OnScrollValueChange()
  if self.Updating then
    self.content_title_root:SetActive(false)
    self.topGroupNode = nil
    return
  end
  local topNode
  local top = self.memberContent:GetAnchoredPositionY()
  local lastY = 0
  local count = #LWAlMemberShowRank
  for i = count, 1, -1 do
    topNode = self.rankMemberList[i]
    if topNode and topNode:GetActive() then
      local y = topNode:GetAnchoredPositionY() + top
      if 0 < y then
        if i ~= count and 0 < lastY + 65 then
          topNode = nil
        end
        break
      end
      lastY = y
    end
    topNode = nil
  end
  if topNode then
    self.content_title_root:SetActive(true)
    self.content_title_rank_icon:LoadSprite(topNode.rankIcon.spritePath)
    self.content_title_my_pos_icon:SetActive(topNode.my_pos_icon:GetActive())
    self.content_title_arrow_icon:SetActive(topNode.arrowIcon:GetActive())
    self.content_title_arrow_icon_select:SetActive(topNode.arrowSelectIcon:GetActive())
    self.content_title_member_text:SetText(topNode.memberNum:GetText())
  else
    self.content_title_root:SetActive(false)
  end
  self.topGroupNode = topNode
end

function AllianceMemberListCom:RefreshContent()
  self.Updating = true
  self.topGroupNode = nil
  self.content_title_root:SetActive(false)
  for i = #LWAlMemberShowRank, 1, -1 do
    self.rankMemberList[i]:RefreshContent()
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.memberContent.rectTransform)
  self.Updating = false
  self:OnScrollValueChange()
end

return AllianceMemberListCom
