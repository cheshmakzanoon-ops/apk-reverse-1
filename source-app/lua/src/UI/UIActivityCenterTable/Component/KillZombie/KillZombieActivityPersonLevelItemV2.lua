local base = UIBaseContainer
local KillZombieActivityPersonLevelItemV2 = BaseClass("KillZombieActivityPersonLevelItemV2", base)
local Localization = CS.GameEntry.Localization
local bg_path = "bg"
local icon_path = "icon"
local level_lv_path = "name"
local lock_icon_path = "LockIcon"
local lock_gray_mask_path = "GrayMask"
local select_frame_path = "SelectFrame"
local arrow_path = "arrow"
local star6_path = "star6"
local star_1_path = "star6/1"
local star_2_path = "star6/2"
local star_3_path = "star6/3"
local star_4_path = "star6/4"
local star_5_path = "star6/5"
local star_6_path = "star6/6"
local star7_path = "star7"
local star7_gray_path = "star7Gray"
local star7_gray_num_path = "star7Gray/star7GrayNum"
local star7_num_path = "star7/star7Num"
local star7_img_path = "star7/star"

function KillZombieActivityPersonLevelItemV2:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.level_lv = self:AddComponent(UIText, level_lv_path)
  self.lock_icon = self:AddComponent(UIImage, lock_icon_path)
  self.gray_mask = self:AddComponent(UIImage, lock_gray_mask_path)
  self.select_frame = self:AddComponent(UIImage, select_frame_path)
  self.btn = self:AddComponent(UIToggle, "")
  self.btn:SetIsOnWithoutNotify(false)
  self.btn:SetOnValueChanged(function(tf)
    self:OnItemSelect(tf)
  end)
  self.arrow = self:AddComponent(UIImage, arrow_path)
  self.star6 = self:AddComponent(UIBaseContainer, star6_path)
  self.star_1 = self:AddComponent(UIImage, star_1_path)
  self.star_2 = self:AddComponent(UIImage, star_2_path)
  self.star_3 = self:AddComponent(UIImage, star_3_path)
  self.star_4 = self:AddComponent(UIImage, star_4_path)
  self.star_5 = self:AddComponent(UIImage, star_5_path)
  self.star_6 = self:AddComponent(UIImage, star_6_path)
  self.star7 = self:AddComponent(UIBaseContainer, star7_path)
  self.star7_gray = self:AddComponent(UIBaseContainer, star7_gray_path)
  self.star7_gray_num = self:AddComponent(UIText, star7_gray_num_path)
  self.star7_num = self:AddComponent(UIText, star7_num_path)
  self.star_7_img = self:AddComponent(UIImage, star7_img_path)
  self.lock_icon:SetActive(false)
  self.gray_mask:SetActive(false)
  self.select_frame:SetActive(false)
  self.star7:SetActive(true)
  self.star6:SetActive(false)
  self.star7_gray:SetActive(false)
  self.level_lv:SetLocalText("challenge_zombie_005")
  self.isLocked = true
  self.difficultyLevel = nil
end

function KillZombieActivityPersonLevelItemV2:OnItemSelect(selected)
  if selected then
    if not self.isLocked then
      Logger.LogInfo("[KillZombie] OnItemSelect --- selected index = " .. self.theIndex)
      local mod = self.theData.relDifficultyInLevel % 3
      if mod == 0 then
        self.tip_root:ShowUI(self.theIndex, self, -145, self.difficultyLevel)
      elseif mod == 1 then
        self.tip_root:ShowUI(self.theIndex, self, 145, self.difficultyLevel)
      elseif mod == 2 then
        self.tip_root:ShowUI(self.theIndex, self, 0, self.difficultyLevel)
      end
      self.theView.scroll:StopMovement()
      self.tip_root.transform.position = self.transform.position
      self.tip_root:SetActive(true)
      self.select_frame:SetActive(true)
    else
      if self.theData.difficulty > DataCenter.ActivityKillZombieManager.maxOpenLevel then
        UIUtil.ShowTipsId("challenge_zombie_advanced_not_available")
        return
      end
      UIUtil.ShowTips(Localization:GetString("challenge_zombie_009"))
      self.btn:SetIsOnWithoutNotify(false)
    end
  else
    self.select_frame:SetActive(false)
    self.tip_root:SetActive(false)
  end
end

function KillZombieActivityPersonLevelItemV2:PerformClick()
  self.btn:SetIsOn(true)
end

function KillZombieActivityPersonLevelItemV2:SetLocked(locked)
  self.isLocked = locked
  self.lock_icon:SetActive(locked)
  self.gray_mask:SetActive(locked)
end

function KillZombieActivityPersonLevelItemV2:IsLocked()
  return self.isLocked
end

function KillZombieActivityPersonLevelItemV2:SetData(index, data, view, maxIndex, tip_root_v2, difficultyLevel)
  self.theIndex = index
  self.theData = data
  self.theView = view
  self.tip_root = tip_root_v2
  self.difficultyLevel = difficultyLevel
  Logger.LogInfo("[KillZombie] SetData --- index = " .. self.theIndex .. ", difficulty = " .. (self.theData and self.theData.difficulty or 0))
  local realDifficultyInLevel = data.relDifficultyInLevel
  self.star7_num:SetText("x " .. realDifficultyInLevel)
  if data.difficultyLevel == 0 then
    self.icon:LoadSprite(string.format("Assets/Main/Sprites/UI/UIActivityKillZombie/FX_jiangjunshilian_huizhang1-%d.png", realDifficultyInLevel))
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIActivityKillZombie/FX_jiangjunshilian_banzi2.png")
    self.star_7_img:LoadSprite("Assets/Main/Sprites/UI/UIActivityKillZombie/zyf_nanduxuanze_star.png")
  elseif data.difficultyLevel == 1 then
    self.icon:LoadSprite(string.format("Assets/Main/Sprites/UI/UIActivityKillZombie/FX_jiangjunshilian_huizhang2-%d.png", realDifficultyInLevel))
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIActivityKillZombie/FX_jiangjunshilian_banzi.png")
    self.star_7_img:LoadSprite("Assets/Main/Sprites/UI/UIActivityKillZombie/FX_jiangjunshilian_xingxing.png")
  end
  self.arrow:SetActive(realDifficultyInLevel % 3 ~= 0 and index < maxIndex)
end

function KillZombieActivityPersonLevelItemV2:OnDestroy()
  self.bg = nil
  self.icon = nil
  self.level_lv = nil
  self.lock_icon = nil
  self.select_frame = nil
  self.tip_root = nil
  self.difficultyLevel = nil
  base.OnDestroy(self)
end

function KillZombieActivityPersonLevelItemV2:UpdateData()
  local user_difficulty_select = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_SELECT, 0)
  if 0 < user_difficulty_select then
    self.tip_root:SetActive(false)
  end
end

function KillZombieActivityPersonLevelItemV2:UpdateTipArrow(active)
end

function KillZombieActivityPersonLevelItemV2:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshActivityDetailData, self.UpdateData)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.UpdateData)
end

function KillZombieActivityPersonLevelItemV2:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshActivityDetailData, self.UpdateData)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.UpdateData)
  base.OnRemoveListener(self)
end

return KillZombieActivityPersonLevelItemV2
