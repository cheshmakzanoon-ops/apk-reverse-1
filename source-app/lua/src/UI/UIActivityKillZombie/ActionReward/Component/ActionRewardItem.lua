local UIActivityKillZombieActionRewardItem = BaseClass("UIActivityKillZombieActionRewardItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local bg_path = "bg"
local name_path = "name"
local items_scroll_path = "itemsScroll"
local items_path = "itemsScroll/Viewport/Content"
local active_path = "active"
local txt_path = "active/txt"
local go_btn_path = "GoBtn"
local btn_text_path = "GoBtn/BtnText"

function UIActivityKillZombieActionRewardItem:OnCreate()
  base.OnCreate(self)
  self.bgFinish = self:AddComponent(UIText, "bg_finish")
  self.name = self:AddComponent(UIText, name_path)
  self.scroll = self:AddComponent(UIScrollRect, items_scroll_path)
  self.content = self:AddComponent(UIBaseContainer, items_path)
  self.active = self:AddComponent(UIImage, active_path)
  self.txt = self:AddComponent(UIText, txt_path)
  self.txt:SetLocalText("2010214")
  self.go_btn = self:AddComponent(UIButton, go_btn_path)
  self.go_btn_img = self:AddComponent(UIImage, go_btn_path)
  self.btn_text = self:AddComponent(UIText, btn_text_path)
  self.bindingGetRewardAction = Bind(self, self.OnBtnClickGetReward)
  self.bindingGoBossAction = Bind(self, self.OnBtnClickGoToMonster)
  self.go_btn:SetOnClick(nil)
end

function UIActivityKillZombieActionRewardItem:OnDestroy()
  self.content:RemoveComponents(UICommonResItem)
  self.rewardItem:GameObjectRecycleAll()
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.bgFinish = nil
  self.name = nil
  self.scroll = nil
  self.content = nil
  self.active = nil
  self.txt = nil
  self.data = nil
  self.view = nil
  self.rewardId = nil
  self.rewardItem = nil
  base.OnDestroy(self)
end

function UIActivityKillZombieActionRewardItem:OnEnable()
  base.OnEnable(self)
  self:AddUIListener(EventId.MonsterChallengedTaskReward, self.OnTaskReward)
end

function UIActivityKillZombieActionRewardItem:OnDisable()
  self:RemoveUIListener(EventId.MonsterChallengedTaskReward, self.OnTaskReward)
  base.OnDisable(self)
end

function UIActivityKillZombieActionRewardItem:OnTaskReward(rewardInfo)
  if self.taskState == TaskState.CanReceive and rewardInfo ~= nil and string.contains(rewardInfo .. ",", self.level .. ",") then
    self.btn_text:SetLocalText("457011")
    self.go_btn:SetActive(false)
    self.bgFinish:SetActive(true)
    self.taskState = TaskState.Received
  end
end

function UIActivityKillZombieActionRewardItem:SetIsActive()
  if self.bgFinish:GetActive() then
    return
  end
  local mgr = DataCenter.ActivityListDataManager
  local difficulty_select = mgr:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_SELECT, 0)
  self.active:SetActive(self.data.difficulty == difficulty_select)
  self.bgFinish:SetActive(false)
end

function UIActivityKillZombieActionRewardItem:ReInit(maxLevel, data, rewardStr, view, rewardItem)
  self.data = data
  self.view = view
  self.level = maxLevel
  self.rewardStr = rewardStr
  self.rewardItem = rewardItem
  local goItem, theItem
  local extraRewards = DataCenter.RewardManager:ParseRewardsStr(rewardStr)
  local theItemList = self.theItemList or {}
  local count = #theItemList
  local index = 0
  if extraRewards ~= nil then
    for i, item in ipairs(extraRewards) do
      local levelName = "item_" .. i
      theItem = theItemList[i]
      if theItem == nil then
        goItem = rewardItem:GameObjectSpawn(self.content.transform)
        goItem.name = levelName
        goItem:SetActive(true)
        theItem = self.content:AddComponent(UICommonResItem, levelName)
        theItemList[i] = theItem
      end
      theItem:SetActive(true)
      theItem:ReInit(item)
      index = i
    end
    self.scroll:SetSizeDelta(Vector2(math.min(520, #extraRewards * 96 - #extraRewards), 100))
    self.scroll:StopMovement()
    self.scroll:SetHorizontalNormalizedPosition(0)
  end
  for i = index + 1, count do
    theItem = theItemList[i]
    if theItem ~= nil then
      theItem:SetActive(false)
    end
  end
  self.theItemList = theItemList
  local now_difficulty = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_SELECT, 0)
  self.active:SetActive(false)
  self.bgFinish:SetActive(false)
  self.go_btn:SetActive(now_difficulty == data.difficulty)
  if now_difficulty == data.difficulty then
    local kill_zombie_data = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_ACTIVITY_PLAYER_INFO)
    local kill_count = kill_zombie_data.count or 0
    local taskState = TaskState.NoComplete
    if maxLevel > kill_count then
      taskState = TaskState.NoComplete
    elseif kill_zombie_data.rewardInfo ~= nil then
      if string.contains(kill_zombie_data.rewardInfo .. ",", maxLevel .. ",") then
        taskState = TaskState.Received
      else
        taskState = TaskState.CanReceive
      end
    else
      taskState = TaskState.CanReceive
    end
    self.name:SetText(Localization:GetString("2010215", "<color=#f53c3d>" .. kill_count .. "</color>", maxLevel))
    local btnImgPath = ""
    if taskState == TaskState.Received then
      self.btn_text:SetLocalText("457011")
      UIGray.SetGray(self.go_btn.transform, true, false)
      self.go_btn:SetActive(false)
      self.bgFinish:SetActive(true)
      btnImgPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/tongyong_cfm_anniu_2.png"
    elseif taskState == TaskState.CanReceive then
      self.btn_text:SetLocalText("457010")
      UIGray.SetGray(self.go_btn.transform, false, true)
      self.go_btn:SetOnClick(self.bindingGetRewardAction)
      btnImgPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/tongyong_cfm_anniu_1.png"
    else
      self.btn_text:SetLocalText("challenge_zombie_btn03")
      UIGray.SetGray(self.go_btn.transform, false, true)
      self.go_btn:SetOnClick(self.bindingGoBossAction)
      btnImgPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/tongyong_cfm_anniu_5.png"
    end
    self.go_btn_img:LoadSprite(btnImgPath)
    self.taskState = taskState
  else
    self.name:SetLocalText("2010215", 0, maxLevel)
  end
end

function UIActivityKillZombieActionRewardItem:OnBtnClickGetReward()
  if self.taskState == TaskState.CanReceive then
    SFSNetwork.SendMessage(MsgDefines.KillZombieGetTaskReward, self.level)
  end
end

function UIActivityKillZombieActionRewardItem:OnBtnClickGoToMonster()
  local kill_zombie_data = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_ACTIVITY_PLAYER_INFO)
  if kill_zombie_data and kill_zombie_data.finish == 1 then
    UIUtil.ShowTipsId("2010216")
    return
  end
  DataCenter.ActivityKillZombieManager:JumpToPersonMonster()
end

return UIActivityKillZombieActionRewardItem
