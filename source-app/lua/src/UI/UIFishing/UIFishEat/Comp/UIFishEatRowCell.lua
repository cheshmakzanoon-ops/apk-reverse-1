local base = UIBaseContainer
local UIFishEatFishCell = require("UI.UIFishing.UIFishEat.Comp.UIFishEatFishCell")
local UIFishEatRowCell = BaseClass("UIFishEatRowCell", UIBaseContainer)

function UIFishEatRowCell:ComponentDefine()
  local template_fish_path = "template_fish"
  local p_trans_root_path = "p_trans_root"
  self.template_fish = self:AddComponent(UIBaseContainer, template_fish_path)
  self.p_trans_root = self:AddComponent(UIGameObjectPoolRoot, p_trans_root_path)
end

function UIFishEatRowCell:ComponentDestroy()
  self.template_fish = nil
  self.p_trans_root = nil
end

function UIFishEatRowCell:DataDefine()
end

function UIFishEatRowCell:DataDestroy()
end

function UIFishEatRowCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIFishEatRowCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIFishEatRowCell:OnAddListener()
  base.OnAddListener(self)
end

function UIFishEatRowCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIFishEatRowCell:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function UIFishEatRowCell:InitData(data)
  if data ~= nil then
    self.Data = data
    return true
  end
  return false
end

function UIFishEatRowCell:InitUi()
  self.p_trans_root:Init(self.template_fish.gameObject, UIFishEatFishCell)
  self.p_trans_root:Clear()
  if not table.IsNullOrEmpty(self.Data.Fishes) then
    for _, fishCell in pairs(self.Data.Fishes) do
      local data = {}
      data.Fish = fishCell
      self.p_trans_root:AddData(data)
    end
  end
end

function UIFishEatRowCell:UpdateData()
end

function UIFishEatRowCell:UpdateUi()
end

return UIFishEatRowCell
