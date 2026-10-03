local base = require("UI.BattleFieldBase.BattleFieldBaseView")
local LWMainEpidemicZoneUIView = BaseClass("LWMainEpidemicZoneUIView", base)
local ActMgr = DataCenter.ActEpidemicZoneManager
local LWMainEpidemicZoneNoticeItem = require("UI.LWMainEpidemicZoneUI.Component.LWMainEpidemicZoneNoticeItem")
local notice_item_path = "safeArea/NoticeItem"
local defence_redPoint_path = "safeArea/bottomLayer/LeftBtnLayout/defence/RedPointNum"
local defence_per_txt_path = "safeArea/bottomLayer/LeftBtnLayout/defence/defencePerTxt"
local safe_tip_path = "safeArea/topLayer/Power/SafeTip"
local safe_speed_text_path = "safeArea/topLayer/Power/SafeTip/SafeSpeedText"
local safe_tip_close_path = "safeArea/topLayer/Power/SafeTip/SafeTipClose"
local KEY_EPIDEMIC_SAFE_TIP = "_EPIDEMIC_SAFE_TIP"

function LWMainEpidemicZoneUIView:GetBfType()
  return BattleFieldType.EpidemicZone
end

function LWMainEpidemicZoneUIView:InitPolygonPoints()
  if self.centerE == nil then
    return
  end
  if self.polygonPoints then
    return
  end
  local points = {}
  local rect = self.centerE.rectTransform.rect
  local width, height = rect.width, rect.height
  local hr = 60
  table.insert(points, {
    100 + hr,
    340
  })
  table.insert(points, {
    width - 130 - hr,
    340
  })
  table.insert(points, {
    width - 130 - hr,
    400
  })
  table.insert(points, {
    width - 20 - hr,
    400
  })
  table.insert(points, {
    width - 20 - hr,
    710
  })
  table.insert(points, {
    width - 20 - hr,
    height - 680
  })
  table.insert(points, {
    width - 220 - hr,
    height - 680
  })
  table.insert(points, {
    width - 220 - hr,
    height - 320
  })
  table.insert(points, {
    20 + hr,
    height - 340
  })
  table.insert(points, {
    20 + hr,
    620
  })
  table.insert(points, {
    100 + hr,
    620
  })
  self.polygonPoints = points
end

function LWMainEpidemicZoneUIView:ComponentDefine()
  self.defenceShowPer = LuaEntry.DataConfig:TryGetNum("YiBianJinQu_battle", "k15", 20)
  if self.textLeft then
    self.textLeft:SetLocalText("Desert_strom_commander_1001")
  end
  local cls = "UI.LWMainEpidemicZoneUI.Component.LWMainEpidemicZoneSkill"
  local prefab = "Assets/Main/Prefabs/UI/BF_Epidemic/Battle/BattleMainSkill.prefab"
  self.skill = self:LoadComponentAsync(cls, prefab, self.bottom_layer, function(_, go)
    go.transform:SetAsLastSibling()
    go.name = "Skill"
    local rectTF = go:GetComponent(typeof(CS.UnityEngine.RectTransform))
    if rectTF ~= nil then
      rectTF:Set_anchoredPosition(0, 210)
    end
    self.skill:RefreshSkillShow()
    self:TryPlayGuide()
  end)
  self.notice_item = self:AddComponent(LWMainEpidemicZoneNoticeItem, notice_item_path)
  self.notice_item:CleanSeq()
  self.defence_redPoint = self:AddComponent(UIBaseContainer, defence_redPoint_path)
  self.defence_redPoint_num = self.defence_redPoint:AddComponent(UITextMeshProUGUIEx, "Text")
  self.defence_per_txt = self:AddComponent(UITextMeshProUGUIEx, defence_per_txt_path)
  self.safe_tip = self:AddComponent(UIButton, safe_tip_path)
  self.safe_tip:SetActive(false)
  self.safe_tip:SetOnClick(function()
    self:CloseSafeTip()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIEpidemicBattleHeal, {anim = true}, 3)
  end)
  self.safe_speed_text = self:AddComponent(UITextMeshProUGUIEx, safe_speed_text_path)
  local speed = LuaEntry.DataConfig:TryGetNum("YiBianJinQu_battle", "k9", 0)
  self.safe_speed_text:SetText(string.format("+%s/s", speed))
  self.safe_tip_close = self:AddComponent(UIButton, safe_tip_close_path)
  self.safe_tip_close:SetOnClick(function()
    self:CloseSafeTip()
  end)
