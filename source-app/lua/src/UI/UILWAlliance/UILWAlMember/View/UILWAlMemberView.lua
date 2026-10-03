local UILWAlMemberView = BaseClass("UILWAlMemberView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local Leader = require("UI.UILWAlliance.UILWAlMember.Component.UILWAlMemberLeader")
local OffcialItem = require("UI.UILWAlliance.UILWAlMember.Component.UILWAlMemberOffcialItem")
local MemberListItem = require("UI.UILWAlliance.UILWAlMember.Component.UILWAlMemberListItemNew")
local MemberItem = require("UI.UILWAlliance.UILWAlMember.Component.UILWAlMemberItemNew")
local UILWAlMemberOfficialTipPanel = require("UI.UILWAlliance.UILWAlMember.Component.UILWAlMemberOfficialTipPanel")
local UILWAlMemberFeaturePanel = require("UI.UILWAlliance.UILWAlMember.Component.UILWAlMemberFeaturePanel")
local title_text_path = "Root/TopBar/TextTitle"
local return_btn_path = "Root/BottomBar/BtnBack"
local leader_content_path = "Root/MiddleContentContainer/Leader"
local offcial_content_path = "Root/MiddleContentContainer/Official"
local member_list_content_path = "Root/MiddleContentContainer/ScrollView/Viewport/Content"
local scroll_view_path = "Root/MiddleContentContainer/ScrollView"
local TITLE_TXT = 393017
local content_title_root_path = "Root/MiddleContentContainer/ScrollView/Viewport/TitleContent"
local find_input_field_path = "Root/MiddleContentContainer/Find/FindInputField"
local find_clear_btn_path = "Root/MiddleContentContainer/Find/FindClearBtn"
local empty_panel_path = "Root/MiddleContentContainer/EmptyPanel"
local empty_text_path = "Root/MiddleContentContainer/EmptyPanel/EmptyText"

local function RefreshMemberListData(self)
  local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if data then
    local tempAlId = data.uid
    SFSNetwork.SendMessage(MsgDefines.AlRank, tempAlId)
  end
end

function UILWAlMemberView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  RefreshMemberListData(self)
  self:SetModifyGroupBtn()
end

function UILWAlMemberView:OnDestroy()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlMemberView:ComponentDefine()
  self.titleText = self:AddComponent(UIText, title_text_path)
  self.titleText:SetLocalText(TITLE_TXT)
  self.closeBtn = self:AddComponent(UIButton, return_btn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.leaderContent = self:AddComponent(Leader, leader_content_path)
  self.offcialContent = self:AddComponent(UIBaseContainer, offcial_content_path)
  self.offcialList = {}
  for i = 1, #LWAlMemberShowOffcial do
    self.offcialList[i] = self:AddComponent(OffcialItem, offcial_content_path .. "/OfficialItem" .. i)
    self.offcialList[i]:SetData(LWAlMemberShowOffcial[i])
  end
  self.content_title_root = self:AddComponent(MemberListItem, content_title_root_path)
  self.content_title_root:SetActive(false)
  self.find_input_field = self:AddComponent(UIInput, find_input_field_path)
  self.find_input_field:SetText("")
  self.find_input_field:SetOnValueChange(function(value)
    self:SearchIptOnValueChange(value)
  end)
  self.find_clear_btn = self:AddComponent(UIButton, find_clear_btn_path)
  self.find_clear_btn:SetOnClick(function()
    self.find_input_field:SetText("")
  end)
  self.find_clear_btn:SetActive(false)
  self.scroll_rect = self:AddComponent(UIScrollRect, scroll_view_path)
  self.scroll_view = self:AddComponent(UILoopListView2, scroll_view_path)
  self.scroll_view:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.scroll_rect:AddValueChangeListener(function()
    self:OnScrollValueChange()
  end)
  self.content = self:AddComponent(UIBaseContainer, member_list_content_path)
  self.empty_content = self:AddComponent(UIBaseComponent, empty_panel_path)
  self.empty_text = self:AddComponent(UITextMeshProUGUIEx, empty_text_path)
  self.empty_content:SetActive(false)
  self.tipPanel = self:AddComponent(UILWAlMemberOfficialTipPanel, "Root/TipPanel")
  self.tipPanelBtn = self:AddComponent(UIButton, "Root/TipPanel")
  self.tipPanelBtn:SetActive(false)
  self.tipPanelBtn:SetOnClick(function()
    self:CloseTipPanel()
  end)
  self.featurePanel = self:AddComponent(UILWAlMemberFeaturePanel, "Root/BottomBar/FeatureBtnPanel/FeaturePanel")
  self.featurePanel:SetActive(false)
  self.modifyGroupPanel = self:AddComponent(UIBaseComponent, "Root/BottomBar/FeatureBtnPanel/ModifyGroupPanel")
  self.modifyGroupBtn = self:AddComponent(UIButton, "Root/BottomBar/FeatureBtnPanel/ModifyGroupPanel/ModifyGroupBtn")
  self.modifyGroupBtn:SetOnClick(function()
    self:OpenModifyGroupPopup()
  end)
  self.modifyGroupBtnText = self:AddComponent(UIText, "Root/BottomBar/FeatureBtnPanel/ModifyGroupPanel/ModifyGroupBtn/LW_Btn_Common_New_Base/ModifyGroupBtnText")
  self.modifyGroupBtnText:SetLocalText("alliance_rankEdit_btn_edit")
  self.modifyGroupPanel:SetActive(false)
end

function UILWAlMemberView:ComponentDestroy()
  self.titleText = nil
  self.closeBtn = nil
  self.leaderContent = nil
  self.offcialContent = nil
  for i = 1, #LWAlMemberShowOffcial do
    self.offcialList[i] = nil
  end
  self.offcialList = nil
  self.memberContent = nil
  self.find_input_field = nil
  self.find_clear_btn = nil
  self.empty_content = nil
  self.empty_text = nil
  self.tipPanel = nil
  self.tipPanelBtn = nil
  self.featurePanel = nil
  self.modifyGroupPanel = nil
  self.modifyGroupBtn = nil
end

function UILWAlMemberView:DataDefine()
  self.ctrl:SetView(self)
  self.searchInputValue = nil
  self.rankGroupShowMember = {}
  for i = 1, 4 do
    self.rankGroupShowMember[i] = false
  end
  self.needOpenRank = DataCenter.AllianceBaseDataManager:GetSelfRank()
end

function UILWAlMemberView:DataDestroy()
  self.searchInputValue = nil
  self.rankGroupShowMember = nil
  self.fromSearch = nil
  self.needOpenRank = nil
  self.ctrl:ClearView()
end

function UILWAlMemberView:OnEnable()
  base.OnEnable(self)
end

function UILWAlMemberView:OnDisable()
  base.OnDisable(self)
end

function UILWAlMemberView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceMember, self.Refresh)
  self:AddUIListener(EventId.AlLeaderVoteStatusChange, self.Refresh)
end

function UILWAlMemberView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceMember, self.Refresh)
  self:RemoveUIListener(EventId.AlLeaderVoteStatusChange, self.Refresh)
