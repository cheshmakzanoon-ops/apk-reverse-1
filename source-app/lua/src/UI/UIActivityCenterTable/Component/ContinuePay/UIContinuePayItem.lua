local UIContinuePayItem = BaseClass("UIContinuePayItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIItemCell = require("UI.UIHero2.Common.UIItemCell")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:CloseAniSeq()
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
  self.rootNode = self:AddComponent(UIBaseContainer, "")
  self.rootAni = self:AddComponent(UIAnimator, "")
  self.rootAni:Enable(false)
  self.infoPanel = self:AddComponent(UIBaseContainer, "Root/InfoPanel")
  self.coverPanel = self:AddComponent(UIImage, "Root/CoverPanel")
  self.itemContent = self:AddComponent(UIBaseContainer, "Root/InfoPanel/itemContent")
  self.itemCell = self:AddComponent(UIItemCell, "Root/InfoPanel/itemContent/UIItemCell")
  self.commonResItem = self:AddComponent(UICommonResItem, "Root/InfoPanel/itemContent/Reward")
  self.itemNum = self:AddComponent(UIText, "Root/InfoPanel/itemContent/itemNum")
  self.NodeEffectRoot = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot")
  self.NodeEffectRoot_1 = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot_1")
  self.NodeEffectRoot:SetActive(false)
  self.NodeEffectRoot_1:SetActive(false)
  self.bg = self:AddComponent(UIImage, "Root/InfoPanel/bg")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(BindCallback(self, self.OnCellClick))
end

local function ComponentDestroy(self)
  self.rootNode = nil
  self.rootAni = nil
  self.infoPanel = nil
  self.itemContent = nil
  self.itemCell = nil
  self.commonResItem = nil
  self.itemNum = nil
  self.NodeEffectRoot = nil
  self.NodeEffectRoot_1 = nil
  self.bg = nil
  self.btn = nil
end

local function DataDefine(self)
  self.reward = nil
end

local function DataDestroy(self)
  self.reward = nil
end

local function UpdateView(self)
  CS.UIGray.SetGray(self.rootNode.transform, false, true)
  self.rootAni:Enable(false)
  self.NodeEffectRoot:SetActive(false)
  self.NodeEffectRoot_1:SetActive(false)
  self.rewardIndex = -1
  if self.reward and not string.IsNullOrEmpty(self.reward.itemId) then
    self.coverPanel:SetActive(false)
    self.infoPanel:SetActive(true)
    self.commonResItem:ReInit(self.reward)
  else
    self.coverPanel:SetActive(true)
    self.infoPanel:SetActive(false)
  end
end

local function OnCellClick(self)
  if self.callBackFunc ~= nil then
    self.callBackFunc()
  end
end

local function ResetAniVal(self)
  self.rootAni:Enable(false)
  self.rootNode:SetAnchoredPositionXY(0, 0)
  self.rootNode:SetEulerAnglesXYZ(0, 0, 0)
  self.rootNode:SetLocalScaleXYZ(1, 1, 1)
  self.rootAni:SetAnchoredPositionXY(0, 0)
  self.rootAni:SetEulerAnglesXYZ(0, 0, 0)
  self.rootAni:SetLocalScaleXYZ(1, 1, 1)
  self.infoPanel:SetEulerAnglesXYZ(0, 0, 0)
end

local function SetCoverView(self)
  self:ResetAniVal()
  self.infoPanel:SetActive(false)
end

local function SetNormalView(self)
  self:ResetAniVal()
  self.infoPanel:SetActive(true)
  self.NodeEffectRoot_1:SetActive(self.rewardIndex ~= nil and self.rewardIndex == 0)
end

local function ShowItem(self, activityId, blockIndex)
  self.activityId = activityId
  self.blockIndex = blockIndex
  local reward = DataCenter.ContinuePayActivityManager:GetRewardByIndex(self.blockIndex).reward[1]
  if reward then
    self.reward = {
      rewardType = reward.type,
      count = reward.value.num,
      itemId = reward.value.id
    }
  else
    self.reward = nil
  end
  self:UpdateView()
end

local function SetClickCallBack(self, callBack)
  self.callBackFunc = callBack
end

local function CloseAniSeq(self)
  if self.aniSeq ~= nil then
    self.aniSeq:Kill()
    self.aniSeq = nil
  end
end

local function PlayCoverAniSeq(self)
  self:CloseAniSeq()
  self.NodeEffectRoot:SetActive(false)
  self.NodeEffectRoot_1:SetActive(false)
  local rotateTime = 0.3
  self.aniSeq = DOTween.Sequence()
  self.aniSeq:Append(self.rootAni.transform:DORotate(Vector3(0, 90, 0), rotateTime))
  self:SetCoverView()
  self.aniSeq:Append(self.rootAni.transform:DORotate(Vector3(0, 0, 0), rotateTime))
  self.aniSeq:OnComplete(function()
    self:CloseAniSeq()
  end)
end

local function PlayOpenAni(self)
  self:CloseAniSeq()
  local delayTime = 0.1
  local effectTime = 1
  self.aniSeq = DOTween.Sequence()
  self.aniSeq:AppendCallback(function()
  end)
  self.aniSeq:AppendInterval(delayTime)
  self.aniSeq:AppendCallback(function()
    self:SetNormalView()
  end)
  self.aniSeq:AppendInterval(effectTime)
  self.aniSeq:AppendCallback(function()
  end)
  self.aniSeq:OnComplete(function()
    self:CloseAniSeq()
  end)
end

local function PlayFankaAni(self)
  self:CloseAniSeq()
  local effectTime = 1
  self.aniSeq = DOTween.Sequence()
  self.aniSeq:AppendCallback(function()
    self.rootAni:Enable(true)
    self.rootAni:Play("Eff_ui_wabao_fanka")
  end)
  self.aniSeq:AppendInterval(effectTime)
  self.aniSeq:AppendCallback(function()
    self.rootAni:Enable(false)
  end)
  self.aniSeq:OnComplete(function()
    self:CloseAniSeq()
  end)
end

UIContinuePayItem.OnCreate = OnCreate
UIContinuePayItem.OnDestroy = OnDestroy
UIContinuePayItem.OnEnable = OnEnable
UIContinuePayItem.OnDisable = OnDisable
UIContinuePayItem.ComponentDefine = ComponentDefine
UIContinuePayItem.ComponentDestroy = ComponentDestroy
UIContinuePayItem.DataDefine = DataDefine
UIContinuePayItem.DataDestroy = DataDestroy
UIContinuePayItem.UpdateView = UpdateView
UIContinuePayItem.OnCellClick = OnCellClick
UIContinuePayItem.SetCoverView = SetCoverView
UIContinuePayItem.SetNormalView = SetNormalView
UIContinuePayItem.PlayOpenAni = PlayOpenAni
UIContinuePayItem.PlayFankaAni = PlayFankaAni
UIContinuePayItem.CloseAniSeq = CloseAniSeq
UIContinuePayItem.PlayCoverAniSeq = PlayCoverAniSeq
UIContinuePayItem.ShowItem = ShowItem
UIContinuePayItem.ResetAniVal = ResetAniVal
UIContinuePayItem.SetClickCallBack = SetClickCallBack
return UIContinuePayItem
