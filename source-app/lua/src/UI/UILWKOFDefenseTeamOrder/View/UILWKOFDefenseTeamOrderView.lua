local UILWKOFDefenseTeamOrderView = BaseClass("UILWKOFDefenseTeamOrderView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local closePanel_path = "panel"
local closeBtn_path = "CloseBtn"
local defTeam1_path = "Root/DefTeam1"
local defTeam2_path = "Root/DefTeam2"
local defTeam3_path = "Root/DefTeam3"
local switch1Btn_path = "Root/SwitchBtn1"
local switch2Btn_path = "Root/SwitchBtn2"
local random_toggle_path = "Root/RandomToggle"
local UILWKOFDefenseTeamOrderItem = require("UI.UILWKOFDefenseTeamOrder.Component.UILWKOFDefenseTeamOrderItem")
local UIHeroPVPFormationSelectPanel = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.UIHeroPVPFormationSelectPanel")

function UILWKOFDefenseTeamOrderView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UILWKOFDefenseTeamOrderView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UILWKOFDefenseTeamOrderView:OnAddListener()
  base.OnAddListener(self)
end

function UILWKOFDefenseTeamOrderView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWKOFDefenseTeamOrderView:ComponentDefine()
  self.closePanel = self:AddComponent(UIButton, closePanel_path)
  self.closePanel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.defTeam1 = self:AddComponent(UILWKOFDefenseTeamOrderItem, defTeam1_path)
  self.defTeam2 = self:AddComponent(UILWKOFDefenseTeamOrderItem, defTeam2_path)
  self.defTeam3 = self:AddComponent(UILWKOFDefenseTeamOrderItem, defTeam3_path)
  self.switch1Btn = self:AddComponent(UIButton, switch1Btn_path)
  self.switch1Btn:SetOnClick(function()
    DataCenter.LWKOFBattleManager:SwitchSelfDefTeam(1, 2)
    self:Refresh()
  end)
  self.switch2Btn = self:AddComponent(UIButton, switch2Btn_path)
  self.switch2Btn:SetOnClick(function()
    DataCenter.LWKOFBattleManager:SwitchSelfDefTeam(2, 3)
    self:Refresh()
  end)
  self.selectPanel = self:AddComponent(UIHeroPVPFormationSelectPanel, random_toggle_path)
  self.selectPanel:SetActive(false)
end

function UILWKOFDefenseTeamOrderView:DataDefine()
end

function UILWKOFDefenseTeamOrderView:ComponentDestroy()
end

function UILWKOFDefenseTeamOrderView:DataDestroy()
end

function UILWKOFDefenseTeamOrderView:ReInit()
  self:Refresh()
end

function UILWKOFDefenseTeamOrderView:ConvertTeamDataToShowData(teamData)
  if not teamData then
    return {}
  end
  local showData = {}
  local heroesUuid = teamData:GetLocalAllHeroes()
  for index, uuid in pairs(heroesUuid) do
    local heroData = {}
    heroData.heroUuid = uuid
    showData[index] = heroData
  end
  return showData
end

function UILWKOFDefenseTeamOrderView:Refresh()
  local defTeam1Info = DataCenter.LWKOFBattleManager:GetSelfDefTeamByIndex(1)
  local defTeam2Info = DataCenter.LWKOFBattleManager:GetSelfDefTeamByIndex(2)
  local defTeam3Info = DataCenter.LWKOFBattleManager:GetSelfDefTeamByIndex(3)
  local defTeam1ShowData = self:ConvertTeamDataToShowData(defTeam1Info)
  self.defTeam1:SetData(defTeam1ShowData, string.GetFormattedStr(defTeam1Info:GetTotalCapacity()))
  local defTeam2ShowData = self:ConvertTeamDataToShowData(defTeam2Info)
  self.defTeam2:SetData(defTeam2ShowData, string.GetFormattedStr(defTeam2Info:GetTotalCapacity()))
  local defTeam3ShowData = self:ConvertTeamDataToShowData(defTeam3Info)
  self.defTeam3:SetData(defTeam3ShowData, string.GetFormattedStr(defTeam3Info:GetTotalCapacity()))
  self:RefreshSelectPanel()
end

function UILWKOFDefenseTeamOrderView:RefreshSelectPanel()
  self.selectPanel:SetActive(false)
  if DataCenter.LWKOFBattleManager:GetType() == TypeKOF.NewPeakArena then
    self.selectPanel:SetActive(true)
    self.selectPanel:SetData(UserSettingKey.NEW_ARENA_KOF_RANDOM, "alliance_train_013")
  end
end

return UILWKOFDefenseTeamOrderView
