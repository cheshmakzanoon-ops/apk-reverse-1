local base = UIBaseContainer
local BattleHelperUniversalItem = BaseClass("BattleHelperUniversalItem", base)
local BattleHelperEnumtype = require("UI.UILWMail.UILWMailMain.Component.BattleAIHelperComs.BattleHelperEnumtype")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:UnloadInfoItem()
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
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function UnloadInfoItem(self)
  if self.curInfoItem then
    self:RemoveAllComponentes()
    self.curInfoItem = nil
  end
  if self.curInfoItemReq then
    self:GameObjectDestroy(self.curInfoItemReq)
    self.curInfoItemReq = nil
  end
  self.curType = nil
end

local ITEM_NAME = "InfoItem"

local function ReInit(self, data)
  local typeTemplate = data.type
  if not typeTemplate then
    return
  end
  if self.curType ~= nil and self.curType ~= data.type then
    self:UnloadInfoItem()
  end
  if self.curInfoItem then
    local setDataFuncName = typeTemplate.SetDataFuncName
    if setDataFuncName then
      self.curInfoItem[setDataFuncName](self.curInfoItem, data.info)
    end
  else
    self.curInfoItemReq = self:GameObjectInstantiateAsync(typeTemplate.prefabPath, function(request)
      local go = request.gameObject
      if IsNull(go) then
        return
      end
      local transform = go.transform
      transform:SetParent(self.transform)
      local scale = 1
      if typeTemplate.scale then
        scale = typeTemplate.scale
      end
      transform:Set_localScale(scale, scale, scale)
      transform:Set_localPosition(0, 0, 0)
      transform:Set_pivot(0.5, 0.5)
      if typeTemplate.width and typeTemplate.height then
        transform:Set_sizeDelta(typeTemplate.width, typeTemplate.height)
      end
      go.name = ITEM_NAME
      local cls = require(typeTemplate.scriptPath)
      if typeTemplate.scriptPath == "UI.UICommonResItem.UICommonResItem" then
        cls = UICommonResItem
      end
      self.curInfoItem = self:AddComponent(cls, ITEM_NAME)
      local setDataFuncName = typeTemplate.SetDataFuncName
      local setDataNeedUnpack = typeTemplate.SetDataNeedUnpack
      if setDataFuncName then
        if setDataNeedUnpack then
          self.curInfoItem[setDataFuncName](self.curInfoItem, table.unpack(data.info))
        else
          self.curInfoItem[setDataFuncName](self.curInfoItem, data.info)
        end
      end
    end)
  end
end

BattleHelperUniversalItem.OnCreate = OnCreate
BattleHelperUniversalItem.OnDestroy = OnDestroy
BattleHelperUniversalItem.OnEnable = OnEnable
BattleHelperUniversalItem.OnDisable = OnDisable
BattleHelperUniversalItem.ComponentDefine = ComponentDefine
BattleHelperUniversalItem.ComponentDestroy = ComponentDestroy
BattleHelperUniversalItem.DataDefine = DataDefine
BattleHelperUniversalItem.DataDestroy = DataDestroy
BattleHelperUniversalItem.ReInit = ReInit
BattleHelperUniversalItem.UnloadInfoItem = UnloadInfoItem
return BattleHelperUniversalItem
