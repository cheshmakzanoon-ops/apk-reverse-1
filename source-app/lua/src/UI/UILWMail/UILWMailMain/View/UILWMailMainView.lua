local UILWMailMainView = BaseClass("UILWMailMainView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local MailChannel = require("UI.UILWMail.UILWMailMain.Component.UILWMailChannel")
local MailList = require("UI.UILWMail.UILWMailMain.Component.UILWMailList")
local MailDetail = require("UI.UILWMail.UILWMailMain.Component.UILWMailDetail")
local MailBattleParseHelper = require("DataCenter.MailData.MailBattleParseHelper")
local title_text_path = "Root/TopBar/TextTitle"
local return_btn_path_close = "Root/BottomBar/BtnClose"
local return_btn_path_1 = "Root/BottomBar/BtnBack1"
local return_btn_path_2 = "Root/BottomBar/BtnBack2"
local return_btn_path_3 = "Root/BottomBar/BtnBack3"
local channel_content_path = "Root/MiddleContentContainer/ChannelHolder"
local mail_list_content_path = "Root/MiddleContentContainer/MailHolder"
local no_mail_txt = "Root/MiddleContentContainer/MailHolder/NoMailTxt"
local mail_detail_content_path = "Root/MiddleContentContainer/MailDetailHolder"
local all_read_red_path = "Root/BottomBar/AllReadBtn/CommonRedPoint"
local all_read_btn_path = "Root/BottomBar/AllReadBtn"
local all_read_btn_txt_path = "Root/BottomBar/AllReadBtn/AllReadText"
local all_delete_btn_path = "Root/BottomBar/AllDeleteBtn"
local all_delete_btn_txt_path = "Root/BottomBar/AllDeleteBtn/AllDeleteText"
local collect_btn_path = "Root/BottomBar/MailDetailBtns/CollectBtn"
local collect_btn_txt_path = "Root/BottomBar/MailDetailBtns/CollectBtn/CollectText"
local share_btn_path = "Root/BottomBar/MailDetailBtns/ShareBtn"
local delete_btn_path = "Root/BottomBar/MailDetailBtns/DeleteBtn"
local delete_btn_txt_path = "Root/BottomBar/MailDetailBtns/DeleteBtn/DeleteText"
local receive_btn_path = "Root/BottomBar/ReceiveBtn"
local receive_btn_txt_path = "Root/BottomBar/ReceiveBtn/ReceiveText"
local all_rm_btn_path = "Root/BottomBar/AllRMBtn"
local recharge_assistance_path = "Root/TopBar/RechargeAssistance"
local recharge_assistance_text_path = "Root/TopBar/RechargeAssistance/LW_Btn_Common_New_Base/RechargeAssistanceText"
local NO_MAIL_TXT = 311043
local __fromTag, __fromData

function UILWMailMainView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function UILWMailMainView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailMainView:ComponentDefine()
  self.closeBtn = self:AddComponent(UIButton, return_btn_path_close)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.returnBtn1 = self:AddComponent(UIButton, return_btn_path_1)
  self.returnBtn1:SetOnClick(function()
    self.ctrl:SetCurrentView(1)
    self.ctrl:SetCurrentTab(0)
    self:ContentTrans()
  end)
  self.returnBtn2 = self:AddComponent(UIButton, return_btn_path_2)
  self.returnBtn2:SetOnClick(function()
    BattleReportUtil.Cancel()
    if __fromTag then
      if __fromTag == "PeakArenaRecord" then
        self.ctrl:CloseSelf()
        DataCenter.LWPVPArenaManager.ShowPVPArenaMain(PVPArenaType.PeakArena, true)
      elseif __fromTag == "ActivityArenaRecord" then
        self.ctrl:CloseSelf()
        local activityId = tonumber(__fromData)
        if activityId == DataCenter.LWNewbieArenaV2Manager:GetArenaInfoId() then
          DataCenter.LWPVPArenaManager.ShowPVPArenaMain(PVPArenaType.NewbieArenaV2)
        else
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCenterTable, {
            anim = true,
            UIMainAnim = UIMainAnimType.AllHide
          }, activityId)
        end
      elseif __fromTag == "3V3Record" then
        self.ctrl:CloseSelf()
        if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIArena3V3BattleResult) and not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UITrain3V3BattleResult) and DataCenter.LW3V3Manager:GetType() == Type3v3.Arena then
          DataCenter.LWPVPArenaManager.ShowPVPArenaMain(PVPArenaType.Arena3V3, __fromData)
        end
      elseif __fromTag == "TruckRecord" then
        self.ctrl:CloseSelf()
        if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWTruckRecord) then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTruckRecord, {anim = false}, {})
        end
      elseif __fromTag == "HSRRecord" then
        self.ctrl:CloseSelf()
        if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIHSRPersonalHistoryList) then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIHSRPersonalHistoryList, {anim = true}, 2)
        end
      elseif __fromTag == "ChatShareRob" then
        self.ctrl:CloseSelf()
      elseif __fromTag == "NewPeakArenaRecord" then
        self.ctrl:CloseSelf()
        if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.NewPeakArenaRecord) then
          DataCenter.LWPVPArenaManager.ShowPVPArenaMain(PVPArenaType.NewPeakArena, true)
        end
      elseif __fromTag == "NewGaleArenaRecord" then
        self.ctrl:CloseSelf()
        if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.NewPeakArenaRecord) then
          DataCenter.LWPVPArenaManager.ShowPVPArenaMain(PVPArenaType.NewGaleArena, true)
        end
      elseif __fromTag == "KOFBattleResult" then
        self.ctrl:CloseSelf()
      elseif __fromTag == "TrainKOFBattleRecord" then
        self.ctrl:CloseSelf()
      elseif __fromTag == "DetectReward" then
        self.ctrl:CloseSelf()
      elseif __fromTag == "WorldPointScout" then
        self.ctrl:CloseSelf()
        local info = CS.SceneManager.World:GetPointInfo(__fromData)
        if info then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
            anim = true,
            playEffect = false,
            UIMainAnim = UIMainAnimType.LeftRightBottomHide
          }, info.uuid, info.mainIndex, info.ownerUid, WorldPointUIType.City, 0, info.itemId)
        end
      elseif __fromTag == "ConvertBattleReportToVirtualMail" then
        self.ctrl:CloseSelf()
        if __fromData and __fromData.callBackAfterCloseMailUI then
          __fromData.callBackAfterCloseMailUI(self.openType)
        end
      end
      __fromTag = nil
      __fromData = nil
      DataCenter.MailDataManager:ClearFromTagAndFromData()
    else
      local tab = self.ctrl:GetCurrentTab()
      if tab and 0 < tab then
        self.ctrl:SetCurrentView(2)
        self.ctrl:SetCurrentMail(nil)
        self:ContentTrans()
      else
        self.ctrl:CloseSelf()
      end
    end
  end)
  self.returnBtn3 = self:AddComponent(UIButton, return_btn_path_3)
  self.returnBtn3:SetActive(false)
  self.returnBtn3:SetOnClick(function()
    if self.ctrl:IsCurTemp() then
      local viewType = self:TryCorrectViewType(MailContentType.SharedMail, __fromTag)
      self.ctrl:SetCurrentView(viewType)
    else
      self.ctrl:SetCurrentView(3)
    end
    self:ContentTrans()
  end)
  self.titleText = self:AddComponent(UIText, title_text_path)
  self.channelContent = self:AddComponent(MailChannel, channel_content_path)
  self.mailListContent = self:AddComponent(MailList, mail_list_content_path)
  self.noMailTxt = self:AddComponent(UIText, no_mail_txt)
  self.noMailBtn = self:AddComponent(UIButton, no_mail_txt)
  self.noMailBtn:SetOnClick(function()
    self:OnNoMailClick()
  end)
  self.mailDetailContent = self:AddComponent(MailDetail, mail_detail_content_path)
  self.allReadRedPoint = self:AddComponent(UICommonRedPoint, all_read_red_path)
  self.allReadRedPoint:SetType(CommonRedPointPriority.Level1)
  self.allReadTxt = self:AddComponent(UIText, all_read_btn_txt_path)
  self.allReadBtn = self:AddComponent(UIButton, all_read_btn_path)
  self.allReadBtn:SetOnClick(function()
    self:OnAllReadClick()
  end)
  self.allDeleteTxt = self:AddComponent(UIText, all_delete_btn_txt_path)
  self.allDeleteBtn = self:AddComponent(UIButton, all_delete_btn_path)
  self.allDeleteBtn:SetOnClick(function()
    self:OnAllDeleteClick()
  end)
  self.shareBtn = self:AddComponent(UIButton, share_btn_path)
  self.shareBtn:SetOnClick(function()
    self:OnShareBtnClick()
  end)
  self.collectTxt = self:AddComponent(UIText, collect_btn_txt_path)
  self.collectBtnImg = self:AddComponent(UIImage, collect_btn_path)
  self.collectBtn = self:AddComponent(UIButton, collect_btn_path)
  self.collectBtn:SetOnClick(function()
    self:OnCollectClick()
  end)
  self.deleteTxt = self:AddComponent(UIText, delete_btn_txt_path)
  self.deleteBtn = self:AddComponent(UIButton, delete_btn_path)
  self.deleteBtn:SetOnClick(function()
    self:OnDeleteClick()
  end)
  self.receiveTxt = self:AddComponent(UIText, receive_btn_txt_path)
  self.receiveBtn = self:AddComponent(UIButton, receive_btn_path)
  self.receiveBtn:SetOnClick(function()
    self:OnReceiveClick()
  end)
  self.allReadTxt:SetLocalText(MailButtonTitle[MailButtonType.ALL_READ])
  self.allDeleteTxt:SetLocalText(MailButtonTitle[MailButtonType.ALL_DELETE])
  self.collectTxt:SetLocalText(MailButtonTitle[MailButtonType.COLLECT])
  self.deleteTxt:SetLocalText(MailButtonTitle[MailButtonType.DELETE])
  self.receiveTxt:SetLocalText(MailButtonTitle[MailButtonType.RECEIVE])
  self.noMailTxt:SetLocalText(NO_MAIL_TXT)
  self.all_rm_btn = self:AddComponent(UIButton, all_rm_btn_path)
  self.all_rm_btn:SetOnClick(function()
    self:OnRmAllClick()
  end)
  self.tipTxt = self:AddComponent(UIText, "Root/BottomBar/TipText")
  self.tipTxt:SetLocalText(801311)
  self.channelContent:SetActive(true)
  self.mailListContent:SetActive(true)
  self.mailDetailContent:SetActive(true)
  self.rechargeAssistanceBtn = self:AddComponent(UIButton, recharge_assistance_path)
  self.rechargeAssistanceBtn:SetOnClick(function()
    self:OnClickRechargeAssistance()
  end)
  self.rechargeAssistanceBtnText = self:AddComponent(UIText, recharge_assistance_text_path)
