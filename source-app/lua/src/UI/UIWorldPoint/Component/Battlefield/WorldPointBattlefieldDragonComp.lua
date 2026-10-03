local base = UIAsyncContainer
local WorldPointBattlefieldDragonComp = BaseClass("WorldPointBattlefieldDragonComp", base)
local Localization = CS.GameEntry.Localization
local COLOR_GREEN = Color.New(0.03529411764705882, 0.6078431372549019, 0.2901960784313726, 1)
local COLOR_BLACK = Color.New(0.16470588235294117, 0.1568627450980392, 0.18823529411764706, 1)
local lua_path_assistance = "UI.UIWorldPoint.Component.UIWorldPointNewOtherPlayerInfoAssistanceComp"

function WorldPointBattlefieldDragonComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function WorldPointBattlefieldDragonComp:OnDestroy()
  self.buildInfo = nil
  self.serverData = nil
  self.bTemplate = nil
  self.pointData = nil
  if self.dCompAssistance then
    self.dCompAssistance:Delete()
    self.dCompAssistance = nil
  end
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function WorldPointBattlefieldDragonComp:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textProtectTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compResItem = self.viewSkin:AddComponent(self, UICommonResItem, 4)
  self.compMsgGroup = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.textSpeedTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textSpeedNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnSpeed = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnSpeed:SetOnClick(function()
    self:OnBtnSpeedClick()
  end)
  self.textCurTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textCurNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.btnCur = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnCur:SetOnClick(function()
    self:OnBtnCurClick()
  end)
  self.compInfo2 = self.viewSkin:AddComponent(self, UIBaseContainer, 12)
  self.imgFlag = self.viewSkin:AddComponent(self, UIImage, 13)
  self.textInfo = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.textPlayer = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.compAssistanceRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 16)
  self.textTipsLabel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 17)
  self.compInfoBuff = self.viewSkin:AddComponent(self, UIBaseContainer, 18)
  self.imgBuffIcon = self.viewSkin:AddComponent(self, UIImage, 19)
  self.textBuffDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 20)
  self.compInfoTime = self.viewSkin:AddComponent(self, UIBaseComponent, 21)
  self.textTimeDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 22)
  self.btnTime = self.viewSkin:AddComponent(self, UIButton, 23)
  self.btnTime:SetOnClick(function()
    self:OnBtnTimeClick()
  end)
  if WorldBattleUtil.EnableShowWorldAssistanceInfo() then
    self.dCompAssistance = UIAsyncLoaderBridge.New(self, "dCompAssistance", self.transform:Find("assistanceRoot"), UIAssets.UIWorldPointComp_PlayerAssistanceComp, lua_path_assistance)
  end
end

function WorldPointBattlefieldDragonComp:ComponentDestroy()
  self.viewSkin = nil
  self.textDesc = nil
  self.imgIcon = nil
  self.textProtectTip = nil
  self.compResItem = nil
  self.compMsgGroup = nil
  self.textSpeedTip = nil
  self.textSpeedNum = nil
  self.btnSpeed = nil
  self.textCurTip = nil
  self.textCurNum = nil
  self.btnCur = nil
  self.compInfo2 = nil
  self.imgFlag = nil
  self.textInfo = nil
  self.textPlayer = nil
  self.compAssistanceRoot = nil
  self.textTipsLabel = nil
  self.compInfoBuff = nil
  self.imgBuffIcon = nil
  self.textBuffDesc = nil
  self.compInfoTime = nil
  self.textTimeDesc = nil
  self.btnTime = nil
end

function WorldPointBattlefieldDragonComp:DataDefine()
end

function WorldPointBattlefieldDragonComp:DataDestroy()
end

function WorldPointBattlefieldDragonComp:OnAddListener()
  base.OnAddListener(self)
end

function WorldPointBattlefieldDragonComp:OnRemoveListener()
  base.OnRemoveListener(self)
end

function WorldPointBattlefieldDragonComp:GetEffUp(detailInfo)
  local nowAId = detailInfo ~= nil and detailInfo.AllianceId or nil
  return DataCenter.ActDragonManager:GetBuildUpEffInfo(nowAId)
end

