local base = UIBaseContainer
local UIGhostreconTaskMemberPanel = BaseClass("UIGhostreconTaskMemberPanel", base)
local UIGhostreconTaskMemberCell = require("UI.UIDispatchTask.Ghostrecon.Task.Component.UIGhostreconTaskMemberCell")
local titleText_path = "TitleText"
local tipBtn_path = "TipBtn"
local memberCell1_path = "ListPanel/MemberCell1"
local memberCell2_path = "ListPanel/MemberCell2"
local memberCell3_path = "ListPanel/MemberCell3"
local memberCell4_path = "ListPanel/MemberCell4"
local memberCell5_path = "ListPanel/MemberCell5"

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
  self.titleText = self:AddComponent(UIBaseContainer, titleText_path)
  self.tipBtn = self:AddComponent(UIButton, tipBtn_path)
  self.memberCell1 = self:AddComponent(UIGhostreconTaskMemberCell, memberCell1_path)
  self.memberCell2 = self:AddComponent(UIGhostreconTaskMemberCell, memberCell2_path)
  self.memberCell3 = self:AddComponent(UIGhostreconTaskMemberCell, memberCell3_path)
  self.memberCell4 = self:AddComponent(UIGhostreconTaskMemberCell, memberCell4_path)
  self.memberCell5 = self:AddComponent(UIGhostreconTaskMemberCell, memberCell5_path)
  self.tipBtn:SetOnClick(function()
    local param = {}
    param.uuid = self.uuid
    param.width = 550
    param.alignObject = self.tipBtn
    param.yPosFix = 20
    param.showArrow = true
    param.width = 400
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostreconMemberListTip, {anim = true}, param)
  end)
end

local function ComponentDestroy(self)
  self.titleText = nil
  self.tipBtn = nil
  self.memberCell1 = nil
  self.memberCell2 = nil
  self.memberCell3 = nil
  self.memberCell4 = nil
  self.memberCell5 = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.uuid = nil
  self.taskInfo = nil
end

local function SetData(self, uuid)
  self.uuid = uuid
  self.taskInfo = DataCenter.ActGhostreconManager:GetTaskInfoByUUid(uuid)
  for i = 1, 5 do
    if self.taskInfo.memberList[i] then
      self["memberCell" .. i]:SetData(self.taskInfo.memberList[i].memberInfo)
    else
      self["memberCell" .. i]:SetData(nil)
    end
  end
end

UIGhostreconTaskMemberPanel.OnCreate = OnCreate
UIGhostreconTaskMemberPanel.OnDestroy = OnDestroy
UIGhostreconTaskMemberPanel.OnEnable = OnEnable
UIGhostreconTaskMemberPanel.OnDisable = OnDisable
UIGhostreconTaskMemberPanel.ComponentDefine = ComponentDefine
UIGhostreconTaskMemberPanel.ComponentDestroy = ComponentDestroy
UIGhostreconTaskMemberPanel.DataDefine = DataDefine
UIGhostreconTaskMemberPanel.DataDestroy = DataDestroy
UIGhostreconTaskMemberPanel.SetData = SetData
return UIGhostreconTaskMemberPanel
