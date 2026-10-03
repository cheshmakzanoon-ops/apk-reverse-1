local base = UIBaseContainer
local UILWTorchRelayMainGrowUpItemComponent = BaseClass("UILWTorchRelayMainGrowUpItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWTorchRelayMainGrowUpItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWTorchRelayMainGrowUpItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTorchRelayMainGrowUpItemComponent:ComponentDefine()
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.imgMainIcon = self:AddComponent(UIImage, "MainIcon")
  self.textTitle = self:AddComponent(UIText, "TitleText")
  self.imgPowerIcon = self:AddComponent(UIImage, "PowerIcon")
  self.textPower = self:AddComponent(UIText, "PowerText")
  self.textLevel = self:AddComponent(UIText, "LevelText")
  self.imgLevelUpIcon = self:AddComponent(UIImage, "LevelUpIcon")
  self.Background = self:AddComponent(UIImage, "Background")
end

function UILWTorchRelayMainGrowUpItemComponent:ComponentDestroy()
  self.imgMainIcon = nil
  self.textTitle = nil
  self.imgPowerIcon = nil
  self.textPower = nil
  self.textLevel = nil
  self.imgLevelUpIcon = nil
end

function UILWTorchRelayMainGrowUpItemComponent:DataDefine()
end

function UILWTorchRelayMainGrowUpItemComponent:DataDestroy()
end

function UILWTorchRelayMainGrowUpItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWTorchRelayMainGrowUpItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWTorchRelayMainGrowUpItemComponent:ReInit(activityId, type)
  self.type = type
  self.activityId = activityId
  self.data = DataCenter.ActivityTorchRelayManager:GetActivityData(activityId)
  if self.data == nil then
    return
  end
  self.textTitle:SetText(DataCenter.ActivityTorchRelayManager:GetGrowUpTypeName(type))
  local level = self.data:GetGrowUpLevelByType(self.type)
  self.textLevel:SetText("Lv." .. tostring(level))
  local isCanLevelUp, _ = self.data:IsCanGrowUpLevelUp(self.type)
  self.imgLevelUpIcon:SetActive(isCanLevelUp)
  local levelConfig = self.data:GetGrowUpConfig(type, level)
  if levelConfig ~= nil then
    self.textPower:SetText(DataCenter.ActivityTorchRelayManager:GetGrowUpValueDescription(levelConfig, activityId))
  end
  self.imgMainIcon:LoadSprite(self.data.config:GetGameSkillPic(self.type))
  self.imgPowerIcon:LoadSprite(self.data.config:GetGameSkillIcon(self.type))
  self.Background:LoadSpriteAsync(self.data.config:GetGameSkillPicBg())
end

function UILWTorchRelayMainGrowUpItemComponent:OnBtnClick()
  if self.activityId then
    local param = {
      activityId = self.activityId
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.TorchRelayGrowUp, {anim = true}, param)
  end
end

return UILWTorchRelayMainGrowUpItemComponent
