local base = UIBaseContainer
local TacticalChipSquadItem = BaseClass("TacticalChipSquadItem", UIBaseContainer)
local UIHeroCell = require("UI.UIHero2.Common.UIHeroCellSmall")
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")
local ArmyFormationUtils = require("DataCenter.ArmyFormationData.ArmyFormationUtils")
local SQUAD_INDEX_ICON_PATH_FORMAT = "Assets/Main/Sprites/UI/LWUITacticalWeaponChip/FX_wurenjixingpian_fenpeibiandui0%s.png"
local Localization = CS.GameEntry.Localization
local btn_path = "btn"

function TacticalChipSquadItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function TacticalChipSquadItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TacticalChipSquadItem:ComponentDefine()
  self.compSelectFlag = self:AddComponent(UIBaseContainer, "selectFlag")
  self.compUnSelectFlag = self:AddComponent(UIBaseContainer, "unSelectFlag")
  self.compHeroBgNode = self:AddComponent(UIBaseContainer, "heroBgNode")
  self.compHeroListNode = self:AddComponent(UIBaseContainer, "heroListNode")
  self.textSquadName = self:AddComponent(UITextMeshProUGUIEx, "squadName")
  self.textPower = self:AddComponent(UITextMeshProUGUIEx, "powerNode/powerText")
  self.imgSquadIndexFlag = self:AddComponent(UIImage, "unSelectFlag/squadIndexFlag")
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
end

function TacticalChipSquadItem:ComponentDestroy()
  self.compSelectFlag = nil
  self.compUnSelectFlag = nil
  self.compHeroBgNode = nil
  self.compHeroListNode = nil
  self.textSquadName = nil
  self.textPower = nil
  self.imgSquadIndexFlag = nil
end

function TacticalChipSquadItem:DataDefine()
end

function TacticalChipSquadItem:DataDestroy()
  self.onSquadUseClickHandler = nil
  self.compHeroListNode:RemoveComponents(UIHeroCell)
  self.reqList = nil
end

function TacticalChipSquadItem:OnAddListener()
  base.OnAddListener(self)
end

function TacticalChipSquadItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function TacticalChipSquadItem:ReInit(data, planId)
  if data == nil then
    return
  end
  self.planId = planId
  self.data = data
  self.dataList = data.heroes
  if self.reqList == nil then
    self.reqList = {}
    local index = 0
    for uuid, pos in pairs(self.dataList) do
      self.reqList[index] = self:CreateItem(index, uuid)
      index = index + 1
    end
  end
  local totalCombatPower = data:GetParkingTotalCapacity()
  self.textPower:SetText(string.GetFormattedStr2(totalCombatPower))
  local squadIndex = TacticalWeaponUtils.GetUsingFormationByTypeAndSet(FormationDataType.ArmyFormation, planId)
  self:SetSelect(squadIndex == data.index)
  self.imgSquadIndexFlag:SetActive(false)
  local formationData = ArmyFormationUtils.GetArmyFormationDataByEnterWay(TWSkillChipFormationType.ArmyFormation, data.index)
  if formationData then
    local useSetId = formationData:GetLocalTWSkillChipSetId()
    if useSetId and 0 < useSetId then
      self.imgSquadIndexFlag:LoadSprite(string.format(SQUAD_INDEX_ICON_PATH_FORMAT, useSetId))
      self.imgSquadIndexFlag:SetActive(true)
    end
  end
  self.textSquadName:SetLocalText(HeroParkingSquadNameId[data.index])
end

function TacticalChipSquadItem:CreateItem(index, uuid)
  return self:GameObjectInstantiateAsync(UIAssets.UIHeroCellSmall, function(request)
    local go = request.gameObject
    if IsNull(go) then
      return
    end
    go.gameObject:SetActive(true)
    go.transform:SetParent(self.compHeroListNode.transform)
    go.transform:Set_localScale(0.85, 0.85, 1)
    go.name = "hero" .. index
    local cell = self.compHeroListNode:AddComponent(UIHeroCell, go.name)
    cell:Reinit({heroUuid = uuid})
  end)
end

function TacticalChipSquadItem:SetSelect(visible)
  self.compSelectFlag:SetActive(visible)
  self.compUnSelectFlag:SetActive(not visible)
end

function TacticalChipSquadItem:SetOnSquadUseClickHandler(handler)
  self.onSquadUseClickHandler = handler
end

function TacticalChipSquadItem:OnClick()
  local usingFormation = TacticalWeaponUtils.GetUsingFormationByTypeAndSet(FormationDataType.ArmyFormation, self.planId)
  if usingFormation == self.data.index then
    return
  end
  if not self.data:IsFree() then
    UIUtil.ShowTipsId("drone_skillChip_title_11")
    return
  end
  local formationType = FormationDataType.ArmyFormation
  local prevUsingChipSetId = self.data:GetLocalTWSkillChipSetId()
  if usingFormation and 0 < usingFormation then
    local otherSquadData = ArmyFormationUtils.GetArmyFormationDataByEnterWay(formationType, usingFormation)
    if not otherSquadData then
      return
    end
    if not otherSquadData:IsFree() then
      UIUtil.ShowTipsId("drone_skillChip_title_11")
      return
    end
    UIUtil.ShowMessage(Localization:GetString("drone_skillChip_title_10", self.planId, usingFormation), 1, "110006", nil, function()
      local otherHeroes = otherSquadData:GenerateServerHeroArray()
      SFSNetwork.SendMessage(MsgDefines.NormalFormationInfoSave, otherSquadData.uuid, otherHeroes, 0, prevUsingChipSetId)
      local curHeroes = self.data:GenerateServerHeroArray()
      SFSNetwork.SendMessage(MsgDefines.NormalFormationInfoSave, self.data.uuid, curHeroes, 0, self.planId)
    end, nil, nil)
  else
    local curHeroes = self.data:GenerateServerHeroArray()
    SFSNetwork.SendMessage(MsgDefines.NormalFormationInfoSave, self.data.uuid, curHeroes, 0, self.planId)
  end
end

return TacticalChipSquadItem
