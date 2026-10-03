local EquipRecommendManager = BaseClass("EquipRecommendManager")
local Localization = CS.GameEntry.Localization
local EquipRecommendTemplate = require("DataCenter/EquipData/EquipRecommendTemplate")
local EquipRecommendData = require("DataCenter/EquipData/EquipRecommendData")

function EquipRecommendManager:__init()
  self.curSquadIndexList = {}
  self.recommendTemplateGroupDict = {}
  self.recommendTemplateDict = {}
  self.isRecommendDirty = true
  self.cacheData = nil
  self.recommendOpen = nil
end

function EquipRecommendManager:__delete()
  self.curSquadIndexList = nil
  self.recommendTemplateGroupDict = nil
  self.recommendTemplateDict = nil
  self.isRecommendDirty = nil
  self.cacheData = nil
  self.recommendOpen = nil
end

function EquipRecommendManager:InitSwitch(message)
  if message == nil then
    return
  end
  if message.recommendOpen ~= nil then
    self.recommendOpen = message.recommendOpen
  end
  if message.formationIndexArray ~= nil then
    self.curSquadIndexList = message.formationIndexArray
  end
end

function EquipRecommendManager:IsFunctionOpen()
  if self.recommendOpen ~= nil and self.recommendOpen == true then
    return true
  end
  return false
end

function EquipRecommendManager:GetCurSquadIndex()
  if not table.IsNullOrEmpty(self.curSquadIndexList) then
    return self.curSquadIndexList[1]
  end
end

