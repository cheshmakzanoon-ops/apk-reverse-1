local base = UIBaseView
local LWUISheepSuccessView = BaseClass("LWUISheepSuccessView", base)
local full_content_path = "Center/FullPassReward/FullContent"
local reward_full_item_path = "Center/FullPassReward/FullContent/rewardFullItem"
local normal_content_path = "Center/NormalPassReward/NormalContent"
local reward_item_path = "Center/NormalPassReward/NormalContent/rewardItem"
local full_pass_title_path = "Top/FullPassTitle"
local normal_pass_title_path = "Top/NormalPassTitle"
local full_pass_reward_path = "Center/FullPassReward"
local txt_level_path = "Center/NormalPassReward/txt_level"
local btn_back_path = "Buttom/BtnBack"
local btn_continue_path = "Buttom/BtnContinue"
local btn_full_path = "Buttom/BtnFull"
local btn_all_full_path = "Buttom/BtnFull/BtnAllFull"
local normal_pass_reward_path = "Center/NormalPassReward"

function LWUISheepSuccessView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:Refresh()
end

function LWUISheepSuccessView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUISheepSuccessView:ComponentDefine()
  self.animator = self:AddComponent(UIAnimator, "")
  self.full_content = self:AddComponent(UIBaseContainer, full_content_path)
  self.normal_content = self:AddComponent(UIBaseContainer, normal_content_path)
  self.full_pass_title = self:AddComponent(UIBaseContainer, full_pass_title_path)
  self.normal_pass_title = self:AddComponent(UIBaseContainer, normal_pass_title_path)
  self.full_pass_reward = self:AddComponent(UIBaseContainer, full_pass_reward_path)
  self.reward_full_item = self:AddComponent(UICanvasGroup, reward_full_item_path)
  self.reward_item = self:AddComponent(UICanvasGroup, reward_item_path)
  self.txt_level = self:AddComponent(UITextMeshProUGUIEx, txt_level_path)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_continue = self:AddComponent(UIButton, btn_continue_path)
  self.btn_full = self:AddComponent(UIBaseContainer, btn_full_path)
  self.btn_all_full = self:AddComponent(UIButton, btn_all_full_path)
  self.normal_pass_reward = self:AddComponent(UIBaseContainer, normal_pass_reward_path)
  self.theItem_full_item = self.reward_full_item.gameObject
  self.theItem_full_item:GameObjectCreatePool()
  self.theItem_full_item:SetActive(false)
  self.theItem_normal_item = self.reward_item.gameObject
  self.theItem_normal_item:GameObjectCreatePool()
  self.theItem_normal_item:SetActive(false)
  self.btn_back:SetOnClick(BindCallback(self, self.OnBackClick))
  self.btn_continue:SetOnClick(BindCallback(self, self.OnContinueClick))
  self.btn_all_full:SetOnClick(BindCallback(self, self.OnBackClick))
end

function LWUISheepSuccessView:ComponentDestroy()
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
  self.btn_back = nil
  self.btn_continue = nil
  self.theItem_full_item = nil
  self.theItem_normal_item = nil
  self.btn_full = nil
  self.btn_all_full = nil
  self.normal_pass_reward = nil
  self.animator = nil
end

function LWUISheepSuccessView:OnBackClick()
  self.ctrl:CloseSelf()
  EventManager:GetInstance():Broadcast(EventId.SeasonSheepCloseGame)
end

function LWUISheepSuccessView:OnContinueClick()
  if DataCenter.LWSheepDataManager:IsEnd() then
    UIUtil.ShowTipsId(370100)
    return
  end
  self.ctrl:CloseSelf()
  self.parent:NextLevel()
end

function LWUISheepSuccessView:Refresh()
  self.parent = self:GetUserData()
  self.engine = self.parent.engine
  local rewardsInfo = self.engine:GetPassRewards()
  local perfect = rewardsInfo.perfectReward ~= nil and #rewardsInfo.perfectReward > 0
  self.animator:Play(perfect and "LWUISheepFullSuccessIn" or "LWUISheepSuccessIn")
  self.full_pass_title:SetActive(perfect)
  self.normal_pass_title:SetActive(not perfect)
  self.full_pass_reward:SetActive(perfect)
  local canNext = DataCenter.LWSheepDataManager:CanChallenge()
  self.btn_full:SetActive(not canNext)
  self.btn_back:SetActive(canNext)
  self.btn_continue:SetActive(canNext)
  self.normal_pass_reward:SetAnchoredPositionXY(0, perfect and -45 or 90)
  self.txt_level:SetLocalText("season_s4_activity_1200010_desc11", rewardsInfo.level)
  self.theItem_full_item:GameObjectRecycleAll()
  self.theItem_normal_item:GameObjectRecycleAll()
  local perfectParams = DataCenter.RewardManager:ReturnRewardParamForMessage(rewardsInfo.perfectReward)
  if perfect then
    for i, paramInfo in ipairs(perfectParams) do
      local levelName = "full_item_" .. i
      local goItem = self.theItem_full_item:GameObjectSpawn(self.full_content.transform)
      goItem.name = levelName
      goItem:SetActive(true)
      local theItem = self.full_content:AddComponent(UICommonResItem, levelName)
      theItem:ReInit(paramInfo)
    end
  end
  local rewardParams = DataCenter.RewardManager:ReturnRewardParamForMessage(rewardsInfo.reward)
  for i, paramInfo in ipairs(rewardParams) do
    local levelName = "normal_item_" .. i
    local goItem = self.theItem_normal_item:GameObjectSpawn(self.normal_content.transform)
    goItem.name = levelName
    goItem:SetActive(true)
    local theItem = self.normal_content:AddComponent(UICommonResItem, levelName)
    theItem:ReInit(paramInfo)
  end
end

return LWUISheepSuccessView
