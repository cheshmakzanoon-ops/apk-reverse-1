local base = UIBaseContainer
local UITruckRewardInsuranceRewardShell = BaseClass("UITruckRewardInsuranceRewardShell", UIBaseContainer)
local root_path = "Root"
local lock_icon_path = "lock_icon"
local obj_path = ""

function UITruckRewardInsuranceRewardShell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UITruckRewardInsuranceRewardShell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITruckRewardInsuranceRewardShell:ComponentDefine()
  self.compRoot = self:AddComponent(UIBaseContainer, root_path)
  self.lock_icon = self:AddComponent(UIImage, lock_icon_path)
  self.obj = self:AddComponent(UIBaseContainer, obj_path)
end

function UITruckRewardInsuranceRewardShell:ComponentDestroy()
  self.compRoot = nil
  self.lock_icon = nil
  self.obj = nil
end

function UITruckRewardInsuranceRewardShell:DataDefine()
  self.itemGo = nil
  self.itemScript = nil
end

function UITruckRewardInsuranceRewardShell:DataDestroy()
  self:ClearContent()
  if self.effectReq ~= nil then
    self:GameObjectDestroy(self.effectReq)
  end
  self.effectReq = nil
end

function UITruckRewardInsuranceRewardShell:OnAddListener()
  base.OnAddListener(self)
end

function UITruckRewardInsuranceRewardShell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UITruckRewardInsuranceRewardShell:ClearContent()
  self.compRoot:RemoveComponents(UICommonResItem)
  if self.itemGo ~= nil then
    self:GameObjectDestroy(self.itemGo)
    self.itemGo = nil
  end
  self.itemScript = nil
end

function UITruckRewardInsuranceRewardShell:SetData(reward)
  self:ClearContent()
  self.itemGo = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
    if req == nil or IsNull(req.gameObject) then
      return
    end
    local item = req.gameObject
    item.name = "reward_item"
    item:SetActive(true)
    item.transform:SetParent(self.compRoot.transform)
    item.transform:Set_localScale(0.9, 0.9, 0.9)
    item.transform:Set_sizeDelta(118, 118)
    item.transform:Set_pivot(0.5, 0.5)
    local cell = self.compRoot:AddComponent(UICommonResItem, item.name)
    cell:SetAnchoredPositionXY(0, 0)
    cell:SetAnchorMinXY(0.5, 0.5)
    cell:SetAnchorMaxXY(0.5, 0.5)
    cell:ReInit(reward)
  end)
  local isOpen = DataCenter.MonthCardNewManager:CheckIfMonthCardActive()
  self.lock_icon:SetActive(not isOpen)
  self:SetEffectState(true)
end

function UITruckRewardInsuranceRewardShell:SetEffectState(state)
  if self.effectGo then
    self.effectGo:SetActive(state)
  else
    if self.effectReq ~= nil then
      self:GameObjectDestroy(self.effectReq)
    end
    self.effectReq = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/Act2025Halloween/Effect/Eff_ui_duobao_jiangli_faguang.prefab", function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.obj.transform)
      go.name = NameCount
      NameCount = NameCount + 1
      local cell = self.obj:AddComponent(UIBaseContainer, go.name)
      cell:SetAnchoredPositionXY(0, 0)
      cell:SetLocalScaleXYZ(1.3, 1.3, 1.3)
      self.effectGo = cell
      self.effectGo:SetActive(true)
    end)
  end
end

return UITruckRewardInsuranceRewardShell
