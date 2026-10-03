local UIMainAttackCityBtn = BaseClass("UIMainAttackCityBtn", UIBaseContainer)
local base = UIBaseContainer

function UIMainAttackCityBtn:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIMainAttackCityBtn:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMainAttackCityBtn:ComponentDefine()
  self.btnText = self:AddComponent(UIText, "BtnText")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.btnText:SetLocalText("gogncheng_liantu_content1008")
end

function UIMainAttackCityBtn:ComponentDestroy()
  self.btnText = nil
  self.btn = nil
end

function UIMainAttackCityBtn:RefreshShowState()
  local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.S0AttackCityNew.Type)
  if actList and 0 < #actList then
    self:SetActive(false)
    return
  end
  local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.KingActivity.Type)
  if actList and 0 < #actList then
    self:SetActive(false)
    return
  end
  actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.AttackCityActivity.Type)
  if actList and 0 < #actList then
    self.actData = actList[1]
  else
    self.actData = nil
  end
  if self.actData ~= nil then
    self:SetActive(true)
  else
    self:SetActive(false)
  end
end

function UIMainAttackCityBtn:OnBtnClick()
  if self.actData ~= nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCenterTable, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, self.actData.activityId)
  end
end

return UIMainAttackCityBtn
