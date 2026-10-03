local UIConfiscateHistoryView = BaseClass("UIConfiscateHistoryView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ConfiscateHistoryItem = require("UI.UIFishing.UIConfiscateHistory.ConfiscateHistoryItem")
local panel_path = "panel"
local close_btn_path = "Root/Common_img_title/CloseBtn"
local no_log_txt_path = "Root/MiddleContent/noLogTxt"
local scroll_view_path = "Root/MiddleContent/ScrollView"

function UIConfiscateHistoryView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:Refresh()
  DataCenter.FishingDataManager:FetchConfiscateRecords()
end

function UIConfiscateHistoryView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIConfiscateHistoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshConfiscateHistory, self.Refresh)
end

function UIConfiscateHistoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshConfiscateHistory, self.Refresh)
  base.OnRemoveListener(self)
end

function UIConfiscateHistoryView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.no_log_txt = self:AddComponent(UIBaseComponent, no_log_txt_path)
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

function UIConfiscateHistoryView:ComponentDestroy()
  self:ClearScroll()
  self.dataList = nil
  self.close_btn = nil
  self.no_log_txt = nil
  self.scroll_view = nil
end

function UIConfiscateHistoryView:Refresh()
  self.dataList = DataCenter.FishingDataManager:GetConfiscateRecords()
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

function UIConfiscateHistoryView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(ConfiscateHistoryItem, itemObj)
  if cellItem ~= nil then
    cellItem:SetData(self.dataList[index])
  end
end

function UIConfiscateHistoryView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, ConfiscateHistoryItem)
end

function UIConfiscateHistoryView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(ConfiscateHistoryItem)
end

return UIConfiscateHistoryView
