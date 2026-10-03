local base = UIBaseView
local UILWGGGoPveResultView = BaseClass("UILWGGGoPveResultView", base)
local btn_back_path = "Buttom/BtnBack"
local btn_continue_path = "Buttom/BtnContinue"
local btn_full_path = "Buttom/BtnFull"
local btn_all_full_path = "Buttom/BtnFull/BtnAllFull"
local txt_level_path = "Center/txt_level"
local txt_time_path = "Center/txt_time"
local content_path = "Center/content"
local reward_item_path = "Center/content/rewardItem"

function UILWGGGoPveResultView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.battleResult = self:GetUserData()
  self:Refresh()
  DataCenter.LWSoundManager:PlaySound(6100036, false)
end

function UILWGGGoPveResultView:OnDestroy()
  if self.battleResult then
    self.battleResult.boot:Exit()
    self.battleResult = nil
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWGGGoPveResultView:ComponentDefine()
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_continue = self:AddComponent(UIButton, btn_continue_path)
  self.btn_full = self:AddComponent(UIBaseContainer, btn_full_path)
  self.btn_all_full = self:AddComponent(UIButton, btn_all_full_path)
  self.txt_level = self:AddComponent(UITextMeshProUGUIEx, txt_level_path)
  self.txt_time = self:AddComponent(UITextMeshProUGUIEx, txt_time_path)
  self.reward_item = self:AddComponent(UICanvasGroup, reward_item_path)
  self.content = self:AddComponent(UICanvasGroup, content_path)
  self.theItem_normal_item = self.reward_item.gameObject
  self.theItem_normal_item:GameObjectCreatePool()
  self.theItem_normal_item:SetActive(false)
  self.btn_back:SetOnClick(BindCallback(self, self.OnBackClick))
  self.btn_continue:SetOnClick(BindCallback(self, self.OnContinueClick))
  self.btn_all_full:SetOnClick(BindCallback(self, self.OnBackClick))
end

function UILWGGGoPveResultView:ComponentDestroy()
  self.theItem_normal_item:GameObjectRecycleAll()
  self.theItem_normal_item = nil
  self.reward_item = nil
  self.content = nil
  self.btn_back = nil
  self.btn_continue = nil
  self.btn_full = nil
  self.btn_all_full = nil
  self.txt_level = nil
  self.txt_time = nil
end

function UILWGGGoPveResultView:SeasonGGGoPveEndHandle(msg)
  self:RefreshReward(msg)
end

function UILWGGGoPveResultView:OnBackClick()
  self.ctrl:CloseSelf()
end

function UILWGGGoPveResultView:OnContinueClick()
  self.battleResult.boot:Next()
  self.battleResult = nil
  self.ctrl:CloseSelf()
end

function UILWGGGoPveResultView:Refresh()
  local canNext = DataCenter.LWGGGoDataManager:CanChallenge()
  self.btn_full:SetActive(not canNext)
  self.btn_back:SetActive(canNext)
  self.btn_continue:SetActive(canNext)
  self.txt_level:SetLocalText("season_s4_activity_1200010_desc11", self.battleResult.level)
  local timeStr = string.format("%.3f", (self.battleResult.battleTimeMills or 0) / 1000)
  self.txt_time:SetLocalText("s6_miniGame_time_limit", timeStr)
  self:RefreshReward()
end

function UILWGGGoPveResultView:RefreshReward()
  self.theItem_normal_item:GameObjectRecycleAll()
  local validation = self.battleResult.validation
  if validation.code ~= 0 then
    return
  end
  if validation.reward == nil then
    return
  end
  local rewardParams = DataCenter.RewardManager:ReturnRewardParamForMessage(validation.reward)
  for i, paramInfo in ipairs(rewardParams) do
    local levelName = "normal_item_" .. i
    local goItem = self.theItem_normal_item:GameObjectSpawn(self.content.transform)
    goItem.name = levelName
    goItem:SetActive(true)
    local theItem = self.content:AddComponent(UICommonResItem, levelName)
    theItem:ReInit(paramInfo)
  end
end

return UILWGGGoPveResultView
