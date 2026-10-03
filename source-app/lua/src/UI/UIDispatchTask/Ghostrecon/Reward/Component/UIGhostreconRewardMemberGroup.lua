local UIGhostreconRewardMemberGroup = BaseClass("UIGhostreconRewardMemberGroup", UIBaseContainer)
local base = UIBaseContainer
local UIGhostreconRewardMemberItem = require("UI.UIDispatchTask.Ghostrecon.Reward.Component.UIGhostreconRewardMemberItem")
local ActGhostreconMemberInfo = require("DataCenter.ActivityListData.ActGhostrecon.ActGhostreconMemberInfo")
local member_item1_path = "MemberItem1"
local member_item2_path = "MemberItem2"
local member_item3_path = "MemberItem3"
local member_item4_path = "MemberItem4"

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
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.member_item1 = self:AddComponent(UIGhostreconRewardMemberItem, member_item1_path)
  self.member_item2 = self:AddComponent(UIGhostreconRewardMemberItem, member_item2_path)
  self.member_item3 = self:AddComponent(UIGhostreconRewardMemberItem, member_item3_path)
  self.member_item4 = self:AddComponent(UIGhostreconRewardMemberItem, member_item4_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.member_item1 = nil
  self.member_item2 = nil
  self.member_item3 = nil
  self.member_item4 = nil
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function SetItem(self, data)
  self.data = data
  for i = 1, 4 do
    local memberInfo
    if data[i] then
      memberInfo = ActGhostreconMemberInfo.New()
      memberInfo:ParseData(data[i])
    end
    local memberItem = self["member_item" .. i]
    if memberInfo and memberInfo.uid ~= LuaEntry.Player.uid then
      memberItem:SetActive(true)
      memberItem:SetData(memberInfo.uid, memberInfo.memberInfo, data[i])
    else
      memberItem:SetActive(false)
    end
  end
end

UIGhostreconRewardMemberGroup.OnCreate = OnCreate
UIGhostreconRewardMemberGroup.OnDestroy = OnDestroy
UIGhostreconRewardMemberGroup.OnEnable = OnEnable
UIGhostreconRewardMemberGroup.OnDisable = OnDisable
UIGhostreconRewardMemberGroup.ComponentDefine = ComponentDefine
UIGhostreconRewardMemberGroup.ComponentDestroy = ComponentDestroy
UIGhostreconRewardMemberGroup.DataDefine = DataDefine
UIGhostreconRewardMemberGroup.DataDestroy = DataDestroy
UIGhostreconRewardMemberGroup.OnAddListener = OnAddListener
UIGhostreconRewardMemberGroup.OnRemoveListener = OnRemoveListener
UIGhostreconRewardMemberGroup.SetItem = SetItem
return UIGhostreconRewardMemberGroup
