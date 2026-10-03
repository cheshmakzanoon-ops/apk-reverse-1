local UIZendeskCtrl = BaseClass("UIZendeskCtrl", UIBaseCtrl)
local inClose = false

local function CloseSelf(self)
  if inClose then
    return
  end
  inClose = true
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIZendesk)
end

local function CreateZendeskSupportView(self, container, url)
  inClose = false
  CS.ZendeskSupportView.Show(container.gameObject, url, function()
    self:CloseSelf()
  end)
end

local function CloseZendeskSupportView(self)
  CS.ZendeskSupportView.Close()
end

local function ShowZendeskMessaging(self)
  CS.ZendeskSupportView.ShowMessaging()
end

local function OnCustomKeyCodeEscape(self)
end

UIZendeskCtrl.CloseSelf = CloseSelf
UIZendeskCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
UIZendeskCtrl.CreateZendeskSupportView = CreateZendeskSupportView
UIZendeskCtrl.CloseZendeskSupportView = CloseZendeskSupportView
UIZendeskCtrl.ShowZendeskMessaging = ShowZendeskMessaging
return UIZendeskCtrl
