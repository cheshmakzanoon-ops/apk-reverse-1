local FormationDominatorLineV2 = BaseClass("FormationDominatorLineV2", UIAsyncContainer)
local base = UIAsyncContainer
local UIHeroCell = require("UI.UIHero2.Common.UIHeroCellSmall")

function FormationDominatorLineV2:OnCreate()
  base.OnCreate(self)
  self.dominatorCell = self:AddComponent(UIHeroCell, "FormationSelectHeroItem/UIHeroCellSmall")
  self.supplyBar = self:AddComponent(UISlider, "Slider")
  self.supply_num_txt = self:AddComponent(UIText, "loadNum")
  self:SetAsFirstSibling()
  self:SetLocalScaleXYZ(0.9, 0.9, 0.9)
end

function FormationDominatorLineV2:OnDestroy()
  self.dominatorCell = nil
  self.supplyBar = nil
  self.supply_num_txt = nil
  base.OnDestroy(self)
end

function FormationDominatorLineV2:UpdateData()
  if not self:AsyncLoadDone() then
    return
  end
  if self.uuid then
    self:InitData(self.uuid)
  end
  if self.supply and self.fixedSoldierType then
    self:SetSupply(self.supply, self.fixedSoldierType)
  end
end

function FormationDominatorLineV2:InitData(dominatorUuid)
  if self.uuid ~= dominatorUuid then
    self.uuid = dominatorUuid
  end
  if self.dominatorCell and self:AsyncLoadDone() then
    local dominatorInfo = DataCenter.DominatorManager:GetInfoByUuid(dominatorUuid)
    self.dominatorInfo = dominatorInfo
    if dominatorInfo then
      self:SetActive(true)
      local heroId = dominatorInfo.dominatorId
      local rankLv = dominatorInfo.rankLv
      self.dominatorCell:InitWithConfigId(heroId, nil, nil, rankLv)
    else
      self:SetActive(false)
    end
  end
end

function FormationDominatorLineV2:SetSupply(supply, fixedSoldierType)
  local _supply = supply or 0
  if self.supply ~= _supply then
    self.supply = _supply
  end
  if self.fixedSoldierType ~= fixedSoldierType then
    self.fixedSoldierType = fixedSoldierType
  end
  if self.supplyBar and self.supply_num_txt and self:AsyncLoadDone() then
    if self.dominatorInfo then
      local capacity = self.dominatorInfo:GetSoldierCapacity()
      if self.fixedSoldierType == SoldierType.Mummy then
        local s3_mummy_config_k7 = SeasonUtil.GetMummyConfigNum("k7", 1)
        if s3_mummy_config_k7 ~= nil and s3_mummy_config_k7 ~= 0 and s3_mummy_config_k7 ~= 1 then
          capacity = math.ceil(capacity / s3_mummy_config_k7)
        end
      end
      _supply = math.min(_supply, capacity)
      self.supplyBar:SetValue(_supply / capacity)
      self.supply_num_txt:SetText(math.floor(_supply))
    else
      self.supplyBar:SetValue(0)
      self.supply_num_txt:SetText("0")
    end
  end
end

return FormationDominatorLineV2
