local PlayerCareerManager = BaseClass("PlayerCareerManager")
local PlayerCareerTemplate = require("DataCenter.PlayerCareer.PlayerCareerTemplate")
local PlayerCareerEffectTemplate = require("DataCenter.PlayerCareer.PlayerCareerEffectTemplate")
local PlayerCareerSkill = require("DataCenter.PlayerCareer.PlayerCareerSkill")
local Localization = CS.GameEntry.Localization
local PayType = {SelectCareer = 1, LevelUpCareer = 2}

local function __init(self)
  self:OnAddListener()
  self.NEED_LEVEL = LuaEntry.DataConfig:TryGetNum("player_career", "k1")
  self.careerTemplateDict = {}
  self.careerEffectTemplateDict = {}
  self.careerMaxLv = {}
  self.careerChangeRequireItemDict = {}
  self.careerTypeList = {}
  self.freeChangeCareerTypeList = {}
  self.careerFreeChangeEndTime = 0
  self.careerSkillDict = {}
  self.careerEffectNeedLv = {}
  self.careerSkillNextEndTime = LongMaxValue
  self.careerLevelUpNeedItemIdDict = {}
  self.irrigationInfoDic = {}
  self.payType = nil
  self.payAndUsePackId = nil
  self.payAndUseCareerType = nil
  self.tempFromCareerLv = nil
  self.tempToCareerLv = nil
  LocalController:instance():visitTable(TableName.PlayerCareer, function(_, line)
    local template = PlayerCareerTemplate.New()
    template:InitData(line)
    self.careerTemplateDict[template.id] = template
    if self.careerMaxLv[template.type] == nil or template.level > self.careerMaxLv[template.type] then
      self.careerMaxLv[template.type] = template.level
    end
    if not table.hasvalue(self.careerTypeList, template.type) then
      table.insert(self.careerTypeList, template.type)
    end
    for _, id in ipairs(template.initEffectList) do
      self.careerEffectNeedLv[id] = 1
    end
    self.careerEffectNeedLv[template.levelEffect] = template.level
    if self.careerLevelUpNeedItemIdDict[template.type] == nil and template.level > 1 and table.count(template.requireItemDict) > 0 then
      for itemId, _ in pairs(template.requireItemDict) do
        self.careerLevelUpNeedItemIdDict[template.type] = itemId
        break
      end
    end
  end)
  table.sort(self.careerTypeList, function(careerTypeA, careerTypeB)
    local templateA = self:GetCareerTemplate(careerTypeA, 1)
    local templateB = self:GetCareerTemplate(careerTypeB, 1)
    return templateA.order < templateB.order
  end)
  LocalController:instance():visitTable(TableName.PlayerCareerEffect, function(_, line)
    local template = PlayerCareerEffectTemplate.New()
    template:InitData(line)
    self.careerEffectTemplateDict[template.id] = template
  end)
  local changeStr = LuaEntry.DataConfig:TryGetStr("player_career", "k2")
  for _, str in ipairs(string.split(changeStr, "|")) do
    local spls = string.split(str, ";")
    if #spls == 3 then
      local type = tonumber(spls[1])
      local itemId = tonumber(spls[2])
      local count = tonumber(spls[3])
      if self.careerChangeRequireItemDict[type] == nil then
        self.careerChangeRequireItemDict[type] = {}
      end
      self.careerChangeRequireItemDict[type][itemId] = count
    end
  end
  local freeChangeStr = LuaEntry.DataConfig:TryGetStr("player_career", "k6")
  for _, str in ipairs(string.split(freeChangeStr, ";")) do
    table.insert(self.freeChangeCareerTypeList, tonumber(str))
  end
  for type, idList in pairs(CareerSkillTypeToIdList) do
    for _, id in ipairs(idList) do
      self.careerSkillDict[id] = PlayerCareerSkill.New(id, 0, 0, type)
    end
  end
  self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
  self.timer:Start()
end

