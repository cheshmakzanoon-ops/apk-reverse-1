local UIWorldOccupyHistoryView = BaseClass("UIWorldOccupyHistoryView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIWorldOccupyHistoryItem = require("UI.LWWorld.UIWorldOccupyHistory.Component.UIWorldOccupyHistoryItem")
local panel_path = "panel"
local close_btn_path = "Root/Common_img_title/CloseBtn"
local no_log_txt_path = "Root/MiddleContent/noLogTxt"
local scroll_view_path = "Root/MiddleContent/ScrollView"

function UIWorldOccupyHistoryView:OnCreate()
  base.OnCreate(self)
  self.dataList = {}
  self.uuid = self:GetUserData()
  self:ComponentDefine()
  self:UpdateData()
  SFSNetwork.SendMessage(MsgDefines.GetCityOccupyHistoryList, self.uuid)
end

function UIWorldOccupyHistoryView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWorldOccupyHistoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CrossKingOccupyHistoryListRefresh, self.UpdateData)
end

function UIWorldOccupyHistoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.CrossKingOccupyHistoryListRefresh, self.UpdateData)
  base.OnRemoveListener(self)
end

function UIWorldOccupyHistoryView:ComponentDefine()
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

function UIWorldOccupyHistoryView:ComponentDestroy()
  self:ClearScroll()
  self.close_btn = nil
  self.no_log_txt = nil
  self.scroll_view = nil
  self.content = nil
end

function UIWorldOccupyHistoryView:UpdateData()
  self:ClearScroll()
  local data = DataCenter.ZoneWarManager:GetOccupyHistoryList(self.uuid)
  local dataCount = data and #data or 0
  self.dataList = data
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

function UIWorldOccupyHistoryView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(UIWorldOccupyHistoryItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(index, self.dataList[index])
  end
end

function UIWorldOccupyHistoryView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, UIWorldOccupyHistoryItem)
end

function UIWorldOccupyHistoryView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(UIWorldOccupyHistoryItem)
end

return UIWorldOccupyHistoryView
