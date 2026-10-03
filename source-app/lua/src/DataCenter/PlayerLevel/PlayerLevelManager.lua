local PlayerLevelManager = BaseClass("PlayerLevelManager")
local Localization = CS.GameEntry.Localization
local PlayerLevelTemplate = require("DataCenter.PlayerLevel.PlayerLevelTemplate")
local ContentInfoType = {
  Build = 1,
  Career = 2,
  CareerFree = 3,
  Farm = 4,
  Factory = 5,
  Effect = 6,
  Normal = 99
}

local function __init(self)
  self:OnAddListener()
  self.scrollToLevel = nil
  self.timer = nil
  self.levelUpQueue = {}
  self.templateDict = {}
  self.levelRewardArr = {}
  self.dailyExp = 0
  self.dailyExpResetTime = 0
  LocalController:instance():visitTable(TableName.PlayerLevel, function(_, lineData)
    local template = PlayerLevelTemplate.New()
    template:InitData(lineData)
    self.templateDict[template.level] = template
  end)
  local effectDict = {}
  for i = 2, #self.templateDict do
    self.templateDict[i].totalExp = self.templateDict[i - 1].totalExp + self.templateDict[i].curExp
    local effectList = {}
    local effectLine = self.templateDict[i].effect
    if not string.IsNullOrEmpty(effectLine) then
      local effectStrs = string.split(effectLine, "|")
      for _, effectStr in pairs(effectStrs) do
        local kv = string.split(effectStr, ";")
        local key = tonumber(kv[1])
        local value = tonumber(kv[2])
        local oldValue = effectDict[key] or 0
        if value > oldValue then
          table.insert(effectList, {
            key = key,
            value = value - oldValue
          })
        end
        effectDict[key] = value
      end
    end
    self.templateDict[i].effectList = effectList
  end
end

local function __delete(self)
  self:OnRemoveListener()
  self.scrollToLevel = nil
  self.templateDict = nil
  self.timer = nil
  self.levelUpQueue = nil
  self.levelRewardArr = nil
  self.dailyExp = nil
  self.dailyExpResetTime = nil
end

local function OnAddListener(self)
  EventManager:GetInstance():AddListener(EventId.CloseUI, self.CloseUISignal)
end

local function OnRemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.CloseUI, self.CloseUISignal)
end

local function CloseUISignal()
  DataCenter.PlayerLevelManager:TryShowLevelUp()
end

local function InitData(self, message)
  if message.levelRewardArr then
    self.levelRewardArr = message.levelRewardArr
    table.sort(self.levelRewardArr, function(a, b)
      return a.level < b.level
    end)
  end
  if message.playerExpLimit then
    local info = message.playerExpLimit
    self.dailyExp = info.dailyExp or 0
    self.dailyExpResetTime = info.lastResetTime or 0
  end
end

local function Enabled(self)
  return LuaEntry.DataConfig:CheckSwitch("player_level")
end

local function GetSeason(self)
  return 1
end

local function GetLevel(self)
  local Player = LuaEntry.Player
  return Player.level or 1
end

local function GetCurExp(self)
  local Player = LuaEntry.Player
  return Player.exp or 0
end

local function GetTotalExp(self)
  local level = self:GetLevel()
  return self:GetCurExp() + self.templateDict[level].totalExp
end

local function GetLevelPercent(self)
  local level = self:GetLevel()
  local template = self:GetTemplate(level + 1)
  if template then
    local result = self:GetCurExp() / template.curExp
    result = math.max(result, 0)
    result = math.min(result, 1)
    return result
  else
    return 1
  end
end

local function CanOpenBox(self)
  if not self:Enabled() then
    return false
  end
  return self:GetFirstOpenLevel() ~= nil
end

local function GetFirstOpenLevel(self)
  if not self:Enabled() then
    return nil
  end
  for _, template in ipairs(self.templateDict) do
    if template.level > 1 and self:GetLevel() >= template.level and not self:HasReceivedLevelReward(template.level) then
      return template.level
    end
  end
  return nil
end

local function GetTemplate(self, level)
  return self.templateDict[level]
end

local function GetMaxLevel(self)
  return #self.templateDict
end