end

function UILWMailMainView:ComponentDestroy()
  self.closeBtn = nil
  self.returnBtn1 = nil
  self.returnBtn2 = nil
  self.returnBtn3 = nil
  self.titleText = nil
  self.channelContent = nil
  self.mailListContent = nil
  self.noMailTxt = nil
  self.mailDetailContent = nil
  self.allReadRedPoint = nil
  self.allReadTxt = nil
  self.allReadBtn = nil
  self.allDeleteTxt = nil
  self.allDeleteBtn = nil
  self.collectTxt = nil
  self.collectBtn = nil
  self.deleteTxt = nil
  self.deleteBtn = nil
  self.receiveTxt = nil
  self.receiveBtn = nil
  self.all_rm_btn = nil
  self.rechargeAssistanceBtn = nil
  self.rechargeAssistanceBtnText = nil
end

function UILWMailMainView:DataDefine()
  self.ctrl:InitData()
  self.ctrl:SetView(self)
  self.hasReward = false
end

function UILWMailMainView:DataDestroy()
  self.ctrl:ClearData()
  self.hasReward = nil
end

function UILWMailMainView:OnEnable()
  base.OnEnable(self)
end

function UILWMailMainView:Init()
  self.ctrl:SetCurrentView(1)
  local openType, mailUid, fromTag, fromData = self:GetUserData()
  if fromTag then
    DataCenter.MailDataManager.fromTag = fromTag
  end
  if fromData then
    DataCenter.MailDataManager.fromData = fromData
  end
  __fromTag = DataCenter.MailDataManager.fromTag
  __fromData = DataCenter.MailDataManager.fromData
  openType = openType or UIMailOpenType.Default
  self.openType = openType
  if openType == UIMailOpenType.History then
    mailUid = DataCenter.MailDataManager:LoadUIHistory()
    openType = mailUid and UIMailOpenType.Detail or UIMailOpenType.Default
  end
  if openType == UIMailOpenType.Detail then
    local mailData = DataCenter.MailDataManager:GetMailInfoById(mailUid)
    if mailData == nil then
      self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, 5)
      DataCenter.MailDataManager:ReqMailById(mailUid, function(mailInfo)
        if self.__blockerHandleID then
          UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
          self.__blockerHandleID = nil
        end
        if not self.ctrl then
          return
        end
        if not mailInfo then
          return
        end
        local view, tab = DataCenter.MailDataManager:GetUIStateByUid(mailUid)
        if view and tab and mailUid then
          view = self:TryCorrectViewType(view, fromTag)
          self.ctrl:SetCurrentView(view)
          self.ctrl:SetCurrentTab(tab)
          self.ctrl:SetCurrentMail(mailUid)
          self:ReInit()
        end
      end)
    else
      local view, tab = DataCenter.MailDataManager:GetUIStateByUid(mailUid)
      if view and tab and mailUid then
        view = self:TryCorrectViewType(view, fromTag)
        self.ctrl:SetCurrentView(view)
        self.ctrl:SetCurrentTab(tab)
        self.ctrl:SetCurrentMail(mailUid)
      end
    end
  end
  self:ReInit()
