local WorldPointGhostrecon = BaseClass("WorldPointGhostrecon", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGhostreconPlayerItem = require("UI.UIDispatchTask.Ghostrecon.Component.UIGhostreconPlayerItem")
local ActGhostreconTaskInfo = require("DataCenter.ActivityListData.ActGhostrecon.ActGhostreconTaskInfo")
local UIGhostreconRewardBoxBtn = require("UI.UIDispatchTask.Ghostrecon.Component.UIGhostreconRewardBoxBtn")
local member_panel_path = "MemberPanel"
local reward_panel_path = "RewardPanel"
local special_reward_panel_path = "SpecialRewardPanel"
local alliance_tip_panel_path = "AllianceTipPanel"
local protect_tip_path = "protectTip"
local server_tip_path = "serverTips"
local member_desc_path = "MemberPanel/MemberDesc"
local leader_head_path = "MemberPanel/HeadContent/LeaderHead"
local member_item1_path = "MemberPanel/HeadContent/MemberContent/MemberItem1"
local member_item2_path = "MemberPanel/HeadContent/MemberContent/MemberItem2"
local member_item3_path = "MemberPanel/HeadContent/MemberContent/MemberItem3"
local member_item4_path = "MemberPanel/HeadContent/MemberContent/MemberItem4"
local reward_item_path = "RewardPanel/ScrollView/Viewport/RewardItem"
local reward_content_path = "RewardPanel/ScrollView/Viewport/RewardContent"
local reawrd_desc_path = "RewardPanel/ReawrdDesc"
local special_reward_desc_path = "SpecialRewardPanel/SpecialRewardDesc"
local alliance_tip_path = "AllianceTipPanel/AllianceTip"
local special_scroll_view_path = "SpecialRewardPanel/SpecialScrollView"
local special_reward_box_path = "SpecialRewardPanel/SpecialScrollView/RewardBoxPanel"

function WorldPointGhostrecon:OnCreate()
  base.OnCreate(self)
  self.requestWorldDetail = nil
  self.member_panel = self:AddComponent(UIBaseContainer, member_panel_path)
  self.reward_panel = self:AddComponent(UIBaseContainer, reward_panel_path)
  self.special_reward_panel = self:AddComponent(UIBaseContainer, special_reward_panel_path)
  self.alliance_tip_panel = self:AddComponent(UIBaseContainer, alliance_tip_panel_path)
  self.protect_tip = self:AddComponent(UIText, protect_tip_path)
  self.member_desc = self:AddComponent(UIText, member_desc_path)
  self.leader_head = self:AddComponent(UIGhostreconPlayerItem, leader_head_path)
  self.member_item1 = self:AddComponent(UIGhostreconPlayerItem, member_item1_path)
  self.member_item2 = self:AddComponent(UIGhostreconPlayerItem, member_item2_path)
  self.member_item3 = self:AddComponent(UIGhostreconPlayerItem, member_item3_path)
  self.member_item4 = self:AddComponent(UIGhostreconPlayerItem, member_item4_path)
  self.theItem = self.transform:Find(reward_item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.reward_content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.reawrd_desc = self:AddComponent(UIText, reawrd_desc_path)
  self.special_reward_desc = self:AddComponent(UIText, special_reward_desc_path)
  self.alliance_tip = self:AddComponent(UIText, alliance_tip_path)
  self.special_scroll_img = self:AddComponent(UIImage, special_scroll_view_path)
  self.rewardBox = self:AddComponent(UIGhostreconRewardBoxBtn, special_reward_box_path)
  self.serverTips = self:AddComponent(UIText, server_tip_path)
  self.member_panel:SetActive(false)
  self.reward_panel:SetActive(false)
  self.special_reward_panel:SetActive(false)
  self.alliance_tip_panel:SetActive(false)
  self.protect_tip:SetActive(false)
  self.serverTips:SetActive(false)
  self.member_desc:SetLocalText("ghostrecon_009")
  self.reawrd_desc:SetLocalText("ghostrecon_010")
  self.alliance_tip:SetLocalText("ghostrecon_013")
  self.protect_tip:SetLocalText("ghostrecon_014")
end

function WorldPointGhostrecon:OnDestroy()
  self.reward_content:RemoveComponents(UICommonResItem)
  self.theItem:GameObjectRecycleAll()
  self.theItem = nil
  self.member_panel = nil
  self.reward_panel = nil
  self.special_reward_panel = nil
  self.alliance_tip_panel = nil
  self.protect_tip = nil
  self.serverTips = nil
  self.member_desc = nil
  self.leader_head = nil
  self.member_item1 = nil
  self.member_item2 = nil
  self.member_item3 = nil
  self.member_item4 = nil
  self.reward_content = nil
  self.reawrd_desc = nil
  self.alliance_tip = nil
  self.rewardBox = nil
  self.pointData = nil
  self.pointId = nil
  self.info = nil
  base.OnDestroy(self)
end

function WorldPointGhostrecon:OnEnable()
  base.OnEnable(self)
end

function WorldPointGhostrecon:OnDisable()
  base.OnDisable(self)
end

function WorldPointGhostrecon:RefreshData(pointData, pointId, info)
  self.pointData = pointData
  self.pointId = pointId
  self.info = info
  self:UpdateInfo()
end

function WorldPointGhostrecon:UpdateInfo()
  local detail = DataCenter.WorldPointDetailManager:GetDetailByPointId(self.pointId)
  if detail == nil or self.pointData == nil or self.pointData.cfgId == nil or self.pointData.uuid == nil or detail.taskInfo == nil or detail.taskInfo.uuid ~= self.pointData.uuid then
    if self.pointId and self.requestWorldDetail ~= true then
      SFSNetwork.SendMessage(MsgDefines.WorldGetDetail, self.pointId, self.view.ctrl.serverId, 0)
      self.requestWorldDetail = true
    end
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local cfg = DataCenter.ActGhostreconManager:GetTaskTemplate(self.pointData.cfgId)
  local todayStealNum = DataCenter.ActGhostreconManager.stealTimes
  local maxStealNum = DataCenter.ActGhostreconManager:GetNowSettingCfg().stealCount
  if self.pointData.completionTime == 0 then
    self.member_panel:SetActive(false)
    self.reward_panel:SetActive(false)
    self.special_reward_panel:SetActive(false)
    self.alliance_tip_panel:SetActive(false)
    self.protect_tip:SetActive(true)
    self.serverTips:SetActive(false)
    self.info.protectGhostrecon = true
  elseif now >= self.pointData.completionTime then
    if self.pointData:OwnIsJoin() then
      if self.pointData:OwnHaveReward() then
        self.view.ctrl:CloseSelf()
      else
        self.member_panel:SetActive(true)
        self:RefreshMemberPanel()
        self.reward_panel:SetActive(false)
        self.special_reward_panel:SetActive(false)
        self.alliance_tip_panel:SetActive(true)
        self.protect_tip:SetActive(false)
        self.serverTips:SetActive(false)
      end
    elseif self.pointData:OwnIsAlly() then
      self.member_panel:SetActive(true)
      self:RefreshMemberPanel()
      self.reward_panel:SetActive(false)
      self.special_reward_panel:SetActive(false)
      self.alliance_tip_panel:SetActive(true)
      self.protect_tip:SetActive(false)
      self.serverTips:SetActive(false)
    elseif todayStealNum < maxStealNum then
      self.member_panel:SetActive(true)
      self:RefreshMemberPanel()
      self.reward_panel:SetActive(true)
      self:RefreshRewardPanel()
      self.special_reward_panel:SetActive(false)
      self.alliance_tip_panel:SetActive(false)
      self.protect_tip:SetActive(false)
      local info = CS.SceneManager.World:GetPointInfo(self.pointId)
      if info ~= nil then
        local canGet = DataCenter.ActGhostreconManager:IsCanGetTheReward(info.ownerServer)
        self.serverTips:SetActive(not canGet)
      else
        self.serverTips:SetActive(false)
      end
    else
      self.member_panel:SetActive(false)
      self.reward_panel:SetActive(false)
      self.special_reward_panel:SetActive(false)
      self.alliance_tip_panel:SetActive(false)
      self.protect_tip:SetActive(true)
      self.serverTips:SetActive(false)
    end
  elseif self.pointData:OwnIsLeader() then
    self.member_panel:SetActive(true)
    self:RefreshMemberPanel()
    self.reward_panel:SetActive(true)
    self:RefreshRewardPanel()
    if cfg:HaveSuperReward() then
      self.special_reward_panel:SetActive(true)
      self:RefreshSpecialPanel()
    else
      self.special_reward_panel:SetActive(false)
    end
    self.alliance_tip_panel:SetActive(false)
  elseif self.pointData:OwnIsJoin() then
    self.member_panel:SetActive(true)
    self:RefreshMemberPanel()
    if self.pointData:OwnCanReward() then
      self.reward_panel:SetActive(true)
      self:RefreshRewardPanel()
      if cfg:HaveSuperReward() then
        self.special_reward_panel:SetActive(true)
        self:RefreshSpecialPanel()
      else
        self.special_reward_panel:SetActive(false)
      end
      self.alliance_tip_panel:SetActive(false)
    else
      self.reward_panel:SetActive(false)
      self.special_reward_panel:SetActive(false)
      self.alliance_tip_panel:SetActive(true)
    end
    self.protect_tip:SetActive(false)
    self.serverTips:SetActive(false)
  elseif self.pointData:OwnIsAlly() then
    self.member_panel:SetActive(true)
    self:RefreshMemberPanel()
    self.reward_panel:SetActive(false)
    self.special_reward_panel:SetActive(false)
    self.alliance_tip_panel:SetActive(true)
    self.protect_tip:SetActive(false)
    self.serverTips:SetActive(false)
  elseif self.pointData.completionTime - now <= 600000 then
    self.member_panel:SetActive(true)
    self:RefreshMemberPanel()
    self.reward_panel:SetActive(true)
    self:RefreshRewardPanel()
    self.special_reward_panel:SetActive(false)
    self.alliance_tip_panel:SetActive(false)
    self.protect_tip:SetActive(false)
    local info = CS.SceneManager.World:GetPointInfo(self.pointId)
    if info ~= nil then
      local canGet = DataCenter.ActGhostreconManager:IsCanGetTheReward(info.ownerServer)
      self.serverTips:SetActive(not canGet)
    else
      self.serverTips:SetActive(false)
    end
  else
    self.member_panel:SetActive(false)
    self.reward_panel:SetActive(false)
    self.special_reward_panel:SetActive(false)
    self.alliance_tip_panel:SetActive(false)
    self.protect_tip:SetActive(true)
    self.serverTips:SetActive(false)
    self.info.protectGhostrecon = true
  end
end

function WorldPointGhostrecon:RefreshMemberPanel()
  local detail = DataCenter.WorldPointDetailManager:GetDetailByPointId(self.pointId)
  local taskInfo = detail.taskInfo
  if taskInfo and taskInfo.leaderMemberInfo then
    self.leader_head:SetData(taskInfo.leaderMemberInfo.memberInfo)
    for i = 1, 4 do
      local member = self["member_item" .. i]
      if taskInfo.noLeaderMemberList[i] then
        member:SetActive(true)
        member:SetData(taskInfo.noLeaderMemberList[i].memberInfo)
      else
        member:SetActive(false)
      end
    end
  end
end

function WorldPointGhostrecon:RefreshRewardPanel()
  local detail = DataCenter.WorldPointDetailManager:GetDetailByPointId(self.pointId)
  local extraRewards = detail.reward
  local goItem, theItem
  self.reward_content:RemoveComponents(UICommonResItem)
  self.theItem:GameObjectRecycleAll()
  if extraRewards ~= nil then
    for i, data in ipairs(extraRewards) do
      local theName = "item_" .. i
      goItem = self.theItem:GameObjectSpawn(self.reward_content.transform)
      goItem.name = theName
      goItem:SetActive(true)
      theItem = self.reward_content:AddComponent(UICommonResItem, theName)
      if data.rewardType or param.itemId then
        local buildAddNum, itemId = DataCenter.ActDispatchTaskDataManager:GetBuildAddRewardInfo()
        if self.pointData:OwnIsJoin() and 0 < buildAddNum and tonumber(data.itemId) == itemId then
          data.isShowArrow = true
        end
        theItem:ReInit(data)
      else
        local param = {}
        param.rewardType = data.type
        if type(data.value) == "table" then
          param.itemId = data.value.id
          param.count = data.value.num
        else
          param.itemId = data.type
          param.count = data.value
        end
        param.rewardType = data.type
        param.heroUuid = data.heroUuid
        param.isHeroBox = data.isHeroBox
        local buildAddNum, itemId = DataCenter.ActDispatchTaskDataManager:GetBuildAddRewardInfo()
        if self.pointData:OwnIsJoin() and 0 < buildAddNum and tonumber(param.itemId) == itemId then
          param.isShowArrow = true
        end
        theItem:ReInit(param)
      end
    end
  end
end

function WorldPointGhostrecon:RefreshSpecialPanel()
  local detail = DataCenter.WorldPointDetailManager:GetDetailByPointId(self.pointId)
  local isSuperRewardActive = detail.isSuperRewardActive or 0
  local cfg = DataCenter.ActGhostreconManager:GetTaskTemplate(self.pointData.cfgId)
  self.rewardBox:SetData(cfg)
  if isSuperRewardActive == 0 then
    self.special_scroll_img:SetColorRGBA(0.8901960784313725, 0.8588235294117647, 0.8431372549019608)
    CS.UIGray.SetGray(self.rewardBox.transform, true, true)
    self.special_reward_desc:SetLocalText("ghostrecon_011")
  else
    self.special_scroll_img:SetColorRGBA(0.8274509803921568, 0.9490196078431372, 0.7294117647058823)
    CS.UIGray.SetGray(self.rewardBox.transform, false, true)
    self.special_reward_desc:SetLocalText("ghostrecon_012")
  end
end

function WorldPointGhostrecon:Update100MS()
  if self.pointData and self.pointData.completionTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.pointData.completionTime - curTime
    if 0 < remainTime then
    else
      self.completionTime = nil
      EventManager:GetInstance():Broadcast(EventId.GhostreconRefreshWorldPointBtn)
    end
  end
end

return WorldPointGhostrecon
