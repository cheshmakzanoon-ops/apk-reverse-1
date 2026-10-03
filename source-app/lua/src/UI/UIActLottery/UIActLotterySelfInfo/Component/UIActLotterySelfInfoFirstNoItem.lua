local base = UIBaseContainer
local UIActLotterySelfInfoFirstNoItem = BaseClass("UIActLotterySelfInfoFirstNoItem", UIBaseContainer)
local no_val_path = "NoVal"

function UIActLotterySelfInfoFirstNoItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActLotterySelfInfoFirstNoItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActLotterySelfInfoFirstNoItem:ComponentDefine()
  self.no_val = self:AddComponent(UITextMeshProUGUIEx, no_val_path)
end

function UIActLotterySelfInfoFirstNoItem:ComponentDestroy()
  self.no_val = nil
end

function UIActLotterySelfInfoFirstNoItem:DataDefine()
end

function UIActLotterySelfInfoFirstNoItem:DataDestroy()
end

function UIActLotterySelfInfoFirstNoItem:OnAddListener()
  base.OnAddListener(self)
end

function UIActLotterySelfInfoFirstNoItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActLotterySelfInfoFirstNoItem:SetData(data)
  self.data = data
  self.no_val:SetText(data.tickerNumber)
end

return UIActLotterySelfInfoFirstNoItem
