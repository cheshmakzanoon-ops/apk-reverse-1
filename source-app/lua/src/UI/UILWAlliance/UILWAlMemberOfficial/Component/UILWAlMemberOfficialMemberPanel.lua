local base = UIBaseContainer
local UILWAlMemberOfficialMemberPanel = BaseClass("UILWAlMemberOfficialMemberPanel", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UILWAlMemberOfficialMemberListItem = require("UI.UILWAlliance.UILWAlMemberOfficial.Component.UILWAlMemberOfficialMemberListItem")
local UILWAlMemberOfficialMemberItem = require("UI.UILWAlliance.UILWAlMemberOfficial.Component.UILWAlMemberOfficialMemberItem")

function UILWAlMemberOfficialMemberPanel:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlMemberOfficialMemberPanel:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlMemberOfficialMemberPanel:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.scrollView = self.viewSkin:AddComponent(self, UILoopListView2, 1)
  self.textTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnAppoint = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnAppoint:SetOnClick(function()
    self:OnBtnAppointClick()
  end)
  self.textAppointBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.content = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.compTitleContent = self.viewSkin:AddComponent(self, UILWAlMemberOfficialMemberListItem, 6)
  self.scrollRect = self.viewSkin:AddComponent(self, UIScrollRect, 7)
  self.scrollView:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.scrollRect:AddValueChangeListener(function()
    self:OnScrollValueChange()
  end)
  self.textAppointBtn:SetLocalText("alliance_officer_btn_appointment")
  self.textTip:SetLocalText("alliance_officer_tips_select")
end

function UILWAlMemberOfficialMemberPanel:ComponentDestroy()
  self.viewSkin = nil
  self.scrollView = nil
  self.textTip = nil
  self.btnAppoint = nil
  self.textAppointBtn = nil
  self.content = nil
  self.compTitleContent = nil
  self.scrollRect = nil
end

function UILWAlMemberOfficialMemberPanel:DataDefine()
  self.rankGroupShowMember = {}
  for i = 1, 4 do
    self.rankGroupShowMember[i] = false
  end
  self.firstShowMax = true
end

function UILWAlMemberOfficialMemberPanel:DataDestroy()
  self.rankGroupShowMember = nil
  self.firstShowMax = false
end

function UILWAlMemberOfficialMemberPanel:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlMemberOfficialMemberPanel:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAlMemberOfficialMemberPanel:OnBtnAppointClick()
  local selectInfo = self.view:GetSelectInfo()
  if selectInfo == nil or string.IsNullOrEmpty(selectInfo.uid) then
    return
  end
  local k1 = DataCenter.AllianceMemberDataManager:GetR4MaxMemberNum()
  local list, onlineNum = DataCenter.AllianceMemberDataManager:GetAllianceMemberListByRank(4)
  if #list == k1 and 4 > selectInfo.rank then
    UIUtil.ShowTips(Localization:GetString("455163", "R4"))
    return
  end
  if self.view.type then
    SFSNetwork.SendMessage(MsgDefines.AllianceSetRank, selectInfo.uid, 4, self.view.type)
    self.view.ctrl:CloseSelf()
  end
end

function UILWAlMemberOfficialMemberPanel:OnScrollValueChange()
  if self.updating or self.showDatalist == nil then
    self.compTitleContent:SetActive(false)
    return
  end
  local showListItemData
  for i, v in ipairs(self.showDatalist) do
    local item = self.scrollView:GetShownItemByItemIndex(i - 1)
    if item and self.scrollView:GetItemCornerPosInViewPort(item).y < -58 then
      break
    end
    if v.type == "AlMemberListItem" and self:GetRankGroupShowMember(v.rankId) then
      showListItemData = v
    end
  end
  if showListItemData then
    self.compTitleContent:SetData(showListItemData, self, true)
    self.compTitleContent:SetActive(true)
  else
    self.compTitleContent:SetActive(false)
  end
end

function UILWAlMemberOfficialMemberPanel:Refresh(noRefreshData)
  self:RefreshContent(noRefreshData)
end

function UILWAlMemberOfficialMemberPanel:RefreshContent(noRefreshData)
  self.updating = true
  if not noRefreshData then
    self.showDatalist = self.view.ctrl:GetAllShowData(self.rankGroupShowMember, nil, nil, self.firstShowMax)
    self.firstShowMax = false
  end
  if self.showDatalist and #self.showDatalist > 0 then
    self.scrollView:SetActive(true)
    self.scrollView:SetListItemCount(#self.showDatalist, false, false)
    self.scrollView:RefreshAllShownItem()
  end
  local selectInfo = self.view:GetSelectInfo()
  if selectInfo then
    self.textTip:SetActive(false)
    self.btnAppoint:SetActive(true)
  else
    self.textTip:SetActive(true)
    self.btnAppoint:SetActive(false)
  end
  self.updating = false
  self:OnScrollValueChange()
end

function UILWAlMemberOfficialMemberPanel:OnGetItemByIndex(loopScroll, index)
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
  script:SetData(data, self)
  return item
end

function UILWAlMemberOfficialMemberPanel:GetItemPrefabName(index)
  if self.showDatalist[index].type == "AlMemberListItem" then
    return "AlMemberListItem"
  else
    return "AlMemberItem"
  end
end

function UILWAlMemberOfficialMemberPanel:GetItemScript(index)
  if self.showDatalist[index].type == "AlMemberListItem" then
    return UILWAlMemberOfficialMemberListItem
  else
    return UILWAlMemberOfficialMemberItem
  end
end

function UILWAlMemberOfficialMemberPanel:ClearScroll()
  self.content:RemoveComponents(UILWAlMemberOfficialMemberListItem)
  self.content:RemoveComponents(UILWAlMemberOfficialMemberItem)
  self.scrollView:ClearAllItems()
  self.showDatalist = {}
end

function UILWAlMemberOfficialMemberPanel:SetRankGroupShowMember(rank, showMember)
  self.rankGroupShowMember[rank] = showMember
  self:RefreshContent()
end

function UILWAlMemberOfficialMemberPanel:GetRankGroupShowMember(rank)
  return self.rankGroupShowMember[rank]
end

return UILWAlMemberOfficialMemberPanel
