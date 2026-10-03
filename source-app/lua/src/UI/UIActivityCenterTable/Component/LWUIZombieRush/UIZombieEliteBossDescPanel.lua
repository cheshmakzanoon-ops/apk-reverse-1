local UIZombieEliteBossDescPanel = BaseClass("UIZombieEliteBossDescPanel", UIBaseContainer)
local UIZombieEliteBossRewardRateItem = require("UI.UIActivityCenterTable.Component.LWUIZombieRush.UIZombieEliteBossRewardRateItem")
local base = UIBaseContainer
local click_path = "OpenContent/Click"
local altered_group_path = "OpenContent/AlteredGroup"
local click_root_path = "OpenContent/AlteredGroup/IconRoot/ClickRoot"
local altered_rate_text_path = "OpenContent/AlteredGroup/AlteredRateText"
local normal_icon_path = "OpenContent/AlteredGroup/IconRoot/ClickRoot/NormalIcon"
local altered_icon_path = "OpenContent/AlteredGroup/IconRoot/ClickRoot/AlteredIcon"
local boss_icon_path = "OpenContent/BossIcon"
local altered_boss_icon_path = "OpenContent/AlteredBossIcon"
local boss_pic_new_path = "OpenContent/ContentRoot/BossPicRoot/BossPic_new"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.textActivityTitle = self:AddComponent(UIText, "OpenContent/ActivityTitleText")
  self.textActivityTitle:SetLocalText("zombierush_eliteBoss_title")
  self.textActivityTitle:SetActive(false)
  self.textBossName = self:AddComponent(UIText, "OpenContent/ContentRoot/BossNameText")
  self.imgBossPic = self:AddComponent(UIImage, "OpenContent/ContentRoot/BossPicRoot/BossPic")
  self.textDesc = self:AddComponent(UIText, "OpenContent/ContentRoot/DescText")
  self.ScrollView = self:AddComponent(UIScrollView, "OpenContent/ContentRoot/RewardRoot/Scroll")
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
  self.compContent = self:AddComponent(UIBaseContainer, "OpenContent/ContentRoot/RewardRoot/Scroll/Viewport/Content")
  self.textRewardTips = self:AddComponent(UIText, "OpenContent/ContentRoot/RewardRoot/RewardTipsText")
  self.textRewardTips:SetLocalText("zombierush_eliteBoss_reward")
  self.click = self:AddComponent(UIButton, click_path)
  self.click:SetOnClick(BindCallback(self, self.OnCloseClick))
  self.root = self:AddComponent(UIBaseContainer, "")
  self.altered_group = self:AddComponent(UIBaseContainer, altered_group_path)
  self.click_root = self:AddComponent(UIButton, click_root_path)
  self.click_root:SetOnClick(BindCallback(self, self.OnAlteredClick))
  self.altered_rate_text = self:AddComponent(UITextMeshProUGUIEx, altered_rate_text_path)
  self.normal_icon = self:AddComponent(UIBaseContainer, normal_icon_path)
  self.altered_icon = self:AddComponent(UIBaseContainer, altered_icon_path)
  self.boss_icon = self:AddComponent(UIBaseContainer, boss_icon_path)
  self.altered_boss_icon = self:AddComponent(UIBaseContainer, altered_boss_icon_path)
  self.animator = self:AddComponent(UIAnimator, "")
  self.boss_pic_new = self:AddComponent(UIImage, boss_pic_new_path)
end

local function ComponentDestroy(self)
  self.textActivityTitle = nil
  self.textBossName = nil
  self.imgBossPic = nil
  self.textDesc = nil
  self.ScrollView = nil
  self.compContent = nil
  self.textRewardTips = nil
  self.click = nil
  self.root = nil
  self.altered_group = nil
  self.click_root = nil
  self.altered_rate_text = nil
  self.normal_icon = nil
  self.altered_icon = nil
  self.boss_icon = nil
  self.altered_boss_icon = nil
  self.animator = nil
  self.boss_pic_new = nil
end

local function DataDefine(self)
  self.id = nil
  self.template = nil
  self.showEliteBoss = true
  self.eliteMonsterId = nil
  self.alteredMonsterId = nil
  self.eliteDropId = nil
  self.alteredDropId = nil
  self.eliteBossPercentValue = nil
  self.eliteBossAtkNumValue = nil
  self.alteredBossPercentValue = nil
  self.alteredBossAtkNumValue = nil
end

