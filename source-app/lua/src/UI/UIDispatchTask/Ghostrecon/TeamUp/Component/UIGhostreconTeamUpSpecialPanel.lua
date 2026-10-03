local base = UIBaseContainer
local UIGhostreconTeamUpSpecialPanel = BaseClass("UIGhostreconTeamUpSpecialPanel", base)
local UIGhostreconTeamCell = require("UI.UIDispatchTask.Ghostrecon.Component.UIGhostreconTeamCell")
local titleText_path = "TitleTxt"
local teamCell1_path = "TeamPanel/TeamCell1"
local teamCell2_path = "TeamPanel/TeamCell2"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.teamCell1 = self:AddComponent(UIGhostreconTeamCell, teamCell1_path)
  self.teamCell2 = self:AddComponent(UIGhostreconTeamCell, teamCell2_path)
  self.titleText:SetLocalText("ghostrecon_007")
end

local function ComponentDestroy(self)
  self.titleText = nil
  self.teamCell1 = nil
  self.teamCell2 = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.isMeet = nil
end

local function SetData(self, uuid)
  local taskInfo = DataCenter.ActGhostreconManager:GetTaskInfoByUUid(uuid)
  local cfg = DataCenter.ActGhostreconManager:GetTaskTemplate(taskInfo.cfgId)
  local superConditions = cfg.superCondions
  local meetNums = cfg:GetSuperCondionNumsByMemberList(taskInfo.memberList)
  self.isMeet = true
  for i = 1, 2 do
    local cell = self["teamCell" .. i]
    if superConditions[i] then
      cell:SetActive(true)
      cell:SetData(superConditions[i], meetNums and meetNums[i] or 0)
      if not cell:IsMeet() then
        self.isMeet = false
      end
    else
      cell:SetActive(false)
    end
  end
end

local function IsMeet(self)
  return self.isMeet
end

UIGhostreconTeamUpSpecialPanel.OnCreate = OnCreate
UIGhostreconTeamUpSpecialPanel.OnDestroy = OnDestroy
UIGhostreconTeamUpSpecialPanel.OnEnable = OnEnable
UIGhostreconTeamUpSpecialPanel.OnDisable = OnDisable
UIGhostreconTeamUpSpecialPanel.ComponentDefine = ComponentDefine
UIGhostreconTeamUpSpecialPanel.ComponentDestroy = ComponentDestroy
UIGhostreconTeamUpSpecialPanel.DataDefine = DataDefine
UIGhostreconTeamUpSpecialPanel.DataDestroy = DataDestroy
UIGhostreconTeamUpSpecialPanel.SetData = SetData
UIGhostreconTeamUpSpecialPanel.IsMeet = IsMeet
return UIGhostreconTeamUpSpecialPanel
