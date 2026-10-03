local UIWorldOutpostCityFix = BaseClass("UIWorldOutpostCityFix", UILayoutElement)
local base = UILayoutElement
local Localization = CS.GameEntry.Localization
local FetchOutpostRepairInfo = require("Net.Msgs.Season5.Outpost.FetchOutpostRepairInfoMessage")
local UIWorldOutpostCityFixItem = require("UI.LWWorld.UIWorldOutpostCityPoint.Component.UIWorldOutpostCityFixItem")
local repair_pprogress_txt_path = "bg/RepairPprogressTxt"
local progress_build_path = "bg/progressBuild"
local progress_text_path = "bg/progressBuild/progressBg/progressText"
local rank_path = "Rank"
local t3_path = "Rank/t3"
local t2_path = "Rank/t2"
local t1_path = "Rank/t1"
local rank_content_path = "Rank/Content"
local rank_list_item1_path = "Rank/Content/RankListItem1"
local rank_list_item2_path = "Rank/Content/RankListItem2"
local rank_list_item3_path = "Rank/Content/RankListItem3"
local occupat_eff_key_path = "Status/OccupatEffKey"
local occupat_eff_value_path = "Status/OccupatEffValue"
local mgr_path = "Manager"
local mgr_btn_path = "Manager/MgrBtn"
local mgr_tips_path = "Manager/MgrTips"
local mgr_icon_path = "Manager/MgrIcon"
local status_path = "Status"
local line_content1_path = "LineContent1"
local line_content2_path = "LineContent2"
local city_force_path = "cityForce"
local city_force_btn_path = "cityForce/bg/cityForceBtn"
local city_force_icon_path = "cityForce/cityForceIcon"
local city_force_value_path = "cityForce/cityForceValue"
local line_content3_path = "LineContent3"

function UIWorldOutpostCityFix:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.t3:SetLocalText("war_zone_outpost_7")
  self.t2:SetLocalText("war_zone_outpost_6")
  self.t1:SetLocalText("war_zone_outpost_5")
  self.mgr_tips:SetLocalText("457006")
  self.mgr_btn:SetOnClick(function()
    self:OnMgrClick()
  end)
  local seasonSubType = SeasonUtil.GetSeasonSubdivisionType(false, ServerEnum.View)
  local templates = DataCenter.GovernmentTemplateManager:GetTemplatesByType(GovOfficialType.Outpost, seasonSubType)
  self.official:SetActive(0 < #templates)
  self.city_force_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonS5CrossOccupyDetail)
  end)
end

function UIWorldOutpostCityFix:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWorldOutpostCityFix:ComponentDefine()
  self.line_content1 = self:AddComponent(UIBaseContainer, line_content1_path)
  self.line_content2 = self:AddComponent(UIBaseContainer, line_content2_path)
  self.repair_progress_txt = self:AddComponent(UITextMeshProUGUIEx, repair_pprogress_txt_path)
  self.progress_build = self:AddComponent(UISlider, progress_build_path)
  self.progress_text = self:AddComponent(UITextMeshProUGUIEx, progress_text_path)
  self.rankRoot = self:AddComponent(UILayoutElement, rank_path)
  self.t3 = self:AddComponent(UITextMeshProUGUIEx, t3_path)
  self.t2 = self:AddComponent(UITextMeshProUGUIEx, t2_path)
  self.t1 = self:AddComponent(UITextMeshProUGUIEx, t1_path)
  self.rankContent = self:AddComponent(UIBaseComponent, rank_content_path)
  self.rank_list_item1 = self:AddComponent(UIWorldOutpostCityFixItem, rank_list_item1_path)
  self.rank_list_item2 = self:AddComponent(UIWorldOutpostCityFixItem, rank_list_item2_path)
  self.rank_list_item3 = self:AddComponent(UIWorldOutpostCityFixItem, rank_list_item3_path)
  self.statusRoot = self:AddComponent(UIImage, status_path)
  self.status_eff_key = self:AddComponent(UITextMeshProUGUIEx, occupat_eff_key_path)
  self.status_eff_value = self:AddComponent(UITextMeshProUGUIEx, occupat_eff_value_path)
  self.official = self:AddComponent(UIBaseComponent, mgr_path)
  self.mgr_btn = self:AddComponent(UIButton, mgr_btn_path)
  self.mgr_tips = self:AddComponent(UITextMeshProUGUIEx, mgr_tips_path)
  self.mgr_icon = self:AddComponent(UIImage, mgr_icon_path)
  self.city_force = self:AddComponent(UIBaseContainer, city_force_path)
  self.city_force_btn = self:AddComponent(UIButton, city_force_btn_path)
  self.city_force_icon = self:AddComponent(UIImage, city_force_icon_path)
  self.city_force_value = self:AddComponent(UITextMeshProUGUIEx, city_force_value_path)
  self.line_content3 = self:AddComponent(UIBaseContainer, line_content3_path)
