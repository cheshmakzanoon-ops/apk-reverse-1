local base = UIBaseContainer
local KillZombieActivityALLevelItem = BaseClass("KillZombieActivityALLevelItem", base)
local Localization = CS.GameEntry.Localization
local bg_path = "bg"
local icon_path = "icon"
local attack_bg_path = "attack_bg"
local attack_path = "attack_bg/attack"
local level_desc_path = "name_bg/level_desc"
local level_lv_path = "level_bg/level_lv"
local select_frame_path = "SelectFrame"
local red_point_path = "RedPoint"
local gray_img_path = "Gray"

function KillZombieActivityALLevelItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.attack_bg = self:AddComponent(UIImage, attack_bg_path)
  self.attack = self:AddComponent(UIText, attack_path)
  self.level_desc = self:AddComponent(UIText, level_desc_path)
  self.level_lv = self:AddComponent(UIText, level_lv_path)
  self.select_frame = self:AddComponent(UIImage, select_frame_path)
  self.gray_img = self:AddComponent(UIImage, gray_img_path)
  self.grayMaterial = self.gray_img:GetMaterial()
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.red_point = self:AddComponent(UIImage, red_point_path)
  self.red_point:SetActive(false)
  self.attack:SetLocalText("2010217")
end

function KillZombieActivityALLevelItem:SetOnClick(onClickCallBack)
  self.onClickCallBack = onClickCallBack
end

function KillZombieActivityALLevelItem:OnBtnClick()
  if self.onClickCallBack then
    self.onClickCallBack(self.difficulty)
  end
end

function KillZombieActivityALLevelItem:UpdateSelectStatus(select)
  self.select_frame:SetActive(select)
end

function KillZombieActivityALLevelItem:SetData(difficulty, dataConfig)
  self.difficulty = difficulty
  self.theDataConfig = dataConfig
  self.select_frame:SetActive(false)
  self.level_desc:SetText(Localization:GetString(dataConfig.firstMonster.name))
  self.realDifficulyInLevel = DataCenter.ActivityKillZombieManager.GetRelDifficultyInLevel(difficulty)
  self.level_lv:SetText("Lv." .. self.realDifficulyInLevel)
  self:UpdateData()
end

function KillZombieActivityALLevelItem:GetCurDifficulty()
  return self.difficulty
end

function KillZombieActivityALLevelItem:OnDestroy()
  self.bg = nil
  self.icon = nil
  self.attack_bg = nil
  self.attack = nil
  self.level_desc = nil
  self.level_lv = nil
  self.select_frame = nil
  self.onClickCallBack = nil
  base.OnDestroy(self)
end

function KillZombieActivityALLevelItem:UpdateData()
  local kill_zombie_AL = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_ACTIVITY_AL_INFO)
  if kill_zombie_AL == nil then
    self.red_point:SetActive(false)
    self.attack_bg:SetActive(false)
    return
  end
  local dataStatus = kill_zombie_AL[tostring(self.difficulty)]
  self.icon:SetMaterial(nil)
  if dataStatus ~= nil then
    if dataStatus.status == 0 then
      if dataStatus.monster ~= nil then
        self.red_point:SetActive(false)
        self.attack_bg:SetActive(true)
        self.attack:SetLocalText("2010217")
        return
      end
    elseif dataStatus.status == 1 then
      self.red_point:SetActive(false)
      self.attack_bg:SetActive(true)
      self.attack:SetLocalText("170009")
      return
    elseif dataStatus.status == 2 then
      self.red_point:SetActive(false)
      self.attack_bg:SetActive(true)
      self.attack:SetLocalText("170008")
      self.icon:SetMaterial(self.grayMaterial)
      return
    end
  end
  self.red_point:SetActive(DataCenter.ActivityKillZombieManager:CanInvokeBossZombie(self.difficulty) and DataCenter.AllianceBaseDataManager:IsR4orR5())
  self.attack_bg:SetActive(false)
end

function KillZombieActivityALLevelItem:OnAddListener()
  base.OnAddListener(self)
end

function KillZombieActivityALLevelItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

return KillZombieActivityALLevelItem
