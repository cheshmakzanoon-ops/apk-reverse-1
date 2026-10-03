local WorldAlMinePanel_Construct = BaseClass("WorldAlMinePanel_Construct", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local mineIcon_path = "layout/icon"
local mineDesc_path = "layout/desc"
local prog_path = "prog"
local needTime_path = "prog/needTime"
local progNum_path = "progNum"
local memberCount_path = "memberCount"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DelCountDownTimer()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.mineIconN = self:AddComponent(UIImage, mineIcon_path)
  self.mineDescN = self:AddComponent(UIText, mineDesc_path)
  self.progN = self:AddComponent(UISlider, prog_path)
  self.needTimeN = self:AddComponent(UIText, needTime_path)
  self.progNumN = self:AddComponent(UIText, progNum_path)
  self.memberCountN = self:AddComponent(UIText, memberCount_path)
  
  function self.CountDownTimerAction()
    self:RefreshRemainTime()
  end
end

local function ComponentDestroy(self)
  self.mineDescN = nil
  self.progN = nil
  self.needTimeN = nil
  self.progNumN = nil
  self.memberCountN = nil
end

local function DataDefine(self)
  self.pointId = nil
  self.mineInfo = nil
  self.mineTemplate = nil
end

local function DataDestroy(self)
  self.pointId = nil
  self.mineInfo = nil
  self.mineTemplate = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, pointId)
  self.pointId = pointId
  self:RefreshPanel()
end

local function RefreshPanel(self)
  local detail
  local pointInfo = CS.SceneManager.World:GetPointInfo(self.pointId)
  if pointInfo then
    detail = DataCenter.WorldPointDetailManager:GetDetailByPointId(pointInfo.mainIndex)
  end
  if not detail then
    return
  end
  self.mineInfo = detail.alBuilding
  if not self.mineInfo then
    return
  end
  self.mineTemplate = DataCenter.AllianceMineManager:GetAllianceMineTemplate(self.mineInfo.buildId)
  if self.mineTemplate and self.mineInfo.status == AllianceMineStatus.Constructing then
    self.mineIconN:LoadSprite(self.mineTemplate:GetIconPath())
    local str = Localization:GetString("300754")
    self.mineDescN:SetText(str)
    local needT = (self.mineTemplate.resDurable - self.mineInfo.durability) / self.mineInfo.buildSpeed
    self.endTime = self.mineInfo.lastBuildTime + needT * 1000
    self:AddCountDownTimer()
    self:RefreshRemainTime()
    if not string.IsNullOrEmpty(self.mineInfo.allianceId) and self.mineInfo.allianceId == LuaEntry.Player.allianceId then
      self.memberCountN:SetActive(false)
      self.progNumN:SetActive(true)
    else
      self.progNumN:SetActive(false)
      self.memberCountN:SetActive(true)
      self.memberCountN:SetText(self.mineInfo.soldierNum)
    end
  end
end

local function AddCountDownTimer(self)
  if self.countDownTimer == nil then
    self.countDownTimer = TimerManager:GetInstance():GetTimer(1, self.CountDownTimerAction, self, false, false, false)
  end
  self.countDownTimer:Start()
end

local function RefreshRemainTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.endTime - curTime
  if remainTime ~= nil and 0 < remainTime then
    self.needTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    local tempProg = self.mineInfo:GetConstructDurability() / self.mineTemplate.resDurable
    self.progN:SetValue(tempProg)
    self.progNumN:SetText(string.GetFormattedPercentStr(tempProg))
  else
    self.needTimeN:SetText("")
    self.progN:SetValue(1)
    self.progNumN:SetText("100%")
    self:DelCountDownTimer()
  end
end

local function DelCountDownTimer(self)
  if self.countDownTimer ~= nil then
    self.countDownTimer:Stop()
    self.countDownTimer = nil
  end
end

WorldAlMinePanel_Construct.OnCreate = OnCreate
WorldAlMinePanel_Construct.OnDestroy = OnDestroy
WorldAlMinePanel_Construct.OnEnable = OnEnable
WorldAlMinePanel_Construct.OnDisable = OnDisable
WorldAlMinePanel_Construct.ComponentDefine = ComponentDefine
WorldAlMinePanel_Construct.ComponentDestroy = ComponentDestroy
WorldAlMinePanel_Construct.DataDefine = DataDefine
WorldAlMinePanel_Construct.DataDestroy = DataDestroy
WorldAlMinePanel_Construct.OnAddListener = OnAddListener
WorldAlMinePanel_Construct.OnRemoveListener = OnRemoveListener
WorldAlMinePanel_Construct.SetData = SetData
WorldAlMinePanel_Construct.RefreshPanel = RefreshPanel
WorldAlMinePanel_Construct.AddCountDownTimer = AddCountDownTimer
WorldAlMinePanel_Construct.RefreshRemainTime = RefreshRemainTime
WorldAlMinePanel_Construct.DelCountDownTimer = DelCountDownTimer
return WorldAlMinePanel_Construct
