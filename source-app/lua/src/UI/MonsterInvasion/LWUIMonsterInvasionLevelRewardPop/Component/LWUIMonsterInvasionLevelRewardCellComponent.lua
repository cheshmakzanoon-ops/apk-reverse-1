local LWUIMonsterInvasionLevelRewardCellComponent = BaseClass("LWUIMonsterInvasionLevelRewardCellComponent", UIBaseContainer)
local LWUIMonsterInvasionLevelRewardItemRender = require("UI.MonsterInvasion.LWUIMonsterInvasionLevelRewardPop.Component.LWUIMonsterInvasionLevelRewardItemRenderComponent")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local fullBgPath = "Assets/Main/Sprites/UI/UISearch/%s.png"
local defaultBgIcon = "zyf_shijiesouguai_guaiwudikuang"
local fullPath = "Assets/Main/Sprites/UI/UIMonsterInvasion/%s.png"
local defaultIcon = "zyf_guaiwuruqin_sangshi"

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
  self.monsterBgImage = self:AddComponent(UIImage, "MonsterBg")
  self.monsterIcon = self:AddComponent(UIImage, "MonsterBg/MonsterIcon")
  self.titleText = self:AddComponent(UIText, "TitleText")
  self.desText = self:AddComponent(UIText, "DesText")
  self.rewardScrollView = self:AddComponent(UIScrollRect, "RewardContent/RewardScrollView")
  self.levelRewardContent = self:AddComponent(GridInfinityScrollView, "RewardContent/RewardScrollView/LevelRewardContent")
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.listGO = {}
  self.levelRewardContent:Init(bindFunc1, bindFunc2, bindFunc3)
end

local function ComponentDestroy(self)
  self:ClearScrollCell()
  self.monsterBgImage = nil
  self.monsterIcon = nil
  self.titleText = nil
  self.desText = nil
  self.rewardScrollView = nil
  self.levelRewardContent = nil
  self.listGO = nil
end

local function DataDefine(self)
  self.info = {}
  self.showRewardList = {}
end

local function DataDestroy(self)
  self.info = nil
  self.showRewardList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, info)
  self.info = info
  if self.info.iconName then
    self.monsterIcon:LoadSprite(string.format(fullPath, self.info.iconName))
  end
  local bgList = DataCenter.ActivityMonsterInvasionDataManager:GetRatityBgList()
  local find = false
  for _, v in ipairs(bgList) do
    if self.info.minLevel >= v.minLevel and self.info.maxLevel <= v.maxLevel then
      self.monsterBgImage:LoadSprite(string.format(fullBgPath, v.resourcePath))
      find = true
      break
    end
  end
  if not find then
    self.monsterBgImage:LoadSprite(string.format(fullBgPath, defaultBgIcon))
  end
  local str = Localization:GetString("monster_invasion_02")
  self.titleText:SetText(str .. self.info.minLevel .. "-" .. self.info.maxLevel)
  self:RefreshContent()
end

local function RefreshContent(self)
  self.showRewardList = DataCenter.ActivityMonsterInvasionDataManager:GetShowReward(self.info.rewardStr)
  local rewardCount = #self.showRewardList
  if 0 < rewardCount then
    self.levelRewardContent:SetItemCount(rewardCount)
  end
end

local function OnInitScroll(self, go, index)
  local item = self.rewardScrollView:AddComponent(LWUIMonsterInvasionLevelRewardItemRender, go)
  item:SetActive(false)
  self.listGO[go] = item
end

local function OnUpdateScroll(self, go, index)
  local cellItem = self.listGO[go]
  if cellItem then
    local theIndex = index + 1
    cellItem:SetActive(true)
    cellItem:ReInit(self.showRewardList[theIndex])
    if self.info.dayseffectNum then
      for _, value in ipairs(self.info.dayseffectNum) do
        if theIndex <= tonumber(value) then
          cellItem:AddHighLight()
          break
        end
      end
    end
  end
end

local function OnDestroyScrollItem(go, index)
end

local function ClearScrollCell(self)
  self.rewardScrollView:RemoveComponents(LWUIMonsterInvasionLevelRewardItemRender)
  self.levelRewardContent:DestroyChildNode()
end

LWUIMonsterInvasionLevelRewardCellComponent.OnCreate = OnCreate
LWUIMonsterInvasionLevelRewardCellComponent.OnDestroy = OnDestroy
LWUIMonsterInvasionLevelRewardCellComponent.OnEnable = OnEnable
LWUIMonsterInvasionLevelRewardCellComponent.OnDisable = OnDisable
LWUIMonsterInvasionLevelRewardCellComponent.ComponentDefine = ComponentDefine
LWUIMonsterInvasionLevelRewardCellComponent.ComponentDestroy = ComponentDestroy
LWUIMonsterInvasionLevelRewardCellComponent.DataDefine = DataDefine
LWUIMonsterInvasionLevelRewardCellComponent.DataDestroy = DataDestroy
LWUIMonsterInvasionLevelRewardCellComponent.OnAddListener = OnAddListener
LWUIMonsterInvasionLevelRewardCellComponent.OnRemoveListener = OnRemoveListener
LWUIMonsterInvasionLevelRewardCellComponent.SetData = SetData
LWUIMonsterInvasionLevelRewardCellComponent.RefreshContent = RefreshContent
LWUIMonsterInvasionLevelRewardCellComponent.OnInitScroll = OnInitScroll
LWUIMonsterInvasionLevelRewardCellComponent.OnUpdateScroll = OnUpdateScroll
LWUIMonsterInvasionLevelRewardCellComponent.OnDestroyScrollItem = OnDestroyScrollItem
LWUIMonsterInvasionLevelRewardCellComponent.ClearScrollCell = ClearScrollCell
return LWUIMonsterInvasionLevelRewardCellComponent
