local WorldDragonBuild = BaseClass("WorldDragonBuild", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local lua_path_assistance = "UI.UIWorldPoint.Component.UIWorldPointNewOtherPlayerInfoAssistanceComp"
local desc_text_path = "DescText"
local info_path = "info"
local icon_path = "info/icon"
local protect_tip_path = "info/ProtectTip"
local res_item_path = "info/ResItem"
local msgGroup_path = "info/msgGroup"
local text_speed_path = "info/msgGroup/SpeedNum"
local btn_speed_path = "info/msgGroup/SpeedBtn"
local text_cur_path = "info/msgGroup/CurNum"
local btn_cur_path = "info/msgGroup/CurBtn"
local info2_path = "info2"
local img_flag_path = "info2/flag"
local text_info_path = "info2/textInfo"
local text_player_path = "info2/textPlayer"
local tips_label_path = "tipsLabel"
local assistance_root_path = "assistanceRoot"
local SP_ID = 10110
local COLOR_GREEN = Color.New(0.03529411764705882, 0.6078431372549019, 0.2901960784313726, 1)
local COLOR_BLACK = Color.New(0.16470588235294117, 0.1568627450980392, 0.18823529411764706, 1)

function WorldDragonBuild:OnCreate()
  base.OnCreate(self)
  self.desc_text = self:AddComponent(UIText, desc_text_path)
  self.desc_text:SetActive(false)
  self.infoRoot = self:AddComponent(UIImage, info_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.protect_tip = self:AddComponent(UITextMeshProUGUIEx, protect_tip_path)
  self.res_item = self:AddComponent(UICommonResItem, res_item_path)
  self.msgGroup = self:AddComponent(UIBaseComponent, msgGroup_path)
  self.text_speed = self:AddComponent(UIText, text_speed_path)
  self.btn_speed = self:AddComponent(UIButton, btn_speed_path)
  self.btn_speed:SetOnClick(function()
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
    UIUtil.ShowBubbleTips(strTip, self.btn_speed.transform.position, 0, -30, 0)
  end)
  self.text_cur = self:AddComponent(UIText, text_cur_path)
  self.btn_cur = self:AddComponent(UIButton, btn_cur_path)
  self.btn_cur:SetOnClick(function()
    local time = self.template ~= nil and self.template.safe_point_duration or 0
    local info = self.data ~= nil and CS.SceneManager.World:GetPointInfo(self.data.pointId) or nil
    local detailInfo = info ~= nil and info.detail or nil
    local score = detailInfo ~= nil and detailInfo.Score or 0
    local overflowScore = detailInfo ~= nil and detailInfo.OverflowScore or 0
    local strTip = Localization:GetString("Desert_strom_tips1061", time, score - overflowScore, overflowScore)
    UIUtil.ShowBubbleTips(strTip, self.btn_cur.transform.position, 0, -30, 0)
  end)
  self.info2Root = self:AddComponent(UIImage, info2_path)
  self.img_flag = self:AddComponent(UIImage, img_flag_path)
  self.text_info = self:AddComponent(UITextMeshProUGUIEx, text_info_path)
  self.text_player = self:AddComponent(UITextMeshProUGUIEx, text_player_path)
  self.text_player:SetRichText(true)
  self.tips_label = self:AddComponent(UITextMeshProUGUIEx, tips_label_path)
  if WorldBattleUtil.EnableShowWorldAssistanceInfo() then
    self.dCompAssistance = UIAsyncLoaderBridge.New(self, "dCompAssistance", self.transform:Find(assistance_root_path), UIAssets.UIWorldPointComp_PlayerAssistanceComp, lua_path_assistance, true)
  end
end

function WorldDragonBuild:ShowDesc()
  if self.template ~= nil then
    self.desc_text:SetActive(true)
  end
end

function WorldDragonBuild:OnDestroy()
  if self.dCompAssistance then
    self.dCompAssistance:Delete()
    self.dCompAssistance = nil
  end
  base.OnDestroy(self)
end

function WorldDragonBuild:OnEnable()
  base.OnEnable(self)
end

function WorldDragonBuild:OnDisable()
  base.OnDisable(self)
end

function WorldDragonBuild:IsSpBuild()
  return SP_ID == self.data.buildId
end

function WorldDragonBuild:GetTemplate()
  local template = DataCenter.DragonBuildTemplateManager:GetTemplate(self.data.buildId)
  self.template = template
  return template
end

function WorldDragonBuild:GetBuildMarch()
  return DataCenter.ActDragonManager:GetBuildBestMarch(self.data.uuid)
end

function WorldDragonBuild:IsTeammate()
  return self.data.allianceId == LuaEntry.Player.allianceId
end

function WorldDragonBuild:GetAlIcon()
  local dragonInfo = DataCenter.ActDragonManager:GetActInfo()
  local vsInfo = dragonInfo:GetAllianceById(self.data.allianceId)
  return vsInfo ~= nil and vsInfo.icon or nil
end

function WorldDragonBuild:GetEffUp(detailInfo)
  local nowAId = detailInfo ~= nil and detailInfo.AllianceId or nil
  return DataCenter.ActDragonManager:GetBuildUpEffInfo(nowAId)
end

function WorldDragonBuild:RefreshData(pointData)
  self.data = pointData
  self.curState = nil
  self.tips_label:SetActive(false)
  local template = self:GetTemplate()
  if template ~= nil then
    self.desc_text:SetLocalText(template.des)
    self.icon:LoadSprite(template:GetDetailPath())
    self.icon:SetNativeSize()
  end
  if self:IsSpBuild() then
    self.msgGroup:SetActive(false)
    self.protect_tip:SetActive(true)
    self.protect_tip:SetLocalText(template.name)
    self.res_item:SetActive(true)
    self.res_item:ReInit({
      count = pointData.score,
      rewardType = RewardType.RESOURCE_ITEM,
      itemId = pointData.resId
    })
    self.info2Root:SetActive(false)
  else
    self.msgGroup:SetActive(true)
    self.protect_tip:SetActive(false)
    self.res_item:SetActive(false)
    self.info2Root:SetActive(true)
    self:UpdateCurNum()
    local state = pointData.state or 0
    local checkState = 0
    if state == checkState then
      self.text_info:SetActive(true)
      self.text_player:SetActive(false)
      self.img_flag:SetActive(false)
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if curTime < pointData.openTime then
        self.endTime = self.data.openTime
        self.curState = DragonBuildState.Protect
        self.tips_label:SetLocalText(458279)
        self.tips_label:SetActive(true)
      else
        self.curState = DragonBuildState.Normal
        self.tips_label:SetActive(false)
        self.text_info:SetLocalText(458224)
      end
    else
      self.text_info:SetActive(false)
      self.text_player:SetActive(true)
      checkState = 1
      local str = Localization:GetString(state == checkState and 458193 or 458223)
      local bestMarch = self:GetBuildMarch()
      if bestMarch then
        local colorStr = self:IsTeammate() and "249bc5" or "EE6241"
        str = string.format("%s: <color=#%s>%s</color>", str, colorStr, UIUtil.FormatAllianceAndName(pointData.abbr, bestMarch.ownerName, bestMarch.ownerUid))
      end
      self.text_player:SetText(str)
      local alIcon = self:GetAlIcon()
      if not string.IsNullOrEmpty(alIcon) then
        self.img_flag:SetActive(true)
        self.img_flag:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, alIcon))
        self.img_flag:SetNativeSize()
      else
        self.img_flag:SetActive(false)
      end
      self.curState = state == checkState and DragonBuildState.Occupied or DragonBuildState.Occupying
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
  self:Update1000MS()
