local UIMainNoticeCtrl = BaseClass("UIMainNoticeCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMainNotice, {anim = true})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function GetOneMailByUid(self, uuid)
  local noticeData = DataCenter.WorldNoticeManager:GetDataInfo()
  if noticeData then
    for i = 1, table.count(noticeData) do
      if noticeData[i].uuid == uuid then
        return noticeData[i]
      end
    end
  end
  return nil
end

UIMainNoticeCtrl.CloseSelf = CloseSelf
UIMainNoticeCtrl.Close = Close
UIMainNoticeCtrl.GetOneMailByUid = GetOneMailByUid
return UIMainNoticeCtrl
