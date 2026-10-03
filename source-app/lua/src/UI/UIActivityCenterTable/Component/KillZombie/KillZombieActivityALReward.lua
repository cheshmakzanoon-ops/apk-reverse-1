local base = UIBaseContainer
local KillZombieActivityALReward = BaseClass("KillZombieActivityALReward", base)
local reward_title_path = "reward_title"
local reward_item_path = "ScrollView/Viewport/RewardItem"
local reward_content_path = "ScrollView/Viewport/RewardContent"
local level_btn_go_path = "LevelBtnGo"
local go_text_path = "LevelBtnGo/GoText"
local finish_tip_path = "finish_tip"
local red_point_path = "LevelBtnGo/RedPoint"

function KillZombieActivityALReward:OnCreate()
  base.OnCreate(self)
  self.reward_title = self:AddComponent(UIText, reward_title_path)
  self.content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.reward_title:SetLocalText("2010210")
  self.level_btn_go = self:AddComponent(UIButton, level_btn_go_path)
  self.go_text = self:AddComponent(UIText, go_text_path)
  self.finish_tip = self:AddComponent(UIText, finish_tip_path)
  self.red_point = self:AddComponent(UIImage, red_point_path)
  self.red_point:SetActive(false)
  self.go_text:SetLocalText("372258")
  self.level_btn_go:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.theCellItem = self.transform:Find(reward_item_path).gameObject
  self.theCellItem:GameObjectCreatePool()
end

function KillZombieActivityALReward:SetData(data)
  self.theData = data
end

function KillZombieActivityALReward:ReInit(difficulty)
  local mgr = DataCenter.ActivityListDataManager
  local dataList = DataCenter.ActivityKillZombieManager:GetListByType(2)
  local kill_zombie_AL = mgr:GetExtraData(KILL_ZOMBIE_ACTIVITY_AL_INFO)
  self.difficulty = difficulty
  if kill_zombie_AL ~= nil then
    local dataServer = kill_zombie_AL[tostring(difficulty)]
    if dataServer ~= nil and dataServer.status == 0 then
      local yes = DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.KillZombie)
      self.red_point:SetActive(yes)
    end
  else
    return
  end
  local dataConfig = dataList.data[difficulty]
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
  self:UpdateData()
end

function KillZombieActivityALReward:UpdateData()
  local kill_zombie_data = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_ACTIVITY_AL_INFO)
  local dataStatus = kill_zombie_data[tostring(self.difficulty)]
  if dataStatus ~= nil and dataStatus.status == 1 then
    self.finish_tip:SetActive(true)
    self.level_btn_go:SetActive(false)
    self.finish_tip:SetLocalText("2010224")
  elseif dataStatus ~= nil and dataStatus.status == 2 then
    self.finish_tip:SetActive(true)
    self.level_btn_go:SetActive(false)
    self.finish_tip:SetLocalText("2010216")
  else
    self.finish_tip:SetActive(false)
    self.level_btn_go:SetActive(true)
  end
end

function KillZombieActivityALReward:OnBtnGoClick()
  if CrossServerUtil:NeedIntercept(500019) then
    return
  end
  local kill_zombie_data = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_ACTIVITY_AL_INFO)
  if LuaEntry.Player:IsInAlliance() and kill_zombie_data ~= nil then
    if LuaEntry.Player:GetMainWorldPos() < 0 then
      SFSNetwork.SendMessage(MsgDefines.MoveCityToWorld)
    end
    local dataStatus = kill_zombie_data[tostring(self.difficulty)]
    if dataStatus ~= nil and dataStatus.status == 0 then
      if dataStatus.monster ~= nil and dataStatus.monster.pointId ~= nil then
        GoToUtil.CloseAllWindows()
        GoToUtil.MoveToWorldPointAndOpen(dataStatus.monster.pointId, nil, dataStatus.monster.monsterUid)
      elseif LuaEntry.Player:IsInAlliance() then
        SFSNetwork.SendMessage(MsgDefines.KillZombieALMonster, self.difficulty)
      else
        UIUtil.ShowTipsId("120050")
      end
    else
      self:UpdateData()
    end
  else
    UIUtil.ShowTipsId("2010218")
  end
end

function KillZombieActivityALReward:OnDestroy()
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

function KillZombieActivityALReward:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshActivityDetailData, self.UpdateData)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.UpdateData)
end

function KillZombieActivityALReward:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshActivityDetailData, self.UpdateData)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.UpdateData)
  base.OnRemoveListener(self)
end

return KillZombieActivityALReward
