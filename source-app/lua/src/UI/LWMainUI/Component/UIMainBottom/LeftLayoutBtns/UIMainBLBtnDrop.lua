local UIMainBLBtnBase = require("UI.LWMainUI.Component.UIMainBottom.LeftLayoutBtns.UIMainBLBtnBase")
local UIMainBLBtnDrop = BaseClass("UIMainBLBtnDrop", UIMainBLBtnBase)
local base = UIMainBLBtnBase

local function OnAddMainBtnListener(self)
  base.OnAddMainBtnListener(self)
  self:AddUIListener(EventId.HeroDropListModified, self.Refresh)
  self:AddUIListener(EventId.BuildLevelUp, self.Refresh)
  self:AddUIListener(EventId.OnEnterCity, self.Refresh)
  self:AddUIListener(EventId.OnEnterWorld, self.Refresh)
  self:AddUIListener(EventId.BuildUpgradeFinish, self.Refresh)
end

local function OnRemoveMainBtnListener(self)
  base.OnRemoveMainBtnListener(self)
  self:RemoveUIListener(EventId.HeroDropListModified, self.Refresh)
  self:RemoveUIListener(EventId.BuildLevelUp, self.Refresh)
  self:RemoveUIListener(EventId.OnEnterCity, self.Refresh)
  self:RemoveUIListener(EventId.OnEnterWorld, self.Refresh)
  self:RemoveUIListener(EventId.BuildUpgradeFinish, self.Refresh)
end

local function ReInit(self, type, unlockType)
  base.ReInit(self, type, unlockType)
  self.clickBlock = false
end

local function OnClick(self)
  self.commonRedPoint:SetViewed()
  if not self.clickBlock then
    DataCenter.BuildHeroManager:CheckNewHero()
    self:Refresh()
    self.clickBlock = true
    TimerManager:GetInstance():DelayInvoke(function()
      self.clickBlock = false
    end, 1)
  end
end

local function Refresh(self)
  base.Refresh(self)
  if self.gameObject.activeSelf and CommonUtil.PlayerPrefsGetInt("MAIN_UI_HERO_DROP_BTN_GUIDE", 0) == 0 then
    CommonUtil.PlayerPrefsSetInt("MAIN_UI_HERO_DROP_BTN_GUIDE", 1)
    self.fingerHandle = DataCenter.LWGuideVFXManager:InstantiateAsync("Assets/Main/Prefabs/Guide/UIArrowFinger.prefab", self.OnVfxLoaded, self, 3, GuideVFXPriority.Middle)
  end
end

function UIMainBLBtnDrop:OnVfxLoaded(handle)
  if handle.isError then
    return
  end
  local gameObject = handle.gameObject
  local transform = gameObject.transform
  transform:SetParent(self.transform, false)
  transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
  transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
end

local function CheckEnable(self)
  local inCity = SceneUtils.GetIsInCity()
  local unlock = self:CheckUnlock()
  local num = self:RefreshRedDotNum()
  return unlock and inCity and 0 < num
end

function UIMainBLBtnDrop:OnDisable()
  base.OnDisable(self)
  if self.fingerHandle then
    DataCenter.LWGuideVFXManager:StopCurrent(self.fingerHandle)
    self.fingerHandle = nil
  end
end

UIMainBLBtnDrop.ReInit = ReInit
UIMainBLBtnDrop.OnClick = OnClick
UIMainBLBtnDrop.OnAddMainBtnListener = OnAddMainBtnListener
UIMainBLBtnDrop.OnRemoveMainBtnListener = OnRemoveMainBtnListener
UIMainBLBtnDrop.CheckEnable = CheckEnable
UIMainBLBtnDrop.Refresh = Refresh
return UIMainBLBtnDrop
