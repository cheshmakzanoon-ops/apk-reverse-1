local base = UIBaseContainer
local KillZombieActivityPersonTip = BaseClass("KillZombieActivityPersonTip", base)
local Localization = CS.GameEntry.Localization
local ActivityKillZombieManager = DataCenter.ActivityKillZombieManager
local tip_box_path = "TipBox"
local reward_item_path = "TipBox/ScrollView/Viewport/RewardItem"
local reward_content_path = "TipBox/ScrollView/Viewport/RewardContent"
local select_btn_path = "TipBox/SelectBtn/Icon"
local desc_text_path = "TipBox/DescText"

function KillZombieActivityPersonTip:OnCreate()
  base.OnCreate(self)
  self.tip_root = self:AddComponent(UICanvasGroup, "")
  self.reward_content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.select_btn = self:AddComponent(UIButton, select_btn_path)
  self.tip_box = self:AddComponent(UIImage, tip_box_path)
  self.theCellItem = self.transform:Find(reward_item_path).gameObject
  self.theCellItem:GameObjectCreatePool()
  self.select_btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  if self.transform:Find("panel") ~= nil then
    self.bgPanel = self:AddComponent(UIButton, "panel")
    self.bgPanel:SetOnClick(function()
      self:SetActive(false)
      if self.theActiveItem then
        self.theActiveItem:OnItemSelect(false)
      end
    end)
  end
  self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_text_path)
  self.maxPower = nil
  self.level = nil
  self.last_level = nil
  self.checkDifficulty = nil
  self.difficultyLevel = nil
  self.advanceIsOpen = nil
end

