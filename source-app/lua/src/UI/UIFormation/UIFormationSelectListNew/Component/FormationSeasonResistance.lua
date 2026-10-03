local Localization = CS.GameEntry.Localization
local base = UIBaseContainer
local FormationSeasonResistance = BaseClass("FormationSeasonResistance", base)
local k_x_current_title_path = "KangXing/KangXingCurrent/layout1/Content/KXCurrentTitle"
local k_x_current_num_path = "KangXing/KangXingCurrent/layout1/Content/KXCurrentNum"
local k_x_require_title_path = "KangXing/KangXingRequire/layout1/Content/KXRequireTitle"
local k_x_require_num_path = "KangXing/KangXingRequire/layout1/Content/KXRequireNum"
local kang_xing_msg_path = "KangXingMsg"
local k_x_detail_path = "KangXingMsg/KXDetail"
local kang_xing_msg_btn_path = "KangXingMsg/KangXingMsgBtn"

function FormationSeasonResistance:OnCreate()
  base.OnCreate(self)
  self.need_resistance = 0
  self.has_resistance = 0
  self.kx_current_title = self:AddComponent(UIText, k_x_current_title_path)
  self.kx_current_num = self:AddComponent(UIText, k_x_current_num_path)
  self.kx_require_title = self:AddComponent(UIText, k_x_require_title_path)
  self.kx_require_num = self:AddComponent(UIText, k_x_require_num_path)
  self.kang_xing_msg = self:AddComponent(UIBaseContainer, kang_xing_msg_path)
  self.kx_detail = self:AddComponent(UIText, k_x_detail_path)
  self.kang_xing_msg_btn = self:AddComponent(UIButton, kang_xing_msg_btn_path)
  self.kang_xing_msg:SetActive(false)
  self.kang_xing_msg_btn:SetActive(true)
  self.kang_xing_msg_btn:SetOnClick(function()
    if self.need_resistance and self.need_resistance > 0 then
      LWResourceLackUtil:GotoResLack({
        {
          resType = ResourceType.ResistancePoint,
          need = self.need_resistance
        }
      })
    end
  end)
  self:SetActive(false)
end

function FormationSeasonResistance:OnDestroy()
  base.OnDestroy(self)
end

function FormationSeasonResistance:SetData(targetType, fixedSoldierType)
  if not SeasonUtil.CurServerIsInSeason() then
    self:SetActive(false)
    return 0, 0
  end
  self.targetType = targetType
  self.need_resistance = 0
  self.has_resistance = 0
  if targetType == MarchTargetType.ATTACK_DESERT or targetType == MarchTargetType.ATTACK_ALLIANCE_CITY or targetType == MarchTargetType.RALLY_FOR_ALLIANCE_CITY or targetType == MarchTargetType.ATTACK_CITY_STRONGHOLD or targetType == MarchTargetType.RALLY_CITY_STRONGHOLD or targetType == MarchTargetType.ATTACK_MONSTER or targetType == MarchTargetType.RALLY_FOR_BOSS then
    local resistance = 0
    local selfValue = 0
    if targetType == MarchTargetType.ATTACK_MONSTER or targetType == MarchTargetType.RALLY_FOR_BOSS then
      local marchInfo = CS.SceneManager.World:GetMarch(self.view.ctrl.targetUuid)
      if marchInfo then
        local monsterId = marchInfo.monsterId
        local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
        if monster ~= nil then
          if 0 < monster.monster_resistance then
            resistance = monster.monster_resistance + SeasonUtil.GetBloodyNightResistanceValueAdd()
          end
          selfValue = SeasonUtil.GetSelfSeasonResistanceValue()
        end
      end
    else
      selfValue = SeasonUtil.GetSelfSeasonResistanceValue()
      resistance = SeasonUtil.GetResistanceByPoint(self.view.ctrl.targetPoint)
    end
    if resistance and 0 < resistance then
      if fixedSoldierType == SoldierType.Mummy then
        local effect94115 = LuaEntry.Effect:GetGameEffect(94115)
        if effect94115 ~= nil and effect94115 ~= 0 then
          selfValue = selfValue + effect94115
        end
      end
      self:SetActive(true)
      self.kx_current_title:SetLocalText("season_tiles_popui_info010")
      self.kx_require_title:SetLocalText("season_tiles_popui_info011")
      self.kx_current_num:SetText(string.GetFormattedSeparatorNum(toInt(selfValue)))
      self.kx_require_num:SetText(string.GetFormattedSeparatorNum(toInt(resistance)))
      self.need_resistance = resistance
      self.has_resistance = selfValue
      if resistance <= selfValue then
        self.kang_xing_msg:SetActive(false)
        self.kang_xing_msg_btn:SetActive(false)
        self.kx_detail:SetLocalText("season_tiles_popui_info007")
        self.kx_require_num:SetColorHex("#5FEF87")
      else
        self.kang_xing_msg:SetActive(true)
        self.kang_xing_msg_btn:SetActive(true)
        self.kx_detail:SetLocalText("season_tiles_popui_info006")
        self.kx_require_num:SetColorHex("#F97077")
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.kang_xing_msg.rectTransform)
      end
    else
      self:SetActive(false)
    end
  end
  return self.has_resistance or 0, self.need_resistance or 0
end

function FormationSeasonResistance:Update1000MS()
  if ComponentIsValid(self.kang_xing_msg) then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.kang_xing_msg.rectTransform)
  end
end

return FormationSeasonResistance
