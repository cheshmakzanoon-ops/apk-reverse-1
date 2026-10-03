local ChampionDuelFinalShowCtrl = BaseClass("ChampionDuelFinalShowCtrl", Singleton)
local Resource = CS.GameEntry.Resource
local STM_Alignment = CS.SuperTextMesh.Alignment
local TypeHead = typeof(CS.UIPlayerHead)
local TypeSuperTextMesh = typeof(CS.SuperTextMesh)
local TypeTrigger = typeof(CS.TouchObjectEventTrigger)
local TypeSAnimation = typeof(CS.SimpleAnimation)
local TypePS = typeof(CS.UnityEngine.ParticleSystem)
local MyIsNull = IsNull
local MyFormat = string.format
local YH_TOP_SHOW_PATH = "Assets/_Art_LastWar/Effect/Prefab/Common/Eff_feiting_yanhua_01.prefab"
local FT_TOP_POINT_PATH = "feiting_weizhi/A_Vehicle_feiting_0%d/feiting/To_unity/Root/room/joint1/"
local YH_BOTTOM_SHOW_PATH = "Assets/_Art_LastWar/Effect/Prefab/Common/Eff_feiting_yanhua_02.prefab"
local YH_BOTTOM_POINT_PATH = "A_Hero_David_01_world/A_Hero_David_01/A_Hero_David_01_skin/To_unity/Root/base/All_M/bxg/triggerBottom"
local FT_SHOW_PATH = "Assets/_Art_LastWar/Models/Characters/Object/A_Vehicle_feiting_01/prefab/A_Vehicle_feiting_SJ.prefab"
local FT_ANIM_PATH = "feiting_weizhi/A_Vehicle_feiting_0%d/feiting"
local FT_BASE_POINT_PATH = "feiting_weizhi/A_Vehicle_feiting_0%d/feiting/To_unity/Root/room/joint3/%s"
local FT_EULER_ANGLE_Y = 90
local FT_BASE_X = 1000
local FT_BASE_Y = 950
local FT_POS_MAX = 50
local FT_SPEED = 0.01
local XYZTb = {
  x = FT_BASE_X,
  y = 0,
  z = FT_BASE_Y
}
local COLOR_NAME = Color.New(255, 233, 84, 255)
local COLOR_OUTLINE = Color.New(0.25098039215686274, 0.00784313725490196, 0.03529411764705882, 1)

function ChampionDuelFinalShowCtrl:CleanData()
  if self.baseTileV2 then
    SceneUtils.ReturnPoolV2(self.baseTileV2)
    self.baseTileV2 = nil
  end
  if self.baseWorldV3 then
    SceneUtils.ReturnPoolV3(self.baseWorldV3)
    self.baseWorldV3 = nil
  end
  self:DeleteTimer()
  self:CleanFtReq()
  self:CleanYHReq()
  self:CleanYHSeq()
  self:CleanYHBReqs()
  self.FT_Dir = nil
  self.ftCur = nil
end

function ChampionDuelFinalShowCtrl:CleanFtReq()
  if self.ftReq ~= nil then
    self.ftReq:Destroy()
  end
  self.ftReq = nil
end

function ChampionDuelFinalShowCtrl:CleanYHReq()
  if self.yhReq ~= nil then
    self.yhReq:Destroy()
  end
  self.yhReq = nil
end

function ChampionDuelFinalShowCtrl:CleanYHSeq()
  if self.yhSeq then
    self.yhSeq:Stop()
  end
  self.yhSeq = nil
end

function ChampionDuelFinalShowCtrl:CleanYHBReqs()
  if self.yhbReqs ~= nil then
    for _, v in pairs(self.yhbReqs) do
      if v then
        v:Destroy()
      end
    end
  end
  self.yhbReqs = nil
end

function ChampionDuelFinalShowCtrl:GetYHGo()
  if self.yhReq ~= nil and self.yhReq.isDone then
    if MyIsNull(self.yhReq.gameObject) then
      self:CleanYHReq()
    else
      return self.yhReq.gameObject
    end
  end
  return nil
end

function ChampionDuelFinalShowCtrl:CheckCreateYH_TopShow(idx)
  local go = self:GetYHGo()
  if go then
    self:PlayYH_TopEff(go, idx)
    return
  end
  if self.yhReq ~= nil then
    if self.yhReq.isDone then
      if MyIsNull(self.yhReq.gameObject) then
        self:CleanYHReq()
      else
        self:PlayYH_TopEff(self.yhReq.gameObject, idx)
        return
      end
    else
      return
    end
  end
  local request = Resource:InstantiateAsync(YH_TOP_SHOW_PATH)
  self.yhReq = request
  request:completed("+", function(yhReq)
    local yhGo = yhReq.gameObject
    local world = CS.SceneManager.World
    local ftGo = self:GetFTGo()
    if MyIsNull(yhGo) or MyIsNull(world) or MyIsNull(ftGo) then
      self:CleanYHReq()
      return
    end
    local tf = yhGo.transform
    tf:SetParent(world.DynamicObjNode)
    self:PlayYH_TopEff(yhGo, idx)
  end)