local function GetReward(self, level)
  for _, v in pairs(self.levelRewardArr) do
    if v.level == level then
      return v
    end
  end
  return nil
end

local function GetIcon(self, level)
  local template = self:GetTemplate(level)
  if self:HasSpecialContent(level) then
    local list = self:GetContentInfoList(level)
    return list[1].icon
  elseif not string.IsNullOrEmpty(template.boxIcon) then
    path = string.format("Assets/Main/Sprites/UI/UIPersonalArms/UIactivities_icon_box%s", template.boxIcon)
    if self:HasReceivedLevelReward(level) then
      path = path .. "_1"
    end
    return path
  end
  return "Assets/Main/Sprites/UI/UIAllianceOrder/UIAllianceOrder_img_box.png"
end

local function PlayerAddExp(self, message)
  if not self:Enabled() then
    return
  end
  local Player = LuaEntry.Player
  if message.playerExpLimit then
    local info = message.playerExpLimit
    self.dailyExp = info.dailyExp or 0
    self.dailyExpResetTime = info.lastResetTime or 0
  end
  if message.addType then
    local source = message.addType
    if source == ExpSource.KillMonster then
      local world = CS.SceneManager.World
      local pointId = message.pointId
      local val = message.addExp
      if world and pointId then
        local worldPos = SceneUtils.TileIndexToWorld(pointId)
        local pos = world:WorldToScreenPoint(worldPos)
        self:FlyExp(ExpSource.KillMonster, pos, val)
      end
    end
  end
  for lv = Player.level + 1, message.level do
    self:EnqueueLevelUp(lv)
  end
  Player.level = message.level
  Player.exp = message.exp
  DataCenter.RewardManager:AddRewardsAndRes(message)
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.timer = TimerManager:DelayInvoke(function()
    self:TryShowLevelUp()
    if self.timer then
      self.timer:Stop()
      self.timer = nil
    end
  end, 0.6)
end

local function PlayerReceiveLevelReward(self, message)
  if not self:Enabled() then
    return
  end
  DataCenter.RewardManager:AddRewardsAndRes(message)
  for _, v in pairs(self.levelRewardArr) do
    if v.level == message.level then
      v.received = true
      break
    end
  end
  if not self:HasSpecialContent(message.level) then
    DataCenter.RewardManager:ShowGiftReward(message, Localization:GetString("120985"))
  end
  EventManager:GetInstance():Broadcast(EventId.ReceiveLevelReward, message.level)
end

local function FlyExp(self, source, pos, val, delay)
  if not self:Enabled() then
    return
  end
  if not self:CanAddExpToday() and (source == ExpSource.Farming or source == ExpSource.Pasture or source == ExpSource.Factory or source == ExpSource.Order) then
    return
  end
  if pos == nil or val == nil or tonumber(val) <= 0 then
    return
  end
  if source == ExpSource.Farming then
    local extra = tonumber(LuaEntry.Effect:GetGameEffect(EffectDefine.FARM_EXP_ADD)) or 0
    val = math.floor(val * (1 + extra / 100))
  end
  local pic = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_exp.png"
  local dest = UIUtil.GetUIMainSavePos(UIMainSavePosType.PlayerLevel)
  if dest ~= nil then
    local dly = delay or 1.25
    TimerManager:GetInstance():DelayInvoke(function()
      UIUtil.DoFly(RewardType.EXP, tonumber(val), pic, pos, dest, 57, 62, function()
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.Effect_Exp_FarmSystem, false)
        EventManager:GetInstance():Broadcast(EventId.UpdatePlayerExp)
      end)
    end, dly)
  else
    EventManager:GetInstance():Broadcast(EventId.UpdatePlayerExp)
  end
end

local function HasReceivedLevelReward(self, level)
  if not self:Enabled() or level <= 0 then
    return true
  end
  return self:ReachLevel(level)
end

local function HasContent(self, level)
  local template = self:GetTemplate(level)
  return not string.IsNullOrEmpty(template.reward) or self:HasSpecialContent(level)
end

