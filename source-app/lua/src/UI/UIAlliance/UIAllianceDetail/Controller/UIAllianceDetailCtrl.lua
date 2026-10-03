local UIAllianceDetailCtrl = BaseClass("UIAllianceDetailCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceDetail, {anim = true})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function SendSearchMessageToServer(self, type, page, key, language)
  SFSNetwork.SendMessage(MsgDefines.AlSearch, type, page, key, language)
end

local function GetAllianceData(self, uid)
  return DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(uid)
end

local function OnAllianceMemberClick(self, uid)
end

local function OnLeaderMailClick(self, leaderUid, leaderName)
  if not leaderUid or leaderUid == "" then
    UIUtil.ShowTipsId(390870)
    return
  end
  local userId = leaderUid
  local roomId = ChatManager2:GetInstance().Room:GetPrivateRoomByUserId(userId)
  local param = {}
  param.roomId = roomId
  param.userId = userId
  param.username = leaderName
  GoToUtil.OpenChatView(true, {
    anim = false,
    hideTop = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, param)
end

function UIAllianceDetailCtrl:TranslateAnnounceDesc(id, announce)
  local translateManager = DataCenter.MailDataManager.Translate
  local data = self:GetAllianceData(id)
  data.announce = announce
  data:SetIsTranslating(true)
  translateManager:Translate(data, translateManager.TranslateEnum.AlianceAnnouncement)
end

function UIAllianceDetailCtrl:TranslateAnnounceDescTitle(id, announceTitle)
  local translateManager = DataCenter.MailDataManager.Translate
  local data = self:GetAllianceData(id)
  data:SetAnnounceTitleTranslateing(true)
  data:SetAnnounceTitle(announceTitle)
  translateManager:Translate(data, translateManager.TranslateEnum.AlianceAnnouncementTitle)
end

UIAllianceDetailCtrl.CloseSelf = CloseSelf
UIAllianceDetailCtrl.Close = Close
UIAllianceDetailCtrl.GetAllianceData = GetAllianceData
UIAllianceDetailCtrl.OnAllianceMemberClick = OnAllianceMemberClick
UIAllianceDetailCtrl.SendSearchMessageToServer = SendSearchMessageToServer
UIAllianceDetailCtrl.OnLeaderMailClick = OnLeaderMailClick
return UIAllianceDetailCtrl
