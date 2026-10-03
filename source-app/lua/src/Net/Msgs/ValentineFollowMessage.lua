local ValentineFollowMessage = BaseClass("ValentineFollowMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ValentineFollowMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", param.activityId)
  self.sfsObj:PutUtfString("otherUid", param.otherUid)
end

function ValentineFollowMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.flag and t.activityId then
    if t.flag == 1 then
      local Localization = CS.GameEntry.Localization
      local remainTime = t.remainNum or 0
      local tips = Localization:GetString("Valentine_send_bp_tips_09", remainTime)
      UIUtil.ShowTips(tips)
      DataCenter.ValentineDataManager:CachePlayerFollowHotAdd(t)
      EventManager:GetInstance():Broadcast(EventId.ValentineFollowSuccess, t.otherUid)
      if t.isFollow and t.isFollow == 1 and t.otherUserInfo then
        local param = {}
        param.activityId = t.activityId
        param.needRequest = false
        DataCenter.ValentineDataManager:SetMatchList(t.activityId, {
          t.otherUserInfo
        })
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIActValentineMatch, {
          anim = true,
          onFinish = function()
            EventManager:GetInstance():Broadcast(EventId.ValentineOnRecMatchList)
          end
        }, param)
      end
    elseif t.flag == 0 then
      UIUtil.ShowTipsId("Valentine_send_bp_tips_10")
    end
  end
end

return ValentineFollowMessage