function KillZombieActivityPersonTip:OnDestroy()
  self.reward_content:RemoveComponents(UICommonResItem)
  self.theCellItem:GameObjectRecycleAll()
  for _, v in ipairs(self.reward_content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.reward_content = nil
  self.theCellItem = nil
  self.desc_text = nil
  self.maxPower = nil
  self.level = nil
  self.last_level = nil
  self.checkDifficulty = nil
  self.difficultyLevel = nil
  self.advanceIsOpen = nil
  base.OnDestroy(self)
end

function KillZombieActivityPersonTip:FadeIn(time, index, item)
  self.tip_root:SetActive(true)
  item:UpdateTipArrow(true)
  if self.theIndex == index and self.theActiveItem == item then
    Logger.LogInfo("[KillZombie] FadeIn --- curs index = " .. self.theIndex)
    self.tip_root:SetAlpha(1)
    return
  end
  if 0.01 < time then
    self.tip_root:SetAlpha(0)
    self.tip_root:FadeIn(time)
  else
    self.tip_root:SetAlpha(1)
  end
  local screenPos = PosConverse.UIWorldToScreenPos(item.transform.position)
  if screenPos.x > 400 then
    self.tip_box.transform:Set_pivot(CommonUtil.IsArabicAutoMirrorOpen() and 0.8 or 0.2, 0)
    self.tip_box.transform:Set_localPosition(0, 105, 0)
  else
    self.tip_box.transform:Set_pivot(CommonUtil.IsArabicAutoMirrorOpen() and 0.2 or 0.8, 0)
    self.tip_box.transform:Set_localPosition(0, 105, 0)
  end
  self.theIndex = index
  Logger.LogInfo("[KillZombie] FadeIn --- update index = " .. self.theIndex)
  self.theActiveItem = item
  self:ShowReward()
end

function KillZombieActivityPersonTip:ShowUI(index, item, x, difficultyLevel)
  self.theIndex = index
  self.difficultyLevel = difficultyLevel
  local data = item.theData
  local reqPower = data and data.power_requirement
  if self.maxPower == nil or self.maxPower == 0 then
    self.maxPower = self:GetArmyFormationMaxPower()
  end
  local difficulty = data and data.difficulty or 0
  self.level = difficulty
  Logger.LogInfo("[KillZombie] ShowUI --- show index = " .. self.theIndex .. ", difficulty = " .. (data and data.difficulty or 0) .. ", level = " .. self.level)
  local dialogId
  if reqPower > self.maxPower then
    dialogId = "challenge_zombie_012"
  else
    dialogId = "challenge_zombie_013"
  end
  local context = Localization:GetString(dialogId, string.GetFormattedSeperatorNum(reqPower))
  self.desc_text:SetText(context)
  self.theActiveItem = item
  self.tip_box.transform:Set_localPosition(x * CommonUtil.ArabicAutoMirrorFactor(), 105, 0)
  self:ShowReward()
end

function KillZombieActivityPersonTip:ShowReward()
  self.reward_content:RemoveComponents(UICommonResItem)
  self.theCellItem:GameObjectRecycleAll()
  local extraRewards = self:GetPersonRewardList()
  if extraRewards ~= nil then
    local goItem, theItem
    for i, v in ipairs(extraRewards) do
      local levelName = "item_" .. i
      goItem = self.theCellItem:GameObjectSpawn(self.reward_content.transform)
      goItem.name = levelName
      goItem:SetActive(true)
      theItem = self.reward_content:AddComponent(UICommonResItem, levelName)
      theItem:ReInit(v)
    end
  end
end

function KillZombieActivityPersonTip:GetPersonRewardList()
  local dataList = ActivityKillZombieManager:GetListByType(1)
  local now_data = dataList.data[self.theIndex]
  if now_data == nil then
    now_data = dataList.data[1]
  end
  if now_data.rewardListServer.allRewards == nil then
    now_data.rewardListServer.allRewards = DataCenter.RewardManager:ParseRewardsStr(now_data.rewardListServer.all)
  end
  return now_data.rewardListServer.allRewards
end

function KillZombieActivityPersonTip:SetData(data)
  self.theData = data
end

function KillZombieActivityPersonTip:SetAlpha(alpha)
  self.tip_root:SetAlpha(alpha)
  self.tip_root:SetActive(true)
end

function KillZombieActivityPersonTip:OnBtnClick()
  if not self:CheckDifficulty() then
    self:StartChallenge()
  end
end

local function GetArmyFormationMaxPower(self)
  local maxPower = 0
  local list = DataCenter.ArmyFormationDataManager:GetCurFormationList()
  if list == nil then
    return maxPower
  end
  local power = 0
  for _, v in pairs(list) do
    if v then
      v:GetVirtualConscriptSoldierPower()
      power = v:GetTotalCapacity()
      if maxPower < power then
        maxPower = power
      end
    end
  end
  return maxPower
end

local function StartChallenge(self)
  self.tip_root:SetAlpha(0)
  self.tip_root:SetActive(false)
  self.theActiveItem:UpdateTipArrow(false)
  SFSNetwork.SendMessage(MsgDefines.KillZombieSelectDifficulty, self.theIndex)
end

local function CheckDifficulty(self)
  Logger.LogInfo("[KillZombie] CheckDifficulty --- index = " .. self.theIndex .. ", level = " .. self.level)
  if self.difficultyLevel == 0 then
    if self.checkDifficulty and self.advanceIsOpen then
      local difficulty = ActivityKillZombieManager.GetRelDifficultyInLevel(self.level)
      local maxDifficulty = ActivityKillZombieManager.GetRelDifficultyInLevel(ActivityKillZombieManager.maxReachLevel)
      local context = Localization:GetString("activity_challenge_normal_check", difficulty, maxDifficulty)
      local param = {
        contentText = context,
        btnNum = 2,
        confirmBtnParam = {
          action = function()
            self:StartChallenge()
          end
        }
      }
      UIUtil.TryShowConfirmNew(TodayNoSecondConfirmType.KillZombiePersonalBossChallenge, param)
      return true
    end
  elseif self.checkDifficulty then
    local context
    local difficulty = ActivityKillZombieManager.GetRelDifficultyInLevel(self.level)
    local maxDifficulty = ActivityKillZombieManager.GetRelDifficultyInLevel(ActivityKillZombieManager.maxReachLevel)
    if self.level < ActivityKillZombieManager.maxReachLevel then
      context = Localization:GetString("challenge_person_check_1", difficulty, maxDifficulty, difficulty)
    elseif self.last_level ~= nil then
      if self.last_level < 1000 then
        context = Localization:GetString("challenge_person_check_jump_advanced", difficulty, difficulty)
      elseif self.level ~= self.last_level then
        local lastLevel = ActivityKillZombieManager.GetRelDifficultyInLevel(self.last_level)
        context = Localization:GetString("challenge_person_check_2", difficulty, lastLevel, difficulty)
      elseif self.level == self.last_level then
        context = Localization:GetString("challenge_person_check_3", difficulty, difficulty)
      end
    end
    if string.IsNullOrEmpty(context) then
      return false
    end
    local param = {
      contentText = context,
      btnNum = 2,
      confirmBtnParam = {
        action = function()
          self:StartChallenge()
        end
      }
    }
    UIUtil.TryShowConfirmNew(TodayNoSecondConfirmType.KillZombiePersonalBossChallenge, param)
    return true
  end
  return false
end

local function GetDifficulty(self)
  local value = ActivityKillZombieManager:GetDifficultyRemindSwitchOn()
  self.checkDifficulty = value
  return self.checkDifficulty
end

local function GetLastDifficulty(self)
  local value = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_PLAYER_LAST_DIFFICULTY, 0)
  self.last_level = value
  return self.last_level
end

local function GetAdventureIsOpen(self)
  local playerRecordMaxDiffcultyLevel = CommonUtil.PlayerPrefsGetInt(SettingKeys.PERSON_KILLZOMBIE_MAX_DIFFICULTY_LEVEL, 0)
  local advanceIsOpen = LuaEntry.DataConfig:CheckSwitch("new_challenge_zombie_open")
  self.advanceIsOpen = 0 < playerRecordMaxDiffcultyLevel and advanceIsOpen
  return self.advanceIsOpen
end

KillZombieActivityPersonTip.GetArmyFormationMaxPower = GetArmyFormationMaxPower
KillZombieActivityPersonTip.StartChallenge = StartChallenge
KillZombieActivityPersonTip.CheckDifficulty = CheckDifficulty
KillZombieActivityPersonTip.getters.checkDifficulty = GetDifficulty
KillZombieActivityPersonTip.getters.last_level = GetLastDifficulty
KillZombieActivityPersonTip.getters.advanceIsOpen = GetAdventureIsOpen
return KillZombieActivityPersonTip
