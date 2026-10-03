local UILWFriendsCircleTitle = BaseClass("UILWFriendsCircleTitle", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIAdaptReddot = require("UI.UICommon.Component.UIAdaptReddot")

function UILWFriendsCircleTitle:OnCreate()
  base.OnCreate(self)
  self.data = nil
  self.isFollow = -1
  self:ComponentDefine()
  self:ReInit()
end

function UILWFriendsCircleTitle:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CHAT_MOMENT_RESF_FOLLOW_STATE, self.RefreshFollowedBtn)
  self:AddUIListener(EventId.CHAT_MOMENT_RESF_FOLLOW_STATE_LIST, self.RefreshFollowedBtn)
  self:AddUIListener(EventId.CHAT_MOMENT_NOTICE_REDDOT, self.RefreshPushBtn)
  self:AddUIListener(EventId.CHAT_MOMENT_FRISTFOLLW, self.RefreshFristFollow)
end

function UILWFriendsCircleTitle:RefreshPushBtn()
  local commentCount = ChatInterface.getMoment():GetRedDot(MomentPushType.NoticeComment) or 0
  local likeCount = ChatInterface.getMoment():GetRedDot(MomentPushType.NoticeLike) or 0
  if 0 < commentCount then
    self.pushRedDot:SetRedDotType(UnreadNotificationType.ShowUnreadCount)
    self.pushRedDot:SetNumber(commentCount)
  else
    self.pushRedDot:SetRedDotType(UnreadNotificationType.ShowUnreadDot)
    self.pushRedDot:SetNumber(likeCount)
  end
end

function UILWFriendsCircleTitle:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.CHAT_MOMENT_RESF_FOLLOW_STATE, self.RefreshFollowedBtn)
  self:RemoveUIListener(EventId.CHAT_MOMENT_RESF_FOLLOW_STATE_LIST, self.RefreshFollowedBtn)
  self:RemoveUIListener(EventId.CHAT_MOMENT_NOTICE_REDDOT, self.RefreshPushBtn)
  self:RemoveUIListener(EventId.CHAT_MOMENT_FRISTFOLLW, self.RefreshFristFollow)
end

function UILWFriendsCircleTitle:RefreshFristFollow(data)
  if self.view.uid == data.foolwId then
    self.firstFollow = data.isFirst
  end
end

function UILWFriendsCircleTitle:ComponentDefine()
  self.titleLayout = self:AddComponent(UIBaseContainer, "")
  self.btnLayout = self:AddComponent(UIBaseContainer, "btnLayout")
  self.pushRedDot = self:AddComponent(UIAdaptReddot, "btnLayout/pushBtn/reddot")
  self.sendMessageBtn = self:AddComponent(UIButton, "btnLayout/sendMessageBtn")
  self.settingBtn = self:AddComponent(UIButton, "btnLayout/settingBtn")
  self.pushBtn = self:AddComponent(UIButton, "btnLayout/pushBtn")
  self.followBtn = self:AddComponent(UIButton, "followBtn")
  self.unFollowBtn = self:AddComponent(UIButton, "unFollowLayoutBtn")
  self.sendMessageBtn:SetOnClick(function()
    local isFirstPost = CommonUtil.PlayerPrefsGetBool("FirstPostMoment", true)
    local loaclFlag = isFirstPost
    if isFirstPost then
      local param = {
        contentText = Localization:GetString("moment_privacy_des"),
        btnNum = 1,
        showToggle = true,
        confirmBtnParam = {
          action = function()
            CommonUtil.PlayerPrefsSetBool("FirstPostMoment", loaclFlag)
            UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPostCircleFriend, {anim = true}, self.circleRoomId)
          end,
          context = "moment_privacy_btn"
        },
        toggleParam = {
          toggleText = Localization:GetString("no_more_select"),
          toggleAction = function(flag)
            loaclFlag = flag
          end
        }
      }
      UIUtil.ShowConfirmNew(param)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPostCircleFriend, {anim = true}, self.circleRoomId)
    end
  end)
  self.pushBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMomentPush, {anim = true})
  end)
  self.followBtn:SetOnClick(function()
    local data = ChatInterface.getMoment():GetFirstFollow(self.view.uid)
    if not data then
      if self.view.uid ~= LuaEntry.Player.uid then
        SFSNetwork.SendMessage(MsgDefines.UserQueryFollow, self.view.uid)
      end
      return
    end
    self.firstFollow = data.isFirst
    if self.firstFollow then
      UIUtil.ShowMessage(Localization:GetString("moment_follow_tips1"), 2, "moment_follow_tips_btn", GameDialogDefine.CANCEL, function()
        DataCenter.GiftSystemManager:OpenOperationView({
          windowType = GiftSystemConst.WindowType.Send,
          targetUid = self.view.uid,
          targetServerId = self.view.data.serverId,
          isMoment = true
        })
      end)
    else
      SFSNetwork.SendMessage(MsgDefines.UserAddFollow, {
        targetUid = self.view.uid
      })
    end
  end)
  self.settingBtn:SetOnClick(function()
    local uid = ChatManager2:GetInstance().Room:GetFriendsCirclePlayerUid(self.circleRoomId, ChatGroupType.GROUP_FRIENDS_CIRCLE_ROOM)
    if uid then
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIFriendsCircleSetting, {anim = true}, uid)
    end
  end)
  self.unFollowBtn:SetOnClick(function()
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.MomentUnFollow, {
      self.view.uid
    })
  end)
  if ChatInterface.GetMomentIsOpen() and self.view.uid ~= LuaEntry.Player.uid then
    SFSNetwork.SendMessage(MsgDefines.UserQueryFollow, self.view.uid)
  end
  self:InitViewState()
end

function UILWFriendsCircleTitle:InitViewState()
  if not ChatInterface.GetMomentIsOpen() then
    self.pushBtn:SetActive(false)
    self.followBtn:SetActive(false)
    self.unFollowBtn:SetActive(false)
    return
  end
  local info = ChatInterface.getMoment():GetMomentFollowInfo(self.view.uid)
  self:RefreshPushBtn()
  if not info then
    self.followBtn:SetActive(false)
    self.unFollowBtn:SetActive(false)
    return
  end
  self.followBtn:SetActive(not info.isFollow)
  self.unFollowBtn:SetActive(info.isFollow)
end

function UILWFriendsCircleTitle:ReInit(circleRoomId, data)
  self.circleRoomId = circleRoomId
  self.data = data
  self.btnLayout:SetActive(not CoppaUtil.IsCoppaLimit() and self.view.isSelf)
  self:InitViewState()
end

function UILWFriendsCircleTitle:RefreshFollowedBtn(data)
  if self.view.isSelf or not ChatInterface.GetMomentIsOpen() then
    return
  end
  if data.uid ~= self.view.uid or self.isFollow == data.isFollow then
    return
  end
  self.isFollow = data.isFollow
  self.followBtn:SetActive(not self.isFollow)
  self.unFollowBtn:SetActive(self.isFollow)
end

function UILWFriendsCircleTitle:ComponentDestroy()
  self.titleLayout = nil
  self.sendMessageBtn = nil
end

function UILWFriendsCircleTitle:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWFriendsCircleTitle:DataDestroy()
  self.data = nil
end

return UILWFriendsCircleTitle