function WorldPointBattlefieldDragonComp:UpdateCurNum()
  local info = self.buildInfo ~= nil and CS.SceneManager.World:GetPointInfo(self.buildInfo.pointId) or nil
  local detailInfo = info ~= nil and info.detail or nil
  local score = detailInfo ~= nil and detailInfo.Score or 0
  local overflowScore = detailInfo ~= nil and detailInfo.OverflowScore or 0
  if score == 0 then
    self.textCurNum:SetText(0)
  elseif overflowScore == 0 then
    self.textCurNum:SetText(score)
  else
    local safe = score - overflowScore
    self.textCurNum:SetText(safe .. "+" .. overflowScore)
  end
  local speed = self.bTemplate ~= nil and self.bTemplate.point_produce_per_second or 0
  local bUp, effNum = self:GetEffUp(detailInfo)
  if bUp then
    speed = math.floor(speed * (1 + effNum / 10000))
  end
  if 0 < overflowScore then
    local sPer = self.bTemplate ~= nil and self.bTemplate.safe_percent or 1
    local sOver = math.ceil(speed * (1 - sPer))
    local sSafe = speed - sOver
    self.textSpeedNum:SetText(sSafe .. "+" .. sOver .. "/s")
  else
    self.textSpeedNum:SetText(speed .. "/s")
  end
  self.textSpeedNum:SetColor(bUp and COLOR_GREEN or COLOR_BLACK)
end

function WorldPointBattlefieldDragonComp:GetBuildMarch()
  return DataCenter.BattlefieldDsbDuelManager:GetBuildBestMarch(self.pointData.uuid)
end

function WorldPointBattlefieldDragonComp:GetDetail()
  if not self.buildInfo then
    return
  end
  local info = self.buildInfo ~= nil and CS.SceneManager.World:GetPointInfo(self.buildInfo.pointId) or nil
  local detailInfo = info ~= nil and info.detail or nil
  return detailInfo
end

function WorldPointBattlefieldDragonComp:IsTeammate()
  local detail = self:GetDetail()
  if not detail then
    return false
  end
  local role = detail.Role
  local myRole = BattlefieldDsbDuelUtils.GetMyRoleId()
  return role == myRole
end

function WorldPointBattlefieldDragonComp:GetAlliance()
  local detail = self:GetDetail()
  if not detail then
    return nil
  end
  return BattlefieldDsbDuelUtils.GetRole(detail.Role)
end

