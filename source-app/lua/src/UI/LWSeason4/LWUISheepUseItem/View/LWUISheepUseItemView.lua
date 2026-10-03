local base = UIBaseView
local LWUISheepUseItemView = BaseClass("LWUISheepUseItemView", base)
local LWUISheepIUseItem = require("UI.LWSeason4.LWUISheepUseItem.Component.LWUISheepIUseItem")
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local item_use1_path = "Center/item_use1"
local item_use2_path = "Center/item_use2"
local btn_not_use_path = "btn_not_use"

function LWUISheepUseItemView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:Refresh()
end

function LWUISheepUseItemView:OnDestroy()
  self.engine = nil
  self.parent = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUISheepUseItemView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.item_use1 = self:AddComponent(LWUISheepIUseItem, item_use1_path)
  self.item_use2 = self:AddComponent(LWUISheepIUseItem, item_use2_path)
  self.btn_not_use = self:AddComponent(UIButton, btn_not_use_path)
  self.close_btn:SetOnClick(BindCallback(self, self.OnBackClick))
  self.btn_not_use:SetOnClick(BindCallback(self, self.OnBackClick))
end

function LWUISheepUseItemView:ComponentDestroy()
  self.close_btn = nil
  self.item_use1 = nil
  self.item_use2 = nil
  self.btn_not_use = nil
end

function LWUISheepUseItemView:OnBackClick()
  self.ctrl:CloseSelf()
  EventManager:GetInstance():Broadcast(EventId.SeasonSheepCloseUseItem)
end

function LWUISheepUseItemView:Refresh()
  self.parent = self:GetUserData()
  self.engine = self.parent.engine
  local canShow = self.engine:CanUseItem(SheepGameOpType.Move)
  self.item_use1:SetActive(canShow)
  if canShow then
    self.item_use1:SetData(self.engine:GetItemIdByType(SheepGameOpType.Move), SheepGameOpType.Move, self)
  end
  canShow = self.engine:CanUseItem(SheepGameOpType.Back)
  self.item_use2:SetActive(canShow)
  if canShow then
    self.item_use2:SetData(self.engine:GetItemIdByType(SheepGameOpType.Back), SheepGameOpType.Back, self)
  end
end

function LWUISheepUseItemView:OnClickUse(itemType)
  if DataCenter.LWSheepDataManager:IsEnd() then
    UIUtil.ShowTipsId(370100)
    return
  end
  self.ctrl:CloseSelf()
  SFSNetwork.SendMessage(MsgDefines.LWSheepUseItem, itemType)
end

return LWUISheepUseItemView
