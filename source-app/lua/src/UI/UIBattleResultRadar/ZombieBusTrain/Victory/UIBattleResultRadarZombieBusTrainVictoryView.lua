local UIBattleResultRadarZombieBusTrainVictoryView = BaseClass("UIBattleResultRadarZombieBusTrainVictoryView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local BattleResultAnimStyle = require("UI.UIBattleResultUtils.BattleResultAnimStyle")

function UIBattleResultRadarZombieBusTrainVictoryView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIBattleResultRadarZombieBusTrainVictoryView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBattleResultRadarZombieBusTrainVictoryView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTxtTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTxtStage = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnReturn = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnReturn:SetOnClick(function()
    self:OnBtnReturnClick()
  end)
  self.textTxtReturn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compNodeReward = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.textTxtFirstRewardTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.scrollViewRewardScrollView = self.viewSkin:AddComponent(self, UIScrollView, 7)
  self.compRewardContent = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.btnNext = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnNext:SetOnClick(function()
    self:OnBtnNextClick()
  end)
  self.textTxtNext = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.animatorUIBattleResultRadarZombieBusTrainVictory = self.viewSkin:AddComponent(self, UIAnimator, 11)
  self.textTxtTitle:SetLocalText("311105")
  self.textTxtReturn:SetLocalText("800306")
  self.textTxtNext:SetLocalText("activity_breakthrough_tips_27")
  self.textTxtFirstRewardTip:SetLocalText("800305")
  self.compNodeReward:SetActive(false)
  self.scrollViewRewardScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.scrollViewRewardScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
end

function UIBattleResultRadarZombieBusTrainVictoryView:ComponentDestroy()
  self.viewSkin = nil
  self.textTxtTitle = nil
  self.textTxtStage = nil
  self.btnReturn = nil
  self.textTxtReturn = nil
  self.compNodeReward = nil
  self.textTxtFirstRewardTip = nil
  self.scrollViewRewardScrollView = nil
  self.compRewardContent = nil
  self.btnNext = nil
  self.textTxtNext = nil
  self.animatorUIBattleResultRadarZombieBusTrainVictory = nil
end

function UIBattleResultRadarZombieBusTrainVictoryView:DataDefine()
  self.rewardScrollCellPool = {}
  self.rewardItemIndex = 1
  self.rewardFlyReward = {}
  self.rewardDatalist = {}
  self.battleResultAnimStyle = BattleResultAnimStyle.New()
  local hasAni, animTime = self.animatorUIBattleResultRadarZombieBusTrainVictory:GetAnimationReturnTime("CommonPopup_movein")
  if hasAni and 0 < animTime then
    self.interactableBtns = false
    self.aniTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.interactableBtns = true
    end, animTime)
  else
    self.interactableBtns = true
  end
end

function UIBattleResultRadarZombieBusTrainVictoryView:RefreshView()
  DataCenter.LWSoundManager:PlaySound(10027)
  local param = self:GetUserData()
  self.textTxtStage:SetText("")
  local showNextBtn = false
  if param.zombieBusTrainData then
    local isInWorldEnter = param.zombieBusTrainData.isInWorld
    local curBusIndex = param.zombieBusTrainData.busIndex
    local nextBusData, nextBusIndex = DataCenter.RadarCenterDataManager:GetNextOneCanAttackZombieBusData(curBusIndex)
    showNextBtn = isInWorldEnter and nextBusData ~= nil
  end
  self.btnNext:SetActive(showNextBtn)
  local reward = DataCenter.RadarCenterDataManager:GetRecentZombieBusReward()
  if reward then
    self:OnGetReward(reward)
  end
end

