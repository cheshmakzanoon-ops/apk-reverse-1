local UILWAlMemberOfficialCtrl = BaseClass("UILWAlMemberOfficialCtrl", UIBaseCtrl)
local AllianceMemberShowInfo = require("DataCenter.AllianceData.AllianceMemberShowInfo")

function UILWAlMemberOfficialCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAlMemberOfficial)
end

function UILWAlMemberOfficialCtrl:GetAllShowData(rankGroupShowMember, keyword, fromSearch, autoShowMax)
  return DataCenter.AllianceMemberDataManager:GetAllShowData(rankGroupShowMember, keyword, fromSearch, autoShowMax)
end

return UILWAlMemberOfficialCtrl
