local UIActivityKillZombieActionRewardView = BaseClass("UIActivityKillZombieActionRewardView", UIBaseView)
local base = UIBaseView
local ActionRewardItem = require("UI.UIActivityKillZombie.ActionReward.Component.ActionRewardItem")
local ActionRewardToggle = require("UI.UIActivityKillZombie.ActionReward.Component.ActionRewardToggle")
local panel_path = "panel"
local title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local toggle_path = "PopUpTitle/Common_bg_orange2/mainObj/TabListView/Toggle"
local tab_path = "PopUpTitle/Common_bg_orange2/mainObj/TabListView/Viewport/Tab"
local desc_path = "PopUpTitle/Common_bg_orange2/mainObj/MiddleBg/desc"
local reward_item_path = "PopUpTitle/Common_bg_orange2/mainObj/MiddleBg/ScrollView/RewardItem"
local cell_path = "PopUpTitle/Common_bg_orange2/mainObj/MiddleBg/ScrollView/Cell"
local content_path = "PopUpTitle/Common_bg_orange2/mainObj/MiddleBg/ScrollView/Viewport/Content"
local tab_list_view_path = "PopUpTitle/Common_bg_orange2/mainObj/TabListView"
local scroll_view_path = "PopUpTitle/Common_bg_orange2/mainObj/MiddleBg/ScrollView"

function UIActivityKillZombieActionRewardView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self:ComponentDefine()
end

