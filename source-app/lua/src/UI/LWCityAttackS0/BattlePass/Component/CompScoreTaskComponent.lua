local base = UIBaseContainer
local CompScoreTaskComponent = BaseClass("CompScoreTaskComponent", UIBaseContainer)
local TargetItem = require("UI.LWCityAttackS0.BattlePass.Component.UIAttackCityS0BattlePassScoreItem")
local Localization = CS.GameEntry.Localization
local DOTween = CS.DG.Tweening.DOTween

function CompScoreTaskComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function CompScoreTaskComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function CompScoreTaskComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.content = self:AddComponent(UILoopListView2, "ScrollView/Viewport/Content")
  self.slider = self:AddComponent(UISlider, "ScrollView/Viewport/Content/Slider")
  self.targetList = self:AddComponent(UILoopListView2, "ScrollView")
  local listInitDefaultPara = CS.SuperScrollView.LoopListViewInitParam.CopyDefaultInitParam()
  listInitDefaultPara.mItemDefaultWithPaddingSize = 155
  self.itemIndex = 1
  self.taskList = DataCenter.AttackCityS0DataManager:GetScoreBattlePassInfo()
  local count = 0
  if self.taskList then
    count = #self.taskList
  end
  self.targetList:InitListViewParam(count, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end, listInitDefaultPara)
  self.btnReceiveAll = self:AddComponent(UIButton, "BtnAllScore")
  self.btnReceiveAll:SetOnClick(function()
    self:OnBtnReceiveAllClick()
  end)
end

function CompScoreTaskComponent:ComponentDestroy()
  self.viewSkin = nil
  self.targetList = nil
  self.content = nil
  self.slider = nil
end

function CompScoreTaskComponent:DataDefine()
  self.curScore = 0
end

function CompScoreTaskComponent:DataDestroy()
  if self.currentTween ~= nil then
    self.currentTween:Kill(true)
    self.currentTween = nil
  end
  self:ClearScroll()
  self.initProgress = nil
  self.curScore = nil
  self.itemIndex = nil
end

function CompScoreTaskComponent:OnAddListener()
  base.OnAddListener(self)
end

function CompScoreTaskComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function CompScoreTaskComponent:RefreshPage()
  self:RefreshRewardList(true)
end

function CompScoreTaskComponent:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.taskList then
    return nil
  end
  local packData = self.taskList[index]
  local item = loopScroll:NewListViewItem("UIAttackCityS0BattlePassScoreItem")
  local script = self.content:GetComponent(item.gameObject.name, TargetItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.content:AddComponent(TargetItem, objectName)
  end
  script:SetActive(true)
  script:RefreshData(packData)
  return item
end

local itemHeight = 145
local spacing = 10

function CompScoreTaskComponent:InitProgress(count)
  if self.slider then
    local height = count * itemHeight + spacing * (count - 1) - 160
    height = height < 0 and 0 or height
    self.slider.transform:Set_sizeDelta(36, height)
  end
end

function CompScoreTaskComponent:RefreshScore()
  local progress = 0
  if not table.IsNullOrEmpty(self.taskList) and self.targetList then
    self.targetList:RefreshAllShownItem()
    local firstStep = 0
    local otherStep = (1 - firstStep) / (#self.taskList - 1)
    local lastNeedScore = 0
    for i, v in pairs(self.taskList) do
      local curStageStep = i == 1 and firstStep or otherStep
      local needScore = v.totalNum
      if needScore <= self.curScore then
        progress = progress + curStageStep
        lastNeedScore = needScore
      else
        progress = progress + curStageStep * (self.curScore - lastNeedScore) / (needScore - lastNeedScore)
        break
      end
    end
    progress = 1 < progress and 1 or progress
  end
  self.slider:SetValue(progress)
end

function CompScoreTaskComponent:RefreshRewardList(jump)
  self.btnReceiveAll.gameObject:SetActive(DataCenter.AttackCityS0DataManager:GetBattlePassScoreRedPoint())
  self.taskList = DataCenter.AttackCityS0DataManager:GetScoreBattlePassInfo()
  self.curScore = DataCenter.AttackCityS0DataManager:GetBattlePassScore()
  if not self.taskList then
    return
  end
  if table.IsNullOrEmpty(self.taskList) then
    self.targetList:SetActive(false)
  else
    self.targetList:SetActive(true)
    self.targetList:SetListItemCount(#self.taskList, false, false)
    self.targetList:RefreshAllShownItem()
    if not self.initProgress then
      self:InitProgress(#self.taskList)
      self.initProgress = true
    end
    if jump then
      local jumpIndex = 1
      for i, v in ipairs(self.taskList) do
        if v.hasReward ~= 2 then
          jumpIndex = i
          break
        end
      end
      jumpIndex = math.max(0, jumpIndex - 1)
      self.targetList:MovePanelToItemIndex(jumpIndex)
    end
  end
  if self.curScore then
    self:RefreshScore()
  end
end

function CompScoreTaskComponent:ClearScroll()
  self.content:RemoveComponents(TargetItem)
  self.targetList:ClearAllItems()
end

function CompScoreTaskComponent:OnBtnReceiveAllClick()
  DataCenter.AttackCityS0DataManager:SendBattlePassTaskRewardMsg(-1, -1)
end

return CompScoreTaskComponent
