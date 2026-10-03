local WinterStormBattleTopItemNew = BaseClass("WinterStormBattleTopItemNew", UIAsyncContainer)
local WinterStormBattleTopSliderItemNew = require("UI.UIActivityCenterTable.Component.ActWinterStorm.WinterStormBattleTopSliderItemNew")
local base = UIAsyncContainer
local Resource = CS.GameEntry.Resource
local wstMgr = DataCenter.WinterStormTemplateManager
local awsMgr = DataCenter.ActWinterStormManager
local typeofPS = typeof(CS.UnityEngine.ParticleSystem)
local typeofTM = typeof(CS.SuperTextMesh)
local MyIsNull = IsNull
local MyRand = math.random
local eff_jifen_path = "TipRoot/Eff_ui_shamofengbao_xiaoditu_jifen"
local img_flag_path = "TipRoot/ImgFlag"
local text_num_path = "TipRoot/ImgFlag/TextNum"
local bg_path = "bg"
local img_mid_path = "ImgMid"
local text_time_path = "TimeText"
local progress_blue_path = "ProgressBlue"
local progress_red_path = "ProgressRed"
local eff1_path = "Eff_ui_winterstormbattle01"
local eff2_path = "Eff_ui_winterstormbattle02"
local btn_path = "Btn"
local TIME_COLOR = {
  "#FFF95F",
  "#FF685D",
  "#00F6FF",
  "#FFFFFF"
}
local IMG_PATH = {
  "lrb_dongjifengbao_zhanchang_huang00.png",
  "lrb_dongjifengbao_zhanchang_hong00.png",
  "lrb_dongjifengbao_zhanchang_lan00.png",
  "lrb_dongjizhanchang_zhanchangjifen_da.png"
}
local EFF_SCORE_PATH = "Assets/Main/Prefabs/World/BF_Winter/DragonWarWinterStormScoreTip.prefab"

function WinterStormBattleTopItemNew:OnCreate()
  base.OnCreate(self)
  self.seqScores = {}
  self.reqScores = {}
  self.endTime = 0
  self.curState = 0
  self.lastUpdateScoreTime = 0
  self.bg = self:AddComponent(UIBaseContainer, bg_path)
  self.img_mid = self:AddComponent(UIImage, img_mid_path)
  self.text_time = self:AddComponent(UIText, text_time_path)
  self.text_time:SetActive(false)
  self.progress_blue = self:AddComponent(WinterStormBattleTopSliderItemNew, progress_blue_path)
  local mySide = awsMgr:GetMySide()
  self.progress_blue:SetSide(mySide)
  self.progress_red = self:AddComponent(WinterStormBattleTopSliderItemNew, progress_red_path)
  local otherSide = mySide == 1 and 2 or 1
  self.progress_red:SetSide(otherSide)
  self.eff1 = self.transform:Find(eff1_path):GetComponent(typeofPS)
  self.eff1.gameObject:SetActive(false)
  self.eff2 = self.transform:Find(eff2_path):GetComponent(typeofPS)
  self.eff2.gameObject:SetActive(false)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(BindCallback(self, self.OnClickTip))
end

function WinterStormBattleTopItemNew:OnDestroy()
  if self.seqScores ~= nil then
    for _, v in pairs(self.seqScores) do
      if v ~= nil then
        v:Pause()
        v:Kill()
      end
    end
    self.seqScores = {}
  end
  if self.reqScores ~= nil then
    for _, v in pairs(self.reqScores) do
      if v ~= nil then
        if not MyIsNull(v.gameObject) then
          v.gameObject:SetActive(false)
        end
        v:Destroy()
      end
    end
    self.reqScores = {}
  end
  self.lastUpdateScoreTime = 0
  self.seqScores = {}
  self.reqScores = {}
  self.endTime = 0
  self.curState = 0
  self.bg = nil
  self.img_mid = nil
  self.text_time = nil
  self.progress_blue = nil
  self.progress_red = nil
  self.eff1 = nil
  self.eff2 = nil
  base.OnDestroy(self)
end

function WinterStormBattleTopItemNew:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.WinterStormScoreChange, self.OnScoreRefresh)
  self:AddUIListener(EventId.WinterStormEntityUpdate, self.OnEntityChange)
end

function WinterStormBattleTopItemNew:OnRemoveListener()
  self:RemoveUIListener(EventId.WinterStormScoreChange, self.OnScoreRefresh)
  self:RemoveUIListener(EventId.WinterStormEntityUpdate, self.OnEntityChange)
  base.OnRemoveListener(self)
