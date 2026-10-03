local base = UIBaseContainer
local KillZombieActivityALKirovReward = BaseClass("KillZombieActivityALKirovReward", base)
local KillZombieActivityALKirovRewardItem = require("UI.UIActivityCenterTable.Component.KillZombie.AllianceKirov.KillZombieActivityALKirovRewardItem")
local KillZombieActivityALKirovProgressItem = require("UI.UIActivityCenterTable.Component.KillZombie.AllianceKirov.KillZombieActivityALKirovProgressItem")
local KillZombieRewardBubbleItem = require("UI.UIActivityCenterTable.Component.KillZombie.AllianceKirov.KillZombieRewardBubbleItem")
local personal_item_list_path = "PersonalReward/PersonalItemList"
local al_item_list_path = "AllianceReward/AlItemList"
local personal_item_path = "PersonalReward/PersonalItem"
local alliance_item_path = "AllianceReward/AllianceItem"
local personal_progress_list_path = "PersonalReward/PersonalProgressList"
local personal_progress_item_path = "PersonalReward/PersonalProgressList/PersonalProgressItem"
local al_progress_list_path = "AllianceReward/AlProgressList"
local al_progress_item_path = "AllianceReward/AlProgressList/AlProgressItem"
local bubble_item_path = "BubbleItem"

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
  self.defaultItem = nil
end

local function OnDisable(self)
  base.OnDisable(self)
  self.defaultItem = nil
end

local function ComponentDefine(self)
  self.textPersonal = self:AddComponent(UITextMeshProUGUIEx, "PersonalReward/IconGroup/PersonalText")
  self.textPersonal:SetLocalText("challenge_zombie_person")
  self.personal_item_list = self:AddComponent(UIBaseContainer, personal_item_list_path)
  self.personal_item = self:AddComponent(KillZombieActivityALKirovRewardItem, personal_item_path)
  self.personal_item.gameObject:GameObjectCreatePool()
  self.textAlliance = self:AddComponent(UITextMeshProUGUIEx, "AllianceReward/IconGroup/AllianceText")
  self.textAlliance:SetLocalText("challenge_zombie_alliance")
  self.alliance_item_list = self:AddComponent(UIBaseContainer, al_item_list_path)
  self.alliance_item = self:AddComponent(KillZombieActivityALKirovRewardItem, alliance_item_path)
  self.alliance_item.gameObject:GameObjectCreatePool()
  self.personalItemList = {}
  self.allianceItemList = {}
  self.personal_progress_list = self:AddComponent(UIBaseContainer, personal_progress_list_path)
  self.personal_progress_item = self:AddComponent(KillZombieActivityALKirovProgressItem, personal_progress_item_path)
  self.personal_progress_item.gameObject:GameObjectCreatePool()
  self.al_progress_list = self:AddComponent(UIBaseContainer, al_progress_list_path)
  self.al_progress_item = self:AddComponent(KillZombieActivityALKirovProgressItem, al_progress_item_path)
  self.al_progress_item.gameObject:GameObjectCreatePool()
  self.personalProgressList = {}
  self.alProgressList = {}
  self.bubble_item = self:AddComponent(KillZombieRewardBubbleItem, bubble_item_path)
  self.bubble_item:SetActive(false)
end

local function ComponentDestroy(self)
  self.textPersonal = nil
  self.textAlliance = nil
  self.personal_item_list:RemoveComponents(KillZombieActivityALKirovRewardItem)
  self.personal_item_list = nil
  self.alliance_item_list:RemoveComponents(KillZombieActivityALKirovRewardItem)
  self.alliance_item_list = nil
  self.personal_item.gameObject:GameObjectRecycleAll()
  self.personal_item = nil
  self.alliance_item.gameObject:GameObjectRecycleAll()
  self.alliance_item = nil
  self.personalItemList = nil
  self.allianceItemList = nil
  self.personal_progress_list:RemoveComponents(KillZombieActivityALKirovProgressItem)
  self.personal_progress_list = nil
  self.al_progress_list:RemoveComponents(KillZombieActivityALKirovProgressItem)
  self.al_progress_list = nil
  self.personal_progress_item.gameObject:GameObjectRecycleAll()
  self.personal_progress_item = nil
  self.al_progress_item.gameObject:GameObjectRecycleAll()
  self.al_progress_item = nil
  self.personalProgressList = nil
  self.alProgressList = nil
  self.bubble_item = nil
