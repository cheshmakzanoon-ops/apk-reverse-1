local UILWPlayerDetailCtrl = BaseClass("UILWPlayerDetailCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local BottomBtnsConfig = {
  isSelf = {
    {
      name = "record",
      icon = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/lrb_moments_record_btn.png",
      text = "456210",
      type = PlayerDetailBottomBtnType.Record
    },
    {
      name = "user",
      icon = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/lrb_moments_Account_btn.png",
      text = "280039",
      type = PlayerDetailBottomBtnType.User
    },
    {
      name = "setting",
      icon = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/lrb_moments_Setting_btn.png",
      text = "280012",
      type = PlayerDetailBottomBtnType.Setting
    },
    {
      name = "rank",
      icon = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/lrb_moments_Rankings_btn.png",
      text = "390040",
      type = PlayerDetailBottomBtnType.Rank
    }
  },
  Other = {
    {
      name = "like",
      icon = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/lrb_moments_like_btn.png",
      text = "avatar_mainui_btn_like",
      type = PlayerDetailBottomBtnType.Like
    },
    {
      name = "user",
      icon = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/lrb_moments_chat_btn.png",
      text = "110053",
      type = PlayerDetailBottomBtnType.Chat
    }
  },
  service = {
    name = "service",
    icon = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/zyf_moments_services_btn",
    text = "100619",
    type = PlayerDetailBottomBtnType.Service
  },
  moment = {
    name = "attention",
    icon = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/zyf_pengyouquanyouhua_guanzhujilu_icon.png",
    text = "chat_subtab_follow",
    type = PlayerDetailBottomBtnType.Attention
  }
}

function UILWPlayerDetailCtrl:GetBtnsConfig(isSelf)
  if isSelf then
    local lanage = Localization:GetLanguage()
    local config = DeepCopy(BottomBtnsConfig.isSelf)
    if lanage == Language.Japanese then
      table.insert(config, BottomBtnsConfig.service)
      return config
    else
      if ChatInterface.GetMomentIsOpen() then
        table.insert(config, BottomBtnsConfig.moment)
      end
      return config
    end
  else
    if IsGiftSystemOpen then
      local config = DeepCopy(BottomBtnsConfig.Other)
      table.insert(config, {
        name = "gift",
        icon = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/lrb_moments_gift_btn.png",
        text = "string_gifts",
        type = PlayerDetailBottomBtnType.Gift
      })
      return config
    end
    return BottomBtnsConfig.Other
  end
end

function UILWPlayerDetailCtrl:OnBottomBtnClick(data, clickType)
  if clickType == PlayerDetailBottomBtnType.Record then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerThumbsUpHistory)
  elseif clickType == PlayerDetailBottomBtnType.User then
    if DataCenter.AccountScoreManager:CheckAccountIDOpen() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIAccountManage, {anim = true, hideTop = true})
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingAccount, {anim = true, hideTop = true})
    end
  elseif clickType == PlayerDetailBottomBtnType.Setting then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISetting, {anim = true, hideTop = true})
  elseif clickType == PlayerDetailBottomBtnType.Rank then
    if DataCenter.BuildManager.MainLv >= 10 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIRankTable, {anim = true, hideTop = true})
    else
      UIUtil.ShowTipsId(451038)
    end
  elseif clickType == PlayerDetailBottomBtnType.Like then
    local thePlayerUid = data.uid
    InteractiveUtil.TryThumbsUp(thePlayerUid, InteractiveUtil.ThumbsUpType.PlayerInfo, "PlayerDetailMain", function()
    end)
  elseif clickType == PlayerDetailBottomBtnType.Chat then
    self:OnClickChat(data)
  elseif clickType == PlayerDetailBottomBtnType.Service then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingCustomerService, {anim = true})
  elseif clickType == PlayerDetailBottomBtnType.Gift then
    local isKid = data.isKid or 0
    if CoppaUtil.IsCoppaLimit() or isKid == 2 then
      UIUtil.ShowTipsId(CoppaUtil.GetCoppaDialogId())
      return
    end
    DataCenter.GiftSystemManager:OpenOperationView({
      windowType = GiftSystemConst.WindowType.Send,
      targetUid = data.uid,
      targetServerId = data.serverId
    })
  elseif clickType == PlayerDetailBottomBtnType.Attention then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWFriendsCircleFollowee, {anim = true})
  end
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
end

