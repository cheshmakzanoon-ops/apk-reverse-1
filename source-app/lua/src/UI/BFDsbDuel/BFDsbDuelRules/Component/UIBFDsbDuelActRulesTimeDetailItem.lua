local base = UIBaseContainer
local UIBFDsbDuelActRulesTimeDetailItem = BaseClass("UIBFDsbDuelActRulesTimeDetailItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIBFDsbDuelActRulesTimeDetailItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActRulesTimeDetailItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActRulesTimeDetailItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgIndexBg = self.viewSkin:AddComponent(self, UIImage, 4)
  self.textIndexTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compBtnContent = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.btnBtn3 = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnBtn2 = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnBtn1 = self.viewSkin:AddComponent(self, UIButton, 9)
  self.textBtnTxt1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textBtnTxt3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.textBtnTxt2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 13)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.btnIndexBg = self.viewSkin:AddComponent(self, UIButton, 15)
  self.btnIndexBg:SetOnClick(function()
    self:OnBtnIndexBgClick()
  end)
  self.btnBtn1:SetOnClick(function()
    self:OnBtnClick(1)
  end)
  self.btnBtn2:SetOnClick(function()
    self:OnBtnClick(2)
  end)
  self.btnBtn3:SetOnClick(function()
    self:OnBtnClick(3)
  end)
end

function UIBFDsbDuelActRulesTimeDetailItem:ComponentDestroy()
  self.viewSkin = nil
  self.textTime = nil
  self.btnInfo = nil
  self.textDesc = nil
  self.imgIndexBg = nil
  self.textIndexTxt = nil
  self.compBtnContent = nil
  self.btnBtn3 = nil
  self.btnBtn2 = nil
  self.btnBtn1 = nil
  self.textBtnTxt1 = nil
  self.textBtnTxt3 = nil
  self.textBtnTxt2 = nil
  self.imgBg = nil
  self.textTitle = nil
  self.btnIndexBg = nil
end

function UIBFDsbDuelActRulesTimeDetailItem:DataDefine()
end

function UIBFDsbDuelActRulesTimeDetailItem:DataDestroy()
end

function UIBFDsbDuelActRulesTimeDetailItem:OnAddListener()
  base.OnAddListener(self)
end

function UIBFDsbDuelActRulesTimeDetailItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActRulesTimeDetailItem:OnBtnInfoClick()
end

function UIBFDsbDuelActRulesTimeDetailItem:OnBtnClick(index)
  if index then
    if self.guideData.buttonsJumpTypeList[index] and tonumber(self.guideData.buttonsJumpTypeList[index]) ~= -1 then
      local jumpIndex = tonumber(self.guideData.buttonsJumpTypeList[index])
      if 1 <= jumpIndex and jumpIndex <= 4 then
        EventManager:GetInstance():Broadcast(EventId.DSBDuelChangeRulesViewTab, jumpIndex)
      elseif 11 <= jumpIndex and jumpIndex <= 13 then
        if jumpIndex == 11 then
          UIUtil.ShowTipsId("dsb_duel_tips_1012")
        elseif jumpIndex == 12 then
          UIUtil.ShowTipsId("dsb_duel_tips_1013")
        end
        UIManager.Instance:DestroyWindow(UIWindowNames.UIBFDsbDuelActRules)
        EventManager:GetInstance():Broadcast(EventId.DsbDuelActBattleMainToggleChange, jumpIndex - 10)
      end
    elseif self.guideData.buttonsDetailList[index] then
      local param = {}
      param.type = "desc"
      param.title = ""
      param.desc = self.guideData.buttonsDetailList[index]
      param.alignObject = self["btnBtn" .. index]
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
    end
  end
end

function UIBFDsbDuelActRulesTimeDetailItem:OnBtnIndexBgClick()
  EventManager:GetInstance():Broadcast(EventId.DSBDuelChangeRulesViewTab, self.guideData.sub_type - BattlefieldDsbConst.BF_DSB_GUIDE_TYPE1_SUBTYPE.SignUp + 1)
