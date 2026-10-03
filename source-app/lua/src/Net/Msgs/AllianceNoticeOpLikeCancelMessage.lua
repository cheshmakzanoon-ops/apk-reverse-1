local AllianceNoticeOpLikeCancelMessage = BaseClass("AllianceNoticeOpLikeCancelMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uid, like)
  base.OnCreate(self)
  if uid then
    self.sfsObj:PutUtfString("uuid", tostring(uid))
  end
  if like == 1 then
    self.sfsObj:PutInt("like", 1)
    self.sfsObj:PutInt("dislike", 0)
  else
    self.sfsObj:PutInt("like", 0)
    self.sfsObj:PutInt("dislike", 1)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode == nil or t.errorCode == "" then
    DataCenter.AllianceNoticeManager:RefreshOneNoticeData(t.noticeInfo, 1)
    if t.like == 1 and t.dislike == 0 then
      DataCenter.AllianceNoticeManager:SetIsWaitClickLikeCache(t.noticeInfo.uuid, false)
    elseif t.like == 0 and t.dislike == 1 then
      DataCenter.AllianceNoticeManager:SetIsWaitClickDisLikeCache(t.noticeInfo.uuid, false)
    else
      Logger.LogError("\229\133\172\229\145\138\231\130\185\232\181\158\228\184\139\229\143\145\230\149\176\230\141\174\228\184\141\229\175\185\227\128\130like:" .. t.like .. "dislike:" .. t.dislike)
    end
  else
    local lang = Localization:GetString(t.errorCode)
    local str = lang or t.errorCode
    UIUtil.ShowTips(lang or str)
  end
end

AllianceNoticeOpLikeCancelMessage.OnCreate = OnCreate
AllianceNoticeOpLikeCancelMessage.HandleMessage = HandleMessage
return AllianceNoticeOpLikeCancelMessage
