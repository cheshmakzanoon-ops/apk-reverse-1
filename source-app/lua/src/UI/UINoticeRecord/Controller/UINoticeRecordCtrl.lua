local UINoticeRecordCtrl = BaseClass("UINoticeRecordCtrl", UIBaseCtrl)
local FilterSetData = {
  [AlNoticeRecordFilterType.All] = {
    TopBg = nil,
    txtKey = "alliance_announcement_title_history2",
    descKey = nil
  },
  [AlNoticeRecordFilterType.Publish] = {
    TopBg = "zyf_LMGG_fabu_bg_lan",
    txtKey = "alliance_announcement_title_history3",
    descKey = "alliance_announcement_history_tips4"
  },
  [AlNoticeRecordFilterType.Delete] = {
    TopBg = "lrb_LMGG_shanchu_bg",
    txtKey = "alliance_announcement_title_history5",
    descKey = "alliance_announcement_history_tips3"
  },
  [AlNoticeRecordFilterType.Upgrade] = {
    TopBg = "lrb_LMGG_jiaji_bg",
    txtKey = "alliance_announcement_history_tips6",
    descKey = "alliance_announcement_history_tips5"
  },
  [AlNoticeRecordFilterType.Edit] = {
    TopBg = "zyf_LMGG_fabu_bg_lv",
    txtKey = "alliance_announcement_title_history4",
    descKey = "alliance_announcement_history_tips2"
  }
}
local FilterTypeShowList = {
  AlNoticeRecordFilterType.All,
  AlNoticeRecordFilterType.Publish,
  AlNoticeRecordFilterType.Edit,
  AlNoticeRecordFilterType.Delete,
  AlNoticeRecordFilterType.Upgrade
}

function UINoticeRecordCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UINoticeRecord, {anim = true, playEffect = false})
end

function UINoticeRecordCtrl:GetFilterTypeConfig(filterType)
  if filterType and FilterSetData[filterType] then
    return FilterSetData[filterType]
  end
end

function UINoticeRecordCtrl:GetFilterTypeShowList()
  return FilterTypeShowList
end

function UINoticeRecordCtrl:OnCustomKeyCodeEscape()
  if self.view then
    self.view:BlackWebView()
  else
    self:CloseSelf()
  end
end

return UINoticeRecordCtrl
