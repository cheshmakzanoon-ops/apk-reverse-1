local PushVirusHelpTreatMessage = BaseClass("PushVirusHelpTreatMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function PushVirusHelpTreatMessage:OnCreate()
  base.OnCreate(self)
end

function PushVirusHelpTreatMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t and t.treatlayer and t.helpName then
    local playerHead
    if t.pic and t.uid then
      local headBg
      if t.headSkinId and t.headSkinET then
        headBg = self:GetHeadBgImg(t.headSkinId, t.headSkinET)
      end
      playerHead = {
        uid = t.uid,
        pic = t.pic,
        picVer = t.picVer,
        HeadBg = headBg
      }
    end
    local msg = Localization:GetString("season_tips227", t.helpName, t.treatlayer)
    UIUtil.ShowTips(msg, nil, playerHead)
    EventManager:GetInstance():Broadcast(EventId.MSG_ITME_STATUS_TIME_CHANGE)
  end
end

return PushVirusHelpTreatMessage
