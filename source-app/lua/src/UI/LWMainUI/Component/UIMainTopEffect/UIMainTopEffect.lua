local base = UIBaseContainer
local UIMainTopEffect = BaseClass("UIMainTopEffect", base)
local UIMainFlyRewardCell = require("UI.LWMainUI.Component.UIMainTopEffect.UIMainFlyRewardCell")
local UILWAlertGroup = require("UI.LWMainUI.Component.UIMainTopEffect.UILWAlertGroup")
local UIMainTacticalCardEffect = require("UI.LWMainUI.Component.UIMainTopEffect.UIMainTacticalCardEffect")
local flyCellPath = "UICommonRewardItem"

function UIMainTopEffect:OnCreate()
  base.OnCreate(self)
  self.flyCell = self.transform:Find(flyCellPath)
  local ok, errorMsg = pcall(function()
    self:ComponentDefine()
    self:DataDefine()
  end)
  if not ok and errorMsg then
    Logger.LogError(errorMsg)
  end
end

function UIMainTopEffect:Stop()
  self.flyRewardList = {}
  if self.flyCo then
    coroutine.stopwaiting(self.flyCo)
  end
  self:RemoveComponents(UIMainFlyRewardCell)
end

function UIMainTopEffect:OnDestroy()
  self:Stop()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMainTopEffect:OnEnable()
  base.OnEnable(self)
  self:CheckTacticalCardBuff()
end

function UIMainTopEffect:OnDisable()
  self:Stop()
  self.tacticalCardNode:Clear()
  base.OnDisable(self)
end

function UIMainTopEffect:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UIMainFlyReward, self.CheckFlyReward)
  self:AddUIListener(EventId.UIMainStopFlyReward, self.Stop)
  self:AddUIListener(EventId.UseTacticalCardSkill, self.OnTCCardSkillUse)
end

function UIMainTopEffect:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UIMainFlyReward, self.CheckFlyReward)
  self:RemoveUIListener(EventId.UIMainStopFlyReward, self.Stop)
  self:RemoveUIListener(EventId.UseTacticalCardSkill, self.OnTCCardSkillUse)
end

function UIMainTopEffect:ComponentDefine()
  self.alertGroup = self:AddComponent(UILWAlertGroup, "")
  self.tacticalCardNode = self:AddComponent(UIMainTacticalCardEffect, "tacticalCardNode")
  self.tacticalCardNode:SetActive(false)
end

function UIMainTopEffect:ComponentDestroy()
  self.alertGroup = nil
end

function UIMainTopEffect:DataDefine()
  self.flyRewardList = {}
end

function UIMainTopEffect:RefreshData()
  self.flyRewardList = DataCenter.RewardManager:GetMainUIReward()
  DataCenter.RewardManager:ClearMainUIReward()
end

local function InnerGetFlyTargetByType(self, type, itemId)
  if type == RewardType.METAL or type == RewardType.FOOD or type == RewardType.WOOD or type == RewardType.OBSIDIAN or type == RewardType.PETROLEUM then
    return self.view:GetResourcePos(RewardToResType[type])
  elseif type == RewardType.WORKER then
    return self.view:GetSavePos(UIMainSavePosType.VisitorBtn)
  elseif type == RewardType.GOLD then
    return self.view:GetSavePos(UIMainSavePosType.Gold)
  elseif type == RewardType.HERO or type == RewardType.EquipStrengtheningStone or type == RewardType.HERO_EXP then
    return self.view:GetSavePos(UIMainSavePosType.HeroBtn)
  elseif type == RewardType.VISITOR then
    return self.view:GetSavePos(UIMainSavePosType.VisitorBtn)
  elseif type == RewardType.GOODS and 0 < itemId then
    if itemId == GoldBrickConst.ItemId then
      return self.view:GetSavePos(UIMainSavePosType.GoldBrickBtn)
    end
    local armedUpgradeLevelUpItem = DataCenter.LWArmedUpgradeManager:CheckFlyRewardToArmedUpgradeEntrance(itemId)
    if armedUpgradeLevelUpItem then
      return self.view:GetSavePos(UIMainSavePosType.SaveGirlWarning)
    end
  end
  return self.view:GetSavePos(UIMainSavePosType.BagBtn)
end