function WorldPointBattlefieldDragonComp:Refresh(buildInfo, serverData)
  if not buildInfo or not serverData then
    return
  end
  local templateMgr = BattleFieldUtil.GetTemplateMgrActive()
  self.buildInfo = buildInfo
  self.serverData = serverData
  self.pointData = buildInfo.pointData
  local detail = self.pointData.detail
  local buildId = buildInfo.buildId
  self.bTemplate = templateMgr:GetBuildTemplate(buildId)
  if not self.bTemplate then
    return
  end
  self.textDesc:SetLocalText(self.bTemplate.des)
  self.imgIcon:LoadSpriteAsync(self.bTemplate:GetIconPath(detail and detail.Role))
  self.imgIcon:SetAspectSize(120)
  self.textTipsLabel:SetActive(false)
  if self.bTemplate:IsScoreBox() then
    self.compInfo2:SetActive(false)
    self.compMsgGroup:SetActive(false)
    self.textProtectTip:SetActive(true)
    self.textProtectTip:SetLocalText(self.bTemplate.name)
    self.compResItem:SetActive(true)
    self.compInfoBuff:SetActive(false)
    self.compInfoTime:SetActive(false)
    self.compResItem:ReInit({
      count = self.pointData.score,
      rewardType = RewardType.RESOURCE_ITEM,
      itemId = self.pointData.resId
    })
  else
    self.compMsgGroup:SetActive(true)
    self.textProtectTip:SetActive(false)
    self.compResItem:SetActive(false)
    self.compInfo2:SetActive(true)
    self:UpdateCurNum()
    local isLocked = false
    self.curState = self.pointData.state or BattlefieldBuildState.Normal
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    if self.curState == BattlefieldBuildState.Normal then
      self.imgFlag:SetActive(false)
      if curTime < self.pointData.openTime then
        isLocked = true
        self.endTime = self.pointData.openTime
        self:RefreshTime()
      end
      if isLocked then
        self.textInfo:SetActive(true)
        self.textPlayer:SetActive(false)
        self.imgFlag:SetActive(false)
        self.textTipsLabel:SetActive(true)
        self.textTipsLabel:SetLocalText(458279)
      else
        self.textPlayer:SetActive(false)
        self.textTipsLabel:SetActive(false)
        self.textInfo:SetActive(true)
        self.textInfo:SetLocalText(458224)
      end
    else
      self.textInfo:SetActive(false)
      self.textPlayer:SetActive(true)
      self.textInfo:SetLocalText(458193)
      local ownerAlliance = self:GetAlliance()
      local str = Localization:GetString(self.curState == BattlefieldBuildState.Occupied and "dsb_duel_tips_1023" or 458223)
      if ownerAlliance then
        local bestMarch = self:GetBuildMarch()
        if bestMarch then
          local colorStr = self:IsTeammate() and "249bc5" or "EE6241"
          str = string.format("%s: <color=#%s>%s</color>", str, colorStr, UIUtil.FormatAllianceAndName(ownerAlliance.allianceAbbr, bestMarch.ownerName, bestMarch.ownerUid))
        else
          local colorStr = self:IsTeammate() and "249bc5" or "EE6241"
          str = string.format("%s: <color=#%s>%s</color>", str, colorStr, BattleFieldUtil.ConvertAllianceName(nil, ownerAlliance.allianceAbbr, nil))
        end
      end
      self.textPlayer:SetText(str)
      local alIcon = ownerAlliance and ownerAlliance.allianceIcon
      if not string.IsNullOrEmpty(alIcon) then
        self.imgFlag:SetActive(true)
        self.imgFlag:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, alIcon))
        self.imgFlag:SetNativeSize()
      else
        self.imgFlag:SetActive(false)
      end
      self.compInfo2:SetActive(true)
    end
    self.showBuff = false
    if self.bTemplate:IsBuff() and self.pointData.buffId and self.pointData.buffId ~= 0 then
      local buffTemplate = templateMgr:GetBuffTemplate(self.pointData.buffId)
      if buffTemplate then
        self.compInfoBuff:SetActive(true)
        self.compInfoTime:SetActive(true)
        self.imgBuffIcon:LoadSprite(buffTemplate.icon)
        if buffTemplate.getDesc then
          self.textBuffDesc:SetText(buffTemplate:getDesc())
        else
          self.textBuffDesc:SetLocalText(buffTemplate.desc)
        end
        self.buffEndTime = detail.BuffEndTime or 0
        self.showBuff = true
      else
        self.compInfoBuff:SetActive(false)
        self.compInfoTime:SetActive(false)
      end
    else
      self.compInfoBuff:SetActive(false)
      self.compInfoTime:SetActive(false)
    end
  end
  self:RefreshTopBg()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

function WorldPointBattlefieldDragonComp:OnBtnSpeedClick()
  local info = self.buildInfo ~= nil and CS.SceneManager.World:GetPointInfo(self.buildInfo.pointId) or nil
  local detailInfo = info ~= nil and info.detail or nil
  local overflowScore = detailInfo ~= nil and detailInfo.OverflowScore or 0
  local speed = self.bTemplate ~= nil and self.bTemplate.point_produce_per_second or 0
  local bUp, effNum = self:GetEffUp(detailInfo)
  if bUp then
    speed = math.floor(speed * (1 + effNum / 10000))
  end
  local sSafe, sOver
  if 0 < overflowScore then
    local sPer = self.bTemplate ~= nil and self.bTemplate.safe_percent or 1
    sOver = math.ceil(speed * (1 - sPer))
    sSafe = speed - sOver
  else
    sSafe = speed
    sOver = 0
  end
  local time = self.bTemplate ~= nil and self.bTemplate.safe_point_duration or 0
  local strTip = Localization:GetString("Desert_strom_tips1060", time, sSafe, sOver)
  UIUtil.ShowBubbleTips(strTip, self.btnSpeed.transform.position, 0, -30, 0)
end