end

function WinterStormBattleTopItemNew:OnClickTip()
  DataCenter.ActWinterStormManager:ReqBattleScore()
end

function WinterStormBattleTopItemNew:Check205(curSec)
  local detailInfo
  local world = CS.SceneManager.World
  if self.centerIndex ~= nil then
    local info = world ~= nil and world:GetPointInfo(self.centerIndex) or nil
    if info ~= nil then
      self.centerIndex = nil
      self.config = nil
      detailInfo = info.detail
    end
  end
  if self.centerIndex == nil then
    local list = world ~= nil and world:GetAllDragonPointList() or {}
    local centerType = DataCenter.WinterStormTemplateManager:GetCenterType()
    for _, v in pairs(list) do
      local vDetail = v.detail
      if vDetail ~= nil then
        local config = DataCenter.WinterStormTemplateManager:GetTemplate(vDetail.BuildId)
        if config ~= nil and config.type == centerType then
          self.config = config
          self.centerIndex = v.pointIndex
          local info = world:GetPointInfo(self.centerIndex)
          if info ~= nil then
            detailInfo = info.detail
          end
          break
        end
      end
    end
  end
  local remainTime = 0
  local tmpState = 4
  if detailInfo ~= nil then
    local openTime = detailInfo.OpenTime or 0
    local closeTime = detailInfo.CloseTime or 0
    if curSec >= openTime and curSec < closeTime then
      remainTime = closeTime - curSec
      remainTime = 0 < remainTime and remainTime or 0
      tmpState = detailInfo.Side + 1
      if tmpState == 2 or tmpState == 3 then
        local mySide = awsMgr:GetMySide()
        tmpState = tmpState == mySide + 1 and 3 or 2
      end
    end
  end
  if self.curState ~= tmpState then
    self.curState = tmpState
    local path = string.format(LoadPath.LWBattleFieldWinterPath, IMG_PATH[tmpState])
    self.img_mid:LoadSpriteAsyncWithCallback(path, function()
      if self.img_mid then
        self.img_mid:SetNativeSize()
      end
    end)
  end
  if detailInfo ~= nil then
    local str = string.format("<color=%s>%ss</color>", TIME_COLOR[tmpState], remainTime)
    self.text_time:SetText(str)
    if self.speedFlag and 0 < self.lastUpdateScoreTime and curSec - self.lastUpdateScoreTime > 10 then
      Logger.LogWarning("[WinterStormBattle] over 10s have no score update!")
      self.lastUpdateScoreTime = 0
    end
  end
  return tmpState
end

function WinterStormBattleTopItemNew:Update1000MS()
  if not self.text_time or not self.text_time:GetActive() then
    return
  end
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  if self.endTime > 0 then
    local tmpState = self.bMain and self:Check205(curSec) or 4
    if tmpState == 4 then
      local remainTime = self.endTime - curSec
      if 0 < remainTime then
        local txt = UITimeManager:GetInstance():SecondToFmtStringWithoutHour(remainTime)
        self.text_time:SetText(txt)
        if self.speedFlag and 0 < self.lastUpdateScoreTime and curSec - self.lastUpdateScoreTime > 10 then
          Logger.LogWarning("[WinterStormBattle] over 10s have no score update!")
          self.lastUpdateScoreTime = 0
        end
      elseif self.bMain then
        self:ShowEndTime(self.bMain)
      end
    end
  end
  if self.bMain then
    if self.endTime == 0 then
      self:TrySendEnd(curSec)
    else
      local maxFlag = self.progress_blue:CheckMax() or self.progress_red:CheckMax()
      if maxFlag then
        self:TrySendEnd(curSec)
      end
    end
  end
end

function WinterStormBattleTopItemNew:ShowEndTime(bMain)
  self.bMain = bMain
  self.endTime = 0
  local mr = awsMgr:GetMarchResult()
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local beginTime = mr ~= nil and mr.battleBeginTime or 0
  if bMain and curTime < beginTime then
    self.endTime = beginTime
  else
    local endTime = mr ~= nil and mr.battleEndTime or 0
    if curTime < endTime then
      self.endTime = endTime
    end
  end
  self.btn:SetActive(bMain)
  self.bg:SetActive(bMain)
  self.text_time:SetActive(bMain)
  if bMain then
    local txt = UITimeManager:GetInstance():SecondToFmtStringWithoutHour(0)
    self.text_time:SetText(txt)
    local effPercent = LuaEntry.DataConfig:TryGetNum("winter_battlefield", "k29", 90) / 100
    self.progress_blue:SetEff(self.eff1, effPercent)
    self.progress_red:SetEff(self.eff2, effPercent)
  end
  self:Update1000MS()
  self:OnScoreRefresh()
  self:OnEntityChange()
