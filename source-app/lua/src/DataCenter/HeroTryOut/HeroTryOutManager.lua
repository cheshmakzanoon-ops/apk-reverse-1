local HeroTryOutManager = BaseClass("HeroTryOutManager")
local HeroTryOutKatyushaSpecialParkourBattleBonusExtendData = require("DataCenter.HeroTryOut.HeroTryOutKatyushaSpecialParkourBattleBonusExtendData")
local HeroTryOutData = require("DataCenter.HeroTryOut.HeroTryOutData")
local HeroTryOutHeroData = require("DataCenter.HeroTryOut.HeroTryOutHeroData")
local LWHeroTryOutTemplate = require("DataCenter/HeroTryOut/LWHeroTryOutTemplate")
local LWHeroTryOutTagTemplate = require("DataCenter/HeroTryOut/LwHeroTryOutTagTemplate")
local HeroTryOutArmyFormationInfo = require("DataCenter.HeroTryOut.HeroTryOutArmyFormationInfo")
local Localization = CS.GameEntry.Localization

function HeroTryOutManager:__init()
  self.heroTryOutKatyushaSpecialParkourBattleBonusExtendData = nil
  self.userTryOutData = nil
  self.armyFormationInfoDict = {}
  self.battleRewardDataCache = nil
end

function HeroTryOutManager:__delete()
  self.heroTryOutKatyushaSpecialParkourBattleBonusExtendData = nil
  self.userTryOutData = nil
  self.armyFormationInfoDict = nil
  self.battleRewardDataCache = nil
end

function HeroTryOutManager:IsKatyushaSpecialBonusFunctionOn()
  local isConfigOn = LuaEntry.DataConfig:CheckSwitch("herokim_timeline") and LuaEntry.Player:IsKatyushaSpecialBonusStageB()
  if isConfigOn then
    return true
  end
  return false
end

function HeroTryOutManager:IsHasBoughtFirstPay()
  local isHasBoughtFirstPay = false
  local isNewFirstPay = DataCenter.FirstPayManager:IsNewFirstPay()
  if isNewFirstPay then
    local firstPayPack = DataCenter.FirstPayManager:GetFirstPayPack()
    isHasBoughtFirstPay = firstPayPack == nil
  else
    local firstPayState = DataCenter.FirstPayManager:GetState()
    isHasBoughtFirstPay = firstPayState >= FirstPayState.HasReceivedNormalReward
  end
  return isHasBoughtFirstPay
end

function HeroTryOutManager:GetKatyushaSpecialBonusExtendData()
  if self.heroTryOutKatyushaSpecialParkourBattleBonusExtendData ~= nil then
    return self.heroTryOutKatyushaSpecialParkourBattleBonusExtendData
  end
  self.heroTryOutKatyushaSpecialParkourBattleBonusExtendData = HeroTryOutKatyushaSpecialParkourBattleBonusExtendData.New()
  self.heroTryOutKatyushaSpecialParkourBattleBonusExtendData:InitData()
  return self.heroTryOutKatyushaSpecialParkourBattleBonusExtendData
end

function HeroTryOutManager:GetMonopolyPlacealityIdDict()
  if not self:IsKatyushaSpecialBonusFunctionOn() then
    return nil
  end
  local data = self:GetKatyushaSpecialBonusExtendData()
  if data ~= nil then
    return data:GetMonopolyPlacealityIdDict()
  end
  return nil
end

function HeroTryOutManager:GetMonopolyPlacealityNewIdDict()
  local data = self:GetKatyushaSpecialBonusExtendData()
  if data ~= nil then
    return data:GetMonopolyPlacealityNewIdDict()
  end
  return nil
end

HeroTryOutManager.State = {
  Locked = 0,
  Finished = 1,
  Going = 2
}
HeroTryOutManager.StageType = {Parkour = 1, FakePvp = 2}

function HeroTryOutManager:IsHeroTryOutFunctionOn()
  return LuaEntry.DataConfig:CheckSwitch("hero_try_out")
end

function HeroTryOutManager:TrySendGetHeroTryOutInfoMessage()
  if not self:IsHeroTryOutFunctionOn() then
    return
  end
  if self.userTryOutData == nil or not self.userTryOutData:HasInitDataFromGetInfoMsg() then
    SFSNetwork.SendMessage(MsgDefines.GetHeroTryOutInfo)
  end
end

function HeroTryOutManager:OnGetHeroTryOutInfoMessageCallback(msg)
  if msg == nil or msg.heroTryOutArray == nil then
    return
  end
  if self.userTryOutData == nil then
    self.userTryOutData = HeroTryOutData.New()
  end
  self.userTryOutData:InitData(msg.heroTryOutArray, true)
  EventManager:GetInstance():Broadcast(EventId.HeroTryOutReceiveGetInfoMsg)
