local UILWSeasonMakeFriendsHasFriend = BaseClass("UILWSeasonMakeFriendsHasFriend", UIAsyncContainer)
local base = UIAsyncContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local MarkData = require("UI.LWSeason6.MakeFriends.UILWSeasonMakeFriendsMainUI.Component.UILWSeasonAllianceFriendMarkData")
local red_point_num_history_path = "BtnHistory/RedPointNumHistory"
local text_history_path = "BtnHistory/RedPointNumHistory/TextHistory"
local icon_path = "alliances/icon"
local my_alli_path = "alliances/MyAlli"
local my_alli_name_path = "alliances/MyAlli/MyAlliName"
local other_alli_path = "alliances/OtherAlli"
local other_alli_name_path = "alliances/OtherAlli/OtherAlliName"
local btn_connect_path = "alliances/BtnConnect"
local go_text_path = "alliances/BtnConnect/GoText"
local day_detail_path = "GameObject/DayDetail"
local btn_history_path = "BtnHistory"
local p_btn_help1_path = "p_btn_help1"
local p_btn_help2_path = "p_btn_help2"
local p_btn_help3_path = "Title/PlanList/p_btn_help3"
local condition1_path = "ScrollView/Viewport/Content/Condition1"
local condition2_path = "ScrollView/Viewport/Content/Condition2"
local condition3_path = "ScrollView/Viewport/Content/Condition3"
local condition4_path = "ScrollView/Viewport/Content/Condition4"
local condition5_path = "ScrollView/Viewport/Content/Condition5"
local condition11_path = "ScrollView/Viewport/Content/Condition11"
local condition12_path = "ScrollView/Viewport/Content/Condition12"
local condition13_path = "ScrollView/Viewport/Content/Condition13"
local condition14_path = "ScrollView/Viewport/Content/Condition14"
local condition15_path = "ScrollView/Viewport/Content/Condition15"
local title_path = "Title"
local no_plan_path = "ScrollView/Viewport/Content/NoPlan"

function UILWSeasonMakeFriendsHasFriend:OnCreate()
  base.OnCreate(self)
  local offsetMin = self.rectTransform.offsetMin
  local offsetMax = self.rectTransform.offsetMax
  self.rectTransform:Set_offsetMin(offsetMin.x, 0)
  self.rectTransform:Set_offsetMax(offsetMax.x, 0)
  self.title = self:AddComponent(UIBaseContainer, title_path)
  self.no_plan = self:AddComponent(UITextMeshProUGUIEx, no_plan_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.my_alli = self:AddComponent(UIButton, my_alli_path)
  self.my_alli_name = self:AddComponent(UITextMeshProUGUIEx, my_alli_name_path)
  self.other_alli = self:AddComponent(UIButton, other_alli_path)
  self.other_alli_name = self:AddComponent(UITextMeshProUGUIEx, other_alli_name_path)
  self.my_alli:SetOnClick(function()
    local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if data ~= nil and data.abbr ~= nil then
      UIUtil.TryShowAllianceInfo(data.createServer or data.ownerServerId, data.uid)
    end
  end)
  self.other_alli:SetOnClick(function()
    local data = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(self.allyAllianceId)
    if data ~= nil then
      UIUtil.TryShowAllianceInfo(data.createServer or data.ownerServerId, data.uid)
    end
  end)
  self.day_detail = self:AddComponent(UITextMeshProUGUIEx, day_detail_path)
  self.btn_history = self:AddComponent(UIButton, btn_history_path)
  self.p_btn_help1 = self:AddComponent(UIButton, p_btn_help1_path)
  self.p_btn_help2 = self:AddComponent(UIButton, p_btn_help2_path)
  self.p_btn_help3 = self:AddComponent(UIButton, p_btn_help3_path)
  self.btn_connect = self:AddComponent(UIButton, btn_connect_path)
  self.go_text = self:AddComponent(UITextMeshProUGUIEx, go_text_path)
  self.btn_history:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonMakeFriendsHistory)
  end)
  self.p_btn_help1:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, {
      howToPlayList = {600001}
    })
  end)
  self.p_btn_help2:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, {
      howToPlayList = {600002}
    })
  end)
  self.p_btn_help3:SetOnClick(function()
    UIUtil.ShowButtonTips(self.p_btn_help3, nil, "s6_alliance_ally_desc70", false)
  end)
  self.btn_connect:SetOnClick(function()
    if self.allyAllianceId ~= nil and self.allyAllianceId ~= "" then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonMakeFriendsLinkedCity, {anim = true}, self.allyAllianceId)
    else
      UIUtil.ShowTipsId("avatar_tips006")
    end
  end)
  self.condition1 = self:AddComponent(MarkData, condition1_path)
  self.condition2 = self:AddComponent(MarkData, condition2_path)
  self.condition3 = self:AddComponent(MarkData, condition3_path)
  self.condition4 = self:AddComponent(MarkData, condition4_path)
  self.condition5 = self:AddComponent(MarkData, condition5_path)
  self.condition11 = self:AddComponent(MarkData, condition11_path)
  self.condition12 = self:AddComponent(MarkData, condition12_path)
  self.condition13 = self:AddComponent(MarkData, condition13_path)
  self.condition14 = self:AddComponent(MarkData, condition14_path)
  self.condition15 = self:AddComponent(MarkData, condition15_path)
  self.history_red_point_root = self:AddComponent(UIBaseContainer, red_point_num_history_path)
  self.history_red_point_text = self:AddComponent(UITextMeshProUGUIEx, text_history_path)
end

