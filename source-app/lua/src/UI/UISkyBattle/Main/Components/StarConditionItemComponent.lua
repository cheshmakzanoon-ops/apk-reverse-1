local base = UIBaseContainer
local StarConditionItemComponent = BaseClass("StarConditionItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function StarConditionItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function StarConditionItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function StarConditionItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgStarIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textStarConditionValue = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textFailLabel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
end

function StarConditionItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.imgStarIcon = nil
  self.textStarConditionValue = nil
  self.textFailLabel = nil
end

function StarConditionItemComponent:DataDefine()
end

function StarConditionItemComponent:DataDestroy()
end

function StarConditionItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function StarConditionItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function StarConditionItemComponent:Refresh(conditionMeet, meetText, unMeetText)
  self.imgStarIcon:SetActive(conditionMeet)
  self.textStarConditionValue:SetActive(conditionMeet)
  self.textStarConditionValue:SetText(meetText)
  self.textFailLabel:SetActive(not conditionMeet)
  self.textFailLabel:SetText(unMeetText)
end

return StarConditionItemComponent
