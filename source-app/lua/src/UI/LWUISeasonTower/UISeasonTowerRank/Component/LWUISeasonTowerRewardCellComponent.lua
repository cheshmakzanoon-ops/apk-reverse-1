local base = UIBaseContainer
local LWUISeasonTowerRewardCellComponent = BaseClass("LWUISeasonTowerRewardCellComponent", UIBaseContainer)
local LWSeasonTowerUtil = require("DataCenter.LWSeasonTowerManager.LWSeasonTowerUtil")
local Localization = CS.GameEntry.Localization

function LWUISeasonTowerRewardCellComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:AddCountDownTimer(self.ShowSpecialRewardEffect)
end

function LWUISeasonTowerRewardCellComponent:AddCountDownTimer(func)
  self:RemoveCountDownTimer()
  if self.countDownTimer == nil then
    self.countDownTimer = TimerManager:GetInstance():GetTimer(2, func, self, false, false, false)
    self.countDownTimer:Start()
  end
end

function LWUISeasonTowerRewardCellComponent:RemoveCountDownTimer()
  if self.countDownTimer then
    self.countDownTimer:Stop()
    self.countDownTimer = nil
  end
end

function LWUISeasonTowerRewardCellComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUISeasonTowerRewardCellComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.btnCommon = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnCommon:SetOnClick(function()
    self:OnBtnCommonClick()
  end)
  self.textUnFinish = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textButton = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.imgCommonButton = self.viewSkin:AddComponent(self, UIImage, 6)
  self.rewardScroll = self:AddComponent(UIScrollRect, "RewardScroll")
end

function LWUISeasonTowerRewardCellComponent:ComponentDestroy()
  self:RemoveCountDownTimer()
  self:ClearRewards()
  self.viewSkin = nil
  self.textDesc = nil
  self.compContent = nil
  self.btnCommon = nil
  self.textUnFinish = nil
  self.textButton = nil
  self.imgCommonButton = nil
  self.rewardScroll = nil
  self.rewardModels = nil
  self.viewData = nil
end

function LWUISeasonTowerRewardCellComponent:DataDefine()
  self.viewData = nil
  self.cellList = {}
end

function LWUISeasonTowerRewardCellComponent:DataDestroy()
  self.viewData = nil
  self.cellList = {}
end

function LWUISeasonTowerRewardCellComponent:OnAddListener()
  base.OnAddListener(self)
end

function LWUISeasonTowerRewardCellComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUISeasonTowerRewardCellComponent:OnBtnCommonClick()
  if self.viewData.received == SeasonTowerConfig.RewardState.Received then
    return
  end
  DataCenter.LWSeasonTowerManager:ClaimReward(self.stageId)
end

function LWUISeasonTowerRewardCellComponent:ClearRewards()
  if self.compContent ~= nil then
    self.compContent:RemoveComponents(UICommonResItem)
  end
  if self.rewardModels ~= nil then
    for _, v in pairs(self.rewardModels) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.rewardModels = nil
end

function LWUISeasonTowerRewardCellComponent:RefreshReward(rewardId, title)
  local rewardList = DeepCopy(DataCenter.RewardTemplateManager:GetList(rewardId)) or {}
  if not string.IsNullOrEmpty(title) and tostring(title) ~= "0" then
    local titleCell = LocalController:instance():tryGetLine(TableName.LW_TITLE, title)
    if titleCell ~= nil then
      table.insert(rewardList, 1, {
        rewardType = RewardType.RESOURCE_ITEM,
        itemId = titleCell.connect_resource_item,
        count = 1
      })
    end
  end
  self:ClearRewards()
  local list = rewardList or {}
  self.rewardModels = {}
  local count = #list
  if self.rewardScroll ~= nil then
    self.rewardScroll:SetEnable(3 < count)
  end
  for i = 1, count do
    self.rewardModels[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.compContent.transform)
      go.transform:Set_localScale(0.8, 0.8, 1)
      go.transform.pivot = Vector2.New(0.5, 0.5)
      go.name = "item" .. UIUtil.GetLoopListItemIndex()
      local cell = self.compContent:AddComponent(UICommonResItem, go.name)
      cell:ReInit(list[i])
      cell:SetSizeDelta(Vector2.New(150, 150))
      local itemId = list[i].itemId
      self.cellList[tostring(itemId)] = cell
      self:ShowSpecialRewardEffect()
    end)
  end
end

function LWUISeasonTowerRewardCellComponent:ShowSpecialRewardEffect()
  local reward = DataCenter.LWSeasonTowerManager:GetGroupRewardSpecialItem()
  if self.cellList[tostring(reward)] then
    self.cellList[tostring(reward)]:SetRewardEffect(0.7)
  end
end

function LWUISeasonTowerRewardCellComponent:SetData(viewData, selectIndex)
  if not viewData then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.viewData = viewData
  local configData = viewData.template
  local received = viewData.received
  self.stageId = viewData.stageId
  if selectIndex == SeasonTowerConfig.RewardType.Group then
    self.textDesc:SetText(Localization:GetString("season_tower_reward_point_goal", configData.score))
    self:RefreshReward(configData.rewardId, configData.titleId)
  elseif selectIndex == SeasonTowerConfig.RewardType.Stage then
    self.textDesc:SetText(Localization:GetString("season_tower_reward_floor", configData.floor))
    self:RefreshReward(configData.rewardId)
  end
  self.btnCommon:SetActive(received ~= SeasonTowerConfig.RewardState.NoComplete)
  self.imgCommonButton:LoadSprite(received == SeasonTowerConfig.RewardState.CanReceive and UIAssets.GREEN_BTN or UIAssets.GREY_BTN)
  self.textButton:SetLocalText(received == SeasonTowerConfig.RewardState.CanReceive and "season_tower_reward_get" or "season_tower_reward_done")
  self.textUnFinish:SetActive(received == SeasonTowerConfig.RewardState.NoComplete)
end

return LWUISeasonTowerRewardCellComponent
