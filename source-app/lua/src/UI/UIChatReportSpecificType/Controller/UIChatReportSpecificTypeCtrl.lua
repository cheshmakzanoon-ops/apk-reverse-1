local UIChatReportSpecificTypeCtrl = BaseClass("UIChatReportSpecificTypeCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local Conf = {
  {
    ReportType = ChatReportType.Politics,
    Dialog = "208240"
  },
  {
    ReportType = ChatReportType.Ads,
    Dialog = "208241"
  },
  {
    ReportType = ChatReportType.Gambling,
    Dialog = "208242"
  },
  {
    ReportType = ChatReportType.Gm,
    Dialog = "208243"
  },
  {
    ReportType = ChatReportType.Sexy,
    Dialog = "208244"
  },
  {
    ReportType = ChatReportType.Attack,
    Dialog = "208245"
  },
  {
    ReportType = ChatReportType.Privacy,
    Dialog = "report_reason_privacy"
  },
  {
    ReportType = ChatReportType.Other,
    Dialog = "208248"
  }
}

local function GetReportReasonCof()
  return Conf
end

local function GetPlayerName(data)
  if data.type == ReportType.SeasonAlliancePhoto or data.type == ReportType.SeasonAlliancePhotoMessage then
    if data.title then
      return Localization:GetString("208252", data.title)
    end
    if data.name then
      return Localization:GetString("208252", data.name)
    end
    if data.allianceId then
      return Localization:GetString("report_alliance", data.allianceId)
    end
  end
  return ""
end

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIChatReportSpecificType)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIChatReportSpecificTypeCtrl.CloseSelf = CloseSelf
UIChatReportSpecificTypeCtrl.Close = Close
UIChatReportSpecificTypeCtrl.GetReportReasonCof = GetReportReasonCof
UIChatReportSpecificTypeCtrl.GetPlayerName = GetPlayerName
return UIChatReportSpecificTypeCtrl
