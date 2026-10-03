local UIActContinuePayLackPanelView = BaseClass("UIActContinuePayLackPanelView", UIBaseView)
local UIActContinuePayLackPanelItem = require("UI.UIActContinuePay.UIActContinuePayLackPanel.Component.UIActContinuePayLackPanelItem")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local title_path = "PopUpTitle/Common_img_title/titleText"
local return_btn_path = "panel"
local close_btn_path = "PopUpTitle/CloseBtn"
local scroll_view_path = "PopUpTitle/Common_bg_orange/Scroll View"
local desc_txt_path = "PopUpTitle/Common_bg_orange/DescText"

local function DoClosePanel(self)
  self.ctrl:CloseSelf()
end

function UIActContinuePayLackPanelView:OnCreate()
  base.OnCreate(self)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.title = self:AddComponent(UIText, title_path)
  self.title:SetLocalText("\231\188\186key")
  self.desc = self:AddComponent(UIText, desc_txt_path)
  self.desc:SetLocalText("\231\188\186key")
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    DoClosePanel(self)
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    DoClosePanel(self)
  end)
  self:SetData()
end

function UIActContinuePayLackPanelView:OnDestroy()
  self:ClearScroll()
  self.scroll_view = nil
  self.title = nil
  self.desc = nil
  self.close_btn = nil
  self.return_btn = nil
  base.OnDestroy(self)
end

function UIActContinuePayLackPanelView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnPayActivityTaskUpdated, self.SetData)
end

function UIActContinuePayLackPanelView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnPayActivityTaskUpdated, self.SetData)
  base.OnRemoveListener(self)
end

function UIActContinuePayLackPanelView:OnEnable()
  base.OnEnable(self)
end

function UIActContinuePayLackPanelView:OnDisable()
  base.OnDisable(self)
end

function UIActContinuePayLackPanelView:SetData()
  self.taskDataList = DataCenter.ContinuePayActivityManager:GetTaskList()
  self:ClearScroll()
  local count = #self.taskDataList
  self.scroll_view:SetTotalCount(count)
  if 0 < count then
    self.scroll_view:RefillCells()
  end
end

function UIActContinuePayLackPanelView:ClearScroll()
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIActContinuePayLackPanelItem)
end

function UIActContinuePayLackPanelView:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local item = self.scroll_view:AddComponent(UIActContinuePayLackPanelItem, itemObj)
  item:SetData(self.taskDataList[index].id)
end

function UIActContinuePayLackPanelView:OnDeleteCell(itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UIActContinuePayLackPanelItem)
end

return UIActContinuePayLackPanelView