local function __delete(self)
  self:OnRemoveListener()
  self.NEED_LEVEL = nil
  self.careerTemplateDict = nil
  self.careerEffectTemplateDict = nil
  self.careerMaxLv = nil
  self.careerChangeRequireItemDict = nil
  self.careerFreeChangeEndTime = nil
  self.careerSkillDict = nil
  self.careerEffectNeedLv = nil
  self.careerSkillNextEndTime = nil
  self.careerLevelUpNeedItemIdDict = nil
  self.irrigationInfoDic = nil
  self.payType = nil
  self.payAndUsePackId = nil
  self.payAndUseCareerType = nil
  self.tempFromCareerLv = nil
  self.tempToCareerLv = nil
  self.timer:Stop()
  self.timer = nil
  self.irrigationInfoDic = nil
end

local function OnAddListener(self)
  EventManager:GetInstance():AddListener(EventId.PaySuccess, self.OnPaySuccess)
  EventManager:GetInstance():AddListener(EventId.PlayerCareerSelect, self.OnCareerSelect)
  EventManager:GetInstance():AddListener(EventId.PlayerCareerLevelUp, self.OnCareerLevelUp)
end

local function OnRemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.PaySuccess, self.OnPaySuccess)
  EventManager:GetInstance():RemoveListener(EventId.PlayerCareerSelect, self.OnCareerLevelUp)
  EventManager:GetInstance():RemoveListener(EventId.PlayerCareerLevelUp, self.OnCareerLevelUp)
end

local function InitData(self, message)
  if message.careerFreeChangeEndTime then
    self:UpdateCareerFreeChangeEndTime(message.careerFreeChangeEndTime)
  end
  if message.careerSkills then
    self:UpdateCareerSkills(message.careerSkills)
  end
end

local function UpdateCareerFreeChangeEndTime(self, endTime)
  self.careerFreeChangeEndTime = endTime
end

local function UpdateCareerSkills(self, careerSkills)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local timeUpdated = false
  for _, careerSkill in ipairs(careerSkills) do
    local skill = PlayerCareerSkill.New()
    skill:ParseData(careerSkill)
    self.careerSkillDict[skill.id] = skill
    if curTime < skill.time then
      self.careerSkillNextEndTime = math.min(self.careerSkillNextEndTime, skill.time)
      timeUpdated = true
    end
  end
  if timeUpdated then
    EventManager:GetInstance():Broadcast(EventId.CareerSkillTimeUpdate)
  end
end

local function Enabled(self)
  return LuaEntry.DataConfig:CheckSwitch("player_career_switch")
end

local function EnabledShow(self)
  return self:Enabled() or LuaEntry.DataConfig:CheckSwitch("player_career_show")
end

local function ReachedLevel(self)
  return self.NEED_LEVEL and DataCenter.PlayerLevelManager:GetLevel() >= self.NEED_LEVEL
end

