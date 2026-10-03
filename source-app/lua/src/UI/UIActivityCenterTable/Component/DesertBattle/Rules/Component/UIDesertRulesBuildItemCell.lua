local UIDesertRulesBuildItemCell = BaseClass("UIDesertRulesBuildItemCell", UIBaseContainer)
local base = UIBaseContainer
local BuffIcon = require("UI.LWMainUI.Component.UIMainLeft.BuffIcon")
local build_path = ""
local icon_path = "top/icon_bg/icon"
local name_path = "top/info/name"
local desc_path = "top/info/desc"
local btnInfo_path = "top/info/InfoBtn"
local first_control_root_path = "GameObject"
local first_control_path = "GameObject/Title/FirstControl"
local first_control_add_path = "GameObject/Title/FirstControlAdd"
local first_control_al_path = "GameObject/FirstNode/FirstControlAL"
local first_control_al_add_path = "GameObject/FirstNode/FirstControlALAdd"
local first_control_player_path = "GameObject/FirstNode/FirstControlPlayer"
local first_control_player_add_path = "GameObject/FirstNode/FirstControlPlayerAdd"
local first_node_path = "GameObject/FirstNode"
local effect_list_path = "EffectList"
local effect1_path = "EffectList/Effect1"
local effect_desc1_path = "EffectList/Effect1/EffectDesc1"
local effect_buff1_path = "EffectList/Effect1/EffectBuff1"
local effect_value1_path = "EffectList/Effect1/EffectValue1"
local effect2_path = "EffectList/Effect2"
local effect_desc2_path = "EffectList/Effect2/EffectDesc2"
local effect_buff2_path = "EffectList/Effect2/EffectBuff2"
local effect_value2_path = "EffectList/Effect2/EffectValue2"
local first_control_player_name_path = "GameObject/FirstNode/FirstControlPlayerName"
local first_control_a_l_name_path = "GameObject/FirstNode/FirstControlALName"

function UIDesertRulesBuildItemCell:OnCreate()
  base.OnCreate(self)
  self.build = self:AddComponent(UIImage, build_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.name = self:AddComponent(UIText, name_path)
  self.desc = self:AddComponent(UIText, desc_path)
  self.btnInfo = self:AddComponent(UIButton, btnInfo_path)
  self.btnInfo:SetOnClick(function()
    self:OnInfoClick()
  end)
  self.first_control_root = self:AddComponent(UIBaseContainer, first_control_root_path)
  self.first_control = self:AddComponent(UIText, first_control_path)
  self.first_control_add = self:AddComponent(UIText, first_control_add_path)
  self.first_control_al = self:AddComponent(UIText, first_control_al_path)
  self.first_control_al_add = self:AddComponent(UIText, first_control_al_add_path)
  self.first_control_player = self:AddComponent(UIText, first_control_player_path)
  self.first_control_player_add = self:AddComponent(UIText, first_control_player_add_path)
  self.first_node = self:AddComponent(UIBaseContainer, first_node_path)
  self.first_control_a_l_name = self:AddComponent(UITextMeshProUGUIEx, first_control_a_l_name_path)
  self.first_control_player_name = self:AddComponent(UITextMeshProUGUIEx, first_control_player_name_path)
  self.effect_list = self:AddComponent(UIBaseContainer, effect_list_path)
  self.effect1 = self:AddComponent(UIBaseContainer, effect1_path)
  self.effect_desc1 = self:AddComponent(UIText, effect_desc1_path)
  self.effect_buff1 = self:AddComponent(BuffIcon, effect_buff1_path)
  self.effect_value1 = self:AddComponent(UIText, effect_value1_path)
  self.effect2 = self:AddComponent(UIBaseContainer, effect2_path)
  self.effect_desc2 = self:AddComponent(UIText, effect_desc2_path)
  self.effect_buff2 = self:AddComponent(BuffIcon, effect_buff2_path)
  self.effect_value2 = self:AddComponent(UIText, effect_value2_path)
end

function UIDesertRulesBuildItemCell:OnDestroy()
  base.OnDestroy(self)
end

function UIDesertRulesBuildItemCell:OnInfoClick()
  if self.template == nil then
    return
  end
  if self.battleType == BattleFieldType.EpidemicZone then
    local bBuff = self.template:IsBuff()
    if bBuff then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActEpidemicBattleBuffView, {anim = true}, self.template, self.battleType)
    end
  elseif self.battleType == BattleFieldType.DsbDuel then
    local bBuff = self.template:IsBuff()
    if bBuff then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActEpidemicBattleBuffView, {anim = true}, self.template, self.battleType)
    end
  end
