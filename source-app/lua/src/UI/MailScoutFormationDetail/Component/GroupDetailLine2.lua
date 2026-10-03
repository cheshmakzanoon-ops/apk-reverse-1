local base = UIBaseContainer
local GroupDetailLine2 = BaseClass("GroupDetailLine2", base)
local MailHeroWeaponCell = require("UI.UILWMail.UILWMailMain.Component.MailHeroWeaponCell")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DestroyCells()
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
  self.cellsContainer = self:AddComponent(UIBaseContainer, "cells")
  self.bottomLine = self:AddComponent(UIImage, "bottomLine")
end

local function ComponentDestroy(self)
  self.cellsContainer = nil
end

local function DataDefine(self)
  self.cellReqs = {}
end

local function DataDestroy(self)
end

local function DestroyCells(self)
  self.cellsContainer:RemoveComponents(MailHeroWeaponCell)
  if self.cellReqs then
    for i = 1, #self.cellReqs do
      self:GameObjectDestroy(self.cellReqs[i])
    end
    self.cellReqs = {}
  end
end

local function SetData(self, groupData)
  if not groupData then
    return
  end
  for i = 1, #groupData do
    local data = groupData[i]
    local cellReq = self:GameObjectInstantiateAsync(UIAssets.MailHeroWeaponCell, function(req)
      local obj = req.gameObject
      if IsNull(obj) then
        return
      end
      local name = "MailHeroWeaponCell" .. i
      obj.name = name
      local transform = obj.transform
      transform:SetParent(self.cellsContainer.transform)
      transform:Set_localScale(1, 1, 1)
      local obj = self.cellsContainer:AddComponent(MailHeroWeaponCell, name)
      obj:SetData(data.heroInfo.heroId, data.heroInfo:GetUniqueWeaponLv(), data.heroInfo.uwUnitLvMap, data.heroInfo:GetSkinId())
    end)
    self.cellReqs[i] = cellReq
  end
end

local function SetBottomLineActive(self, active)
  self.bottomLine:SetActive(active)
end

GroupDetailLine2.OnCreate = OnCreate
GroupDetailLine2.OnDestroy = OnDestroy
GroupDetailLine2.OnEnable = OnEnable
GroupDetailLine2.OnDisable = OnDisable
GroupDetailLine2.ComponentDefine = ComponentDefine
GroupDetailLine2.ComponentDestroy = ComponentDestroy
GroupDetailLine2.DataDefine = DataDefine
GroupDetailLine2.DataDestroy = DataDestroy
GroupDetailLine2.SetData = SetData
GroupDetailLine2.DestroyCells = DestroyCells
GroupDetailLine2.SetBottomLineActive = SetBottomLineActive
return GroupDetailLine2
