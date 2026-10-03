local base = UIBaseContainer
local KillZombieActivityALRewardWait = BaseClass("KillZombieActivityALRewardWait", base)
local Localization = CS.GameEntry.Localization
local reward_title_path = "reward_title"
local reward_item_path = "ScrollView/Viewport/RewardItem"
local reward_content_path = "ScrollView/Viewport/RewardContent"
local level_btn_go_path = "LevelBtnGo"
local go_text_path = "LevelBtnGo/GoText"
local level_info_lv_path = "info/level_info_lv"
local level_info_title_path = "info/level_info_title"
local condition11_path = "condition/condition11"
local condition21_path = "condition/condition21"
local red_point_path = "LevelBtnGo/RedPoint"

function KillZombieActivityALRewardWait:OnCreate()
  base.OnCreate(self)
  self.reward_title = self:AddComponent(UIText, reward_title_path)
  self.content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.reward_title:SetLocalText("2010210")
  self.level_btn_go = self:AddComponent(UIButton, level_btn_go_path)
  self.go_text = self:AddComponent(UIText, go_text_path)
  self.go_text:SetLocalText("372258")
  self.red_point = self:AddComponent(UIImage, red_point_path)
  self.red_point:SetActive(false)
  self.level_btn_go:SetActive(true)
  self.level_btn_go:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.level_info_lv = self:AddComponent(UIText, level_info_lv_path)
  self.level_info_title = self:AddComponent(UIText, level_info_title_path)
  self.condition11 = self:AddComponent(UIText, condition11_path)
  self.condition21 = self:AddComponent(UIText, condition21_path)
  self.theCellItem = self.transform:Find(reward_item_path).gameObject
  self.theCellItem:GameObjectCreatePool()
end

function KillZombieActivityALRewardWait:SetData(data)
  self.theData = data
end

function KillZombieActivityALRewardWait:ReInit(difficulty)
  local dataList = DataCenter.ActivityKillZombieManager:GetListByType(2)
  if dataList == nil then
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    return
  end
  local kill_zombie_AL = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_ACTIVITY_AL_INFO)
  local dataConfig = dataList.data[difficulty]
  local dataStatus = kill_zombie_AL[tostring(difficulty)]
  local rewardListServer = dataConfig.rewardListServer
  local levelList = rewardListServer.levelList
  for _, k in ipairs(levelList) do
    local rewardStr = rewardListServer[tostring(k)]
    if rewardStr ~= nil then
      local goItem, theItem
      local extraRewards = DataCenter.RewardManager:ParseRewardsStr(rewardStr)
      if extraRewards ~= nil then
        local theItemList = self.theItemList or {}
        local count = #theItemList
        local index = 0
        for i, item in ipairs(extraRewards) do
          local levelName = "item_" .. i
          theItem = theItemList[levelName]
          if theItem == nil then
            goItem = self.theCellItem:GameObjectSpawn(self.content.transform)
            goItem.name = levelName
            goItem:SetActive(true)
            theItem = self.content:AddComponent(UICommonResItem, levelName)
            theItemList[levelName] = theItem
          end
          theItem:ReInit(item)
          index = i
        end
        for i = index + 1, count do
          theItem = theItemList["item_" .. i]
          if theItem ~= nil then
            theItem:SetActive(false)
          end
        end
        self.theItemList = theItemList
      end
    end
    break
  end
  local monster = dataConfig.firstMonster
  local conditionList = dataConfig.conditionList
  self.difficulty = difficulty
  self.level_info_lv:SetLocalText("all_level_limit_4", monster.level)
  self.level_info_title:SetText(Localization:GetString(monster.name))
  if conditionList ~= nil then
    for _, v in ipairs(conditionList) do
      local level = tonumber(v.level)
      local languageKey = "2010234"
      if level == -1 then
        languageKey = "challenge_zombie_011"
      end
      if v.data.ui_type == 1 then
        local canAttack = DataCenter.ActivityKillZombieManager:CanInvokeBossZombie(difficulty)
        if canAttack then
          local tipMsg = Localization:GetString(languageKey, v.count, v.count, v.data.relDifficultyInLevel, v.level)
          self.condition11:SetText(tipMsg)
          self.condition11:SetActive(true)
          self.condition21:SetActive(false)
        else
          local finish_count = dataStatus.progress or 0
          local tipMsg = Localization:GetString(languageKey, finish_count, v.count, v.data.relDifficultyInLevel, v.level)
          self.condition21:SetText(tipMsg)
          self.condition11:SetActive(false)
          self.condition21:SetActive(true)
        end
        self.canAttack = canAttack
      end
    end
  end
  self.red_point:SetActive(self.canAttack)
end

function KillZombieActivityALRewardWait:OnBtnGoClick()
  if CrossServerUtil:NeedIntercept(500019) then
    return
  end
  local difficulty = self.difficulty
  if difficulty == nil then
    UIUtil.ShowTipsId("120173")
    return
  end
  if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
    UIUtil.ShowTipsId("120173")
    return
  end
  if not self.canAttack then
    UIUtil.ShowTipsId("2010231")
    return
  end
  if LuaEntry.Player:GetMainWorldPos() < 0 then
    SFSNetwork.SendMessage(MsgDefines.MoveCityToWorld)
  end
  UIUtil.ShowMessage(Localization:GetString("2010225"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    SFSNetwork.SendMessage(MsgDefines.KillZombieALMonster, difficulty)
  end, nil, nil)
end

function KillZombieActivityALRewardWait:OnDestroy()
  self.content:RemoveComponents(UICommonResItem)
  self.theCellItem:GameObjectRecycleAll()
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.content = nil
  self.reward_title = nil
  base.OnDestroy(self)
end

return KillZombieActivityALRewardWait