function UIActivityKillZombieActionRewardView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActivityKillZombieActionRewardView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, panel_path)
  self.btnPanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.titleText = self:AddComponent(UIText, title_text_path)
  if self.param then
    self.titleText:SetLocalText(self.param.title or 2000047)
  else
    self.titleText:SetLocalText(2010201)
  end
  self.closeBtn = self:AddComponent(UIButton, close_btn_path)
  self.closeBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.desc = self:AddComponent(UIText, desc_path)
  self.desc:SetText("")
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.tabRoot = self:AddComponent(UIBaseContainer, tab_path)
  self.tab_list_view = self:AddComponent(UIScrollRect, tab_list_view_path)
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.theToggleItem = self.transform:Find(toggle_path).gameObject
  self.theToggleItem:GameObjectCreatePool()
  self.theRewardItem = self.transform:Find(reward_item_path).gameObject
  self.theRewardItem:GameObjectCreatePool()
  self.theCellItem = self.transform:Find(cell_path).gameObject
  self.theCellItem:GameObjectCreatePool()
  self.desc:SetLocalText("2010213")
  local mgr = DataCenter.ActivityListDataManager
  local kill_zombie_difficulty_select = mgr:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_SELECT, 0)
  local goItem, theToggle
  local difficultyLevel = 0
  if kill_zombie_difficulty_select ~= 0 then
    difficultyLevel = DataCenter.ActivityKillZombieManager.GetDifficultyLevel(kill_zombie_difficulty_select)
  elseif self.param then
    difficultyLevel = self.param.curSelectTrail or 0
  end
  local theTabList = DataCenter.ActivityKillZombieManager:GetDatasWithTypeAndDifficultyLevel(1, difficultyLevel)
  self.theTabList = theTabList
  self.defaultSelectDifficulty = 0
  self.ToggleDifficultyList = {}
  local ToggleList = {}
  self.ToggleList = ToggleList
  if self.theTabList then
    for i = theTabList.min, theTabList.max do
      local data = theTabList.data[i]
      if data ~= nil then
        local openedBySeason = DataCenter.ActivityKillZombieManager:IsDifficultyOpenedBySeasonTime(1, i)
        if openedBySeason then
          local name = "item_" .. i
          goItem = self.theToggleItem:GameObjectSpawn(self.tabRoot.transform)
          goItem.name = name
          goItem:SetActive(true)
          theToggle = self.tabRoot:AddComponent(ActionRewardToggle, name)
          theToggle:ReInit(data, self)
          ToggleList[i] = theToggle
          table.insert(self.ToggleDifficultyList, i)
        end
      end
    end
    theToggle = ToggleList[kill_zombie_difficulty_select]
    self.defaultSelectDifficulty = theToggle and kill_zombie_difficulty_select or theTabList.min
    theToggle = ToggleList[self.defaultSelectDifficulty]
    if theToggle then
      theToggle:ActiveTab()
      self:SelectTab(self.defaultSelectDifficulty)
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.tabRoot.rectTransform)
  local selectIndex = table.indexof(self.ToggleDifficultyList, self.defaultSelectDifficulty) or 0
  if 3 < selectIndex then
    self.tab_list_view:SetHorizontalNormalizedPosition(selectIndex / #self.ToggleDifficultyList)
  else
    self.tab_list_view:SetHorizontalNormalizedPosition(0)
  end
  self.initEnd = true
  self.OnRefresh = Bind(self, self.Refresh)
end

function UIActivityKillZombieActionRewardView:SelectTab(difficulty)
  if not self.theTabList then
    return
  end
  local data = self.theTabList.data[difficulty]
  if not data then
    return
  end
  self.data = data
  self.tab_list_view:StopMovement()
  self.scroll_view:StopMovement()
  if self.initEnd then
    self.scroll_view:SetVerticalNormalizedPosition(1.0)
  end
  self:UpdateUI(data)
end

function UIActivityKillZombieActionRewardView:UpdateUI(data)
  local rewardListServer = data.rewardListServer
  if rewardListServer ~= nil then
    local goItem, theItem
    local levelList = rewardListServer.levelList
    local now_difficulty = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_SELECT, 0)
    local kill_zombie_data = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_ACTIVITY_PLAYER_INFO)
    local kill_count = kill_zombie_data.count or 0
    local theItemList = self.theItemList or {}
    local count = #theItemList
    local iii = 0
    local active_index = 0
    local level_count = #levelList
    local floorChallengeCount = -1
    local minChallengeCount = 0
    local minChallengeItem
    for index, needCount in ipairs(levelList) do
      local rewardStr = rewardListServer[tostring(needCount)]
      if rewardStr ~= nil and rewardStr ~= "" then
        local levelName = "level_" .. index
        theItem = theItemList[levelName]
        if theItem == nil then
          goItem = self.theCellItem:GameObjectSpawn(self.content.transform)
          goItem.name = levelName
          goItem:SetActive(true)
          theItem = self.content:AddComponent(ActionRewardItem, levelName)
          theItemList[levelName] = theItem
        end
        theItem:ReInit(needCount, data, rewardStr, self, self.theRewardItem)
        if now_difficulty == data.difficulty then
          local taskState = TaskState.NoComplete
          if needCount > kill_count then
            taskState = TaskState.NoComplete
          elseif kill_zombie_data.rewardInfo ~= nil then
            if string.contains(kill_zombie_data.rewardInfo .. ",", needCount .. ",") then
              taskState = TaskState.Received
            else
              taskState = TaskState.CanReceive
            end
          else
            taskState = TaskState.CanReceive
          end
          if taskState == TaskState.CanReceive then
            theItem.transform:SetAsFirstSibling()
          end
          if needCount <= kill_count and needCount >= floorChallengeCount then
            floorChallengeCount = needCount
          end
          if index == 1 then
            minChallengeCount = needCount
            minChallengeItem = theItem
          elseif needCount < minChallengeCount then
            minChallengeCount = needCount
            minChallengeItem = theItem
          end
        end
        iii = index
      end
    end
    if floorChallengeCount ~= -1 then
      local floorindex = table.indexof(levelList, floorChallengeCount)
      local curChallengeIndex = math.min(level_count, floorindex + 1)
      local levelName = "level_" .. curChallengeIndex
      local theItemList = self.theItemList or {}
      if theItemList[levelName] then
        theItemList[levelName]:SetIsActive()
      end
    elseif minChallengeItem then
      minChallengeItem:SetIsActive()
    end
    self.theItemList = theItemList
    if 3 <= active_index and self.initEnd ~= true then
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.transform)
      self.scroll_view:SetVerticalNormalizedPosition(1.0 - active_index / #levelList)
    end
  end
end

function UIActivityKillZombieActionRewardView:Refresh()
  if self.data then
    self:UpdateUI(self.data)
  end
end

function UIActivityKillZombieActionRewardView:OnEnable()
  base.OnEnable(self)
  self:AddUIListener(EventId.MonsterChallengeUpdate, self.OnRefresh)
end

function UIActivityKillZombieActionRewardView:OnDisable()
  self:RemoveUIListener(EventId.MonsterChallengeUpdate, self.OnRefresh)
  base.OnDisable(self)
end

function UIActivityKillZombieActionRewardView:ComponentDestroy()
  self.tabRoot:RemoveComponents(ActionRewardToggle)
  self.content:RemoveComponents(ActionRewardItem)
  self.theToggleItem:GameObjectRecycleAll()
  self.theRewardItem:GameObjectRecycleAll()
  self.theCellItem:GameObjectRecycleAll()
  for _, v in ipairs(self.tabRoot.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.theToggleItem = nil
  self.theRewardItem = nil
  self.theCellItem = nil
  self.desc = nil
  self.content = nil
  self.tabRoot = nil
  self.btnPanel = nil
  self.titleText = nil
  self.closeBtn = nil
  self.scroll_view = nil
  self.theTabList = nil
  self.defaultSelectDifficulty = 0
  self.ToggleList = nil
end

return UIActivityKillZombieActionRewardView
