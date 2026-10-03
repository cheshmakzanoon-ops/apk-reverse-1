local base = UIBaseContainer
local UILWTruckRecordRecaptureRewardComponent = BaseClass("UILWTruckRecordRecaptureRewardComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWTruckRecordRecaptureRewardComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWTruckRecordRecaptureRewardComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTruckRecordRecaptureRewardComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compUICommonResItem = self.viewSkin:AddComponent(self, UICommonResItem, 1)
  self.compInsuranceRecapture = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
end

function UILWTruckRecordRecaptureRewardComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compUICommonResItem = nil
  self.compInsuranceRecapture = nil
end

function UILWTruckRecordRecaptureRewardComponent:DataDefine()
end

function UILWTruckRecordRecaptureRewardComponent:DataDestroy()
end

function UILWTruckRecordRecaptureRewardComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWTruckRecordRecaptureRewardComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWTruckRecordRecaptureRewardComponent:ReInit(param)
  self.compUICommonResItem:ReInit(param)
  local isOpenTruckInsurance = DataCenter.MonthCardNewManager:IsOpenTruckInsurance()
  self.compInsuranceRecapture:SetActive(isOpenTruckInsurance and param and param.isFindBack == true)
end

function UILWTruckRecordRecaptureRewardComponent:ShowMultiMark(curMultiVal)
  self.compUICommonResItem:ShowMultiMark(curMultiVal)
end

return UILWTruckRecordRecaptureRewardComponent
