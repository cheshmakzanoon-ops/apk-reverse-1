local LWUIMeteoriteDropNoticeCtrl = BaseClass("LWUIMeteoriteDropNoticeCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function LWUIMeteoriteDropNoticeCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUIMeteoriteDropNoticeNotice)
end

return LWUIMeteoriteDropNoticeCtrl
