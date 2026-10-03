local WorldEpidemicBuild = BaseClass("WorldEpidemicBuild", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local EBTemplateMgr = DataCenter.EpidemicBuildTemplateMgr
local EBActMgr = DataCenter.ActEpidemicZoneManager
local lua_path_assistance = "UI.UIWorldPoint.Component.UIWorldPointNewOtherPlayerInfoAssistanceComp"
local info_score_path = "infoScore"
local protect_tip_path = "infoScore/ProtectTip"
local res_item_path = "infoScore/ResItem"
local info_speed_path = "infoSpeed"
local speed_num_path = "infoSpeed/SpeedNum"
local speed_btn_path = "infoSpeed/SpeedBtn"
local info_cur_path = "infoCur"
local cur_num_path = "infoCur/CurNum"
local cur_btn_path = "infoCur/CurBtn"
local line1_path = "line1"
local info_buff_path = "infoBuff"
local buff_icon_path = "infoBuff/BuffIcon"
local buff_name_path = "infoBuff/BuffName"
local buff_desc_path = "infoBuff/BuffDesc"
local info_power_path = "infoPower"
local go_btn_path = "infoPower/GoBtn"
local line2_path = "line2"
local info_time_path = "infoTime"
local time_desc_path = "infoTime/TimeDesc"
local time_btn_path = "infoTime/TimeBtn"
local assistance_root_path = "assistanceRoot"
local COLOR_GREEN = Color.New(0.03529411764705882, 0.6078431372549019, 0.2901960784313726, 1)
local COLOR_BLACK = Color.New(0.16470588235294117, 0.1568627450980392, 0.18823529411764706, 1)

function WorldEpidemicBuild:OnCreate()
  base.OnCreate(self)
  self.info_score = self:AddComponent(UIImage, info_score_path)
  self.protect_tip = self:AddComponent(UITextMeshProUGUIEx, protect_tip_path)
  self.res_item = self:AddComponent(UICommonResItem, res_item_path)
  self.info_speed = self:AddComponent(UIImage, info_speed_path)
  self.speed_num = self:AddComponent(UITextMeshProUGUIEx, speed_num_path)
  self.speed_btn = self:AddComponent(UIButton, speed_btn_path)
  self.speed_btn:SetOnClick(function()
    local info = self.data ~= nil and CS.SceneManager.World:GetPointInfo(self.data.pointId) or nil
    local detailInfo = info ~= nil and info.detail or nil
    local overflowScore = detailInfo ~= nil and detailInfo.OverflowScore or 0
    local speed = self.template ~= nil and self.template.point_produce_per_second or 0
    local bUp, effNum = self:GetEffUp(detailInfo)
    if bUp then
      speed = math.floor(speed * (1 + effNum / 10000))
    end
    local sSafe, sOver
    if 0 < overflowScore then
      local sPer = self.template ~= nil and self.template.safe_percent or 1
      sOver = math.ceil(speed * (1 - sPer))
      sSafe = speed - sOver
    else
      sSafe = speed
      sOver = 0
    end
    local time = self.template ~= nil and self.template.safe_point_duration or 0
    local strTip = Localization:GetString("Desert_strom_tips1060", time, sSafe, sOver)
    UIUtil.ShowBubbleTips(strTip, self.speed_btn.transform.position, 0, -30, 0)
  end)
  self.info_cur = self:AddComponent(UIImage, info_cur_path)
  self.cur_num = self:AddComponent(UITextMeshProUGUIEx, cur_num_path)
  self.cur_btn = self:AddComponent(UIButton, cur_btn_path)
  self.cur_btn:SetOnClick(function()
    local time = self.template ~= nil and self.template.safe_point_duration or 0
    local info = self.data ~= nil and CS.SceneManager.World:GetPointInfo(self.data.pointId) or nil
    local detailInfo = info ~= nil and info.detail or nil
    local score = detailInfo ~= nil and detailInfo.Score or 0
    local overflowScore = detailInfo ~= nil and detailInfo.OverflowScore or 0
    local strTip = Localization:GetString("Desert_strom_tips1061", time, score - overflowScore, overflowScore)
    UIUtil.ShowBubbleTips(strTip, self.cur_btn.transform.position, 0, -30, 0)
  end)
  self.line1 = self:AddComponent(UIImage, line1_path)
  self.info_buff = self:AddComponent(UIBaseContainer, info_buff_path)
  self.buff_icon = self:AddComponent(UIImage, buff_icon_path)
  self.buff_name = self:AddComponent(UITextMeshProUGUIEx, buff_name_path)
  self.buff_desc = self:AddComponent(UITextMeshProUGUIEx, buff_desc_path)
  self.line2 = self:AddComponent(UIImage, line2_path)
  self.info_power = self:AddComponent(UIBaseContainer, info_power_path)
  self.go_btn = self:AddComponent(UIButton, go_btn_path)
  self.go_btn:SetOnClick(function()
    local x, y = BattleFieldUtil.GetNearSafePoint(LuaEntry.Player:GetBattleFieldPos(), BattleFieldType.EpidemicZone, 3)
    if x and y then
      local willPos = SceneUtils.TileToWorld({x = x, y = y})
      self.view.ctrl:CloseSelf()
      GoToUtil.GotoDragonPos(willPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      end, LuaEntry.Player:GetCrossServerId(), LuaEntry.Player:GetCurWorldId(), LuaEntry.Player:GetCurWorldType())
    end
  end)
  self.info_time = self:AddComponent(UIImage, info_time_path)
  self.time_desc = self:AddComponent(UITextMeshProUGUIEx, time_desc_path)
  self.time_btn = self:AddComponent(UIButton, time_btn_path)
  self.time_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActEpidemicBattleBuffView, {anim = true}, self.template, BattleFieldType.EpidemicZone)
  end)
  if WorldBattleUtil.EnableShowWorldAssistanceInfo() then
    self.dCompAssistance = UIAsyncLoaderBridge.New(self, "dCompAssistance", self.transform:Find(assistance_root_path), UIAssets.UIWorldPointComp_PlayerAssistanceComp, lua_path_assistance)
  end
