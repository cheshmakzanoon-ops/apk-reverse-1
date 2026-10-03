local UIMainKillZombie = BaseClass("UIMainKillZombie", UIBaseContainer)
local base = UIBaseContainer
local KillZombieActivityMain = require("UI.UIActivityCenterTable.Component.KillZombie.KillZombieActivityMain")
local tips1_path = "Tips1"
local tips1_name_path = "Tips1/name"
local tips1_items_path = "Tips1/ScrollView/Viewport/items"
local tips2_path = "Tips2"
local tips2_btn_path = "Tips2/GoRewardBtn"

function UIMainKillZombie:OnCreate()
  base.OnCreate(self)
  self.kill_count = -1
  self:ComponentDefine()
end

function UIMainKillZombie:ClearRewards()
  self.tips1_items:RemoveComponents(UICommonResItem)
  if self.rewardReqs then
    for _, req in ipairs(self.rewardReqs) do
      self:GameObjectDestroy(req)
    end
  end
  self.rewardReqs = {}
end

function UIMainKillZombie:OnDestroy()
  self.kill_count = -1
  self.curExtraRewards = nil
  self:ClearRewards()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMainKillZombie:OnEnable()
  base.OnEnable(self)
  self:RefreshData()
  self:AddUIListener(EventId.RefreshActivityDetailData, self.RefreshData)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.RefreshData)
  self:AddUIListener(EventId.MonsterChallengeUpdate, self.OnMonsterChallengeUpdate)
end

function UIMainKillZombie:OnDisable()
  self:RemoveUIListener(EventId.RefreshActivityDetailData, self.RefreshData)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.RefreshData)
  self:RemoveUIListener(EventId.MonsterChallengeUpdate, self.OnMonsterChallengeUpdate)
  base.OnDisable(self)
end

function UIMainKillZombie:ComponentDefine()
  self.lod = 1
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    KillZombieActivityMain.OnMainUIClick()
  end)
  self.tips1 = self:AddComponent(UICanvasGroup, tips1_path)
  self.tips1_bg = self:AddComponent(UIButton, "Tips1/bg")
  self.tips1_name = self:AddComponent(UIText, tips1_name_path)
  self.tips1_items = self:AddComponent(UIBaseContainer, tips1_items_path)
  self.tips1_bg:SetOnClick(function()
    self.tips1_hidden = nil
    self.tips1:SetAlpha(0)
    self.tips1:SetActive(false)
  end)
  self.tips1:SetActive(false)
  self.tips1:SetAlpha(0)
  self.tips2 = self:AddComponent(UICanvasGroup, tips2_path)
  self.tips2_btn = self:AddComponent(UIButton, tips2_btn_path)
  self.tips2_btn:SetOnClick(function()
    self.tips2:SetAlpha(0)
    self.tips2:SetActive(false)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityKillZombieActionReward)
  end)
  self.tips2:SetActive(false)
  self.tips2:SetAlpha(0)
end

function UIMainKillZombie:ComponentDestroy()
  self.btn = nil
end

function UIMainKillZombie:SetLod(lod)
  if self.lod ~= lod then
    self.lod = lod
    self:RefreshData()
  end
end

function UIMainKillZombie:RefreshData()
  if self.lod <= 3 and CrossServerUtil:GetIsCrossServer() == false then
    local curScene = CS.SceneManager.CurrSceneID
    if curScene == SceneManagerSceneID.World then
      self.btn:SetActive(KillZombieActivityMain.CanShowKillZombieIcon())
    else
      self.btn:SetActive(false)
    end
  else
    self.btn:SetActive(false)
  end
end

function UIMainKillZombie:OnMonsterChallengeUpdate()
  if self.view ~= nil and self.view.curAnimState ~= nil and self.view.curAnimState == UIMainAnimType.AllHide then
    return
  end
  if not UIManager:GetInstance():CheckIfIsMainUIOpenOnly(true) then
    return
  end
  if DataCenter.ActivityKillZombieManager:HasPersonMonsterReward() then
    self.tips1:SetActive(false)
    self.tips1:SetAlpha(0)
    self.tips1_hidden = nil
    self.tips2:SetActive(true)
    self.tips2:SetAlpha(1)
  else
    self:OnMonsterChallenged()
  end
