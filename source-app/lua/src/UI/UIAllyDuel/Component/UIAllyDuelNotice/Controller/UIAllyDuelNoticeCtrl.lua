local UIAllyDuelNoticeCtrl = BaseClass("UIAllyDuelNoticeCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllyDuelNotice)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function GetNoticeEndTime(self)
  local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  if not actInfo then
    return
  end
  return actInfo.preOpenTime
end

UIAllyDuelNoticeCtrl.CloseSelf = CloseSelf
UIAllyDuelNoticeCtrl.Close = Close
UIAllyDuelNoticeCtrl.GetNoticeEndTime = GetNoticeEndTime
return UIAllyDuelNoticeCtrl
