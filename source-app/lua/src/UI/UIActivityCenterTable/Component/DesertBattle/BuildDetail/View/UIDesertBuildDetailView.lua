local UIDesertBuildDetailView = BaseClass("UIDesertBuildDetailView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UIDesertBuildDetailItem = require("UI.UIActivityCenterTable.Component.DesertBattle.BuildDetail.Component.UIDesertBuildDetailItem")
local BuffIcon = require("UI.LWMainUI.Component.UIMainLeft.BuffIcon")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local icon_path = "PopUpTitle/Common_bg_orange2/icon"
local title_text_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content/TitleText"
local first_control_root_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content/GameObject"
local first_control_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content/GameObject/FirstControl"
local first_control_add_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content/GameObject/FirstControl/FirstControlAdd"
local first_control_al_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content/GameObject/GameObject/FirstControlAL"
local first_control_al_add_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content/GameObject/GameObject/FirstControlAL/FirstControlALAdd"
local first_control_player_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content/GameObject/GameObject/FirstControlPlayer"
local first_control_player_add_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content/GameObject/GameObject/FirstControlPlayer/FirstControlPlayerAdd"
local effect_root_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content/EffectRoot"
local effect_title_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content/EffectRoot/EffectTitle"
local effect1_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content/EffectRoot/EffectList/Effect1"
local effect_desc1_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content/EffectRoot/EffectList/Effect1/EffectDesc1"
local effect_buff1_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content/EffectRoot/EffectList/Effect1/EffectBuff1"
local effect_value1_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content/EffectRoot/EffectList/Effect1/EffectValue1"
local effect2_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content/EffectRoot/EffectList/Effect2"
local effect_dec2_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content/EffectRoot/EffectList/Effect2/EffectDec2"
local effect_buff2_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content/EffectRoot/EffectList/Effect2/EffectBuff2"
local effect_value2_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content/EffectRoot/EffectList/Effect2/EffectValue2"

function UIDesertBuildDetailView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self:ComponentDefine()
end

function UIDesertBuildDetailView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDesertBuildDetailView:OnAddListener()
  base.OnAddListener(self)
end

function UIDesertBuildDetailView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIDesertBuildDetailView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText(self.param.name)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.icon = self:AddComponent(UIImage, icon_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.first_control_root = self:AddComponent(UIImage, first_control_root_path)
  self.first_control = self:AddComponent(UIText, first_control_path)
  self.first_control_add = self:AddComponent(UIText, first_control_add_path)
  self.first_control_al = self:AddComponent(UIText, first_control_al_path)
  self.first_control_al_add = self:AddComponent(UIText, first_control_al_add_path)
  self.first_control_player = self:AddComponent(UIText, first_control_player_path)
  self.first_control_player_add = self:AddComponent(UIText, first_control_player_add_path)
  self.effect_root = self:AddComponent(UIImage, effect_root_path)
  self.effect_title = self:AddComponent(UIText, effect_title_path)
  self.effect1 = self:AddComponent(UIBaseContainer, effect1_path)
  self.effect_desc1 = self:AddComponent(UIText, effect_desc1_path)
  self.effect_buff1 = self:AddComponent(BuffIcon, effect_buff1_path)
  self.effect_value1 = self:AddComponent(UIText, effect_value1_path)
  self.effect2 = self:AddComponent(UIBaseContainer, effect2_path)
  self.effect_dec2 = self:AddComponent(UIText, effect_dec2_path)
  self.effect_buff2 = self:AddComponent(BuffIcon, effect_buff2_path)
  self.effect_value2 = self:AddComponent(UIText, effect_value2_path)
  local template = DataCenter.DragonBuildTemplateManager:GetTemplate(self.param.buildId)
  if template then
    self.icon:LoadSpriteAuto(template:GetIconPath())
    self.icon:SetAspectSize(280)
    self.title_text:SetLocalText(template.des)
    if 10110 == self.param.buildId then
      self.first_control_root:SetActive(false)
      self.effect_root:SetActive(false)
      return
    end
    self.first_control_root:SetActive(true)
    self.first_control:SetText("")
    self.first_control_add:SetLocalText("458196")
    self.first_control_al:SetText("")
    self.first_control_al_add:SetText("+" .. template.point_produce_per_second .. "/s")
    self.first_control_player:SetText("")
    local tbName = BattleFieldUtil.GetBattleFieldCfgValue(BattleFieldType.Desert, BattleFieldTableKey.P_POINT_ID)
    local pointShow
    if not string.IsNullOrEmpty(tbName) then
      if template.id == 10120 then
        local scoreId = LocalController:instance():getValue(tbName, 2, "score_detail")
        local points = LocalController:instance():getIntValue(TableName.Score, scoreId, "points", 1)
        pointShow = template.gather_point_per_second * points
      else
        local scoreId = LocalController:instance():getValue(tbName, 3, "score_detail")
        pointShow = LocalController:instance():getValue(TableName.Score, scoreId, "points", 30)
      end
    end
    if string.IsNullOrEmpty(pointShow) then
      pointShow = toInt(template.point_produce_per_second * 0.5)
    end
    self.first_control_player_add:SetText(string.format("+%s/s", pointShow))
    self.effect_title:SetLocalText("458202")
    if #template.effectList > 0 then
      local item1 = template.effectList[1]
      local item2 = template.effectList[2]
      self.effect_root:SetActive(true)
      if item1 ~= nil then
        self.effect1:SetActive(true)
        self.effect_desc1:SetLocalText(item1.descID)
        local buffAddNum = ""
        local value = item1.value
        local type = item1.num_type
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
        if item1.effect_icon then
          self.effect_buff1.item_icon:LoadSpriteAuto(item1.effect_icon)
        else
          self.effect_buff1:ReInit(item1)
        end
      else
        self.effect1:SetActive(false)
      end
      if item2 ~= nil then
        self.effect2:SetActive(true)
        self.effect_dec2:SetLocalText(item2.descID)
        local buffAddNum = ""
        local value = item2.value
        local type = item2.num_type
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
        if item2.effect_icon then
          self.effect_buff2.item_icon:LoadSpriteAuto(item2.effect_icon)
        else
          self.effect_buff2:ReInit(item2)
        end
      else
        self.effect2:SetActive(false)
      end
    else
      self.effect_root:SetActive(false)
    end
  end
end

function UIDesertBuildDetailView:ComponentDestroy()
  self.btn_back = nil
end

function UIDesertBuildDetailView:UpdateData()
end

return UIDesertBuildDetailView
