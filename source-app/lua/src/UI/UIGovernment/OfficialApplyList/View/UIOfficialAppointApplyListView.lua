local UIOfficialAppointApplyListView = BaseClass("UIOfficialAppointApplyListView", UIBaseView)
local UIOfficialApplyCell = require("UI.UIGovernment.OfficialApplyList.Component.UIOfficialApplyCell")
local base = UIBaseView
local OfficialApplyManager = DataCenter.OfficialApplyManager
local list_panel_path = "Root/Content/ContentHolder/ListPanel"
local list_num_text_path = "Root/Content/ContentHolder/ListPanel/ListTextPanel/ListNumText"
local maxApplyNum

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btnPanel = self:AddComponent(UIButton, "Panel")
  self.btnPanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btnClose = self:AddComponent(UIButton, "Root/Content/UICommonPopBg/bg_3/CloseBtn")
  self.btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.compNonePanel = self:AddComponent(UIBaseContainer, "Root/Content/ContentHolder/NonePanel")
  self.scrollView = self:AddComponent(UIScrollRect, "Root/Content/ContentHolder/ListPanel/ScrollView")
  self.scrollContent = self:AddComponent(GridInfinityScrollView, "Root/Content/ContentHolder/ListPanel/ScrollView/Content")
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.applyCellList = {}
  self.scrollContent:Init(bindFunc1, bindFunc2, bindFunc3)
  self.list_panel = self:AddComponent(UIBaseContainer, list_panel_path)
  self.list_num_text = self:AddComponent(UITextMeshProUGUIEx, list_num_text_path)
  self.tipText = self:AddComponent(UIText, "Root/Content/ContentHolder/TipText")
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.btnPanel = nil
  self.btnClose = nil
  self.scrollView = nil
  self.compContent = nil
  self.compNonePanel = nil
  self.scrollContent = nil
  self.tipText = nil
end

local function DataDefine(self)
  local positionId, serverId = self:GetUserData()
  self.positionId = positionId
  self.serverId = serverId
  maxApplyNum = OfficialApplyManager.GetMaxApplyNum(self)
  self.applyList = nil
  self:RefreshAll(self.positionId)
  self.isCtrl = OfficialApplyManager:IsManager(self.serverId)
  DataCenter.GovernmentManager:SendKingdomPositionAutoAgreeGet()
end

local function DataDestroy(self)
  self.positionId = nil
  self.applyList = nil
  self.isCtrl = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OfficialApplyListRefresh, self.RefreshApplyList)
  self:AddUIListener(EventId.KingdomPositionInfoUpdate, self.OnPresidentInfoUpdate)
  self:AddUIListener(EventId.OfficialGetAutoAgreeInfo, self.OnOfficialGetAutoAgreeInfo)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.OfficialApplyListRefresh, self.RefreshApplyList)
  self:RemoveUIListener(EventId.KingdomPositionInfoUpdate, self.OnPresidentInfoUpdate)
  self:RemoveUIListener(EventId.OfficialGetAutoAgreeInfo, self.OnOfficialGetAutoAgreeInfo)
  base.OnRemoveListener(self)
end

local function ClearScroll(self)
  self.scrollView:RemoveComponents(UIOfficialApplyCell)
  self.scrollContent:DestroyChildNode()
end

local function RefreshAll(self, positionId)
  if self.positionId ~= positionId then
    return
  end
  local index = OfficialApplyManager:GetApplyListOwnIndex(self.positionId)
  self:RefreshApplyList({positionId = positionId, moveIndex = index})
  self:OnOfficialGetAutoAgreeInfo()
end

local function RefreshApplyList(self, param)
  local positionId = param.positionId
  if positionId ~= self.positionId then
    return
  end
  local moveIndex = param.moveIndex
  local num = 0
  self.applyDataList = OfficialApplyManager:GetApplyList(positionId)
  if self.applyDataList and 0 < #self.applyDataList then
    self.list_panel:SetActive(true)
    self.compNonePanel:SetActive(false)
    self.scrollContent:SetItemCount(#self.applyDataList)
    if moveIndex then
      self.scrollContent:MoveItemByIndex(moveIndex - 1)
    end
    num = #self.applyDataList
  else
    self.list_panel:SetActive(false)
    self.compNonePanel:SetActive(true)
  end
  self.list_num_text:SetText(string.format("[%s/%s]", num, maxApplyNum))
end

local function OnInitScroll(self, go, index)
  local item = self.scrollView:AddComponent(UIOfficialApplyCell, go)
  item.name = tostring("UIOfficialApplyCell" .. index)
  self.applyCellList[go] = item
end

local function OnUpdateScroll(self, go, index)
  if self.applyDataList == nil or self.applyDataList[index + 1] == nil then
    go:SetActive(false)
    return
  end
  local sub = self.applyDataList[index + 1]
  local cellItem = self.applyCellList[go]
  go:SetActive(true)
  cellItem:SetData(self.positionId, sub, self.serverId)
end

local function OnDestroyScrollItem(self, go, index)
end

local function OnPresidentInfoUpdate(self)
  local isCtrl = OfficialApplyManager:IsManager(self.serverId)
  if self.isCtrl and not isCtrl then
    self:RefreshApplyList({
      positionId = self.positionId
    })
  end
  self.isCtrl = isCtrl
end

local function OnOfficialGetAutoAgreeInfo(self)
  if DataCenter.GovernmentManager:GetAutoAgreeShow() then
    if tonumber(self.positionId) == 10002 then
      self.tipText:SetActive(false)
    else
      self.tipText:SetActive(true)
      local autoAgreeInfo = DataCenter.GovernmentManager:GetKingdomPositionAutoAgreeInfo()
      if autoAgreeInfo and autoAgreeInfo.autoAgree then
        self.tipText:SetLocalText("officer_apply_058")
      else
        self.tipText:SetLocalText("officer_apply_059")
      end
    end
  else
    self.tipText:SetActive(false)
  end
end

UIOfficialAppointApplyListView.OnCreate = OnCreate
UIOfficialAppointApplyListView.OnDestroy = OnDestroy
UIOfficialAppointApplyListView.OnEnable = OnEnable
UIOfficialAppointApplyListView.OnDisable = OnDisable
UIOfficialAppointApplyListView.ComponentDefine = ComponentDefine
UIOfficialAppointApplyListView.ComponentDestroy = ComponentDestroy
UIOfficialAppointApplyListView.DataDefine = DataDefine
UIOfficialAppointApplyListView.DataDestroy = DataDestroy
UIOfficialAppointApplyListView.OnAddListener = OnAddListener
UIOfficialAppointApplyListView.OnRemoveListener = OnRemoveListener
UIOfficialAppointApplyListView.ClearScroll = ClearScroll
UIOfficialAppointApplyListView.OnInitScroll = OnInitScroll
UIOfficialAppointApplyListView.OnUpdateScroll = OnUpdateScroll
UIOfficialAppointApplyListView.OnDestroyScrollItem = OnDestroyScrollItem
UIOfficialAppointApplyListView.RefreshAll = RefreshAll
UIOfficialAppointApplyListView.RefreshApplyList = RefreshApplyList
UIOfficialAppointApplyListView.OnPresidentInfoUpdate = OnPresidentInfoUpdate
UIOfficialAppointApplyListView.OnOfficialGetAutoAgreeInfo = OnOfficialGetAutoAgreeInfo
return UIOfficialAppointApplyListView
