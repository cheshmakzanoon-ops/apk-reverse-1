local p_btn_select_path = "p_btn_select"
local p_trans_rotation_root_path = "p_trans_rotation_root"
local p_img_btn_select_path = "p_trans_rotation_root/center/p_img_btn_select"
local p_img_bg_tips_path = "p_img_bg_tips"
local p_img_icon_arrow_path = "p_img_bg_tips/p_img_icon_arrow"
local p_img_icon_tips_path = "p_img_bg_tips/p_img_icon_tips"
local p_text_tips_title_path = "p_img_bg_tips/p_text_tips_title"
local p_text_tips_time_path = "p_img_bg_tips/p_text_tips_time"
local p_img_btn_select_duihao_path = "p_img_btn_select_duihao"
local eff_glow_path = "p_img_bg_tips/Eff_glow/Eff_ui_S5_AllianceWarTimeSet_time_glow"
local base = UIBaseContainer
local SeasonAllianceWarTimeSetSelectionComp = BaseClass("SeasonAllianceWarTimeSetSelectionComp", UIBaseContainer)

function SeasonAllianceWarTimeSetSelectionComp:ComponentDefine()
  self.p_btn_select = self:AddComponent(UIButton, p_btn_select_path)
  self.p_btn_select:SetOnClick(BindCallback(self, self.OnSelectClicked))
  self.p_trans_rotation_root = self:AddComponent(UIBaseContainer, p_trans_rotation_root_path)
  self.p_img_btn_select = self:AddComponent(UIImage, p_img_btn_select_path)
  self.p_img_bg_tips = self:AddComponent(UIImage, p_img_bg_tips_path)
  self.p_img_icon_arrow = self:AddComponent(UIImage, p_img_icon_arrow_path)
  self.p_img_icon_tips = self:AddComponent(UIImage, p_img_icon_tips_path)
  self.p_text_tips_title = self:AddComponent(UITextMeshProUGUIEx, p_text_tips_title_path)
  self.p_text_tips_time = self:AddComponent(UITextMeshProUGUIEx, p_text_tips_time_path)
  self.p_img_btn_select_duihao = self:AddComponent(UIImage, p_img_btn_select_duihao_path)
  self.eff_glow = self:AddComponent(UIBaseContainer, eff_glow_path)
end

function SeasonAllianceWarTimeSetSelectionComp:ComponentDestroy()
  self.p_comp_animator = nil
  self.p_btn_select = nil
  self.p_trans_rotation_root = nil
  self.p_img_btn_select = nil
  self.p_img_bg_tips = nil
  self.p_img_icon_arrow = nil
  self.p_img_icon_tips = nil
  self.p_text_tips_title = nil
  self.p_text_tips_time = nil
  self.p_img_btn_select_duihao = nil
  self.eff_glow = nil
end

function SeasonAllianceWarTimeSetSelectionComp:DataDefine()
  self.DefineArrowRed = ""
  self.DefineArrowGreen = ""
end

function SeasonAllianceWarTimeSetSelectionComp:DataDestroy()
end

function SeasonAllianceWarTimeSetSelectionComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonAllianceWarTimeSetSelectionComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonAllianceWarTimeSetSelectionComp:OnAddListener()
  base.OnAddListener(self)
end

function SeasonAllianceWarTimeSetSelectionComp:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SeasonAllianceWarTimeSetSelectionComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function SeasonAllianceWarTimeSetSelectionComp:InitData(data)
  if data ~= nil then
    self.Data = data
    self.ConfigData = DataCenter.UILWSeasonAllianceWarTimeManager:GetWarTimeConfigData(self.Data.TimeIndex)
    return true
  end
  return false
end

function SeasonAllianceWarTimeSetSelectionComp:InitUi()
  self.p_img_icon_tips:LoadSpriteAsync(self.ConfigData:GetImgClock())
  self.p_text_tips_title:SetLocalText(self:GetTitleText())
  if self.Data.IsLocalTime then
    self.p_text_tips_time:SetText(self.ConfigData:GetLocalTimeRangeStr())
  else
    self.p_text_tips_time:SetText(self.ConfigData:GetServerTimeRangeStr())
  end
  self.p_img_icon_arrow:SetColor(self:GetBgColor())
end

function SeasonAllianceWarTimeSetSelectionComp:UpdateData()
  return true
end

function SeasonAllianceWarTimeSetSelectionComp:UpdateUi()
  self.p_img_btn_select:LoadSpriteAsync(self:GetImgArrow())
end

function SeasonAllianceWarTimeSetSelectionComp:GetArrowRotation()
  if self.Data ~= nil then
    if self.Data.TimeIndex == 0 then
      return 120
    elseif self.Data.TimeIndex == 1 then
      return 0
    elseif self.Data.TimeIndex == 2 then
      return -120
    end
  end
  return 0
end

function SeasonAllianceWarTimeSetSelectionComp:GetImgArrow()
  if self.Data ~= nil then
    if self.Data.IsSelect then
      return "Assets/Main/SeasonRes/S5/Sprites/AllianceWarTime/mjc_S5_MZ_shezhi_yuan_zhizhen2_2.png"
    else
      return "Assets/Main/SeasonRes/S5/Sprites/AllianceWarTime/mjc_S5_MZ_shezhi_yuan_zhizhen2_1.png"
    end
  end
  return ""
end

function SeasonAllianceWarTimeSetSelectionComp:GetTitleText()
  if self.Data ~= nil then
    if self.Data.IsSelect then
      if self.Data.TimeIndex == 0 then
        return "s5_alliance_battle_time_ui100"
      elseif self.Data.TimeIndex == 1 then
        return "s5_alliance_battle_time_ui110"
      elseif self.Data.TimeIndex == 2 then
        return "s5_alliance_battle_time_ui120"
      end
    elseif self.Data.TimeIndex == 0 then
      return "s5_alliance_battle_time_ui10"
    elseif self.Data.TimeIndex == 1 then
      return "s5_alliance_battle_time_ui11"
    elseif self.Data.TimeIndex == 2 then
      return "s5_alliance_battle_time_ui12"
    end
  end
  return ""
end

function SeasonAllianceWarTimeSetSelectionComp:GetBgColor()
  if self.Data ~= nil and self.Data.IsSelect then
    return Color.New(0.31, 0.54, 0.4, 1)
  end
  return Color.New(0.31, 0.3, 0.29, 1)
end

function SeasonAllianceWarTimeSetSelectionComp:OnSelectClicked()
  if not DataCenter.UILWSeasonAllianceWarTimeManager:IsSetValid(true) then
    return
  end
  if self.Data ~= nil then
    self.view:TryClickSelection(self.Data.TimeIndex)
  end
end

function SeasonAllianceWarTimeSetSelectionComp:PlayConfirm(show)
  self.eff_glow:SetActive(show)
end

return SeasonAllianceWarTimeSetSelectionComp