function EquipRecommendManager:SendSetCurSquadIndexMessage(squadIndex)
  if not self:IsFunctionOpen() then
    return
  end
  local curSquad = self:GetCurSquadIndex()
  if curSquad == squadIndex then
    return
  end
  if squadIndex == 0 then
    UIUtil.ShowMessage(Localization:GetString("equip_recommend_desc_5"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      SFSNetwork.SendMessage(MsgDefines.HeroEquipRecommendSwitch, squadIndex)
    end, function()
    end)
  elseif curSquad ~= nil and 0 < curSquad then
    UIUtil.ShowMessage(Localization:GetString("equip_recommend_desc_4", tostring(curSquad)), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      SFSNetwork.SendMessage(MsgDefines.HeroEquipRecommendSwitch, squadIndex)
    end, function()
    end)
  else
    SFSNetwork.SendMessage(MsgDefines.HeroEquipRecommendSwitch, squadIndex)
  end
end

function EquipRecommendManager:OnSetSquadIndexCallback(message)
  if message == nil then
    return
  end
  if message.formationIndexArray ~= nil then
    self.curSquadIndexList = message.formationIndexArray
  end
  self:SetRecommendDataDirty()
  EventManager:GetInstance():Broadcast(EventId.HeroEquipRecommendSwitchSuccess)
end

function EquipRecommendManager:OnFunctionOpenPushCallback(message)
  if message == nil then
    return
  end
  if message.recommendOpen ~= nil then
    self.recommendOpen = message.recommendOpen
  end
  self:SetRecommendDataDirty()
  EventManager:GetInstance():Broadcast(EventId.HeroEquipRecommendFunctionOpenChanged)
end

function EquipRecommendManager:GetTemplate(id)
  if id == nil or id <= 0 then
    return nil
  end
  if self.recommendTemplateDict[id] == nil then
    local line = LocalController:instance():getLine(TableName.EQUIP_RECOMMEND, id)
    if line ~= nil then
      self.recommendTemplateDict[id] = EquipRecommendTemplate.New()
      self.recommendTemplateDict[id]:UpdateData(line)
    end
  end
  return self.recommendTemplateDict[id]
end

function EquipRecommendManager:GetTemplateByOrderAndGroup(order, groupId)
  local allTemplates = self:GetTemplateListByGroup(groupId)
  if not table.IsNullOrEmpty(allTemplates) then
    for i, v in pairs(allTemplates) do
      if v.order == order then
        return v
      end
    end
  end
end

function EquipRecommendManager:GetTemplateListByGroup(groupId)
  groupId = tostring(groupId)
  if self.recommendTemplateGroupDict[groupId] == nil then
    self.recommendTemplateGroupDict[groupId] = {}
    LocalController:instance():visitTable(TableName.EQUIP_RECOMMEND, function(id, lineData)
      local group = tostring(lineData:getValue("group_id") or 0)
      if group == groupId then
        local template = self:GetTemplate(id)
        if template then
          table.insert(self.recommendTemplateGroupDict[groupId], template)
        end
      end
    end)
    table.sort(self.recommendTemplateGroupDict[groupId], function(a, b)
      return a.order < b.order
    end)
  end
  return self.recommendTemplateGroupDict[groupId]
end

function EquipRecommendManager:SetRecommendDataDirty()
  self.isRecommendDirty = true
end

function EquipRecommendManager:TryUpdateRecommendData()
  if self.isRecommendDirty or self.cacheData == nil then
    if self.cacheData == nil then
      self.cacheData = EquipRecommendData.New()
    end
    local curSquadIndex = self:GetCurSquadIndex()
    self.cacheData:Reset(curSquadIndex)
  end
  self.isRecommendDirty = false
end

function EquipRecommendManager:IsShowRecommend(heroData, equipData)
  if not self:IsFunctionOpen() then
    return false
  end
  if heroData == nil or equipData == nil then
    return false
  end
  local squadIndex = DataCenter.ArmyFormationDataManager:GetHeroSquadIndex(heroData.uuid)
  local curSelectSquadIndex = self:GetCurSquadIndex()
  local isSameSquad = curSelectSquadIndex ~= nil and squadIndex ~= nil and squadIndex == curSelectSquadIndex
  if not isSameSquad then
    return false
  end
  self:TryUpdateRecommendData()
  return self.cacheData:IsShowRecommend(heroData, equipData)
end

function EquipRecommendManager:IsShowRecommendByHero(heroData)
  if not self:IsFunctionOpen() then
    return false
  end
  if heroData == nil then
    return false
  end
  local squadIndex = DataCenter.ArmyFormationDataManager:GetHeroSquadIndex(heroData.uuid)
  local curSelectSquadIndex = self:GetCurSquadIndex()
  local isSameSquad = curSelectSquadIndex ~= nil and squadIndex ~= nil and squadIndex == curSelectSquadIndex
  if not isSameSquad then
    return false
  end
  self:TryUpdateRecommendData()
  return self.cacheData:IsShowRecommendByHero(heroData)
end

function EquipRecommendManager:GetGroupIdByHero(heroUuid)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
  if heroData ~= nil then
    local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(heroData.heroId)
    if heroTemplate ~= nil then
      return heroTemplate:GetEquipRecommendGroup()
    end
  end
end

function EquipRecommendManager:GetTemplateListByHero(heroUuid)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
  if heroData ~= nil then
    local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(heroData.heroId)
    if heroTemplate ~= nil then
      return self:GetTemplateListByGroup(heroTemplate:GetEquipRecommendGroup())
    end
  end
end

function EquipRecommendManager:GetSquadText(squad)
  if squad == 1 then
    return Localization:GetString("800351")
  end
  if squad == 2 then
    return Localization:GetString("800352")
  end
  if squad == 3 then
    return Localization:GetString("800353")
  end
  if squad == 4 then
    return Localization:GetString("800354")
  end
  return ""
end

function EquipRecommendManager:GetMaxPowerSquadIndex()
  local powerDict = {}
  for squad = 1, 4 do
    local power = 0
    local squadData = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByIndex(squad)
    if squadData ~= nil then
      local heroes = squadData:GetLocalAllHeroes()
      for i = 1, 5 do
        if heroes[i] ~= nil then
          local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroes[i])
          if heroData ~= nil then
            power = power + heroData.power
          end
        end
      end
      power = power + squadData:GetEquipCapacity() + squadData:GetTWSkillChipCapacity() + squadData:GetVirtualConscriptSoldierPower()
    end
    table.insert(powerDict, {squad = squad, power = power})
  end
  local maxSquad
  for i, v in pairs(powerDict) do
    if maxSquad == nil or v.power > maxSquad.power then
      maxSquad = v
    end
  end
  if maxSquad ~= nil then
    return maxSquad.squad
  end
  return 1
end

return EquipRecommendManager
