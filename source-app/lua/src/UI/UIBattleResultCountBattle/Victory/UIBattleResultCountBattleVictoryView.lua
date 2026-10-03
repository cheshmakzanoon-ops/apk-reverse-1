local UIBattleResultCountBattleVictoryView = BaseClass("UIBattleResultCountBattleVictoryView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local BattleResultAnimStyle = require("UI.UIBattleResultUtils.BattleResultAnimStyle")

function UIBattleResultCountBattleVictoryView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIBattleResultCountBattleVictoryView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBattleResultCountBattleVictoryView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgHead = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textTxtSoldierNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textTxtTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTxtStage = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textTxtExceedNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.btnReturn = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnReturn:SetOnClick(function()
    self:OnBtnReturnClick()
  end)
  self.textTxtReturn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.compNodeReward = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.textTxtFirstRewardTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.scrollViewRewardScrollView = self.viewSkin:AddComponent(self, UIScrollView, 10)
  self.compRewardContent = self.viewSkin:AddComponent(self, UIBaseContainer, 11)
  self.animatorUIBattleResultCountBattleVictory = self.viewSkin:AddComponent(self, UIAnimator, 12)
  self.textTxtTitle:SetLocalText("311105")
  self.textTxtReturn:SetLocalText("800306")
  self.textTxtFirstRewardTip:SetLocalText("800305")
  self.compNodeReward:SetActive(false)
  self.scrollViewRewardScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.scrollViewRewardScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
end

function UIBattleResultCountBattleVictoryView:ComponentDestroy()
  self.viewSkin = nil
  self.imgHead = nil
  self.textTxtSoldierNum = nil
  self.textTxtTitle = nil
  self.textTxtStage = nil
  self.textTxtExceedNum = nil
  self.btnReturn = nil
  self.textTxtReturn = nil
  self.compNodeReward = nil
  self.textTxtFirstRewardTip = nil
  self.scrollViewRewardScrollView = nil
  self.compRewardContent = nil
  self.animatorUIBattleResultCountBattleVictory = nil
end

function UIBattleResultCountBattleVictoryView:DataDefine()
  self.heroId = nil
  self.battleResultAnimStyle = BattleResultAnimStyle.New()
  self.rewardScrollCellPool = {}
  self.rewardItemIndex = 1
  self.rewardFlyReward = {}
  self.rewardDatalist = {}
  local hasAni, animTime = self.animatorUIBattleResultCountBattleVictory:GetAnimationReturnTime("CommonPopup_movein")
  if hasAni and 0 < animTime then
    self.interactableBtns = false
    self.aniTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.interactableBtns = true
    end, animTime)
  else
    self.interactableBtns = true
  end
end

function UIBattleResultCountBattleVictoryView:DataDestroy()
  if self.EscTimer then
    self.EscTimer:Stop()
    self.EscTimer = nil
  end
  if self.aniTimer then
    self.aniTimer:Stop()
    self.aniTimer = nil
    self.interactableBtns = false
  end
  self.battleResultAnimStyle:Delete()
  self.battleResultAnimStyle = nil
  self:ClearRewardScroll()
  if self.scoreTween then
    self.scoreTween:Kill()
  end
  self.scoreTween = nil
  self.heroId = nil
end

function UIBattleResultCountBattleVictoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CountBattleReward, self.OnGetReward)
  self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
end

function UIBattleResultCountBattleVictoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.CountBattleReward, self.OnGetReward)
  self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  base.OnRemoveListener(self)
end

function UIBattleResultCountBattleVictoryView:OnKeyCodeEscape()
  if not self.interactableBtns then
    return
  end
  if self.EscTimer ~= nil then
    return
  end
  self.EscTimer = TimerManager:GetInstance():DelayFrameInvoke(function()
    self:OnBtnReturnClick()
    self.EscTimer = nil
  end, 1)
end

function UIBattleResultCountBattleVictoryView:OnBtnReturnClick()
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
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if logic and logic.param and logic.param.enterType == PVEEnterType.StageFeatureScene then
    DataCenter.LWBattleManager:SetBattleExitFlag(true)
  end
  self.ctrl:CloseSelf()
  DataCenter.LWBattleManager:Exit(nil, "win")
end

function UIBattleResultCountBattleVictoryView:RefreshView()
  DataCenter.LWSoundManager:PlaySound(10027)
  local param = self:GetUserData()
  local stageId = param.stageId
  self.textTxtStage:SetText(Localization:GetString(GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Count_Stage), stageId, "name"), GetTableData(TableName.LW_Count_Stage, stageId, "order")))
  if self.scoreTween then
    self.scoreTween:Kill()
  end
  self.tempScore = 0
  self.textTxtSoldierNum:SetText("X 0")
  self.scoreTween = CS.DG.Tweening.DOTween.To(function()
    return self.tempScore
  end, function(value)
    self.tempScore = value
    self.textTxtSoldierNum:SetText("X " .. math.floor(value))
  end, param.score, 1):SetEase(CS.DG.Tweening.Ease.OutQuad):SetDelay(0.5):OnComplete(function()
    self.textTxtSoldierNum:SetText("X " .. param.score)
  end)
  self.textTxtExceedNum:SetText(string.format("<size=32><color=#ffffff>%s</color></size> <size=36><color=#fec939>%s</color></size> <size=32><color=#ffffff>%s</color></size>", Localization:GetString("800827"), param.rank, Localization:GetString("800828")))
  if DataCenter.ParkourManager.countReward and DataCenter.ParkourManager.countRewardStageId == stageId then
    self:OnGetReward(DataCenter.ParkourManager.countReward)
  end
end

function UIBattleResultCountBattleVictoryView:OnGetReward(param)
  self.rewardDatalist = DataCenter.RewardManager:ReturnRewardParamForMessage(param) or {}
  self.compNodeReward:SetActive(#self.rewardDatalist > 0)
  for i, v in ipairs(self.rewardDatalist) do
    if v.rewardType == RewardType.HERO then
      self.heroId = v.heroUuid
      break
    end
  end
  DataCenter.ParkourManager.countReward = nil
  DataCenter.ParkourManager.countRewardStageId = nil
  self:RefreshReward()
  if self.heroId and DataCenter.HeroDataManager:NeedShowNewHeroWindow(self.heroId) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroExhibitPanel, {anim = false}, self.heroId, {
      self.heroId
    }, nil, true)
  end
end

function UIBattleResultCountBattleVictoryView:RefreshReward()
  self.scrollViewRewardScrollView:SetTotalCount(#self.rewardDatalist)
  if #self.rewardDatalist > 0 then
    self.scrollViewRewardScrollView:RefillCells()
  end
end

function UIBattleResultCountBattleVictoryView:ClearRewardScroll()
  self.scrollViewRewardScrollView:ClearCells()
  self.rewardScrollCellPool = nil
  self.rewardItemIndex = nil
  self.rewardFlyReward = nil
  self.rewardDatalist = nil
end

function UIBattleResultCountBattleVictoryView:OnRewardItemMoveIn(itemObj, index)
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

function UIBattleResultCountBattleVictoryView:OnRewardItemMoveOut(itemObj, index)
  self.rewardFlyReward[itemObj.transform] = nil
end

return UIBattleResultCountBattleVictoryView
