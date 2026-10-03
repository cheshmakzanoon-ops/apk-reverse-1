local PushAllianceLeaveMessage = BaseClass("PushAllianceLeaveMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local AutoCloseView = {
  UIWindowNames.UILWAlMain,
  UIWindowNames.UIAllianceWarMainTable,
  UIWindowNames.UILWAlHelp,
  UIWindowNames.UILWAllianceGift,
  UIWindowNames.UILWAlMember,
  UIWindowNames.UILWAlMemberManager,
  UIWindowNames.UILWAlAuthorityManager,
  UIWindowNames.UILWAlMemberOfficial,
  UIWindowNames.UIAllianceScience,
  UIWindowNames.UIAllianceScienceInfo,
  UIWindowNames.UILWAlAssemblyInfo,
  UIWindowNames.UILWAllianceRank,
  UIWindowNames.UILWAlRankRewardPanel,
  UIWindowNames.UIActivityAttackCityDetail,
  UIWindowNames.UIAllianceTask,
  UIWindowNames.UILWAllianceLog,
  UIWindowNames.UILWAllianceApplication,
  UIWindowNames.UIAllianceStarBook,
  UIWindowNames.UILWAlSetting,
  UIWindowNames.UILWAllianceInviteShare,
  UIWindowNames.UILWAllianceInviteShareNew,
  UIWindowNames.UILWAlMail_v2,
  UIWindowNames.LWUIAllianceNoticeDetail
}

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceBaseDataManager:ResetAllianceData(t)
    local reason = t.reason
    local needTip = true
    if not string.IsNullOrEmpty(reason) and (reason == "Kick_By_Merge" or reason == "Kick_By_Recommend" or reason == "Kick_By_Alliance_Recommend" or reason == "Kick_By_Alliance_Jump") then
      needTip = false
    end
    if needTip then
      UIUtil.ShowMessage(Localization:GetString("390868"), 1, "110006", nil, function()
        local params = {guide = false}
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
      end, nil, nil)
    end
    for i, v in ipairs(AutoCloseView) do
      UIManager:GetInstance():DestroyWindow(v)
    end
  end
end

PushAllianceLeaveMessage.OnCreate = OnCreate
PushAllianceLeaveMessage.HandleMessage = HandleMessage
return PushAllianceLeaveMessage
