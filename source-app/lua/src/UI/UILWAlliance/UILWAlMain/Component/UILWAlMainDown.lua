local UILWAlMainDown = BaseClass("UILWAlMainDown", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local MainDownItem = require("UI.UILWAlliance.UILWAlMain.Component.UILWAlMainDownItem")
local content_path = "BottomBtnContent"
local item_path = "BottomBtnItem"

function UILWAlMainDown:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlMainDown:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlMainDown:ComponentDefine()
  self.listContent = self:AddComponent(UIBaseContainer, content_path)
  self.listItemPrefab = self.transform:Find(item_path).gameObject
  self.listItemPrefab:GameObjectCreatePool()
end

function UILWAlMainDown:ComponentDestroy()
  self.listContent = nil
  self.listItemPrefab = nil
end

function UILWAlMainDown:DataDefine()
  self.btnCells = {}
end

function UILWAlMainDown:DataDestroy()
  self.btnCells = nil
end

function UILWAlMainDown:OnEnable()
  base.OnEnable(self)
end

function UILWAlMainDown:OnDisable()
  base.OnDisable(self)
end

function UILWAlMainDown:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlMainDown:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAlMainDown:ClearContent()
  self.listContent:RemoveComponents(MainDownItem)
end

function UILWAlMainDown:RefreshContent()
  self:ClearContent()
  self.listItemPrefab.gameObject:GameObjectRecycleAll()
  for k, v in ipairs(LWAlMainDownShowBtns) do
    if v ~= LWAlMainDownBtnType.Al_StarLog or not not DataCenter.AllianceStarManager:ShowAlStarLogItem() then
      local item = self.listItemPrefab:GameObjectSpawn(self.listContent.transform)
      item.name = "item" .. k
      local cell = self.listContent:AddComponent(MainDownItem, item.name)
      local params = {type = v}
      cell:SetData(params)
      self.btnCells[v] = cell
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.listContent.rectTransform)
  local param = self.view:GetUserData()
  if param and param.Guide then
    local target
    if param.Guide == "Setting" then
      target = self.btnCells[LWAlMainDownBtnType.Al_Setting]
      target = target and target.transform
    end
    if not IsNull(target) then
      local p = {
        position = target.position,
        arrowType = ArrowType.Capacity,
        positionType = PositionType.Screen
      }
      TimerManager:GetInstance():DelayInvoke(function()
        DataCenter.ArrowManager:ShowArrow(p)
      end, 0.1)
    end
  end
end

function UILWAlMainDown:GetDownBtnPosByType(type)
  if self.btnCells[type] then
    return self.btnCells[type].transform.position
  end
  return nil
end

return UILWAlMainDown
