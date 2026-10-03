local base = UIAsyncContainer
local RecordConsignComponent = BaseClass("RecordConsignComponent", UIAsyncContainer)
local Localization = CS.GameEntry.Localization

function RecordConsignComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function RecordConsignComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function RecordConsignComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgLine = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textServer = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textProfit = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textRemainNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textSold = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textRemain = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textSoldNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textProfitNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textSold:SetLocalText("activity_1200044_tips52", "")
  self.textRemain:SetLocalText("activity_1200044_tips53", "")
  self.textProfit:SetLocalText("activity_1200044_tips54", "")
end

function RecordConsignComponent:ComponentDestroy()
  self.viewSkin = nil
  self.imgLine = nil
  self.textServer = nil
  self.textProfit = nil
  self.textTime = nil
  self.textRemainNum = nil
  self.textSold = nil
  self.textRemain = nil
  self.textSoldNum = nil
  self.textProfitNum = nil
end

function RecordConsignComponent:DataDefine()
end

function RecordConsignComponent:DataDestroy()
  self.data = nil
end

function RecordConsignComponent:OnAddListener()
  base.OnAddListener(self)
end

function RecordConsignComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function RecordConsignComponent:SetData(data, isLastOne)
  self.data = data
  self.isLastOne = isLastOne
end

function RecordConsignComponent:UpdateData()
  self.imgLine:SetActive(not self.isLastOne)
  self.textTime:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(self.data.time))
  self.textSoldNum:SetText(string.GetFormattedSeparatorNum(self.data.tradeNum))
  self.textRemainNum:SetText(string.GetFormattedSeparatorNum(self.data.remainNum))
  self.textProfitNum:SetText(string.GetFormattedSeparatorNum(self.data.tradeMoney))
  self.textServer:SetText(UIUtil.FormatServerName(self.data.serverId))
end

return RecordConsignComponent
