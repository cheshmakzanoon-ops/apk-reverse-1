local ActMigrationSettingMessage = BaseClass("ActMigrationSettingMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, info)
  base.OnCreate(self)
  if not string.IsNullOrEmpty(info.notice) then
    self.sfsObj:PutUtfString("notice", info.notice)
  end
  local languageList = SFSArray.New()
  for _, v in pairs(info.languageList) do
    if not string.IsNullOrEmpty(v) then
      languageList:AddUtfString(v)
    end
  end
  self.sfsObj:PutSFSArray("languageList", languageList)
  self.sfsObj:PutInt("applyLevel", info.applyLevel)
  self.sfsObj:PutLong("applyPower", info.applyPower)
  self.sfsObj:PutInt("applyAutoLevel", info.applyAutoLevel)
  self.sfsObj:PutLong("applyAutoPower", info.applyAutoPower)
  self.sfsObj:PutInt("applyAutoSwitch", info.applyAutoSwitch)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowErrorCodeTips(t)
    return
  end
  DataCenter.ActMigrationManager:HandleSetting(t)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMigrationSetting)
end

ActMigrationSettingMessage.OnCreate = OnCreate
ActMigrationSettingMessage.HandleMessage = HandleMessage
return ActMigrationSettingMessage