end

function WorldDragonBuild:UpdateCurNum()
  local info = self.data ~= nil and CS.SceneManager.World:GetPointInfo(self.data.pointId) or nil
  local detailInfo = info ~= nil and info.detail or nil
  local score = detailInfo ~= nil and detailInfo.Score or 0
  local overflowScore = detailInfo ~= nil and detailInfo.OverflowScore or 0
  if score == 0 then
    self.text_cur:SetText(0)
  elseif overflowScore == 0 then
    self.text_cur:SetText(score)
  else
    local safe = score - overflowScore
    self.text_cur:SetText(safe .. "+" .. overflowScore)
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
    self.text_speed:SetText(sSafe .. "+" .. sOver .. "/s")
  else
    self.text_speed:SetText(speed .. "/s")
  end
  self.text_speed:SetColor(bUp and COLOR_GREEN or COLOR_BLACK)
end

function WorldDragonBuild:Update1000MS()
  if self.data == nil then
    return
  end
  local checkState = 0
  if self.curState == DragonBuildState.Protect and self.data.state == checkState then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.endTime - curTime
    if 0 < remainTime then
      self.text_info:SetText(Localization:GetString(456511) .. " " .. UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.curState = DragonBuildState.Normal
      self.tips_label:SetActive(false)
      self.text_info:SetLocalText(458224)
    end
  elseif self.curState == DragonBuildState.Occupied and not self:IsSpBuild() then
    self:UpdateCurNum()
  end
end

function WorldDragonBuild:UpdateDetailInfo(detail)
  if not self.rectTransform then
    return
  end
  if not detail then
    return
  end
  self:RefreshAssistance(detail.playerData)
end

function WorldDragonBuild:RefreshAssistance(info)
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

return WorldDragonBuild