end

function WorldEpidemicBuild:OnDestroy()
  self.info_score = nil
  self.protect_tip = nil
  self.res_item = nil
  self.info_speed = nil
  self.speed_num = nil
  self.speed_btn = nil
  self.info_cur = nil
  self.cur_num = nil
  self.cur_btn = nil
  self.line1 = nil
  self.info_buff = nil
  self.buff_icon = nil
  self.buff_name = nil
  self.buff_desc = nil
  self.line2 = nil
  self.info_power = nil
  self.go_btn = nil
  self.info_time = nil
  self.time_desc = nil
  self.time_btn = nil
  if self.dCompAssistance then
    self.dCompAssistance:Delete()
    self.dCompAssistance = nil
  end
  base.OnDestroy(self)
end

function WorldEpidemicBuild:ShowDesc()
end

function WorldEpidemicBuild:IsSpBuild()
  return EBTemplateMgr:IsScoreBox(self.data.buildId)
end

function WorldEpidemicBuild:GetEffUp(detailInfo)
  return false, 0
end

function WorldEpidemicBuild:RefreshData(pointData)
  self.data = pointData
  self.curState = nil
  self.endTime = nil
  self.template = EBTemplateMgr:GetTemplate(self.data.buildId)
  if self:IsSpBuild() then
    self.info_score:SetActive(true)
    self.info_speed:SetActive(false)
    self.info_cur:SetActive(false)
    self.line1:SetActive(false)
    self.info_power:SetActive(false)
    self.info_buff:SetActive(false)
    self.line2:SetActive(false)
    self.info_time:SetActive(false)
    self.protect_tip:SetLocalText(self.template.name)
    self.res_item:ReInit({
      count = pointData.score,
      rewardType = RewardType.RESOURCE_ITEM,
      itemId = pointData.resId
    })
  else
    self.info_score:SetActive(false)
    self.info_speed:SetActive(true)
    self.info_cur:SetActive(true)
    self:UpdateCurNum()
    local state = pointData.state or 0
    if state == EpidemicBuildState.Normal then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if curTime < pointData.openTime then
        self.curState = DragonBuildState.Protect
        self.endTime = self.data.openTime
      end
    end
    local bBuildPower, bBuildBuff
    if self.curState ~= DragonBuildState.Protect then
      self.curState = state == EpidemicBuildState.Occupied and DragonBuildState.Occupied or DragonBuildState.Normal
      bBuildPower = EBTemplateMgr:IsPowerTower(self.data.buildId)
      if not bBuildPower then
        bBuildBuff = EBTemplateMgr:IsBuff(self.data.buildId)
      end
      if bBuildBuff then
        local buffTemplate = EBActMgr:GetTemplateBuffById(self.data.buffId)
        if not string.IsNullOrEmpty(buffTemplate.icon) then
          self.buff_icon:LoadSprite(buffTemplate.icon)
        end
        self.buff_name:SetLocalText(buffTemplate.name)
        if buffTemplate.getDesc then
          self.buff_desc:SetText(buffTemplate:getDesc())
        else
          self.buff_desc:SetLocalText(buffTemplate.desc)
        end
        self.endTime = self.data.buffEndTime
      end
    end
    self.info_power:SetActive(bBuildPower)
    if bBuildPower then
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.info_power.rectTransform)
    end
    self.info_buff:SetActive(bBuildBuff)
    if bBuildBuff then
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.info_buff.rectTransform)
    end
    self.line1:SetActive(bBuildPower or bBuildBuff)
    self.line2:SetActive(self.endTime ~= nil and not bBuildBuff)
    self.info_time:SetActive(self.endTime ~= nil)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
  self:Update1000MS()
