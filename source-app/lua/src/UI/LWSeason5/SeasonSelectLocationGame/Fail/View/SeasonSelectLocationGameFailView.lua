local base = UIBaseView
local SeasonSelectLocationGameFailView = BaseClass("SeasonSelectLocationGameFailView", base)
local btn_back_path = "Buttom/BtnBack"
local normal_pass_reward_path = "Center/NormalPassReward"
local normal_content_path = "Center/NormalPassReward/NormalContent"
local reward_item_path = "Center/NormalPassReward/NormalContent/rewardItem"
local txt_level_path = "Center/NormalPassReward/txt_level"

function SeasonSelectLocationGameFailView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:InitData()
  self:InitUi()
end

function SeasonSelectLocationGameFailView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonSelectLocationGameFailView:ComponentDefine()
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self, self.OnBackClick))
  self.normal_pass_reward = self:AddComponent(UIBaseContainer, normal_pass_reward_path)
  self.normal_content = self:AddComponent(UIBaseContainer, normal_content_path)
  self.reward_item = self:AddComponent(UICanvasGroup, reward_item_path)
  self.txt_level = self:AddComponent(UITextMeshProUGUIEx, txt_level_path)
  self.theItem_normal_item = self.reward_item.gameObject
  self.theItem_normal_item:GameObjectCreatePool()
  self.theItem_normal_item:SetActive(false)
end

function SeasonSelectLocationGameFailView:ComponentDestroy()
  self.theItem_normal_item:GameObjectRecycleAll()
  self.btn_back = nil
  self.normal_pass_reward = nil
  self.normal_content = nil
  self.reward_item = nil
  self.txt_level = nil
end

function SeasonSelectLocationGameFailView:OnAddListener()
  self:AddUIListener(EventId.SeasonTetrisResetUpdate, self.OnResetCallback)
end

function SeasonSelectLocationGameFailView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonTetrisResetUpdate, self.OnResetCallback)
end

function SeasonSelectLocationGameFailView:InitData()
  self.WaitReset = false
  self.Data = self:GetUserData()
  if self.Data ~= nil and self.Data.CfgId ~= nil then
    self.GameCell = LocalController:instance():getLine(TableName.SEASON_S1_BLOCK_GAME, self.Data.CfgId)
  end
end

function SeasonSelectLocationGameFailView:InitUi()
  self.txt_level:SetLocalText("zone_selection_location_game_name_UI_3")
  self.theItem_normal_item:GameObjectRecycleAll()
  local curIndex = DataCenter.SeasonTetrisManager:GetCurLevelIndex()
  local showReward = curIndex == 2
  if showReward and self.GameCell ~= nil then
    self.normal_pass_reward:SetActive(true)
    local rewards = DataCenter.RewardTemplateManager:GetList(self.GameCell.reward)
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

function SeasonSelectLocationGameFailView:OnBackClick()
  self.ctrl:CloseSelf()
  DataCenter.SeasonTetrisManager:SendReset(false)
  EventManager:GetInstance():Broadcast(EventId.SeasonTetrisCloseGame)
end

function SeasonSelectLocationGameFailView:OnAgainClick()
  if self.WaitReset then
    return
  end
  DataCenter.SeasonTetrisManager:SendReset(true)
  self.WaitReset = true
end

function SeasonSelectLocationGameFailView:OnResetCallback(evt)
  self.WaitReset = false
  self.ctrl:CloseSelf()
end

return SeasonSelectLocationGameFailView
