local ArmyFormationDetailPowerTipsView = BaseClass("ArmyFormationDetailPowerTipsView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ArmyFormationPowerSourceItem = require("UI.ArmyFormationDetailPowerTips.Component.ArmyFormationDetailPowerSourceItem")
local SoliderNumTips = require("UI.ArmyFormationDetailPowerTips.Component.PowerDetailSoldierNumTips")
local UILWScienceDetailDesc = require("UI/UILWScience/UILWScienceDetail/Component/UILWScienceDetailDesc")
local tip_txt_path = "content/Scroll View/Viewport/Content/tipTxt"
local extra_power_conent_path = "content/Scroll View/Viewport/Content/extraPowerConent"
local power_conent_path = "content/Scroll View/Viewport/Content/powerConent"
local property_item_path = "content/Scroll View/Viewport/Content/PropertyItem"
local normal_power_name_path = "content/Scroll View/Viewport/Content/normalPowerInfo/normalPowerName"
local normal_power_value_path = "content/Scroll View/Viewport/Content/normalPowerInfo/normalPowerValue"
local extra_power_name_path = "content/Scroll View/Viewport/Content/ExtraPowerInfo/extraPowerName"
local extra_power_value_path = "content/Scroll View/Viewport/Content/ExtraPowerInfo/extraPowerValue"
local title_text_path = "content/Scroll View/Viewport/Content/titleText"
local u_i_soldier_num_tips_path = "content/Scroll View/Viewport/Content/UISoldierNumTips"
local solider_title_text_path = "content/Scroll View/Viewport/Content/soliderTitleText"
local content_path = "content/Scroll View/Viewport/Content"

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
  self.extra_power_content = self:AddComponent(UIBaseContainer, extra_power_conent_path)
  self.normalPowerNameText = self:AddComponent(UIText, normal_power_name_path)
  self.normalPowerValueText = self:AddComponent(UIText, normal_power_value_path)
  self.extraPowerNameText = self:AddComponent(UILWScienceDetailDesc, extra_power_name_path)
  self.extraPowerValueText = self:AddComponent(UIText, extra_power_value_path)
  
  local function ProcessDesc(desc)
    local modifiedText = string.gsub(desc, "<link=", string.format("<color=%s><u><link=", "#FFAC40"))
    modifiedText = string.gsub(modifiedText, "</link>", "</link></u></color>")
    return modifiedText
  end
  
  local des = Localization:GetString("power_display_new_003")
  des = ProcessDesc(des)
  self.extraPowerNameText:SetText(des)
  self.normalPowerNameText:SetLocalText("power_display_new_001")
  self.titleText = self:AddComponent(UIText, title_text_path)
  self.titleText:SetLocalText("power_stats_tip1")
  self.soliderNumTips = self:AddComponent(SoliderNumTips, u_i_soldier_num_tips_path)
  self.soldierTitleText = self:AddComponent(UIText, solider_title_text_path)
  self.soldierTitleText:SetLocalText(458291)
  self.scrollContent = self:AddComponent(UIBaseContainer, content_path)
end

local function ComponentDestroy(self)
  self:ClearCell()
  self.imgArrow = nil
  self.content = nil
  self.cellNode = nil
  self.tip_txt = nil
  self.power_conent = nil
  self.property_item = nil
  self.extra_power_content = nil
  self.normalPowerNameText = nil
  self.normalPowerValueText = nil
  self.extraPowerNameText = nil
  self.extraPowerValueText = nil
  self.titleText = nil
  self.soliderNumTips = nil
  self.soldierTitleText = nil
  self.scrollContent = nil
end

local function ClearCell(self)
  self.cellNode:GameObjectRecycleAll()
  self.power_conent:RemoveComponents(ArmyFormationPowerSourceItem)
  self.extra_power_content:RemoveComponents(ArmyFormationPowerSourceItem)
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
    contentPosY = arrowPosY - arrowSize.y + 3.6
  else
    self.imgArrow:SetEulerAnglesXYZ(0, 0, 180)
    contentPosY = arrowPosY + arrowSize.y - 6
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
  self.scrollContent:SetAnchoredPositionXY(0, 0, 0)
end

function ArmyFormationDetailPowerTipsView:RefreshContent()
  self:ClearCell()
  self:RefreshSoliderNumTips()
  self:RefreshNormalPowerContentInfo()
  self:RefreshExtraPowerContentInfo()
end

function ArmyFormationDetailPowerTipsView:RefreshSoliderNumTips()
  local isShowLackSoldierTip = self.param.soldierNumInfo.isShowLackSoldierTip or false
  self.soliderNumTips.gameObject:SetActive(isShowLackSoldierTip)
  self.soldierTitleText.gameObject:SetActive(isShowLackSoldierTip)
  if not isShowLackSoldierTip then
    return
  end
  self.soliderNumTips:RefreshUI(self.param.soldierNumInfo)
end

function ArmyFormationDetailPowerTipsView:RefreshNormalPowerContentInfo()
  local sourceShowData = {}
  local heroPower = self.param.sourceData.heroPower
  local armyPower = self.param.sourceData.armyPower
  local squadEquipPower = self.param.sourceData.squadEquipPower
  local otherPower = self.param.sourceData.otherPower
  local totalPower = self.param.sourceData.totalPower
  local dominatorPower = self.param.sourceData.dominatorPower
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
  for i, v in ipairs(sourceShowData) do
    if sourceShowData[i].val and not (0 >= sourceShowData[i].val) then
      local goObj = self.cellNode:GameObjectSpawn(self.power_conent.transform)
      goObj.name = "item_" .. i
      goObj:SetActive(true)
      local itemRender = self.power_conent:AddComponent(ArmyFormationPowerSourceItem, goObj.name)
      itemRender:Refresh(sourceShowData[i])
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.transform)
  self.normalPowerValueText:SetText(string.GetFormattedStr(totalPower))
