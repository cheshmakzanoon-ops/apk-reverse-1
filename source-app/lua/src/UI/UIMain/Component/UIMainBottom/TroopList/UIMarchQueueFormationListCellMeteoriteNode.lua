local UIMarchQueueFormationListCellMeteoriteNode = BaseClass("UIMarchQueueFormationListCellMeteoriteNode", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local tmp_crystal_count_path = "imgBg/imgIconCrystal/tmpCrystalCount"
local tmp_nucleus_count_path = "imgBg/imgIconNucleus/tmpNucleusCount"

local function OnCreate(self)
  base.OnCreate(self)
  self.tmp_crystal_count = self:AddComponent(UITextMeshProUGUIEx, tmp_crystal_count_path)
  self.tmp_nucleus_count = self:AddComponent(UITextMeshProUGUIEx, tmp_nucleus_count_path)
end

local function OnDestroy(self)
  self.tmp_crystal_count = nil
  self.tmp_nucleus_count = nil
  base.OnDestroy(self)
end

function UIMarchQueueFormationListCellMeteoriteNode:SetCount(crystal, nucleus)
  if self.tmp_crystal_count then
    self.tmp_crystal_count:SetText(string.format("x%s", crystal))
  end
  if self.tmp_nucleus_count then
    self.tmp_nucleus_count:SetText(string.format("x%s", nucleus))
  end
end

UIMarchQueueFormationListCellMeteoriteNode.OnCreate = OnCreate
UIMarchQueueFormationListCellMeteoriteNode.OnDestroy = OnDestroy
return UIMarchQueueFormationListCellMeteoriteNode
