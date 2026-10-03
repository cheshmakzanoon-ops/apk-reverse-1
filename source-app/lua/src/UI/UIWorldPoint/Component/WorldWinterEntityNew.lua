local WorldWinterEntityNew = BaseClass("WorldWinterEntityNew", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.ActWinterStormManager
local lua_path_assistance = "UI.UIWorldPoint.Component.UIWorldPointNewOtherPlayerInfoAssistanceComp"
local info_path = "info"
local icon_path = "info/icon"
local msg_group_path = "info/msgGroup"
local text_speed_path = "info/msgGroup/SpeedNum"
local btn_speed_path = "info/msgGroup/SpeedBtn"
local text_cur_path = "info/msgGroup/CurNum"
local btn_cur_path = "info/msgGroup/CurBtn"
local protect_path = "info/protect"
local txt_path = "info/protect/txt"
local protect_tip_path = "info/protect/ProtectTip"
local protect_time_path = "info/protect/ProtectTime"
local info2_path = "info2"
local text_info_path = "info2/textInfo"
local assistance_root_path = "assistanceRoot"

function WorldWinterEntityNew:OnCreate()
  base.OnCreate(self)
  self.unsafe_percent = LuaEntry.DataConfig:TryGetNum("winter_battlefield", "k20", 40) / 100
  self.infoRoot = self:AddComponent(UIImage, info_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.msg_group = self:AddComponent(UIBaseComponent, msg_group_path)
  self.text_speed = self:AddComponent(UIText, text_speed_path)
  self.btn_speed = self:AddComponent(UIButton, btn_speed_path)
  self.btn_speed:SetOnClick(function()
    local speed = self.template ~= nil and self.template.point_produce_per_second or 0
    local sOver = math.ceil(speed * (1 - self.unsafe_percent))
    local sSafe = speed - sOver
    local strTip = Localization:GetString("winter_battlefield_interface_tips1078", sSafe, sOver)
    UIUtil.ShowBubbleTips(strTip, self.btn_speed.transform.position, 0, -30, 0)
  end)
  self.text_cur = self:AddComponent(UIText, text_cur_path)
  self.btn_cur = self:AddComponent(UIButton, btn_cur_path)
  self.btn_cur:SetOnClick(function()
    local score = ActMgr:GetBuildScore(self.data.uuid)
    local sSafe = math.ceil(score / self.unsafe_percent) - score
    local strTip = Localization:GetString("winter_battlefield_interface_tips1079", sSafe, score)
    UIUtil.ShowBubbleTips(strTip, self.btn_cur.transform.position, 0, -30, 0)
  end)
  self.protect = self:AddComponent(UIBaseComponent, protect_path)
  self.protect_tip = self:AddComponent(UIText, protect_tip_path)
  self.protect_time = self:AddComponent(UIText, protect_time_path)
  self.text_info = self:AddComponent(UITextMeshProUGUIEx, text_info_path)
  self.info2 = self:AddComponent(UIBaseComponent, info2_path)
  self.infoText = self:AddComponent(UIText, txt_path)
  if WorldBattleUtil.EnableShowWorldAssistanceInfo() then
    self.dCompAssistance = UIAsyncLoaderBridge.New(self, "dCompAssistance", self.transform:Find(assistance_root_path), UIAssets.UIWorldPointComp_PlayerAssistanceComp, lua_path_assistance, true)
  end
end

function WorldWinterEntityNew:OnDestroy()
  if self.dCompAssistance then
    self.dCompAssistance:Delete()
    self.dCompAssistance = nil
  end
  base.OnDestroy(self)
end

function WorldWinterEntityNew:OpenCheck()
  if self.curState == WinterEntityState.Fixing then
    UIUtil.ShowTipsId(458279)
    return false
  end
  return ActMgr:BattleOpenCheck(true)
end

function WorldWinterEntityNew:RefreshData(pointData)
  self.data = pointData
  local template = pointData.template
  self.template = template
  if template ~= nil then
    self.icon:LoadSprite(template:GetDetailPath())
    self.icon:SetAspectSize(100)
    local bBuild = template:IsBuild()
    self.msg_group:SetActive(bBuild)
    self.protect:SetActive(not bBuild)
    self.info2:SetActive(bBuild)
  end
  self.curState = pointData.state or 0
  self:UpdateByState()
end

function WorldWinterEntityNew:UpdateByState()
  local pointData = self.data
  local template = self.template
  local state = self.curState
  local bBuild = template and template:IsBuild()
  local curSide = pointData.side
  local speed = template and template.point_produce_per_second or 0
  self.text_speed:SetText(speed .. "/s")
  self.text_cur:SetText(0)
  self.endTime = 0
  if state == WinterEntityState.Normal then
    if bBuild then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if curTime < pointData.openTime then
        self.text_info:SetLocalText(458279)
      else
        self.text_info:SetLocalText(458224)
      end
    else
      self.infoText:SetActive(true)
      self.protect_tip:SetActive(false)
      self.protect_time:SetActive(false)
    end
  elseif state == WinterEntityState.Occupied then
    if bBuild then
      local str = Localization:GetString("winter_battlefield_interface_tips1062")
      local info = ActMgr:GetBuildBestMarch(pointData.uuid)
      local ownerUid = info ~= nil and info.uid or nil
      local teamArr = ActMgr:GetTeamArr(ownerUid)
      if teamArr ~= nil then
        local mySide = ActMgr:GetMySide()
        local colorStr = curSide == mySide and "249bc5" or "EE6241"
        str = string.format("%s: <color=#%s>%s</color>", str, colorStr, UIUtil.FormatServerAllianceName(teamArr.server, teamArr.allianceName, teamArr.name, teamArr.uid))
      end
      self.text_info:SetText(str)
    else
      self.infoText:SetActive(false)
      self.protect_tip:SetLocalText("456507")
      self.protect_tip:SetActive(true)
      if pointData.closeTime ~= nil and 0 < pointData.closeTime then
        self.endTime = pointData.closeTime
        self.protect_time:SetActive(true)
      end
    end
  elseif pointData.state == WinterEntityState.Occupying and not bBuild then
    self.infoText:SetActive(false)
    local opTime = template.occupy_time
    self.endTime = pointData.occupyingStartTime + opTime
    self.protect_time:SetActive(true)
    self.protect_tip:SetLocalText("winter_battlefield_interface_tips1061")
    self.protect_tip:SetActive(true)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
  self:Update1000MS()
end

function WorldWinterEntityNew:UpdateDetailInfo(detail)
  if not self.rectTransform then
    return
  end
  if not detail then
    return
  end
  self:RefreshAssistance(detail.playerData)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

function WorldWinterEntityNew:Update1000MS()
  if self.data == nil or self.template == nil then
    return
  end
  local bBuild = self.template:IsBuild()
  if bBuild then
    if self.curState == WinterEntityState.Occupied then
      local score = ActMgr:GetBuildScore(self.data.uuid)
      local total = math.ceil(score / self.unsafe_percent)
      self.text_cur:SetText(total)
    end
  elseif self.endTime > 0 then
    local curSec = UITimeManager:GetInstance():GetServerSeconds()
    local remainTime = self.endTime - curSec
    if 0 < remainTime then
      self.protect_time:SetText(UITimeManager:GetInstance():SecondToFmtStringWithoutHour(remainTime))
    elseif self.curState == WinterEntityState.Fixing then
      self.curState = WinterEntityState.Normal
      self:UpdateByState()
    elseif self.curState == WinterEntityState.Occupying then
      self.curState = WinterEntityState.Occupied
      self:UpdateByState()
    elseif self.curState == WinterEntityState.Waiting then
      self.curState = WinterEntityState.Death
      self:UpdateByState()
    end
  end
end

function WorldWinterEntityNew:RefreshAssistance(info)
  if not self.dCompAssistance then
    return
  end
  if not (info and info.assistanceList) or #info.assistanceList <= 0 then
    self.dCompAssistance:SetActive(false)
  else
    self.dCompAssistance:SetActive(true)
    self.dCompAssistance:Setup({
      isCity = true,
      pointId = self.data.pointId,
      cityId = info.cityId,
      assistanceList = info.assistanceList,
      maxMember = info.maxAssistance,
      memberCount = info.currAssistance,
      totalPower = info.assistanceTotalPower,
      limit = 10
    })
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
  end
end

return WorldWinterEntityNew
