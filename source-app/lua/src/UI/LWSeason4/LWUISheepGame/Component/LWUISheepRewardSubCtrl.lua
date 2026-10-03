local base = UIBaseContainer
local LWUISheepRewardSubCtrl = BaseClass("LWUISheepRewardSubCtrl", base)
local reward_item_path = "rewardItem"
local txt_level_path = "Top/txtLevel"
local txt_diff_path = "Top/txtLevel/txt_diff"
local btn_close_path = "Top/btn_close"
local normal_content_path = "Center/NormalPassReward/NormalContent"
local perfect_content_path = "Center/PerfectPassReward/PerfectContent"
local random_content_path = "Center/RandomPassReward/RandomContent"
local normal_pass_reward_path = "Center/NormalPassReward"
local perfect_pass_reward_path = "Center/PerfectPassReward"
local random_pass_reward_path = "Center/RandomPassReward"
local DEFINE_DIFF_TEXT_IDS = {
  [1] = "season_s4_activity_1200010_desc28",
  [2] = "season_s4_activity_1200010_desc29",
  [3] = "season_s4_activity_1200010_desc30"
}

function LWUISheepRewardSubCtrl:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.itemViews = {}
end

function LWUISheepRewardSubCtrl:OnDestroy()
  self.itemViews = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUISheepRewardSubCtrl:ComponentDefine()
  self.reward_item = self:AddComponent(UIBaseContainer, reward_item_path)
  self.txt_level = self:AddComponent(UITextMeshProUGUIEx, txt_level_path)
  self.txt_diff = self:AddComponent(UITextMeshProUGUIEx, txt_diff_path)
  self.btn_close = self:AddComponent(UIButton, btn_close_path)
  self.normal_content = self:AddComponent(UIBaseContainer, normal_content_path)
  self.perfect_content = self:AddComponent(UIBaseContainer, perfect_content_path)
  self.random_content = self:AddComponent(UIBaseContainer, random_content_path)
  self.normal_pass_reward = self:AddComponent(UIBaseContainer, normal_pass_reward_path)
  self.perfect_pass_reward = self:AddComponent(UIBaseContainer, perfect_pass_reward_path)
  self.random_pass_reward = self:AddComponent(UIBaseContainer, random_pass_reward_path)
  self.btn_close:SetOnClick(BindCallback(self, self.ClickClose))
  self.go_item = self.reward_item.gameObject
  self.go_item:GameObjectCreatePool()
end

function LWUISheepRewardSubCtrl:ComponentDestroy()
  self.go_item:GameObjectRecycleAll()
  self.go_item = nil
  self.reward_item = nil
  self.txt_level = nil
  self.txt_diff = nil
  self.btn_close = nil
  self.normal_content = nil
  self.perfect_content = nil
  self.random_content = nil
  self.normal_pass_reward = nil
  self.perfect_pass_reward = nil
  self.random_pass_reward = nil
end

function LWUISheepRewardSubCtrl:OnEnable()
  base.OnEnable(self)
  self:Refresh()
end

function LWUISheepRewardSubCtrl:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CommonGetServerReward, self.CommonGetServerRewardHandle)
end

function LWUISheepRewardSubCtrl:OnRemoveListener()
  self:RemoveUIListener(EventId.CommonGetServerReward, self.CommonGetServerRewardHandle)
  base.OnRemoveListener(self)
end

function LWUISheepRewardSubCtrl:ClickClose()
  self:SetActive(false)
end

function LWUISheepRewardSubCtrl:Refresh()
  self:ReqReward()
  self:RefreshOther()
end

