local base = UIBaseContainer
local KillZombieActivityPersonLevel = BaseClass("KillZombieActivityPersonLevel", base)
local PersonLevelItem = require("UI.UIActivityCenterTable.Component.KillZombie.KillZombieActivityPersonLevelItem")
local PersonTip = require("UI.UIActivityCenterTable.Component.KillZombie.KillZombieActivityPersonTip")
local level_list_path = "ScrollView/Viewport/LevelList"
local level_item_path = "ScrollView/Viewport/LevelItem"
local black_mask_path = "BlackMask"
local tip_root_path = "TipRoot"

function KillZombieActivityPersonLevel:OnCreate()
  base.OnCreate(self)
  self.scroll_view = self:AddComponent(UIScrollRect, "ScrollView")
  self.content = self:AddComponent(UIBaseContainer, level_list_path)
  self.tip_root = self:AddComponent(PersonTip, tip_root_path)
  self.black_mask = self:AddComponent(UIImage, black_mask_path)
  self.theCellItem = self.transform:Find(level_item_path).gameObject
  self.theCellItem:GameObjectCreatePool()
  local goItem, theItem
  local itemList = {}
  local dataList = DataCenter.ActivityKillZombieManager:GetListByType(1)
  for difficulty = dataList.min, dataList.max do
    local levelName = "item_" .. difficulty
    local data = dataList.data[difficulty]
    if data ~= nil then
      goItem = self.theCellItem:GameObjectSpawn(self.content.transform)
      goItem.name = levelName
      goItem:SetActive(true)
      theItem = self.content:AddComponent(PersonLevelItem, levelName)
      theItem:SetData(difficulty, data, self)
      table.insert(itemList, theItem)
    end
  end
  self.itemCellList = itemList
  local kill_zombie_difficulty_select = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_SELECT, 0)
  local kill_zombie_difficulty_max = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_MAX, 0)
  if kill_zombie_difficulty_select == 0 and 3 < kill_zombie_difficulty_max then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
    self.scroll_view:SetHorizontalNormalizedPosition(kill_zombie_difficulty_max / dataList.max)
  elseif 3 < kill_zombie_difficulty_select then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
    self.scroll_view:SetHorizontalNormalizedPosition(kill_zombie_difficulty_select / dataList.max)
  else
    self.scroll_view:SetHorizontalNormalizedPosition(0)
  end
  if kill_zombie_difficulty_select == 0 then
    self.activeItem = itemList[kill_zombie_difficulty_max]
  else
    self.activeItem = itemList[kill_zombie_difficulty_select]
  end
end

function KillZombieActivityPersonLevel:OnEnable()
  base.OnEnable(self)
  local mgr = DataCenter.ActivityListDataManager
  local kill_zombie_difficulty_select = mgr:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_SELECT, 0)
  if kill_zombie_difficulty_select == 0 then
    self.black_mask:SetActive(true)
    self:AddTimer(0.7)
    self.scroll_view:AddValueChangeListener(function(vec)
      self:OnScrollValueChange(vec)
    end)
  else
    self.tip_root:SetActive(false)
    self.black_mask:SetActive(false)
    self.activeItem:UpdateTipArrow(false)
  end
end

function KillZombieActivityPersonLevel:OnScrollValueChange(vec)
  if self.timer == nil and (self.lastVec == nil or math.abs(vec.x - self.lastVec.x) > 0.01) then
    self.tip_root:SetAlpha(0)
    self.activeItem:UpdateTipArrow(false)
    self.lastVec = vec
  end
end

function KillZombieActivityPersonLevel:UpdateDifficultyTips()
  local mgr = DataCenter.ActivityListDataManager
  local kill_zombie_difficulty_max = mgr:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_MAX, 0)
  local kill_zombie_difficulty_select = mgr:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_SELECT, 0)
  if kill_zombie_difficulty_select == 0 then
    self.tip_root:SetAlpha(0)
    self.tip_root:SetActive(true)
    self.tip_root:FadeIn(0.3, kill_zombie_difficulty_max, self.activeItem)
  else
    self.scroll_view:RemoveAllListeners()
    self.tip_root:SetActive(false)
    self.black_mask:SetActive(false)
    self.activeItem:UpdateTipArrow(false)
  end
end

function KillZombieActivityPersonLevel:OnDisable()
  self.scroll_view:RemoveAllListeners()
  self:DeleteTimer()
  base.OnDisable(self)
end

function KillZombieActivityPersonLevel:SetData(data)
  self.theData = data
  self.tip_root:SetData(data)
end

function KillZombieActivityPersonLevel:ShowTips(index, item)
  self:DeleteTimer()
  self.tip_root:SetActive(true)
  self.tip_root:FadeIn(0, index, item)
end

function KillZombieActivityPersonLevel:OnSelectItem(index, item)
  if self.activeIndex == index and self.activeItem == item then
    return
  end
  for i, cell in ipairs(self.itemCellList) do
    cell:UpdateSelectStatus(index == i, index)
  end
  self.activeIndex = index
  self.activeItem = item
  self:ShowTips(self.activeIndex, self.activeItem)
end

function KillZombieActivityPersonLevel:OnDestroy()
  self.theCellItem:GameObjectRecycleAll()
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.scroll_view:RemoveAllListeners()
  self:DeleteTimer()
  self.timer = nil
  self.theCellItem = nil
  self.content = nil
  self.scroll_view = nil
  self.tip_root = nil
  self.black_mask = nil
  base.OnDestroy(self)
end

function KillZombieActivityPersonLevel:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function KillZombieActivityPersonLevel:AddTimer(time)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(time, self.TimeCallBack, self, true, false, false)
  end
  self.timer:Start()
end

function KillZombieActivityPersonLevel:TimeCallBack()
  self:DeleteTimer()
  if self.activeIndex == nil then
    self:UpdateDifficultyTips()
  else
    if self.activeItem ~= nil then
      self:ShowTips(self.activeIndex, self.activeItem)
    else
    end
  end
end

function KillZombieActivityPersonLevel:UpdateData()
  local mgr = DataCenter.ActivityListDataManager
  local kill_zombie_difficulty_select = mgr:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_SELECT, 0)
  if 1 <= kill_zombie_difficulty_select then
    self.tip_root:SetActive(false)
    self.black_mask:SetActive(false)
    self.activeItem:UpdateTipArrow(false)
    self.scroll_view:RemoveAllListeners()
    self:DeleteTimer()
  end
end

function KillZombieActivityPersonLevel:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshActivityDetailData, self.UpdateData)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.UpdateData)
end

function KillZombieActivityPersonLevel:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshActivityDetailData, self.UpdateData)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.UpdateData)
  base.OnRemoveListener(self)
end

return KillZombieActivityPersonLevel
