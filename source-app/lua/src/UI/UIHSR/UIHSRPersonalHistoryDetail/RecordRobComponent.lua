local base = UIAsyncContainer
local RecordRobComponent = BaseClass("RecordRobComponent", UIAsyncContainer)
local Localization = CS.GameEntry.Localization

function RecordRobComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function RecordRobComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function RecordRobComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textRob = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgLine = self.viewSkin:AddComponent(self, UIImage, 4)
end

function RecordRobComponent:ComponentDestroy()
  self.viewSkin = nil
  self.textRob = nil
  self.textTitle = nil
  self.textTime = nil
  self.imgLine = nil
end

function RecordRobComponent:DataDefine()
end

function RecordRobComponent:DataDestroy()
  self.data = nil
  self.isLastOne = nil
end

function RecordRobComponent:OnAddListener()
  base.OnAddListener(self)
end

function RecordRobComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function RecordRobComponent:SetData(data, isLastOne)
  self.data = data
  self.isLastOne = isLastOne
end

function RecordRobComponent:UpdateData()
  self.imgLine:SetActive(not self.isLastOne)
  self.textTime:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(self.data.time))
  local robber = UIUtil.FormatServerAllianceName(self.data.lootServer, self.data.lootAbbr, self.data.lootName, self.data.lootUid)
  local goodsStr = " <sprite=0> " .. self.data.lootNum
  self.textRob:SetLocalText("activity_1200044_tips55", robber, goodsStr)
  self.textTitle:SetLocalText("s5_bank_ui72")
end

return RecordRobComponent
