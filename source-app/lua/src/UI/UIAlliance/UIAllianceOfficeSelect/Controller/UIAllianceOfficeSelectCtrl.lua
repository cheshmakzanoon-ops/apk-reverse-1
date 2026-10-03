local UIAllianceOfficeSelectCtrl = BaseClass("UIAllianceOfficeSelectCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceOfficeSelect)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function OnSetOfficial(self, uid, index)
  local officialNum = DataCenter.AllianceMemberDataManager:GetOfficialByUid(uid)
  local indexStr = tostring(index)
  if indexStr == officialNum and 0 < index then
    UIUtil.ShowTipsId(360114)
  elseif 0 < index then
    SFSNetwork.SendMessage(MsgDefines.AllianceSetRank, uid, 4, index)
  else
    local alliance = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    SFSNetwork.SendMessage(MsgDefines.AllianceDeleteOffical, alliance.uid, 4, tonumber(officialNum), uid)
  end
  self:CloseSelf()
end

UIAllianceOfficeSelectCtrl.CloseSelf = CloseSelf
UIAllianceOfficeSelectCtrl.Close = Close
UIAllianceOfficeSelectCtrl.OnSetOfficial = OnSetOfficial
return UIAllianceOfficeSelectCtrl