local function TimerAction(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > self.careerSkillNextEndTime then
    self.careerSkillNextEndTime = LongMaxValue
    for _, skill in pairs(self.careerSkillDict) do
      if curTime < skill.time then
        self.careerSkillNextEndTime = math.min(self.careerSkillNextEndTime, skill.time)
      end
    end
    EventManager:GetInstance():Broadcast(EventId.CareerSkillTimeUpdate)
  end
end

local function GetCareerType(self)
  return self:Enabled() and LuaEntry.Player.careerType or CareerType.None
end

local function GetCareerLv(self)
  return self:Enabled() and LuaEntry.Player.careerLv or 0
end

local function GetCareerTemplate(self, careerType, careerLv)
  if careerType == nil or careerLv == nil then
    return nil
  end
  local id = careerType * 1000 + (careerLv or 1) - 1
  return self.careerTemplateDict[id]
end

local function GetCareerEffectTemplate(self, id)
  if id == nil then
    return nil
  end
  return self.careerEffectTemplateDict[id]
end

local function GetCareerMaxLv(self, careerType)
  return self.careerMaxLv[careerType] or 0
end

local function GetCareerTypeList(self)
  return self.careerTypeList
end

local function GetEffectTip(self, id)
  local template = self:GetCareerEffectTemplate(id)
  if template == nil then
    return ""
  end
  local name = Localization:GetString(template.name)
  if template.show == 1 then
    name = name .. " (" .. Localization:GetString("120105") .. ")"
  end
  local effectValStrs = {}
  for i = 1, #template.effectVals do
    local str = tostring(template.effectVals[i])
    local showType = template.showTypes[i]
    if showType == 1 then
      str = str .. "%"
    elseif showType == 2 then
      str = "+" .. str
    elseif showType == 3 then
      str = "-" .. str
    elseif showType == 4 then
      str = "+" .. str .. "%"
    elseif showType == 5 then
      str = "-" .. str .. "%"
    end
    table.insert(effectValStrs, str)
  end
  local desc = Localization:GetString(template.description, table.unpack(effectValStrs))
  return name, desc
end

local function GetRequireItemInfo(self, requireItemDict)
  local strs = {}
  local dataList = {}
  local lackItemId
  for itemId, count in pairs(requireItemDict) do
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
    local itemData = DataCenter.ItemData:GetItemById(itemId)
    local haveCount = itemData and itemData.count or 0
    local str = Localization:GetString(tostring(itemTemplate.name)) .. " x" .. count
    table.insert(strs, str)
    local data = {
      rewardType = RewardType.GOODS,
      itemId = itemId,
      count = string.GetFormattedStr(count)
    }
    table.insert(dataList, data)
    if count > haveCount and lackItemId == nil then
      lackItemId = itemId
    end
  end
  return string.join(strs, "\n"), dataList, lackItemId
end

local function GetRequireResInfo(self, requireResDict)
  local strs = {}
  local dataList = {}
  local lackResType
  for resType, count in pairs(requireResDict) do
    local haveCount = LuaEntry.Resource:GetCntByResType(resType)
    local str = CommonUtil.GetResourceNameByType(resType) .. " x" .. count
    table.insert(strs, str)
    local data = {
      rewardType = ResTypeToReward[resType],
      count = string.GetFormattedStr(count)
    }
    table.insert(dataList, data)
    if count > haveCount and lackResType == nil then
      lackResType = resType
    end
  end
  return string.join(strs, "\n"), dataList, lackResType
end

local function ConvertCareerName(self, careerTypeList)
  if table.IsNullOrEmpty(careerTypeList) then
    return ""
  end
  if #careerTypeList == #self:GetCareerTypeList() then
    return Localization:GetString(395409)
  end
  local names = {}
  for _, careerType in ipairs(careerTypeList) do
    local careerTemplate = self:GetCareerTemplate(careerType, 1)
    table.insert(names, Localization:GetString(careerTemplate.name))
  end
  return string.join(names, ", ")
end

local function CanLevelUp(self)
  if self:Enabled() and self:ReachedLevel() then
    local careerType = self:GetCareerType()
    local careerLv = self:GetCareerLv()
    if careerType == CareerType.None then
      local nextCareerTemplate = self:GetCareerTemplate(CareerType.Admiral, 1)
      return DataCenter.PlayerLevelManager:GetLevel() >= nextCareerTemplate.requirePlayerLv
    elseif 0 < careerLv and careerLv < self:GetCareerMaxLv(careerType) then
      local nextCareerTemplate = self:GetCareerTemplate(careerType, careerLv + 1)
      return DataCenter.PlayerLevelManager:GetLevel() >= nextCareerTemplate.requirePlayerLv
    end
  end
  return false
end

local function GetCareerRequireItemDict(self, careerType)
  if self:GetCareerType() == CareerType.None then
    local careerTemplate = self:GetCareerTemplate(careerType, 1)
    return careerTemplate.requireItemDict or {}
  else
    return self.careerChangeRequireItemDict[careerType] or {}
  end
end

local function SelectCareer(self, careerType)
  local careerTemplate = self:GetCareerTemplate(careerType, 1)
  local careerName = Localization:GetString(tostring(careerTemplate.name))
  local requireItemDict = self:GetCareerRequireItemDict(careerType)
  if table.IsNullOrEmpty(requireItemDict) then
    local tip = Localization:GetString("395010", careerName)
    UIUtil.ShowMessage(tip, 2, GameDialogDefine.CANCEL, GameDialogDefine.CONFIRM, nil, function()
      SFSNetwork.SendMessage(MsgDefines.PlayerCareerSelect, careerType)
    end, nil, nil, nil, nil, nil, self:Enabled())
  elseif self:HaveFreeChangeForCareer(careerType) then
    local restTime = self:GetFreeChangeRestTime()
    local restTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(restTime)
    
    local function onConfirm()
      SFSNetwork.SendMessage(MsgDefines.PlayerCareerSelect, careerType)
    end
    
    local function timerAction(view)
      local tRestTime = self:GetFreeChangeRestTime()
      if 0 < tRestTime then
        local tRestTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(tRestTime)
        view.bottom_desc_text:SetLocalText(395402, tRestTimeStr)
      end
    end
    
    local param = {
      title = Localization:GetString("100378"),
      topDesc = Localization:GetString("395403", careerName),
      bottomDesc = Localization:GetString("395402", restTimeStr),
      onConfirm = onConfirm,
      timerAction = timerAction
    }
    UIUtil.ShowUseItemTip(param)
  else
    local str, dataList, lackItemId = self:GetRequireItemInfo(requireItemDict)
    local confirmStr = ""
    local pack
    if lackItemId ~= nil then
      local packList = GiftPackageData.GetGivenPacks(lackItemId)
      if not table.IsNullOrEmpty(packList) then
        pack = packList[1]
        confirmStr = DataCenter.PayManager:GetDollarText(pack:getPrice(), pack:getProductID())
      end
    end
    
    local function onConfirm()
      if lackItemId == nil then
        SFSNetwork.SendMessage(MsgDefines.PlayerCareerSelect, careerType)
      elseif pack ~= nil then
        local function onFinalConfirm()
          self.payType = PayType.SelectCareer
          
          self.payAndUsePackId = pack:getID()
          self.payAndUseCareerType = careerType
          DataCenter.PayManager:BuyGift(pack)
        end
        
        local needItemId = self:GetCareerLevelUpNeedItemId(careerType)
        if needItemId then
          local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(needItemId)
          local tip = Localization:GetString("395018", careerName, Localization:GetString(itemTemplate.name))
          UIUtil.ShowMessage(tip, 2, GameDialogDefine.CANCEL, GameDialogDefine.CONFIRM, nil, onFinalConfirm)
        else
          onFinalConfirm()
        end
      else
        UIUtil.ShowTipsId(120021)
      end
    end
    
    local topDesc, bottomDesc, enableConfirm
    if LuaEntry.Player:IsInAlliance() and careerType == CareerType.Admiral and #DataCenter.AllianceCareerManager:GetAllianceMemberListByCareer(1) >= DataCenter.AllianceCareerManager:GetCareerMaxNum(1) then
      topDesc = Localization:GetString("395410", DataCenter.AllianceCareerManager:GetCareerMaxNum(1))
      bottomDesc = ""
      enableConfirm = false
    else
      topDesc = Localization:GetString("395002", str, careerName)
      enableConfirm = self:Enabled()
      if lackItemId ~= nil and pack ~= nil then
        bottomDesc = Localization:GetString("320148", 1)
      else
        bottomDesc = ""
      end
    end
    local param = {
      title = Localization:GetString("100378"),
      topDesc = topDesc,
      bottomDesc = bottomDesc,
      dataList = dataList,
      confirmStr = confirmStr,
      onConfirm = onConfirm,
      enableConfirm = enableConfirm
    }
    UIUtil.ShowUseItemTip(param)
  end
end

local function LevelUpCareer(self, careerType, curCareerLv, targetCareerLv)
  if curCareerLv == nil or targetCareerLv <= curCareerLv then
    return
  end
  local careerLv = curCareerLv + 1
  while targetCareerLv > careerLv do
    local careerTemplate = self:GetCareerTemplate(careerType, careerLv)
    if not (table.IsNullOrEmpty(careerTemplate.requireItemDict) and table.IsNullOrEmpty(careerTemplate.requireResDict)) then
      break
    end
    careerLv = careerLv + 1
  end
  self.tempFromCareerLv = curCareerLv
  self.tempToCareerLv = careerLv
  local careerTemplate = self:GetCareerTemplate(careerType, careerLv)
  local careerName = Localization:GetString(tostring(careerTemplate.name))
  if not table.IsNullOrEmpty(careerTemplate.requireItemDict) then
    local str, dataList, lackItemId = self:GetRequireItemInfo(careerTemplate.requireItemDict)
    local confirmStr = ""
    local pack
    if lackItemId ~= nil then
      local packList = GiftPackageData.GetGivenPacks(lackItemId)
      if not table.IsNullOrEmpty(packList) then
        pack = packList[1]
        confirmStr = DataCenter.PayManager:GetDollarText(pack:getPrice(), pack:getProductID())
      end
    end
    
    local function onConfirm()
      if lackItemId == nil then
        SFSNetwork.SendMessage(MsgDefines.PlayerCareerLevelUp, careerLv)
      elseif pack ~= nil then
        self.payType = PayType.LevelUpCareer
        self.payAndUsePackId = pack:getID()
        DataCenter.PayManager:BuyGift(pack)
      else
        UIUtil.ShowTipsId(120021)
      end
    end
    
    local param = {
      title = Localization:GetString("100378"),
      topDesc = Localization:GetString("395012", str, careerName),
      dataList = dataList,
      confirmStr = confirmStr,
      onConfirm = onConfirm
    }
    UIUtil.ShowUseItemTip(param)
  elseif not table.IsNullOrEmpty(careerTemplate.requireResDict) then
    local str, dataList, lackResType = self:GetRequireResInfo(careerTemplate.requireResDict)
    
    local function onConfirm()
      if lackResType == nil then
        SFSNetwork.SendMessage(MsgDefines.PlayerCareerLevelUp, careerLv)
      else
        UIUtil.ShowTipsId(120020)
      end
    end
    
    local param = {
      title = Localization:GetString("100378"),
      topDesc = Localization:GetString("395012", str, careerName),
      dataList = dataList,
      onConfirm = onConfirm
    }
    UIUtil.ShowUseItemTip(param)
  else
    SFSNetwork.SendMessage(MsgDefines.PlayerCareerLevelUp, careerLv)
  end
end

local function GetFreeChangeRestTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local endTime = self.careerFreeChangeEndTime
  return endTime - curTime
end

local function HaveFreeChange(self)
  if not self:Enabled() then
    return false
  end
  if self:GetCareerType() == CareerType.None then
    return false
  end
  return self:GetFreeChangeRestTime() > 0
end

local function HaveFreeChangeForCareer(self, careerType)
  if not self:HaveFreeChange() then
    return false
  end
  if self:GetCareerType() == careerType then
    return false
  end
  return table.hasvalue(self.freeChangeCareerTypeList, careerType)
end

local function ShowFreeChangeRed(self)
  return false
end

local function GetCareerSkill(self, id)
  return self.careerSkillDict[id]
end

local function GetTroopSkillList(self)
  local list = {}
  for _, skill in pairs(self.careerSkillDict) do
    if self:GetCareerType() == CareerType.Admiral and skill.type == CareerSkillType.AdmiralTroopSkill and self:GetCareerLv() >= self.careerEffectNeedLv[skill.id] then
      local template = self:GetCareerEffectTemplate(skill.id)
      if template.show == 0 then
        table.insert(list, skill)
      end
    end
  end
  return list
end

local function UseSkill(self, id)
  SFSNetwork.SendMessage(MsgDefines.UseCareerSkill, id)
end

local function GetSkillState(self, id)
  local skill = self:GetCareerSkill(id)
  if skill == nil then
    return CareerSkillState.Unknown
  end
  local curTime = math.ceil(UITimeManager:GetInstance():GetServerTime())
  local usingTime = math.max(skill.time - curTime, 0)
  local usedTime = math.max(skill.cdTime - curTime, 0)
  if 0 < usingTime then
    return CareerSkillState.Using
  elseif 0 < usedTime then
    return CareerSkillState.Used
  else
    return CareerSkillState.Ready
  end
end

local function GetCareerLevelUpNeedItemId(self, careerType)
  return self.careerLevelUpNeedItemIdDict[careerType]
end

local function OnCareerSelect()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerLevel, 2)
end

