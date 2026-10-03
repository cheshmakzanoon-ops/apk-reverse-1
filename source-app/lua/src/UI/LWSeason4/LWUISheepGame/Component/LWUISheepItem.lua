local base = UIBaseContainer
local LWUISheepItem = BaseClass("LWUISheepItem", base)
local UIGray = CS.UIGray
local text_count_path = "Text"
local btn_add_path = "BtnAdd"
local btn_remove_path = ""

function LWUISheepItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWUISheepItem:OnDestroy()
  self.itemType = nil
  self.itemId = nil
  self.parent = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUISheepItem:ComponentDefine()
  self.txt_count = self:AddComponent(UIText, text_count_path)
  self.btn_add = self:AddComponent(UIButton, btn_add_path)
  self.btn_use = self:AddComponent(UIButton, btn_remove_path)
  self.btn_use:SetOnClick(BindCallback(self, self.OnClickUse))
  self.btn_add:SetOnClick(BindCallback(self, self.OnClickAdd))
end

function LWUISheepItem:ComponentDestroy()
  self.txt_count = nil
  self.btn_click = nil
  self.btn_remove = nil
end

function LWUISheepItem:OnClickUse()
  if DataCenter.LWSheepDataManager:IsEnd() then
    UIUtil.ShowTipsId(370100)
    return
  end
  local itemCount = DataCenter.ItemData:GetItemCount(self.itemId)
  if itemCount == 0 then
    LWResourceLackUtil:GotoGoodsItemLack(self.itemId, 1)
    return
  end
  local isCanUse, tip = self.parent.engine:CanUseItem(self.itemType)
  if not isCanUse then
    UIUtil.ShowTipsId(tip)
    return
  end
  self.parent:OnUseItem(self)
end

function LWUISheepItem:OnClickAdd()
  LWResourceLackUtil:GotoGoodsItemLack(self.itemId, 1)
end

function LWUISheepItem:SetData(itemId, itemType, parent)
  self.itemId = itemId
  self.itemType = itemType
  self.parent = parent
  self:UpdateUI()
end

function LWUISheepItem:UpdateUI()
  local count = DataCenter.ItemData:GetItemCount(self.itemId) or 0
  self.txt_count:SetText(count)
  self:RefreshState()
end

function LWUISheepItem:RefreshState()
  local isCanUse = self.parent.engine:CanUseItem(self.itemType)
  UIGray.SetGray(self.btn_use.transform, not isCanUse, true, false)
end

return LWUISheepItem