end

function UILWMailMainView:TryCorrectViewType(oriViewType, fromTag)
  if (fromTag == "NewPeakArenaRecord" or fromTag == "NewGaleArenaRecord" or fromTag == "3V3Record" or fromTag == "TrainKOFBattleRecord" or fromTag == "TruckRecord" or fromTag == "ActivityArenaRecord" or fromTag == "KOFBattleResult") and oriViewType == MailContentType.SharedMail then
    return MailContentType.MailDetail
  end
  return oriViewType
end

function UILWMailMainView:OnDisable()
  base.OnDisable(self)
  if self.__blockerHandleID then
    UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
    self.__blockerHandleID = nil
  end
end

function UILWMailMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.Mail_DeleteMailDone, self.OnMailDeleteDone)
  self:AddUIListener(EventId.Mail_DeleteBatchMailDone, self.RefreshDownButtons)
  self:AddUIListener(EventId.MailPush, self.RefreshDownButtons)
  self:AddUIListener(EventId.Mail_KickAllMailDone, self.RefreshDownButtons)
  self:AddUIListener(EventId.Mail_MoveToTab, self.OnMailMoveToTab)
end

function UILWMailMainView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.Mail_DeleteMailDone, self.OnMailDeleteDone)
  self:RemoveUIListener(EventId.Mail_DeleteBatchMailDone, self.RefreshDownButtons)
  self:RemoveUIListener(EventId.MailPush, self.RefreshDownButtons)
  self:RemoveUIListener(EventId.Mail_KickAllMailDone, self.RefreshDownButtons)
  self:RemoveUIListener(EventId.Mail_MoveToTab, self.OnMailMoveToTab)
