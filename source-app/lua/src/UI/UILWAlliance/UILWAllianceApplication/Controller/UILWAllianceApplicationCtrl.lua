local UILWAllianceApplicationCtrl = BaseClass("UILWAllianceApplicationCtrl", UIBaseCtrl)

function UILWAllianceApplicationCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAllianceApplication)
end

function UILWAllianceApplicationCtrl:Close()
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

function UILWAllianceApplicationCtrl:GetAllianceApplyList()
  local showList = {}
  local data = DataCenter.AllianceMemberDataManager:GetApplyMemberList()
  if data ~= nil then
    table.walk(data, function(k, v)
      local oneData = {}
      oneData.uid = v.uid
      oneData.name = v.name
      oneData.power = v.power
      oneData.kill = v.armyKill
      oneData.pic = v.pic
      oneData.picVer = v.picVer
      oneData.headBg = v:GetHeadBgImg()
      oneData.gender = v.gender
      oneData.level = v.level
      table.insert(showList, oneData)
    end)
  end
  return showList
end

function UILWAllianceApplicationCtrl:OnPlayerDetailClick(uid)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true, hideTop = true}, uid)
end

function UILWAllianceApplicationCtrl:OnAcceptClick(uid)
  if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
    UIUtil.ShowTipsId(120173)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.AcceptAllianceApply, uid)
end

function UILWAllianceApplicationCtrl:OnRefuseClick(uid)
  if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
    UIUtil.ShowTipsId(120173)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.RefuseAllianceApply, uid)
end

return UILWAllianceApplicationCtrl
