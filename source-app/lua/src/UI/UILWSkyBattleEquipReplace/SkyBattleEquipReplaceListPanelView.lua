local SkyBattleEquipReplaceListPanelView = BaseClass("SkyBattleEquipReplaceListPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local SkyBattleEquipRowItemComponent = require("UI.UILWSkyBattleEquipReplace.Components.SkyBattleEquipRowItemComponent")
local EquipSlotItemComponent = require("UI.UILWStageSkyBattleChapter.Components.EquipSlotItemComponent")

function SkyBattleEquipReplaceListPanelView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
end

function SkyBattleEquipReplaceListPanelView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SkyBattleEquipReplaceListPanelView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compEmptyEquipContent = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.compEquipContent = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compEquipSlotItem = self.viewSkin:AddComponent(self, EquipSlotItemComponent, 6)
  self.textEquipName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textPower = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.scrollViewEquipScroll = self.viewSkin:AddComponent(self, UIScrollView, 9)
  self.compEquipRowItem = self.viewSkin:AddComponent(self, UIBaseComponent, 10)
  self.textEmptyEquipList = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.btnRemove = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnRemove:SetOnClick(function()
    self:OnBtnRemoveClick()
  end)
  self.textPropertySkill = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.btnSkillDesc = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnSkillDesc:SetOnClick(function()
    self:OnBtnSkillDescClick()
  end)
  self.textProperty1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.textProperty2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.textProperty3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 17)
  self.textProperty4 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.compEquipDetailPanel = self.viewSkin:AddComponent(self, UIBaseComponent, 19)
  self.btnCloseEquipDetail = self.viewSkin:AddComponent(self, UIButton, 20)
  self.btnCloseEquipDetail:SetOnClick(function()
    self:OnBtnCloseEquipDetailClick()
  end)
  self.textTxtSkillName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 21)
  self.textTxtSkillCoolingTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 22)
  self.textTxtSkillDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 23)
  self.textTitle:SetLocalText(430748)
  self.textDesc:SetLocalText(430745)
  self.compEquipRowItem:SetActive(false)
  self.scrollViewEquipScroll:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemCreateCell(itemObj, index)
  end)
  self.scrollViewEquipScroll:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemDeleteCell(itemObj, index)
  end)
end

function SkyBattleEquipReplaceListPanelView:ComponentDestroy()
  self.scrollViewEquipScroll:ClearCells()
  self.scrollViewEquipScroll:RemoveComponents(SkyBattleEquipRowItemComponent)
  self.viewSkin = nil
  self.textTitle = nil
  self.btnClose = nil
  self.compEmptyEquipContent = nil
  self.compEquipContent = nil
  self.textDesc = nil
  self.compEquipSlotItem = nil
  self.textEquipName = nil
  self.textPower = nil
  self.scrollViewEquipScroll = nil
  self.compEquipRowItem = nil
  self.textEmptyEquipList = nil
  self.btnRemove = nil
  self.textPropertySkill = nil
  self.btnSkillDesc = nil
  self.textProperty1 = nil
  self.textProperty2 = nil
  self.textProperty3 = nil
  self.textProperty4 = nil
  self.compEquipDetailPanel = nil
  self.btnCloseEquipDetail = nil
  self.textTxtSkillName = nil
  self.textTxtSkillCoolingTime = nil
  self.textTxtSkillDesc = nil
end

function SkyBattleEquipReplaceListPanelView:DataDefine()
  self.slotData = self:GetUserData()
  self.scrollEquipItemPool = {}
  self.excludeEquip = {}
  self.takeOffArray = {}
  self.scrollEquipItemIndex = 1
  self.propertyItems = {}
  table.insert(self.propertyItems, self.textProperty1)
  table.insert(self.propertyItems, self.textProperty2)
  table.insert(self.propertyItems, self.textProperty3)
  table.insert(self.propertyItems, self.textProperty4)
