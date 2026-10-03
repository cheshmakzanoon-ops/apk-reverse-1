local base = UIAsyncContainer
local RecordDumpComponent = BaseClass("RecordDumpComponent", UIAsyncContainer)
local Localization = CS.GameEntry.Localization

function RecordDumpComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function RecordDumpComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function RecordDumpComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textProfit = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textServer = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textUnitPrice = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgLine = self.viewSkin:AddComponent(self, UIImage, 4)
  self.textProfitNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textSoldNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textSold = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textUnitPriceNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textSold:SetLocalText("activity_1200044_tips52", "")
  self.textUnitPrice:SetLocalText("activity_1200044_tips79")
  self.textProfit:SetLocalText("activity_1200044_tips54", "")
end

function RecordDumpComponent:ComponentDestroy()
  self.viewSkin = nil
  self.textProfit = nil
  self.textServer = nil
  self.textUnitPrice = nil
  self.imgLine = nil
  self.textProfitNum = nil
  self.textSoldNum = nil
  self.textTime = nil
  self.textSold = nil
  self.textUnitPriceNum = nil
end

function RecordDumpComponent:DataDefine()
end

function RecordDumpComponent:DataDestroy()
  self.data = nil
  self.isLastOne = nil
end

function RecordDumpComponent:OnAddListener()
  base.OnAddListener(self)
end

function RecordDumpComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function RecordDumpComponent:SetData(data, isLastOne)
  self.data = data
  self.isLastOne = isLastOne
end

function RecordDumpComponent:UpdateData()
  self.imgLine:SetActive(not self.isLastOne)
  self.textTime:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(self.data.time))
  self.textSoldNum:SetText(string.GetFormattedSeparatorNum(self.data.tradeNum))
  self.textProfitNum:SetText(string.GetFormattedSeparatorNum(self.data.tradeMoney))
  self.textUnitPriceNum:SetText(string.GetFormattedSeparatorNum(self.data.unitPrice))
  self.textServer:SetText(UIUtil.FormatServerName(self.data.serverId))
end

return RecordDumpComponent
