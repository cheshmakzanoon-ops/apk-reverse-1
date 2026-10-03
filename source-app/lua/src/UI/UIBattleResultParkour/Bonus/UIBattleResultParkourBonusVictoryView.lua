local UIBattleResultParkourBonusVictoryView = BaseClass("UIBattleResultParkourBonusVictoryView", UIBaseView)
local BattleResultAnimStyle = require("UI.UIBattleResultUtils.BattleResultAnimStyle")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Const = require("Scene.LWBattle.Const")
local DELAY_SEC = 0.04
local START_DELAY_SEC = 0.3

function UIBattleResultParkourBonusVictoryView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIBattleResultParkourBonusVictoryView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBattleResultParkourBonusVictoryView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTxtTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.scrollViewBonusList = self.viewSkin:AddComponent(self, UIScrollView, 2)
  self.compBonusContent = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.textTxtNoExtraBonus = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textTxtGetExtraBonus = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.scrollViewExtraBonusList = self.viewSkin:AddComponent(self, UIScrollView, 6)
  self.compExtraBonusContent = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.btnClaim = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnClaim:SetOnClick(function()
    self:OnBtnClaimClick()
  end)
  self.textTxtClaim = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.btnRetry = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnRetry:SetOnClick(function()
    self:OnBtnRetryClick()
  end)
  self.textTxtRetry = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.btnReturn = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnReturn:SetOnClick(function()
    self:OnBtnReturnClick()
  end)
  self.compNodeBonusLevel = self.viewSkin:AddComponent(self, UIBaseContainer, 13)
  self.imgNumber1 = self.viewSkin:AddComponent(self, UIImage, 14)
  self.imgNumber2 = self.viewSkin:AddComponent(self, UIImage, 15)
  self.imgNumber3 = self.viewSkin:AddComponent(self, UIImage, 16)
  self.animatorUIBattleResultParkourBonusVictory = self.viewSkin:AddComponent(self, UIAnimator, 17)
  self.textTxtTitle:SetLocalText("monopoly_bonus_reward_01")
  self.textTxtClaim:SetLocalText("monopoly_bonus_reward_05")
  self.textTxtRetry:SetLocalText("monopoly_bonus_reward_06")
  self.compNodeBonusLevel:SetActive(false)
  self.scrollViewBonusList:SetOnItemMoveIn(function(itemObj, index)
    self:OnBonusRewardItemMoveIn(itemObj, index)
  end)
  self.scrollViewBonusList:SetOnItemMoveOut(function(itemObj, index)
    self:OnBonusRewardItemMoveOut(itemObj, index)
  end)
  self.scrollViewExtraBonusList:SetOnItemMoveIn(function(itemObj, index)
    self:OnExtraBonusRewardItemMoveIn(itemObj, index)
  end)
  self.scrollViewExtraBonusList:SetOnItemMoveOut(function(itemObj, index)
    self:OnExtraBonusRewardItemMoveOut(itemObj, index)
  end)
end

function UIBattleResultParkourBonusVictoryView:ComponentDestroy()
  self.viewSkin = nil
  self.textTxtTitle = nil
  self.scrollViewBonusList = nil
  self.compBonusContent = nil
  self.textTxtNoExtraBonus = nil
  self.textTxtGetExtraBonus = nil
  self.scrollViewExtraBonusList = nil
  self.compExtraBonusContent = nil
  self.btnClaim = nil
  self.textTxtClaim = nil
  self.btnRetry = nil
  self.textTxtRetry = nil
  self.btnReturn = nil
  self.compNodeBonusLevel = nil
  self.imgNumber1 = nil
  self.imgNumber2 = nil
  self.imgNumber3 = nil
  self.animatorUIBattleResultParkourBonusVictory = nil
end

