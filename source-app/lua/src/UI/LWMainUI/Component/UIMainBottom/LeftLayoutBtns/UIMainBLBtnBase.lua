local UIMainBLBtnBase = BaseClass("UIMainBLBtnBase", UIBaseContainer)
local base = UIBaseContainer
local btn_path = "btn"
local common_red_point_path = "CommonRedPoint"

local function OnCreate(self)
  base.OnCreate(self)
  self:OnAddMainBtnListener()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:OnRemoveMainBtnListener()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function SetActive(self, active)
  base.SetActive(self, active and self:CheckEnable())
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.commonRedPoint = self:AddComponent(UICommonRedPoint, common_red_point_path)
  self.commonRedPoint:SetType(CommonRedPointPriority.LevelNormal)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.commonRedPoint = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self, type, unlockType)
  self.type = type
  self.unlockType = unlockType
  if self.unlockType ~= nil then
    self.view:RegisterFunctionUnlock(self.unlockType, self)
  end
  if self.type == UIMainFunctionInfo.Visitor then
    self.commonRedPoint:SetType(CommonRedPointPriority.LevelNormal, CommonRedPointExtraType.Hide)
  elseif self.type == UIMainFunctionInfo.DispatchTask or self.type == UIMainFunctionInfo.Detect then
    self.commonRedPoint:SetType(CommonRedPointPriority.Level1)
  end
  if self.type == UIMainFunctionInfo.Build then
    self.commonRedPoint:SetId(self.type)
  end
  self:Refresh()
end

local function Refresh(self)
  self:RefreshRedDotNum()
  self:SetActive(true)
end

local function OnClick(self)
  self.commonRedPoint:SetViewed()
  self.view.ctrl:OnFunctionClick(self.type)
end

local function CheckUnlock(self)
  if self.unlockType == nil then
    return true
  end
  local unlock = DataCenter.LWFunctionUnlockManager:CheckCanShow(self.unlockType)
  return unlock
end

local function RefreshRedDotNum(self)
  if self.view.ctrl == nil then
    return 0
  end
  local isShow, num, rewardNum, tipNum = self.view.ctrl:IsRedPotShowByType(self.type)
  if self.type == UIMainFunctionInfo.Detect then
    self.commonRedPoint:SetForceTipNum(rewardNum)
  elseif self.type == UIMainFunctionInfo.Truck then
    if 0 < rewardNum then
      self.commonRedPoint:SetNum(0, rewardNum)
    else
      self.commonRedPoint:SetNum(0, tipNum)
    end
  else
    self.commonRedPoint:SetNum(rewardNum, tipNum)
  end
  return num
end

local function CheckEnable(self)
  local unlock = self:CheckUnlock()
  return unlock
end

UIMainBLBtnBase.OnCreate = OnCreate
UIMainBLBtnBase.OnDestroy = OnDestroy
UIMainBLBtnBase.OnEnable = OnEnable
UIMainBLBtnBase.OnDisable = OnDisable
UIMainBLBtnBase.SetActive = SetActive
UIMainBLBtnBase.ComponentDefine = ComponentDefine
UIMainBLBtnBase.ComponentDestroy = ComponentDestroy
UIMainBLBtnBase.ReInit = ReInit
UIMainBLBtnBase.Refresh = Refresh
UIMainBLBtnBase.OnClick = OnClick
UIMainBLBtnBase.OnAddListener = OnAddListener
UIMainBLBtnBase.OnRemoveListener = OnRemoveListener
UIMainBLBtnBase.CheckUnlock = CheckUnlock
UIMainBLBtnBase.CheckEnable = CheckEnable
UIMainBLBtnBase.RefreshRedDotNum = RefreshRedDotNum

function UIMainBLBtnBase.OnAddMainBtnListener()
end

function UIMainBLBtnBase.OnRemoveMainBtnListener()
end

return UIMainBLBtnBase
