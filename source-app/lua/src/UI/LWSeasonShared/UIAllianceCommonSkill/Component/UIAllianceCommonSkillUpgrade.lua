local base = UIBaseContainer
local UIAllianceCommonSkillUpgrade = BaseClass("UIAllianceCommonSkillUpgrade", base)
local AllianceSkillItemView = require("UI.LWSeasonShared.UIAllianceCommonSkill.Component.AllianceSkillItemView")
local AllianceSkillDonateFishLogic = require("UI.LWSeason6.UILWSeasonDonateFish.Logic.AllianceSkillDonateFishLogic")
local sr_UICommonLoopListViewVertical_path = "UICommonLoopListViewVertical"
local sli_Slider_path = "BottomBar/LW_Simple_Slider/Slider"
local txt_slider_path = "BottomBar/LW_Simple_Slider/txt_Slider"
local txt_count_path = "BottomBar/txt_count"
local btn_CommonButton_path = "BottomBar/CommonButton"
local img_energy_path = "BottomBar/LW_Simple_Slider/img_Slider"

function UIAllianceCommonSkillUpgrade:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  SFSNetwork.SendMessage(MsgDefines.AllianceGovernmentSkillGetList)
  SFSNetwork.SendMessage(MsgDefines.AllianceSkillEnergyGetInfo)
end

function UIAllianceCommonSkillUpgrade:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllianceCommonSkillUpgrade:ComponentDefine()
  self.sli_Slider = self:AddComponent(UISlider, sli_Slider_path)
  self.txt_slider = self:AddComponent(UIText, txt_slider_path)
  self.txt_count = self:AddComponent(UIText, txt_count_path)
  self.btn_CommonButton = self:AddComponent(UIButton, btn_CommonButton_path)
  self.img_energy = self:AddComponent(UIImage, img_energy_path)
  self.btn_CommonButton:SetOnClick(BindCallback(self, self.ClickUpgrade))
  self.sr_UICommonLoopListViewVertical = self:AddComponent(UILoopListViewSimple, sr_UICommonLoopListViewVertical_path)
  self.sr_UICommonLoopListViewVertical:Init(AllianceSkillItemView)
end

function UIAllianceCommonSkillUpgrade:ComponentDestroy()
  self.sr_UICommonLoopListViewVertical = nil
  self.sli_Slider = nil
  self.txt_slider = nil
  self.txt_count = nil
  self.btn_CommonButton = nil
  self.img_energy = nil
end

function UIAllianceCommonSkillUpgrade:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateAllianceGovernmentCommonSkillList, self.RefreshList)
  self:AddUIListener(EventId.UpdateAllianceGovernmentCommonEnergyList, self.RefreshSlider)
end

function UIAllianceCommonSkillUpgrade:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateAllianceGovernmentCommonSkillList, self.RefreshList)
  self:RemoveUIListener(EventId.UpdateAllianceGovernmentCommonEnergyList, self.RefreshSlider)
  base.OnRemoveListener(self)
end

function UIAllianceCommonSkillUpgrade:ClickUpgrade()
  local energy = DataCenter.AllianceGovernmentCommonSkillManager:GetEnergyInfo()
  local logic = AllianceSkillDonateFishLogic.New(energy)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonDonateFish, {anim = true}, logic)
end

function UIAllianceCommonSkillUpgrade:ReInit()
  self:RefreshList()
  self:RefreshSlider()
end

function UIAllianceCommonSkillUpgrade:RefreshList()
  self.showDataList = DataCenter.AllianceGovernmentCommonSkillManager:GetSkillList()
  self.sr_UICommonLoopListViewVertical:Clear()
  for _, v in ipairs(self.showDataList) do
    self.sr_UICommonLoopListViewVertical:AddData(v)
  end
  self.sr_UICommonLoopListViewVertical:Show()
end

function UIAllianceCommonSkillUpgrade:RefreshSlider()
  local energy = DataCenter.AllianceGovernmentCommonSkillManager:GetEnergyInfo()
  if not energy:IsSyncServer() then
    return
  end
  local energyMax = energy:GetMaxEnergy()
  self.sli_Slider:SetValue(energy.currentEnergy / energyMax)
  self.txt_slider:SetText(string.GetFormattedStr(energy.currentEnergy) .. "/" .. string.GetFormattedStr(energyMax))
  self.img_energy:LoadSpriteAsync(energy:GetCostIcon())
  local donateInfo = energy:GetDonateInfo()
  if donateInfo then
    if donateInfo.num == 0 then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local deltaTime = energy.donateInfo.cdEndTime - curTime
      self.txt_count:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    else
      self.txt_count:SetLocalText(141114, donateInfo.num .. "/" .. donateInfo.max)
    end
  end
end

function UIAllianceCommonSkillUpgrade:Update1000MS()
  local energy = DataCenter.AllianceGovernmentCommonSkillManager:GetEnergyInfo()
  local donateInfo = energy:GetDonateInfo()
  if donateInfo and donateInfo.num == 0 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = energy.donateInfo.cdEndTime - curTime
    self.txt_count:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    if deltaTime < 0 then
      donateInfo.num = 1
      SFSNetwork.SendMessage(MsgDefines.AllianceSkillEnergyGetInfo)
    end
  end
end

return UIAllianceCommonSkillUpgrade