local function GetDefault(param)
  if param.itemId then
    return DataCenter.RewardManager:GetPicByType(param.rewardType, tonumber(param.itemId)), nil
  else
    return DataCenter.RewardManager:GetPicByType(param.rewardType), nil
  end
end

local function GetGoods(param)
  local itemId = tonumber(param.itemId)
  return DataCenter.RewardManager:GetPicByType(param.rewardType, itemId), nil
end

local function GetHero(param)
  local heroId = tonumber(param.itemId)
  local icon = HeroUtils.GetHeroIconPath(heroId)
  return icon, "Assets/Main/Sprites/UI/LWCommon/Sprite/tongyong_cfm_daojukuang_5.png"
end

local function GetWorker(param)
  return DataCenter.RewardManager:GetPicByType(param.rewardType), "Assets/Main/Sprites/UI/LWCommon/Sprite/tongyong_cfm_daojukuang_5.png"
end

local TypeRewardMap = {
  [RewardType.HERO] = GetHero,
  [RewardType.WORKER] = GetWorker,
  [RewardType.GOODS] = GetGoods,
  Default = GetDefault
}

local function fly(self, cfgList, delay)
  for _, cfg in pairs(cfgList) do
    local pos = cfg[1]
    local p = cfg[2]
    local icon, bg
    if TypeRewardMap[p.rewardType] then
      icon, bg = TypeRewardMap[p.rewardType](p)
    else
      icon, bg = TypeRewardMap.Default(p)
    end
    if p.rewardType ~= RewardType.WORKER then
      local callback
      if p.rewardType == RewardType.HERO_EXP then
        function callback()
          self.view:ShowHeroExpEffect()
        end
      end
      if p.rewardType == RewardType.METAL or p.rewardType == RewardType.FOOD or p.rewardType == RewardType.WOOD or p.rewardType == RewardType.OBSIDIAN or p.rewardType == RewardType.PETROLEUM then
        UIUtil.DoFlyCustom(icon, "", 10, pos, InnerGetFlyTargetByType(self, p.rewardType), nil, nil, callback, nil, nil, nil, delay, self.transform)
      else
        local width, height
        local itemId = p.itemId and tonumber(p.itemId) or 0
        UIUtil.DoFlyCustom(icon, "", 1, pos, InnerGetFlyTargetByType(self, p.rewardType, itemId), width, height, callback, nil, nil, nil, delay, self.transform)
      end
    end
  end
end

function UIMainTopEffect:FlyReward()
  if self.flyCo then
    coroutine.stopwaiting(self.flyCo)
  end
  local flyRewards = self.flyRewardList
  self.flyRewardList = {}
  self.flyCo = coroutine.start(function()
    for i, v in ipairs(flyRewards) do
      coroutine.waitforseconds(0.5)
      fly(self, v)
    end
    self.flyCo = nil
  end)
end

function UIMainTopEffect:CheckFlyReward(cfg)
  if self then
    if type(cfg) == "table" and 0 < #cfg then
      table.insert(self.flyRewardList, cfg)
    end
    if self.view.ctrl:IsVisible() then
      self:FlyReward()
    end
  end
end

function UIMainTopEffect:ShowAlarmEffect(alarmType)
  if self.alertGroup then
    self.alertGroup:ShowAlarmEffect(alarmType)
  end
end

function UIMainTopEffect:OnTCCardSkillUse(param)
  if not param then
    return
  end
  if param.castUid and param.castUid == LuaEntry.Player.uid then
    self.tacticalCardNode:SetActive(true)
    self.tacticalCardNode:OnTCCardSkillUse(param)
  end
end

function UIMainTopEffect:CheckTacticalCardBuff()
  local haveEffect = false
  local now = UITimeManager:GetInstance():GetServerTime()
  local effectStatus = DataCenter.StatusManager:GetAllBuffData()
  for i, v in ipairs(effectStatus) do
    if v and now < v.endTime then
      local line = LocalController:instance():getLine(TableName.StatusTab, v.id)
      if not string.IsNullOrEmpty(line.card_screen_effect) then
        haveEffect = true
        self.tacticalCardNode:PushScreenLoopVfx(line, v)
      end
    end
  end
  self.tacticalCardNode:SetActive(haveEffect)
end

return UIMainTopEffect