end

function UIWorldOutpostCityFix:ComponentDestroy()
  self.city_force = nil
  self.city_force_btn = nil
  self.city_force_icon = nil
  self.city_force_value = nil
  self.line_content3 = nil
  self.line_content1 = nil
  self.line_content2 = nil
  self.repair_progress_txt = nil
  self.progress_build = nil
  self.progress_text = nil
  self.rankRoot = nil
  self.t3 = nil
  self.t2 = nil
  self.t1 = nil
  self.rank_list_item1 = nil
  self.rank_list_item2 = nil
  self.rank_list_item3 = nil
  self.statusRoot = nil
  self.status_eff_key = nil
  self.status_eff_value = nil
  self.mgr_btn = nil
  self.mgr_tips = nil
  self.mgr_icon = nil
end

function UIWorldOutpostCityFix:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OutpostRepairInfoUpdate, self.OnRepairInfoUpdate)
end

function UIWorldOutpostCityFix:OnRemoveListener()
  self:RemoveUIListener(EventId.OutpostRepairInfoUpdate, self.OnRepairInfoUpdate)
  base.OnRemoveListener(self)
end

function UIWorldOutpostCityFix:OnMgrClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonOfficialMain, {anim = true}, GovOfficialType.Outpost, self.view.ctrl.serverId, self.view.ctrl.cityId)
end

function UIWorldOutpostCityFix:InitData(param)
  self.param = param
  self.cityMeta = param.meta
  self.fixActData = param.fixActData
  self.extraInfo = param.extraInfo
  self.ok = param.state == 0 and param.fixActData ~= nil
  self:SetActive(self.ok)
  self:RefreshUI()
end

function UIWorldOutpostCityFix:RefreshData(serverData)
  self.serverData = serverData
  self.outpostRepairInfo = serverData.outpostRepairInfo
  self:RefreshUI()
end

function UIWorldOutpostCityFix:OnRepairInfoUpdate()
  if self.param then
    self.outpostRepairInfo = FetchOutpostRepairInfo.GetRepairInfo(self.param.serverId, self.param.cityId, false)
    self:RefreshUI()
  end
end

function UIWorldOutpostCityFix:RefreshUI()
  if self.fixActData and self.ok then
    local data = self.outpostRepairInfo or {}
    local outpostInfo = data.outpostInfo or {}
    local needPoint = toInt(self.fixActData.para)
    local hasPoint = toInt(outpostInfo.repairScore)
    self.repair_progress_txt:SetLocalText("war_zone_outpost_4", hasPoint, needPoint)
    self.progress_text:SetText(string.format("%s/%s", hasPoint, needPoint))
    if 0 < needPoint then
      self.progress_build:SetValue(hasPoint / needPoint)
    else
      self.progress_build:SetValue(0)
    end
    local rankArr
    local repairRank = data.repairRank
    if repairRank then
      rankArr = repairRank.rankArr
    end
    if rankArr and 0 < #rankArr then
      table.sort(rankArr, function(a, b)
        return a.rank < b.rank
      end)
      self.rank_list_item1:ReInit(1, rankArr[1])
      self.rank_list_item2:ReInit(2, rankArr[2])
      self.rank_list_item3:ReInit(3, rankArr[3])
      self.rankRoot:SetActive(true)
      self.line_content2:SetActive(true)
    else
      self.rankRoot:SetActive(false)
      self.line_content2:SetActive(false)
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rankContent.transform)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rankRoot.transform)
    if self.cityMeta and self.cityMeta.buff ~= nil and self.cityMeta.buff ~= "" and self.cityMeta.buff ~= 0 then
      local effectId, effectValue = string.match(self.cityMeta.buff, "([^;]+);([^;]+)")
      if effectId and effectValue then
        local buffAddNum, effectName = UIUtil.GetEffectStr(nil, effectValue, effectId)
        if buffAddNum ~= nil then
          if effectName ~= nil then
            self.status_eff_value:SetText(Localization:GetString(effectName) .. buffAddNum)
          else
            self.status_eff_value:SetText(buffAddNum)
          end
          self.status_eff_key:SetLocalText("war_zone_outpost_11")
          self.statusRoot:SetActive(true)
        else
          self.statusRoot:SetActive(false)
        end
      else
        self.statusRoot:SetActive(false)
      end
    else
      self.statusRoot:SetActive(false)
    end
    local force_num = 0
    if self.cityMeta then
      force_num = toInt(self.cityMeta.force)
    end
    if 0 < force_num then
      local value = string.GetFormattedSeparatorNum(force_num)
      self.line_content3:SetActive(true)
      self.city_force:SetActive(true)
      self.city_force_value:SetLocalText("season_s1_add_city_desc01", value)
    else
      self.line_content3:SetActive(false)
      self.city_force:SetActive(false)
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

return UIWorldOutpostCityFix
