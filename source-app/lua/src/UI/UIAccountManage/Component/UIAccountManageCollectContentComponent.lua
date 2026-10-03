local base = UIBaseContainer
local UIAccountManageCollectContentComponent = BaseClass("UIAccountManageCollectContentComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIAccountManageCollectContentComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAccountManageCollectContentComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAccountManageCollectContentComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.eventTrigger = self.viewSkin:AddComponent(self, UIEventTrigger, 1)
  self.scroll = self.viewSkin:AddComponent(self, UIScrollRect, 2)
  self.textPointTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textPoint = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.eventTrigger:OnBeginDrag(function(eventData)
    if self.scroll then
      self.scroll:OnBeginDrag(eventData)
    end
  end)
  self.eventTrigger:OnDrag(function(eventData)
    if self.scroll then
      self.scroll:OnDrag(eventData)
    end
  end)
  self.eventTrigger:OnEndDrag(function(eventData)
    if self.scroll then
      self.scroll:OnEndDrag(eventData)
    end
  end)
  self.eventTrigger:OnPointerClick(function(eventData)
    self:OnBtnUINewClick()
  end)
end

function UIAccountManageCollectContentComponent:ComponentDestroy()
  self.viewSkin = nil
  self.eventTrigger = nil
  self.scroll = nil
  self.textPointTitle = nil
  self.textPoint = nil
  self.compContent = nil
end

function UIAccountManageCollectContentComponent:DataDefine()
end

function UIAccountManageCollectContentComponent:DataDestroy()
end

function UIAccountManageCollectContentComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIAccountManageCollectContentComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAccountManageCollectContentComponent:OnBtnUINewClick()
  DataCenter.AccountScoreManager:GoToLogInAccountScoreWeb(AccountScoreLogInWebType.AccountView_ScoreContent)
end

function UIAccountManageCollectContentComponent:Init()
  self.textPointTitle:SetLocalText("id_account1_desc")
  self.textPoint:SetLocalText("id_account2_desc")
  local titlePreferHeight = self.textPointTitle.unity_tmpro:GetPreferredValues().y
  local descPreferHeight = self.textPoint.unity_tmpro:GetPreferredValues().y
  local scrollEnable = 140 < titlePreferHeight + descPreferHeight
  self.scroll:SetEnable(scrollEnable)
  if scrollEnable then
    local x, y = self.compContent:GetSizeDeltaXY()
    self.compContent:SetSizeDeltaXY(x, titlePreferHeight + descPreferHeight + 20)
  end
end

return UIAccountManageCollectContentComponent