local function OnCareerLevelUp()
  local m = DataCenter.PlayerCareerManager
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICareerLevelUp)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICareerLevelUp, m.tempFromCareerLv, m.tempToCareerLv)
end

local function OnPaySuccess(packId)
  local m = DataCenter.PlayerCareerManager
  if m.payType == PayType.SelectCareer and packId == m.payAndUsePackId and m.payAndUseCareerType ~= nil then
    SFSNetwork.SendMessage(MsgDefines.PlayerCareerSelect, m.payAndUseCareerType)
  elseif m.payType == PayType.LevelUpCareer and packId == m.payAndUsePackId then
    SFSNetwork.SendMessage(MsgDefines.PlayerCareerLevelUp, m.tempToCareerLv)
  end
end

local function UpdateIrrigateInfo(self, t)
  self.irrigationInfoDic = {}
  if t.irrigationArr then
    for i, v in ipairs(t.irrigationArr) do
      self:UpdateOneIrrigationInfo(v)
    end
  end
end

local function UpdateOneIrrigationInfo(self, irrigationObj)
  if self.irrigationInfoDic[irrigationObj.type] then
    self.irrigationInfoDic[irrigationObj.type].remainTimes = irrigationObj.num
    self.irrigationInfoDic[irrigationObj.type].lastRecoverTime = irrigationObj.lastRecoverTime
  else
    local newOne = {}
    newOne.type = irrigationObj.type
    newOne.remainTimes = irrigationObj.num
    newOne.lastRecoverTime = irrigationObj.lastRecoverTime
    newOne.cost = 0
    newOne.maxTimes = 0
    newOne.recoverTimeS = 0
    self.irrigationInfoDic[newOne.type] = newOne
    local conf
    if irrigationObj.type == IrrigationType.Farmland then
      conf = LuaEntry.DataConfig:TryGetStr("career_peasant", "k1")
    else
      conf = LuaEntry.DataConfig:TryGetStr("career_peasant", "k2")
    end
    if conf then
      local strArr = string.split(conf, ";")
      newOne.cost = tonumber(strArr[1])
      newOne.maxTimes = tonumber(strArr[2])
      newOne.recoverTimeS = tonumber(strArr[3])
    end
  end
