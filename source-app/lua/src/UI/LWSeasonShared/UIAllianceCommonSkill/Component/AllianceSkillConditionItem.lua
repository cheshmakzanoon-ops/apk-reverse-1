local base = UIBaseContainer
local AllianceSkillConditionItem = BaseClass("AllianceSkillConditionItem", base)
local AllianceSkillDonateFishLogic = require("UI.LWSeason6.UILWSeasonDonateFish.Logic.AllianceSkillDonateFishLogic")
local img_condition_path = "img_condition"
local txt_desc_path = "txt_desc"
local btn_goto_path = "btn_goto"
local img_finish_path = "img_finish"
local txt_cd_path = "txt_cd"

function AllianceSkillConditionItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function AllianceSkillConditionItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllianceSkillConditionItem:ComponentDefine()
  self.img_condition = self:AddComponent(UIImage, img_condition_path)
  self.txt_desc = self:AddComponent(UIText, txt_desc_path)
  self.btn_goto = self:AddComponent(UIButton, btn_goto_path)
  self.img_finish = self:AddComponent(UIImage, img_finish_path)
  self.txt_cd = self:AddComponent(UIText, txt_cd_path)
  self.btn_goto:SetOnClick(BindCallback(self, self.ClickGoTo))
end

function AllianceSkillConditionItem:ComponentDestroy()
  self.img_condition = nil
  self.txt_desc = nil
  self.btn_goto = nil
  self.img_finish = nil
  self.txt_cd = nil
end

function AllianceSkillConditionItem:ClickGoTo()
  if self.type == 1 then
    if self.data.config.skill_flag == AlOfficialSkillType.AbundantHarvest then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceCommonSkill, {anim = true})
      GoToUtil.GoToCampScience()
    else
      local serverId = LuaEntry.Player:GetSourceServerId()
      local table_name = SeasonUtil.GetWorldCityTableNameByServerId(serverId)
      local cityId = 0
      LocalController:instance():visitTable(table_name, function(id, cell)
        if cell.buff then
          local buffId, _ = string.string2_ii(cell.buff, ";")
          if buffId ~= nil and buffId ~= 0 and buffId == self.data.config.prerequisites_effect then
            cityId = cell.id
            return true
          end
        end
      end)
      if cityId ~= 0 then
        do
          local template = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, serverId)
          if template then
            template:JumpTo()
          end
        end
      end
    end
  elseif self.type == 2 then
    local energy = DataCenter.AllianceGovernmentCommonSkillManager:GetEnergyInfo()
    local logic = AllianceSkillDonateFishLogic.New(energy)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonDonateFish, {anim = true}, logic)
  end
end

function AllianceSkillConditionItem:ReEffectLock(data)
  self.type = 1
  self.data = data
  local isFinish = not data:IsLock()
  local desc = data.config.unlock_condition_desc
  if desc and desc[1] then
    self.txt_desc:SetLocalText(data.config.unlock_condition_desc[1])
  end
  self.img_finish:SetActive(isFinish)
  self.btn_goto:SetActive(not isFinish)
  if isFinish then
    self.txt_desc:SetColorHex("#2A2830")
  else
    self.txt_desc:SetColorHex("#FE3C3D")
  end
  self.img_condition:LoadSpriteAuto(data.scoreConfig.icon_get)
  self.img_condition:SetSizeDeltaXY(52, 52)
  self.txt_cd:SetActive(false)
end

function AllianceSkillConditionItem:ReEnergyCost(data)
  self.type = 2
  local energy = DataCenter.AllianceGovernmentCommonSkillManager:GetEnergyInfo()
  local isFinish = energy.currentEnergy >= data.config.consume_energy
  self.img_finish:SetActive(isFinish)
  self.btn_goto:SetActive(not isFinish)
  self.txt_desc:SetText(energy.currentEnergy .. "/" .. data.config.consume_energy)
  if isFinish then
    self.txt_desc:SetColorHex("#2A2830")
  else
    self.txt_desc:SetColorHex("#FE3C3D")
  end
  local energy = DataCenter.AllianceGovernmentCommonSkillManager:GetEnergyInfo()
  self.img_condition:LoadSpriteAuto(energy:GetCostIcon())
  self.img_condition:SetSizeDeltaXY(48, 48)
  self.txt_cd:SetActive(false)
end

function AllianceSkillConditionItem:RefreshCD(data)
  self.type = 3
  self.data = data
  local isFinish = data.state == 0
  self.img_finish:SetActive(isFinish)
  self.btn_goto:SetActive(false)
  self.txt_desc:SetLocalText("season_s6_government_skill_desc37")
  if isFinish then
    self.txt_desc:SetColorHex("#2A2830")
  else
    self.txt_desc:SetColorHex("#FE3C3D")
  end
  self.img_condition:LoadSpriteAuto("Assets/Main/Sprites/UI/LWCommon/Sprite/guaji_cfm_tubiao_2.png")
  self.img_condition:SetSizeDeltaXY(46, 46)
  self:Update1000MS()
end

function AllianceSkillConditionItem:Update1000MS()
  if self.type == 3 and self.data then
    local hasCd = self.data:InCd()
    if hasCd then
      local cd = self.data:GetCD()
      local cdStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(cd)
      self.txt_cd:SetLocalText("season_s6_government_skill_desc43", cdStr)
      self.txt_cd:SetActive(true)
    else
      self.txt_cd:SetActive(false)
      self.img_finish:SetActive(true)
    end
  end
end

return AllianceSkillConditionItem
