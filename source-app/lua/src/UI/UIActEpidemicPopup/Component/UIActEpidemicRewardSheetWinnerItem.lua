local UIActEpidemicRewardSheetWinnerItem = BaseClass("UIActEpidemicRewardSheetWinnerItem", UIBaseContainer)
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
  self.scrollRectScrollView = self:AddComponent(UIScrollRect, "ScrollView")
  self.imgImtTitleLeft = self:AddComponent(UIImage, "ImtTitleLeft")
  self.imgImtTitleRight = self:AddComponent(UIImage, "ImtTitleLeft/ImtTitleRight")
  self.textRankText2 = self:AddComponent(UITextMeshProUGUIEx, "ImtTitleLeft/RankText2")
  self.compContent = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content")
end

local function ComponentDestroy(self)
  self.scrollRectScrollView = nil
  self.imgImtTitleLeft = nil
  self.imgImtTitleRight = nil
  self.textRankText2 = nil
  self.compContent = nil
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

function UIActEpidemicRewardSheetWinnerItem:SetAllRewardsDestroy()
  self.compContent:RemoveComponents(UICommonResItem)
  if self.rewardModels ~= nil then
    for _, v in pairs(self.rewardModels) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.rewardModels = {}
  self.rewardItemsList = {}
end

function UIActEpidemicRewardSheetWinnerItem:GetKey(isAlliance, isWin)
  if isAlliance then
    if isWin then
      return "YiBianJinQu_reward_tips_6"
    else
      return "YiBianJinQu_reward_tips_8"
    end
  elseif isWin then
    return "YiBianJinQu_reward_tips_7"
  else
    return "YiBianJinQu_reward_tips_9"
  end
end

function UIActEpidemicRewardSheetWinnerItem:GetBg(isAlliance, isWin)
  return string.format(LoadPath.LWBattleFieldEpidemicPath, isWin and "mjc_guanzhijineng_sidai" or "mjc_yibianjinqu_sidai_shibai")
end

function UIActEpidemicRewardSheetWinnerItem:ReInit(index, data)
  self:SetAllRewardsDestroy()
  local list = DataCenter.ActMeteoriteBattleManager:GetRewardsById(data.rewardId)
  self.rewardModelCount = 0
  local key = self:GetKey(data.alliance, data.win)
  local bg = self:GetBg(data.alliance, data.win)
  self.textRankText2:SetLocalText(key)
  self.imgImtTitleLeft:LoadSprite(bg)
  self.imgImtTitleRight:LoadSprite(bg)
  for i, v in ipairs(list) do
    self.rewardModelCount = self.rewardModelCount + 1
    self.rewardModels[self.rewardModelCount] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.compContent.transform)
      go.transform.localScale = Vector3.New(1, 1, 1)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      local cell = self.compContent:AddComponent(UICommonResItem, nameStr)
      cell:ReInit(list[i])
      table.insert(self.rewardItemsList, cell)
    end)
  end
end

UIActEpidemicRewardSheetWinnerItem.OnCreate = OnCreate
UIActEpidemicRewardSheetWinnerItem.OnDestroy = OnDestroy
UIActEpidemicRewardSheetWinnerItem.OnEnable = OnEnable
UIActEpidemicRewardSheetWinnerItem.OnDisable = OnDisable
UIActEpidemicRewardSheetWinnerItem.ComponentDefine = ComponentDefine
UIActEpidemicRewardSheetWinnerItem.ComponentDestroy = ComponentDestroy
UIActEpidemicRewardSheetWinnerItem.DataDefine = DataDefine
UIActEpidemicRewardSheetWinnerItem.DataDestroy = DataDestroy
UIActEpidemicRewardSheetWinnerItem.OnAddListener = OnAddListener
UIActEpidemicRewardSheetWinnerItem.OnRemoveListener = OnRemoveListener
return UIActEpidemicRewardSheetWinnerItem
