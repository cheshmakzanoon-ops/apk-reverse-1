local base = UIBaseContainer
local KillZombieActivityALKirovRewardItem = BaseClass("KillZombieActivityALKirovRewardItem", base)
local Localization = CS.GameEntry.Localization
local circle_path = "Circle"
local small_bg_path = "Circle/SmallBg"
local big_bg_path = "Circle/BigBg"
local done_circle_path = "Circle/SmallBg/DoneCircle"
local done_spe_circle_path = "Circle/BigBg/DoneSpeCircle"
local root_path = "Circle/Root"
local select_path = "select"

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
  self.isSelected = nil
  self.excludeSelf = nil
end

local function OnDisable(self)
  base.OnDisable(self)
  self.isSelected = nil
  self.excludeSelf = nil
end

local function ComponentDefine(self)
  self.circle = self:AddComponent(UIButton, circle_path)
  self.circle:SetOnClick(BindCallback(self, self.OnItemClick))
  self.small_bg = self:AddComponent(UIImage, small_bg_path)
  self.big_bg = self:AddComponent(UIImage, big_bg_path)
  self.done_circle = self:AddComponent(UIImage, done_circle_path)
  self.done_spe_circle = self:AddComponent(UIImage, done_spe_circle_path)
  self.root = self:AddComponent(UIBaseContainer, root_path)
  self.select = self:AddComponent(UIImage, select_path)
  self.select:SetActive(false)
end

local function ComponentDestroy(self)
  self.circle = nil
  self.small_bg = nil
  self.big_bg = nil
  self.done_circle = nil
  self.done_spe_circle = nil
  self.root = nil
  self.select = nil
end

local function DataDefine(self)
  self.reward = nil
  self.type = nil
  self.index = nil
  self.nodeDmg = nil
  self.isReach = nil
  self.isSelected = nil
  self.excludeSelf = nil
  self:AddUIListener(EventId.ChallengeZombieProgressNodeClicked, self.ShowSelect)
end

local function DataDestroy(self)
  self.reward = nil
  self.type = nil
  self.index = nil
  self.nodeDmg = nil
  self.isReach = nil
  self.isSelected = nil
  self.excludeSelf = nil
  self:RemoveUIListener(EventId.ChallengeZombieProgressNodeClicked, self.ShowSelect)
end

local function RefreshInfo(self, maxDmg, dmg, reward, mark, progressItem, type, index, nodeDmg)
  local node
  if mark and tonumber(mark) == 0 then
    self.big_bg:SetActive(false)
    self.select.transform:Set_localScale(0.6, 0.6, 0.6)
    node = self.done_circle
  else
    self.big_bg:SetActive(true)
    self.select.transform:Set_localScale(0.8, 0.8, 0.8)
    node = self.done_spe_circle
  end
  local isReach = false
  if maxDmg then
    dmg = dmg or 0
    local value = Mathf.Clamp01(dmg / maxDmg)
    if progressItem then
      progressItem:RefreshProgress(value)
    end
    isReach = 1 <= value
    node:SetActive(isReach)
  end
  self.reward = reward
  self.type = type
  self.index = index
  self.nodeDmg = nodeDmg
  self.isReach = isReach
end

local function GetIsReach(self)
  return self.isReach
end

local function OnItemClick(self)
  self.isSelected = not self.isSelected
  self.excludeSelf = true
  if self.isSelected then
    self.select:SetActive(true)
    EventManager:GetInstance():Broadcast(EventId.ChallengeZombieProgressNodeClicked, {
      node = self.root,
      reward = self.reward,
      type = self.type,
      index = self.index,
      nodeDmg = self.nodeDmg
    })
  else
    self.select:SetActive(false)
    EventManager:GetInstance():Broadcast(EventId.ChallengeZombieProgressNodeClicked)
  end
end

local function ShowSelect(self, param)
  if self.excludeSelf then
    self.excludeSelf = false
    return
  end
  self.isSelected = param and param.index == self.index and param.type == self.type
  if self.select then
    self.select:SetActive(self.isSelected)
  end
end

KillZombieActivityALKirovRewardItem.OnCreate = OnCreate
KillZombieActivityALKirovRewardItem.OnDestroy = OnDestroy
KillZombieActivityALKirovRewardItem.OnEnable = OnEnable
KillZombieActivityALKirovRewardItem.OnDisable = OnDisable
KillZombieActivityALKirovRewardItem.ComponentDefine = ComponentDefine
KillZombieActivityALKirovRewardItem.ComponentDestroy = ComponentDestroy
KillZombieActivityALKirovRewardItem.DataDefine = DataDefine
KillZombieActivityALKirovRewardItem.DataDestroy = DataDestroy
KillZombieActivityALKirovRewardItem.RefreshInfo = RefreshInfo
KillZombieActivityALKirovRewardItem.GetIsReach = GetIsReach
KillZombieActivityALKirovRewardItem.OnItemClick = OnItemClick
KillZombieActivityALKirovRewardItem.ShowSelect = ShowSelect
return KillZombieActivityALKirovRewardItem
