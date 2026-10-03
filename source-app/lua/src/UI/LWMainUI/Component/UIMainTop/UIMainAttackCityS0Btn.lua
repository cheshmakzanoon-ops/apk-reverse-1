local UIMainAttackCityS0Btn = BaseClass("UIMainAttackCityS0Btn", UIBaseContainer)
local base = UIBaseContainer

function UIMainAttackCityS0Btn:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIMainAttackCityS0Btn:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMainAttackCityS0Btn:ComponentDefine()
  self.btnText = self:AddComponent(UIText, "BtnText")
  self.effect = self:AddComponent(UIBaseContainer, "Eff_iconfire")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.btnText:SetLocalText("gogncheng_liantu_content1008")
  self.commonRedPoint = self:AddComponent(UICommonRedPoint, "RedPoint")
  self.commonRedPoint:SetType(CommonRedPointPriority.Level1)
end

function UIMainAttackCityS0Btn:ComponentDestroy()
  self.btnText = nil
  self.btn = nil
  self.effect = nil
  self.commonRedPoint = nil
end

function UIMainAttackCityS0Btn:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceWarEventRefresh, self.OnRefreshShow)
  self:AddUIListener(EventId.AllianceWarEventReminderChange, self.OnRefreshShow)
end

function UIMainAttackCityS0Btn:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceWarEventRefresh, self.OnRefreshShow)
  self:RemoveUIListener(EventId.AllianceWarEventReminderChange, self.OnRefreshShow)
  base.OnRemoveListener(self)
end

function UIMainAttackCityS0Btn:RefreshShowState()
  if not LuaEntry.Player:IsLoginSourceServer() then
    self:SetActive(false)
    self.commonRedPoint:SetActive(false)
    return
  end
  self.actData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.S0AttackCityNew.Type)
  if self.actData ~= nil then
    self:SetActive(true)
    self:OnRedPointRefresh()
  else
    self:SetActive(false)
    self.commonRedPoint:SetActive(false)
  end
end

function UIMainAttackCityS0Btn:OnBtnClick()
  if self.actData ~= nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCommonGroupShow, CommonActivityGroupEnum.S0AttackCityNew, self.actData.activityId)
  end
end

function UIMainAttackCityS0Btn:OnRefreshShow()
  self.effect:SetActive(DataCenter.AllianceWarEventDataManager:CheckHasReminder())
end

function UIMainAttackCityS0Btn:OnRedPointRefresh()
  local count = DataCenter.AttackCityS0DataManager:GetBattlePassRedPointNum() + DataCenter.AttackCityS0DataManager:GetCityClueRedPoint()
  self.commonRedPoint:SetNum(count)
end

return UIMainAttackCityS0Btn
