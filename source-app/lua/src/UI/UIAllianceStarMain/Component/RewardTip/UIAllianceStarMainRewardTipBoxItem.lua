local UIAllianceStarMainRewardTipBoxItem = BaseClass("UIAllianceStarMainRewardTipBoxItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.imgIcon = self:AddComponent(UIImage, "IconImg")
  self.textNum = self:AddComponent(UITextMeshProUGUIEx, "NumBg/NumText")
end

local function ComponentDestroy(self)
  self.imgIcon = nil
  self.textNum = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function Refresh(self, rewardSetting, claimedIndex)
  self.textNum:SetText(rewardSetting[1])
  if claimedIndex >= rewardSetting[3] then
    self.imgIcon:LoadSprite(string.format(LoadPath.UIPersonalArms, AlStarRewardBoxImg[rewardSetting[3]].boxOpenImg))
  else
    self.imgIcon:LoadSprite(string.format(LoadPath.UIPersonalArms, AlStarRewardBoxImg[rewardSetting[3]].boxCloseImg))
  end
end

UIAllianceStarMainRewardTipBoxItem.OnCreate = OnCreate
UIAllianceStarMainRewardTipBoxItem.OnDestroy = OnDestroy
UIAllianceStarMainRewardTipBoxItem.OnEnable = OnEnable
UIAllianceStarMainRewardTipBoxItem.OnDisable = OnDisable
UIAllianceStarMainRewardTipBoxItem.ComponentDefine = ComponentDefine
UIAllianceStarMainRewardTipBoxItem.ComponentDestroy = ComponentDestroy
UIAllianceStarMainRewardTipBoxItem.DataDefine = DataDefine
UIAllianceStarMainRewardTipBoxItem.DataDestroy = DataDestroy
UIAllianceStarMainRewardTipBoxItem.OnAddListener = OnAddListener
UIAllianceStarMainRewardTipBoxItem.OnRemoveListener = OnRemoveListener
UIAllianceStarMainRewardTipBoxItem.Refresh = Refresh
return UIAllianceStarMainRewardTipBoxItem
