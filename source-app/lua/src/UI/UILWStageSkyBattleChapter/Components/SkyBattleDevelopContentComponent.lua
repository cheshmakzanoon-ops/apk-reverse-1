local base = UIBaseContainer
local SkyBattleDevelopContentComponent = BaseClass("SkyBattleDevelopContentComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIModelView = require("Framework.UI.Component.UIModelView")
local EquipSlotItemComponent = require("UI.UILWStageSkyBattleChapter.Components.EquipSlotItemComponent")

function SkyBattleDevelopContentComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitPlaneScene()
end

function SkyBattleDevelopContentComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SkyBattleDevelopContentComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnSelectCloth = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnSelectCloth:SetOnClick(function()
    self:OnBtnSelectClothClick()
  end)
  self.compEquipSlot4Item = self.viewSkin:AddComponent(self, EquipSlotItemComponent, 2)
  self.compEquipSlot3Item = self.viewSkin:AddComponent(self, EquipSlotItemComponent, 3)
  self.compEquipSlot2Item = self.viewSkin:AddComponent(self, EquipSlotItemComponent, 4)
  self.compEquipSlot1Item = self.viewSkin:AddComponent(self, EquipSlotItemComponent, 5)
  self.textAtkInfoTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textCurAtk = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textHpInfoTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textCurHp = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textMemPropertyInfoTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textCurMemPropertyInfoNumber = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.textMemCountInfoTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.textCurMemCountInfo = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.compBigAvator = self.viewSkin:AddComponent(self, UIModelView, 14)
  self.btnEquipAll = self.viewSkin:AddComponent(self, UIButton, 15)
  self.btnEquipAll:SetOnClick(function()
    self:OnBtnEquipAllClick()
  end)
  self.textBtnEquipAllTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.textBtnSelectClothTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 17)
  self.imgEquipAllRedPoint = self.viewSkin:AddComponent(self, UIImage, 18)
  self.textAtkInfoTitle:SetLocalText(DataCenter.LWSkyBattleGrowthChapterManager:GetEquipPropertyNameKey(SkyBattleEquipType.Attack))
  self.textHpInfoTitle:SetLocalText(DataCenter.LWSkyBattleGrowthChapterManager:GetEquipPropertyNameKey(SkyBattleEquipType.HP))
  self.textMemPropertyInfoTitle:SetLocalText(DataCenter.LWSkyBattleGrowthChapterManager:GetEquipPropertyNameKey(SkyBattleEquipType.MemberPropPercent))
  self.textMemCountInfoTitle:SetLocalText(DataCenter.LWSkyBattleGrowthChapterManager:GetEquipPropertyNameKey(SkyBattleEquipType.MemberNum))
  self.textBtnEquipAllTxt:SetLocalText(430737)
  self.textBtnSelectClothTxt:SetLocalText(141146)
end

function SkyBattleDevelopContentComponent:ComponentDestroy()
  self.viewSkin = nil
  self.btnSelectCloth = nil
  self.compEquipSlot4Item = nil
  self.compEquipSlot3Item = nil
  self.compEquipSlot2Item = nil
  self.compEquipSlot1Item = nil
  self.textAtkInfoTitle = nil
  self.textCurAtk = nil
  self.textHpInfoTitle = nil
  self.textCurHp = nil
  self.textMemPropertyInfoTitle = nil
  self.textCurMemPropertyInfoNumber = nil
  self.textMemCountInfoTitle = nil
  self.textCurMemCountInfo = nil
  self.compBigAvator = nil
  self.btnEquipAll = nil
  self.textBtnEquipAllTxt = nil
  self.textBtnSelectClothTxt = nil
  self.imgEquipAllRedPoint = nil
end

function SkyBattleDevelopContentComponent:DataDefine()
  self.slotComps = {}
  self.compEquipSlot1Item:Refresh()
  table.insert(self.slotComps, self.compEquipSlot1Item)
  self.compEquipSlot2Item:Refresh()
  table.insert(self.slotComps, self.compEquipSlot2Item)
  self.compEquipSlot3Item:Refresh()
  table.insert(self.slotComps, self.compEquipSlot3Item)
  self.compEquipSlot4Item:Refresh()
  table.insert(self.slotComps, self.compEquipSlot4Item)
end

