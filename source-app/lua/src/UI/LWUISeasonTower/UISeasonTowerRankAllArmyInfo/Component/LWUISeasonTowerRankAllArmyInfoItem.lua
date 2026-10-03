local LWUISeasonTowerRankAllArmyInfoItem = BaseClass("LWUISeasonTowerRankAllArmyInfoItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local LWSeasonTowerUtil = require("DataCenter.LWSeasonTowerManager.LWSeasonTowerUtil")
local content_path = "ScrollView/Viewport/Content"
local stage_text_path = "StageText"
local floor_text_path = "FloorText"
local empty_text_path = "EmptyText"

function LWUISeasonTowerRankAllArmyInfoItem:OnCreate()
  base.OnCreate(self)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.stage_text = self:AddComponent(UIText, stage_text_path)
  self.floor_text = self:AddComponent(UIText, floor_text_path)
  self.empty_text = self:AddComponent(UIText, empty_text_path)
  self.model = {}
end

function LWUISeasonTowerRankAllArmyInfoItem:OnDestroy()
  self:ClearHero()
  self.content = nil
  self.stage_text = nil
  self.floor_text = nil
  self.empty_text = nil
  base.OnDestroy(self)
end

function LWUISeasonTowerRankAllArmyInfoItem:SetData(data)
  self:ShowHeroList(data)
  local stageData = DataCenter.LWSeasonTowerManager:GetStageDataById(data.stageId)
  if stageData then
    local template = stageData:GetTemplate()
    self.stage_text:SetLocalText(template.name)
  end
  if data and data.floor then
    self.floor_text:SetText(Localization:GetString("season_tower_show_progress", data.floor))
  end
  if data and not table.IsNullOrEmpty(data.heroes) then
    self.empty_text:SetActive(false)
  else
    if stageData and stageData:IsStageOpen() then
      self.empty_text:SetLocalText("season_tower_rank_stage_none")
    else
      self.empty_text:SetLocalText("season_tower_rank_stage_lock")
    end
    self.empty_text:SetActive(true)
  end
end

function LWUISeasonTowerRankAllArmyInfoItem:ClearHero()
  self.content:RemoveComponents(UIHeroCellSmall)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

local NameCount = 1

function LWUISeasonTowerRankAllArmyInfoItem:ShowHeroList(unit)
  self:ClearHero()
  if unit == nil then
    return
  end
  local heroes = unit.heroes
  local heroList = table.values(heroes)
  if 0 < #heroList then
    table.sort(heroList, function(heroA, heroB)
      local indexA = heroA.index % 6
      local indexB = heroB.index % 6
      return indexA < indexB
    end)
    for _, heroInfo in pairs(heroList) do
      if self.model[_] == nil then
        self.model[_] = self:GameObjectInstantiateAsync(UIAssets.UIHeroCellSmall, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          go.gameObject:SetActive(true)
          go.transform:SetParent(self.content.transform)
          go.transform:Set_localScale(0.9, 0.9, 1)
          local nameStr = tostring(NameCount)
          go.name = nameStr
          NameCount = NameCount + 1
          local cell = self.content:AddComponent(UIHeroCellSmall, nameStr)
          cell:InitWithConfigId(heroInfo.heroId, nil, heroInfo.level, heroInfo.rankLv, heroInfo.weaponLevel, heroInfo.awakenLv, heroInfo.skinId)
        end)
      end
    end
  end
end

return LWUISeasonTowerRankAllArmyInfoItem