end

function UILWMailMainView:ReInit()
  self:ContentTrans()
end

function UILWMailMainView:RefreshTitle()
  local current_view = self.ctrl:GetCurrentView()
  local current_tab = self.ctrl:GetCurrentTab()
  local defaultDialog = "100164"
  if current_view == MailContentType.ChannelList then
    self.titleText:SetLocalText(defaultDialog)
  elseif current_view == MailContentType.MailList then
    self.titleText:SetLocalText(MailShowNameGroup[current_tab] and MailShowNameGroup[current_tab].title_txt or defaultDialog)
  elseif current_view == MailContentType.MailDetail then
    self.titleText:SetLocalText(defaultDialog)
  elseif current_view == MailContentType.SubBattleReport then
    self.titleText:SetLocalText(defaultDialog)
  elseif current_view == MailContentType.SharedMail then
    self.titleText:SetLocalText(defaultDialog)
  end
end

function UILWMailMainView:RefreshDownButtons()
  local current_view = self.ctrl:GetCurrentView()
  local current_tab = self.ctrl:GetCurrentTab()
  self.closeBtn:SetActive(false)
  self.returnBtn1:SetActive(false)
  self.returnBtn2:SetActive(false)
  self.returnBtn3:SetActive(false)
  self.allReadBtn:SetActive(false)
  self.allDeleteBtn:SetActive(false)
  self.collectBtn:SetActive(false)
  self.deleteBtn:SetActive(false)
  self.shareBtn:SetActive(false)
  self.receiveBtn:SetActive(false)
  self.all_rm_btn:SetActive(false)
  self.tipTxt:SetActive(false)
  if current_view == MailContentType.ChannelList then
    self.closeBtn:SetActive(true)
    self.tipTxt:SetActive(true)
  elseif current_view == MailContentType.MailList then
    self.returnBtn1:SetActive(true)
    local mailList = self.mailListContent:GetMailShowList()
    self.allReadBtn:SetActive(0 < #mailList)
    self.allDeleteBtn:SetActive(0 < #mailList)
  elseif current_view == MailContentType.MailDetail then
    self.returnBtn2:SetActive(true)
    self.collectBtn:SetActive(true)
    self.deleteBtn:SetActive(true)
    local mailData = self.ctrl:GetCurrentMailData()
    if mailData then
      if mailData.saveFlag == 1 then
        self.collectBtnImg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_youjianxitongyouhua_yishouchang_icon.png")
      else
        self.collectBtnImg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_fenxiangzhanbao_shoucang.png")
      end
      if mailData.type == MailType.LW_INACTIVITY_MEMBER_MAIL then
        self.all_rm_btn:SetActive(true)
        local mailCustom = mailData:GetMailCustom()
        local dealStatus = mailCustom and mailCustom.c and mailCustom.c.deal and mailCustom.c.deal or 0
        if dealStatus == 0 then
          local strKey = "MailKickAllDeal_" .. mailData.uid
          dealStatus = CS.GameEntry.Setting:GetInt(strKey, 0)
        end
        if dealStatus == 0 then
          UIGray.SetGray(self.all_rm_btn.transform, false, true)
        else
          UIGray.SetGray(self.all_rm_btn.transform, true, false)
        end
      else
        local has_reward = mailData.rewardStatus == 0
        if has_reward then
          self.receiveBtn:SetActive(true)
        else
          self.receiveBtn:SetActive(false)
        end
      end
      if ShareMailType[mailData.type] then
        self.shareBtn:SetActive(true)
        if IsMailNewFightType(mailData.type) then
          local extData = mailData:GetMailExt()
          if extData.battleType == MailBattleReportType.CROSS_ARENA then
            self.deleteBtn:SetActive(false)
            self.collectBtn:SetActive(false)
          end
        elseif mailData.type == MailType.TRUCK_BATTLE_REPORT or mailData.type == MailType.ZONE_TRAIN_BATTLE_RESULT then
          self.deleteBtn:SetActive(false)
          self.collectBtn:SetActive(false)
        elseif mailData.type == MailType.TRAIN_3V3 then
          self.deleteBtn:SetActive(false)
          self.collectBtn:SetActive(false)
        elseif mailData.type == MailType.TRAIN_KOF then
          self.deleteBtn:SetActive(false)
          self.collectBtn:SetActive(false)
        elseif mailData.type == MailType.NEW_ARENA_KOF_BATTLE or mailData.type == MailType.ARENA_BATTLE_REPORT then
          self.deleteBtn:SetActive(false)
          self.collectBtn:SetActive(true)
        end
      end
    end
  elseif current_view == MailContentType.SubBattleReport then
    self.returnBtn3:SetActive(true)
  elseif current_view == MailContentType.SharedMail then
    self.closeBtn:SetActive(true)
    if __fromTag and __fromTag == "ConvertBattleReportToVirtualMail" then
      self.closeBtn:SetActive(false)
      self.returnBtn2:SetActive(true)
      self.ctrl:SetVirtualBattleReportMailShowMark(true)
      if __fromData and __fromData.isShowSharedButton then
        self.shareBtn:SetActive(true)
      end
    end
  end
  if current_view == MailContentType.ChannelList then
    self.allReadBtn:SetLocalScaleXYZ(1, 1, 1)
    self.allReadBtn:SetAnchoredPositionXY(14, -5)
  elseif current_view == MailContentType.MailList then
    self.allReadBtn:SetLocalScaleXYZ(0.9, 0.9, 0.9)
    self.allReadBtn:SetAnchoredPositionXY(251, -5)
  end
  if current_view == MailContentType.ChannelList or current_view == MailContentType.MailList then
    self.allReadRedPoint:SetActive(false)
    self.ctrl:JudgeRewardByGroup(function(bool)
      self.hasReward = bool
      if bool and self.allReadRedPoint then
        if current_tab == MailInternalGroup.MAIL_IN_alliance or current_tab == MailInternalGroup.MAIL_IN_system or current_tab == MailInternalGroup.MAIL_IN_activity then
          self.allReadRedPoint:SetNum(1)
        else
          self.allReadRedPoint:SetDefaultVisible(true)
        end
      end
    end)
  end
end

function UILWMailMainView:ContentTrans()
  self:RefreshTitle()
  self:RefreshDownButtons()
  local current_view = self.ctrl:GetCurrentView()
  if current_view == MailContentType.ChannelList then
    self.channelContent:SetShow(true)
    self.mailListContent:SetShow(false)
    self.mailDetailContent:SetShow(false)
    self.channelContent:RefreshContent()
  elseif current_view == MailContentType.MailList then
    self.channelContent:SetShow(false)
    self.mailListContent:SetShow(true)
    self.mailDetailContent:SetShow(false)
    self.mailListContent:RefreshContent()
  elseif current_view == MailContentType.MailDetail then
    self.channelContent:SetShow(false)
    self.mailListContent:SetShow(false)
    self.mailDetailContent:SetShow(true)
    self.mailDetailContent:RefreshContent()
  elseif current_view == MailContentType.SubBattleReport then
    self.channelContent:SetShow(false)
    self.mailListContent:SetShow(false)
    self.mailDetailContent:SetShow(true)
    self.mailDetailContent:ShowMusterSolo()
  elseif current_view == MailContentType.SharedMail then
    self.channelContent:SetShow(false)
    self.mailListContent:SetShow(false)
    self.mailDetailContent:SetShow(true)
    self.mailDetailContent:RefreshContent()
  end
  self:RefreshAssistanceBtn()
end

function UILWMailMainView:HideMusterSolo()
  self.mailDetailContent:HideMusterSolo()
end

function UILWMailMainView:OnNoMailClick()
  local current_view = self.ctrl:GetCurrentView()
  if current_view == MailContentType.MailList then
    local current_tab = self.ctrl:GetCurrentTab()
    DataCenter.MailDataManager:ReqMore(current_tab, function()
      EventManager:GetInstance():Broadcast(EventId.Mail_DeleteBatchMailDone)
      EventManager:GetInstance():Broadcast(EventId.MailPush)
    end)
  end
end

function UILWMailMainView:OnAllReadClick()
  local current_view = self.ctrl:GetCurrentView()
  local current_tab = self.ctrl:GetCurrentTab()
  local all_read = false
  if current_view == MailContentType.ChannelList then
    all_read = true
  elseif current_view == MailContentType.MailList then
    all_read = true
  end
  if all_read then
    DataCenter.MailDataManager:SetAllAndOne(true)
  end
  self.mailListContent:InitFilterParams()
  self.ctrl:ReadMailByGroup()
  if not self.hasReward then
    UIUtil.ShowTipsId(312080)
  end
end

function UILWMailMainView:OnAllDeleteClick()
  local isSearchingType = false
  if self.mailListContent.filterType ~= MailFilterType.None and self.mailListContent.filterParam then
    if not string.IsNullOrEmpty(self.mailListContent.filterParam.keywords) then
      isSearchingType = true
    elseif self.mailListContent.curTab ~= MailInternalGroup.MAIL_IN_favor and #self.mailListContent.mailFilter.list > 0 and #self.mailListContent.filterParam.mailTypes ~= #self.mailListContent.mailFilter.list[1] then
      isSearchingType = true
    end
  end
  if isSearchingType then
    local needDelUids = {}
    local mailList = self.mailListContent:GetMailShowList()
    for _, v in pairs(mailList) do
      if v.status == 1 and v.rewardStatus == 1 then
        table.insert(needDelUids, v.uid)
      end
    end
    UIUtil.ShowMessage(Localization:GetString("311040"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      self.mailListContent:InitFilterParams()
      if 0 < #needDelUids then
        DataCenter.MailDataManager:DeleteMailList(needDelUids)
      end
    end, function()
    end)
  else
    UIUtil.ShowMessage(Localization:GetString("311040"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      self.mailListContent:InitFilterParams()
      self.ctrl:DeleteMailByGroup()
    end, function()
    end)
  end
end

function UILWMailMainView:OnCollectClick()
  local mailData = self.ctrl:GetCurrentMailData()
  if mailData == nil then
    return
  end
  if mailData.saveFlag == nil or mailData.saveFlag == 0 then
    self.ctrl:CollectCurrentMail()
  else
    self.ctrl:CancelFavor(mailData.uid)
  end
end

function UILWMailMainView:OnShareBtnClick()
  if CoppaUtil.IsCoppaLimitWithTips() then
    return
  end
  local mailData = self.ctrl:GetCurrentMailData()
  if mailData == nil then
    return
  end
  local shareParam = {}
  shareParam.post = PostType.Text_FightReport
  shareParam.param = {}
  shareParam.param.reportUid = mailData.uid
  shareParam.param.reportLang = ChatManager2:GetInstance().Translate:GetLangString(ChatInterface.getLanguageName())
  shareParam.param.mailType = mailData.type
  shareParam.param.toUser = mailData.toUser
  if mailData.type == MailType.TRUCK_BATTLE_REPORT then
    local extData = mailData:GetMailExt()
    shareParam.param.train_quality = extData.trainData.train_quality
  elseif IsMailScoutType(mailData.type) or mailData.type == MailType.LW_SEASON_SCOUT_MAIL then
    shareParam.post = PostType.Text_ScoutReport
    local ext = mailData:GetMailExt():GetExtData()
    if ext and MailBattleParseHelper.IsWerewolf(ext.targetUser) then
      shareParam.param.wolfEndTime = ext.targetUser.wolfEndTime
    end
  elseif mailData.type == MailType.LANDMINE then
    shareParam.post = PostType.Landmine
    local data = mailData:GetMailExt()
    if data then
      local meta = DataCenter.WorldTriggerTemplateManager:GetMeta(data.cfgId)
      local isPassive = data:IsPassive()
      local name = isPassive and data.hunter.name or data.prey.name
      local langKey = isPassive and "season_mastery_s2_UI_7_report" or "season_mastery_s2_UI_6_report"
      shareParam.param.customizeDesc = Localization:GetString(langKey, name, meta:GetName())
    end
  elseif mailData.type == MailType.DISGUISE_ATTACK then
    shareParam.post = PostType.Disguise
  elseif mailData.type == MailType.SEASON_BANK then
    shareParam.post = PostType.SeasonBankReport
    local data = mailData:GetMailExt()
    data = data and data.bankReport
    if data then
      local param = {}
      param.reportUid = mailData.uid
      param.reportLang = ChatManager2:GetInstance().Translate:GetLangString(ChatInterface.getLanguageName())
      param.mailType = mailData.type
      param.toUser = mailData.toUser
      param.param = data
      shareParam.param = param
      shareParam.uid = mailData.uid
    end
  else
    if mailData.type == MailType.NEW_FIGHT and __fromTag and __fromTag == "ConvertBattleReportToVirtualMail" then
      shareParam.post = PostType.NewBattleReportShare
      local extData = mailData:GetMailExt()
      if extData then
        shareParam.param.ossAddress = extData:GetBattleDownloadAddress()
      else
        shareParam.param.ossAddress = ""
      end
    end
    local data = mailData:GetMailExt()
    if data then
      local resultState = data:GetBattleResultStatus()
      shareParam.param.resultState = resultState
      shareParam.param.targetName = data:GetTargetName_ForShare()
      local targetPlayer = data:GetTargetPlayer()
      if MailBattleParseHelper.IsWerewolf(targetPlayer) then
        shareParam.param.wolfEndTime = targetPlayer.wolfEndTime
      end
    end
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, shareParam)
end

function UILWMailMainView:OnDeleteClick()
  local mailData = self.ctrl:GetCurrentMailData()
  if mailData == nil then
    return
  end
  if mailData.rewardStatus == 0 then
    return
  end
  UIUtil.ShowMessage(Localization:GetString("310020"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    self.ctrl:DeleteCurrentMail()
  end, function()
  end)
end

function UILWMailMainView:OnReceiveClick()
  DataCenter.MailDataManager:SetAllAndOne(false)
  self.ctrl:ReceiveCurrentMail()
  EventManager:GetInstance():Broadcast(EventId.OnClickReceiveOneMailReward)
end

function UILWMailMainView:OnMailDeleteDone(uid)
  self.ctrl:SetCurrentView(2)
  self.ctrl:SetCurrentMail(nil)
  self.mailListContent:OnMailDeleteDone(uid)
  self:ContentTrans()
end

function UILWMailMainView:OnMailMoveToTab(tab)
  self.ctrl:SetCurrentView(2)
  self.ctrl:SetCurrentTab(tab)
  self:ContentTrans()
end

function UILWMailMainView:OnRmAllClick()
  UIUtil.ShowMessage(Localization:GetString("455093"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    self.ctrl:KickAllInactiveMembers()
  end, function()
  end)
end

function UILWMailMainView:NeedAskForPushPermission(prefKey)
  if not self._needAskForPushPermissionKeys then
    self._needAskForPushPermissionKeys = {}
  end
  if self._needAskForPushPermissionKeys[prefKey] then
    return
  end
  if CS.GameEntry.Sdk:GetIsNotifyOpen() then
    return
  end
  local lastAskTime = CommonUtil.PlayerPrefsGetLong(prefKey, 0)
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local gapTime = serverTime - lastAskTime
  if gapTime < 86400000 then
    return
  end
  self._needAskForPushPermissionKeys[prefKey] = true
end

function UILWMailMainView:AskForPushPermission()
  if not self._needAskForPushPermissionKeys then
    return
  end
  local needAsk = false
  for prefKey, isTrue in pairs(self._needAskForPushPermissionKeys) do
    if isTrue then
      CommonUtil.PlayerPrefsSetLong(prefKey, UITimeManager:GetInstance():GetServerTime())
      needAsk = true
    end
  end
  self._needAskForPushPermissionKeys = nil
  if needAsk then
    UIUtil.ShowMessage(Localization:GetString("2900008"), 2, "2900009", "110106", function()
      CS.GameEntry.Sdk:AskForNotifyPermission()
    end)
  end
end

function UILWMailMainView:OnClickRechargeAssistance()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIRefundFaq)
  PostEventLog.Track(PostEventLog.Defines.OpenRefundFAQView)
end

function UILWMailMainView:RefreshAssistanceBtn()
  local tab = self.ctrl:GetCurrentTab()
  local showRechargeBtn = tab == MailInternalGroup.MAIL_IN_charge
  local switchOn = LuaEntry.DataConfig:CheckSwitch("refund_client1")
  local condition = switchOn and LuaEntry.Player.payDollerTotal and LuaEntry.Player.payDollerTotal > 0
  self.rechargeAssistanceBtn:SetActive(showRechargeBtn and condition)
  self.rechargeAssistanceBtnText:SetLocalText("refund_interface_button_help")
end

return UILWMailMainView
