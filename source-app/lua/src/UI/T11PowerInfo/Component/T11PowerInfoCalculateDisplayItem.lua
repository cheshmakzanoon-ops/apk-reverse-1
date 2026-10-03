local base = UIBaseContainer
local T11PowerInfoCalculateDisplayItem = BaseClass("T11PowerInfoCalculateDisplayItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function T11PowerInfoCalculateDisplayItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function T11PowerInfoCalculateDisplayItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11PowerInfoCalculateDisplayItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textAttributeOriginName1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textAttributeOriginValue1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textAttributeOriginName2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textAttributeOriginValue2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textAttributeOriginName3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textAttributeOriginValue3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textAttributeOriginName4 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textAttributeOriginValue4 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.nameList = {
    self.textAttributeOriginName1,
    self.textAttributeOriginName2,
    self.textAttributeOriginName3,
    self.textAttributeOriginName4
  }
  self.valueList = {
    self.textAttributeOriginValue1,
    self.textAttributeOriginValue2,
    self.textAttributeOriginValue3,
    self.textAttributeOriginValue4
  }
end

function T11PowerInfoCalculateDisplayItem:ComponentDestroy()
  self.textAttributeOriginName1 = nil
  self.textAttributeOriginValue1 = nil
  self.textAttributeOriginName2 = nil
  self.textAttributeOriginValue2 = nil
  self.textAttributeOriginName3 = nil
  self.textAttributeOriginValue3 = nil
  self.textAttributeOriginName4 = nil
  self.textAttributeOriginValue4 = nil
end

function T11PowerInfoCalculateDisplayItem:DataDefine()
end

function T11PowerInfoCalculateDisplayItem:DataDestroy()
end

function T11PowerInfoCalculateDisplayItem:OnAddListener()
  base.OnAddListener(self)
end

function T11PowerInfoCalculateDisplayItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function T11PowerInfoCalculateDisplayItem:SetData(data)
  for i = 1, #self.nameList do
    if data[i] then
      self.nameList[i]:SetLocalText(data[i].title)
      self.valueList[i]:SetText(data[i].value)
    end
  end
end

return T11PowerInfoCalculateDisplayItem
