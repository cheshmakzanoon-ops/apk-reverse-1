local UIParkourBonusResultView = BaseClass("UIParkourBonusResultView", UIBaseView)
local UIParkourBonusResultRewardPanel = require("UI.UIParkour.BonusResultUI.Component.UIParkourBonusResultRewardPanel")
local Const = require("Scene.LWBattle.Const")
local base = UIBaseView
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
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "Layout/UICommonRewardPopUp/Panel/ImgTitleBg/TextTitle")
  self.textClaimBtn = self:AddComponent(UITextMeshProUGUIEx, "Layout/BtnGroup/ClaimBtn/ClaimBtnText")
  self.btnClaim = self:AddComponent(UIButton, "Layout/BtnGroup/ClaimBtn")
  self.btnClaim:SetOnClick(function()
    self:OnBtnClaimClick()
  end)
  self.textNextBtn = self:AddComponent(UITextMeshProUGUIEx, "Layout/BtnGroup/NextBtn/NextBtnText")
  self.btnNext = self:AddComponent(UIButton, "Layout/BtnGroup/NextBtn")
  self.btnNext:SetOnClick(function()
    self:OnBtnNextClick()
  end)
  self.btnRetry = self:AddComponent(UIButton, "Layout/BtnGroup/RetryBtn")
  self.btnRetry:SetOnClick(function()
    self:OnBtnRetryClick()
  end)
  self.textRetryBtn = self:AddComponent(UITextMeshProUGUIEx, "Layout/BtnGroup/RetryBtn/RetryBtnText")
  self.compRewardPanel = self:AddComponent(UIParkourBonusResultRewardPanel, "Layout/RewardPanel")
  self.compAddRewardPanel = self:AddComponent(UIParkourBonusResultRewardPanel, "Layout/AddRewardPanel")
  self.textTitle:SetLocalText("monopoly_bonus_reward_01")
  self.textNextBtn:SetLocalText(456809)
  self.textClaimBtn:SetLocalText("monopoly_bonus_reward_05")
  self.textRetryBtn:SetLocalText("monopoly_bonus_reward_06")
  self.bonusLevel = self:AddComponent(UIBaseContainer, "Layout/BonusLevel")
  self.bonusNum1 = self:AddComponent(UIImage, "Layout/BonusLevel/number1")
  self.bonusNum2 = self:AddComponent(UIImage, "Layout/BonusLevel/number2")
  self.bonusNum3 = self:AddComponent(UIImage, "Layout/BonusLevel/number3")
  self.bonusNumList = {
    self.bonusNum1,
    self.bonusNum2,
    self.bonusNum3
  }
  self.bonusLevel:SetActive(false)
end

local function ComponentDestroy(self)
  self.textTitle = nil
  self.textClaimBtn = nil
  self.btnClaim = nil
  self.btnRetry = nil
  self.textRetryBtn = nil
  self.compRewardPanel = nil
  self.compAddRewardPanel = nil
  self.bonusLevel = nil
  self.bonusNum1 = nil
  self.bonusNum2 = nil
  self.bonusNum3 = nil
  self.bonusLevel = nil
  self.btnNext = nil
  self.textNextBtn = nil
end

local function DataDefine(self)
  self.param = self:GetUserData()
  self:Refresh()
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnBtnClaimClick(self)
  local cfg = {}
  for k, v in pairs(self.compRewardPanel:GetFlyReward()) do
    local data = {
      k.position,
      v
    }
    table.insert(cfg, data)
  end
  for k, v in pairs(self.compAddRewardPanel:GetFlyReward()) do
    local data = {
      k.position,
      v
    }
    table.insert(cfg, data)
  end
  self.ctrl:CloseSelf()
  DataCenter.LWBattleManager:GetCurBattleLogic():NoticeWin()
  DataCenter.LWBattleManager:Exit(function()
    EventManager:GetInstance():Broadcast(EventId.UIMainFlyReward, cfg)
  end, "win")
end

