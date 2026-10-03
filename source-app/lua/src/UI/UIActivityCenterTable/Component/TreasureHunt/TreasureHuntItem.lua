local TreasureHuntItem = BaseClass("TreasureHuntItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroCellBig = require("UI.UIHero2.Common.UIHeroCellBig")
local StayShakeAni = ""
local DrawCardAni = ""
local specialIndex = 1
local bgPath = "Assets/Main/Sprites/UI/UITreasureHuntActivity/cfm_huodong_wabao_ka_%s.png"

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
  self.itemCell = self:AddComponent(UICommonResItem, "Root/InfoPanel/itemContent/UICommonResItem")
  self.itemNum = self:AddComponent(UIText, "Root/InfoPanel/itemContent/itemNum")
  self.NodeEffectRoot = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot")
  self.NodeEffectRoot_1 = self:AddComponent(UIBaseContainer, "Root/NodeEffectRoot_1")
  self.NodeEffectRoot:SetActive(false)
  self.NodeEffectRoot_1:SetActive(false)
  self.bg = self:AddComponent(UIImage, "Root/InfoPanel/bg")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(BindCallback(self, self.OnCellClick))
  self.tipContent = self:AddComponent(UIBaseContainer, "Root/tipContent")
end

local function ComponentDestroy(self)
  self.rootNode = nil
  self.rootAni = nil
  self.infoPanel = nil
  self.itemContent = nil
  self.itemCell = nil
  self.itemNum = nil
  self.NodeEffectRoot = nil
  self.NodeEffectRoot_1 = nil
  self.bg = nil
  self.btn = nil
  self.tipContent = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function UpdateView(self)
  CS.UIGray.SetGray(self.rootNode.transform, false, true)
  self.rootAni:Enable(false)
  self.NodeEffectRoot:SetActive(false)
  self.NodeEffectRoot_1:SetActive(false)
  self.rewardIndex = -1
  if not self.digReward then
    local isMaxLevel = self:CheckIfIsMaxLv()
    local reward
    local targetLevel = isMaxLevel and self.digInfo.finishedLv or self.digInfo.finishedLv + 1
    reward = DataCenter.DigActivityManager:GetDiggedOutReward(self.digInfo.activityId, targetLevel, self.blockIndex)
    self.digReward = reward
    local rewardIndex = DataCenter.DigActivityManager:GetDiggedOutRewardIndex(self.digInfo.activityId, targetLevel, self.blockIndex)
    self.rewardIndex = rewardIndex
    if isMaxLevel then
      CS.UIGray.SetGray(self.rootNode.transform, true, true)
    end
  end
  if self.digReward and not string.IsNullOrEmpty(self.digReward.itemId) then
    self.infoPanel:SetActive(true)
    local rewardInfo = {}
    rewardInfo.rewardType = RewardType.GOODS
    rewardInfo.itemId = self.digReward.itemId
    rewardInfo.count = nil
    self.itemContent:SetActive(true)
    self.itemCell:ReInit(rewardInfo)
    self.itemNum:SetText("x" .. self.digReward.count)
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(rewardInfo.itemId)
    local color = itemTemplate.color
    self:SetItemQualityView(color)
  else
    self.infoPanel:SetActive(false)
  end
  self.tipContent:SetActive(false)
  if self.state == TreasureHuntActivityState.SelectBigReward and self.blockIndex == specialIndex and (not self.digReward or not not string.IsNullOrEmpty(self.digReward.itemId)) then
    self.tipContent:SetActive(true)
  end
  self:SetBgImg()
  self:SetEffect()
end

local function SetBgImg(self)
  if self.state == TreasureHuntActivityState.SelectBigReward and self.blockIndex == specialIndex then
    self.coverPanel:LoadSprite(string.format(bgPath, 1))
  else
    self.coverPanel:LoadSprite(string.format(bgPath, 2))
  end
end

local function SetEffect(self)
  local show = false
  if self.state == TreasureHuntActivityState.SelectBigReward then
    if self.blockIndex == specialIndex then
      show = true
    end
  elseif self.rewardIndex ~= nil and self.rewardIndex == 0 then
    show = true
  end
  self.NodeEffectRoot_1:SetActive(show)
end

local function SetItemQualityView(self, quality)
  if quality == 6 then
    self.bg:LoadSprite(string.format(bgPath, 8))
  elseif quality == 5 then
    self.bg:LoadSprite(string.format(bgPath, 7))
  elseif quality == 4 then
    self.bg:LoadSprite(string.format(bgPath, 6))
  elseif quality == 3 then
    self.bg:LoadSprite(string.format(bgPath, 5))
  elseif quality == 2 then
    self.bg:LoadSprite(string.format(bgPath, 4))
  elseif quality == 1 then
    self.bg:LoadSprite(string.format(bgPath, 3))
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
  self.coverPanel:LoadSprite(string.format(bgPath, 2))
end

local function SetNormalView(self)
  self:ResetAniVal()
  self.infoPanel:SetActive(true)
  self.NodeEffectRoot_1:SetActive(self.rewardIndex ~= nil and self.rewardIndex == 0)
end

local function ShowItem(self, activityId, digInfo, blockIndex)
  self.isPreview = false
  self.activityId = activityId
  self.digInfo = digInfo
  self.blockIndex = blockIndex
  self.digReward = nil
  self:UpdateView()
end

local function ShowPreview(self, activityId, digInfo, tempIndex, reward)
  self.isPreview = true
  self.activityId = activityId
  self.digInfo = digInfo
  self.blockIndex = tempIndex
  self.digReward = reward
  self:UpdateView()
end

local function SetClickCallBack(self, callBack)
  self.callBackFunc = callBack
end

local function SetCurState(self, state)
  self.state = state
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
    self.NodeEffectRoot:SetActive(true)
  end)
  self.aniSeq:AppendInterval(delayTime)
  self.aniSeq:AppendCallback(function()
    self:SetNormalView()
  end)
  self.aniSeq:AppendInterval(effectTime)
  self.aniSeq:AppendCallback(function()
    self.NodeEffectRoot:SetActive(false)
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

local function PlayGaikaAni(self)
end

local function CheckIfIsMaxLv(self)
  local level = self.digInfo.finishedLv
  local maxLvCount = DataCenter.DigActivityManager:GetMaxLvCount(self.activityId)
  return level >= maxLvCount
end

TreasureHuntItem.OnCreate = OnCreate
TreasureHuntItem.OnDestroy = OnDestroy
TreasureHuntItem.OnEnable = OnEnable
TreasureHuntItem.OnDisable = OnDisable
TreasureHuntItem.ComponentDefine = ComponentDefine
TreasureHuntItem.ComponentDestroy = ComponentDestroy
TreasureHuntItem.DataDefine = DataDefine
TreasureHuntItem.DataDestroy = DataDestroy
TreasureHuntItem.UpdateView = UpdateView
TreasureHuntItem.OnCellClick = OnCellClick
TreasureHuntItem.SetCoverView = SetCoverView
TreasureHuntItem.SetNormalView = SetNormalView
TreasureHuntItem.PlayOpenAni = PlayOpenAni
TreasureHuntItem.PlayFankaAni = PlayFankaAni
TreasureHuntItem.PlayGaikaAni = PlayGaikaAni
TreasureHuntItem.CloseAniSeq = CloseAniSeq
TreasureHuntItem.PlayCoverAniSeq = PlayCoverAniSeq
TreasureHuntItem.ShowItem = ShowItem
TreasureHuntItem.ShowPreview = ShowPreview
TreasureHuntItem.ResetAniVal = ResetAniVal
TreasureHuntItem.SetBgImg = SetBgImg
TreasureHuntItem.SetEffect = SetEffect
TreasureHuntItem.SetItemQualityView = SetItemQualityView
TreasureHuntItem.SetClickCallBack = SetClickCallBack
TreasureHuntItem.SetCurState = SetCurState
TreasureHuntItem.CheckIfIsMaxLv = CheckIfIsMaxLv
return TreasureHuntItem
