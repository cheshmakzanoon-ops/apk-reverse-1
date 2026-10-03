local UILWPlayerDetailView = BaseClass("UILWPlayerDetailView", UIBaseView)
local base = UIBaseView
local UILWPlayerDetailTop = require("UI.LWPlayerInfo.UILWPlayerDetail.Component.Top.UILWPlayerDetailTop")
local UILWPlayerDetailMiddle = require("UI.LWPlayerInfo.UILWPlayerDetail.Component.Middle.UILWPlayerDetailMiddle")
local UILWPlayerDetailBottomBtnItem = require("UI.LWPlayerInfo.UILWPlayerDetail.Component.Bottom.Btns.UILWPlayerDetailBottomBtnItem")
local UILWPlayerDetailBottom = require("UI.LWPlayerInfo.UILWPlayerDetail.Component.Bottom.UILWPlayerDetailBottom")
local horizontalLayoutGroup = typeof(CS.UnityEngine.UI.HorizontalLayoutGroup)

function UILWPlayerDetailView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

function UILWPlayerDetailView:ReopenWithoutCreate()
  base.ReopenWithoutCreate(self)
  self:DataDefine()
  self:ReInit()
end

function UILWPlayerDetailView:ReInit()
  self.btns:RemoveComponents(UILWPlayerDetailBottomBtnItem)
  self.btnItem:GameObjectRecycleAll()
  self.btnList = {}
  local config = self.ctrl:GetBtnsConfig(self.isSelf)
  local item
  for i = 1, #config do
    item = self.btnItem:GameObjectSpawn(self.btns.transform)
    item.name = config[i].name .. i
    item:SetActive(true)
    item = self.btns:AddComponent(UILWPlayerDetailBottomBtnItem, item.name)
    item:ReInit(config[i])
    self.btnList[i] = item
  end
  self:InitView()
  if self.isSelf then
    self.btnsLayout.childForceExpandWidth = true
    self.btnsLayout.spacing = 0
  else
    self.btnsLayout.childForceExpandWidth = false
    self.btnsLayout.spacing = 80
  end
end

function UILWPlayerDetailView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWPlayerDetailView:ComponentDefine()
  self.bg = self:AddComponent(UIBaseContainer, "bg")
  self.middle = self:AddComponent(UILWPlayerDetailMiddle, "bg/middle")
  self.top = self:AddComponent(UILWPlayerDetailTop, "bg/top")
  self.bottom = self:AddComponent(UILWPlayerDetailBottom, "bg/Bottom")
  self.panelBtn = self:AddComponent(UIButton, "panel")
  self.btns = self:AddComponent(UIBaseContainer, "bg/BtnLayout/Btns")
  self.btnsLine = self:AddComponent(UIBaseContainer, "bg/BtnLayout/lineIcon")
  self.btnItem = self.transform:Find("bg/BtnLayout/Btns/Btn").gameObject
  self.btnsLayout = self.btns.gameObject:GetComponent(horizontalLayoutGroup)
  self.btnItem:GameObjectCreatePool()
  self.panelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

function UILWPlayerDetailView:DataDefine()
  local param = self:GetUserData()
  local selfUid = tostring(LuaEntry.Player.uid)
  self.isShowUnreadRedDot = false
  self.activityId = 0
  if param == nil or param == 0 or param == "" then
    self.uid = selfUid
  elseif type(param) == "table" then
    self.uid = tostring(param.uid)
    self.isShowUnreadRedDot = param.isShowUnreadRedDot
    self.activityId = param.activityId
  else
    self.uid = tostring(param)
  end
  self.isSelf = self.uid == tostring(LuaEntry.Player.uid)
  if not self.isSelf then
    local info = ChatInterface.getMoment():GetMomentFollowInfo(self.uid)
    if not info then
      ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.MomentFollowState, self.uid)
    end
  end
end

function UILWPlayerDetailView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SearchAllianceSuccess, self.OnPlayerDataCallBack)
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.OnPlayerDataCallBack)
  self:AddUIListener(EventId.NickNameChangeEvent, self.OnPlayerDataCallBack)
  self:AddUIListener(EventId.GenderChangeEvent, self.OnPlayerDataCallBack)
  self:AddUIListener(EventId.UpdatePlayerHeadIcon, self.OnRefreshPlayerIcon)
  self:AddUIListener(EventId.AllianceBaseDataUpdated, self.OnAllianceBaseDataUpdated)
  self:AddUIListener(EventId.OfficialApplyTipRefresh, self.RefreshOfficialApplyPoint)
  self:AddUIListener(EventId.KingdomPositionInfoUpdate, self.RefreshOfficialApplyPoint)
  self:AddUIListener(EventId.FriendsCircleSettingUpdate, self.RefreshData)
  self:AddUIListener(EventId.ChatRoomClear, self.ClearFriendsCircle)
  self:AddUIListener(EventId.CHAT_LOGIN_SUCCESS, self.OnChatLoginSuccess)
end

