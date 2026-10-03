local base = UIBaseContainer
local UIIdleGameTaskEventInvitePlayerItemComponent = BaseClass("UIIdleGameTaskEventInvitePlayerItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIIdleGameTaskEventInvitePlayerItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIIdleGameTaskEventInvitePlayerItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIIdleGameTaskEventInvitePlayerItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 1)
  self.compNobodyFlag = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.simpleAnimRoot = self.viewSkin:AddComponent(self, UISimpleAnimation, 3)
  self.compEffKuang = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
end

function UIIdleGameTaskEventInvitePlayerItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compPlayerHead = nil
  self.compNobodyFlag = nil
  self.simpleAnimRoot = nil
  self.compEffKuang = nil
end

function UIIdleGameTaskEventInvitePlayerItemComponent:DataDefine()
end

function UIIdleGameTaskEventInvitePlayerItemComponent:DataDestroy()
end

function UIIdleGameTaskEventInvitePlayerItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIIdleGameTaskEventInvitePlayerItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIIdleGameTaskEventInvitePlayerItemComponent:ReInit(data, isPlayAnim)
  self.compPlayerHead:SetActive(not data.isEmptyPlace)
  self.compNobodyFlag:SetActive(data.isEmptyPlace)
  if not data.isEmptyPlace then
    if data.headSkinPath then
      self.compPlayerHead:SetData(data.uid, data.pic, data.picVer, nil, data.headSkinPath)
    else
      self.compPlayerHead:SetHeadAndFrame(data.uid, data.pic, data.picVer, nil, data.headSkinId, data.headSkinET)
    end
    self.compPlayerHead:SetEnableClickShowInfo(true, true)
  end
  if isPlayAnim then
    self.simpleAnimRoot:Enable(true)
    self.compEffKuang:SetActive(true)
    self.simpleAnimRoot:Play("Default")
  else
    self.simpleAnimRoot:Enable(false)
    self.compEffKuang:SetActive(false)
  end
end

return UIIdleGameTaskEventInvitePlayerItemComponent