end

function HeroTryOutManager:GetUserData()
  return self.userTryOutData
end

function HeroTryOutManager:IsUserDataReady()
  return self.userTryOutData ~= nil and self.userTryOutData:HasInitDataFromGetInfoMsg()
end

function HeroTryOutManager:IsShowHeroTryOutEntrance(heroId)
  if not self:IsHeroTryOutFunctionOn() then
    return false
  end
  if not self:IsUserDataReady() then
    return false
  end
  local heroTryOutData = self:GetAllHeroTryOutIdDataByHeroId(heroId)
  if heroTryOutData ~= nil then
    return heroTryOutData:IsShowEntrance()
  end
  return false
end

function HeroTryOutManager:GetAllHeroTryOutIdDictByHeroId(heroId)
  local heroIdNum = tonumber(heroId)
  local result = {}
  LocalController:instance():visitTable(TableName.LW_HERO_TRY_OUT, function(id, lineData)
    if lineData ~= nil and lineData.hero_id == heroIdNum then
      result[lineData.order] = id
    end
  end)
  return result
end

function HeroTryOutManager:GetAllHeroTryOutIdDataByHeroId(heroId)
  local data = HeroTryOutHeroData.New()
  data:Update(heroId)
  return data
end

function HeroTryOutManager:GetLWHeroTryOutTemplateById(id)
  local rowData = LocalController:instance():getLine(TableName.LW_HERO_TRY_OUT, id)
  if rowData ~= nil then
    local template = LWHeroTryOutTemplate.New()
    template:UpdateData(rowData)
    return template
  end
end

function HeroTryOutManager:GetLWHeroTryOutTagTemplateById(id)
  local rowData = LocalController:instance():getLine(TableName.LW_HERO_TRY_OUT_TAG, id)
  if rowData ~= nil then
    local template = LWHeroTryOutTagTemplate.New()
    template:UpdateData(rowData)
    return template
  end
end

function HeroTryOutManager:EnterBattle(heroTryOutId, isReEnter, enterLogMsg)
  local template = self:GetLWHeroTryOutTemplateById(heroTryOutId)
  if template == nil then
    Logger.LogWarning("HeroTryOut\239\188\140HeroTryOutManager:EnterBattle template == nil, return " .. tostring(heroTryOutId))
    return
  end
  if not isReEnter and (CS.SceneManager.IsInPVE() or UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIPVELoading)) then
    Logger.LogWarning("HeroTryOut\239\188\140HeroTryOutManager:EnterBattle in pve, return " .. tostring(heroTryOutId))
    return
  end
  if template.stage_type == self.StageType.Parkour then
    local levelId = template.stage_id
    local param = {}
    param.type = PVEType.Parkour
    param.enterType = PVEEnterType.HeroTryOut
    param.levelId = levelId
    param.extraData = {}
    param.extraData.cfgId = heroTryOutId
    param.extraData.heroTryOutTemplate = template
    DataCenter.LWBattleManager:Enter(param)
    Logger.LogInfo("HeroTryOut\239\188\140HeroTryOutManager:EnterBattle Parkour " .. tostring(heroTryOutId) .. ", " .. tostring(enterLogMsg))
  elseif template.stage_type == self.StageType.FakePvp then
    local levelId = template.stage_id
    local param = {}
    param.type = PVEType.FakePVP
    param.enterType = PVEEnterType.HeroTryOut
    param.levelId = levelId
    param.sceneId = template.lw_scene_id
    param.extraData = {}
    param.extraData.cfgId = heroTryOutId
    DataCenter.LWBattleManager:Enter(param)
    Logger.LogInfo("HeroTryOut\239\188\140HeroTryOutManager:EnterBattle FakePvp " .. tostring(heroTryOutId) .. ", " .. tostring(enterLogMsg))
  end
end

function HeroTryOutManager:GetArmyFormationInfoByHeroTryOutId(heroTryOutId)
  if self.armyFormationInfoDict and self.armyFormationInfoDict[heroTryOutId] then
    return self.armyFormationInfoDict[heroTryOutId]
  end
  if self.armyFormationInfoDict == nil then
    self.armyFormationInfoDict = {}
  end
  local armyFormationInfo = HeroTryOutArmyFormationInfo.New(heroTryOutId)
  self.armyFormationInfoDict[heroTryOutId] = armyFormationInfo
  return armyFormationInfo
end

