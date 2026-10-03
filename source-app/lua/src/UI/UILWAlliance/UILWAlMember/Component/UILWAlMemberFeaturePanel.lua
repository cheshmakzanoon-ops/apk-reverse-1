local base = UIBaseContainer
local UILWAlMemberFeaturePanel = BaseClass("UILWAlMemberFeaturePanel", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

function UILWAlMemberFeaturePanel:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlMemberFeaturePanel:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlMemberFeaturePanel:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnFeature = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnFeature:SetOnClick(function()
    self:OnBtnFeatureClick()
  end)
  self.textFeatureBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compFeatureLockPanel = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.textFeatureLock = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textFeatureBtn:SetLocalText("alliance_invite_btn")
end

function UILWAlMemberFeaturePanel:ComponentDestroy()
  self.viewSkin = nil
  self.btnFeature = nil
  self.textFeatureBtn = nil
  self.compFeatureLockPanel = nil
  self.textFeatureLock = nil
end

function UILWAlMemberFeaturePanel:DataDefine()
end

function UILWAlMemberFeaturePanel:DataDestroy()
end

function UILWAlMemberFeaturePanel:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlMemberFeaturePanel:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAlMemberFeaturePanel:OnBtnFeatureClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlFeatureMember, {anim = true})
end

function UILWAlMemberFeaturePanel:Refresh(openTime)
  self.openTime = openTime
  self:Update1000MS()
end

function UILWAlMemberFeaturePanel:Update1000MS()
  if self.openTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    local diff = self.openTime - now
    if 0 < diff then
      UIGray.SetGray(self.btnFeature.transform, true, false)
      self.compFeatureLockPanel:SetActive(true)
      self.textFeatureLock:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(diff))
    else
      UIGray.SetGray(self.btnFeature.transform, false, true)
      self.compFeatureLockPanel:SetActive(false)
    end
  else
    self.compFeatureLockPanel:SetActive(false)
  end
end

return UILWAlMemberFeaturePanel