end

function WorldEpidemicBuild:UpdateCurNum()
  local info = self.data ~= nil and CS.SceneManager.World:GetPointInfo(self.data.pointId) or nil
  local detailInfo = info ~= nil and info.detail or nil
  local score = detailInfo ~= nil and detailInfo.Score or 0
  local overflowScore = detailInfo ~= nil and detailInfo.OverflowScore or 0
  if score == 0 then
    self.cur_num:SetText(0)
  elseif overflowScore == 0 then
    self.cur_num:SetText(score)
  else
    local safe = score - overflowScore
    self.cur_num:SetText(safe .. "+" .. overflowScore)
  end
  local speed = self.template ~= nil and self.template.point_produce_per_second or 0
  local bUp, effNum = self:GetEffUp(detailInfo)
  if bUp then
    speed = math.floor(speed * (1 + effNum / 10000))
  end
  if 0 < overflowScore then
    local sPer = self.template ~= nil and self.template.safe_percent or 1
    local sOver = math.ceil(speed * (1 - sPer))
    local sSafe = speed - sOver
    self.speed_num:SetText(sSafe .. "+" .. sOver .. "/s")
  else
    self.speed_num:SetText(speed .. "/s")
  end
  self.speed_num:SetColor(bUp and COLOR_GREEN or COLOR_BLACK)
end

function WorldEpidemicBuild:Update1000MS()
  if self.data == nil then
    return
  end
  if self.endTime ~= nil then
    local curSec = UITimeManager:GetInstance():GetServerSeconds()
    local remainTime = math.max(self.endTime - curSec, 0)
    local key = self.curState == DragonBuildState.Protect and "456511" or "YiBianJinQu_battle_tips_12"
    self.time_desc:SetText(string.format([[
<size=24>%s</size>
%s]], Localization:GetString(key), UITimeManager:GetInstance():SecondToFmtString(remainTime)))
  end
  if self.curState == DragonBuildState.Occupied and not self:IsSpBuild() then
    self:UpdateCurNum()
  end
end

function WorldEpidemicBuild:UpdateDetailInfo(detail)
  if not self.rectTransform then
    return
  end
  if not detail then
    return
  end
  self:RefreshAssistance(detail.playerData)
end

function WorldEpidemicBuild:RefreshAssistance(info)
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
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

return WorldEpidemicBuild
