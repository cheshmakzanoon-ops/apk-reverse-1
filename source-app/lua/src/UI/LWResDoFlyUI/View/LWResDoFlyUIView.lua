local base = UIBaseView
local LWResDoFlyUIView = BaseClass("LWResDoFlyUIView", UIBaseView)
local bag_obj_path = "safeArea/bagObj"

local function OnCreate(self)
  base.OnCreate(self)
  local defaultDelayTime = 1.8
  local showStayTime = 0.5
  local param = self:GetUserData()
  local stayTime = param.stayTime or defaultDelayTime
  local rewardType = param.rewardType
  local isHaveEndPos = param.isHaveEndPos
  local curTime = UITimeManager:GetInstance():GetServerTime() / 1000
  local closeTime = curTime + stayTime + showStayTime
  self.maxCloseTime = self.maxCloseTime or 0
  self.bagShow = self.bagShow or false
  if curTime > self.maxCloseTime then
    self.bagShow = false
  end
  if closeTime > self.maxCloseTime then
    self.maxCloseTime = closeTime
  end
  if not isHaveEndPos and self:IsBagShowByType(rewardType) then
    self.bagShow = true
  end
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.bag_obj = self:AddComponent(UIBaseContainer, bag_obj_path)
  self.bag_obj:SetActive(self.bagShow)
end

local function ComponentDestroy(self)
  self.bag_obj = nil
end

local function DataDefine(self)
  if self.autoCloseTime then
    self.autoCloseTime:Stop()
    self.autoCloseTime = nil
  end
  local curTime = UITimeManager:GetInstance():GetServerTime() / 1000
  local delayTime = self.maxCloseTime - curTime
  self.autoCloseTime = TimerManager:GetInstance():DelayInvoke(function()
    self.autoCloseTime = nil
    self.ctrl:CloseSelf()
  end, delayTime)
end

local function DataDestroy(self)
  if self.autoCloseTime then
    self.autoCloseTime:Stop()
    self.autoCloseTime = nil
  end
end

local function RefreshPanel(self)
  local bagPos = UIUtil.GetUIMainSavePos(UIMainSavePosType.BagBtn)
  self.bag_obj.transform:Set_position(bagPos.x, bagPos.y, bagPos.z)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshPanel(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function IsBagShowByType(self, rewardType)
  local result = rewardType == RewardType.GOODS
  return result
end

LWResDoFlyUIView.OnCreate = OnCreate
LWResDoFlyUIView.OnDestroy = OnDestroy
LWResDoFlyUIView.ComponentDefine = ComponentDefine
LWResDoFlyUIView.ComponentDestroy = ComponentDestroy
LWResDoFlyUIView.DataDefine = DataDefine
LWResDoFlyUIView.DataDestroy = DataDestroy
LWResDoFlyUIView.RefreshPanel = RefreshPanel
LWResDoFlyUIView.OnEnable = OnEnable
LWResDoFlyUIView.OnDisable = OnDisable
LWResDoFlyUIView.OnAddListener = OnAddListener
LWResDoFlyUIView.OnRemoveListener = OnRemoveListener
LWResDoFlyUIView.IsBagShowByType = IsBagShowByType
return LWResDoFlyUIView