local function HasSpecialContent(self, level)
  local template = self:GetTemplate(level)
  return not table.IsNullOrEmpty(template.buildIdList) or not table.IsNullOrEmpty(template.farmIdList) or not table.IsNullOrEmpty(template.factoryIdList) or not table.IsNullOrEmpty(template.effectList) or DataCenter.PlayerCareerManager:EnabledShow() and template.unlockCareerLv > 0 or DataCenter.PlayerCareerManager:EnabledShow() and 0 < template.careerFree
end

local function GetContentInfoList(self, level, orderParam)
  local list = {}
  local dict = self:GetContentInfoDict(level, orderParam)
  for _, typeDict in pairs(dict) do
    for _, info in pairs(typeDict) do
      table.insert(list, info)
    end
  end
  table.sort(list, function(a, b)
    return a.order < b.order
  end)
  return list
end

local function GetContentInfoDict(self, level, orderParam)
  local dict = {
    [ContentInfoType.Build] = {},
    [ContentInfoType.Career] = {},
    [ContentInfoType.CareerFree] = {},
    [ContentInfoType.Farm] = {},
    [ContentInfoType.Factory] = {},
    [ContentInfoType.Effect] = {},
    [ContentInfoType.Normal] = {}
  }
  local template = self:GetTemplate(level)
  if not table.IsNullOrEmpty(template.buildIdList) then
    for _, buildId in pairs(template.buildIdList) do
      local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
      local info = {
        icon = DataCenter.BuildManager:GetBuildIconPath(buildId, 1),
        name = Localization:GetString(buildTemplate.name),
        desc = Localization:GetString(buildTemplate.des),
        pos = UIUtil.GetUIMainSavePos(UIMainSavePosType.FastBuild) + Vector3.New(0, 10, 0),
        count = "",
        unlock = true,
        order = orderParam and orderParam.buildOrder or 1,
        type = ContentInfoType.Build
      }
      dict[ContentInfoType.Build][buildId] = info
    end
  end
  if DataCenter.PlayerCareerManager:EnabledShow() and 0 < template.unlockCareerLv then
    local info = {
      icon = string.format(LoadPath.CommonNewPath, "Common_icon_career"),
      name = Localization:GetString("395400"),
      desc = Localization:GetString("395015"),
      pos = nil,
      count = NumToRoman(template.unlockCareerLv),
      unlock = false,
      order = orderParam and orderParam.careerOrder or 2,
      type = ContentInfoType.Career
    }
    dict[ContentInfoType.Career][1] = info
  end
  if DataCenter.PlayerCareerManager:Enabled() and template.careerFree and 0 < template.careerFree then
    local careerNames = {}
    for _, careerType in ipairs(DataCenter.PlayerCareerManager.freeChangeCareerTypeList) do
      local careerTemplate = DataCenter.PlayerCareerManager:GetCareerTemplate(careerType, 1)
      table.insert(careerNames, Localization:GetString(careerTemplate.name))
    end
    local info = {
      icon = "Assets/Main/Sprites/ItemIcons/item200027",
      name = Localization:GetString("395404"),
      desc = Localization:GetString("395401", template.careerFree, table.unpack(careerNames)),
      pos = nil,
      count = template.careerFree .. "h",
      unlock = false,
      order = orderParam and orderParam.careerFreeOrder or 3,
      type = ContentInfoType.CareerFree
    }
    dict[ContentInfoType.CareerFree][1] = info
  end
  if not table.IsNullOrEmpty(template.farmIdList) then
    for _, farmId in pairs(template.farmIdList) do
      local farmTemplate = DataCenter.FarmingDataManager:GetFramingTemplate(farmId)
      local resId = farmTemplate:GetResourceItemId()
      local resTemplate = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(resId)
      local info = {
        icon = farmTemplate:GetIconPath(),
        name = Localization:GetString(farmTemplate.product_name),
        desc = Localization:GetString(resTemplate.desc),
        pos = nil,
        count = "",
        unlock = true,
        order = orderParam and orderParam.farmOrder or 4,
        type = ContentInfoType.Farm,
        resId = resId
      }
      dict[ContentInfoType.Farm][farmId] = info
    end
  end
  if not table.IsNullOrEmpty(template.factoryIdList) then
    for _, factoryId in pairs(template.factoryIdList) do
      local factoryTemplate = DataCenter.FactoryDataManager:GetFactoryTemplate(factoryId)
      local resId = factoryTemplate:GetResourceItemId()
      local resTemplate = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(resId)
      local info = {
        icon = factoryTemplate:GetIconPath(),
        name = Localization:GetString(factoryTemplate.product_name),
        desc = Localization:GetString(resTemplate.desc),
        pos = nil,
        count = "",
        unlock = true,
        order = orderParam and orderParam.factoryOrder or 5,
        type = ContentInfoType.Factory,
        resId = resId
      }
      dict[ContentInfoType.Factory][factoryId] = info
    end
  end
  if not table.IsNullOrEmpty(template.effectList) then
    for _, effect in pairs(template.effectList) do
      local icon
      if effect.key == EffectDefine.ADD_FIELD_NUM then
        icon = "Assets/Main/Sprites/BuildIconOutCity/pic702000_2_free.png"
      elseif effect.key == EffectDefine.ADD_OSTRICH_NUM then
        icon = "Assets/Main/Sprites/ItemIcons/Common_icon_ostrich.png"
      elseif effect.key == EffectDefine.ADD_COW_NUM then
        icon = "Assets/Main/Sprites/ItemIcons/Common_icon_cattle.png"
      elseif effect.key == EffectDefine.ADD_PIG_NUM then
        icon = "Assets/Main/Sprites/ItemIcons/Common_icon_sandworm.png"
      end
      local effectName = Localization:GetString(GetTableData(TableName.EffectNumDesc, effect.key, "des"))
      if icon ~= nil and effectName ~= nil then
        local info = {
          icon = icon,
          name = effectName .. " +" .. effect.value,
          desc = "",
          pos = nil,
          count = "",
          unlock = false,
          order = orderParam and orderParam.effectOrder or 6,
          type = ContentInfoType.Effect,
          effect = effect
        }
        dict[ContentInfoType.Effect][effect.key] = info
      end
    end
  end
  local levelReward = self:GetReward(level)
  if levelReward and levelReward.reward then
    for _, reward in pairs(levelReward.reward) do
      if type(reward.value) == "number" then
        local info = {
          icon = DataCenter.RewardManager:GetPicByType(reward.type),
          name = DataCenter.RewardManager:GetNameByType(reward.type),
          desc = DataCenter.RewardManager:GetDescByType(reward.type),
          pos = nil,
          count = "x" .. string.GetFormattedStr(reward.value),
          unlock = false,
          order = orderParam and orderParam.rewardOrder or 7,
          type = ContentInfoType.Normal
        }
        dict[ContentInfoType.Normal][reward.type] = info
      elseif type(reward.value) == "table" then
        local showUnlock = false
        for _, info in pairs(dict[ContentInfoType.Farm]) do
          if info.resId == tonumber(reward.value.id) then
            info.count = "x" .. string.GetFormattedStr(reward.value.num)
            showUnlock = true
            break
          end
        end
        for _, info in pairs(dict[ContentInfoType.Factory]) do
          if info.resId == tonumber(reward.value.id) then
            info.count = "x" .. string.GetFormattedStr(reward.value.num)
            showUnlock = true
            break
          end
        end
        if not showUnlock then
          local info = {
            icon = DataCenter.RewardManager:GetPicByType(reward.type, reward.value.id),
            name = DataCenter.RewardManager:GetNameByType(reward.type, reward.value.id),
            desc = DataCenter.RewardManager:GetDescByType(reward.type, reward.value.id),
            pos = nil,
            count = "x" .. string.GetFormattedStr(reward.value.num),
            unlock = false,
            order = orderParam and orderParam.rewardOrder or 8,
            type = ContentInfoType.Normal
          }
          dict[ContentInfoType.Normal][reward.value.id] = info
        end
      end
    end
  end
  return dict
