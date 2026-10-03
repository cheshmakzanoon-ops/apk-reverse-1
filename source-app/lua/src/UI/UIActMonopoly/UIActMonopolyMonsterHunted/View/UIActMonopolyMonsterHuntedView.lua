local UIActMonopolyMonsterHuntedView = BaseClass("UIActMonopolyMonsterHuntedView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self.activityId = self:GetUserData()
  self:ComponentDefine()
  self:RefreshView()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btnClose = self:AddComponent(UIButton, "UICommonMiniPopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.textTitle = self:AddComponent(UIText, "UICommonMiniPopUpTitle/titleText")
  self.des = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content")
  self.btnOK = self:AddComponent(UIButton, "Root/BtnOk")
  self.btnOK:SetOnClick(BindCallback(self, self.OnBtnOKClick))
end

local function ComponentDestroy(self)
  self.btnClose = nil
  self.textTitle = nil
  self.btnOK = nil
end

local function RefreshView(self)
  local activityDetailData = DataCenter.ActMonopolyDataManager:GetActData(self.activityId)
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  local bossTempId = tonumber(activityInfo.boss_type)
  if bossTempId and 0 < bossTempId then
    self.bossTemp = DataCenter.ActMonopolyDataManager:GetMonopolyBossTempById(bossTempId)
  end
  local weakHp = self.bossTemp.bullet_boss_hp_weak
  self.des:SetLocalText("richman_boss_desc10", weakHp)
end

local function OnBtnOKClick(self)
  self.ctrl:CloseSelf()
end

UIActMonopolyMonsterHuntedView.OnCreate = OnCreate
UIActMonopolyMonsterHuntedView.OnDestroy = OnDestroy
UIActMonopolyMonsterHuntedView.ComponentDefine = ComponentDefine
UIActMonopolyMonsterHuntedView.ComponentDestroy = ComponentDestroy
UIActMonopolyMonsterHuntedView.RefreshView = RefreshView
UIActMonopolyMonsterHuntedView.OnBtnRoleClick = OnBtnRoleClick
UIActMonopolyMonsterHuntedView.OnBtnOKClick = OnBtnOKClick
return UIActMonopolyMonsterHuntedView
