local base = UIBaseContainer
local UIS0AllianceBossRewardItem = BaseClass("UIS0AllianceBossRewardItem", UIBaseContainer)

function UIS0AllianceBossRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIS0AllianceBossRewardItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIS0AllianceBossRewardItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.resItem = self.viewSkin:AddComponent(self, UICommonResItem, 1)
  self.compDoubleMark = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.textMultiple = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
end

function UIS0AllianceBossRewardItem:ComponentDestroy()
  self.viewSkin = nil
  self.resItem = nil
  self.compDoubleMark = nil
  self.textMultiple = nil
end

function UIS0AllianceBossRewardItem:DataDefine()
end

function UIS0AllianceBossRewardItem:DataDestroy()
end

function UIS0AllianceBossRewardItem:OnAddListener()
  base.OnAddListener(self)
end

function UIS0AllianceBossRewardItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIS0AllianceBossRewardItem:RefreshItem(reward, bonus)
  if reward then
    self.resItem:ParseInfo(reward)
  end
  if bonus and 1 < bonus then
    self.compDoubleMark:SetActive(true)
    self.textMultiple:SetText("x" .. bonus)
  else
    self.compDoubleMark:SetActive(false)
  end
end

return UIS0AllianceBossRewardItem