end

function LWMainEpidemicZoneUIView:TryPlayGuide()
  local topDone = self.battle_info and self.battle_info:AsyncLoadDone()
  local miniMapDone = self.mini_map and self.mini_map:AsyncLoadDone()
  local skillDone = self.skill and self.skill:AsyncLoadDone()
  if topDone and miniMapDone and skillDone then
    EventManager:GetInstance():Broadcast(EventId.GF_enter_battlefield, BattleFieldType.EpidemicZone)
  end
end

function LWMainEpidemicZoneUIView:ComponentDestroy()
  self.battle_info = nil
  self.mini_map = nil
  self.skill = nil
  self.notice_item = nil
  self.defence_redPoint = nil
  self.defence_redPoint_num = nil
  self.defence_per_txt = nil
end

function LWMainEpidemicZoneUIView:OnBattleInfoReady()
  local testFlag = BattleFieldUtil.BTestJump()
  if not testFlag then
    self.battle_info:SetMain(true)
  end
  self:TryPlayGuide()
end

function LWMainEpidemicZoneUIView:OnMiniMapReady()
  self.mini_map:SetMain()
  self:TryPlayGuide()
end

function LWMainEpidemicZoneUIView:DoBtnGo()
  if self:IsCurWatchIdx() then
    ActMgr:TryEnterBattlefield(0)
  end
end

function LWMainEpidemicZoneUIView:DoBtnLeft()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIEpidemicBattleCommanderSet)
end

function LWMainEpidemicZoneUIView:IsCurWatchIdx()
  local groupIdx = ActMgr:GetMyGroupIdx()
  if 0 < groupIdx and groupIdx == BattleFieldUtil.ObserveIdx() then
    return true
  end
  return false
end

function LWMainEpidemicZoneUIView:CheckEnterShow()
  if BattleFieldUtil.isObserve then
    return
  end
  self:OnSelfAttackedBySkill()
  self:OnPointsUpdate()
end

function LWMainEpidemicZoneUIView:OnObserveChange()
  if self.skill and self.skill:AsyncLoadDone() then
    self.skill:RefreshSkillShow()
  end
  self:OnSelfAttackedBySkill()
  self:OnPointsUpdate()
  self:TryShowSafeTip()
end

function LWMainEpidemicZoneUIView:OnHospitalUpdateEx()
  self:TryShowSafeTip()
end

local function SortDist(a, b)
  return a[1] < b[1]
end

function LWMainEpidemicZoneUIView:RefreshCameraPointEx()
  local theWorld = CS.SceneManager.World
  local list = theWorld:GetAllDragonPointList()
  local havePoint
  local infos = {}
  local curPos = theWorld.CurTarget
  local curTile = SceneUtils.WorldToTile(curPos)
  if list ~= nil then
    local templateMgr = DataCenter.EpidemicBuildTemplateMgr
    for _, v in pairs(list) do
      local detailInfo = v.detail
      local bId = detailInfo ~= nil and detailInfo.BuildId or nil
      if bId ~= nil and templateMgr:IsBuild(bId) then
        local template = templateMgr:GetTemplate(bId)
        local tarTile = SceneUtils.IndexToTilePos(v.mainIndex, ForceChangeScene.World)
        if UIUtil.IsInViewByTileXY(tarTile, template.size + 2) then
          havePoint = true
          break
        else
          local dist = math.floor(Vector2.Distance(curTile, tarTile))
          table.insert(infos, {
            dist,
            v.mainIndex,
            detailInfo.BuildId,
            detailInfo.Role
          })
        end
      end
    end
  end
  if havePoint then
    self.worldBuildInfos = {}
  else
    table.sort(infos, SortDist)
    self.worldBuildInfos = infos
  end
  for i = 1, 3 do
    self:RefreshOneBuildBtn(i)
  end
end

function LWMainEpidemicZoneUIView:GetEndSec()
  local groupInfo = ActMgr:GetCurGroup()
  local eTime = groupInfo ~= nil and groupInfo.endTime or 0
  return eTime
end