end

function SkyBattleEquipReplaceListPanelView:DataDestroy()
  self.slotData = nil
  self.equipDatas = nil
  self.scrollEquipItemPool = nil
  self.excludeEquip = nil
  self.takeOffArray = nil
  self.propertyItems = nil
end

function SkyBattleEquipReplaceListPanelView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SkyBattleEquipInstall, self.OnBtnCloseClick)
  self:AddUIListener(EventId.SkyBattleEquipUnInstall, self.OnBtnCloseClick)
end

function SkyBattleEquipReplaceListPanelView:OnRemoveListener()
  self:RemoveUIListener(EventId.SkyBattleEquipInstall, self.OnBtnCloseClick)
  self:RemoveUIListener(EventId.SkyBattleEquipUnInstall, self.OnBtnCloseClick)
  base.OnRemoveListener(self)
end

function SkyBattleEquipReplaceListPanelView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function SkyBattleEquipReplaceListPanelView:OnBtnSkillDescClick()
  self.compEquipDetailPanel:SetActive(true)
end

function SkyBattleEquipReplaceListPanelView:OnBtnCloseEquipDetailClick()
  self.compEquipDetailPanel:SetActive(false)
end

function SkyBattleEquipReplaceListPanelView:Refresh()
  self.compEquipDetailPanel:SetActive(false)
  self.compEmptyEquipContent:SetActive(false)
  self.compEquipContent:SetActive(false)
  self.scrollViewEquipScroll:SetActive(false)
  self.textEmptyEquipList:SetActive(false)
  self.textPropertySkill:SetActive(false)
  for type, propertyItem in ipairs(self.propertyItems) do
    propertyItem:SetActive(false)
  end
  if not self.slotData then
    return
  end
  if self.slotData.uuid == 0 then
    self.compEmptyEquipContent:SetActive(true)
    self.compEquipContent:SetActive(false)
    self.excludeEquip[1] = nil
  else
    self.compEmptyEquipContent:SetActive(false)
    self.compEquipContent:SetActive(true)
    self.textEquipName:SetLocalText(self.slotData.name)
    self.textPower:SetText(string.GetFormattedStr(self.slotData.power))
    self.compEquipSlotItem:Refresh(self.slotData.slot, self.slotData, nil, false)
    self.excludeEquip[1] = self.slotData.uuid
    if self.slotData.skill then
      local skillId = tonumber(self.slotData.skill)
      local equipSkillName = LocalController:instance():getValue(TableName.LW_Hero_Skill, skillId, "name", "")
      if not string.IsNullOrEmpty(equipSkillName) then
        self.textPropertySkill:SetActive(true)
        local skillName = Localization:GetString(equipSkillName)
        self.textPropertySkill:SetText(string.format("%s:%s", Localization:GetString("lw_title_ui_7"), skillName))
        self.textTxtSkillName:SetText(skillName)
      end
      local coolingNum = LocalController:instance():getValue(TableName.LW_Hero_Skill, skillId, "attack_interval", 0)
      self.textTxtSkillCoolingTime:SetText(string.format("%s: %d", Localization:GetString("coolingTime"), coolingNum))
      local desc = LocalController:instance():getValue(TableName.LW_Hero_Skill, skillId, "desc", "")
      self.textTxtSkillDesc:SetText(string.format("%s \r\n %s", Localization:GetString("season_mastery_102"), desc))
    end
  end
  if not self.slotData then
    self.compEmptyEquipContent:SetActive(true)
    self.compEquipContent:SetActive(false)
    self.scrollViewEquipScroll:SetActive(false)
    self.textEmptyEquipList:SetActive(true)
  else
    if self.slotData.uuid == 0 then
      self.compEmptyEquipContent:SetActive(true)
      self.compEquipContent:SetActive(false)
      self.excludeEquip[1] = nil
    else
      self.compEmptyEquipContent:SetActive(false)
      self.compEquipContent:SetActive(true)
      self.textEquipName:SetLocalText(self.slotData.name)
      self.textPower:SetText(string.GetFormattedStr(self.slotData.power))
      self.compEquipSlotItem:Refresh(self.slotData.slot, self.slotData, nil)
      self.textPropertySkill:SetActive(false)
      if self.slotData.skill then
        local equipSkillName = LocalController:instance():getValue(TableName.LW_Hero_Skill, tonumber(self.slotData.skill), "name", "")
        if not string.IsNullOrEmpty(equipSkillName) then
          self.textPropertySkill:SetActive(true)
          self.textPropertySkill:SetText(string.format("%s:%s", Localization:GetString("lw_title_ui_7"), Localization:GetString(equipSkillName)))
        end
      else
        self.textPropertySkill:SetActive(false)
      end
      if self.slotData.properties then
        for type, propertyItem in ipairs(self.propertyItems) do
          if self.slotData.properties[type] then
            local properTxt = Localization:GetString(DataCenter.LWSkyBattleGrowthChapterManager:GetEquipPropertyNameKey(type))
            local properValue = self.slotData.properties[type].value
            propertyItem:SetText(string.format("%s: %s%d", properTxt, 0 < properValue and "+" or "", properValue))
            propertyItem:SetActive(true)
          else
            propertyItem:SetActive(false)
          end
        end
      else
        for type, propertyItem in ipairs(self.propertyItems) do
          propertyItem:SetActive(false)
        end
      end
      self.excludeEquip[1] = self.slotData.uuid
    end
    self.equipDatas = DataCenter.LWSkyBattleGrowthChapterManager:GetEquipInfoDatasByType(self.slotData.slot, self.excludeEquip)
    local equipCounts = #self.equipDatas
    if 0 < equipCounts then
      self.scrollViewEquipScroll:SetActive(true)
      self.scrollViewEquipScroll:SetTotalCount(equipCounts)
      self.scrollViewEquipScroll:RefillCells()
      self.textEmptyEquipList:SetActive(false)
    else
      self.scrollViewEquipScroll:SetActive(false)
      self.textEmptyEquipList:SetActive(true)
    end
  end
