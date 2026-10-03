local base = UIBaseView
local SeasonSelectLocationGameSuccessView = BaseClass("SeasonSelectLocationGameSuccessView", base)
local full_content_path = "Center/FullPassReward/FullContent"
local reward_full_item_path = "Center/FullPassReward/FullContent/rewardFullItem"
local normal_content_path = "Center/NormalPassReward/NormalContent"
local reward_item_path = "Center/NormalPassReward/NormalContent/rewardItem"
local full_pass_title_path = "Top/FullPassTitle"
local normal_pass_title_path = "Top/NormalPassTitle"
local full_pass_reward_path = "Center/FullPassReward"
local txt_level_path = "Center/NormalPassReward/txt_level"
local btn_full_path = "Buttom/BtnFull"
local btn_all_full_path = "Buttom/BtnFull/BtnAllFull"
local normal_pass_reward_path = "Center/NormalPassReward"
local txt_time_path = "Buttom/content_time/txt_time"
local txt_put_time_path = "Buttom/content_put_time/txt_put_time"

function SeasonSelectLocationGameSuccessView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:InitData()
  self:Refresh()
end

function SeasonSelectLocationGameSuccessView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonSelectLocationGameSuccessView:ComponentDefine()
  self.animator = self:AddComponent(UIAnimator, "")
  self.full_content = self:AddComponent(UIBaseContainer, full_content_path)
  self.normal_content = self:AddComponent(UIBaseContainer, normal_content_path)
  self.full_pass_title = self:AddComponent(UIBaseContainer, full_pass_title_path)
  self.normal_pass_title = self:AddComponent(UIBaseContainer, normal_pass_title_path)
  self.full_pass_reward = self:AddComponent(UIBaseContainer, full_pass_reward_path)
  self.reward_full_item = self:AddComponent(UICanvasGroup, reward_full_item_path)
  self.reward_item = self:AddComponent(UICanvasGroup, reward_item_path)
  self.txt_level = self:AddComponent(UITextMeshProUGUIEx, txt_level_path)
  self.btn_full = self:AddComponent(UIBaseContainer, btn_full_path)
  self.btn_all_full = self:AddComponent(UIButton, btn_all_full_path)
  self.normal_pass_reward = self:AddComponent(UIBaseContainer, normal_pass_reward_path)
  self.txt_time = self:AddComponent(UITextMeshProUGUIEx, txt_time_path)
  self.txt_put_time = self:AddComponent(UITextMeshProUGUIEx, txt_put_time_path)
  self.theItem_full_item = self.reward_full_item.gameObject
  self.theItem_full_item:GameObjectCreatePool()
  self.theItem_full_item:SetActive(false)
  self.theItem_normal_item = self.reward_item.gameObject
  self.theItem_normal_item:GameObjectCreatePool()
  self.theItem_normal_item:SetActive(false)
  self.btn_all_full:SetOnClick(BindCallback(self, self.OnBackClick))
end

function SeasonSelectLocationGameSuccessView:ComponentDestroy()
  self.theItem_full_item:GameObjectRecycleAll()
  self.theItem_normal_item:GameObjectRecycleAll()
  self.full_content = nil
  self.normal_content = nil
  self.full_pass_title = nil
  self.normal_pass_title = nil
  self.full_pass_reward = nil
  self.reward_full_item = nil
  self.reward_item = nil
  self.txt_level = nil
  self.theItem_full_item = nil
  self.theItem_normal_item = nil
  self.btn_full = nil
  self.btn_all_full = nil
  self.normal_pass_reward = nil
  self.animator = nil
  self.txt_time = nil
  self.txt_put_time = nil
end

function SeasonSelectLocationGameSuccessView:OnAddListener()
  self:AddUIListener(EventId.SeasonTetrisResetUpdate, self.OnResetCallback)
end

function SeasonSelectLocationGameSuccessView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonTetrisResetUpdate, self.OnResetCallback)
end

function SeasonSelectLocationGameSuccessView:InitData()
  self.WaitReset = false
end

function SeasonSelectLocationGameSuccessView:Refresh()
  self.Data = self:GetUserData()
  local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(math.ceil(self.Data.Time))
  self.txt_time:SetText(timeStr)
  self.txt_put_time:SetLocalText("zone_selection_location_UI_42", string.GetFormattedSeparatorNum(self.Data.PutTimes))
  local perfect = true
  self.animator:Play("SeasonSelectLocation")
  self.full_pass_title:SetActive(perfect)
  self.normal_pass_title:SetActive(not perfect)
  self.full_pass_reward:SetActive(perfect)
  self.btn_full:SetActive(true)
  self.normal_pass_reward:SetAnchoredPositionXY(0, perfect and -45 or 90)
  self.txt_level:SetLocalText("zone_selection_location_game_name_UI_3")
  self.theItem_full_item:GameObjectRecycleAll()
  self.theItem_normal_item:GameObjectRecycleAll()
  local gameCell = LocalController:instance():getLine(TableName.SEASON_S1_BLOCK_GAME, self.Data.CfgId)
  local targetList = string.string2table_ii_toList(gameCell.aim, "|", ";", nil)
  local targetItems = {}
  for _, pair in pairs(targetList) do
    table.insert(targetItems, {
      itemId = tostring(pair[1]),
      count = pair[2],
      rewardType = RewardType.GOODS
    })
  end
  for i, paramInfo in ipairs(targetItems) do
    local levelName = "target_item_" .. i
    local goItem = self.theItem_full_item:GameObjectSpawn(self.full_content.transform)
    goItem.name = levelName
    goItem:SetActive(true)
    local theItem = self.full_content:AddComponent(UICommonResItem, levelName)
    theItem:ReInit(paramInfo)
  end
  if DataCenter.SeasonSelectLocationGameManager:ShowClaimDailyReward() then
    self.normal_pass_reward:SetActive(true)
    local rewards = DataCenter.RewardTemplateManager:GetList(gameCell.reward)
    for i, paramInfo in ipairs(rewards) do
      local levelName = "normal_item_" .. i
      local goItem = self.theItem_normal_item:GameObjectSpawn(self.normal_content.transform)
      goItem.name = levelName
      goItem:SetActive(true)
      local theItem = self.normal_content:AddComponent(UICommonResItem, levelName)
      theItem:ReInit(paramInfo)
    end
  else
    self.normal_pass_reward:SetActive(false)
  end
end

function SeasonSelectLocationGameSuccessView:OnBackClick()
  self.ctrl:CloseSelf()
  DataCenter.SeasonTetrisManager:SendReset(false)
  EventManager:GetInstance():Broadcast(EventId.SeasonTetrisCloseGame)
end

function SeasonSelectLocationGameSuccessView:OnContinueClick()
  local canNext = not DataCenter.SeasonTetrisManager:IsAllFinished()
  if not canNext then
    return
  end
  if self.WaitReset then
    return
  end
  DataCenter.SeasonTetrisManager:SendReset(true)
  self.WaitReset = true
end

function SeasonSelectLocationGameSuccessView:OnResetCallback(evt)
  self.WaitReset = false
  self.ctrl:CloseSelf()
end

return SeasonSelectLocationGameSuccessView
