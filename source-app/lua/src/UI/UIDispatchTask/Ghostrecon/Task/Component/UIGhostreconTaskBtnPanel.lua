local base = UIBaseContainer
local UIGhostreconTaskBtnPanel = BaseClass("UIGhostreconTaskBtnPanel", base)
local flushedBtn_path = "FlushedBtn"
local deployBtn_path = "DeployBtn"
local flushedBtnText_path = "FlushedBtn/FlushedBtnText"
local deployBtnText_path = "DeployBtn/DeployBtnText"

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
  self.flushedBtn = self:AddComponent(UIButton, flushedBtn_path)
  self.deployBtn = self:AddComponent(UIButton, deployBtn_path)
  self.flushedBtnText = self:AddComponent(UIText, flushedBtnText_path)
  self.deployBtnText = self:AddComponent(UIText, deployBtnText_path)
  self.flushedBtn:SetOnClick(Bind(self, self.OnClickFlushedBtn))
  self.flushedBtn:SetActive(false)
  self.deployBtn:SetOnClick(Bind(self, self.OnClickDeployBtn))
  self.deployBtnText:SetLocalText("ghostrecon_030")
end

local function ComponentDestroy(self)
  self.flushedBtn = nil
  self.deployBtn = nil
  self.flushedBtnText = nil
  self.deployBtnText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.uuid = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GhostreconTaskPutPointInWorld, self.OnGhostreconTaskPutPointInWorld)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.GhostreconTaskPutPointInWorld, self.OnGhostreconTaskPutPointInWorld)
  base.OnAddListener(self)
end

local function SetData(self, uuid)
  self.uuid = uuid
end

local function OnClickFlushedBtn(self)
end

local function OnClickDeployBtn(self)
  local taskInfo = DataCenter.ActGhostreconManager:GetTaskInfoByUUid(self.uuid)
  if taskInfo.pointId == nil or taskInfo.pointId == 0 then
    SFSNetwork.SendMessage(MsgDefines.GhostReconPutPointInWorld, self.uuid)
  else
    self:OnGhostreconTaskPutPointInWorld(self.uuid)
  end
end

local function OnGhostreconTaskPutPointInWorld(self, uuid)
  if uuid == self.uuid then
    local taskInfo = DataCenter.ActGhostreconManager:GetTaskInfoByUUid(uuid)
    if taskInfo and taskInfo.pointId then
      DataCenter.ActGhostreconManager:JumpToPoint(taskInfo.pointId, taskInfo.uuid, taskInfo.targetServer)
    end
  end
end

UIGhostreconTaskBtnPanel.OnCreate = OnCreate
UIGhostreconTaskBtnPanel.OnDestroy = OnDestroy
UIGhostreconTaskBtnPanel.OnEnable = OnEnable
UIGhostreconTaskBtnPanel.OnDisable = OnDisable
UIGhostreconTaskBtnPanel.ComponentDefine = ComponentDefine
UIGhostreconTaskBtnPanel.ComponentDestroy = ComponentDestroy
UIGhostreconTaskBtnPanel.DataDefine = DataDefine
UIGhostreconTaskBtnPanel.DataDestroy = DataDestroy
UIGhostreconTaskBtnPanel.OnAddListener = OnAddListener
UIGhostreconTaskBtnPanel.OnRemoveListener = OnRemoveListener
UIGhostreconTaskBtnPanel.SetData = SetData
UIGhostreconTaskBtnPanel.OnClickFlushedBtn = OnClickFlushedBtn
UIGhostreconTaskBtnPanel.OnClickDeployBtn = OnClickDeployBtn
UIGhostreconTaskBtnPanel.OnGhostreconTaskPutPointInWorld = OnGhostreconTaskPutPointInWorld
return UIGhostreconTaskBtnPanel