function LWUISheepRewardSubCtrl:ReqReward()
  if not DataCenter.LWSheepDataManager:IsPass() and not DataCenter.LWSheepDataManager:IsDayPass() then
    local blockId = DataCenter.LWSheepDataManager:GetCurBlockId()
    if blockId ~= nil then
      local normalId = tostring(GetTableData(TableName.SEASON_BLOCK_REMOVAL, blockId, "reward"))
      local perfectId = tostring(GetTableData(TableName.SEASON_BLOCK_REMOVAL, blockId, "perfect_reward"))
      self.normal_pass_reward:SetActive(not string.IsNullOrEmpty(normalId) and normalId ~= "0")
      self.perfect_pass_reward:SetActive(not string.IsNullOrEmpty(perfectId) and perfectId ~= "0")
      DataCenter.ClientRewardToServerDataManager:GetRewardByTwoId(normalId, perfectId)
    end
  end
end

function LWUISheepRewardSubCtrl:CommonGetServerRewardHandle(rewards)
  local blockId = DataCenter.LWSheepDataManager:GetCurBlockId()
  if blockId == nil then
    return
  end
  local normalId = tostring(GetTableData(TableName.SEASON_BLOCK_REMOVAL, blockId, "reward"))
  local perfectId = tostring(GetTableData(TableName.SEASON_BLOCK_REMOVAL, blockId, "perfect_reward"))
  for id, reward in pairs(rewards) do
    if id == perfectId then
      self:RefreshPerfectReward(reward)
    end
    if id == normalId then
      self:RefreshNormalReward(reward)
    end
  end
end

function LWUISheepRewardSubCtrl:RefreshNormalReward(reward)
  if 0 < #reward then
    local rewardParams = DataCenter.RewardManager:ReturnRewardParamForMessage(reward)
    for i, paramInfo in ipairs(rewardParams) do
      local goName = "normal_item" .. i
      local theItem = self.itemViews[goName]
      if theItem == nil then
        local goItem = self.go_item:GameObjectSpawn(self.normal_content.transform)
        goItem.name = goName
        theItem = self.normal_content:AddComponent(UICommonResItem, goName)
        self.itemViews[goName] = theItem
      end
      theItem:SetActive(true)
      theItem:ReInit(paramInfo)
    end
  end
end

function LWUISheepRewardSubCtrl:RefreshPerfectReward(reward)
  if 0 < #reward then
    local rewardParams = DataCenter.RewardManager:ReturnRewardParamForMessage(reward)
    for i, paramInfo in ipairs(rewardParams) do
      local goName = "prefect_item" .. i
      local theItem = self.itemViews[goName]
      if theItem == nil then
        local goItem = self.go_item:GameObjectSpawn(self.perfect_content.transform)
        goItem.name = goName
        theItem = self.perfect_content:AddComponent(UICommonResItem, goName)
        self.itemViews[goName] = theItem
      end
      theItem:SetActive(true)
      theItem:ReInit(paramInfo)
    end
  end
end

function LWUISheepRewardSubCtrl:RefreshOther()
  local level = DataCenter.LWSheepDataManager:GetCurrentLevel()
  self.txt_level:SetLocalText("season_s4_activity_1200010_desc33", level)
  local blockId = DataCenter.LWSheepDataManager:GetCurrentLevel() + 10000
  local diff = GetTableData(TableName.SEASON_BLOCK_REMOVAL, blockId, "difficulty")
  self.txt_diff:SetLocalText(DEFINE_DIFF_TEXT_IDS[diff])
  local randomTableData = GetTableData(TableName.SEASON_BLOCK_REMOVAL, blockId, "random_rewards_show")
  local randomParams = DataCenter.RewardManager:ParseRewardsStr(randomTableData)
  self.random_pass_reward:SetActive(table.count(randomParams) > 0)
  for i, paramInfo in ipairs(randomParams) do
    local goName = "random_item" .. i
    local theItem = self.itemViews[goName]
    if theItem == nil then
      local goItem = self.go_item:GameObjectSpawn(self.random_content.transform)
      goItem.name = goName
      theItem = self.random_content:AddComponent(UICommonResItem, goName)
      self.itemViews[goName] = theItem
    end
    theItem:SetActive(true)
    theItem:ReInit(paramInfo)
  end
end

return LWUISheepRewardSubCtrl