function SkyBattleDevelopContentComponent:DataDestroy()
  self.slotComps = nil
end

function SkyBattleDevelopContentComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SkyBattleChapterGrowthUserInfoInit, self.RefreshPlaneContent)
  self:AddUIListener(EventId.SkyBattleChapterGrowthUserInfoRefresh, self.RefreshPlaneContent)
  self:AddUIListener(EventId.SkyBattleChapterGrowthBattleInfoInit, self.RefreshAllSlotContent)
  self:AddUIListener(EventId.SkyBattleChapterGrowthBattleSlotInfoRefresh, self.RefreshAllSlotContent)
  self:AddUIListener(EventId.SkyBattleEquipSlotUpgrade, self.RefreshSlotsContent)
  self:AddUIListener(EventId.SkyBattleEquipUnInstall, self.RefreshSlotsContent)
  self:AddUIListener(EventId.SkyBattleEquipInstall, self.RefreshSlotsContent)
  self:AddUIListener(EventId.SkyBattleChapterGrowthBattleEquipInfoRefresh, self.RefreshAllSlotContent)
end

function SkyBattleDevelopContentComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.SkyBattleChapterGrowthUserInfoInit, self.RefreshPlaneContent)
  self:RemoveUIListener(EventId.SkyBattleChapterGrowthUserInfoRefresh, self.RefreshPlaneContent)
  self:RemoveUIListener(EventId.SkyBattleChapterGrowthBattleInfoInit, self.RefreshAllSlotContent)
  self:RemoveUIListener(EventId.SkyBattleChapterGrowthBattleSlotInfoRefresh, self.RefreshAllSlotContent)
  self:RemoveUIListener(EventId.SkyBattleEquipSlotUpgrade, self.RefreshSlotsContent)
  self:RemoveUIListener(EventId.SkyBattleEquipUnInstall, self.RefreshSlotsContent)
  self:RemoveUIListener(EventId.SkyBattleEquipInstall, self.RefreshSlotsContent)
  self:RemoveUIListener(EventId.SkyBattleChapterGrowthBattleEquipInfoRefresh, self.RefreshAllSlotContent)
  base.OnRemoveListener(self)
end

function SkyBattleDevelopContentComponent:OnEnable()
  base.OnEnable(self)
  self:RefreshPlaneContent()
  self:RefreshAllSlotContent()
end

function SkyBattleDevelopContentComponent:OnBtnEquipAllClick()
  local slots = DataCenter.LWSkyBattleGrowthChapterManager.battleSlotInfo
  if not slots then
    return
  end
  local replaceSlotData = {}
  local existReplaceSlot = false
  for i, slotData in ipairs(slots) do
    local slotHighPowerData = DataCenter.LWSkyBattleGrowthChapterManager:GetLocationTopPowerData(slotData.slot)
    if not (not slotHighPowerData or slotData.equipInfo) or slotHighPowerData and slotData.equipInfo and slotHighPowerData.power > slotData.equipInfo.power then
      replaceSlotData[i] = slotHighPowerData.uuid
      existReplaceSlot = true
    end
  end
  if replaceSlotData and existReplaceSlot then
    SFSNetwork.SendMessage(MsgDefines.UserSkyBattleEquipInstall, replaceSlotData)
  end
end

function SkyBattleDevelopContentComponent:OnBtnSelectClothClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISkyBattlePlaneSkinPage)
end

function SkyBattleDevelopContentComponent:RefreshPlaneContent()
  self:RefreshSelectedPlaneModel()
  self:RefreshPropertyContent()
end

local allSlotIndex = {
  1,
  2,
  3,
  4
}

function SkyBattleDevelopContentComponent:RefreshAllSlotContent()
  self:RefreshSlots(allSlotIndex)
  self:RefreshPropertyContent()
end

function SkyBattleDevelopContentComponent:RefreshSlotsContent(slots)
  if not slots then
    return
  end
  self:RefreshSlots(slots)
  self:RefreshPropertyContent()
end

local planeShowSceneAssets = "Assets/Main/Prefabs/LWBattle/Plane/Skin/SkyBattlePlaneScene.prefab"

