local base = require("UI.UILWHero.UIHeroSimpleTip.View.UIArrowTipBase")
local UIGhostreconMemberListTipView = BaseClass("UIGhostreconMemberListTipView", base)
local UIGhostreconMemberCell = require("UI.UIDispatchTask.Ghostrecon.MemberTip.Component.UIGhostreconMemberCell")
local memberCell1_path = "Root/ImgBg/Content/MemberCell1"
local memberCell2_path = "Root/ImgBg/Content/MemberCell2"
local memberCell3_path = "Root/ImgBg/Content/MemberCell3"
local memberCell4_path = "Root/ImgBg/Content/MemberCell4"
local memberCell5_path = "Root/ImgBg/Content/MemberCell5"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  base.ComponentDefine(self)
  self.memberCell1 = self:AddComponent(UIGhostreconMemberCell, memberCell1_path)
  self.memberCell2 = self:AddComponent(UIGhostreconMemberCell, memberCell2_path)
  self.memberCell3 = self:AddComponent(UIGhostreconMemberCell, memberCell3_path)
  self.memberCell4 = self:AddComponent(UIGhostreconMemberCell, memberCell4_path)
  self.memberCell5 = self:AddComponent(UIGhostreconMemberCell, memberCell5_path)
end

local function ComponentDestroy(self)
  self.memberCell1 = nil
  self.memberCell2 = nil
  self.memberCell3 = nil
  self.memberCell4 = nil
  self.memberCell5 = nil
  base.ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  self:AddUIListener(EventId.GhostreconTaskRefreshAll, self.RefreshShow)
  self:AddUIListener(EventId.GhostreconRefreshOneTask, self.OnGhostreconRefreshTask)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.GhostreconTaskRefreshAll, self.RefreshShow)
  self:RemoveUIListener(EventId.GhostreconRefreshOneTask, self.OnGhostreconRefreshTask)
end

local function RefreshShow(self)
  base.RefreshShow(self)
  local data = DataCenter.ActGhostreconManager:GetTaskInfoByUUid(self.param.uuid)
  if data then
    local memberList = data.memberList
    local lastIndex = 1
    for i = 1, 5 do
      if memberList[i] then
        self["memberCell" .. i]:SetData(self.param.uuid, i, self.param.formTeamUp)
        self["memberCell" .. i]:SetActive(true)
        lastIndex = i
      else
        self["memberCell" .. i]:SetActive(false)
      end
    end
    self["memberCell" .. lastIndex]:HideLineImg()
  else
    self.ctrl:CloseSelf()
  end
end

local function OnGhostreconRefreshTask(self, param)
  if param.uuid == self.param.uuid then
    self:RefreshShow()
  end
end

UIGhostreconMemberListTipView.OnCreate = OnCreate
UIGhostreconMemberListTipView.OnDestroy = OnDestroy
UIGhostreconMemberListTipView.OnEnable = OnEnable
UIGhostreconMemberListTipView.OnDisable = OnDisable
UIGhostreconMemberListTipView.ComponentDefine = ComponentDefine
UIGhostreconMemberListTipView.ComponentDestroy = ComponentDestroy
UIGhostreconMemberListTipView.DataDefine = DataDefine
UIGhostreconMemberListTipView.DataDestroy = DataDestroy
UIGhostreconMemberListTipView.RefreshShow = RefreshShow
UIGhostreconMemberListTipView.OnAddListener = OnAddListener
UIGhostreconMemberListTipView.OnRemoveListener = OnRemoveListener
UIGhostreconMemberListTipView.OnGhostreconRefreshTask = OnGhostreconRefreshTask
return UIGhostreconMemberListTipView