end

function ArmyFormationDetailPowerTipsView:RefreshExtraPowerContentInfo()
  local extraPowerInfo = self.param.sourceData.extraPowerInfo
  local sourceShowData = {}
  local sciencePower = 0
  local allianceSciencePower = 0
  local masteryPower = 0
  local campPower = 0
  local battleFiledPower = 0
  for _, v in ipairs(extraPowerInfo) do
    if v.viewType == ExtraPowerInfoType.Science then
      sciencePower = v.value
    elseif v.viewType == ExtraPowerInfoType.AllianceScience then
      allianceSciencePower = v.value
    elseif v.viewType == ExtraPowerInfoType.Mastery then
      masteryPower = v.value
    elseif v.viewType == ExtraPowerInfoType.Camp then
      campPower = v.value
    elseif v.viewType == ExtraPowerInfoType.BattleField then
      battleFiledPower = v.value
    end
  end
  local totalExtraPower = sciencePower + allianceSciencePower + masteryPower + campPower + battleFiledPower
  if 0 < sciencePower then
    table.insert(sourceShowData, {name = 110292, val = sciencePower})
  end
  if 0 < allianceSciencePower then
    table.insert(sourceShowData, {
      name = "power_display_new_014",
      val = allianceSciencePower
    })
  end
  if 0 < masteryPower then
    table.insert(sourceShowData, {
      name = "power_display_new_015",
      val = masteryPower
    })
  end
  if 0 < campPower then
    table.insert(sourceShowData, {
      name = "power_display_new_006",
      val = campPower
    })
  end
  if 0 < battleFiledPower then
    table.insert(sourceShowData, {
      name = "power_display_new_005",
      val = battleFiledPower
    })
  end
  for i, v in ipairs(sourceShowData) do
    local goObj = self.cellNode:GameObjectSpawn(self.extra_power_content.transform)
    goObj.name = "item_" .. i
    goObj:SetActive(true)
    local itemRender = self.extra_power_content:AddComponent(ArmyFormationPowerSourceItem, goObj.name)
    itemRender:Refresh(sourceShowData[i])
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.extra_power_content.transform)
  self.extraPowerValueText:SetText("+" .. string.GetFormattedStr(math.floor(totalExtraPower)))
end

ArmyFormationDetailPowerTipsView.OnCreate = OnCreate
ArmyFormationDetailPowerTipsView.OnDestroy = OnDestroy
ArmyFormationDetailPowerTipsView.OnEnable = OnEnable
ArmyFormationDetailPowerTipsView.OnDisable = OnDisable
ArmyFormationDetailPowerTipsView.ComponentDefine = ComponentDefine
ArmyFormationDetailPowerTipsView.ComponentDestroy = ComponentDestroy
ArmyFormationDetailPowerTipsView.ClearCell = ClearCell
ArmyFormationDetailPowerTipsView.RefreshView = RefreshView
return ArmyFormationDetailPowerTipsView