local function DataDestroy(self)
  self.id = nil
  self.template = nil
  self.showEliteBoss = nil
  self.eliteMonsterId = nil
  self.alteredMonsterId = nil
  self.eliteDropId = nil
  self.alteredDropId = nil
  self.eliteBossPercentValue = nil
  self.eliteBossAtkNumValue = nil
  self.alteredBossPercentValue = nil
  self.alteredBossAtkNumValue = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self, template)
  if template then
    if self.id == template.id then
      return
    end
    self.id = template.id
    self.template = template
    self:SetCurSeasonEliteMonsterId(template.eliteBoss_show)
    self:SetCurSeasonEliteDropId(template.eliteBoss_reward_show)
    self:SetCurEliteBossTipsData(template.eliteBoss_target)
    self:SetCurAlteredBossTipsData(template.alter_rate)
    self:RefreshMonsterInfo(template)
  end
end

local function RefreshMonsterInfo(self)
  local monsterId, dropId, btnDlogId, descDlogId
  local percent, num = 0, 0
  if self.showEliteBoss then
    monsterId = self.eliteMonsterId
    dropId = self.eliteDropId
    btnDlogId = "zombierush_eliteBoss_infoBtn_normal"
    descDlogId = "zombierush_eliteBoss_rule_normal"
    percent = self.eliteBossPercentValue
    num = self.eliteBossAtkNumValue
    self.imgBossPic:SetAlpha(1)
    self.boss_pic_new:SetAlpha(0)
  else
    monsterId = self.alteredMonsterId
    dropId = self.alteredDropId
    btnDlogId = "zombierush_eliteBoss_infoBtn_alter"
    descDlogId = "zombierush_eliteBoss_rule_alter"
    percent = self.alteredBossPercentValue
    num = self.alteredBossAtkNumValue
    self.imgBossPic:SetAlpha(0)
    self.boss_pic_new:SetAlpha(1)
  end
  if monsterId and 0 < monsterId then
    local name = GetTableData(TableName.Monster, monsterId, "name")
    self.textBossName:SetLocalText(name)
  end
  local pic1 = GetTableData(TableName.Monster, self.eliteMonsterId, "pic_name")
  local pic2 = GetTableData(TableName.Monster, self.alteredMonsterId, "pic_name")
  self.imgBossPic:LoadSpriteAuto(UIUtil.GetFullPath(LoadPath.HeroIconsBigPath, pic1))
  self.boss_pic_new:LoadSpriteAuto(UIUtil.GetFullPath(LoadPath.HeroIconsBigPath, pic2))
  self:RefreshRewardList(dropId)
  self.altered_rate_text:SetLocalText(btnDlogId)
  local perStr = string.format("%.0f", percent / 100)
  self.textDesc:SetLocalText(descDlogId, perStr, num)
  self.normal_icon:SetActive(not self.showEliteBoss)
  self.boss_icon:SetActive(self.showEliteBoss)
  self.altered_icon:SetActive(self.showEliteBoss)
  self.altered_boss_icon:SetActive(not self.showEliteBoss)
end

local function OnCloseClick(self)
  self:SetPanelShow(false)
end

local function SetPanelShow(self, active)
  self.root:SetActive(active)
  if active then
    self:PlayAnimation("LWUIZombieEliteBossDescMovieIn")
  end
end