function UIBattleResultParkourBonusVictoryView:DataDefine()
  self.bonusNumList = {
    self.imgNumber1,
    self.imgNumber2,
    self.imgNumber3
  }
  self.bonusScrollCellPool = {}
  self.bonusItemIndex = 1
  self.bonusRewardFlyReward = {}
  self.bonusRewardDatalist = {}
  self.rewardAnimStyle = BattleResultAnimStyle.New()
  self.extraBonusScrollCellPool = {}
  self.extraBonusItemIndex = 1
  self.extraBonusRewardFlyReward = {}
  self.extraBonusRewardDatalist = {}
  self.extraRewardAnimStyle = BattleResultAnimStyle.New()
  local hasAni, animTime = self.animatorUIBattleResultParkourBonusVictory:GetAnimationReturnTime("CommonPopup_movein")
  if hasAni and 0 < animTime then
    self.interactableBtns = false
    self.aniTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.interactableBtns = true
    end, animTime)
  else
    self.interactableBtns = true
  end
end

function UIBattleResultParkourBonusVictoryView:DataDestroy()
  if self.aniTimer then
    self.aniTimer:Stop()
    self.aniTimer = nil
    self.interactableBtns = false
  end
  self.rewardAnimStyle:Delete()
  self.rewardAnimStyle = nil
  self.extraRewardAnimStyle:Delete()
  self.extraRewardAnimStyle = nil
  self:ClearBonusScroll()
  self:ClearExtraBonusScroll()
  self.bonusNumList = nil
end

function UIBattleResultParkourBonusVictoryView:RefreshView()
  self.param = self:GetUserData()
  if self.param.stageRewardList then
    local rewardList = DataCenter.RewardTemplateManager:GetRewardByIdList(self.param.stageRewardList)
    self:RefreshBonusReward(rewardList)
  end
  local fullExtraReward = true
  local extraRewardText = Localization:GetString("monopoly_bonus_reward_04")
  if self.param.bonusType == Const.ParkourBattleBonusType.GoldMonster then
    self.btnRetry:SetActive(false)
    self.btnClaim:SetActive(true)
    if self.param.goods and self.param.goods[ResourceType.Wood] then
      local woodNum = self.param.goods[ResourceType.Wood]
      local addRewardList = {
        [1] = {
          itemId = "",
          rewardType = RewardType.Wood,
          count = woodNum
        }
      }
      self:RefreshExtraBonusReward(addRewardList)
    end
  elseif self.param.bonusType == Const.ParkourBattleBonusType.ProgressMonster then
    local progressNum = self.param.goods[ResourceType.GoldProgress] or 0
    local progressData = self.param.extendData
    local getRewardIdList = {}
    local showRetryBtn = true
    if progressData then
      for i, v in ipairs(progressData) do
        if progressNum >= v.progressNum then
          table.insert(getRewardIdList, v.rewardId)
          if i == #progressData then
            showRetryBtn = false
          end
        end
      end
    end
    fullExtraReward = not showRetryBtn
    local addRewardList = DataCenter.RewardTemplateManager:GetRewardByIdList(getRewardIdList)
    self:RefreshExtraBonusReward(addRewardList)
    extraRewardText = showRetryBtn and Localization:GetString("monopoly_bonus_reward_02") or Localization:GetString("monopoly_bonus_reward_03")
    self.btnRetry:SetActive(showRetryBtn)
    self.btnClaim:SetActive(true)
  elseif self.param.bonusType == Const.ParkourBattleBonusType.Dash then
    local bonusLevel = self.param.bonusLevel
    if bonusLevel then
      self:ShowBonusLevel(bonusLevel)
    end
    local showRetryBtn = not self.param.maxBonus
    self.btnRetry:SetActive(showRetryBtn)
    if self.param.stageRewardList and bonusLevel then
      bonusLevel = Mathf.Max(0, bonusLevel - 1)
      local rewardList
      if 0 < bonusLevel then
        rewardList = DataCenter.RewardTemplateManager:GetRewardByIdList(self.param.stageRewardList)
        for _, reward in ipairs(rewardList) do
          if reward.count then
            reward.count = Mathf.Ceil(reward.count * bonusLevel)
          end
        end
      else
        rewardList = {}
      end
      self:RefreshExtraBonusReward(rewardList)
      fullExtraReward = not showRetryBtn
      extraRewardText = showRetryBtn and Localization:GetString("monopoly_bonus_reward_02") or Localization:GetString("monopoly_bonus_reward_03")
    end
    self.btnClaim:SetActive(true)
  end
  if fullExtraReward then
    self.textTxtNoExtraBonus:SetActive(false)
    self.textTxtGetExtraBonus:SetActive(true)
    self.textTxtGetExtraBonus:SetText(extraRewardText)
  else
    self.textTxtNoExtraBonus:SetActive(true)
    self.textTxtNoExtraBonus:SetText(extraRewardText)
    self.textTxtGetExtraBonus:SetActive(false)
  end