function WorldPointBattlefieldDragonComp:OnBtnCurClick()
  local time = self.bTemplate ~= nil and self.bTemplate.safe_point_duration or 0
  local info = self.buildInfo ~= nil and CS.SceneManager.World:GetPointInfo(self.buildInfo.pointId) or nil
  local detailInfo = info ~= nil and info.detail or nil
  local score = detailInfo ~= nil and detailInfo.Score or 0
  local overflowScore = detailInfo ~= nil and detailInfo.OverflowScore or 0
  local strTip = Localization:GetString("Desert_strom_tips1061", time, score - overflowScore, overflowScore)
  UIUtil.ShowBubbleTips(strTip, self.btnCur.transform.position, 0, -30, 0)
end

function WorldPointBattlefieldDragonComp:RefreshTopBg()
  if not self.view or not self.buildInfo then
    return
  end
  local info = self.buildInfo ~= nil and CS.SceneManager.World:GetPointInfo(self.buildInfo.pointId) or nil
  local detailInfo = info ~= nil and info.detail or nil
  local role = detailInfo and detailInfo.Role
  if role then
    local color = BattlefieldDsbDuelUtils.GetColorByRoleType(role, true)
    if not color or not color.spPlayerTopBg then
      self.view:SetTopBg()
    else
      self.view:SetTopBg(string.format(LoadPath.LWBattleFieldDsbDuelWorldPath, color.spPlayerTopBg))
    end
  else
    self.view:SetTopBg()
  end
end

function WorldPointBattlefieldDragonComp:Update1000MS()
  if not self.curState then
    return
  end
  if self.curState == BattlefieldBuildState.Normal then
    self:RefreshTime()
  elseif self.curState == BattlefieldBuildState.Occupied and self.bTemplate and not self.bTemplate:IsScoreBox() then
    self:UpdateCurNum()
  end
  if self.showBuff then
    local curSec = UITimeManager:GetInstance():GetServerSeconds()
    local remainTime = math.max(self.buffEndTime - curSec, 0)
    local key = "dsb_duel_tips_1031"
    self.textTimeDesc:SetText(string.format([[
<size=24>%s</size>
%s]], Localization:GetString(key), UITimeManager:GetInstance():SecondToFmtString(remainTime)))
    if remainTime <= 0 then
      self.compInfoTime:SetActive(false)
    end
  end
end

function WorldPointBattlefieldDragonComp:RefreshTime()
  if not self.endTime then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local remainTime = self.endTime - curTime
  if 0 < remainTime then
    self.textInfo:SetText(Localization:GetString(456511) .. " " .. UITimeManager:GetInstance():MilliSecondToFmtString(remainTime * 1000))
  else
    self.curState = BattlefieldBuildState.Normal
    self.textTipsLabel:SetActive(false)
    self.textInfo:SetLocalText(458224)
    self.endTime = nil
  end
end

function WorldPointBattlefieldDragonComp:RefreshAssistance(info)
  if not self.dCompAssistance then
    return
  end
  if not (info and info.assistanceList) or #info.assistanceList <= 0 then
    self.dCompAssistance:SetActive(false)
  else
    self.dCompAssistance:SetActive(true)
    self.dCompAssistance:Setup({
      isCity = true,
      pointId = self.buildInfo.pointId,
      cityId = info.cityId,
      assistanceList = info.assistanceList,
      maxMember = info.maxAssistance,
      memberCount = info.currAssistance,
      totalPower = info.assistanceTotalPower,
      limit = 10
    })
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
  self:ReAutoFitUI()
end

function WorldPointBattlefieldDragonComp:RefreshDetail(detail)
  if not self.rectTransform then
    return
  end
  if not detail then
    return
  end
  self:RefreshAssistance(detail)
end

function WorldPointBattlefieldDragonComp:OnBtnTimeClick()
  UIUtil.ShowBubbleTipsAuto(Localization:GetString("dsb_duel_tips_1032"), self.btnTime.transform.position, 0, -35, 0)
end

function WorldPointBattlefieldDragonComp:ReAutoFitUI()
  if self.view and self.view.ReAutoFitUI then
    self.view:ReAutoFitUI()
  end
end

return WorldPointBattlefieldDragonComp
