local UIS0AllianceBossBuildRecordView = BaseClass("UIS0AllianceBossBuildRecordView", UIBaseView)
local UIS0AllianceBossBuildRecordItem = require("UI.UIS0AllianceBoss.Component.UIS0AllianceBossBuildRecordItem")
local S0AllianceBossDonateInfo = require("DataCenter.ActS0AllianceBoss.S0AllianceBossDonateInfo")
local base = UIBaseView

function UIS0AllianceBossBuildRecordView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function UIS0AllianceBossBuildRecordView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIS0AllianceBossBuildRecordView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnMask = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnMask:SetOnClick(function()
    self:OnBtnMaskClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compNodeRecord = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.textNodeNone = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.scrollView = self.viewSkin:AddComponent(self, UIScrollView, 6)
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function UIS0AllianceBossBuildRecordView:ComponentDestroy()
  self:ClearScroll()
  self.viewSkin = nil
  self.btnMask = nil
  self.textTitle = nil
  self.btnClose = nil
  self.compNodeRecord = nil
  self.textNodeNone = nil
  self.scrollView = nil
end

function UIS0AllianceBossBuildRecordView:DataDefine()
end

function UIS0AllianceBossBuildRecordView:DataDestroy()
end

function UIS0AllianceBossBuildRecordView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnS0AllianceBossDonateRecordGot, self.RefreshView)
end

function UIS0AllianceBossBuildRecordView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnS0AllianceBossDonateRecordGot, self.RefreshView)
  base.OnRemoveListener(self)
end

function UIS0AllianceBossBuildRecordView:InitView()
  DataCenter.S0AllianceBossDataManager:ReqDonateRecord()
  self.textTitle:SetLocalText("s0_alliance_boss_donate_nodata_title")
end

function UIS0AllianceBossBuildRecordView:RefreshView(message)
  local noInfo = true
  if message and message.donateList then
    local donateList = message.donateList
    local result = {}
    for i, v in ipairs(donateList) do
      local oneData = S0AllianceBossDonateInfo.New()
      oneData:ParseData(v)
      result[i] = oneData
    end
    if 0 < #result then
      self.compNodeRecord:SetActive(true)
      self.dataList = result
      self:ClearScroll()
      self.scrollView:SetTotalCount(#result)
      self.scrollView:RefillCells()
      noInfo = false
    end
  end
  self.textNodeNone:SetActive(noInfo)
  if noInfo then
    self.textNodeNone:SetLocalText("zone_mobilization_donated_no_data")
    self.compNodeRecord:SetActive(false)
  end
end

function UIS0AllianceBossBuildRecordView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(UIS0AllianceBossBuildRecordItem, itemObj)
  if cellItem ~= nil then
    local info = self.dataList[index]
    if info then
      cellItem:RefreshItem(info)
    end
  end
end

function UIS0AllianceBossBuildRecordView:OnItemMoveOut(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, UIS0AllianceBossBuildRecordItem)
end

function UIS0AllianceBossBuildRecordView:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UIS0AllianceBossBuildRecordItem)
end

function UIS0AllianceBossBuildRecordView:OnBtnMaskClick()
  self:OnBtnCloseClick()
end

function UIS0AllianceBossBuildRecordView:OnBtnCloseClick()
  if self.ctrl then
    self.ctrl:CloseSelf()
  end
end

return UIS0AllianceBossBuildRecordView