end

function UIBattleResultParkourBonusVictoryView:OnAddListener()
  base.OnAddListener(self)
end

function UIBattleResultParkourBonusVictoryView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBattleResultParkourBonusVictoryView:OnBtnClaimClick()
  if not self.interactableBtns then
    return
  end
  local cfg = {}
  for k, v in pairs(self.bonusRewardFlyReward) do
    local data = {
      k.position,
      v
    }
    table.insert(cfg, data)
  end
  for k, v in pairs(self.extraBonusRewardFlyReward) do
    local data = {
      k.position,
      v
    }
    table.insert(cfg, data)
  end
  self.ctrl:CloseSelf()
  local battleLogic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if not battleLogic then
    return
  end
  DataCenter.LWBattleManager:GetCurBattleLogic():NoticeWin()
  DataCenter.LWBattleManager:Exit(function()
    EventManager:GetInstance():Broadcast(EventId.UIMainFlyReward, cfg)
  end, "win")
end

function UIBattleResultParkourBonusVictoryView:OnBtnRetryClick()
  if not self.interactableBtns then
    return
  end
  self.ctrl:CloseSelf()
  local battleLogic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if not battleLogic then
    return
  end
  DataCenter.LWBattleManager:GetCurBattleLogic():NoticeLose()
  DataCenter.LWBattleManager:Restart()
end

function UIBattleResultParkourBonusVictoryView:OnBtnReturnClick()
  if not self.interactableBtns then
    return
  end
  self:OnBtnClaimClick()
end

