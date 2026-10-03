local base = UIBaseContainer
local UIOffSeason1RecaptureFeatureItem = BaseClass("UIOffSeason1RecaptureFeatureItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIOffSeason1RecaptureFeatureItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIOffSeason1RecaptureFeatureItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIOffSeason1RecaptureFeatureItem:ComponentDefine()
  self.btn = self:AddComponent(UIButton, "")
  self.bg = self:AddComponent(UIBaseComponent, "FeatureItemBg")
  self.icon = self:AddComponent(UIBaseComponent, "FeatureItemIcon")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function UIOffSeason1RecaptureFeatureItem:ComponentDestroy()
  self.btn = nil
  self.bg = nil
  self.icon = nil
end

function UIOffSeason1RecaptureFeatureItem:DataDefine()
end

function UIOffSeason1RecaptureFeatureItem:DataDestroy()
end

function UIOffSeason1RecaptureFeatureItem:OnAddListener()
  base.OnAddListener(self)
end

function UIOffSeason1RecaptureFeatureItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIOffSeason1RecaptureFeatureItem:OnBtnClick()
  if self.monsterUuid then
    if DataCenter.OffSeason1RecaptureManager:IsCtrl() then
      SFSNetwork.SendMessage(MsgDefines.CityBattleS1PresidentChooseCityDefend, self.isFeature and -1 or 1, self.monsterUuid)
      if self.holder.HideTipRoot then
        self.holder:HideTipRoot()
      end
    elseif self.isFeature and self.holder.ShowTipRoot then
      self.holder:ShowTipRoot("s1_offseason_activity_recapture_firstAttackTips3", true)
    end
  end
end

function UIOffSeason1RecaptureFeatureItem:Refresh(isFeature, monsterUuid)
  self.isFeature = isFeature
  self.monsterUuid = monsterUuid
  self.icon:SetActive(self.isFeature)
  self.bg:SetActive(self.monsterUuid and DataCenter.OffSeason1RecaptureManager:IsCtrl() and not self.isFeature)
end

return UIOffSeason1RecaptureFeatureItem
