local PushUserGMOffMessage = BaseClass("PushUserGMOffMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  UIUtil.ShowMessage(Localization:GetString("E130023"), 2, "110043", "129091", function()
    CS.ApplicationLaunch.Instance:Quit()
  end, function()
    CS.ApplicationLaunch.Instance:ReloadGameCheckResVerion()
  end)
end

PushUserGMOffMessage.OnCreate = OnCreate
PushUserGMOffMessage.HandleMessage = HandleMessage
return PushUserGMOffMessage