end

function SkyBattleEquipReplaceListPanelView:OnItemCreateCell(itemObj, index)
  local item = self.scrollEquipItemPool[itemObj.name]
  if not item then
    local name = tostring(self.scrollEquipItemIndex)
    itemObj.name = name
    item = self.scrollViewEquipScroll:AddComponent(SkyBattleEquipRowItemComponent, itemObj)
    self.scrollEquipItemPool[name] = item
    self.scrollEquipItemIndex = self.scrollEquipItemIndex + 1
  end
  local equipData = self.equipDatas[index]
  local showRed = not self.slotData.equipInfo or self.slotData.equipInfo.power < equipData.power
  item:Refresh(equipData, function(equipInfo)
    self:OnEquipRowItemClick(equipInfo)
  end, showRed)
end

function SkyBattleEquipReplaceListPanelView:OnItemDeleteCell(itemObj, index)
  local item = self.scrollEquipItemPool[itemObj.name]
  if item then
    self.scrollViewEquipScroll:RemoveComponent(itemObj)
  end
end

function SkyBattleEquipReplaceListPanelView:OnEquipRowItemClick(equipInfo)
  if not self.slotData then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.UserSkyBattleEquipInstall, {
    [self.slotData.slot] = equipInfo.uuid
  })
end

function SkyBattleEquipReplaceListPanelView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function SkyBattleEquipReplaceListPanelView:OnBtnRemoveClick()
  if not self.slotData then
    return
  end
  self.takeOffArray[1] = self.slotData.slot
  SFSNetwork.SendMessage(MsgDefines.UserSkyBattleEquipUninstall, self.takeOffArray)
end

return SkyBattleEquipReplaceListPanelView