end

local function DataDefine(self)
  self.delayTimer = nil
  self.defaultItem = nil
end

local function DataDestroy(self)
  if self.delayTimer then
    self.delayTimer:Stop()
  end
  self.delayTimer = nil
  self.defaultItem = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChallengeZombieProgressNodeClicked, self.ShowRewardBubble)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.ChallengeZombieProgressNodeClicked, self.ShowRewardBubble)
  base.OnRemoveListener(self)
end

local function RefreshView(self, bossId, personalDmg, allianceDmg)
  self.bossId = bossId
  self:InitListView(bossId, personalDmg, allianceDmg)
end

local function InitListView(self, bossId, personalDmg, allianceDmg)
  if bossId == nil or bossId == 0 then
    return
  end
  local template = DataCenter.AdvancedChallengeBossTemplateManager:GetTemplate(bossId)
  if template == nil then
    return
  end
  self:InitProgressList(template.player_progress)
  if personalDmg ~= nil then
    self.personal_item_list:SetActive(true)
    self:InitPersonalItemList(personalDmg, template.player_progress, template.player_reward_show, template.player_progress_special)
  else
    self.personal_item_list:SetActive(false)
  end
  allianceDmg = allianceDmg or 0
  self:InitAllianceItemList(allianceDmg, template.alliance_progress, template.alliance_reward_show, template.alliance_progress_special)
end

local function InitProgressList(self, progressData)
  if table.IsNullOrEmpty(self.personalProgressList) and progressData then
    local count = #progressData
    for i = 1, count - 1 do
      local item = self.personal_progress_item.gameObject:GameObjectSpawn(self.personal_progress_list.transform)
      local name = tostring(i)
      item.name = name
      local cell = self.personal_progress_list:AddComponent(KillZombieActivityALKirovProgressItem, name)
      table.insert(self.personalProgressList, cell)
      local item1 = self.al_progress_item.gameObject:GameObjectSpawn(self.al_progress_list.transform)
      item1.name = name
      local cell1 = self.al_progress_list:AddComponent(KillZombieActivityALKirovProgressItem, name)
      table.insert(self.alProgressList, cell1)
    end
  end
end

local function InitPersonalItemList(self, personalDmg, progressData, rewardData, markData)
  if progressData and rewardData and markData then
    local rewardArr = string.split(rewardData, "|")
    if rewardArr and markData then
      personalDmg = personalDmg or 0
      if self.personalProgressList == nil or #self.personalProgressList == 0 then
        self:InitProgressList()
      end
      local lastDmg = 0
      local create = self.personalItemList == nil or #self.personalItemList == 0
      for i, v in ipairs(progressData) do
        local curDmg = tonumber(v)
        local dmg = curDmg - lastDmg
        local remainDmg = personalDmg - lastDmg
        lastDmg = curDmg
        local progressItem = 1 < i and self.personalProgressList[i - 1] or nil
        local cell
        if create then
          local item = self.personal_item.gameObject:GameObjectSpawn(self.personal_item_list.transform)
          local name = tostring(i)
          item.name = name
          cell = self.personal_item_list:AddComponent(KillZombieActivityALKirovRewardItem, name)
          cell:RefreshInfo(dmg, remainDmg, rewardArr[i], markData[i], progressItem, 0, i, tonumber(v))
          table.insert(self.personalItemList, cell)
        else
          cell = self.personalItemList[i]
          if cell then
            cell:RefreshInfo(dmg, remainDmg, rewardArr[i], markData[i], progressItem, 0, i, tonumber(v))
          end
        end
      end
    end
  end
