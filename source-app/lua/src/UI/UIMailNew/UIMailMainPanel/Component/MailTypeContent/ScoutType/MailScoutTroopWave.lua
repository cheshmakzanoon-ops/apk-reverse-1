local MailScoutTroopWave = BaseClass("MailScoutTroopWave", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local MailScoutHeroItem = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.ScoutType.MailScoutHeroItem")
local MailScoutTroopItem = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.ScoutType.MailScoutTroopItem")
local title_path = "Txt/Txt1"
local total_count_path = "Txt/Txt2"
local hero_container_path = "Txt/HeroList"
local troop_container_path = "TroopList"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.TitleN = self:AddComponent(UIText, title_path)
  self.TotalCountN = self:AddComponent(UIText, total_count_path)
  self.HeroContainerN = self:AddComponent(UIBaseContainer, hero_container_path)
  self.TroopContainerN = self:AddComponent(UIBaseContainer, troop_container_path)
end

local function ComponentDestroy(self)
  self.TitleN = nil
  self.TotalCountN = nil
  self.HeroContainerN = nil
  self.TroopContainerN = nil
end

local function DataDefine(self)
  self.HeroModels = {}
  self.HeroItemsList = {}
  self.TroopModels = {}
  self.TroopItemsList = {}
end

local function DataDestroy(self)
  self.HeroModels = nil
  self.HeroItemsList = nil
  self.TroopModels = nil
  self.TroopItemsList = nil
end

local function RefreshData(self, formation, user, waveIndex)
  if user then
    self.TitleN:SetLocalText(300643, user.abbr, user.name)
  else
    local nameStr = Localization:GetString("300621", waveIndex)
    if formation.specialUnitType ~= nil and formation.specialUnitType.value ~= nil and formation.specialUnitType.value == SpecialUnitType.BUILDING_STATION then
      nameStr = Localization:GetString("140311")
    end
    self.TitleN:SetText(nameStr)
  end
  if formation.soldierTotal then
    self.TotalCountN:SetLocalText(300625, string.GetFormattedStr(formation.soldierTotal.value))
  else
    self.TotalCountN:SetText("")
  end
  self:RefreshHeros(formation.hero)
  self:RefreshTroops(formation.soldier)
  EventManager:GetInstance():Broadcast(EventId.MailScoutReposition)
end

local function RefreshHeros(self, heros)
  if heros and table.length(heros) > 0 then
    self.HeroContainerN:SetActive(true)
  else
    self.HeroContainerN:SetActive(false)
    return
  end
  local list = heros
  self:SetAllHeroesDestroy()
  self.heroModelCount = 0
  if list ~= nil and 0 < #list then
    for i = 1, table.length(list) do
      self.heroModelCount = self.heroModelCount + 1
      self.HeroModels[self.heroModelCount] = self:GameObjectInstantiateAsync(UIAssets.MailScoutHeroItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.HeroContainerN.transform)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.HeroContainerN.transform)
        EventManager:GetInstance():Broadcast(EventId.MailScoutReposition)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = self.HeroContainerN:AddComponent(MailScoutHeroItem, nameStr)
        cell:RefreshData(list[i])
        table.insert(self.HeroItemsList, cell)
      end)
    end
  end
end

local function SetAllHeroesDestroy(self)
  self.HeroContainerN:RemoveComponents(MailScoutHeroItem)
  if self.HeroModels ~= nil then
    for k, v in pairs(self.HeroModels) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.HeroModels = {}
  self.HeroItemsList = {}
end

local function RefreshTroops(self, troops)
  if troops and table.length(troops) > 0 then
    self.TroopContainerN:SetActive(true)
  else
    self.TroopContainerN:SetActive(false)
    return
  end
  local list = troops
  self:SetAllTroopsDestroy()
  self.troopModelCount = 0
  if list ~= nil and 0 < #list then
    for i = 1, table.length(list) do
      self.troopModelCount = self.troopModelCount + 1
      self.TroopModels[self.troopModelCount] = self:GameObjectInstantiateAsync(UIAssets.MailScoutTroopItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.TroopContainerN.transform)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.TroopContainerN.transform)
        EventManager:GetInstance():Broadcast(EventId.MailScoutReposition)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = self.TroopContainerN:AddComponent(MailScoutTroopItem, nameStr)
        cell:RefreshData(list[i])
        table.insert(self.TroopItemsList, cell)
      end)
    end
  end
end

local function SetAllTroopsDestroy(self)
  self.TroopContainerN:RemoveComponents(MailScoutTroopItem)
  if self.TroopModels ~= nil then
    for k, v in pairs(self.TroopModels) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.TroopModels = {}
  self.TroopItemsList = {}
end

MailScoutTroopWave.OnCreate = OnCreate
MailScoutTroopWave.OnDestroy = OnDestroy
MailScoutTroopWave.OnEnable = OnEnable
MailScoutTroopWave.OnDisable = OnDisable
MailScoutTroopWave.ComponentDefine = ComponentDefine
MailScoutTroopWave.ComponentDestroy = ComponentDestroy
MailScoutTroopWave.DataDefine = DataDefine
MailScoutTroopWave.DataDestroy = DataDestroy
MailScoutTroopWave.RefreshData = RefreshData
MailScoutTroopWave.RefreshHeros = RefreshHeros
MailScoutTroopWave.RefreshTroops = RefreshTroops
MailScoutTroopWave.SetAllHeroesDestroy = SetAllHeroesDestroy
MailScoutTroopWave.SetAllTroopsDestroy = SetAllTroopsDestroy
return MailScoutTroopWave
