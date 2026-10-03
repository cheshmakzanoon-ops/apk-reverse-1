local SeasonCampDestroyNoticeCtrl = BaseClass("SeasonCampDestroyNoticeCtrl", UIBaseCtrl)

function SeasonCampDestroyNoticeCtrl:SetConfirmCallback(confirmCallback)
  self.confirmCallback = confirmCallback
end

function SeasonCampDestroyNoticeCtrl:DoConfirm()
  if self.confirmCallback then
    self.confirmCallback()
    self.confirmCallback = nil
  end
end

function SeasonCampDestroyNoticeCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonCampDestroyNotice)
end

function SeasonCampDestroyNoticeCtrl:GetDataList()
  return {
    {
      desc = "season_s6_activity_1200112_desc06",
      icon = "Assets/Main/SeasonRes/S6/Sprites/CampDestroy/mjc_S6_ZYDK_shuoming_icon_1.png"
    },
    {
      desc = "season_s6_activity_1200112_desc07",
      icon = "Assets/Main/SeasonRes/S6/Sprites/CampDestroy/mjc_S6_ZYDK_shuoming_icon_2.png"
    },
    {
      desc = "season_s6_activity_1200112_desc08",
      icon = "Assets/Main/SeasonRes/S6/Sprites/CampDestroy/mjc_S6_ZYDK_shuoming_icon_3.png"
    }
  }
end

return SeasonCampDestroyNoticeCtrl
