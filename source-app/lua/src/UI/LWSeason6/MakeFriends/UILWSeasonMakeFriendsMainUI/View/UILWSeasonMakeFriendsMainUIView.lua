local UILWSeasonMakeFriendsMainUIView = BaseClass("UILWSeasonMakeFriendsMainUIView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local content_path = "Root/Container/Content"
local text_title_path = "Root/TopBar/TextTitle"
local btn_back_path = "Root/BottomBar/BtnBack"

function UILWSeasonMakeFriendsMainUIView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  SFSNetwork.SendMessage(MsgDefines.FetchAllianceAllyCombinedList)
  DataCenter.SeasonAllyFriendManager.friendMarkDirty = false
end

function UILWSeasonMakeFriendsMainUIView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMakeFriendsMainUIView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MFAllyFriendAllianceUpdate, self.UpdateData)
  self:AddUIListener(EventId.PushAllianceHaveFriendsUpdate, self.UpdateData)
  self:AddUIListener(EventId.PushAllianceFriendsLeaveUpdate, self.UpdateData)
  self:AddUIListener(EventId.SearchAllianceSuccess, self.UpdateData)
end

function UILWSeasonMakeFriendsMainUIView:OnRemoveListener()
  self:RemoveUIListener(EventId.MFAllyFriendAllianceUpdate, self.UpdateData)
  self:RemoveUIListener(EventId.PushAllianceHaveFriendsUpdate, self.UpdateData)
  self:RemoveUIListener(EventId.PushAllianceFriendsLeaveUpdate, self.UpdateData)
  self:RemoveUIListener(EventId.SearchAllianceSuccess, self.UpdateData)
  base.OnRemoveListener(self)
end

function UILWSeasonMakeFriendsMainUIView:ComponentDefine()
  self.text_title = self:AddComponent(UITextMeshProUGUIEx, text_title_path)
  self.text_title:SetLocalText("s6_alliance_ally_tittle01")
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

function UILWSeasonMakeFriendsMainUIView:ComponentDestroy()
  self.content = nil
  self.text_title = nil
  self.btn_back = nil
end

function UILWSeasonMakeFriendsMainUIView:OnEnable()
  base.OnEnable(self)
  self:UpdateData()
  local count = UIUtil.GetYearActiveCount("SeasonMakeFriendsMainUI", true)
  if count == 0 then
    local plotId = 6109
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = plotId, hideMainUI = false})
  end
end

function UILWSeasonMakeFriendsMainUIView:OnDisable()
  base.OnDisable(self)
end

function UILWSeasonMakeFriendsMainUIView:UpdateData()
  local hasFriend = DataCenter.SeasonAllyFriendManager:HasFriend()
  if hasFriend then
    if self.ExistFriends == nil then
      local lua = require("UI.LWSeason6.MakeFriends.UILWSeasonMakeFriendsMainUI.Component.UILWSeasonMakeFriendsHasFriend")
      local prefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/MakeFriends/Component/MyFriendInfo.prefab"
      self.ExistFriends = UIBaseComponent.LoadComponentAsync(self, lua, prefabPath, self.content)
    else
      self.ExistFriends:UpdateData()
    end
  elseif self.NotExistFriends == nil then
    local lua = require("UI.LWSeason6.MakeFriends.UILWSeasonMakeFriendsMainUI.Component.UILWSeasonMakeFriendsNotExistFriends")
    local prefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/MakeFriends/Component/NotExistFriends.prefab"
    self.NotExistFriends = UIBaseComponent.LoadComponentAsync(self, lua, prefabPath, self.content)
  else
    self.NotExistFriends:UpdateData()
  end
  if self.ExistFriends ~= nil then
    self.ExistFriends:SetActive(hasFriend)
  end
  if self.NotExistFriends ~= nil then
    self.NotExistFriends:SetActive(not hasFriend)
  end
end

return UILWSeasonMakeFriendsMainUIView
