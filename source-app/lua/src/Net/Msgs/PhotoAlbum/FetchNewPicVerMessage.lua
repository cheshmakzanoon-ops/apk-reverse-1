local FetchNewPicVerMessage = BaseClass("FetchNewPicVerMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function FetchNewPicVerMessage:OnCreate(funcType)
  base.OnCreate(self)
  self.sfsObj:PutInt("funcType", funcType)
end

function FetchNewPicVerMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if t.expireTime then
      local second = UITimeManager:GetInstance():SecondToFmtString(tonumber(t.expireTime))
      local lang = Localization:GetString(errCode, second)
      UIUtil.ShowTips(lang or errCode)
    else
      UIUtil.ShowTipsId(errCode)
    end
    if t.funcType == FetchPicVerFuncType.SeasonAlliancePhoto then
      DataCenter.SeasonPhotoManager:SetSeasonPhotoUploadFail()
    elseif DataCenter.SendPhotoToServerManager:CheckIsInclueImgFuncType(t.funcType) then
      DataCenter.SendPhotoToServerManager:StopAllNoPicVerTask()
    end
  else
    if t.photoVersion == nil then
      Logger.LogError("\230\156\141\229\138\161\229\153\168\228\184\139\229\143\145\230\156\128\230\150\176\229\155\190\231\137\135\231\137\136\230\156\172\229\143\183\228\184\186\231\169\186\239\188\129")
      DataCenter.SendPhotoToServerManager:StopAllNoPicVerTask()
      return
    end
    if t.funcType == FetchPicVerFuncType.PlayerHeadIcon then
      LuaEntry.GlobalData.serverPicVer = toInt(t.photoVersion)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerHeadIconSelect, {anim = true})
    elseif t.funcType == FetchPicVerFuncType.ChatSendPhoto or t.funcType == FetchPicVerFuncType.MomentPhoto or t.funcType == FetchPicVerFuncType.ChatAllianceNoticePhoto then
      LuaEntry.GlobalData.readyForPicVer = true
      LuaEntry.GlobalData.lastestPicVer_ChatPhoto = toInt(t.photoVersion)
      if LuaEntry.GlobalData.readyForSelectPic and LuaEntry.GlobalData.readyForPicVer then
        if t.funcType == FetchPicVerFuncType.ChatSendPhoto then
          DataCenter.ChatSendPhotoManager:CheckUploadShowSecondConfirmBox()
        elseif t.funcType == FetchPicVerFuncType.MomentPhoto or t.funcType == FetchPicVerFuncType.ChatAllianceNoticePhoto then
          DataCenter.ChatSendPhotoManager:RequestStartUploadPhoto()
        end
      end
    elseif t.funcType == FetchPicVerFuncType.SeasonAlliancePhoto then
      LuaEntry.GlobalData.lastestPicVer_ChatPhoto = toInt(t.photoVersion)
      DataCenter.SeasonPhotoManager:RequestStartUploadSeasonPhoto()
    elseif DataCenter.SendPhotoToServerManager:CheckIsInclueImgFuncType(t.funcType) then
      DataCenter.SendPhotoToServerManager:OnPicVerMsgBack(toInt(t.photoVersion))
    end
  end
end

return FetchNewPicVerMessage