end

function UIDesertRulesBuildItemCell:ReInit(template, battleType)
  self.template = template
  self.battleType = battleType
  local iconPath = template.GetRulesIconPath and template:GetRulesIconPath() or template:GetDetailPath()
  self.icon:LoadSpriteAuto(iconPath)
  self.icon:SetAspectSize(138)
  self.name:SetLocalText(template.name)
  self.desc:SetLocalText(template.des)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.desc.rectTransform)
  local sBtnInfo = false
  if battleType == BattleFieldType.EpidemicZone then
    sBtnInfo = template:IsBuff()
  elseif battleType == BattleFieldType.DsbDuel then
    sBtnInfo = template:IsBuff()
  end
  self.btnInfo:SetActive(sBtnInfo)
  if template.id == 10110 or battleType == BattleFieldType.WinterStorm then
    self.first_control_root:SetActive(false)
    self.effect_list:SetActive(false)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.build.rectTransform)
    return
  end
  self.first_control_root:SetActive(true)
  self.effect_list:SetActive(true)
  if battleType == BattleFieldType.EpidemicZone then
    if template.point_produce_per_second == 0 then
      self.first_control_root:SetActive(false)
    else
      self.first_control_root:SetActive(true)
      self.first_control_player:SetActive(false)
      self.first_control_player_add:SetActive(false)
      self.first_control_player_name:SetActive(false)
      self.first_node:SetSizeDeltaXY(690, 40)
    end
  else
    self.first_control_player:SetActive(true)
    self.first_control_player_add:SetActive(true)
    self.first_control_player_name:SetActive(true)
    self.first_node:SetSizeDeltaXY(690, 80)
    local pointShow
    if battleType == BattleFieldType.Desert then
      local tbName = BattleFieldUtil.GetBattleFieldCfgValue(BattleFieldType.Desert, BattleFieldTableKey.P_POINT_ID)
      if not string.IsNullOrEmpty(tbName) then
        if template.id == 10120 then
          local scoreId = LocalController:instance():getValue(tbName, 2, "score_detail")
          local points = LocalController:instance():getIntValue(TableName.Score, scoreId, "points", 1)
          pointShow = template.gather_point_per_second * points
        else
          local scoreId = LocalController:instance():getValue(tbName, 3, "score_detail")
          pointShow = LocalController:instance():getIntValue(TableName.Score, scoreId, "points", 30)
        end
      end
    elseif battleType == BattleFieldType.DsbDuel then
      local tbName = BattleFieldUtil.GetBattleFieldCfgValue(BattleFieldType.DsbDuel, BattleFieldTableKey.P_POINT_ID)
      if not string.IsNullOrEmpty(tbName) then
        if template.type == 5 then
          local scoreId = LocalController:instance():getValue(tbName, 2, "score_detail")
          local points = LocalController:instance():getIntValue(TableName.Score, scoreId, "points", 1)
          pointShow = template.point_produce_per_second * points
        else
          local scoreId = LocalController:instance():getValue(tbName, 3, "score_detail")
          pointShow = LocalController:instance():getIntValue(TableName.Score, scoreId, "points", 30)
        end
      end
    end
    if pointShow == nil then
      pointShow = toInt(template.point_produce_per_second * 0.5)
    end
    self.first_control_player_add:SetText(string.format("+%s/s", pointShow))
  end
  self.first_control_add:SetLocalText("458196")
  self.first_control_al_add:SetText("+" .. template.point_produce_per_second .. "/s")
  if battleType == BattleFieldType.Desert or battleType == BattleFieldType.DsbDuel then
    self.first_control:SetActive(false)
    self.first_control_al:SetActive(false)
    self.first_control_player:SetActive(false)
    local x, y, z = self.first_control_add:GetLocalPositionXYZ()
    self.first_control_add:SetLocalPositionXYZ(100, y, z)
    x, y, z = self.first_control_al_add:GetLocalPositionXYZ()
    self.first_control_al_add:SetLocalPositionXYZ(100, y, z)
    x, y, z = self.first_control_player_add:GetLocalPositionXYZ()
    self.first_control_player_add:SetLocalPositionXYZ(100, y, z)
  elseif battleType == BattleFieldType.EpidemicZone then
    self.first_control:SetActive(false)
    self.first_control_al:SetActive(false)
    self.first_control_player:SetActive(false)
    local x, y, z = self.first_control_add:GetLocalPositionXYZ()
    self.first_control_add:SetLocalPositionXYZ(100, y, z)
    x, y, z = self.first_control_al_add:GetLocalPositionXYZ()
    self.first_control_al_add:SetLocalPositionXYZ(100, y, z)
    x, y, z = self.first_control_player_add:GetLocalPositionXYZ()
    self.first_control_player_add:SetLocalPositionXYZ(100, y, z)
  else
    self.first_control:SetLocalText("458191")
    local _point = tostring(template.first_capture_point or "0")
    self.first_control_al:SetText(_point)
    self.first_control_player:SetText(tostring(toInt(_point) * 0.5))
    local x, y, z = self.first_control_add:GetLocalPositionXYZ()
    self.first_control_add:SetLocalPositionXYZ(340, y, z)
    x, y, z = self.first_control_al_add:GetLocalPositionXYZ()
    self.first_control_al_add:SetLocalPositionXYZ(340, y, z)
    x, y, z = self.first_control_player_add:GetLocalPositionXYZ()
    self.first_control_player_add:SetLocalPositionXYZ(340, y, z)
  end
  local item1 = template.effectList and template.effectList[1]
  local item2 = template.effectList and template.effectList[2]
  if item1 ~= nil and item1.effect_icon ~= nil and item1.effect_icon ~= "" then
    self.effect1:SetActive(true)
    self.effect_desc1:SetLocalText(item1.descID)
    local buffAddNum = ""
    local value = item1.value
    local type = item1.num_type
    local showFlag = tonumber(item1.id) ~= EffectDefine.LW_DRAGON_HOSPITAL_HEAL_ADD and tonumber(item1.id) ~= EffectDefine.LW_DSB_DUEL_HOSPITAL_HEAL_ADD and 0 < value
    if showFlag then
      if type == EffectLocalTypeInEffectDesc.Str then
        buffAddNum = value
      elseif type == EffectLocalTypeInEffectDesc.Num then
        buffAddNum = string.GetFormattedSeperatorNum(value)
      elseif type == EffectLocalTypeInEffectDesc.Percent then
        buffAddNum = string.GetFormattedPercentStr(value / 100)
      elseif type == EffectLocalTypeInEffectDesc.Thousandth then
        buffAddNum = string.GetFormattedThousandthStr(value / 1000)
      end
      self.effect_value1:SetText("+" .. buffAddNum)
      if item1.effect_icon ~= nil and item1.effect_icon ~= "" then
        self.effect_buff1.item_icon:LoadSpriteAuto(item1.effect_icon)
      else
        self.effect_buff1:ReInit(item1)
      end
    end
    self.effect_value1:SetActive(showFlag)
    self.effect_buff1:SetActive(showFlag)
  else
    self.effect1:SetActive(false)
  end
  if item2 ~= nil and item2.effect_icon ~= nil and item2.effect_icon ~= "" then
    self.effect2:SetActive(true)
    self.effect_desc2:SetLocalText(item2.descID)
    local buffAddNum = ""
    local value = item2.value
    local type = item2.num_type
    local showFlag = tonumber(item2.id) ~= EffectDefine.LW_DRAGON_HOSPITAL_HEAL_ADD and 0 < value
    if showFlag then
      if type == EffectLocalTypeInEffectDesc.Str then
        buffAddNum = value
      elseif type == EffectLocalTypeInEffectDesc.Num then
        buffAddNum = string.GetFormattedSeperatorNum(value)
      elseif type == EffectLocalTypeInEffectDesc.Percent then
        buffAddNum = string.GetFormattedPercentStr(value / 100)
      elseif type == EffectLocalTypeInEffectDesc.Thousandth then
        buffAddNum = string.GetFormattedThousandthStr(value / 1000)
      end
      self.effect_value2:SetText("+" .. buffAddNum)
      if item2.effect_icon ~= nil and item2.effect_icon ~= "" then
        self.effect_buff2.item_icon:LoadSpriteAuto(item2.effect_icon)
      else
        self.effect_buff2:ReInit(item2)
      end
    end
    self.effect_value2:SetActive(showFlag)
    self.effect_buff2:SetActive(showFlag)
  else
    self.effect2:SetActive(false)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.effect_list.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.build.rectTransform)
end

return UIDesertRulesBuildItemCell