end

function UIBFDsbDuelActRulesTimeDetailItem:SetData(guideData, curIndex)
  self.guideData = guideData
  self.curIndex = curIndex
  self.textIndexTxt:SetText(guideData.sequence)
  if curIndex < guideData.sequence then
    self.imgIndexBg:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldDsbDuelPath, "zxl_shamo_jindu_hui.png"))
    self.imgBg:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldDsbDuelPath, "zxl_shamo_biaoti_hui.png"))
  else
    self.imgIndexBg:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldDsbDuelPath, "lyt_2024shengdanjie_dafuweng_jinduyuandi.png"))
    self.imgBg:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldDsbDuelPath, "zxl_shamo_biaoti_huang.png"))
  end
  local schedule = BattlefieldDsbDuelUtils.ActInfo:GetSchedule()
  self.textDesc:SetActive(not string.IsNullOrEmpty(guideData.desc))
  if not string.IsNullOrEmpty(guideData.desc) then
    local curBattleWeek = guideData.sequence - BattlefieldDsbDuelUtils.ActTemplateInfo:GetFirstBattleWeekGuideSequence() + 1
    if 1 <= curBattleWeek and curBattleWeek <= 5 then
      local curWeekSchedule = schedule[curBattleWeek]
      if curWeekSchedule then
        self.textDesc:SetLocalText(guideData.desc, guideData.sequence, BattlefieldDsbDuelUtils.GetGroupLetter(curWeekSchedule[1]), BattlefieldDsbDuelUtils.GetGroupLetter(curWeekSchedule[2]), BattlefieldDsbDuelUtils.GetGroupLetter(curWeekSchedule[3]), BattlefieldDsbDuelUtils.GetGroupLetter(curWeekSchedule[4]))
      end
    else
      self.textDesc:SetLocalText(guideData.desc, guideData.sequence)
    end
  end
  local index = guideData.sequence
  local sTime, eTime
  if index == BattlefieldDsbConst.BF_DSB_BIG_PHASE_INDEX.SignUp then
    local signUpSTime, signUpETime = BattlefieldDsbDuelUtils.ActInfo:GetBigPhaseStartEndTimeByPhase(BattlefieldDsbConst.BF_DSB_BIG_PHASE_INDEX.SignUp)
    local groupSTime, groupETime = BattlefieldDsbDuelUtils.ActInfo:GetBigPhaseStartEndTimeByPhase(BattlefieldDsbConst.BF_DSB_BIG_PHASE_INDEX.Group)
    sTime = signUpSTime
    eTime = groupETime
  else
    sTime, eTime = BattlefieldDsbDuelUtils.ActInfo:GetBigPhaseStartEndTimeByPhase(index + 1)
  end
  self.textTime:SetText(self:GetTimeToMD(sTime / 1000) .. "-" .. self:GetTimeToMD(eTime / 1000))
  local buttonsKeyList = guideData.buttonsKeyList
  self.compBtnContent:SetActive(not table.IsNullOrEmpty(buttonsKeyList))
  if not table.IsNullOrEmpty(buttonsKeyList) then
    self.btnBtn1:SetActive(1 <= #buttonsKeyList)
    self.btnBtn2:SetActive(2 <= #buttonsKeyList)
    self.btnBtn3:SetActive(3 <= #buttonsKeyList)
    for i = 1, math.min(3, #buttonsKeyList) do
      self["textBtnTxt" .. i]:SetLocalText(buttonsKeyList[i])
    end
  end
end

function UIBFDsbDuelActRulesTimeDetailItem:GetTimeToMD(second)
  local format = UITimeManager:GetInstance():TimeSecToServerDate(second)
  local format_time = string.format("%0d/%0d", format.month, format.day)
  return format_time
end

return UIBFDsbDuelActRulesTimeDetailItem
