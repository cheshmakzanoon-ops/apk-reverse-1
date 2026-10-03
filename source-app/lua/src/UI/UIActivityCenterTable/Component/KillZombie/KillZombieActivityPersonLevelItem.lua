local base = UIBaseContainer
local KillZombieActivityPersonLevelItem = BaseClass("KillZombieActivityPersonLevelItem", base)
local Localization = CS.GameEntry.Localization
local bg_path = "bg"
local icon_path = "icon"
local attack_bg_path = "attack_bg"
local level_desc_path = "name_bg/level_desc"
local level_lv_path = "level_bg/level_lv"
local lock_icon_path = "LockIcon"
local select_frame_path = "SelectFrame"
local tip_root_path = "SelectFrame/TipRoot"

function KillZombieActivityPersonLevelItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.attack_bg = self:AddComponent(UIImage, attack_bg_path)
  self.level_desc = self:AddComponent(UIText, level_desc_path)
  self.level_lv = self:AddComponent(UIText, level_lv_path)
  self.lock_icon = self:AddComponent(UIImage, lock_icon_path)
  self.tip_root = self:AddComponent(UIBaseContainer, tip_root_path)
  self.select_frame = self:AddComponent(UIImage, select_frame_path)
  self.tip_root:SetActive(false)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function KillZombieActivityPersonLevelItem:OnBtnClick()
  local mgr = DataCenter.ActivityListDataManager
  local kill_zombie_difficulty_select = mgr:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_SELECT, 0)
  local kill_zombie_difficulty_max = mgr:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_MAX, 0)
  if kill_zombie_difficulty_max >= self.theIndex then
    if kill_zombie_difficulty_select == 0 then
      if self.select_frame:GetActive() then
        self.theView:ShowTips(self.theIndex, self)
        return
      end
      self.theView:OnSelectItem(self.theIndex, self)
    else
    end
  elseif self.theIndex > 1 then
    UIUtil.ShowTips(Localization:GetString("2010232", self.theIndex - 1))
  end
end

function KillZombieActivityPersonLevelItem:UpdateSelectStatus(select, index)
  self.select_frame:SetActive(select)
  self.tip_root:SetActive(select)
  self.attack_bg:SetActive(false)
end

function KillZombieActivityPersonLevelItem:SetData(index, data, view)
  local mgr = DataCenter.ActivityListDataManager
  local kill_zombie_difficulty_select = mgr:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_SELECT, 0)
  local kill_zombie_difficulty_max = mgr:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_MAX, 0)
  local monster = data.firstMonster
  local monsterName = Localization:GetString(monster.name)
  self.theIndex = index
  self.theData = data
  self.theView = view
  self.level_desc:SetText(monsterName)
  self.level_lv:SetText("Lv." .. index)
  if index <= kill_zombie_difficulty_max then
    self.lock_icon:SetActive(false)
    CS.UIGray.SetGray(self.bg.transform, false, false)
    CS.UIGray.SetGray(self.icon.transform, false, false)
  else
    self.lock_icon:SetActive(true)
    CS.UIGray.SetGray(self.bg.transform, true, false)
    CS.UIGray.SetGray(self.icon.transform, true, false)
  end
  if kill_zombie_difficulty_select == 0 then
    self.attack_bg:SetActive(false)
    self.select_frame:SetActive(index == kill_zombie_difficulty_max)
  else
    self.attack_bg:SetActive(index == kill_zombie_difficulty_select)
    self.select_frame:SetActive(index == kill_zombie_difficulty_select)
  end
end

function KillZombieActivityPersonLevelItem:UpdateTipArrow(active)
  self.tip_root:SetActive(active)
end

function KillZombieActivityPersonLevelItem:OnDestroy()
  self.bg = nil
  self.icon = nil
  self.attack_bg = nil
  self.level_desc = nil
  self.level_lv = nil
  self.lock_icon = nil
  self.select_frame = nil
  self.tip_root = nil
  base.OnDestroy(self)
end

function KillZombieActivityPersonLevelItem:UpdateData()
  local user_difficulty_select = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_SELECT, 0)
  if 0 < user_difficulty_select then
    self.tip_root:SetActive(false)
  end
end

function KillZombieActivityPersonLevelItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshActivityDetailData, self.UpdateData)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.UpdateData)
end

function KillZombieActivityPersonLevelItem:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshActivityDetailData, self.UpdateData)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.UpdateData)
  base.OnRemoveListener(self)
end

return KillZombieActivityPersonLevelItem
