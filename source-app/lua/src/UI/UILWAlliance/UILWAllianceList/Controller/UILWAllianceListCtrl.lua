local UILWAllianceListCtrl = BaseClass("UILWAllianceListCtrl", UIBaseCtrl)

function UILWAllianceListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAllianceList)
end

function UILWAllianceListCtrl:SendAlSearchMessageToServer(type, page, key, language, isRecommend)
  SFSNetwork.SendMessage(MsgDefines.AlSearch, type, page, key, language, isRecommend)
end

function UILWAllianceListCtrl:GetAllSearchAlIdList()
  return DataCenter.AllianceTempListManager:GetSearchAllianceIdList()
end

function UILWAllianceListCtrl:GetOneAlByUid(uid)
  return DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(uid)
end

return UILWAllianceListCtrl
