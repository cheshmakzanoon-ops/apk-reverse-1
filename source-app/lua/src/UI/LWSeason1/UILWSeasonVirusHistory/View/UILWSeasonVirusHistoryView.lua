local UILWSeasonVirusHistoryView = BaseClass("UILWSeasonVirusHistoryView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local HistoryItem = require("UI.LWSeason1.UILWSeasonVirusHistory.Component.UILWSeasonVirusHistoryItem")
local DetailItem = require("UI.LWSeason1.UILWSeasonVirusHistory.Component.UILWSeasonVirusDetailItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local scroll_view_path = "PopUpTitle/ScrollView"
local content_path = "PopUpTitle/ScrollView/Viewport/Content"

function UILWSeasonVirusHistoryView:OnCreate()
  base.OnCreate(self)
  self.dataList = {}
  self.items = {}
  self:ComponentDefine()
  self:UpdateData()
end

function UILWSeasonVirusHistoryView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonVirusHistoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGovernmentSkillUsedState, self.UpdateData)
end

function UILWSeasonVirusHistoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateGovernmentSkillUsedState, self.UpdateData)
  base.OnRemoveListener(self)
end

function UILWSeasonVirusHistoryView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("season_virus_name")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.ScrollView = self:AddComponent(UILoopListView2, scroll_view_path)
  self.ScrollView:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
end

function UILWSeasonVirusHistoryView:ComponentDestroy()
  self.items = {}
  self.content:RemoveComponents(UITextMeshProUGUIEx)
  self.content:RemoveComponents(DetailItem)
  self.content:RemoveComponents(HistoryItem)
  self.ScrollView:ClearAllItems()
  self.btn_back = nil
end

function UILWSeasonVirusHistoryView:UpdateData()
  self.dataList = {
    "Title1",
    "Desc",
    "Title2",
    "NoData"
  }
  self.ScrollView:SetListItemCount(#self.dataList, false, false)
  self.ScrollView:RefreshAllShownItem()
end

function UILWSeasonVirusHistoryView:TryGetScrollItem(listview, index)
  local dataList = self.dataList
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local csItem
  local data = dataList[index]
  local theScript
  if data == "Title1" or data == "Title2" or data == "NoData" then
    csItem = listview:NewListViewItem(data)
    theScript = UITextMeshProUGUIEx
  elseif data == "Desc" then
    csItem = listview:NewListViewItem(data)
    theScript = DetailItem
  else
    csItem = listview:NewListViewItem("HistoryItem")
    theScript = HistoryItem
  end
  if self.items[csItem] == nil then
    NameCount = NameCount + 1
    local nameStr = "Cell" .. NameCount
    csItem.gameObject.name = nameStr
    self.items[csItem] = self.content:AddComponent(theScript, nameStr)
  end
  if self.items[csItem] ~= nil then
    if data == "Desc" then
      self.items[csItem]:ReInit()
    elseif data == "Title1" or data == "Title2" or data == "NoData" then
    else
      self.items[csItem]:ReInit(data)
    end
  end
  return csItem
end

return UILWSeasonVirusHistoryView
