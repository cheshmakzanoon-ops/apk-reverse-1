local UIDailyPackBtn = BaseClass("UIDailyPackBtn", UIBaseContainer)
local base = UIBaseContainer

local function RefrehsRedPoint(self, list)
  self.redPoint:SetActive(false)
end

local function RefreshShowState(self)
  local show = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.MainUI_GiftPack)
  if show then
    local list = WelfareController.getShowTagInfosWithType(RechargeEntryType.DailySale)
    if list and 0 < #list then
      show = true
    else
      show = false
    end
  end
  if show then
    self:SetActive(true)
    local showNewTag = self:RefreshNewTag()
    if not showNewTag then
      RefrehsRedPoint(self)
    else
      self.redPoint:SetActive(false)
    end
  else
    self:SetActive(false)
  end
end

local function OnBtnClick(self)
  GoToUtil.GotoOpenView(UIWindowNames.LWBuyDiamond, {
    anim = false,
    UIMainAnim = UIMainAnimType.AllHide
  }, nil, nil, RechargeEntryType.DailySale)
  CommonUtil.FeatureExplorationTrack(FeatureExplorationType.DailyPack)
end

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshNewTag()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.nameText = self:AddComponent(UIText, "NameText")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    OnBtnClick(self)
  end)
  self.nameText:SetLocalText(2000088)
  self.redPoint = self:AddComponent(UIBaseContainer, "RedPoint")
  self.newTag = self:AddComponent(UIBaseContainer, "DailyPackNew")
  self.newTagText = self:AddComponent(UIText, "DailyPackNew/Bg/Text")
  self.newTagText:SetText("NEW")
end

local function ComponentDestroy(self)
  self.nameText = nil
  self.btn = nil
  self.redPoint = nil
  self.newTag = nil
  self.newTagText = nil
end

local function DataDefine(self)
  self.hasSetName = false
end

local function DataDestroy(self)
  self.hasSetName = false
end

local function RefreshNewTag(self)
  if self.activeSelf then
    self.newTag:SetActive(false)
  end
  return false
end

local function HideNewTag(self)
  self.newTag:SetActive(false)
  RefrehsRedPoint(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.EnterDailyPack, self.HideNewTag)
  self:AddUIListener(EventId.RefreshMainUIDailyPackBtnNewTag, self.OnRefreshNewTag)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.EnterDailyPack, self.HideNewTag)
  self:RemoveUIListener(EventId.RefreshMainUIDailyPackBtnNewTag, self.OnRefreshNewTag)
end

function UIDailyPackBtn:OnRefreshNewTag()
  local showNewTag = self:RefreshNewTag()
  if not showNewTag then
    RefrehsRedPoint(self)
  else
    self.redPoint:SetActive(false)
  end
end

UIDailyPackBtn.OnCreate = OnCreate
UIDailyPackBtn.OnDestroy = OnDestroy
UIDailyPackBtn.OnEnable = OnEnable
UIDailyPackBtn.OnDisable = OnDisable
UIDailyPackBtn.ComponentDefine = ComponentDefine
UIDailyPackBtn.ComponentDestroy = ComponentDestroy
UIDailyPackBtn.DataDefine = DataDefine
UIDailyPackBtn.DataDestroy = DataDestroy
UIDailyPackBtn.RefreshShowState = RefreshShowState
UIDailyPackBtn.RefreshNewTag = RefreshNewTag
UIDailyPackBtn.HideNewTag = HideNewTag
UIDailyPackBtn.OnAddListener = OnAddListener
UIDailyPackBtn.OnRemoveListener = OnRemoveListener
return UIDailyPackBtn
