local UILWPowerHistoryView = BaseClass("UILWPowerHistoryView", UIBaseView)
local base = UIBaseView
local theHistoryData = {}
local UILWPowerHistoryItem = require("UI.LWSeason4.UILWPowerHistory.Component.UILWPowerHistoryItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local scroll_view_path = "PopUpTitle/ScrollView"
local content_path = "PopUpTitle/ScrollView/Viewport/Content"
local empty_path = "PopUpTitle/Empty"
local loading_path = "PopUpTitle/loading"

function UILWPowerHistoryView:OnCreate()
  base.OnCreate(self)
  self.ConvertList = nil
  self.items = {}
  self:ComponentDefine()
  if table.count(theHistoryData) > 0 then
    self:OnHistoryData(nil)
  else
    self.loading:SetActive(true)
    self.empty:SetActive(false)
    self.ScrollView:SetActive(false)
  end
  SFSNetwork.SendMessage(MsgDefines.FetchSeasonLightHouseHistory, 0, 100)
end

function UILWPowerHistoryView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWPowerHistoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonLightHouseHistory, self.OnHistoryData)
end

function UILWPowerHistoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonLightHouseHistory, self.OnHistoryData)
  base.OnRemoveListener(self)
end

function UILWPowerHistoryView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("season_s4_building_ui_info50")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.ScrollView = self:AddComponent(UIScrollView, scroll_view_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.empty = self:AddComponent(UITextMeshProUGUIEx, empty_path)
  self.loading = self:AddComponent(UIImage, loading_path)
end

function UILWPowerHistoryView:ComponentDestroy()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(UILWPowerHistoryItem)
  self.btn_back = nil
end

function UILWPowerHistoryView:OnHistoryData(t)
  local hasNewData = false
  if t and t.pageNum and t.pageSize and t.list then
    for k, v in pairs(t.list) do
      if theHistoryData[v.eventTime] == nil then
        hasNewData = true
        theHistoryData[v.eventTime] = v
      end
    end
    if #t.list >= t.pageSize then
      SFSNetwork.SendMessage(MsgDefines.FetchSeasonLightHouseHistory, t.pageNum + 1, 100)
    end
    if not hasNewData and self.dataList ~= nil then
      return
    end
  end
  local dataList = {}
  for k, v in pairs(theHistoryData) do
    table.insert(dataList, v)
  end
  local dataCount = #dataList
  if 0 < dataCount then
    table.sort(dataList, function(a, b)
      return a.eventTime > b.eventTime
    end)
    self.dataList = dataList
    self.empty:SetActive(false)
    self.loading:SetActive(false)
    self.ScrollView:SetActive(true)
    self.ScrollView:SetTotalCount(dataCount)
    self.ScrollView:RefillCells()
  else
    self.empty:SetActive(true)
    self.ScrollView:SetActive(false)
    self.loading:SetActive(false)
  end
end

function UILWPowerHistoryView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(UILWPowerHistoryItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(index, self.dataList[index])
  end
end

function UILWPowerHistoryView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, UILWPowerHistoryItem)
end

function UILWPowerHistoryView:GetScrollItem(listview, index)
  local dataList = self.dataList
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local csItem = listview:NewListViewItem("HistoryItem")
  if self.items[csItem] == nil then
    local nameStr = "HistoryItem" .. UIUtil.GetLoopListItemIndex()
    csItem.gameObject.name = nameStr
    self.items[csItem] = self.content:AddComponent(UILWPowerHistoryItem, nameStr)
  end
  if self.items[csItem] ~= nil then
    self.items[csItem]:ReInit(index, dataList[index])
  end
  return csItem
end

return UILWPowerHistoryView
