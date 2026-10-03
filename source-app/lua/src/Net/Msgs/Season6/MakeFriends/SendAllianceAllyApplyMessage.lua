local SendAllianceAllyApplyMessage = BaseClass("SendAllianceAllyApplyMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SendAllianceAllyApplyMessage:OnCreate(targetAllianceId, content)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("targetAllianceId", targetAllianceId)
  self.sfsObj:PutUtfString("content", content)
end

function SendAllianceAllyApplyMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.applyId then
    SFSNetwork.SendMessage(MsgDefines.FetchAllianceAllyApplyDetail, t.applyId)
    SFSNetwork.SendMessage(MsgDefines.FetchAllianceAllyCombinedList)
    UIUtil.ShowTipsId("zonewar_landlord_tips_1004")
  end
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWSeasonMakeFriendsMainUI) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonMakeFriendsMainUI, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllHide
    })
  end
end

return SendAllianceAllyApplyMessage