end

function ChampionDuelFinalShowCtrl:PlayYH_TopEff(yhGo, idx)
  local ftGo = self:GetFTGo()
  if MyIsNull(yhGo) or MyIsNull(ftGo) then
    return
  end
  local ftTopRt = ftGo.transform:Find(MyFormat(FT_TOP_POINT_PATH, idx))
  if not ftTopRt then
    return
  end
  local x, y, z = ftTopRt:Get_localPosition()
  local startV3 = ftTopRt:TransformPoint(x, y, z)
  yhGo.transform:Set_localPosition(startV3.x, startV3.y, startV3.z)
  local eff = yhGo:GetComponent(TypePS)
  if eff == nil then
    return
  end
  self:CleanYHSeq()
  yhGo:SetActive(true)
  eff:Simulate(0)
  eff:Play()
  if eff.main ~= nil then
    self.yhSeq = TimerManager:GetInstance():DelayInvoke(function()
      if MyIsNull(yhGo) then
        return
      end
      self:CleanYHSeq()
      yhGo:SetActive(false)
      eff:Stop()
    end, eff.main.duration)
  end
end

function ChampionDuelFinalShowCtrl:GetOneYHBObj()
  if self.yhbReqs ~= nil then
    for _, v in pairs(self.yhbReqs) do
      if v and v.isDone then
        local go = v.gameObject
        if not MyIsNull(go) and not go.activeSelf then
          return go
        end
      end
    end
  end
  return nil
end

function ChampionDuelFinalShowCtrl:GetOneYHBReq()
  if self.yhbReqs == nil then
    self.yhbReqs = {}
  end
  local idx = #self.yhbReqs + 1
  for k, v in pairs(self.yhbReqs) do
    if v and v.isDone then
      local go = v.gameObject
      if MyIsNull(go) then
        v:Destroy()
        idx = k
        break
      end
    end
  end
  self.yhbReqs[idx] = Resource:InstantiateAsync(YH_BOTTOM_SHOW_PATH)
  return idx
end

function ChampionDuelFinalShowCtrl:CheckCreateYH_BottomShow()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.lastYHBottomTime ~= nil and curTime - self.lastYHBottomTime < 1000 then
    return
  end
  self.lastYHBottomTime = curTime
  local go = self:GetOneYHBObj()
  if go then
    self:PlayYH_BottomEff(go)
    return
  end
  local idx = self:GetOneYHBReq()
  local request = self.yhbReqs[idx]
  request:completed("+", function(yhReq)
    local yhbGo = yhReq.gameObject
    local world = CS.SceneManager.World
    if MyIsNull(yhbGo) or MyIsNull(world) then
      return
    end
    yhbGo.name = "CD_YHB_" .. idx
    yhbGo.transform:SetParent(world.DynamicObjNode)
    self:PlayYH_BottomEff(yhbGo)
  end)
end

function ChampionDuelFinalShowCtrl:PlayYH_BottomEff(yhbGo)
  if MyIsNull(yhbGo) then
    return
  end
  local eff = yhbGo:GetComponent(TypePS)
  if eff == nil then
    return
  end
  local world = CS.SceneManager.World
  if MyIsNull(world) then
    return
  end
  local screenPos = CS.UnityEngine.Input.mousePosition
  local worldPos = world:ScreenPointToWorld(screenPos, 0)
  yhbGo.transform:Set_position(worldPos.x, worldPos.y, worldPos.z)
  yhbGo:SetActive(true)
  eff:Simulate(0)
  eff:Play()
  if eff.main ~= nil then
    local seq
    seq = TimerManager:GetInstance():DelayInvoke(function()
      if seq then
        seq:Stop()
      end
      seq = nil
      if not MyIsNull(yhbGo) then
        yhbGo:SetActive(false)
      end
    end, eff.main.duration)
  end
end

function ChampionDuelFinalShowCtrl:GetFTGo()
  if self.ftReq ~= nil and self.ftReq.isDone then
    if MyIsNull(self.ftReq.gameObject) then
      self:CleanFtReq()
    else
      return self.ftReq.gameObject
    end
  end
  return nil
end

