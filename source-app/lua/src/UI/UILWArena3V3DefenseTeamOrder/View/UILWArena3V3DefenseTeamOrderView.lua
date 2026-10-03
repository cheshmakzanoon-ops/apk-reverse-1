local UILWArena3V3DefenseTeamOrderView = BaseClass("UILWArena3V3DefenseTeamOrderView", UIBaseView)
local base = UIBaseView
local closePanel_path = "panel"
local closeBtn_path = "CloseBtn"
local defTeam1_path = "Root/DefTeam1"
local defTeam2_path = "Root/DefTeam2"
local defTeam3_path = "Root/DefTeam3"
local switch1Btn_path = "Root/SwitchBtn1"
local switch2Btn_path = "Root/SwitchBtn2"
local UILW3V3TeamItem = require("UI.UILW3V3Campaign.Component.UILW3V3TeamItem")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
  self:Refresh()
end

local function OnDisable(self)
  self.active = false
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.closePanel = self:AddComponent(UIButton, closePanel_path)
  self.closePanel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.defTeam1 = self:AddComponent(UILW3V3TeamItem, defTeam1_path)
  self.defTeam2 = self:AddComponent(UILW3V3TeamItem, defTeam2_path)
  self.defTeam3 = self:AddComponent(UILW3V3TeamItem, defTeam3_path)
  self.switch1Btn = self:AddComponent(UIButton, switch1Btn_path)
  self.switch1Btn:SetOnClick(function()
    DataCenter.LW3V3Manager:SwitchSelfDefTeam(1, 2)
    self:Refresh()
  end)
  self.switch2Btn = self:AddComponent(UIButton, switch2Btn_path)
  self.switch2Btn:SetOnClick(function()
    DataCenter.LW3V3Manager:SwitchSelfDefTeam(2, 3)
    self:Refresh()
  end)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function ConvertTeamDataToShowData(self, teamData)
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

local function Refresh(self)
  local defTeam1Info = DataCenter.LW3V3Manager:GetSelfDefTeamByIndex(1)
  local defTeam2Info = DataCenter.LW3V3Manager:GetSelfDefTeamByIndex(2)
  local defTeam3Info = DataCenter.LW3V3Manager:GetSelfDefTeamByIndex(3)
  local defTeam1ShowData = ConvertTeamDataToShowData(self, defTeam1Info)
  
  local function GetDominatorData(teamInfo)
    local dominatorData
    local dominatorUuid = teamInfo:GetLocalDominatorUuid()
    if dominatorUuid and 0 < dominatorUuid then
      local info = DataCenter.DominatorManager:GetInfoByUuid(dominatorUuid)
      if info then
        dominatorData = {
          heroId = info.dominatorId,
          rankLv = info:GetCurRankLv()
        }
      end
    end
    return dominatorData
  end
  
  self.defTeam1:SetData(defTeam1ShowData, string.GetFormattedStr(defTeam1Info:GetTotalCapacity()), GetDominatorData(defTeam1Info))
  local defTeam2ShowData = ConvertTeamDataToShowData(self, defTeam2Info)
  self.defTeam2:SetData(defTeam2ShowData, string.GetFormattedStr(defTeam2Info:GetTotalCapacity()), GetDominatorData(defTeam2Info))
  local defTeam3ShowData = ConvertTeamDataToShowData(self, defTeam3Info)
  self.defTeam3:SetData(defTeam3ShowData, string.GetFormattedStr(defTeam3Info:GetTotalCapacity()), GetDominatorData(defTeam3Info))
end

UILWArena3V3DefenseTeamOrderView.OnCreate = OnCreate
UILWArena3V3DefenseTeamOrderView.OnDestroy = OnDestroy
UILWArena3V3DefenseTeamOrderView.OnEnable = OnEnable
UILWArena3V3DefenseTeamOrderView.OnDisable = OnDisable
UILWArena3V3DefenseTeamOrderView.ComponentDefine = ComponentDefine
UILWArena3V3DefenseTeamOrderView.ComponentDestroy = ComponentDestroy
UILWArena3V3DefenseTeamOrderView.DataDefine = DataDefine
UILWArena3V3DefenseTeamOrderView.DataDestroy = DataDestroy
UILWArena3V3DefenseTeamOrderView.Refresh = Refresh
return UILWArena3V3DefenseTeamOrderView
