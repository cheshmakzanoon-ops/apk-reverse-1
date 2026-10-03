local UserDelAccountMessage = BaseClass("UserDelAccountMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, confirmType, uid)
  base.OnCreate(self)
  local confirm = AccountDelConfirmType.SendReview
  if confirmType then
    confirm = confirmType
  end
  self.sfsObj:PutInt("confirm", confirm)
  if not string.IsNullOrEmpty(uid) then
    self.sfsObj:PutUtfString("uid", uid)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    local tipStr
    if errCode == "delete_account_content_17" and t.endTime then
      local diffTime = t.endTime - UITimeManager:GetInstance():GetServerTime()
      if 0 < diffTime then
        tipStr = Localization:GetString(errCode, UITimeManager:GetInstance():GetFormattedTimeMs(diffTime))
      end
    elseif errCode == "delete_account_content_16" then
      tipStr = Localization:GetString(errCode)
    end
    if not string.IsNullOrEmpty(tipStr) then
      UIUtil.ShowSecondMessage("", tipStr, 1, GameDialogDefine.CONFIRM, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, false)
    else
      UIUtil.ShowTipsId(errCode)
    end
    return
  end
  local confirm = AccountDelConfirmType.SendReview
  if t.confirm then
    confirm = t.confirm
  end
  if confirm == AccountDelConfirmType.SendReview then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDelAllAcctResultConfirm, {anim = true})
  elseif confirm == AccountDelConfirmType.RealDel then
  end
end

UserDelAccountMessage.OnCreate = OnCreate
UserDelAccountMessage.HandleMessage = HandleMessage
return UserDelAccountMessage