function SkyBattleDevelopContentComponent:InitPlaneScene()
  self.compBigAvator:Clear()
  self.compBigAvator:SetDefaultSceneTrans(Vector3.New(500, 0, 500))
  self.compBigAvator:SetRTFormat(CS.UnityEngine.RenderTextureFormat.ARGB32)
  self.compBigAvator:SetActive(true)
  self.compBigAvator:SetEnable(false)
  self.compBigAvator:ReInit(planeShowSceneAssets)
end

function SkyBattleDevelopContentComponent:RefreshSelectedPlaneModel()
  local curSelectedPlane = DataCenter.LWSkyBattleGrowthChapterManager:GetCurSelectedPlaneData()
  if not curSelectedPlane or curSelectedPlane.planeId == 0 then
    self.compBigAvator:SetActive(false)
    return
  end
  if not self.showedPlaneId or self.showedPlaneId ~= curSelectedPlane.planeId then
    self.showedPlaneId = curSelectedPlane.planeId
    local prefabPath = curSelectedPlane.planePrefabPath
    if prefabPath then
      self.compBigAvator:SetActive(true)
      self:RefreshPlaneMode(prefabPath)
    else
      self.compBigAvator:SetActive(false)
    end
  end
end

function SkyBattleDevelopContentComponent:RefreshPlaneMode(modelPath, callBack)
  self.compBigAvator:ChangeModel(modelPath, callBack)
end

function SkyBattleDevelopContentComponent:RefreshSlots(slots)
  local slotInfo = DataCenter.LWSkyBattleGrowthChapterManager.battleSlotInfo
  if not slotInfo then
    return
  end
  local hasEquipAllRedPoint = false
  for i, slotIndex in ipairs(slots) do
    local slotData = slotInfo[slotIndex]
    local slotHighPowerData = DataCenter.LWSkyBattleGrowthChapterManager:GetLocationTopPowerData(slotIndex)
    if slotData then
      local hasRed = false
      if not (not slotHighPowerData or slotData.equipInfo) or slotHighPowerData and slotData.equipInfo and slotHighPowerData.power > slotData.equipInfo.power then
        hasRed = true
        hasEquipAllRedPoint = true
      end
      self.slotComps[slotIndex]:Refresh(slotIndex, slotData, function(index)
        self:OnSlotItemClick(index)
      end, hasRed)
    else
      self.slotComps[slotIndex]:Refresh(slotIndex, nil, nil, false)
    end
    self.slotComps[slotIndex]:SetActive(true)
  end
  self.imgEquipAllRedPoint:SetActive(hasEquipAllRedPoint)
end

function SkyBattleDevelopContentComponent:OnSlotItemClick(slotIndex)
  local slots = DataCenter.LWSkyBattleGrowthChapterManager.battleSlotInfo
  if not slots then
    return
  end
  local slotData = slots[slotIndex]
  if not slotData then
    return
  end
  if slotData.uuid and slotData.uuid ~= 0 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISkyBattlePlaneEquipDetail, {anim = true}, slotData)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.SkyBattleEquipReplaceListPanel, {anim = true}, slotData)
  end
end

function SkyBattleDevelopContentComponent:RefreshPropertyContent()
  self.textCurAtk:SetText(string.GetFormattedStr(DataCenter.LWSkyBattleGrowthChapterManager:GetPropertyValue(SkyBattleEquipType.Attack)))
  self.textCurHp:SetText(string.GetFormattedStr(DataCenter.LWSkyBattleGrowthChapterManager:GetPropertyValue(SkyBattleEquipType.HP)))
  local properPercent = math.ceil(DataCenter.LWSkyBattleGrowthChapterManager:GetPropertyValue(SkyBattleEquipType.MemberPropPercent) / 100)
  self.textCurMemPropertyInfoNumber:SetText(string.format("%d%%", properPercent))
  self.textCurMemCountInfo:SetText(string.GetFormattedStr(DataCenter.LWSkyBattleGrowthChapterManager:GetPropertyValue(SkyBattleEquipType.MemberNum)))
end

function SkyBattleDevelopContentComponent:GetGuidePosition(guide)
  if guide == SkyBattleChapterGrowthGuideType.Slot1 then
    return self.compEquipSlot1Item.transform.position
  elseif guide == SkyBattleChapterGrowthGuideType.Skin then
    return self.btnSelectCloth.transform.position
  end
end

return SkyBattleDevelopContentComponent
