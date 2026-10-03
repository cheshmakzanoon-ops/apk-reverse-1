local base = UIBaseContainer
local TargetItem = BaseClass("TargetItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

function TargetItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitUI()
  self.textTxtReward:SetLocalText("parkour_get_reward_btn")
end

function TargetItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TargetItem:ComponentDefine()
  self.rewardContent = self:AddComponent(UIBaseContainer, "Rect_Reward/Viewport/Content")
  self.btnReward = self:AddComponent(UIButton, "Btn_Reward")
  self.btnReward:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
  self.textTxtReward = self:AddComponent(UITextMeshProUGUIEx, "Btn_Reward/Txt_Reward")
  self.imgScoreIcon = self:AddComponent(UIImage, "ScoreIcon")
  self.textTargetScore = self:AddComponent(UITextMeshProUGUIEx, "TargetScoreText")
end

function TargetItem:ComponentDestroy()
  self.rewardContent = nil
  self.btnReward = nil
  self.textTxtReward = nil
  self.imgScoreIcon = nil
  self.textTargetScore = nil
end

function TargetItem:DataDefine()
end

function TargetItem:DataDestroy()
  self:ClearContent()
  self.needScore = nil
  self.curScore = nil
  self.stageInfo = nil
  self.state = nil
  self.rewardList = nil
  self.curIndex = nil
  self.maxIndex = nil
end

function TargetItem:OnAddListener()
  base.OnAddListener(self)
end

function TargetItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function TargetItem:InitUI()
  self.imgScoreIcon:LoadSprite("Assets/Main/Sprites/ItemIcons/lrb_paoku_jifen_daojv.png")
end

function TargetItem:OnBtnRewardClick()
  if not self.stageInfo then
    return
  end
  if self.stageInfo.state ~= TaskState.CanReceive then
    return
  end
  local round = DataCenter.LWSurfingDataManager:GetAllianceBattlePassRound()
  DataCenter.LWSurfingDataManager:ReceiveRewardParkourBattlePassMessage(round, SurfingBattlePassType.Alliance, self.stageInfo.id)
end

function TargetItem:RefreshData(stageInfo, curScore, curIndex, maxIndex)
  if not stageInfo then
    return
  end
  self.needScore = DataCenter.LWSurfingDataManager:GetBattlePassScoreById(stageInfo.id)
  self.curScore = curScore
  self.stageInfo = stageInfo
  self.textTargetScore:SetText(self.needScore)
  self.state = self.stageInfo.state
  self.rewardList = self.stageInfo.reward
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

function TargetItem:RefreshReward()
  self:ClearContent()
  self.asyncModels = {}
  if self.rewardList then
    for i = 1, #self.rewardList do
      self.asyncModels[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:Set_sizeDelta(150, 150)
        go.transform:SetParent(self.rewardContent.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = "item" .. i
        local cell = self.rewardContent:AddComponent(UICommonResItem, go.name)
        cell:ParseInfo(self.rewardList[i])
      end)
    end
  end
end

function TargetItem:ClearContent()
  self.rewardContent:RemoveComponents(UICommonResItem)
  if self.asyncModels then
    for _, v in pairs(self.asyncModels) do
      if v then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.asyncModels = nil
end

return TargetItem