function UILWPlayerDetailCtrl:OnClickChat(data)
  if UIManager.Instance:IsWindowOpen(UIWindowNames.UIChatNew_v2) then
    local windows = {}
    for k, v in pairs(UIManager.Instance.windows) do
      windows[k] = v
    end
    for k, v in pairs(windows) do
      if v.Name ~= UIWindowNames.UIChatNew_v2 and v.Name ~= UIWindowNames.UIMain and v.Name ~= UIWindowNames.UIJeepAdventureMainView and v.Name ~= UIWindowNames.LWLLBattleMainUIView and v.Name ~= UIWindowNames.UISeasonTowerMain and not BattlefieldConfig.IsBattlefieldMainUI(v.Name) then
        UIManager.Instance:DestroyWindow(v.Name)
      end
    end
    local userInfo = {}
    userInfo.uid = data.uid
    userInfo.userName = data.name
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_TALK_TO_PRIVATE, userInfo)
  else
    local userInfo = {}
    userInfo.uid = data.uid
    userInfo.userName = data.name
    local data = {}
    data.privateUserInfo = userInfo
    UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
    GoToUtil.OpenChatView(false, {anim = false}, data)
    local curBattleType = DataCenter.LWBattleManager:GetCurBattleType()
    local curEnterType = DataCenter.LWBattleManager:GetPVEEnterType()
    if curBattleType == PVEType.Arena3V3 and curEnterType == PVEEnterType.Arena3V3 then
      DataCenter.LWBattleManager:Exit(nil, "chat")
    end
  end
  self:CloseSelf()
end

function UILWPlayerDetailCtrl:GetRedDotIsOpenByType(redType, netData)
  if redType == PlayerDetailBottomBtnType.Record then
    local cache = self:GetRedDotCache()
    if cache == nil then
      return false
    end
    local newGiftCount = netData.newGiftCount or 0
    local thumbsUp = netData.thumbsUpCount or 0
    return newGiftCount > toInt(cache.newGiftCount) or thumbsUp > toInt(cache.thumbsUpCount)
  elseif redType == PlayerDetailBottomBtnType.Setting then
    local show = DataCenter.LWCustomerServiceManager:GetCustomerServiceRedPointData()
    if show then
      local lanage = Localization:GetLanguage()
      if lanage == Language.Japanese then
        return false
      else
        return true
      end
    end
    return false
  elseif redType == PlayerDetailBottomBtnType.Service then
    local show = DataCenter.LWCustomerServiceManager:GetCustomerServiceRedPointData()
    if show then
      return true
    end
    return false
  else
    return false
  end
end

function UILWPlayerDetailCtrl:GetRedDotNumIsOpenByType(redType, netData)
  if redType == PlayerDetailBottomBtnType.Chat then
    if netData.uid == LuaEntry.Player.uid then
      return -1
    end
    if netData.isShowUnreadRedDot and netData.activityId and netData.activityId ~= 0 and netData.uid and netData.uid ~= "" then
      local matchRedPoint = DataCenter.ValentineDataManager:GetMatchRedPoint(netData.activityId, netData.uid)
      return matchRedPoint
    end
  end
  return -1
end

function UILWPlayerDetailCtrl:GetRedDotCache()
  local info = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(LuaEntry.Player.uid)
  if info == nil then
    return
  end
  local redDotInfo = CommonUtil.PlayerPrefsGetTable("PLAYER_DETAIL_RED_DOT_INFO")
  if redDotInfo == nil then
    redDotInfo = {
      thumbsUpCount = info.thumbsUpCount or 0,
      newGiftCount = info.newGiftCount or 0
    }
    CommonUtil.PlayerPrefsSetTable("PLAYER_DETAIL_RED_DOT_INFO", redDotInfo)
  end
  return redDotInfo
end

function UILWPlayerDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWPlayerDetail)
end

return UILWPlayerDetailCtrl
