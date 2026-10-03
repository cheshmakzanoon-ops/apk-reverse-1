local base = UIAsyncContainer
local RecordFailureComponent = BaseClass("RecordFailureComponent", UIAsyncContainer)
local Localization = CS.GameEntry.Localization

function RecordFailureComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function RecordFailureComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function RecordFailureComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textRob = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgLine = self.viewSkin:AddComponent(self, UIImage, 4)
end

function RecordFailureComponent:ComponentDestroy()
  self.viewSkin = nil
  self.textRob = nil
  self.textTitle = nil
  self.textTime = nil
  self.imgLine = nil
end

function RecordFailureComponent:DataDefine()
end

function RecordFailureComponent:DataDestroy()
  self.data = nil
  self.isLastOne = nil
end

function RecordFailureComponent:SetData(data, isLastOne)
  self.data = data
  self.isLastOne = isLastOne
end

function RecordFailureComponent:UpdateData()
  self.imgLine:SetActive(not self.isLastOne)
  self.textTime:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(self.data.time))
  self.textRob:SetLocalText("server_train_record_tips", self.data.maxSellPrice, self.data.unitPrice)
  self.textTitle:SetText(UIUtil.FormatServerName(self.data.serverId))
end

return RecordFailureComponent