end

function UILWAlMemberView:OnScrollValueChange()
  if self.updating or self.showDatalist == nil then
    self.content_title_root:SetActive(false)
    return
  end
  local showListItemData
  for i, v in ipairs(self.showDatalist) do
    local item = self.scroll_view:GetShownItemByItemIndex(i - 1)
    if item and self.scroll_view:GetItemCornerPosInViewPort(item).y < -58 then
      break
    end
    if v.type == "AlMemberListItem" and self:GetRankGroupShowMember(v.rankId) then
      showListItemData = v
    end
  end
  if showListItemData then
    self.content_title_root:SetData(showListItemData, true)
    self.content_title_root:SetActive(true)
  else
    self.content_title_root:SetActive(false)
  end
end

function UILWAlMemberView:Refresh()
  if self.needOpenRank then
    self:SetRankGroupShowMember(self.needOpenRank, true)
    self.needOpenRank = nil
  else
    self:RefreshContent()
  end
  self:RefreshFeaturePanel()
end

function UILWAlMemberView:RefreshContent()
  local leaderInfo = self.ctrl:GetLeaderInfo()
  self.updating = true
  self.topGroupNode = nil
  self.content_title_root:SetActive(false)
  self.leaderContent:RefreshContent(leaderInfo)
  if not leaderInfo or not leaderInfo.isSelfAlliance then
    self.offcialContent:SetActive(false)
  else
    self.offcialContent:SetActive(true)
    for i = 1, #LWAlMemberShowOffcial do
      self.offcialList[i]:RefreshContent()
    end
  end
  self.showDatalist = self.ctrl:GetAllShowData(self.rankGroupShowMember, self.searchInputValue, self.fromSearch)
  if #self.showDatalist > 0 then
    self.empty_content:SetActive(false)
    self.scroll_view:SetActive(true)
    self.scroll_view:SetListItemCount(#self.showDatalist, false, false)
    self.scroll_view:RefreshAllShownItem()
  else
    self.empty_content:SetActive(true)
    self.scroll_view:SetActive(false)
  end
  self.updating = false
  self:OnScrollValueChange()
end

function UILWAlMemberView:SearchIptOnValueChange(value)
  self.find_clear_btn:SetActive(not string.IsNullOrEmpty(value))
  self.searchInputValue = value
  self.fromSearch = true
  self:RefreshContent()
  self.fromSearch = false
end

function UILWAlMemberView:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.showDatalist then
    return nil
  end
  local data = self.showDatalist[index]
  local prefabName = self:GetItemPrefabName(index)
  local itemScript = self:GetItemScript(index)
  local item = loopScroll:NewListViewItem(prefabName)
  local script = self.content:GetComponent(item.gameObject.name, itemScript)
  if script == nil then
    local objectName = UIUtil.GetLoopListItemIndex()
    item.gameObject.name = objectName
    script = self.content:AddComponent(itemScript, objectName)
  end
  script:SetActive(true)
  script:SetData(data)
  return item
end

function UILWAlMemberView:GetItemPrefabName(index)
  if self.showDatalist[index].type == "AlMemberListItem" then
    return "AlMemberListItem"
  else
    return "AlMemberItem"
  end
end

function UILWAlMemberView:GetItemScript(index)
  if self.showDatalist[index].type == "AlMemberListItem" then
    return MemberListItem
  else
    return MemberItem
  end
end

function UILWAlMemberView:ClearScroll()
  self.content:RemoveComponents(MemberListItem)
  self.content:RemoveComponents(MemberItem)
  self.scroll_view:ClearAllItems()
  self.showDatalist = {}
end

function UILWAlMemberView:SetRankGroupShowMember(rank, showMember)
  self.rankGroupShowMember[rank] = showMember
  self:RefreshContent()
end

function UILWAlMemberView:GetRankGroupShowMember(rank)
  return self.rankGroupShowMember[rank]
end

function UILWAlMemberView:ShowTipPanel(type, onlyShowRemove, pos)
  self.tipPanelBtn:SetActive(true)
  self.tipPanel:SetData(type, onlyShowRemove, pos)
end

function UILWAlMemberView:CloseTipPanel()
  self.tipPanelBtn:SetActive(false)
end

function UILWAlMemberView:RefreshFeaturePanel()
  local show, openTime = DataCenter.AllianceFeatureManager:GetMemberFeatureShowAndOpenTime()
  if show then
    self.featurePanel:SetActive(true)
    self.featurePanel:Refresh(openTime)
  else
    self.featurePanel:SetActive(false)
  end
end

function UILWAlMemberView:SetModifyGroupBtn()
  if not DataCenter.AllianceMemberDataManager:CheckIsRankEditSwitch() then
    self.modifyGroupPanel:SetActive(false)
    return
  end
  local rank_edit_limit_config = LuaEntry.DataConfig:TryGetStr("alliance_rankEdit", "k1", "")
  local edit_limit_config = string.split(rank_edit_limit_config, ";")
  local minGiftLevel = tonumber(edit_limit_config[1]) or 5
  if minGiftLevel > DataCenter.AllianceGiftDataManager:GetCurLevel() or not DataCenter.AllianceBaseDataManager:IsR5() then
    self.modifyGroupPanel:SetActive(false)
  else
    self.modifyGroupPanel:SetActive(true)
  end
end

function UILWAlMemberView:OpenModifyGroupPopup()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlModifyGroup)
end

return UILWAlMemberView