function ChampionDuelFinalShowCtrl:SetFTGoShow(flag)
  local ftGo = self:GetFTGo()
  if MyIsNull(ftGo) then
    return
  end
  ftGo:SetActive(flag)
  if flag then
    for i = 1, 3 do
      self:PlayFTAnim(i, true)
    end
  end
end

function ChampionDuelFinalShowCtrl:GetFTShowTeam(idx)
  local fr = DataCenter.ChampionDuelManager:GetFinalRankList()
  if #fr == 0 then
    return nil
  end
  local teamInfo = fr[idx]
  return teamInfo
end

function ChampionDuelFinalShowCtrl:InitFTTriggers(idx)
  local ftGo = self:GetFTGo()
  if MyIsNull(ftGo) then
    return
  end
  local infoRt = ftGo.transform:Find(MyFormat(FT_BASE_POINT_PATH, idx, "triggerInfo"))
  if infoRt then
    local trigger = infoRt:GetComponent(TypeTrigger)
    if trigger then
      function trigger.onPointerClick()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionDuelFinalList, {anim = false})
      end
    end
  end
  local ftRt = ftGo.transform:Find(MyFormat(FT_BASE_POINT_PATH, idx, "triggerFt"))
  if ftRt then
    local trigger = ftRt:GetComponent(TypeTrigger)
    if trigger then
      function trigger.onPointerClick()
        self:CheckCreateYH_TopShow(idx)
      end
    end
  end
  local bottomRt = ftGo.transform:Find(YH_BOTTOM_POINT_PATH)
  if bottomRt then
    local trigger = bottomRt:GetComponent(TypeTrigger)
    if trigger then
      function trigger.onPointerClick()
        self:CheckCreateYH_BottomShow()
      end
    end
  end
end

function ChampionDuelFinalShowCtrl:CheckUpdateFTHead(idx)
  local ftGo = self:GetFTGo()
  if MyIsNull(ftGo) then
    return
  end
  local headPt = ftGo.transform:Find(MyFormat(FT_BASE_POINT_PATH, idx, "touxiang"))
  if not headPt then
    return
  end
  local player_head = headPt:GetComponent(TypeHead)
  if not player_head then
    return
  end
  local teamInfo = self:GetFTShowTeam(idx)
  if teamInfo then
    player_head:SetData(teamInfo.uid, teamInfo.head, teamInfo.frame)
  end
end

function ChampionDuelFinalShowCtrl:CheckUpdateFTName(idx)
  local ftGo = self:GetFTGo()
  if MyIsNull(ftGo) then
    return
  end
  local namePt = ftGo.transform:Find(MyFormat(FT_BASE_POINT_PATH, idx, "mingzi"))
  if not namePt then
    return
  end
  local name_text = namePt:GetComponent(TypeSuperTextMesh)
  if not name_text then
    return
  end
  local eaX, eaY, eaZ = namePt:Get_localEulerAngles()
  local ftDir = self:GetFT_Dir()
  eaY = -1 * ftDir * FT_EULER_ANGLE_Y
  namePt:Set_localEulerAngles(eaX, eaY, eaZ)
  local alignment = 0 < ftDir and STM_Alignment.MidRight or STM_Alignment.MidLeft
  name_text.alignment = alignment
  name_text.color = COLOR_NAME
  name_text.outlineColor = COLOR_OUTLINE
  local teamInfo = self:GetFTShowTeam(idx)
  if teamInfo then
    name_text.text = UIUtil.FormatServerAllianceName(teamInfo.server, teamInfo.abbr, teamInfo.name)
  end
  name_text:Rebuild()
end

function ChampionDuelFinalShowCtrl:PlayFTAnim(idx, bForce)
  local ftGo = self:GetFTGo()
  if MyIsNull(ftGo) then
    return
  end
  local animRt = ftGo.transform:Find(MyFormat(FT_ANIM_PATH, idx))
  if not animRt then
    return
  end
  local animation = animRt:GetComponent(TypeSAnimation)
  if not animation then
    return
  end
  local ftDir = self:GetFT_Dir()
  local animStr = 0 < ftDir and "idleR" or "idleL"
  if animation:IsPlaying(animStr) then
    if bForce then
      animation:Rewind(animStr)
    end
    return
  end
  animation:Play(animStr)
end

function ChampionDuelFinalShowCtrl:UpdateFTAnim(ignoreHead)
  for i = 1, 3 do
    if not ignoreHead then
      self:CheckUpdateFTHead(i)
    end
    self:CheckUpdateFTName(i)
    self:PlayFTAnim(i)
  end
end

