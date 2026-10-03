local base = UIAsyncContainer
local ProfitFloatComponent = BaseClass("ProfitFloatComponent", UIAsyncContainer)
local Localization = CS.GameEntry.Localization

function ProfitFloatComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ProfitFloatComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ProfitFloatComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textFloatSell = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textFloatSellNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textFloatEarnNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textFloatSell:SetLocalText("activity_1200044_tips52", "")
end

function ProfitFloatComponent:ComponentDestroy()
  self.viewSkin = nil
  self.textFloatSell = nil
  self.textFloatSellNum = nil
  self.textFloatEarnNum = nil
end

function ProfitFloatComponent:DataDefine()
end

function ProfitFloatComponent:DataDestroy()
  self.data = nil
end

function ProfitFloatComponent:OnAddListener()
  base.OnAddListener(self)
end

function ProfitFloatComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ProfitFloatComponent:SetData(data)
  self.data = data
end

function ProfitFloatComponent:UpdateData()
  self.textFloatSellNum:SetText(self.data.soldNum)
  self.textFloatEarnNum:SetText(self.data.profit)
end

return ProfitFloatComponent
