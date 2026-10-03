local base = UIBaseContainer
local GhostTargetItem = BaseClass("GhostTargetItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local RewardItem = require("UI.UIGhostParkour.Outside.BattlePassReward.Component.GhostRewardItem")
local UIGray = CS.UIGray

function GhostTargetItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitUI()
  self.textTxtReward:SetLocalText("parkour_get_reward_btn")
end

function GhostTargetItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function GhostTargetItem:ComponentDefine()
  self.rewardContent = self:AddComponent(UIBaseContainer, "Rect_Reward/Viewport/Content")
  self.btnReward = self:AddComponent(UIButton, "Btn_Reward")
  self.btnReward:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
  self.textTxtReward = self:AddComponent(UITextMeshProUGUIEx, "Btn_Reward/Txt_Reward")
  self.imgScoreIcon = self:AddComponent(UIImage, "ScoreIcon")
  self.textTargetScore = self:AddComponent(UITextMeshProUGUIEx, "TargetScoreText")
  self.rewardItem = self:AddComponent(UIBaseComponent, "Rect_Reward/UIRewardItem")
  self.rewardItem.gameObject:SetActive(false)
  self.rewardItemPool = self.rewardItem.gameObject
  self.rewardItemPool:GameObjectCreatePool()
  self.rewardItems = {}
end

function GhostTargetItem:ComponentDestroy()
  self.rewardContent = nil
  self.rewardItem = nil
  self.btnReward = nil
  self.textTxtReward = nil
  self.imgScoreIcon = nil
  self.textTargetScore = nil
end

function GhostTargetItem:DataDefine()
end

function GhostTargetItem:DataDestroy()
  self:ClearContent()
  self.needScore = nil
  self.curScore = nil
  self.stageInfo = nil
  self.state = nil
  self.rewardList = nil
  self.curIndex = nil
  self.maxIndex = nil
end

function GhostTargetItem:OnAddListener()
  base.OnAddListener(self)
end

function GhostTargetItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function GhostTargetItem:InitUI()
  self.imgScoreIcon:LoadSpriteAsync("Assets/Main/Sprites/ItemIcons/lrb_YZPK_icon_yinliao.png")
end

function GhostTargetItem:OnBtnRewardClick()
  if not self.stageInfo then
    return
  end
  if self.stageInfo.state ~= TaskState.CanReceive then
    return
  end
  local round = DataCenter.LWGhostParkourDataManager:GetGhostParkourRound()
  DataCenter.LWGhostParkourDataManager:SendRewardGhostParkourBattlePassMessage(round, self.stageInfo.id, GhostParkourPassType.Alliance)
end

function GhostTargetItem:RefreshData(stageInfo, curScore, curIndex, maxIndex)
  if not stageInfo then
    return
  end
  self.needScore = GetTableData(TableName.lw_parkour_battle_pass, stageInfo.id, "score")
  self.curScore = curScore
  self.stageInfo = stageInfo
  self.textTargetScore:SetText(self.needScore)
  self.state = self.stageInfo.state
  self.rewardList = DeepCopy(self.stageInfo.reward)
  self.curIndex = curIndex
  self.maxIndex = maxIndex
  if self.state == TaskState.NoComplete then
    UIGray.SetGray(self.btnReward.transform, true, false)
    self.textTxtReward:SetLocalText("parkour_get_reward_btn")
  elseif self.state == TaskState.CanReceive then
    UIGray.SetGray(self.btnReward.transform, false, true)
    self.textTxtReward:SetLocalText("parkour_get_reward_btn")
  else
    UIGray.SetGray(self.btnReward.transform, true, false)
    self.textTxtReward:SetLocalText("2000411")
  end
  self:RefreshReward()
end

function GhostTargetItem:RefreshReward()
  if self.rewardList then
    local count = #self.rewardList
    for i = 1, count do
      local item = self.rewardItems[i]
      if item == nil then
        local go = self.rewardItemPool:GameObjectSpawn(self.rewardContent.transform)
        go.name = "item" .. i
        item = self.rewardContent:AddComponent(RewardItem, go.name)
        self.rewardItems[i] = item
      else
        item.gameObject.transform:SetParent(self.rewardContent.transform)
      end
      item:SetActive(true)
      item:ReInit(self.rewardList[i])
    end
    for i = count + 1, #self.rewardItems do
      local item = self.rewardItems[i]
      if item then
        item:SetActive(false)
      end
    end
  end
end

function GhostTargetItem:ClearContent()
  self.rewardContent:RemoveComponents(RewardItem)
  self.rewardItemPool:GameObjectRecycleAll()
  self.rewardItems = nil
end

return GhostTargetItem
