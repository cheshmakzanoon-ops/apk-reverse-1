local UIMainPopupPackEntranceAniItem = BaseClass("UIMainPopupPackEntranceAniItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Timer = CS.GameEntry.Timer
local ResourceManager = CS.GameEntry.Resource
local idleAniName = "V_ui_%s_idle"
local switchAniName = "V_ui_%s_switch"
local root_path = ""
local hero_new_path = "hero_new"
local hero_old_path = "hero_old"

local function OnCreate(self)
  base.OnCreate(self)
  self.root = self:TryAddComponent(UIAnimator, root_path)
  self.hero_new = self:TryAddComponent(UIImage, hero_new_path)
  self.hero_old = self:TryAddComponent(UIImage, hero_old_path)
  self.packageName = ""
end

local function OnDestroy(self)
  self.root = nil
  self.hero_new = nil
  self.hero_old = nil
  self.packageName = nil
  base.OnDestroy(self)
end

local function SetData(self, packageName)
  self.packageName = packageName
end

local function PlayIdleAni(self, iconNew)
  if self:IsComponentLack() then
    return
  end
  self.hero_old:LoadSprite(UIUtil.GetFullPath(LoadPath.LWMainUINew, iconNew))
  self.root:PlayAnimationReturnTime(string.format(idleAniName, self.packageName))
end

local function PlaySwitchAni(self, iconNew, iconOld)
  local aniTime = 0
  if self:IsComponentLack() then
    return aniTime
  end
  self.hero_new:LoadSprite(UIUtil.GetFullPath(LoadPath.LWMainUINew, iconNew))
  self.hero_old:LoadSprite(UIUtil.GetFullPath(LoadPath.LWMainUINew, iconOld))
  local isSuccess = false
  isSuccess, aniTime = self.root:PlayAnimationReturnTime(string.format(switchAniName, self.packageName))
  if not isSuccess then
    aniTime = 0
  end
  return aniTime
end

local function IsComponentLack(self)
  local isLack = false
  if self.root == nil or self.hero_new == nil or self.hero_old == nil then
    isLack = true
  end
  return isLack
end

UIMainPopupPackEntranceAniItem.OnCreate = OnCreate
UIMainPopupPackEntranceAniItem.OnDestroy = OnDestroy
UIMainPopupPackEntranceAniItem.PlayIdleAni = PlayIdleAni
UIMainPopupPackEntranceAniItem.PlaySwitchAni = PlaySwitchAni
UIMainPopupPackEntranceAniItem.IsComponentLack = IsComponentLack
UIMainPopupPackEntranceAniItem.SetData = SetData
return UIMainPopupPackEntranceAniItem
