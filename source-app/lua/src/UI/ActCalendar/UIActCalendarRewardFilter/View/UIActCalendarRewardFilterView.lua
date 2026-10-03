local UIActCalendarRewardFilterView = BaseClass("UIActCalendarRewardFilterView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ActCalendarPropsItem = require("UI.ActCalendar.Component.ActCalendarPropsItem")

function UIActCalendarRewardFilterView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

function UIActCalendarRewardFilterView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActCalendarRewardFilterView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.propsScrollView = self.viewSkin:AddComponent(self, GridInfinityScrollView, 3)
  self.textSearchBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textDetailTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.btnSearch = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnSearch:SetOnClick(function()
    self:OnBtnSearchClick()
  end)
  self.textDetailDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textDetailTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.propsScrollContent = self:AddComponent(UIBaseContainer, "root/rewardNode/rewardScrollVew/rewardScrollVewContent")
  self.propsScrollView:SetAnchoredPositionXY(0, 0)
end

function UIActCalendarRewardFilterView:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.btnClose = nil
  self.propsScrollView = nil
  self.textSearchBtn = nil
  self.textDetailTips = nil
  self.btnSearch = nil
  self.textDetailDesc = nil
  self.textDetailTitle = nil
  self.btnPanel = nil
end

function UIActCalendarRewardFilterView:DataDefine()
  self.listGO = {}
  self.propsList = {}
end

function UIActCalendarRewardFilterView:DataDestroy()
  self.listGO = nil
  self.propsList = nil
  self:_clearItemCell()
end

function UIActCalendarRewardFilterView:_clearItemCell()
  self.propsScrollContent:RemoveComponents(ActCalendarPropsItem)
  self.propsScrollView:DestroyChildNode()
end

function UIActCalendarRewardFilterView:OnAddListener()
  base.OnAddListener(self)
end

function UIActCalendarRewardFilterView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActCalendarRewardFilterView:ReInit()
  self.propsList = DataCenter.ActCalendarManager:GetAllProps()
  if not self.propsList then
    Logger.LogError("propsList \230\178\161\230\156\137\230\149\176\230\141\174\229\149\138 ")
    return
  end
  self:_initScroll()
  self:_refreshList()
end

function UIActCalendarRewardFilterView:_initScroll()
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.propsScrollView:Init(bindFunc1, bindFunc2, bindFunc3)
end

function UIActCalendarRewardFilterView:_refreshList()
  local propsCount = 0
  if self.propsList then
    propsCount = #self.propsList
  end
  self.propsScrollView:SetItemCount(propsCount)
end

function UIActCalendarRewardFilterView:_onPropsItemClick(propsItem, props)
  if not propsItem or not props then
    return
  end
  if self.curSelectItem and self.curSelectProps and self.curSelectProps.itemId ~= props.itemId then
    self.curSelectItem:SetSelectFrameVisible(false)
  end
  self.curSelectItem = propsItem
  self.curSelectProps = props
  self.curSelectItem:SetSelectFrameVisible(true)
  if Localization:HasKey(props.itemName) then
    self.textDetailTitle:SetLocalText(props.itemName)
  else
    self.textDetailTitle:SetText(props.itemName)
  end
  if Localization:HasKey(props.itemDesc) then
    self.textDetailDesc:SetLocalText(props.itemDesc)
  else
    self.textDetailDesc:SetText(props.itemDesc)
  end
end

function UIActCalendarRewardFilterView:OnInitScroll(go, index)
  local item = self.propsScrollContent:AddComponent(ActCalendarPropsItem, go)
  self.listGO[go] = item
  item:SetSelectFrameVisible(false)
  item:SetClickHandler(function(propsItem, propsData)
    self:_onPropsItemClick(propsItem, propsData)
  end)
  if self.curSelectItem == nil and index == 1 then
    self:_onPropsItemClick(item, self.propsList[1])
  end
end

function UIActCalendarRewardFilterView:OnUpdateScroll(go, index)
  local reward = self.propsList[index + 1]
  if reward == nil then
    return
  end
  go.name = "item_" .. reward.itemId
  local cellItem = self.listGO[go]
  if not cellItem then
    return
  end
  local props = self.propsList[index + 1]
  cellItem:SetLocalScaleXYZ(1, 1, 1)
  cellItem:SetData(props)
  if self.curSelectProps then
    cellItem:SetSelectFrameVisible(self.curSelectProps.itemId == props.itemId)
  end
end

function UIActCalendarRewardFilterView:OnDestroyScrollItem(go, index)
end

function UIActCalendarRewardFilterView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIActCalendarRewardFilterView:OnBtnSearchClick()
  EventManager:GetInstance():Broadcast(EventId.ActCalendarPropsFilter, self.curSelectProps)
  self.ctrl:CloseSelf()
end

function UIActCalendarRewardFilterView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

return UIActCalendarRewardFilterView