end

local function GetIrrigationInfo(self, irrigateType)
  return self.irrigationInfoDic[irrigateType]
end

local function GetRemainIrrigationTimes(self, irrigateType)
  local irgInfo = self.irrigationInfoDic[irrigateType]
  if irgInfo then
    if irgInfo.remainTimes > 0 then
      return irgInfo.remainTimes
    else
      local nextRecoverTime = irgInfo.lastRecoverTime + irgInfo.recoverTimeS * 1000
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if nextRecoverTime <= curTime then
        return 1
      else
        return 0, nextRecoverTime
      end
    end
  end
  return 0, 0
end

local function CheckIfIrrigateAvailable(self, irrigateType)
  local effNum = irrigateType == IrrigationType.Farmland and EffectDefine.FARMER_IRRIGATE_FRAM or EffectDefine.FARMER_IRRIGATE_PASTURE
  return LuaEntry.Effect:GetGameEffect(effNum) == 1
end

local function UpdateTraderExtraReward(self, t)
  if t.bankExtraRewardInfo then
    self.traderInfo = {}
    self.traderInfo.lastResetTime = t.bankExtraRewardInfo.lastResetTime
    self.traderInfo.gotCount = t.bankExtraRewardInfo.count
    EventManager:GetInstance():Broadcast(EventId.UpdateTraderExtraRewardTimes)
  end
