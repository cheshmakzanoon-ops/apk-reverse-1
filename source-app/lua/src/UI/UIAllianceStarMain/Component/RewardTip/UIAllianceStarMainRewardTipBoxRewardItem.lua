local UIAllianceStarMainRewardTipBoxRewardItem = BaseClass("UIAllianceStarMainRewardTipBoxRewardItem", UIBaseContainer)
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
  self.imgBox = self:AddComponent(UIImage, "BoxImg")
  self.scrollView = self:AddComponent(UIScrollRect, "ScrollView")
  self.compContent = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content")
  self.resItemPool = self.transform:Find("ScrollView/Viewport/Content/ResItem").gameObject
  self.resItemPool:SetActive(false)
  self.resItemPool:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self.compContent:RemoveComponents(UICommonResItem)
  self.resItemPool:GameObjectRecycleAll()
  self.resItemPool = nil
  self.imgBox = nil
  self.scrollView = nil
  self.compContent = nil
end

local function DataDefine(self)
  self.resItems = {}
end

local function DataDestroy(self)
  self.resItems = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function Refresh(self, rewardSetting)
  local rewardId = rewardSetting[2]
  local rewardIndex = rewardSetting[3]
  self.imgBox:LoadSprite(string.format(LoadPath.UIPersonalArms, AlStarRewardBoxImg[rewardIndex].closeImg))
  local rewardList = DataCenter.RewardTemplateManager:GetList(rewardId)
  local rewardCount = #rewardList
  for i = 1, rewardCount do
    local resItem = self.resItems[i]
    if resItem == nil then
      local obj = self.resItemPool:GameObjectSpawn(self.compContent.transform)
      obj.name = "resItem" .. i
      resItem = self.compContent:AddComponent(UICommonResItem, obj.name)
      self.resItems[i] = resItem
    end
    resItem:SetActive(true)
    resItem:ReInit(rewardList[i])
  end
  for i = rewardCount + 1, #self.resItems do
    self.resItems[i]:SetActive(false)
  end
end

UIAllianceStarMainRewardTipBoxRewardItem.OnCreate = OnCreate
UIAllianceStarMainRewardTipBoxRewardItem.OnDestroy = OnDestroy
UIAllianceStarMainRewardTipBoxRewardItem.OnEnable = OnEnable
UIAllianceStarMainRewardTipBoxRewardItem.OnDisable = OnDisable
UIAllianceStarMainRewardTipBoxRewardItem.ComponentDefine = ComponentDefine
UIAllianceStarMainRewardTipBoxRewardItem.ComponentDestroy = ComponentDestroy
UIAllianceStarMainRewardTipBoxRewardItem.DataDefine = DataDefine
UIAllianceStarMainRewardTipBoxRewardItem.DataDestroy = DataDestroy
UIAllianceStarMainRewardTipBoxRewardItem.OnAddListener = OnAddListener
UIAllianceStarMainRewardTipBoxRewardItem.OnRemoveListener = OnRemoveListener
UIAllianceStarMainRewardTipBoxRewardItem.Refresh = Refresh
return UIAllianceStarMainRewardTipBoxRewardItem
