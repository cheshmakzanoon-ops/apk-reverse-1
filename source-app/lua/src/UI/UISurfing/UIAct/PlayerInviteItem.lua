local base = UIBaseContainer
local PlayerInviteItem = BaseClass("PlayerInviteItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local img_add_path = "img_add"

function PlayerInviteItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function PlayerInviteItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function PlayerInviteItem:ComponentDefine()
  self.img_add = self:AddComponent(UIButton, img_add_path)
  self.img_add:SetOnClick(BindCallback(self, self.OnInviteClick))
  self.compPlayer = self:AddComponent(UICommonHead, "player")
  self.compPlayer:SetEnableClickShowInfo(true, true)
  self.btnImgDel = self:AddComponent(UIButton, "img_del")
end

function PlayerInviteItem:ComponentDestroy()
  self.img_add = nil
  self.compPlayer = nil
  self.btnImgDel = nil
end

function PlayerInviteItem:DataDefine()
  self.shareParam = nil
  self.shareCd = nil
end

function PlayerInviteItem:DataDestroy()
  self.shareParam = nil
  self.shareCd = nil
end

function PlayerInviteItem:OnAddListener()
  base.OnAddListener(self)
end

function PlayerInviteItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function PlayerInviteItem:OnBtnImgDelClick()
end

function PlayerInviteItem:ReInit(param)
  if param then
    self.compPlayer:SetActive(true)
    self.compPlayer:SetHeadAndFrame(param.uid, param.headPic, param.headPicVer, false, param.headSkinId, param.headSkinET)
  else
    self.compPlayer:SetActive(false)
  end
end

function PlayerInviteItem:OnInviteClick()
  if LuaEntry.Player:IsInAlliance() then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    CommonUtil.PlayerPrefsSetLong(SettingKeys.SURFING_BATTLE_INVITE_TIPS, curTime)
    EventManager:GetInstance():Broadcast(EventId.SurfingInviteRedPoint)
    if self.endTs == nil then
      local activityId = DataCenter.LWSurfingDataManager:GetActId()
      local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
      self.endTs = activityInfo and activityInfo.endTime
    end
    if self.endTs == 0 then
      UIUtil.ShowTipsId("challenge_zombie_share_expired_tips")
      return
    end
    local curTs = UITimeManager:GetInstance():GetServerTime()
    if curTs > self.endTs then
      UIUtil.ShowTipsId("challenge_zombie_share_expired_tips")
      return
    end
    local lastTimeStr = Setting:GetString(SettingKeys.SURFING_ON_INVITE_SHARE_CD, "")
    if lastTimeStr ~= "" then
      local lastTime = tonumber(lastTimeStr)
      local offset = curTs - lastTime
      offset = math.ceil(offset / 1000)
      if self.shareCd == nil then
        self.shareCd = LuaEntry.DataConfig:TryGetNum("surfing_config", "k2", 0)
      end
      if 0 < offset and offset < self.shareCd then
        local context = Localization:GetString("breakthough_tips_03", self.shareCd - offset)
        UIUtil.ShowTips(context)
        return
      end
    end
    if self.shareParam == nil then
      local shareParam = {}
      shareParam.msgName = MsgDefines.ParkourShareInviteChat
      shareParam.tipsId = "parkour_help_share"
      self.shareParam = shareParam
    end
    if CoppaUtil.IsCoppaLimitWithTips() then
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonSimpleShareConfirm, {anim = true}, self.shareParam)
  else
    if LuaEntry.Player:IsFirstJoinAlliance() == true then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
      return
    end
    local params = {guide = false}
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
  end
end

return PlayerInviteItem