local function RefreshRewardList(self, dropId)
  if dropId and 0 < dropId then
    self:ClearScroll()
    local rewardData = GetTableData(TableName.DropInfoDetail, dropId, "dropInfoDetail")
    if string.IsNullOrEmpty(rewardData) then
      return
    end
    self.dropList = string.split(rewardData, "|")
    if self.dropList and 0 < #self.dropList then
      self.ScrollView:SetTotalCount(#self.dropList)
      self.ScrollView:RefillCells()
    end
  end
end

local function OnRewardItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(UIZombieEliteBossRewardRateItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(self.dropList[index])
    self.cellCache[index] = cellItem
  end
end

local function OnRewardItemMoveOut(self, itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, UIZombieEliteBossRewardRateItem)
  self.cellCache[index] = nil
end

local function ClearScroll(self)
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(UIZombieEliteBossRewardRateItem)
  self.cellCache = {}
end

local function OnAlteredClick(self)
  self.showEliteBoss = not self.showEliteBoss
  if self.showEliteBoss then
    self:PlayAnimation("LWUIZombieEliteBossDescChange2")
  else
    self:PlayAnimation("LWUIZombieEliteBossDescChange1")
  end
  self:RefreshMonsterInfo()
end

local function SetCurSeasonEliteMonsterId(self, eliteBoss_show)
  local eliteId, alteredId
  if not string.IsNullOrEmpty(eliteBoss_show) then
    local seasonDataArr = string.split(eliteBoss_show, "|")
    if seasonDataArr and 0 < #seasonDataArr then
      local season = DataCenter.SeasonDataManager:GetSeason()
      season = tostring(season)
      for _, v in pairs(seasonDataArr) do
        if v then
          local vArr = string.split(v, ";")
          if vArr and 2 < #vArr and vArr[1] == season then
            eliteId = tonumber(vArr[2])
            alteredId = tonumber(vArr[3])
            break
          end
        end
      end
    end
  end
  self.eliteMonsterId = eliteId
  self.alteredMonsterId = alteredId
end

local function SetCurSeasonEliteDropId(self, eliteBoss_reward_show)
  local dropId, alteredDropId
  if not string.IsNullOrEmpty(eliteBoss_reward_show) then
    local seasonRewardsArr = string.split(eliteBoss_reward_show, "|")
    if seasonRewardsArr and 0 < #seasonRewardsArr then
      local season = DataCenter.SeasonDataManager:GetSeason()
      season = tostring(season)
      for _, v in pairs(seasonRewardsArr) do
        local arr = string.split(v, ";")
        if arr and 2 < #arr and season == arr[1] then
          dropId = tonumber(arr[2])
          alteredDropId = tonumber(arr[3])
          break
        end
      end
    end
  end
  self.eliteDropId = dropId
  self.alteredDropId = alteredDropId
end

local function SetCurEliteBossTipsData(self, eliteBoss_target)
  local percent, num
  if not string.IsNullOrEmpty(eliteBoss_target) then
    local arr = string.split(eliteBoss_target, "|")
    if arr and 0 < #arr then
      local vArr = string.split(arr[1], ";")
      if vArr and 2 < #vArr then
        percent = tonumber(vArr[2])
        num = tonumber(vArr[3])
      end
    end
  end
  self.eliteBossPercentValue = percent
  self.eliteBossAtkNumValue = num
end

local function SetCurAlteredBossTipsData(self, alter_rate)
  local percent, num
  if not string.IsNullOrEmpty(alter_rate) then
    local arr = string.split(alter_rate, ";")
    if arr and 1 < #arr then
      percent = tonumber(arr[1])
      num = tonumber(arr[2])
    end
  end
  self.alteredBossPercentValue = percent
  self.alteredBossAtkNumValue = num
end

local function PlayAnimation(self, animName)
  if self.animator and not string.IsNullOrEmpty(animName) then
    self.animator:SetSpeed(1)
    self.animator:SampleAnimationAtTime(animName, 0)
    self.animator:Play(animName)
  end
end

UIZombieEliteBossDescPanel.OnCreate = OnCreate
UIZombieEliteBossDescPanel.OnDestroy = OnDestroy
UIZombieEliteBossDescPanel.OnEnable = OnEnable
UIZombieEliteBossDescPanel.OnDisable = OnDisable
UIZombieEliteBossDescPanel.ComponentDefine = ComponentDefine
UIZombieEliteBossDescPanel.ComponentDestroy = ComponentDestroy
UIZombieEliteBossDescPanel.DataDefine = DataDefine
UIZombieEliteBossDescPanel.DataDestroy = DataDestroy
UIZombieEliteBossDescPanel.OnAddListener = OnAddListener
UIZombieEliteBossDescPanel.OnRemoveListener = OnRemoveListener
UIZombieEliteBossDescPanel.OnCloseClick = OnCloseClick
UIZombieEliteBossDescPanel.SetPanelShow = SetPanelShow
UIZombieEliteBossDescPanel.ReInit = ReInit
UIZombieEliteBossDescPanel.RefreshRewardList = RefreshRewardList
UIZombieEliteBossDescPanel.OnRewardItemMoveIn = OnRewardItemMoveIn
UIZombieEliteBossDescPanel.OnRewardItemMoveOut = OnRewardItemMoveOut
UIZombieEliteBossDescPanel.ClearScroll = ClearScroll
UIZombieEliteBossDescPanel.OnAlteredClick = OnAlteredClick
UIZombieEliteBossDescPanel.SetCurSeasonEliteMonsterId = SetCurSeasonEliteMonsterId
UIZombieEliteBossDescPanel.SetCurSeasonEliteDropId = SetCurSeasonEliteDropId
UIZombieEliteBossDescPanel.RefreshMonsterInfo = RefreshMonsterInfo
UIZombieEliteBossDescPanel.RefreshMonsterInfo = RefreshMonsterInfo
UIZombieEliteBossDescPanel.SetCurEliteBossTipsData = SetCurEliteBossTipsData
UIZombieEliteBossDescPanel.SetCurAlteredBossTipsData = SetCurAlteredBossTipsData
UIZombieEliteBossDescPanel.PlayAnimation = PlayAnimation
return UIZombieEliteBossDescPanel