end

function WinterStormBattleTopItemNew:UpdateNum(numCL, numCR, mySide)
  self.progress_blue:UpdateNum(numCL, false)
  self.progress_red:UpdateNum(numCR, false)
  if self.bMain and self.speedFlag and (toInt(numCL) > 0 or toInt(numCR) > 0) then
    self.lastUpdateScoreTime = UITimeManager:GetInstance():GetServerSeconds()
  end
end

function WinterStormBattleTopItemNew:OnScoreRefresh(info)
  if self.endTime <= 0 then
    return
  end
  local mySide = awsMgr:GetMySide()
  local otherSide = 0
  if mySide ~= 0 then
    otherSide = mySide == 2 and 1 or 2
  end
  if info == nil then
    local actInfo = awsMgr:GetActInfo()
    local battleScore = actInfo ~= nil and actInfo.battleScore or nil
    if battleScore ~= nil then
      local flag = false
      for side, score in pairs(battleScore) do
        if side == mySide then
          self.progress_blue:UpdateNum(score, false)
          if 0 < toInt(score) then
            flag = true
          end
        elseif side == otherSide then
          self.progress_red:UpdateNum(score, false)
          if 0 < toInt(score) then
            flag = true
          end
        end
      end
      if self.bMain and self.speedFlag and flag then
        self.lastUpdateScoreTime = UITimeManager:GetInstance():GetServerSeconds()
      end
    end
  else
    local playAnim = false
    if self.bMain then
      if 0 > info.updateScore then
        playAnim = true
      elseif info.buildUUID ~= nil and 0 < info.buildUUID then
        local world = CS.SceneManager.World
        local pointInfo = world ~= nil and world:GetPointInfoByUuid(info.buildUUID) or nil
        if pointInfo and pointInfo.detail ~= nil then
          local config = DataCenter.WinterStormTemplateManager:GetTemplate(pointInfo.detail.BuildId)
          if config ~= nil and config:IsDrop() then
            playAnim = true
          end
          local cityList = world:GetAllMainBaseList()
          for _, v in pairs(cityList) do
            if v.ownerUid == info.uid then
              for i = 1, 5 do
                TimerManager:GetInstance():DelayInvoke(function()
                  self:PlayScoreEff(info.buildUUID, i, pointInfo.pointIndex, v.pointIndex, info.updateScore)
                end, i * 0.1)
              end
              break
            end
          end
        else
          playAnim = true
        end
      end
    end
    local side = info.side
    local target = side == mySide and self.progress_blue or self.progress_red
    if self.bMain then
      target:PlayTip(info)
    end
    target:UpdateNum(info.score, playAnim)
    if self.bMain and self.speedFlag and (0 < toInt(info.score) or toInt(info.updateScore) ~= 0) then
      self.lastUpdateScoreTime = UITimeManager:GetInstance():GetServerSeconds()
    end
  end
end

function WinterStormBattleTopItemNew:OnEntityChange(pointIndex)
  if self.endTime <= 0 or not self.bMain then
    return
  end
  local world = CS.SceneManager.World
  local list = world ~= nil and world:GetAllDragonPointList() or nil
  local mySide = awsMgr:GetMySide()
  local otherSide = 0
  if mySide ~= 0 then
    otherSide = mySide == 2 and 1 or 2
  end
  if list == nil or table.length(list) == 0 then
    return
  end
  local lNum, rNum = 0, 0
  for _, v in pairs(list) do
    local detailInfo = v.detail
    if detailInfo ~= nil then
      local config = wstMgr:GetTemplate(detailInfo.BuildId)
      if config ~= nil and config:IsBuild() then
        local side = detailInfo.Side
        if side == mySide then
          lNum = lNum + config.point_produce_per_second
        elseif side == otherSide then
          rNum = rNum + config.point_produce_per_second
        end
      end
    end
  end
  self.speedFlag = 0 < lNum or 0 < rNum
  self.progress_blue:UpdateSpeed(lNum)
  self.progress_red:UpdateSpeed(rNum)