end

function UIMainKillZombie:UpdateWhenAnim(animName)
  if animName == UIMainAnimType.AllHide and self.btn and self.btn:GetActive() then
    if self.tips1 ~= nil and self.tips1:GetActive() then
      self.tips1:SetActive(false)
      self.tips1:SetAlpha(0)
      self.tips1_hidden = nil
    end
    if self.tips2 ~= nil and self.tips2:GetActive() then
      self.tips2:SetActive(false)
      self.tips2:SetAlpha(0)
    end
  end
end

function UIMainKillZombie:OnMonsterChallenged()
  if self.view ~= nil and self.view.curAnimState ~= nil and self.view.curAnimState == UIMainAnimType.AllHide then
    return
  end
  if not UIManager:GetInstance():CheckIfIsMainUIOpenOnly(true) then
    return
  end
  if self.tips1 then
    local mgr = DataCenter.ActivityListDataManager
    local dataList = DataCenter.ActivityKillZombieManager:GetListByType(1)
    local difficulty_select = mgr:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_SELECT, 0)
    if difficulty_select == 0 then
      return
    end
    local kill_zombie_data = mgr:GetExtraData(KILL_ZOMBIE_ACTIVITY_PLAYER_INFO)
    if kill_zombie_data == nil then
      return
    end
    local kill_count = kill_zombie_data.count or 0
    if kill_count == 0 or self.kill_count == kill_count then
      return
    end
    local now_data = dataList.data[difficulty_select]
    if now_data == nil or now_data.rewardListServer == nil then
      return
    end
    local levelList = now_data.rewardListServer.levelList
    local level_count = #levelList
    local extraRewards
    local floorChallengeCount = -1
    local minChallengeCount = 0
    local minChallengeItem
    for index, needCount in ipairs(levelList) do
      if needCount <= kill_count and needCount >= floorChallengeCount then
        floorChallengeCount = needCount
      end
      if index == 1 then
        minChallengeCount = needCount
      elseif needCount < minChallengeCount then
        minChallengeCount = needCount
      end
    end
    local curChallengeIndex = 0
    local needCount = 0
    if floorChallengeCount ~= -1 then
      local floorindex = table.indexof(levelList, floorChallengeCount)
      curChallengeIndex = math.min(level_count, floorindex + 1)
      needCount = levelList[curChallengeIndex]
    elseif 0 < minChallengeCount then
      needCount = minChallengeCount
    end
    local rewardStr = now_data.rewardListServer[tostring(needCount)]
    if rewardStr ~= nil and rewardStr ~= "" then
      extraRewards = DataCenter.RewardManager:ParseRewardsStr(rewardStr)
      self.tips1:SetActive(true)
      self.tips1:SetAlpha(1)
      self.tips1_hidden = 3
      self.tips1_name:SetLocalText("2010363", kill_count, needCount)
    end
    if extraRewards == nil and self.curExtraRewards ~= nil then
      self.tips1:SetAlpha(0)
      self.tips1_hidden = nil
    end
    if table.deep_compare(extraRewards, self.curExtraRewards) then
      return
    end
    self:ClearRewards()
    for i, item in ipairs(extraRewards) do
      local req = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
        if req == nil then
          return
        end
        local obj = req.gameObject
        if IsNull(obj) then
          return
        end
        local rewardName = "item_" .. i
        obj.name = rewardName
        obj:SetActive(true)
        obj.transform:SetParent(self.tips1_items.transform)
        obj.transform:Set_localScale(0.9, 0.9, 1)
        obj.transform:Set_sizeDelta(97, 102)
        obj.transform:Set_pivot(0, 1)
        local cell = self.tips1_items:AddComponent(UICommonResItem, rewardName)
        cell:ReInit(item)
      end)
      table.insert(self.rewardReqs, req)
    end
    self.curExtraRewards = extraRewards
  end
end

function UIMainKillZombie:Update1000MS()
  if self.tips1_hidden then
    self.tips1_hidden = self.tips1_hidden - 1
    if self.tips1_hidden == 0 then
      self.tips1_hidden = nil
      self.tips1:SetAlpha(0)
      self.tips1:SetActive(false)
    end
  end
end

return UIMainKillZombie