function LWMainEpidemicZoneUIView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.EpidemicBattleBeAttackedBySkill, self.OnSelfAttackedBySkill)
  self:AddUIListener(EventId.UPDATE_POINTS_DATA, self.OnPointsUpdate)
end

function LWMainEpidemicZoneUIView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.EpidemicBattleBeAttackedBySkill, self.OnSelfAttackedBySkill)
  self:RemoveUIListener(EventId.UPDATE_POINTS_DATA, self.OnPointsUpdate)
end

function LWMainEpidemicZoneUIView:Update1000MS()
  if base.Update1000MS then
    base.Update1000MS(self)
  end
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  if self.lastDefenceRedUpdate == nil or curSec - self.lastDefenceRedUpdate > 5 then
    self.lastDefenceRedUpdate = curSec
    self:OnSelfAttackedBySkill()
  end
end

function LWMainEpidemicZoneUIView:OnSelfAttackedBySkill()
  if BattleFieldUtil.isObserve then
    return
  end
  if self.defence_redPoint == nil then
    return
  end
  self.lastDefenceRedUpdate = UITimeManager:GetInstance():GetServerSeconds()
  local redCnt = ActMgr:GetBeAttackedBySkillList()
  self.defence_redPoint:SetActive(0 < redCnt)
  if 0 < redCnt then
    self.defence_redPoint_num:SetText(redCnt)
  end
  self:TryShowFlashRed(redCnt)
end

function LWMainEpidemicZoneUIView:TryShowFlashRed(num)
  if self.flashing_red == nil or self.bFlashing then
    return
  end
  if self.seqAttackedBySkill ~= nil then
    self.seqAttackedBySkill:Stop()
    self.seqAttackedBySkill = nil
  end
  if 0 < num then
    self.flashing_red:SetActive(true)
    self.seqAttackedBySkill = TimerManager:GetInstance():DelayInvoke(function()
      self.seqAttackedBySkill = nil
      if not self.bFlashing then
        self.flashing_red:SetActive(false)
      end
    end, 3)
  else
    self.flashing_red:SetActive(false)
  end
end

function LWMainEpidemicZoneUIView:OnPointsUpdate()
  if BattleFieldUtil.isObserve then
    return
  end
  local mainCity = BattleFieldUtil.GetSelfMainCity()
  if mainCity ~= nil then
    local curHp = mainCity.curHp or 0
    local maxHp = mainCity.curMaxHp or 0
    if maxHp == 0 then
      maxHp = BattleFieldUtil.GetPlayerMaxHp(BattleFieldType.EpidemicZone)
    end
    if curHp / maxHp * 100 <= self.defenceShowPer then
      self.defence_per_txt:SetText(string.GetFormattedPercentStr(curHp / maxHp))
      self.btnDefence:LoadSpriteAsync(string.format(LoadPath.LWBattleFieldPath, "mjc_yibianjunqu_btn_chengfang_debuff"))
    else
      self.defence_per_txt:SetText("")
      self.btnDefence:LoadSpriteAsync(string.format(LoadPath.LWBattleFieldPath, "lrb_zhanchang_chengfang"))
    end
  end
end

function LWMainEpidemicZoneUIView:CloseSafeTip()
  self.safe_tip:SetActive(false)
  local groupInfo = ActMgr:GetCurGroup()
  local battleEndTime = groupInfo ~= nil and groupInfo.endTime or 0
  CommonUtil.PlayerPrefsSetInt(KEY_EPIDEMIC_SAFE_TIP, battleEndTime)
end

function LWMainEpidemicZoneUIView:TryShowSafeTip()
  local signTime = CommonUtil.PlayerPrefsGetInt(KEY_EPIDEMIC_SAFE_TIP, 0)
  local groupInfo = ActMgr:GetCurGroup()
  local battleEndTime = groupInfo ~= nil and groupInfo.endTime or 0
  if signTime >= battleEndTime then
    return
  end
  local curPoint = LuaEntry.Player:GetBattleFieldPos()
  local inBlock = BattleFieldUtil.IsInBlockRange(curPoint, BattleFieldType.EpidemicZone)
  if not inBlock then
    return
  end
  local showHospitalEffect = BattleFieldUtil.CheckHospitalEffState()
  self.safe_tip:SetActive(showHospitalEffect)
end

return LWMainEpidemicZoneUIView