end

function WinterStormBattleTopItemNew:PlayScoreEff(uuid, i, buildPointIndex, playerPointIndex, score)
  local key = uuid .. "_" .. i
  local seq = self.seqScores[key]
  if seq ~= nil then
    seq:Pause()
    seq:Kill()
    self.seqScores[key] = nil
  end
  local request = self.reqScores[key]
  if request ~= nil then
    self:DoPlayScoreEff(uuid, i, buildPointIndex, playerPointIndex, score)
    return
  end
  request = Resource:InstantiateAsync(EFF_SCORE_PATH)
  self.reqScores[key] = request
  request:completed("+", function(req)
    local _go = req.gameObject
    if MyIsNull(_go) then
      if req ~= nil then
        req:Destroy()
      end
      self.reqScores[key] = nil
      return
    end
    _go.name = "EFF_SCORE_PATH_" .. key
    local world = CS.SceneManager.World
    if world then
      _go.transform:SetParent(world.DynamicObjNode)
    end
    self:DoPlayScoreEff(uuid, i, buildPointIndex, playerPointIndex, score)
  end)
end

function WinterStormBattleTopItemNew:DoPlayScoreEff(uuid, i, buildPointIndex, playerPointIndex, score)
  local key = uuid .. "_" .. i
  local req = self.reqScores[key]
  if not req.isDone then
    return
  end
  local go = req.gameObject
  if MyIsNull(go) then
    if req ~= nil then
      req:Destroy()
    end
    self.reqScores[key] = nil
    return
  end
  local posFrom = SceneUtils.TileIndexToWorld(buildPointIndex, ForceChangeScene.World)
  local posTo = SceneUtils.TileIndexToWorld(playerPointIndex, ForceChangeScene.World)
  go:SetActive(true)
  local tf = go.transform
  tf:Set_localPosition(posFrom.x, posFrom.y, posFrom.z)
  local eff_root = tf:Find(eff_jifen_path)
  eff_root.gameObject:SetActive(true)
  local particle = eff_root:GetComponent(typeofPS)
  if particle ~= nil then
    particle:Play()
  end
  local score_root = tf:Find(img_flag_path)
  score_root.gameObject:SetActive(false)
  local score_text = tf:Find(text_num_path):GetComponent(typeofTM)
  score_text.text = "+" .. score
  local sequence = CS.DG.Tweening.DOTween.Sequence()
  self.seqScores[key] = sequence
  local time = 1
  local partTime = 0.5
  local moveToPos = Vector3.New(posFrom.x, posFrom.y, posFrom.z)
  local random = MyRand(5, 10)
  local dirX, dirZ = 1, 1
  if i == 1 then
    dirX = 0
  elseif i == 3 then
    dirZ = -1
  elseif i == 4 then
    dirX = -1
    dirZ = -1
  elseif i == 5 then
    dirX = -1
  end
  moveToPos.x = moveToPos.x + dirX * random
  moveToPos.z = moveToPos.z + dirZ * random
  sequence:Append(tf:DOLocalMove(moveToPos, partTime):SetEase(CS.DG.Tweening.Ease.OutCirc))
  sequence:Append(tf:DOLocalMove(Vector3.New(posTo.x, posTo.y, posTo.z), time):SetEase(CS.DG.Tweening.Ease.OutCirc))
  sequence:AppendCallback(function()
    eff_root.gameObject:SetActive(false)
    score_root.gameObject:SetActive(true)
  end)
  if i == 1 then
    sequence:Append(tf:DOLocalMoveY(1, 0.5))
  end
  sequence:AppendCallback(function()
    go:SetActive(false)
  end)
end

function WinterStormBattleTopItemNew:TrySendEnd(curSec)
  if not self.bMain then
    return
  end
  local rFlag = false
  local mr = DataCenter.ActWinterStormManager:GetMarchResult()
  if mr == nil or mr.marchId == 0 then
    rFlag = true
  else
    local result = DataCenter.ActWinterStormManager:GetResult()
    if result ~= nil then
      rFlag = true
    end
  end
  if rFlag and UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWinterStormBattleResultS0) then
    return
  end
  if self.signTime == nil then
    self.signTime = curSec
    return
  end
  if curSec - self.signTime < 5 then
    return
  end
  DataCenter.ActWinterStormManager:SendResult()
  self.signTime = curSec
end

return WinterStormBattleTopItemNew
