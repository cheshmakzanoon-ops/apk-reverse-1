local UIAccountManageCtrl = BaseClass("UIAccountManageCtrl", UIBaseCtrl)

function UIAccountManageCtrl:__init()
  self.isAnonymity = nil
end

function UIAccountManageCtrl:__delete()
  self.isAnonymity = nil
end

function UIAccountManageCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAccountManage)
end

function UIAccountManageCtrl:GetAccountManageAnonymity()
  if not self.isAnonymity then
    self.isAnonymity = Setting:GetPrivateBool("AccountSettingAnonymity", true)
  end
  return self.isAnonymity
end

function UIAccountManageCtrl:SetAccountManageAnonymity(isAnonymity)
  if self.isAnonymity == isAnonymity then
    return
  end
  self.isAnonymity = isAnonymity
  Setting:SetPrivateBool("AccountSettingAnonymity", isAnonymity)
end

return UIAccountManageCtrl
