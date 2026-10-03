local UISandWormHistoryView = BaseClass("UISandWormHistoryView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local SandWormHistoryItem = require("UI.UISandWormHunt.UISandWormHistory.Component.SandWormHistoryItem")
local panel_path = "panel"
local close_btn_path = "Root/Common_img_title/CloseBtn"
local no_log_txt_path = "Root/MiddleContent/noLogTxt"
local scroll_view_path = "Root/MiddleContent/ScrollView"

function UISandWormHistoryView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:Refresh()
  DataCenter.SandWormHuntDataManager:FetchHistoryData()
end

function UISandWormHistoryView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISandWormHistoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SandWormHistoryRefresh, self.Refresh)
end

function UISandWormHistoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.SandWormHistoryRefresh, self.Refresh)
  base.OnRemoveListener(self)
end

function UISandWormHistoryView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.no_log_txt = self:AddComponent(UITextMeshProUGUIEx, no_log_txt_path)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_view_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
end

function UISandWormHistoryView:ComponentDestroy()
  self:ClearScroll()
  self.dataList = nil
  self.close_btn = nil
  self.no_log_txt = nil
  self.scroll_view = nil
  self.content = nil
end

function UISandWormHistoryView:Refresh()
  self.dataList = DataCenter.SandWormHuntDataManager:GetSandWormHistory()
  local dataCount = #self.dataList
  if 0 < dataCount then
    self.no_log_txt:SetActive(false)
    self.ScrollView:SetActive(true)
    self.ScrollView:SetTotalCount(dataCount)
    self.ScrollView:RefillCells()
  else
    self.no_log_txt:SetActive(true)
    self.ScrollView:SetActive(false)
  end
end

function UISandWormHistoryView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(SandWormHistoryItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(index, self.dataList[index])
  end
end

function UISandWormHistoryView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, SandWormHistoryItem)
end

function UISandWormHistoryView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(SandWormHistoryItem)
end

return UISandWormHistoryView
