local base = UIBaseContainer
local SkyBattleEquipRowItemComponent = BaseClass("SkyBattleEquipRowItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIEquipItemComponent = require("UI.UILWStageSkyBattleChapter.Components.UIEquipItemComponent")

function SkyBattleEquipRowItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SkyBattleEquipRowItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SkyBattleEquipRowItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compUISkyBattleEquipItem = self.viewSkin:AddComponent(self, UIEquipItemComponent, 1)
  self.textEquipName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textPower = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnEquip = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnEquip:SetOnClick(function()
    self:OnBtnEquipClick()
  end)
  self.textEquipBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textProperty1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textProperty2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textProperty3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textProperty4 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textPropertySkill = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.imgRedPoint = self.viewSkin:AddComponent(self, UIImage, 11)
  self.textEquipBtn:SetLocalText("No-Key-EquipOn")
end

function SkyBattleEquipRowItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compUISkyBattleEquipItem = nil
  self.textEquipName = nil
  self.textPower = nil
  self.btnEquip = nil
  self.textEquipBtn = nil
  self.textProperty1 = nil
  self.textProperty2 = nil
  self.textProperty3 = nil
  self.textProperty4 = nil
  self.textPropertySkill = nil
  self.imgRedPoint = nil
end

function SkyBattleEquipRowItemComponent:DataDefine()
  self.propertyItems = {}
  table.insert(self.propertyItems, self.textProperty1)
  table.insert(self.propertyItems, self.textProperty2)
  table.insert(self.propertyItems, self.textProperty3)
  table.insert(self.propertyItems, self.textProperty4)
end

function SkyBattleEquipRowItemComponent:DataDestroy()
  self.propertyItems = nil
  self.battleEquipInfo = nil
  self.onEquipCallBack = nil
end

function SkyBattleEquipRowItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function SkyBattleEquipRowItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SkyBattleEquipRowItemComponent:OnBtnEquipClick()
  if not self.battleEquipInfo or not self.onEquipCallBack then
    return
  end
  self.onEquipCallBack(self.battleEquipInfo)
end

function SkyBattleEquipRowItemComponent:Refresh(battleEquipInfo, onEquipCallBack, showRed)
  self.battleEquipInfo = battleEquipInfo
  self.onEquipCallBack = onEquipCallBack
  self.compUISkyBattleEquipItem:SetData(battleEquipInfo, 1, false, function()
    self:OnDetailInfoClick()
  end)
  self.textEquipName:SetLocalText(battleEquipInfo.name)
  self.textPower:SetText(string.GetFormattedStr(battleEquipInfo.power))
  self.imgRedPoint:SetActive(showRed)
  self.textPropertySkill:SetActive(false)
  if not string.IsNullOrEmpty(battleEquipInfo.skill) then
    local equipSkillName = LocalController:instance():getValue(TableName.LW_Hero_Skill, tonumber(battleEquipInfo.skill), "name", "")
    if not string.IsNullOrEmpty(equipSkillName) then
      self.textPropertySkill:SetActive(true)
      self.textPropertySkill:SetText(string.format("%s:<color=94e138>%s</color>", Localization:GetString("lw_title_ui_7"), Localization:GetString(equipSkillName)))
    end
  end
  for type, propertyItem in ipairs(self.propertyItems) do
    if battleEquipInfo.properties[type] then
      local properTxt = Localization:GetString(DataCenter.LWSkyBattleGrowthChapterManager:GetEquipPropertyNameKey(type))
      local properValue = battleEquipInfo.properties[type].value
      local propertyValueShowTxt = string.format("%d", properValue)
      if type == SkyBattleEquipType.MemberPropPercent then
        properValue = properValue * 0.01
        propertyValueShowTxt = string.format("%d%%", properValue)
      end
      propertyItem:SetText(string.format("%s: %s%s", properTxt, 0 < properValue and "+" or "", propertyValueShowTxt))
      propertyItem:SetActive(true)
    else
      propertyItem:SetActive(false)
    end
  end
end

function SkyBattleEquipRowItemComponent:OnDetailInfoClick()
end

return SkyBattleEquipRowItemComponent