function ChampionDuelFinalShowCtrl:CheckCreateWorldShow()
  local go = self:GetFTGo()
  if go then
    return
  end
  if self.ftReq ~= nil then
    if self.ftReq.isDone then
      if MyIsNull(self.ftReq.gameObject) then
        self:CleanFtReq()
      else
        return
      end
    else
      return
    end
  end
  local request = Resource:InstantiateAsync(FT_SHOW_PATH)
  self.ftReq = request
  request:completed("+", function(ftReq)
    local ftGo = ftReq.gameObject
    local world = CS.SceneManager.World
    if MyIsNull(ftGo) or MyIsNull(world) then
      self:CleanFtReq()
      return
    end
    ftGo.transform:SetParent(world.DynamicObjNode)
    ftGo:SetActive(true)
    for i = 1, 3 do
      self:InitFTTriggers(i)
    end
    self:UpdateFTAnim()
    self:UpdateFTMove()
  end)
end

function ChampionDuelFinalShowCtrl:AddTimer()
  self:CheckCreateWorldShow()
  if self.timer ~= nil then
    self:SetFTGoShow(true)
    return
  end
  self.timer = TimerManager:GetInstance():GetTimer(1, self.UpdateFTMove, self, false, true, false)
  self.timer:Start()
end

function ChampionDuelFinalShowCtrl:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function ChampionDuelFinalShowCtrl:GetFT_Dir()
  if not self.FT_Dir then
    self.FT_Dir = math.random(1, 100) <= 50 and 1 or -1
    self.ftCur = FT_BASE_X
  end
  return self.FT_Dir
end

function ChampionDuelFinalShowCtrl:UpdateFTMove()
  local ftDir = self:GetFT_Dir()
  local curX = self.ftCur
  local tmpCur = curX + FT_SPEED * ftDir
  if tmpCur > FT_BASE_X + FT_POS_MAX or tmpCur < FT_BASE_X - FT_POS_MAX then
    self.FT_Dir = -1 * ftDir
    tmpCur = curX + FT_SPEED * ftDir
    self:UpdateFTAnim(true)
  end
  self.ftCur = tmpCur
  local ftGo = self:GetFTGo()
  if MyIsNull(ftGo) or not ftGo.activeSelf then
    return
  end
  local rt = ftGo.transform
  local ea = rt.eulerAngles
  ea.y = ftDir * FT_EULER_ANGLE_Y
  rt.eulerAngles = ea
  local v3 = self.baseWorldV3
  if v3 == nil then
    v3 = self:UpdateBaseXZ()
  end
  rt:Set_position(v3.x - XYZTb.x + self.ftCur, 0, v3.z)
end

function ChampionDuelFinalShowCtrl:UpdateBaseXZ()
  local v2 = self.baseTileV2
  if v2 == nil then
    self.baseTileV2 = SceneUtils.WorldToUniqueTile(XYZTb)
    v2 = self.baseTileV2
  end
  if self.baseWorldV3 then
    SceneUtils.ReturnPoolV3(self.baseWorldV3)
    self.baseWorldV3 = nil
  end
  self.baseWorldV3 = SceneUtils.TileToWorld(v2, ForceChangeScene.World, LuaEntry.Player:GetCurServerId())
  return self.baseWorldV3
end

function ChampionDuelFinalShowCtrl:CheckWorldShow()
  if BattleFieldUtil.InBattleField() then
    self:SetFTGoShow(false)
    return
  end
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local endTime = DataCenter.ChampionDuelManager:GetFinalRankEndTime()
  if curSec >= endTime then
    self:SetFTGoShow(false)
    return
  end
  local list = DataCenter.ChampionDuelManager:GetFinalRankList()
  if #list == 0 then
    self:SetFTGoShow(false)
    return
  end
  if not SceneUtils.GetIsInWorld() then
    self:SetFTGoShow(false)
    return
  end
  local world = CS.SceneManager.World
  if MyIsNull(world) then
    self:SetFTGoShow(false)
    return
  end
  local lod = world:GetLodLevel()
  if 3 < lod then
    if self.cacheLod ~= lod then
      self:SetFTGoShow(false)
    end
    self.cacheLod = lod
    return
  end
  self.cacheLod = lod
  local configSchedule = DataCenter.ZoneWarManager.configSchedule
  if configSchedule then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime >= configSchedule.crossStartTime and curTime < configSchedule.roundSettleTime then
      self:SetFTGoShow(false)
      return
    end
  end
  local targetV3 = world.CurTarget
  local curV2 = SceneUtils.WorldToTile(targetV3, ForceChangeScene.World)
  local x = curV2.x
  local y = curV2.y
  if 450 <= x and x <= 550 and 450 <= y and y <= 550 then
    self:AddTimer()
  end
end

return ChampionDuelFinalShowCtrl
