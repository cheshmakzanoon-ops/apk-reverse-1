local UILWAlSettingCtrl = BaseClass("UILWAlSettingCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local StringUtils = CS.StringUtils

function UILWAlSettingCtrl:SetView(view)
  self.view = view
end

function UILWAlSettingCtrl:ClearView()
  self.view = nil
end

function UILWAlSettingCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAlSetting)
end

function UILWAlSettingCtrl:OnSettingGreyClick(type)
  if type == LWAlSettingBtnType.Al_Mail then
    if CoppaUtil.IsCoppaLimitWithTips() then
      return
    end
    UIUtil.ShowTipsId(2900062)
  end
end

function UILWAlSettingCtrl:OnSettingBtnClick(type)
  if type == LWAlSettingBtnType.Al_Exit then
    local farmer = DataCenter.SeasonFarmerManager:IsActive()
    if farmer then
      UIUtil.ShowSecondMessage("", Localization:GetString("season_builders_alliance_UI_20"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        UIUtil.ShowLeaveAllianceTips(function(isDismiss)
          self:QuitAlliance(isDismiss)
        end)
      end, nil, nil, nil, nil, nil, nil, nil, nil, false)
      return
    end
    UIUtil.ShowLeaveAllianceTips(function(isDismiss)
      local todayShow = DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.ShowFireworkQuitAlliance)
      if (DataCenter.LWFireworkManager:IsFiringByUid(LuaEntry.Player:GetUid()) or DataCenter.LWFireworkGiftManager:IsHasAvailableBoxByUid(LuaEntry.Player:GetUid())) and todayShow then
        UIUtil.ShowSecondMessageByParam({
          tipText = Localization:GetString("firework_tips_1003"),
          btnNum = 2,
          showToggle = true,
          toggleAction = function(isOn)
            DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.ShowFireworkQuitAlliance, isOn)
          end,
          sureAction = function()
            self:QuitAlliance(isDismiss)
          end
        })
      else
        self:QuitAlliance(isDismiss)
      end
    end)
  elseif type == LWAlSettingBtnType.Al_Authority then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlAuthorityInfo, {anim = true, hideTop = false})
  elseif type == LWAlSettingBtnType.Al_Share then
    if LuaEntry.DataConfig:CheckSwitch("alliance_inviteLinkNew_switch") then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceInviteShareNew, {anim = true})
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceInviteShare, {anim = true})
    end
  elseif type == LWAlSettingBtnType.Al_Apply then
  elseif type == LWAlSettingBtnType.Al_List then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceList, {anim = true})
  elseif type == LWAlSettingBtnType.Al_Modify then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlModifyInfo, {anim = true})
  elseif type == LWAlSettingBtnType.Al_Mail then
    if CoppaUtil.IsCoppaLimitWithTips() then
      return
    end
    local canChat = DataCenter.LWRefundPunishManager:GetCanChat()
    if not canChat then
      return
    end
    if StringUtils.VersionCompare(CS.GameEntry.Sdk.Version, "1.0.258") >= 0 and not Config.IsPC() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlMail_v2, {anim = true})
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlMail, {anim = true})
    end
  elseif type == LWAlSettingBtnType.Al_Alliance_War_time then
    UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonAllianceWarTimeSetView)
  else
    UIUtil.ShowTipsId(393003)
  end
end

function UILWAlSettingCtrl:DismissAlliance()
  SFSNetwork.SendMessage(MsgDefines.AlDismiss)
  GoToUtil.CloseAllWindows()
end

function UILWAlSettingCtrl:QuitAlliance(isDismiss)
  if isDismiss then
    SFSNetwork.SendMessage(MsgDefines.AlDismiss)
  else
    SFSNetwork.SendMessage(MsgDefines.AlLeave)
  end
  GoToUtil.CloseAllWindows()
end

function UILWAlSettingCtrl:GetBtnList()
  local btns = {}
  for _, v in ipairs(LWAlSettingShowBtns) do
    if v == LWAlSettingBtnType.Al_Modify then
      if DataCenter.AllianceBaseDataManager:IsSelfLeader() then
        table.insert(btns, v)
      end
    elseif v == LWAlSettingBtnType.Al_Cancel_Leader then
      if not DataCenter.AllianceBaseDataManager:IsSelfLeader() then
        table.insert(btns, v)
      end
    elseif v == LWAlSettingBtnType.Al_Apply or v == LWAlSettingBtnType.Al_Share or v == LWAlSettingBtnType.Al_Mail then
      if DataCenter.AllianceBaseDataManager:IsR4orR5() then
        table.insert(btns, v)
      end
    elseif v == LWAlSettingBtnType.Al_Alliance_War_time then
      if DataCenter.UILWSeasonAllianceWarTimeManager:IsFuncOpen(true) and DataCenter.UILWSeasonAllianceWarTimeManager:CanShowOnUI() then
        table.insert(btns, v)
      end
    else
      table.insert(btns, v)
    end
  end
  return btns
end

return UILWAlSettingCtrl