function UILWSeasonMakeFriendsHasFriend:OnDestroy()
  self.history_red_point_root = nil
  self.history_red_point_text = nil
  self.icon = nil
  self.my_alli = nil
  self.my_alli_name = nil
  self.other_alli = nil
  self.other_alli_name = nil
  self.day_detail = nil
  self.btn_history = nil
  self.p_btn_help1 = nil
  self.p_btn_help2 = nil
  self.p_btn_help3 = nil
  self.btn_connect = nil
  self.go_text = nil
  self.condition1 = nil
  self.condition2 = nil
  self.condition3 = nil
  self.condition4 = nil
  self.condition5 = nil
  self.condition11 = nil
  self.condition12 = nil
  self.condition13 = nil
  self.condition14 = nil
  self.condition15 = nil
  self.title = nil
  self.no_plan = nil
  base.OnDestroy(self)
end

function UILWSeasonMakeFriendsHasFriend:OnEnable()
  base.OnEnable(self)
  self:OnAllyLogUpdate()
end

function UILWSeasonMakeFriendsHasFriend:OnDisable()
  base.OnDisable(self)
end

function UILWSeasonMakeFriendsHasFriend:UpdateData()
  self.allyAllianceId = DataCenter.SeasonAllyFriendManager:GetFriendAllyId()
  if self.allyAllianceId ~= nil and self.allyAllianceId ~= "" then
    local allianceInfo = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(self.allyAllianceId)
    if allianceInfo == nil then
      SFSNetwork.SendMessage(MsgDefines.GetAllianceInfo, self.allyAllianceId)
    else
      self.allianceInfo = allianceInfo
      self:RefreshUI()
    end
  end
end

function UILWSeasonMakeFriendsHasFriend:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceMarkUpdate, self.UpdateData)
  self:AddUIListener(EventId.MFAllyFriendAllianceUpdate, self.UpdateData)
  self:AddUIListener(EventId.SearchAllianceSuccess, self.UpdateData)
  self:AddUIListener(EventId.MFAllyLogUpdate, self.OnAllyLogUpdate)
end

function UILWSeasonMakeFriendsHasFriend:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceMarkUpdate, self.UpdateData)
  self:RemoveUIListener(EventId.MFAllyFriendAllianceUpdate, self.UpdateData)
  self:RemoveUIListener(EventId.SearchAllianceSuccess, self.UpdateData)
  self:RemoveUIListener(EventId.MFAllyLogUpdate, self.OnAllyLogUpdate)
  base.OnRemoveListener(self)
end

function UILWSeasonMakeFriendsHasFriend:OnAllyLogUpdate()
  if self.history_red_point_root ~= nil then
    local newCount = DataCenter.SeasonAllyFriendManager:GetNewLogCount()
    if newCount and 0 < newCount then
      self.history_red_point_root:SetActive(true)
      self.history_red_point_text:SetText(tostring(newCount))
    else
      self.history_red_point_root:SetActive(false)
    end
  end
end

function UILWSeasonMakeFriendsHasFriend:RefreshUI()
  if not self:AsyncLoadDone() then
    return
  end
  local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if data == nil or data.abbr == nil then
    return
  end
  local allianceInfo = self.allianceInfo or DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(self.allyAllianceId)
  if allianceInfo == nil then
    return
  end
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local name1 = UIUtil.FormatServerAllianceName(mySourceServerId, data.abbr, nil)
  local name2 = UIUtil.FormatServerAllianceName(allianceInfo.createServer or allianceInfo.ownerServerId, allianceInfo.abbr, nil)
  self.my_alli_name:SetText(name1)
  self.other_alli_name:SetText(name2)
  self.my_alli:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, data.icon))
  self.other_alli:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, allianceInfo.icon))
  local allyStartTime = DataCenter.SeasonAllyFriendManager.allyStartTime
  if allyStartTime ~= nil and allyStartTime ~= 0 then
    local now = UITimeManager:GetInstance():GetServerTime()
    local strTime = string.format("<size=48>%d</size>", math.floor((now - allyStartTime) * 0.001 / OneDayTime))
    self.day_detail:SetLocalText("s6_alliance_ally_desc53", strTime)
  else
    self.day_detail:SetText("")
  end
  local allianceMarkDatas = DataCenter.WorldFavoDataManager.allianceMarkDatas or {}
  local allianceMarkForFriends = DataCenter.WorldFavoDataManager.allianceMarkForFriends or {
    dataDict = {}
  }
  local dataCount = 0
  dataCount = dataCount + self.condition1:ReInit(allianceMarkDatas[MarkType.Alliance_13])
  dataCount = dataCount + self.condition2:ReInit(allianceMarkDatas[MarkType.Alliance_14])
  dataCount = dataCount + self.condition3:ReInit(allianceMarkDatas[MarkType.Alliance_15])
  dataCount = dataCount + self.condition4:ReInit(allianceMarkDatas[MarkType.Alliance_16])
  dataCount = dataCount + self.condition5:ReInit(allianceMarkDatas[MarkType.Alliance_17])
  dataCount = dataCount + self.condition11:ReInit(allianceMarkForFriends.dataDict[MarkType.Alliance_13])
  dataCount = dataCount + self.condition12:ReInit(allianceMarkForFriends.dataDict[MarkType.Alliance_14])
  dataCount = dataCount + self.condition13:ReInit(allianceMarkForFriends.dataDict[MarkType.Alliance_15])
  dataCount = dataCount + self.condition14:ReInit(allianceMarkForFriends.dataDict[MarkType.Alliance_16])
  dataCount = dataCount + self.condition15:ReInit(allianceMarkForFriends.dataDict[MarkType.Alliance_17])
  self.title:SetActive(true)
  self.no_plan:SetActive(dataCount == 0)
end

return UILWSeasonMakeFriendsHasFriend
