local DetectEventLevelUpRewardBtn = BaseClass("DetectEventLevelUpRewardBtn", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local btn_path = ""
local tipContent_path = "tipContent"
local rewardContent_path = "rewardContent"
local rewardImage_path = "rewardContent/bg/rewardImage"
local tween_path = "rewardContent/bg"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.shockTweenSeq = nil
end

local function OnDestroy(self)
  self:StopShockTween()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.clickBtn = self:AddComponent(UIButton, btn_path)
  self.clickBtn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.clickBtn:SetActive(false)
  self.tipContent = self:AddComponent(UIBaseContainer, tipContent_path)
  self.rewardContent = self:AddComponent(UIBaseContainer, rewardContent_path)
  self.rewardImage = self:AddComponent(UIImage, rewardImage_path)
  self.tween = self:AddComponent(UIBaseContainer, tween_path)
  self.tween:SetEulerAnglesXYZ(0, 0, 0)
end

local function ComponentDestroy(self)
  self.clickBtn = nil
  self.tipContent = nil
  self.rewardContent = nil
  self.rewardImage = nil
  self.tween = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  self:AddUIListener(EventId.DetectInfoChange, self.DoWhenDataChange)
  self:AddUIListener(EventId.GetAllDetectInfo, self.DoWhenDataChange)
  self:AddUIListener(EventId.DetectInfoChangeClaimLevelReward, self.DoWhenDataChange)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.DetectInfoChange, self.DoWhenDataChange)
  self:RemoveUIListener(EventId.GetAllDetectInfo, self.DoWhenDataChange)
  self:RemoveUIListener(EventId.DetectInfoChangeClaimLevelReward, self.DoWhenDataChange)
end

local function DoWhenDataChange(self)
  self:RefreshView()
end

local function RefreshView(self)
  local rewardLevel = DataCenter.RadarCenterDataManager:GetDetectInfoRewardLevel()
  local curLevel = DataCenter.RadarCenterDataManager:GetDetectInfoLevel()
  local maxLv = self.view.ctrl:GetDetectEventMaxLevel()
  if rewardLevel == curLevel and curLevel >= maxLv then
    self.clickBtn:SetActive(false)
    self:StopShockTween()
    self.tween:SetEulerAnglesXYZ(0, 0, 0)
  else
    self.clickBtn:SetActive(true)
    if rewardLevel < curLevel then
      self.tipContent:SetActive(false)
      self.rewardContent:SetActive(true)
      local template = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.DETECT_LEVEL), rewardLevel)
      if template ~= nil then
        local iconPath = string.format(LoadPath.RadarCenterPath, template.levelup_icon)
        self.rewardImage:LoadSprite(iconPath)
        self.rewardImage:SetNativeSize()
      end
      self:PlayShockTween()
    else
      self.tipContent:SetActive(true)
      self.rewardContent:SetActive(false)
      self:StopShockTween()
      self.tween:SetEulerAnglesXYZ(0, 0, 0)
    end
  end
end

local function OnBtnClick(self)
  if self.view.isPlayingOpenTween then
    return
  end
  local rewardLevel = DataCenter.RadarCenterDataManager:GetDetectInfoRewardLevel()
  local curLevel = DataCenter.RadarCenterDataManager:GetDetectInfoLevel()
  local maxLv = self.view.ctrl:GetDetectEventMaxLevel()
  if rewardLevel == curLevel and curLevel >= maxLv then
  elseif rewardLevel < curLevel then
    SFSNetwork.SendMessage(MsgDefines.DetectEventClaimLevelReward, rewardLevel)
  else
    UIUtil.ShowTipsId(801340)
  end
end

local function PlayShockTween(self)
  self:StopShockTween()
  local rotateTime = 0.08
  local rotate1 = Vector3.New(0, 0, 12)
  local rotate2 = Vector3.New(0, 0, -12)
  local rotateTime2 = 0.05
  local rotate3 = Vector3.New(0, 0, 6)
  local rotate4 = Vector3.New(0, 0, -6)
  self.tween:SetEulerAnglesXYZ(0, 0, 0)
  self.shockTweenSeq = DOTween.Sequence()
  self.shockTweenSeq:Append(self.tween.transform:DORotate(rotate1, rotateTime))
  self.shockTweenSeq:Append(self.tween.transform:DORotate(Vector3.zero, rotateTime))
  self.shockTweenSeq:Append(self.tween.transform:DORotate(rotate2, rotateTime))
  self.shockTweenSeq:Append(self.tween.transform:DORotate(Vector3.zero, rotateTime))
  self.shockTweenSeq:Append(self.tween.transform:DORotate(rotate3, rotateTime2))
  self.shockTweenSeq:Append(self.tween.transform:DORotate(Vector3.zero, rotateTime2))
  self.shockTweenSeq:Append(self.tween.transform:DORotate(rotate4, rotateTime2))
  self.shockTweenSeq:Append(self.tween.transform:DORotate(Vector3.zero, rotateTime2))
  self.shockTweenSeq:AppendInterval(rotateTime * 8)
  self.shockTweenSeq:SetLoops(-1)
end

local function StopShockTween(self)
  if self.shockTweenSeq ~= nil then
    self.shockTweenSeq:Kill()
    self.shockTweenSeq = nil
  end
end

DetectEventLevelUpRewardBtn.OnCreate = OnCreate
DetectEventLevelUpRewardBtn.OnDestroy = OnDestroy
DetectEventLevelUpRewardBtn.ComponentDefine = ComponentDefine
DetectEventLevelUpRewardBtn.ComponentDestroy = ComponentDestroy
DetectEventLevelUpRewardBtn.DataDefine = DataDefine
DetectEventLevelUpRewardBtn.DataDestroy = DataDestroy
DetectEventLevelUpRewardBtn.RefreshView = RefreshView
DetectEventLevelUpRewardBtn.OnAddListener = OnAddListener
DetectEventLevelUpRewardBtn.OnRemoveListener = OnRemoveListener
DetectEventLevelUpRewardBtn.DoWhenDataChange = DoWhenDataChange
DetectEventLevelUpRewardBtn.OnBtnClick = OnBtnClick
DetectEventLevelUpRewardBtn.PlayShockTween = PlayShockTween
DetectEventLevelUpRewardBtn.StopShockTween = StopShockTween
return DetectEventLevelUpRewardBtn
