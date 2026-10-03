local base = UIBaseContainer
local UILWTorchRelayGrowUpItemComponent = BaseClass("UILWTorchRelayGrowUpItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWTorchRelayGrowUpItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWTorchRelayGrowUpItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTorchRelayGrowUpItemComponent:ComponentDefine()
  self.imgMainIcon = self:AddComponent(UIImage, "Content/MainIcon")
  self.textTitle = self:AddComponent(UIText, "Content/TitleText")
  self.imgPowerIcon = self:AddComponent(UIImage, "Content/PowerIcon")
  self.textLevel = self:AddComponent(UIText, "Content/LevelText")
  self.compLevelUpIcon = self:AddComponent(UIBaseContainer, "Content/LevelUpIcon")
  self.textPower = self:AddComponent(UIText, "Content/Layout/PowerText")
  self.compNextPowerArrow = self:AddComponent(UIBaseContainer, "Content/Layout/NextPowerArrow")
  self.textNextPower = self:AddComponent(UIText, "Content/Layout/NextPowerText")
  self.btnUpgrade = self:AddComponent(UIButton, "UpgradeBtn")
  self.btnUpgrade:SetOnClick(function()
    self:OnBtnUpgradeClick()
  end)
  self.textBtn = self:AddComponent(UIText, "UpgradeBtn/Btn/BtnText")
  self.textBtn:SetText(Localization:GetString("activity_torch_relay_button_7"))
  self.textValue = self:AddComponent(UIText, "UpgradeBtn/Btn/Layout/ValueText")
  self.compLayoutBtn = self:AddComponent(UIBaseContainer, "UpgradeBtn/Btn/Layout")
  self.btnContent = self:AddComponent(UIButton, "Content")
  self.btnContent:SetOnClick(function()
    self:OnBtnContentClick()
  end)
  self.compTips = self:AddComponent(UIBaseContainer, "Tips")
  self.textTips = self:AddComponent(UIText, "Tips/TipsText")
  self.powerUpItemIcon = self:AddComponent(UIImage, "UpgradeBtn/Btn/Layout/Icon")
  self.Background = self:AddComponent(UIImage, "Content/Background")
end

function UILWTorchRelayGrowUpItemComponent:ComponentDestroy()
  self.imgMainIcon = nil
  self.textTitle = nil
  self.imgPowerIcon = nil
  self.textLevel = nil
  self.compLevelUpIcon = nil
  self.textPower = nil
  self.compNextPowerArrow = nil
  self.textNextPower = nil
  self.btnUpgrade = nil
  self.textBtn = nil
  self.textValue = nil
  self.btnContent = nil
  self.compTips = nil
  self.textTips = nil
  self.compLayoutBtn = nil
end

function UILWTorchRelayGrowUpItemComponent:DataDefine()
  self.isBlock = false
end

function UILWTorchRelayGrowUpItemComponent:DataDestroy()
  self.isBlock = nil
end

function UILWTorchRelayGrowUpItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWTorchRelayGrowUpItemComponent:ReInit(activityId, type)
  self.type = type
  self.activityId = activityId
  self.data = DataCenter.ActivityTorchRelayManager:GetActivityData(activityId)
  if self.data == nil then
    return
  end
  self.textTitle:SetText(DataCenter.ActivityTorchRelayManager:GetGrowUpTypeName(type))
  local level = self.data:GetGrowUpLevelByType(self.type)
  self.textLevel:SetText("Lv." .. tostring(level))
  local levelConfig = self.data:GetGrowUpConfig(type, level)
  if levelConfig == nil then
    return
  end
  self.textPower:SetText(DataCenter.ActivityTorchRelayManager:GetGrowUpValueDescription(levelConfig, activityId))
  self.imgMainIcon:LoadSprite(self.data.config:GetGameSkillPic(self.type))
  self.imgPowerIcon:LoadSprite(self.data.config:GetGameSkillIcon(self.type))
  self.Background:LoadSpriteAsync(self.data.config:GetGameSkillPicBg())
  local isCanLevelUp, _ = self.data:IsCanGrowUpLevelUp(self.type)
  self.compLevelUpIcon:SetActive(isCanLevelUp)
  self.compNextPowerArrow:SetActive(isCanLevelUp)
  self.textNextPower:SetActive(isCanLevelUp)
  if isCanLevelUp then
    local nextLevelConfig = self.data:GetGrowUpConfig(type, level + 1)
    if nextLevelConfig ~= nil then
      self.textNextPower:SetText(DataCenter.ActivityTorchRelayManager:GetGrowUpValueDescription(nextLevelConfig, activityId))
    end
  end
  local isMaxed = self.data:IsGrowUpLevelMaxed(self.type)
  self.btnUpgrade:SetActive(not isMaxed)
  if not isMaxed then
    self.textValue:SetText(levelConfig.costNum)
    if self.data:GetCurGrowUpLevelCostItemCount() >= levelConfig.costNum then
      self.textValue:SetColor(WhiteColor)
    else
      self.textValue:SetColor(RedColor)
    end
  else
    self.textLevel:SetText("MAX")
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compLayoutBtn.transform)
  self.compTips:SetActive(false)
  self.textTips:SetText(DataCenter.ActivityTorchRelayManager:GetGrowUpTips(levelConfig, activityId))
  self.isBlock = false
  if self.data.config then
    local stageConfig = self.data.config:GetStageConfigTemplate()
    self.powerUpItemIcon:LoadSpriteAsync(stageConfig:getMiniMileIcon())
  end
end

function UILWTorchRelayGrowUpItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWTorchRelayGrowUpItemComponent:OnBtnUpgradeClick()
  if self.isBlock then
    return
  end
  if self.data == nil then
    return
  end
  local isCanLevelUp, reason = self.data:IsCanGrowUpLevelUp(self.type)
  if isCanLevelUp then
    DataCenter.ActivityTorchRelayManager:SendGrowUpMsg(self.activityId, self.type)
    self.isBlock = true
  elseif reason == 1 then
    local curLevel = self.data:GetGrowUpLevelByType(self.type)
    local curLevelConfig = self.data:GetGrowUpConfig(self.type, curLevel)
    if curLevelConfig ~= nil then
      LWResourceLackUtil:GotoGoodsItemLack(self.data.config.distance_score_id, curLevelConfig.costNum - self.data:GetCurGrowUpLevelCostItemCount())
    end
  elseif reason == 2 then
    UIUtil.ShowTips(Localization:GetString("activity_torch_relay_desc_42"))
  end
end

function UILWTorchRelayGrowUpItemComponent:OnBtnContentClick()
  self.compTips:SetActive(true)
  if self.holder then
    self.holder:OnTipsShow()
  end
end

function UILWTorchRelayGrowUpItemComponent:HideTips()
  if self.compTips then
    self.compTips:SetActive(false)
  end
end

return UILWTorchRelayGrowUpItemComponent
