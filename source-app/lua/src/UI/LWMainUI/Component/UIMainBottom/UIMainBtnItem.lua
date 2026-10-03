local UIMainBtnItem = BaseClass("UIMainBtnItem", UIBaseContainer)
local base = UIBaseContainer
local BirthdayGoodsTipBtn = require("UI.LWMainUI.Component.UIMainBottom.Birthday.BirthdayGoodsTipBtn")
local build_btn_path = "buildBtn"
local common_red_point_path = "CommonRedPoint"

local function OnCreate(self, id)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:TryDestroyBirthdayTip()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, build_btn_path)
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

local function DataDefine(self)
  self.type = nil
end

local function DataDestroy(self)
  self.type = nil
end

function UIMainBtnItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnBirthdayLetterRewardGetTipStatusChange, self.OnBirthdayLetterRewardGetTipStatusChange)
end

function UIMainBtnItem:OnRemoveListener()
  self:RemoveUIListener(EventId.OnBirthdayLetterRewardGetTipStatusChange, self.OnBirthdayLetterRewardGetTipStatusChange)
  base.OnRemoveListener(self)
end

local function ReInit(self, param)
  self.type = param
  if self.type == UIMainFunctionInfo.Goods then
    self.commonRedPoint:SetId(self.type)
  end
  self:RefreshData()
  self:TryDestroyBirthdayTip()
  self:OnBirthdayLetterRewardGetTipStatusChange()
end

function UIMainBtnItem:SetRedPointType(priority)
  if self.commonRedPoint then
    self.commonRedPoint:SetType(priority)
  end
end

local function RefreshData(self)
  self:OnUpdateRedPot()
end

local function OnUpdateRedPot(self)
  local num, rewardNum, tipNum = self.view.ctrl:GetRedPotCountByType(self.type)
  if 0 < rewardNum then
    self.commonRedPoint:SetNum(rewardNum)
  else
    self.commonRedPoint:SetDefaultVisible(0 < tipNum)
  end
end

function UIMainBtnItem:HideRedPoint()
  self.commonRedPoint:SetActive(false)
end

local function OnClick(self)
  self.commonRedPoint:SetViewed()
  self.view.ctrl:OnFunctionClick(self.type)
end

function UIMainBtnItem:OnBirthdayLetterRewardGetTipStatusChange()
  if self.type ~= UIMainFunctionInfo.Goods then
    return
  end
  local data = DataCenter.BirthdayDataManager.isBirthdayLetterRewardGetTip
  if data then
    self:TryShowBirthdayTip()
  else
    self:TryDestroyBirthdayTip()
  end
end

function UIMainBtnItem:TryShowBirthdayTip()
  local isShow = DataCenter.BirthdayDataManager.isBirthdayLetterRewardGetTip
  if isShow == false then
    return
  end
  if self.tipReq ~= nil then
    return
  end
  self.tipReq = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWMainUI/Birthday/BirthdayBagItemTipBtn.prefab", function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.name = "BirthdayBagItemTipBtn"
    go:SetActive(true)
    go.transform:SetParent(self.btn.transform)
    local BirthdayBagItemTipBtn = self.btn:AddComponent(BirthdayGoodsTipBtn, "BirthdayBagItemTipBtn")
    BirthdayBagItemTipBtn:SetAsLastSibling()
    BirthdayBagItemTipBtn:SetLocalScaleXYZ(1, 1, 1)
    if CommonUtil.IsArabicAutoMirrorOpen() then
      BirthdayBagItemTipBtn:SetAnchorMinXY(1, 0.5)
      BirthdayBagItemTipBtn:SetAnchorMaxXY(1, 0.5)
      BirthdayBagItemTipBtn:SetPivotXY(0, 0.5)
    else
      BirthdayBagItemTipBtn:SetAnchorMinXY(0, 0.5)
      BirthdayBagItemTipBtn:SetAnchorMaxXY(0, 0.5)
      BirthdayBagItemTipBtn:SetPivotXY(1, 0.5)
    end
    BirthdayBagItemTipBtn:SetAnchoredPositionXY(0, 0)
  end)
end

function UIMainBtnItem:TryDestroyBirthdayTip()
  if self.tipReq ~= nil then
    self.btn:RemoveComponent("BirthdayBagItemTipBtn", BirthdayGoodsTipBtn)
    self:GameObjectDestroy(self.tipReq)
    self.tipReq = nil
  end
end

UIMainBtnItem.OnCreate = OnCreate
UIMainBtnItem.OnDestroy = OnDestroy
UIMainBtnItem.OnEnable = OnEnable
UIMainBtnItem.OnDisable = OnDisable
UIMainBtnItem.ComponentDefine = ComponentDefine
UIMainBtnItem.ComponentDestroy = ComponentDestroy
UIMainBtnItem.DataDefine = DataDefine
UIMainBtnItem.DataDestroy = DataDestroy
UIMainBtnItem.RefreshData = RefreshData
UIMainBtnItem.OnUpdateRedPot = OnUpdateRedPot
UIMainBtnItem.OnClick = OnClick
UIMainBtnItem.ReInit = ReInit
return UIMainBtnItem