end

local function TryShowLevelUp(self)
  if table.count(self.levelUpQueue) > 0 then
    local stackCount = UIManager:GetInstance():GetStackWindowCount()
    local show = false
    if stackCount == 0 then
      show = true
    else
      local topWindow = UIManager:GetInstance():GetStackTopWindow()
      if topWindow.Name == UIWindowNames.UIFactory or topWindow.Name == UIWindowNames.UIFarm or topWindow.Name == UIWindowNames.UIFarmGather or topWindow.Name == UIWindowNames.UIBuildDetails and topWindow.View.buildTemplate.id == BuildingTypes.FUN_BUILD_MAIN then
        show = true
      end
    end
    if show then
      if DataCenter.GuideManager:InGuide() then
        DataCenter.GuideManager:SetGuideEndCallBack(function()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILevelUp)
          DataCenter.GuideManager:CheckPlayerLevelGuide(DataCenter.GuideManager:GetSaveGuideValue(SaveTriggerGuidePlayerLevel))
        end)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILevelUp)
        DataCenter.GuideManager:CheckPlayerLevelGuide(DataCenter.GuideManager:GetSaveGuideValue(SaveTriggerGuidePlayerLevel))
      end
    end
  end
end

local function ReachLevel(self, level)
  if not self:Enabled() then
    return true
  end
  local Player = LuaEntry.Player
  return level <= Player.level
