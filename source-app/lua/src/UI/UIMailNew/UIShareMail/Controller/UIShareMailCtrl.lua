local ctrl = BaseClass("ctrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChatNew)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIShareMail)
end

local function OnMoreHero(self)
  local scienceId = DataCenter.ArmyFormationDataManager:GetFirstFormationUnlockScienceId()
  if scienceId ~= nil then
    GoToUtil.GotoScience(CommonUtil.GetScienceBaseType(scienceId))
    self:CloseSelf()
  end
end

local function OnUpgradeHeroLevel(self, heroUuid)
  GoToUtil.GotoOpenView(UIWindowNames.UIHeroList, {
    anim = false,
    UIMainAnim = UIMainAnimType.AllHide
  }, heroUuid)
end

local function OnRecruitHero(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruit)
end

local function OnUpgradeHeroQuality(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroAdvance)
end

local function OnClickPosBtn(self, pos, serverId)
  if not SceneUtils.CheckCanGotoWorld(120018) then
    return
  end
  if pos ~= 0 then
    self:CloseSelf()
    GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pos, ForceChangeScene.World), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
    end, serverId)
  end
end

ctrl.OnClickPosBtn = OnClickPosBtn
ctrl.OnMoreHero = OnMoreHero
ctrl.OnUpgradeHeroLevel = OnUpgradeHeroLevel
ctrl.OnRecruitHero = OnRecruitHero
ctrl.OnUpgradeHeroQuality = OnUpgradeHeroQuality
ctrl.CloseSelf = CloseSelf
return ctrl