end

local function InitAllianceItemList(self, allianceDmg, progressData, rewardData, markData)
  if progressData and rewardData and markData then
    local rewardArr = string.split(rewardData, "|")
    if rewardArr and markData then
      allianceDmg = allianceDmg or 0
      local lastDmg = 0
      local create = self.allianceItemList == nil or #self.allianceItemList == 0
      local check = self.defaultItem == nil
      local defaultItem
      for i, v in ipairs(progressData) do
        local curDmg = tonumber(v)
        local dmg = curDmg - lastDmg
        local remainDmg = allianceDmg - lastDmg
        lastDmg = curDmg
        local progressItem = 1 < i and self.alProgressList[i - 1] or nil
        local cell
        if create then
          local item = self.alliance_item.gameObject:GameObjectSpawn(self.alliance_item_list.transform)
          local name = tostring(i)
          item.name = name
          cell = self.alliance_item_list:AddComponent(KillZombieActivityALKirovRewardItem, name)
          cell:RefreshInfo(dmg, remainDmg, rewardArr[i], markData[i], progressItem, 1, i, tonumber(v))
          table.insert(self.allianceItemList, cell)
        else
          cell = self.allianceItemList[i]
          if cell then
            cell:RefreshInfo(dmg, remainDmg, rewardArr[i], markData[i], progressItem, 1, i, tonumber(v))
          end
        end
        if check and cell then
          if defaultItem == nil then
            defaultItem = cell
          elseif cell:GetIsReach() then
            defaultItem = cell
          end
        end
      end
      self.defaultItem = check and defaultItem or self.defaultItem
      self.bubble_item:ResetData()
    end
  end
end

local function ShowDefaultRewardBubble(self, show, first)
  if show then
    if first then
      if self.delayTimer then
        self.delayTimer:Stop()
      end
      self.delayTimer = TimerManager:GetInstance():DelayFrameInvoke(function()
        if self.delayTimer then
          self.delayTimer:Stop()
        end
        if self.defaultItem then
          self.defaultItem:OnItemClick()
        end
      end, 3)
    elseif self.defaultItem then
      self.defaultItem:OnItemClick()
    end
  else
    EventManager:GetInstance():Broadcast(EventId.ChallengeZombieProgressNodeClicked)
  end
end

local function ShowRewardBubble(self, param)
  if param then
    if param.node then
      self.bubble_item.transform.position = param.node.transform.position
      self.bubble_item:RefreshInfo(param)
    else
      self.bubble_item:SetActive(false)
    end
  else
    self.bubble_item:SetActive(false)
  end
end

KillZombieActivityALKirovReward.OnCreate = OnCreate
KillZombieActivityALKirovReward.OnDestroy = OnDestroy
KillZombieActivityALKirovReward.OnEnable = OnEnable
KillZombieActivityALKirovReward.OnDisable = OnDisable
KillZombieActivityALKirovReward.ComponentDefine = ComponentDefine
KillZombieActivityALKirovReward.ComponentDestroy = ComponentDestroy
KillZombieActivityALKirovReward.DataDefine = DataDefine
KillZombieActivityALKirovReward.DataDestroy = DataDestroy
KillZombieActivityALKirovReward.OnAddListener = OnAddListener
KillZombieActivityALKirovReward.OnRemoveListener = OnRemoveListener
KillZombieActivityALKirovReward.RefreshView = RefreshView
KillZombieActivityALKirovReward.InitListView = InitListView
KillZombieActivityALKirovReward.InitProgressList = InitProgressList
KillZombieActivityALKirovReward.InitPersonalItemList = InitPersonalItemList
KillZombieActivityALKirovReward.InitAllianceItemList = InitAllianceItemList
KillZombieActivityALKirovReward.ShowDefaultRewardBubble = ShowDefaultRewardBubble
KillZombieActivityALKirovReward.ShowRewardBubble = ShowRewardBubble
return KillZombieActivityALKirovReward
