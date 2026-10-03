local UIScratchOffRecordPageView = BaseClass("UIScratchOffRecordPageView", UIBaseView)
local base = UIBaseView
local ScratchOffRecordItem = require("UI.UIScratchOffRecordPage.Comp.ScratchOffRecordItem")
local titleTxt_path = "UICommonPopUpTitle/Common_img_title/titleText"
local closeBtn_path = "UICommonPopUpTitle/CloseBtn"
local panel_path = "UICommonPopUpTitle/panel"
local noRecordTxt_path = "Root/noRecordTxt"
local scrollView_Path = "Root/ScrollView"

function UIScratchOffRecordPageView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function UIScratchOffRecordPageView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIScratchOffRecordPageView:OnEnable()
  base.OnEnable(self)
  self.activityId = tonumber(self:GetUserData())
  SFSNetwork.SendMessage(MsgDefines.GetScratchOffGameRewardRecord, self.activityId)
end

function UIScratchOffRecordPageView:DataDefine()
  self.itemInfoList = {}
end

function UIScratchOffRecordPageView:DataDestroy()
  self.itemInfoList = nil
end

function UIScratchOffRecordPageView:ComponentDefine()
  self.titleTxt = self:AddComponent(UIText, titleTxt_path)
  self.noRecordTxt = self:AddComponent(UIText, noRecordTxt_path)
  self.noRecordTxt:SetLocalText(302233)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.panelBtn = self:AddComponent(UIButton, panel_path)
  self.panelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.ScrollView = self:AddComponent(UIScrollView, scrollView_Path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
end

function UIScratchOffRecordPageView:ComponentDestroy()
  self.titleTxt = nil
  self.closeBtn = nil
  self.panelBtn = nil
  self.ScrollView = nil
  self.noRecordTxt = nil
end

function UIScratchOffRecordPageView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local item = self.ScrollView:AddComponent(ScratchOffRecordItem, itemObj)
  item:SetData(self.itemInfoList[index])
end

function UIScratchOffRecordPageView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, ScratchOffRecordItem)
end

function UIScratchOffRecordPageView:RefreshView()
  self.itemInfoList = self.ctrl:GetItemInfoList(self.activityId)
  if self.itemInfoList and #self.itemInfoList > 0 then
    self.ScrollView:SetTotalCount(#self.itemInfoList)
    self.ScrollView:RefillCells()
    self.ScrollView:ScrollToCell(1)
    self.noRecordTxt:SetActive(false)
  else
    self.noRecordTxt:SetActive(true)
  end
end

function UIScratchOffRecordPageView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ScratchOffGameRewardRecordInfoUpdate, self.RefreshView)
end

function UIScratchOffRecordPageView:OnRemoveListener()
  self:RemoveUIListener(EventId.ScratchOffGameRewardRecordInfoUpdate, self.RefreshView)
  base.OnRemoveListener(self)
end

return UIScratchOffRecordPageView
