local UIPlayerLevelPackageRewardItem = BaseClass("UIPlayerLevelPackageRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self.commonResItem = self:AddComponent(UICommonResItem, "Content/UICommonResItem")
  self.nameText = self:AddComponent(UIText, "Content/RewardNameText")
  self.countText = self:AddComponent(UIText, "Content/RewardCountText")
  self.param = nil
  self.bg = self:AddComponent(UIImage, "Content")
  self.bg1 = self:AddComponent(UIImage, "Content/Bg1")
  self.content = self:AddComponent(UIAnimator, "Content")
  self.extraFlag = self:AddComponent(UIImage, "Content/ExtraFlag")
  self.openAniDelayTimer = nil
end

local function OnDestroy(self)
  self.commonResItem = nil
  self.nameText = nil
  self.countText = nil
  self.param = nil
  self.bg = nil
  self.bg1 = nil
  self.content = nil
  self.extraFlag = nil
  self:CloseOpenAniTimer()
  base.OnDestroy(self)
end

local function ReInit(self, param, rechargeId, waitShowTime)
  self.param = param
  self.commonResItem:ReInit(param)
  self.commonResItem:SetItemCountActive(false)
  local name
  if not string.IsNullOrEmpty(param.itemName) then
    name = param.itemName
  else
    name = DataCenter.RewardManager:GetNameByType(param.rewardType, param.itemId)
  end
  self.nameText:SetText(name)
  self.countText:SetText(param.count)
  local rechargeLine = DataCenter.RechargeManager:GetLine(rechargeId)
  if rechargeLine.resource_config2_list and #rechargeLine.resource_config2_list == 2 and #rechargeLine.resource_config2_list[1] == 4 then
    self.bg:SetColorRGBA255(rechargeLine.resource_config2_list[1][1], rechargeLine.resource_config2_list[1][2], rechargeLine.resource_config2_list[1][3], rechargeLine.resource_config2_list[1][4])
  end
  self:CloseOpenAniTimer()
  if waitShowTime and 0 < waitShowTime then
    self.content:SetSpeed(0)
    self.content:SampleAnimationAtTime("Eff_UIPlayerLevelPackagePageRewardItem_In", 0)
    self.content:Play("Eff_UIPlayerLevelPackagePageRewardItem_In")
    self.openAniDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.content:SetSpeed(1)
      self.content:Play("Eff_UIPlayerLevelPackagePageRewardItem_In")
    end, waitShowTime)
  else
    self.content:SetSpeed(1)
    self.content:Play("Eff_UIPlayerLevelPackagePageRewardItem_In")
  end
  self.extraFlag:SetActive(self.param.isShowExtraFlag)
  if self.param.isShowExtraFlag then
    self.extraFlag:LoadSpriteAsyncWithCallback("Assets/Main/Sprites/UI/PyramidSpeedUp/zxl_ewai_wenzi.png", function(sprite)
      if self.extraFlag then
        self.extraFlag:SetNativeSize()
      end
    end)
  end
end

local function CloseOpenAniTimer(self)
  if self.openAniDelayTimer then
    self.openAniDelayTimer:Stop()
    self.openAniDelayTimer = nil
  end
end

UIPlayerLevelPackageRewardItem.OnCreate = OnCreate
UIPlayerLevelPackageRewardItem.OnDestroy = OnDestroy
UIPlayerLevelPackageRewardItem.ReInit = ReInit
UIPlayerLevelPackageRewardItem.CloseOpenAniTimer = CloseOpenAniTimer
return UIPlayerLevelPackageRewardItem
