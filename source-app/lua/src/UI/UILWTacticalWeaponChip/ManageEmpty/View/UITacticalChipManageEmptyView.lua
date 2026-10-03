local UITacticalChipManageEmptyView = BaseClass("UITacticalChipManageEmptyView", UIBaseView)
local base = UIBaseView
local TITLE = {
  [1] = "uav_chips_title6",
  [2] = "uav_chips_title7",
  [3] = "uav_chips_title8",
  [4] = "uav_chips_title9"
}
local DESC = {
  [1] = "uav_chips_desc14",
  [2] = "uav_chips_desc15",
  [3] = "uav_chips_desc16",
  [4] = "uav_chips_desc17"
}

function UITacticalChipManageEmptyView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:Init()
end

function UITacticalChipManageEmptyView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITacticalChipManageEmptyView:ComponentDefine()
  self.btnBg = self:AddComponent(UIButton, "bgBtn")
  self.btnBg:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTitle = self:AddComponent(UIText, "Root/title")
  self.textDesc = self:AddComponent(UIText, "Root/desc")
  self.textTips = self:AddComponent(UIText, "Root/tips")
  self.textTips:SetLocalText("battlesystem_choose_chip_desc1")
  self.textGoBtn = self:AddComponent(UIText, "Root/goBtn/Btn/goBtnText")
  self.textGoBtn:SetLocalText("battlesystem_choose_chip_button2")
  self.btnGo = self:AddComponent(UIButton, "Root/goBtn")
  self.btnGo:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.btnClose = self:AddComponent(UIButton, "Root/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
end

function UITacticalChipManageEmptyView:ComponentDestroy()
  self.btnBg = nil
  self.textTitle = nil
  self.textDesc = nil
  self.textTips = nil
  self.textGoBtn = nil
  self.btnGo = nil
  self.btnClose = nil
end

function UITacticalChipManageEmptyView:Init()
  self.type = self:GetUserData()
  if TITLE[self.type] then
    self.textTitle:SetLocalText(TITLE[self.type])
  else
    self.textTitle:SetLocalText(TITLE[1])
  end
  if DESC[self.type] then
    self.textDesc:SetLocalText(DESC[self.type])
  else
    self.textDesc:SetLocalText(DESC[1])
  end
end

function UITacticalChipManageEmptyView:OnBtnGoClick()
  if not CS.SceneManager:IsInCity() and not CS.SceneManager:IsInWorld() then
    UIUtil.ShowTipsId("chips_cannot_jump_tips")
    return
  end
  self:GuideToChipFactory()
end

function UITacticalChipManageEmptyView:GuideToChipFactory()
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILDING_TACTICAL_CHIP_FACTORY)
  if buildList == nil or table.count(buildList) == 0 or buildList[1] == nil then
    GoToUtil.GotoBuildListByBuildId(BuildingTypes.LW_BUILDING_TACTICAL_CHIP_FACTORY)
    return
  end
  local targetBuilding = buildList[1]
  GoToUtil.CloseAllWindows()
  self:SwitchToCity(function()
    GoToUtil.GotoPos(targetBuilding:GetCenterVec(), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      WorldArrowManager:GetInstance():ShowArrowEffect(0, targetBuilding:GetCenterVec(), ArrowType.Normal)
      local destroyTimer = TimerManager:GetInstance():GetTimer(1, function()
        WorldArrowManager:GetInstance():RemoveEffect()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalChipFactory, {anim = false}, targetBuilding.uuid)
      end, nil, true, false, false)
      destroyTimer:Start()
    end)
  end)
end

function UITacticalChipManageEmptyView:SwitchToCity(callback)
  if BattleFieldUtil.InBattleField() then
    CrossServerUtil.OnBackSelfServerFromDragonWorld()
    SceneUtils.ChangeToCity(callback)
  elseif not CS.SceneManager:IsInCity() then
    SceneUtils.ChangeToCity(callback)
  elseif callback then
    callback()
  end
end

function UITacticalChipManageEmptyView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

return UITacticalChipManageEmptyView
