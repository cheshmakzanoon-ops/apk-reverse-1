local UIActContinuePayRewardNoticePanelView = BaseClass("UIActContinuePayRewardNoticePanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local title_path = "PopUpTitle/Common_img_title/titleText"
local return_btn_path = "panel"
local close_btn_path = "PopUpTitle/CloseBtn"
local scroll_view_path = "PopUpTitle/Scroll View"

local function DoClosePanel(self)
  self.ctrl:CloseSelf()
end

function UIActContinuePayRewardNoticePanelView:OnCreate()
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
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    DoClosePanel(self)
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    DoClosePanel(self)
  end)
  DataCenter.ContinuePayActivityManager:RequestRewardPreview()
  self:SetData()
end

function UIActContinuePayRewardNoticePanelView:OnDestroy()
  self:ClearScroll()
  self.title = nil
  self.close_btn = nil
  self.return_btn = nil
  self.desc = nil
  self.scroll_view = nil
  base.OnDestroy(self)
end

function UIActContinuePayRewardNoticePanelView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnGetActivityPayRewardPreview, self.Refresh)
end

function UIActContinuePayRewardNoticePanelView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnGetActivityPayRewardPreview, self.Refresh)
end

function UIActContinuePayRewardNoticePanelView:Refresh(rewardList)
  self.rewardDataList = rewardList
  self:SetData()
end

function UIActContinuePayRewardNoticePanelView:OnEnable()
  base.OnEnable(self)
end

function UIActContinuePayRewardNoticePanelView:OnDisable()
  base.OnDisable(self)
end

function UIActContinuePayRewardNoticePanelView:SetData()
  if not table.IsNullOrEmpty(self.rewardDataList) then
    self:ClearScroll()
    local count = #self.rewardDataList
    self.scroll_view:SetTotalCount(count)
    if 0 < count then
      self.scroll_view:RefillCells()
    end
  end
end

function UIActContinuePayRewardNoticePanelView:ClearScroll()
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UICommonResItem)
end

function UIActContinuePayRewardNoticePanelView:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local item = self.scroll_view:AddComponent(UICommonResItem, itemObj)
  local data = self.rewardDataList[index].reward[1]
  local reward = {
    rewardType = data.type,
    count = data.value.num,
    itemId = data.value.id
  }
  item:ReInit(reward)
end

function UIActContinuePayRewardNoticePanelView:OnDeleteCell(itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UICommonResItem)
end

return UIActContinuePayRewardNoticePanelView