local function OnBtnNextClick(self)
  if self.param.enterType == PVEEnterType.DetectZombieBusTrain and self.param.extraData then
    local isInWorldEnter = self.param.extraData.isInWorld
    local curBusIndex = self.param.extraData.busIndex
    local curEventId = self.param.extraData.eventUuid
    local nextBusData, nextBusIndex = DataCenter.RadarCenterDataManager:GetNextOneCanAttackZombieBusData(curBusIndex)
    if isInWorldEnter and nextBusData then
      local cfg = {}
      for k, v in pairs(self.compRewardPanel:GetFlyReward()) do
        local data = {
          k.position,
          v
        }
        table.insert(cfg, data)
      end
      for k, v in pairs(self.compAddRewardPanel:GetFlyReward()) do
        local data = {
          k.position,
          v
        }
        table.insert(cfg, data)
      end
      self.ctrl:CloseSelf()
      DataCenter.LWBattleManager:GetCurBattleLogic():NoticeWin()
      DataCenter.LWBattleManager:Destroy()
      local lastPosition, lastEuler = DataCenter.RadarCenterDataManager:GetLastZombieBusBattleEnterPosAndEuler()
      DataCenter.RadarCenterDataManager:ClickAttackWorldZombieBus(nextBusData, nextBusIndex, curEventId, lastPosition, lastEuler)
    else
      self:OnBtnClaimClick()
    end
  else
    self:OnBtnClaimClick()
  end
end

local function OnBtnRetryClick(self)
  self.ctrl:CloseSelf()
  DataCenter.LWBattleManager:GetCurBattleLogic():NoticeLose()
  DataCenter.LWBattleManager:Restart()
end

local function Refresh(self)
  if self.param.stageRewardList then
    local rewardList = DataCenter.RewardTemplateManager:GetRewardByIdList(self.param.stageRewardList)
    self.compRewardPanel:Refresh(rewardList)
  end
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
      self.compAddRewardPanel:Refresh(addRewardList, Localization:GetString("monopoly_bonus_reward_04"))
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
    local addRewardList = DataCenter.RewardTemplateManager:GetRewardByIdList(getRewardIdList)
    if showRetryBtn then
      self.compAddRewardPanel:Refresh(addRewardList, Localization:GetString("monopoly_bonus_reward_02"))
      self.btnRetry:SetActive(true)
    else
      self.compAddRewardPanel:Refresh(addRewardList, Localization:GetString("monopoly_bonus_reward_03"))
      self.btnRetry:SetActive(false)
    end
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
      if showRetryBtn then
        self.compAddRewardPanel:Refresh(rewardList, Localization:GetString("monopoly_bonus_reward_02"))
      else
        self.compAddRewardPanel:Refresh(rewardList, Localization:GetString("monopoly_bonus_reward_03"))
      end
    end
    self.btnClaim:SetActive(true)
  end
  if self.param.enterType == PVEEnterType.DetectZombieBusTrain and self.param.extraData then
    local isInWorldEnter = self.param.extraData.isInWorld
    local curBusIndex = self.param.extraData.busIndex
    local nextBusData, nextBusIndex = DataCenter.RadarCenterDataManager:GetNextOneCanAttackZombieBusData(curBusIndex)
    self.btnRetry:SetActive(false)
    if isInWorldEnter and nextBusData then
      self.btnClaim:SetActive(true)
      self.btnNext:SetActive(true)
    else
      self.btnClaim:SetActive(true)
      self.btnNext:SetActive(false)
    end
  end
end

function UIParkourBonusResultView:ShowBonusLevel(number)
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
  self.bonusLevel:SetActive(true)
end

function UIParkourBonusResultView:GetBonusLevelShow(value)
  if 0 <= value and value <= 9 then
    return "Assets/Main/Sprites/UI/BonusLevel/zyf_guanqia_zi_" .. value
  end
  return "Assets/Main/Sprites/UI/BonusLevel/zyf_guanqia_zi_dian.png"
end

UIParkourBonusResultView.OnCreate = OnCreate
UIParkourBonusResultView.OnDestroy = OnDestroy
UIParkourBonusResultView.OnEnable = OnEnable
UIParkourBonusResultView.OnDisable = OnDisable
UIParkourBonusResultView.ComponentDefine = ComponentDefine
UIParkourBonusResultView.ComponentDestroy = ComponentDestroy
UIParkourBonusResultView.DataDefine = DataDefine
UIParkourBonusResultView.DataDestroy = DataDestroy
UIParkourBonusResultView.OnAddListener = OnAddListener
UIParkourBonusResultView.OnRemoveListener = OnRemoveListener
UIParkourBonusResultView.OnBtnClaimClick = OnBtnClaimClick
UIParkourBonusResultView.OnBtnRetryClick = OnBtnRetryClick
UIParkourBonusResultView.OnBtnNextClick = OnBtnNextClick
UIParkourBonusResultView.Refresh = Refresh
return UIParkourBonusResultView
