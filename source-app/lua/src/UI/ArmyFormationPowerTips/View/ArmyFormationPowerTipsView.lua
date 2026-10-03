local ArmyFormationPowerTipsView = BaseClass("ArmyFormationPowerTipsView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ArmyFormationPowerSourceItem = require("UI.ArmyFormationPowerTips.Component.ArmyFormationPowerSourceItem")
local tip_txt_path = "content/tipTxt"
local power_conent_path = "content/powerConent"
local property_item_path = "content/PropertyItem"
local defaultWidth = 810
local Screen = CS.UnityEngine.Screen

local function OnCreate(self)
  base.OnCreate(self)
  self.param = self:GetUserData()
  self:ComponentDefine()
  self:RefreshView()
end

local function OnDestroy(self)
  self.param = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
end

local function OnDisable(self)
end

local function ComponentDefine(self)
  local btnPanel = self:AddComponent(UIButton, "Panel")
  btnPanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.imgArrow = self:AddComponent(UIBaseContainer, "ImgArrow")
  self.content = self:AddComponent(UIBaseContainer, "content")
  self.property_item = self:AddComponent(UIBaseContainer, property_item_path)
  self.cellNode = self.property_item.gameObject
  self.cellNode:GameObjectCreatePool()
  self.tip_txt = self:AddComponent(UITextMeshProUGUIEx, tip_txt_path)
  self.power_conent = self:AddComponent(UIBaseContainer, power_conent_path)
end

local function ComponentDestroy(self)
  self:ClearCell()
  self.imgArrow = nil
  self.content = nil
  self.cellNode = nil
  self.tip_txt = nil
  self.power_conent = nil
  self.property_item = nil
end

local function ClearCell(self)
  self.cellNode:GameObjectRecycleAll()
  self.power_conent:RemoveComponents(ArmyFormationPowerSourceItem)
end

local function RefreshView(self)
  if self.param == nil then
    return
  end
  self:RefreshContent()
  local position = self.param.position
  local deltaX = self.param.deltaX
  local deltaY = self.param.deltaY
  self.imgArrow:SetPositionXYZ(position.x, position.y, 0)
  local anchoredPosition = self.imgArrow:GetAnchoredPosition()
  local arrowSize = self.imgArrow.rectTransform.rect.size
  local contentSize = self.content.rectTransform.rect.size
  local arrowPosX = anchoredPosition.x + deltaX
  local arrowPosY = anchoredPosition.y + deltaY
  local contentPosX = 0
  local contentPosY = 0
  self.imgArrow:SetAnchoredPositionXY(arrowPosX, arrowPosY)
  if anchoredPosition.y > 0 then
    self.imgArrow:SetEulerAnglesXYZ(0, 0, 0)
    contentPosY = arrowPosY - arrowSize.y / 2 - contentSize.y / 2 + 3.6
  else
    self.imgArrow:SetEulerAnglesXYZ(0, 0, 180)
    contentPosY = arrowPosY + arrowSize.y / 2 + contentSize.y / 2 - 6
  end
  local normalContentlDeltaX = 100
  local maxContentlPosX = 390 - contentSize.x / 2
  if anchoredPosition.x > 0 then
    contentPosX = arrowPosX - normalContentlDeltaX
    contentPosX = math.min(contentPosX, maxContentlPosX)
  else
    contentPosX = arrowPosX + normalContentlDeltaX
    contentPosX = math.max(contentPosX, -maxContentlPosX)
  end
  self.content:SetAnchoredPositionXY(contentPosX, contentPosY, 0)
end

function ArmyFormationPowerTipsView:RefreshContent()
  local sourceShowData = {}
  local heroPower = self.param.sourceData.heroPower
  local armyPower = self.param.sourceData.armyPower
  local squadEquipPower = self.param.sourceData.squadEquipPower
  local otherPower = self.param.sourceData.otherPower
  local dominatorPower = self.param.sourceData.dominatorPower or 0
  local isFakeArmyPower = self.param.sourceData.isFakeArmyPower
  local tipTxtKey = "power_stats_35"
  if isFakeArmyPower then
    tipTxtKey = "power_stats_35"
  else
    tipTxtKey = "power_stats_36"
  end
  self.tip_txt:SetLocalText(tipTxtKey)
  if 0 < heroPower then
    table.insert(sourceShowData, {
      name = "power_stats_31",
      val = heroPower
    })
  end
  if 0 < armyPower then
    table.insert(sourceShowData, {
      name = "power_stats_32",
      val = armyPower
    })
  end
  if 0 < squadEquipPower then
    table.insert(sourceShowData, {
      name = "power_stats_33",
      val = squadEquipPower
    })
  end
  if 0 < dominatorPower then
    table.insert(sourceShowData, {
      name = "dominator_power",
      val = dominatorPower
    })
  end
  if 0 < otherPower then
    table.insert(sourceShowData, {
      name = "power_stats_34",
      val = otherPower
    })
  end
  self:ClearCell()
  for i, v in ipairs(sourceShowData) do
    local goObj = self.cellNode:GameObjectSpawn(self.power_conent.transform)
    goObj.name = "item_" .. i
    goObj:SetActive(true)
    local itemRender = self.power_conent:AddComponent(ArmyFormationPowerSourceItem, goObj.name)
    itemRender:Refresh(sourceShowData[i])
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.transform)
end

ArmyFormationPowerTipsView.OnCreate = OnCreate
ArmyFormationPowerTipsView.OnDestroy = OnDestroy
ArmyFormationPowerTipsView.OnEnable = OnEnable
ArmyFormationPowerTipsView.OnDisable = OnDisable
ArmyFormationPowerTipsView.ComponentDefine = ComponentDefine
ArmyFormationPowerTipsView.ComponentDestroy = ComponentDestroy
ArmyFormationPowerTipsView.ClearCell = ClearCell
ArmyFormationPowerTipsView.RefreshView = RefreshView
return ArmyFormationPowerTipsView