function UILWPlayerDetailView:OnRemoveListener()
  self:RemoveUIListener(EventId.SearchAllianceSuccess, self.OnPlayerDataCallBack)
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.OnPlayerDataCallBack)
  self:RemoveUIListener(EventId.NickNameChangeEvent, self.OnPlayerDataCallBack)
  self:RemoveUIListener(EventId.GenderChangeEvent, self.OnPlayerDataCallBack)
  self:RemoveUIListener(EventId.UpdatePlayerHeadIcon, self.OnRefreshPlayerIcon)
  self:RemoveUIListener(EventId.AllianceBaseDataUpdated, self.OnAllianceBaseDataUpdated)
  self:RemoveUIListener(EventId.OfficialApplyTipRefresh, self.RefreshOfficialApplyPoint)
  self:RemoveUIListener(EventId.KingdomPositionInfoUpdate, self.RefreshOfficialApplyPoint)
  self:RemoveUIListener(EventId.FriendsCircleSettingUpdate, self.RefreshData)
  self:RemoveUIListener(EventId.ChatRoomClear, self.ClearFriendsCircle)
  self:RemoveUIListener(EventId.CHAT_LOGIN_SUCCESS, self.OnChatLoginSuccess)
  base.OnRemoveListener(self)
end

function UILWPlayerDetailView:OnChatLoginSuccess()
  self.isFriendsCircleInit = false
  self:OnPlayerDataCallBack()
end

function UILWPlayerDetailView:InitView()
  self.isFriendsCircleInit = false
  self:InitUserData(true)
  if self.data then
    self.middle:ReInit(self.data)
    self.top:ReInit(self.data)
    for _, v in pairs(self.btnList) do
      v:SetData(self.data)
    end
    if self.data.uid then
      local friendsCirleIsOpen = self:GetIsOpenFriendsCirle()
      local isButtom = friendsCirleIsOpen or IsGiftSystemOpen
      self.bottom:SetActive(isButtom)
      self.btnsLine:SetActive(not isButtom)
      if isButtom then
        self.bottom:ReInit(self.data, {
          friendsCirle = friendsCirleIsOpen,
          gift = IsGiftSystemOpen
        })
      end
    end
  end
  self.middle.firstShow = true
end

function UILWPlayerDetailView:InitUserData(fetchProfileHint)
  self.data = UIUtil.GetPlayerInfoShowByUid(self.uid, fetchProfileHint)
  self.data.isShowUnreadRedDot = self.isShowUnreadRedDot
  self.data.activityId = self.activityId
end

function UILWPlayerDetailView:OnPlayerDataCallBack()
  self:InitUserData()
  if self.data then
    self.middle:ReInit(self.data)
    self.top:ReInit(self.data)
    for _, v in pairs(self.btnList) do
      v:SetData(self.data)
    end
    if not self.isFriendsCircleInit then
      local friendsCirleIsOpen = self:GetIsOpenFriendsCirle()
      local isButtom = friendsCirleIsOpen or IsGiftSystemOpen
      self.bottom:SetActive(isButtom)
      self.btnsLine:SetActive(not isButtom)
      if isButtom then
        self.bottom:ReInit(self.data, {
          friendsCirle = friendsCirleIsOpen,
          gift = IsGiftSystemOpen
        })
      end
      self.isFriendsCircleInit = true
    end
  end
end

function UILWPlayerDetailView:SetOnTop()
  if self.middle.picCom then
    self.middle.picCom:HideAnim()
  end
  self:RefreshUserData()
  self.isFriendsCircleInit = false
end

function UILWPlayerDetailView:RefreshUserData()
  self:InitUserData()
  if self.data then
    self.middle:ReInit(self.data)
    self.top:ReInit(self.data)
    for _, v in pairs(self.btnList) do
      v:SetData(self.data)
    end
    local friendsCirleIsOpen = self:GetIsOpenFriendsCirle()
    local isButtom = friendsCirleIsOpen or IsGiftSystemOpen
    self.bottom:SetActive(isButtom)
    self.btnsLine:SetActive(not isButtom)
    if isButtom then
      self.bottom:ReInit(self.data, {
        friendsCirle = friendsCirleIsOpen,
        gift = IsGiftSystemOpen
      })
    end
  end
end

function UILWPlayerDetailView:GetIsOpenFriendsCirle()
  self.playerInfo = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(self.data.uid)
  if not self.playerInfo then
    return false
  end
  return self.playerInfo.isFriendsCircleOpen and not self.playerInfo.isShield
end

function UILWPlayerDetailView:OnRefreshPlayerIcon()
  self:InitUserData()
  self.middle:ReInit(self.data)
  self.top:ReInit(self.data)
  for _, v in pairs(self.btnList) do
    v:SetData(self.data)
  end
end

function UILWPlayerDetailView:OnAllianceBaseDataUpdated()
  self:InitUserData()
  self.middle:ReInit(self.data)
  self.top:ReInit(self.data)
  for _, v in pairs(self.btnList) do
    v:SetData(self.data)
  end
end

function UILWPlayerDetailView:RefreshOfficialApplyPoint()
  self:InitUserData()
  self.middle:ReInit(self.data)
  self.top:ReInit(self.data)
  for _, v in pairs(self.btnList) do
    v:SetData(self.data)
  end
end

function UILWPlayerDetailView:RefreshData(uid)
  if uid == self.uid then
    self:InitUserData()
  end
end

function UILWPlayerDetailView:ClearFriendsCircle()
  self.isFriendsCircleInit = false
  self.bottom:ReInit()
end

function UILWPlayerDetailView:DataDestroy()
  self.data = nil
  ChatInterface.getMoment():SendExposure()
end

function UILWPlayerDetailView:ComponentDestroy()
  self.btns:RemoveComponents(UILWPlayerDetailBottomBtnItem)
  self.btnItem:GameObjectRecycleAll()
  self.middle = nil
  self.top = nil
  self.bottom = nil
  self.panelBtn = nil
  self.btns = nil
  self.btnItem = nil
end

return UILWPlayerDetailView
