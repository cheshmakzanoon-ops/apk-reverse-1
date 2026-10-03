local LWGotoUpgradeBaseView = BaseClass("LWGotoUpgradeBaseView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local param = self:GetUserData()
  self.param = param
  self:OnOpen(self)
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.textDesTxt = self:AddComponent(UITextMeshProUGUIEx, "PopUp/DesTxt")
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "PopUp/TitleText")
  self.btnClose = self:AddComponent(UIButton, "PopUp/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textLvFromTxt = self:AddComponent(UITextMeshProUGUIEx, "PopUp/LvFromTxt")
  self.textLvToTxt = self:AddComponent(UITextMeshProUGUIEx, "PopUp/LvToTxt")
  self.btnGo = self:AddComponent(UIButton, "PopUp/GoBtn")
  self.btnGo:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.imgIcon = self:AddComponent(UIImage, "PopUp/Icon")
  self.textBaseLevel = self:AddComponent(UITextMeshProUGUIEx, "PopUp/BaseLevel")
  self.btnPanel = self:AddComponent(UIButton, "Panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
end

local function ComponentDestroy(self)
  self.textDesTxt = nil
  self.textTitle = nil
  self.btnClose = nil
  self.textLvFromTxt = nil
  self.textLvToTxt = nil
  self.btnGo = nil
  self.imgIcon = nil
  self.textBaseLevel = nil
  self.btnPanel = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnOpen(self)
  self.textTitle:SetLocalText("newbies_mainbuilding_needlv_tips1")
  if self.param == nil or self.param.state == nil then
    self.textDesTxt:SetLocalText("newbies_mainbuilding_needlv_tips2")
  elseif self.param.state == 1 then
    self.textDesTxt:SetLocalText("newbies_mainbuilding_needlv_tips3")
  elseif self.param.state == 2 then
    self.textDesTxt:SetLocalText("newbies_mainbuilding_needlv_tips5")
  end
  self.textBaseLevel:SetLocalText("newbies_mainbuilding_needlv_tips4")
  local main = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.FUN_BUILD_MAIN)[1]
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.FUN_BUILD_MAIN)
  self.imgIcon:LoadSpriteAuto(buildTemplate:GetBuildIconOutCity())
  local lv = "Lv."
  self.textLvFromTxt:SetText(lv .. main.level)
  if not self.param or not self.param.level then
    self.textLvToTxt:SetText(lv .. main.level + 1)
  else
    self.textLvToTxt:SetText(lv .. (self.param.level and self.param.level or main.level + 1))
  end
end

local function OnBtnCloseClick(self)
  self.ctrl:CloseSelf()
end

local function OnBtnGoClick(self)
  if CS.SceneManager.IsInPVE() then
    if DataCenter.LWBattleManager.param and DataCenter.LWBattleManager.param.type == PVEType.Parkour then
      DataCenter.LWBattleManager:Exit(function()
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIParkourFormation)
        self:GoToMainBuild()
      end, "quit")
    elseif DataCenter.LWBattleManager:GetCurBattleLogic() == DataCenter.ZombieBattleManager then
      DataCenter.ZombieBattleManager:Exit(function()
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroPVEFormation)
        self:GoToMainBuild()
      end, "quit")
    end
  else
    self:GoToMainBuild()
  end
end

function LWGotoUpgradeBaseView:GoToMainBuild()
  local build = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_MAIN)[1]
  GoToUtil.CloseAllWindows()
  if build:IsUpgrading() then
    GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_MAIN, WorldTileBtnType.City_SpeedUp)
  else
    GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_MAIN, WorldTileBtnType.City_Upgrade)
  end
end

LWGotoUpgradeBaseView.OnCreate = OnCreate
LWGotoUpgradeBaseView.OnDestroy = OnDestroy
LWGotoUpgradeBaseView.OnEnable = OnEnable
LWGotoUpgradeBaseView.OnDisable = OnDisable
LWGotoUpgradeBaseView.ComponentDefine = ComponentDefine
LWGotoUpgradeBaseView.ComponentDestroy = ComponentDestroy
LWGotoUpgradeBaseView.DataDefine = DataDefine
LWGotoUpgradeBaseView.DataDestroy = DataDestroy
LWGotoUpgradeBaseView.OnAddListener = OnAddListener
LWGotoUpgradeBaseView.OnRemoveListener = OnRemoveListener
LWGotoUpgradeBaseView.OnOpen = OnOpen
LWGotoUpgradeBaseView.OnBtnCloseClick = OnBtnCloseClick
LWGotoUpgradeBaseView.OnBtnGoClick = OnBtnGoClick
return LWGotoUpgradeBaseView
