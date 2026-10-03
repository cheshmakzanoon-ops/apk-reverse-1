local base = UIBaseContainer
local UIMainBtnLockHart = BaseClass("UIMainBtnLockHart", UIBaseContainer)

function UIMainBtnLockHart:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIMainBtnLockHart:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMainBtnLockHart:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnUIMainLockHart = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnUIMainLockHart:SetOnClick(function()
    self:OnBtnUIMainLockHartClick()
  end)
  self.imgHeroShow = self.viewSkin:AddComponent(self, UIImage, 2)
end

function UIMainBtnLockHart:ComponentDestroy()
  self.viewSkin = nil
  self.btnUIMainLockHart = nil
  self.imgHeroShow = nil
end

function UIMainBtnLockHart:OnBtnUIMainLockHartClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCommonGroupShow, CommonActivityGroupEnum.Alliance, self.activityId)
end

function UIMainBtnLockHart:SetActivityIcon(activityId)
  if activityId == nil then
    self:SetActive(false)
    return
  end
  self.activityId = activityId
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  self.imgHeroShow:LoadSpriteAuto(self.activityData.para_6)
end

return UIMainBtnLockHart