function UIBattleResultParkourBonusVictoryView:ShowBonusLevel(number)
  local num = string.format("%.2f", number)
  num = tostring(tonumber(num))
  local show = Mathf.Min(#num, 3)
  for i = 1, show do
    local char = num:sub(i, i)
    local val = tonumber(char) or -1
    local img = self:GetBonusLevelShow(val)
    self.bonusNumList[i]:SetActive(true)
    self.bonusNumList[i]:LoadSprite(img)
  end
  for i = show + 1, 3 do
    self.bonusNumList[i]:SetActive(false)
  end
  self.compNodeBonusLevel:SetActive(true)
end

function UIBattleResultParkourBonusVictoryView:GetBonusLevelShow(value)
  if 0 <= value and value <= 9 then
    return "Assets/Main/Sprites/UI/BonusLevel/zyf_guanqia_zi_" .. value
  end
  return "Assets/Main/Sprites/UI/BonusLevel/zyf_guanqia_zi_dian.png"
end

function UIBattleResultParkourBonusVictoryView:RefreshBonusReward(data)
  if data and 0 < #data then
    self.scrollViewBonusList:SetActive(true)
    self.bonusRewardDatalist = data
    self.scrollViewBonusList:SetTotalCount(#self.bonusRewardDatalist)
    if 0 < #self.bonusRewardDatalist then
      self.scrollViewBonusList:RefillCells()
    end
  else
    self.scrollViewBonusList:SetActive(false)
  end
end

function UIBattleResultParkourBonusVictoryView:OnBonusRewardItemMoveIn(itemObj, index)
  local itemName = itemObj.name
  local item = self.bonusScrollCellPool[itemName]
  local firstCreate = false
  if not item then
    firstCreate = true
    itemName = tostring(self.bonusItemIndex)
    itemObj.name = itemName
    item = self.compBonusContent:AddComponent(UICommonResItem, itemObj)
    self.bonusScrollCellPool[itemName] = item
    self.bonusItemIndex = self.bonusItemIndex + 1
  end
  local data = self.bonusRewardDatalist[index]
  item:ReInit(data)
  itemObj.transform:Set_localScale(0.8, 0.8, 0.8)
  if not firstCreate then
    self.rewardAnimStyle:StopItemDelayActiveTimer(itemName, item)
  else
    self.rewardAnimStyle:AddItemNewDelayActiveTimer(itemName, item)
  end
  if data.rewardType == RewardType.RESOURCE then
    local name = DataCenter.ResourceManager:GetResourceNameByType(data.itemId)
    item:SetNameText(name)
  end
  self.bonusRewardFlyReward[itemObj.transform] = data
end

function UIBattleResultParkourBonusVictoryView:OnBonusRewardItemMoveOut(itemObj, index)
  self.bonusRewardFlyReward[itemObj.transform] = nil
end

function UIBattleResultParkourBonusVictoryView:ClearBonusScroll()
  self.scrollViewBonusList:ClearCells()
  self.bonusScrollCellPool = nil
  self.bonusItemIndex = nil
  self.bonusRewardFlyReward = nil
  self.bonusRewardDatalist = nil
end

function UIBattleResultParkourBonusVictoryView:RefreshExtraBonusReward(data)
  if data and 0 < #data then
    self.scrollViewExtraBonusList:SetActive(true)
    self.extraBonusRewardDatalist = data
    self.scrollViewExtraBonusList:SetTotalCount(#self.extraBonusRewardDatalist)
    if 0 < #self.extraBonusRewardDatalist then
      self.scrollViewExtraBonusList:RefillCells()
    end
  else
    self.scrollViewExtraBonusList:SetActive(false)
  end
end

function UIBattleResultParkourBonusVictoryView:OnExtraBonusRewardItemMoveIn(itemObj, index)
  local itemName = itemObj.name
  local item = self.extraBonusScrollCellPool[itemName]
  local firstCreate = false
  if not item then
    firstCreate = true
    itemName = tostring(self.extraBonusItemIndex)
    itemObj.name = itemName
    item = self.compExtraBonusContent:AddComponent(UICommonResItem, itemObj)
    self.extraBonusScrollCellPool[itemName] = item
    self.extraBonusItemIndex = self.extraBonusItemIndex + 1
  end
  local data = self.extraBonusRewardDatalist[index]
  item:ReInit(data)
  itemObj.transform:Set_localScale(0.8, 0.8, 0.8)
  if not firstCreate then
    self.extraRewardAnimStyle:StopItemDelayActiveTimer(itemName, item)
  else
    self.extraRewardAnimStyle:AddItemNewDelayActiveTimer(itemName, item)
  end
  if data.rewardType == RewardType.RESOURCE then
    local rewardName = DataCenter.ResourceManager:GetResourceNameByType(data.itemId)
    item:SetNameText(rewardName)
  end
  self.extraBonusRewardFlyReward[itemObj.transform] = data
end

function UIBattleResultParkourBonusVictoryView:OnExtraBonusRewardItemMoveOut(itemObj, index)
  self.extraBonusRewardFlyReward[itemObj.transform] = nil
end

function UIBattleResultParkourBonusVictoryView:ClearExtraBonusScroll()
  self.scrollViewExtraBonusList:ClearCells()
  self.extraBonusScrollCellPool = nil
  self.extraBonusItemIndex = nil
  self.extraBonusRewardFlyReward = nil
  self.extraBonusRewardDatalist = nil
end

return UIBattleResultParkourBonusVictoryView