end

local function GetRemainTraderExtraRewardTimes(self)
  local maxT = LuaEntry.Effect:GetGameEffect(EffectDefine.TRADER_EXTRA_FARM_BOX)
  if maxT <= 0 then
    return nil
  else
    local remainTimes = 0
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local time1 = math.modf(curTime / 1000)
    local time2 = math.modf(self.traderInfo.lastResetTime / 1000)
    if not UITimeManager:GetInstance():IsSameDayForServer(time1, time2) then
      remainTimes = maxT
    else
      local gotNum = self.traderInfo and self.traderInfo.gotCount or 0
      remainTimes = maxT - gotNum
      remainTimes = math.max(remainTimes, 0)
    end
    return remainTimes
  end
end

PlayerCareerManager.__init = __init
PlayerCareerManager.__delete = __delete
PlayerCareerManager.OnAddListener = OnAddListener
PlayerCareerManager.OnRemoveListener = OnRemoveListener
PlayerCareerManager.InitData = InitData
PlayerCareerManager.UpdateCareerFreeChangeEndTime = UpdateCareerFreeChangeEndTime
PlayerCareerManager.UpdateCareerSkills = UpdateCareerSkills
PlayerCareerManager.Enabled = Enabled
PlayerCareerManager.EnabledShow = EnabledShow
PlayerCareerManager.ReachedLevel = ReachedLevel
PlayerCareerManager.TimerAction = TimerAction
PlayerCareerManager.GetCareerType = GetCareerType
PlayerCareerManager.GetCareerLv = GetCareerLv
PlayerCareerManager.GetCareerTemplate = GetCareerTemplate
PlayerCareerManager.GetCareerEffectTemplate = GetCareerEffectTemplate
PlayerCareerManager.GetCareerMaxLv = GetCareerMaxLv
PlayerCareerManager.GetCareerTypeList = GetCareerTypeList
PlayerCareerManager.GetEffectTip = GetEffectTip
PlayerCareerManager.GetRequireItemInfo = GetRequireItemInfo
PlayerCareerManager.GetRequireResInfo = GetRequireResInfo
PlayerCareerManager.ConvertCareerName = ConvertCareerName
PlayerCareerManager.CanLevelUp = CanLevelUp
PlayerCareerManager.GetCareerRequireItemDict = GetCareerRequireItemDict
PlayerCareerManager.SelectCareer = SelectCareer
PlayerCareerManager.LevelUpCareer = LevelUpCareer
PlayerCareerManager.GetFreeChangeRestTime = GetFreeChangeRestTime
PlayerCareerManager.HaveFreeChange = HaveFreeChange
PlayerCareerManager.HaveFreeChangeForCareer = HaveFreeChangeForCareer
PlayerCareerManager.ShowFreeChangeRed = ShowFreeChangeRed
PlayerCareerManager.GetCareerSkill = GetCareerSkill
PlayerCareerManager.GetTroopSkillList = GetTroopSkillList
PlayerCareerManager.UseSkill = UseSkill
PlayerCareerManager.GetSkillState = GetSkillState
PlayerCareerManager.GetCareerLevelUpNeedItemId = GetCareerLevelUpNeedItemId
PlayerCareerManager.OnCareerSelect = OnCareerSelect
PlayerCareerManager.OnCareerLevelUp = OnCareerLevelUp
PlayerCareerManager.OnPaySuccess = OnPaySuccess
PlayerCareerManager.UpdateIrrigateInfo = UpdateIrrigateInfo
PlayerCareerManager.UpdateOneIrrigationInfo = UpdateOneIrrigationInfo
PlayerCareerManager.GetRemainIrrigationTimes = GetRemainIrrigationTimes
PlayerCareerManager.GetIrrigationInfo = GetIrrigationInfo
PlayerCareerManager.CheckIfIrrigateAvailable = CheckIfIrrigateAvailable
PlayerCareerManager.UpdateTraderExtraReward = UpdateTraderExtraReward
PlayerCareerManager.GetRemainTraderExtraRewardTimes = GetRemainTraderExtraRewardTimes
PlayerCareerManager.UpdateIrrigateTimesLocally = UpdateIrrigateTimesLocally
return PlayerCareerManager