end

local function EnqueueLevelUp(self, level)
  table.insert(self.levelUpQueue, level)
end

local function DequeueLevelUp(self)
  if table.count(self.levelUpQueue) == 0 then
    return nil
  end
  return table.remove(self.levelUpQueue, 1)
end

local function SetScrollToLevel(self, level)
  self.scrollToLevel = level
end

local function GetScrollToLevel(self)
  return self.scrollToLevel
end

local function CanAddExpToday(self)
  local expLimit = LuaEntry.DataConfig:TryGetNum("player_lv_exp", "k1") or 0
  if expLimit == 0 then
    return true
  end
  return expLimit > self:GetDailyExp()
end

local function GetDailyExp(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local sameDay = UITimeManager:GetInstance():IsSameDayForServer(curTime // 1000, self.dailyExpResetTime // 1000)
  if not sameDay then
    return 0
  end
  return self.dailyExp
end

PlayerLevelManager.__init = __init
PlayerLevelManager.__delete = __delete
PlayerLevelManager.OnAddListener = OnAddListener
PlayerLevelManager.OnRemoveListener = OnRemoveListener
PlayerLevelManager.CloseUISignal = CloseUISignal
PlayerLevelManager.ContentInfoType = ContentInfoType
PlayerLevelManager.InitData = InitData
PlayerLevelManager.Enabled = Enabled
PlayerLevelManager.GetSeason = GetSeason
PlayerLevelManager.GetLevel = GetLevel
PlayerLevelManager.GetCurExp = GetCurExp
PlayerLevelManager.GetTotalExp = GetTotalExp
PlayerLevelManager.GetLevelPercent = GetLevelPercent
PlayerLevelManager.CanOpenBox = CanOpenBox
PlayerLevelManager.GetFirstOpenLevel = GetFirstOpenLevel
PlayerLevelManager.GetTemplate = GetTemplate
PlayerLevelManager.GetMaxLevel = GetMaxLevel
PlayerLevelManager.GetReward = GetReward
PlayerLevelManager.GetIcon = GetIcon
PlayerLevelManager.FlyExp = FlyExp
PlayerLevelManager.HasReceivedLevelReward = HasReceivedLevelReward
PlayerLevelManager.HasContent = HasContent
PlayerLevelManager.HasSpecialContent = HasSpecialContent
PlayerLevelManager.GetContentInfoList = GetContentInfoList
PlayerLevelManager.GetContentInfoDict = GetContentInfoDict
PlayerLevelManager.PlayerAddExp = PlayerAddExp
PlayerLevelManager.PlayerReceiveLevelReward = PlayerReceiveLevelReward
PlayerLevelManager.TryShowLevelUp = TryShowLevelUp
PlayerLevelManager.ReachLevel = ReachLevel
PlayerLevelManager.EnqueueLevelUp = EnqueueLevelUp
PlayerLevelManager.DequeueLevelUp = DequeueLevelUp
PlayerLevelManager.SetScrollToLevel = SetScrollToLevel
PlayerLevelManager.GetScrollToLevel = GetScrollToLevel
PlayerLevelManager.CanAddExpToday = CanAddExpToday
PlayerLevelManager.GetDailyExp = GetDailyExp
return PlayerLevelManager