function HeroTryOutManager:SendHeroTryOutBattleMessage(heroTryOutId, heroIdDict)
  SFSNetwork.SendMessage(MsgDefines.HeroTryOutBattle, heroTryOutId, heroIdDict)
end

function HeroTryOutManager:OnHeroTryOutBattleMessageCallback(msg)
  if msg == nil then
    return
  end
  if msg.isWin == true then
    if self.userTryOutData == nil then
      self.userTryOutData = HeroTryOutData.New()
    end
    if not msg.info or not msg.info.heroTryOutArray then
      Logger.LogError("HeroTryOutManager:OnHeroTryOutBattleMessageCallback msg.info or msg.info.heroTryOutArray is nil")
      return
    end
    self.userTryOutData:UpdateData(msg.info.heroTryOutArray)
  end
  if msg.reward then
    DataCenter.RewardManager:AddRewardsAndRes(msg)
    DataCenter.TowerUpSaveDataManager.saveData = msg.reward
    EventManager:GetInstance():Broadcast(EventId.TowerupBattleReward, msg.reward)
  end
  local heroTryOutTemplate = self:GetLWHeroTryOutTemplateById(msg.id)
  if heroTryOutTemplate == nil then
    return
  end
  if heroTryOutTemplate.stage_type == 1 then
  elseif heroTryOutTemplate.stage_type == 2 and (msg.contentsArr or msg.content) then
    EventManager:GetInstance():Broadcast(EventId.HeroTryOutFakePVPBattleDataGet, msg)
  end
end

function HeroTryOutManager:GetBattleCacheReward()
  return self.battleRewardDataCache
end

function HeroTryOutManager:ClearBattleCacheReward()
  self.battleRewardDataCache = nil
end

function HeroTryOutManager:SetBattleCacheReward(rewardData)
  self.battleRewardDataCache = rewardData
end

function HeroTryOutManager:IsShowEntranceRedByHeroId(heroId)
  if not self:IsHasShownHeroDetailEntranceRed(heroId) then
    return true
  end
  local heroTryOutData = self:GetAllHeroTryOutIdDataByHeroId(heroId)
  if heroTryOutData ~= nil then
    local allOpenUnfinishTagTemplates = heroTryOutData:GetAllOpenUnfinishTagTemplates()
    for i, tagTemplate in ipairs(allOpenUnfinishTagTemplates) do
      if tagTemplate:IsShowNewRed() then
        return true
      end
    end
  end
  return false
end

function HeroTryOutManager:IsHasShownHeroDetailEntranceRed(heroId)
  local key = "hero_try_out_entrance_red_bool_show_" .. tostring(heroId)
  return CS.GameEntry.Setting:GetBool(key .. LuaEntry.Player.uid, false)
end

function HeroTryOutManager:SetHasShownHeroDetailEntranceRed(heroId)
  local key = "hero_try_out_entrance_red_bool_show_" .. tostring(heroId)
  CS.GameEntry.Setting:SetBool(key .. LuaEntry.Player.uid, true)
end

function HeroTryOutManager:SendHeroTryOutSkipMessage(heroId, tagId)
  SFSNetwork.SendMessage(MsgDefines.HeroTryOutSkip, heroId, tagId)
end

function HeroTryOutManager:OnHeroTryOutSkipMessageCallback(msg)
  if msg == nil then
    return
  end
  if msg.info and msg.info.heroTryOutArray then
    if self.userTryOutData == nil then
      self.userTryOutData = HeroTryOutData.New()
    end
    self.userTryOutData:UpdateData(msg.info.heroTryOutArray)
  end
  if msg.reward then
    DataCenter.RewardManager:AddRewardsAndRes(msg)
    DataCenter.RewardManager:ShowCommonReward(msg)
  end
  EventManager:GetInstance():Broadcast(EventId.HeroTryOutSkipSuccess, msg)
end

function HeroTryOutManager:PrintRealInfoLog(msg)
  Logger.LogInfo("HeroTryOut Info, Detail: " .. (msg or ""))
end

function HeroTryOutManager:OpenHeroDetail(heroId)
  local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
  local heroList = HeroUtils.GenerateHeroDataList(0)
  if heroData and heroData then
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIHeroDetailPanel) then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroDetailPanel)
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, heroData.uuid, heroList)
  else
    local meta = DataCenter.HeroTemplateManager:GetTemplate(heroId)
    if meta ~= nil and 0 < meta.fragId then
      if table.indexof(heroList, meta.fragId) == false then
        table.insert(heroList, meta.fragId)
      end
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIHeroDetailPanel) then
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroDetailPanel)
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, meta.fragId, heroList)
    end
  end
end

return HeroTryOutManager