function UIBattleResultRadarZombieBusTrainVictoryView:OnGetReward(param)
  self.rewardDatalist = DataCenter.RewardManager:ReturnRewardParamForMessage(param) or {}
  self.compNodeReward:SetActive(#self.rewardDatalist > 0)
  DataCenter.RadarCenterDataManager:SaveZombieBusReward(nil)
  self:RefreshReward()
end

function UIBattleResultRadarZombieBusTrainVictoryView:RefreshReward()
  self.scrollViewRewardScrollView:SetTotalCount(#self.rewardDatalist)
  if #self.rewardDatalist > 0 then
    self.scrollViewRewardScrollView:RefillCells()
  end
end

function UIBattleResultRadarZombieBusTrainVictoryView:ClearRewardScroll()
  self.scrollViewRewardScrollView:ClearCells()
  self.rewardScrollCellPool = nil
  self.rewardItemIndex = nil
  self.rewardFlyReward = nil
  self.rewardDatalist = nil
end

function UIBattleResultRadarZombieBusTrainVictoryView:OnRewardItemMoveIn(itemObj, index)
  local itemName = itemObj.name
  local item = self.rewardScrollCellPool[itemName]
  local firstCreate = false
  if not item then
    firstCreate = true
    itemName = tostring(self.rewardItemIndex)
    itemObj.name = itemName
    item = self.compRewardContent:AddComponent(UICommonResItem, itemObj)
    self.rewardScrollCellPool[itemName] = item
    self.rewardItemIndex = self.rewardItemIndex + 1
  end
  local data = self.rewardDatalist[index]
  item:ReInit(data)
  if not firstCreate then
    self.battleResultAnimStyle:StopItemDelayActiveTimer(itemName, item)
  else
    self.battleResultAnimStyle:AddItemNewDelayActiveTimer(itemName, item)
  end
  if data.rewardType == RewardType.RESOURCE then
    local name = DataCenter.ResourceManager:GetResourceNameByType(data.itemId)
    item:SetNameText(name)
  end
  self.rewardFlyReward[itemObj.transform] = data
end

function UIBattleResultRadarZombieBusTrainVictoryView:OnRewardItemMoveOut(itemObj, index)
  self.rewardFlyReward[itemObj.transform] = nil
end

function UIBattleResultRadarZombieBusTrainVictoryView:DataDestroy()
  if self.aniTimer then
    self.aniTimer:Stop()
    self.aniTimer = nil
    self.interactableBtns = false
  end
  self.battleResultAnimStyle:Delete()
  self.battleResultAnimStyle = nil
  self:ClearRewardScroll()
end

function UIBattleResultRadarZombieBusTrainVictoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ParkourBattleReward, self.OnGetReward)
  self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
end

function UIBattleResultRadarZombieBusTrainVictoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.ParkourBattleReward, self.OnGetReward)
  self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  base.OnRemoveListener(self)
end

function UIBattleResultRadarZombieBusTrainVictoryView:OnKeyCodeEscape()
  TimerManager:GetInstance():DelayFrameInvoke(function()
    self:OnBtnReturnClick()
  end, 1)
end

function UIBattleResultRadarZombieBusTrainVictoryView:OnBtnReturnClick()
  if not self.interactableBtns then
    return
  end
  local cfg = {}
  for i, v in pairs(self.rewardFlyReward) do
    table.insert(cfg, {
      i.position,
      v
    })
  end
  EventManager:GetInstance():Broadcast(EventId.UIMainFlyReward, cfg)
  self.ctrl:CloseSelf()
  DataCenter.LWBattleManager:Exit(nil, "win")
end

function UIBattleResultRadarZombieBusTrainVictoryView:OnBtnNextClick()
  if not self.interactableBtns then
    return
  end
  local userdata = self:GetUserData()
  if userdata.zombieBusTrainData then
    local isInWorldEnter = userdata.zombieBusTrainData.isInWorld
    local curBusIndex = userdata.zombieBusTrainData.busIndex
    local curEventId = userdata.zombieBusTrainData.eventUuid
    local nextBusData, nextBusIndex = DataCenter.RadarCenterDataManager:GetNextOneCanAttackZombieBusData(curBusIndex)
    if isInWorldEnter and nextBusData then
      self.ctrl:CloseSelf()
      DataCenter.LWBattleManager:Destroy()
      local lastPosition, lastEuler = DataCenter.RadarCenterDataManager:GetLastZombieBusBattleEnterPosAndEuler()
      DataCenter.RadarCenterDataManager:ClickAttackWorldZombieBus(nextBusData, nextBusIndex, curEventId, lastPosition, lastEuler)
    else
      self:OnBtnReturnClick()
    end
  else
    self:OnBtnReturnClick()
  end
end

return UIBattleResultRadarZombieBusTrainVictoryView
