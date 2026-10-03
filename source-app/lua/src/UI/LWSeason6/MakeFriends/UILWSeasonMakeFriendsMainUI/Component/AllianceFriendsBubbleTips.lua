local AllianceFriendsBubbleTips = BaseClass("AllianceFriendsBubbleTips", UIAsyncContainer)
local baseBubbleTips = UIAsyncContainer
local Localization = CS.GameEntry.Localization

function AllianceFriendsBubbleTips:OnCreate()
  baseBubbleTips.OnCreate(self)
  self.btn = self:AddComponent(UIButton, "Btn")
  self.icon = self:AddComponent(UIImage, "Btn/Icon")
  self.txt = self:AddComponent(UITextMeshProUGUIEx, "Btn/Txt")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.animRoot = self:AddComponent(UIAnimator, "")
end

function AllianceFriendsBubbleTips:OnDestroy()
  self.btn = nil
  self.icon = nil
  self.txt = nil
  self.animRoot = nil
  baseBubbleTips.OnDestroy(self)
end

function AllianceFriendsBubbleTips:ReInit(data, showIt)
  self.data = data
  self.showIt = showIt
  self:UpdateData()
end

function AllianceFriendsBubbleTips:OnBtnClick()
  if self.data == 1 then
    EventManager:GetInstance():Broadcast(EventId.PushAllianceHaveFriendsUpdate, false)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonMakeFriendsMainUI, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif self.data == 2 then
    EventManager:GetInstance():Broadcast(EventId.PushAllianceFriendsLeaveUpdate, false)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonMakeFriendsMainUI, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif self.data ~= nil and self.data.pointId ~= nil and self.data.serverId ~= nil then
    local worldPointPos = SceneUtils.TileIndexToWorld(self.data.pointId, ForceChangeScene.World)
    local serverId = self.data.serverId
    EventManager:GetInstance():Broadcast(EventId.PushAllianceFriendsHelpMe)
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(worldPointPos, CS.SceneManager.World.Zoom, LookAtFocusTime, function()
    end, serverId)
  end
end

function AllianceFriendsBubbleTips:UpdateData()
  if IsNull(self.gameObject) then
    return
  end
  if self.showIt then
    self.animRoot:Play("InviteTip_movein")
  else
    self.animRoot:Play("InviteTip_moveout")
  end
  if self.data == 1 then
    self.icon:LoadSpriteAsync("Assets/Main/Sprites/ItemIcons/lrb_daojv_biaoqing03.png")
    self.txt:SetLocalText("s6_alliance_ally_desc41")
    self.txt:SetActive(true)
  elseif self.data == 2 then
    self.icon:LoadSpriteAsync("Assets/Main/Sprites/ItemIcons/lrb_daojv_biaoqingzhenjing.png")
    self.txt:SetLocalText("s6_alliance_ally_btn15")
    self.txt:SetActive(true)
  elseif self.data ~= nil and self.data.cityId ~= nil and self.data.serverId ~= nil then
    local name = UIUtil.FormatServerAllianceName(self.data.serverId, self.data.userInfo.abbr, self.data.userInfo.name)
    self.icon:LoadSpriteAsync("Assets/Main/SeasonRes/S6/Sprites/AllyFriendS6/mjc_TMJM_icon_s_jiemeng.png")
    self.txt:SetText(Localization:GetString("110141") .. name)
    self.txt:SetActive(true)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.btn.rectTransform)
end

local UIAlFriendsBubbleNode = BaseClass("UIAlFriendsBubbleNode", UIAsyncProxy)
local base = UIAsyncProxy

function UIAlFriendsBubbleNode:OnCreate()
  base.OnCreate(self)
end

function UIAlFriendsBubbleNode:OnDestroy()
  base.OnDestroy(self)
end

function UIAlFriendsBubbleNode:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PushAllianceHaveFriendsUpdate, self.OnAllianceHaveFriends)
  self:AddUIListener(EventId.PushAllianceFriendsLeaveUpdate, self.OnAllianceFriendsLeave)
  self:AddUIListener(EventId.PushAllianceFriendsHelpMe, self.OnAllianceFriendsHelp)
end

function UIAlFriendsBubbleNode:OnRemoveListener()
  self:RemoveUIListener(EventId.PushAllianceHaveFriendsUpdate, self.OnAllianceHaveFriends)
  self:RemoveUIListener(EventId.PushAllianceFriendsLeaveUpdate, self.OnAllianceFriendsLeave)
  self:RemoveUIListener(EventId.PushAllianceFriendsHelpMe, self.OnAllianceFriendsHelp)
  base.OnRemoveListener(self)
end

function UIAlFriendsBubbleNode:OnRefreshShow()
end

function UIAlFriendsBubbleNode:OnAllianceFriendsHelp(data)
  if data ~= nil and data.fromAllianceId ~= DataCenter.SeasonAllyFriendManager:GetFriendAllyId() then
    return
  end
  self.data = data
  self:TrySetShow(data ~= nil and data.cityId ~= nil and data.serverId ~= nil)
end

function UIAlFriendsBubbleNode:OnAllianceHaveFriends(showIt)
  local hasFriend = DataCenter.SeasonAllyFriendManager:HasFriend()
  self.data = 1
  self:TrySetShow(showIt and hasFriend)
  if showIt and hasFriend then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonMakeFriendsPopup, {anim = false})
  end
end

function UIAlFriendsBubbleNode:OnAllianceFriendsLeave(showIt)
  self.data = 2
  self:TrySetShow(showIt)
end

function UIAlFriendsBubbleNode:TrySetShow(showIt)
  if not showIt then
    self:SetShow(false)
  end
  self.holder:TrySetShow(MainAlBubbleType.Friends, showIt)
end

function UIAlFriendsBubbleNode:SetShow(showIt)
  local prefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/MakeFriends/Component/InviteTip.prefab"
  local obj = self:SetActiveAsync(showIt, AllianceFriendsBubbleTips, prefabPath)
  if obj then
    obj:ReInit(self.data, showIt)
  end
end

return UIAlFriendsBubbleNode
