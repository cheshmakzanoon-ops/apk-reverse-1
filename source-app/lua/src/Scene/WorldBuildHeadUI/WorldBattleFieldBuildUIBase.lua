local WorldBattleFieldBuildUIBase = BaseClass("WorldBattleFieldBuildUIBase")
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local padding = 0.3
local top_root_path = "Top"
local jifen_explode_path = "Top/jifen"
local jifen_shuaguang_path = "Top/jifen_shuaguang"
local top_head_path = "Top/TopHead"
local top_bg_path = "Top/TopHead/TopBg"
local top_arrow_path = "Top/TopHead/TopArrow"
local top_progress_path = "Top/TopHead/Progress"
local top_tip_progress_path = "Top/TopHead/Progress/TipsProgress"
local head_def_path = "Top/TopHead/Head/HeadDef"
local head_none_path = "Top/TopHead/Head/HeadDef/HeadNone"
local head_icon_path = "Top/TopHead/Head"
local bottom_path = "Bottom"
local name_path = "Bottom/name"
local status_path = "Bottom/status"
local status_text_path = "Bottom/status/statusText"
local point_root_path = "Bottom/pointRoot"
local point_flag_path = "Bottom/pointRoot/flag"
local point_text_path = "Bottom/pointRoot/pointText"
local safe_root_path = "Bottom/safeRoot"
local safe_flag_path = "Bottom/safeRoot/flag"
local safe_text_path = "Bottom/safeRoot/safeText"
local safe_p_bg_path = "Bottom/safeRoot/safePBg"
local safe_progress_path = "Bottom/safeRoot/safePBg/safeProgress"
local safe_time_text_path = "Bottom/safeRoot/safePBg/timeText"
local tip_a_root_path = "TipAImgRoot"
local tip_a_bg_img_path = "TipAImgRoot/TipAImgImg"
local tip_a_img_path = "TipAImgRoot/TipAImgImg/TipAImg"
local tip_a_text_path = "TipAImgRoot/TipAImgImg/numAText"
local middle_path = "Middle"
local middle_icon_path = "Middle/MiddleIcon"
local middle_icon_front_path = "Middle/MiddleIconFront"
local middle_icon_text_path = "Middle/MiddleIconText"
local middle_text_path = "middleText"
local TopDiBlue = "zyf_jianzhuzhuangtai_qipao5.png"
local TopArrBlue = "zyf_jianzhuzhuangtai_qipao6.png"
local TopDiRed = "zyf_jianzhuzhuangtai_qipao1.png"
local TopArrRed = "zyf_jianzhuzhuangtai_qipao2.png"
local Hp_Green_Path = "lrb_dongjifengbao_zhanchang_touxiangxietiao02.png"
local Hp_Yellow_Path = "lrb_dongjifengbao_zhanchang_touxiangxietiao01.png"
local Hp_Red_Path = "lrb_dongjifengbao_zhanchang_touxiangxietiao03.png"
local Point_Blue_Path = "lrb_zhanchangjifen_bglan.png"
local Point_Red_Path = "lrb_zhanchangjifen_bghong.png"
local None_Blue_Path = "lrb_zhanchangjifen_wurenzhanling_lan.png"
local None_Red_Path = "lrb_zhanchangjifen_wurenzhanling_hong.png"
local Timer_Blue_Path = "lrb_dongjifengbao_jindutiao03.png"
local Timer_Red_Path = "lrb_dongjifengbao_jindutiao02.png"

function WorldBattleFieldBuildUIBase:OnCreate(go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  
  function self.timer_action(temp)
    self:TimerAction()
  end
  
  self.baseX, self.baseY, self.baseZ = self.gameObject.transform:Get_localPosition()
  local TypeSpriteRenderer = typeof(CS.UnityEngine.SpriteRenderer)
  local TypeSuperTextMesh = typeof(CS.SuperTextMesh)
  local headType = typeof(CS.UIPlayerHead)
  self.topRoot = self.transform:Find(top_root_path).transform
  self.theJifen = self.transform:Find(jifen_explode_path).gameObject
  self.theJifen:GameObjectCreatePool()
  self.jifen_effect_particle = self.transform:Find(jifen_shuaguang_path):GetComponent(typeof(CS.UnityEngine.ParticleSystem))
  self.top_head = self.transform:Find(top_head_path).transform
  self.top_bg = self.transform:Find(top_bg_path):GetComponent(TypeSpriteRenderer)
  self.top_arrow = self.transform:Find(top_arrow_path):GetComponent(TypeSpriteRenderer)
  self.top_progress = self.transform:Find(top_progress_path):GetComponent(TypeSpriteRenderer)
  self.top_tip_progress = self.transform:Find(top_tip_progress_path):GetComponent(TypeSpriteRenderer)
  self.head_def = self.transform:Find(head_def_path):GetComponent(TypeSpriteRenderer)
  self.head_none = self.transform:Find(head_none_path):GetComponent(TypeSpriteRenderer)
  self.head_icon = self.transform:Find(head_icon_path):GetComponent(headType)
  self.bottomRoot = self.transform:Find(bottom_path).transform
  self.name = self.transform:Find(name_path):GetComponent(TypeSuperTextMesh)
  self.statusRoot = self.transform:Find(status_path):GetComponent(TypeSpriteRenderer)
  self.status_text = self.transform:Find(status_text_path):GetComponent(TypeSuperTextMesh)
  self.pointRoot = self.transform:Find(point_root_path):GetComponent(TypeSpriteRenderer)
  self.point_flag = self.transform:Find(point_flag_path):GetComponent(TypeSpriteRenderer)
  self.point_text = self.transform:Find(point_text_path):GetComponent(TypeSuperTextMesh)
  self.safeRoot = self.transform:Find(safe_root_path):GetComponent(TypeSpriteRenderer)
  self.safe_flag = self.transform:Find(safe_flag_path):GetComponent(TypeSpriteRenderer)
  self.safe_text = self.transform:Find(safe_text_path):GetComponent(TypeSuperTextMesh)
  self.safe_progress_bg = self.transform:Find(safe_p_bg_path):GetComponent(TypeSpriteRenderer)
  self.safe_progress = self.transform:Find(safe_progress_path):GetComponent(TypeSpriteRenderer)
  self.safe_time_text = self.transform:Find(safe_time_text_path):GetComponent(TypeSuperTextMesh)
  self.tip_a_root = self.transform:Find(tip_a_root_path).transform
  self.tip_a_bg_img = self.transform:Find(tip_a_bg_img_path):GetComponent(TypeSpriteRenderer)
  self.tip_a_img = self.transform:Find(tip_a_img_path):GetComponent(TypeSpriteRenderer)
  self.tip_a_text = self.transform:Find(tip_a_text_path):GetComponent(TypeSuperTextMesh)
  self.middle_root = self.transform:Find(middle_path).transform
  self.middle_icon = self.transform:Find(middle_icon_path):GetComponent(TypeSpriteRenderer)
  self.middle_icon_front = self.transform:Find(middle_icon_front_path):GetComponent(TypeSpriteRenderer)
  self.middle_icon_text = self.transform:Find(middle_icon_text_path):GetComponent(TypeSuperTextMesh)
  self.middle_text = self.transform:Find(middle_text_path):GetComponent(TypeSuperTextMesh)
end

function WorldBattleFieldBuildUIBase:OnDestroy()
  self:HideProtectEffect()
  self.theJifen:GameObjectRecycleAll()
  self:DeleteTimer()
  self.topRoot = nil
  self.top_arrow = nil
  self.top_head = nil
  self.top_bg = nil
  self.head_icon = nil
  self.head_def = nil
  self.head_none = nil
  self.bottomRoot = nil
  self.name = nil
  self.statusRoot = nil
  self.status_text = nil
  self.pointRoot = nil
  self.point_flag = nil
  self.point_text = nil
  self.safeRoot = nil
  self.safe_flag = nil
  self.safe_text = nil
  self.safe_progress_bg = nil
  self.safe_progress = nil
  self.safe_time_text = nil
  self.tip_a_root = nil
  self.tip_a_bg_img = nil
  self.tip_a_img = nil
  self.tip_a_text = nil
  self.middle_text = nil
  self.timer_action = nil
  self.detailInfo = nil
end

function WorldBattleFieldBuildUIBase:ReInitInfo()
  local mapPointInfo = CS.SceneManager.World:GetPointInfo(self.pointId)
  self.mapPointInfo = mapPointInfo
  self.buildUUID = mapPointInfo ~= nil and mapPointInfo.uuid or nil
  self.detailInfo = mapPointInfo ~= nil and mapPointInfo.detail or nil
end

function WorldBattleFieldBuildUIBase:ReInit(pointId, mapPointInfo)
  self.pointId = pointId
  self.mapPointInfo = mapPointInfo
  self.buildUUID = mapPointInfo ~= nil and mapPointInfo.uuid or nil
  self.detailInfo = mapPointInfo ~= nil and mapPointInfo.detail or nil
  if self.detailInfo then
    self.buildId = self.detailInfo.BuildId or self.detailInfo.ItemId
    self:InitConfig()
    local pos_up = self.config ~= nil and self.config.pos_up or {}
    self.topRoot:Set_localPosition(pos_up[1] or 0, pos_up[2] or 0, pos_up[3] or 0)
    self.tip_a_root:Set_localPosition(pos_up[1] or 0, pos_up[2] or 0, pos_up[3] or 0)
    local pos_down = self.config ~= nil and self.config.pos_down or {}
    self.bottomRoot:Set_localPosition(pos_down[1] or 0, pos_down[2] or 0, pos_down[3] or 0)
  end
  self.name.text = Localization:GetString(self.config ~= nil and self.config.name or "")
  self:UpdateStatus()
end

function WorldBattleFieldBuildUIBase:UpdateData(pointId, mapPointInfo)
  if self.pointId ~= pointId or self.buildId == self.SP_ID then
    return
  end
  self.mapPointInfo = mapPointInfo
  self.buildUUID = mapPointInfo ~= nil and mapPointInfo.uuid or nil
  self.detailInfo = mapPointInfo ~= nil and mapPointInfo.detail or nil
  if self.detailInfo then
    self:UpdateStatus()
  end
end

function WorldBattleFieldBuildUIBase:ShowProtectEffect()
  if self.ProtectEffectRequest ~= nil then
    return
  end
  local request = ResourceManager:InstantiateAsync("Assets/Main/Prefabs/World/hudun_1.prefab")
  self.ProtectEffectRequest = request
  self.simpleAnim = nil
  request:completed("+", function()
    if request.isError then
      return
    end
    local theScale = 0.6
    local pointId = self.pointId
    if BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
      theScale = 0.8
      pointId = pointId + 1000
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    request.gameObject.transform:Set_localScale(theScale, theScale, theScale)
    request.gameObject.transform.position = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
    local anim = request.gameObject.transform:Find("anim")
    if anim then
      self.simpleAnim = anim:GetComponent(typeof(CS.SimpleAnimation))
      if self.simpleAnim then
        self.simpleAnim:Play("show")
      end
    end
  end)
end

function WorldBattleFieldBuildUIBase:HideProtectEffect()
  if self.simpleAnim then
    self.simpleAnim:Play("hide")
    self.simpleAnim = nil
  end
  local request = self.ProtectEffectRequest
  if request ~= nil then
    request:Destroy()
    self.ProtectEffectRequest = nil
  end
end

function WorldBattleFieldBuildUIBase:AddTimer()
  self:DeleteTimer()
  self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  self.timer:Start()
end

function WorldBattleFieldBuildUIBase:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function WorldBattleFieldBuildUIBase:UpdateLod(lod)
  if not IsNull(self.gameObject) and not IsNull(self.gameObject.transform) then
    if lod == 1 then
      self.gameObject.transform:Set_localScale(1, 1, 1)
      self.gameObject.transform:Set_localPosition(self.baseX, self.baseY, self.baseZ)
    else
      local mainCamera = CS.UnityEngine.Camera.main
      if mainCamera and mainCamera.transform then
        local x, y, z = mainCamera.transform:Get_localPosition()
        local scale = 1 - 0.4 * (y - 80) / 220
        local yy = 2 * (y - 80) / 220
        self.gameObject.transform:Set_localScale(scale, scale, 1)
        self.gameObject.transform:Set_localPosition(self.baseX, self.baseY + yy, self.baseZ)
      end
    end
  end
end

function WorldBattleFieldBuildUIBase:UpdateHeadSp(bBlue)
  self.top_bg:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldPath, bBlue and TopDiBlue or TopDiRed))
  if not self.head_def.gameObject.activeSelf then
    self.head_none:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldPath, bBlue and None_Blue_Path or None_Red_Path))
  end
  if self.pointRoot.gameObject.activeSelf then
    self.pointRoot:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldPath, bBlue and Point_Blue_Path or Point_Red_Path))
  end
  if self.safeRoot.gameObject.activeSelf then
    self.safe_progress:LoadSpriteAuto(string.format(LoadPath.LWCommonPath, bBlue and Timer_Blue_Path or Timer_Red_Path))
  end
  self.top_arrow:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldPath, bBlue and TopArrBlue or TopArrRed))
end

function WorldBattleFieldBuildUIBase:UpdateHp(percent)
  if self.hpPercent == percent then
    return
  end
  local curState = self.hpPercent ~= nil and self:GetHpState(self.hpPercent) or 0
  local newState, path = self:GetHpState(percent)
  self.hpPercent = percent
  local s_x, s_y = self.top_progress:Get_size()
  local per = 0.94
  local tmp_x = s_x * per * percent
  local tmp_y = s_y * 0.75
  self.top_tip_progress:Set_size(tmp_x, tmp_y)
  local px, py, pz = self.top_tip_progress.gameObject.transform:Get_localPosition()
  px = (tmp_x - s_x * per) / 2
  self.top_tip_progress.gameObject.transform:Set_localPosition(px, py, pz)
  if newState ~= curState then
    self.top_tip_progress:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldPath, path))
  end
end

function WorldBattleFieldBuildUIBase:UpdateTimer(percent)
  if self.timerPercent == percent then
    return
  end
  self.timerPercent = percent
  local s_x, s_y = self.safe_progress_bg:Get_size()
  local per = 1
  local tmp_x = s_x * per * percent
  local tmp_y = s_y * 1
  self.safe_progress:Set_size(tmp_x, tmp_y)
  local px, py, pz = self.safe_progress.gameObject.transform:Get_localPosition()
  px = (tmp_x - s_x * per) / 2
  self.safe_progress.gameObject.transform:Set_localPosition(px, py, pz)
end

function WorldBattleFieldBuildUIBase:GetHpState(percent)
  local path = ""
  local state = 0
  if 0.7 < percent then
    state = 3
    path = Hp_Green_Path
  elseif percent < 0.3 then
    state = 1
    path = Hp_Red_Path
  else
    state = 2
    path = Hp_Yellow_Path
  end
  return state, path
end

function WorldBattleFieldBuildUIBase:FixPos(text, flag, root, add, w, offSet)
  offSet = offSet or 0
  local s_x = self:FixWidth(text, root, add)
  local x, y, z = text.transform:Get_localPosition()
  x = -s_x / 2 + w * 2 + offSet
  text.transform:Set_localPosition(x, y, z)
  x, y, z = flag.transform:Get_localPosition()
  x = -s_x / 2 + w + offSet
  flag.transform:Set_localPosition(x, y, z)
end

function WorldBattleFieldBuildUIBase:FixWidth(text, root, add)
  local textWidth = text:GetWidth()
  local s_x, s_y
  if root then
    s_x, s_y = root:Get_size()
  end
  s_x = textWidth + padding + add
  if root then
    root:Set_size(s_x, s_y)
  end
  return s_x
end

local function CalculateCubicBezierPointFor2C(t, p0, p1, p2)
  local u = 1 - t
  local tt = t * t
  local uu = u * u
  local p = uu * p0
  p = p + 2 * u * t * p1
  p = p + tt * p2
  return p
end

local SEGMENT_COUNT = 20
local paths = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Vector3), SEGMENT_COUNT)

local function Bezier2Path(startPos, controlPos, endPos)
  for i = 1, SEGMENT_COUNT do
    local t = i / SEGMENT_COUNT
    local pixel = CalculateCubicBezierPointFor2C(t, startPos, controlPos, endPos)
    paths[i - 1] = pixel
  end
  return paths
end

function WorldBattleFieldBuildUIBase:OnDragonScoreExplode(mainPoint, scorePoints)
  local jifen_effect = self.jifen_effect_particle
  jifen_effect.gameObject:SetActive(true)
  jifen_effect:Play()
  TimerManager:GetInstance():DelayInvoke(function()
    jifen_effect:Stop()
    jifen_effect.gameObject:SetActive(false)
    local TypePS = typeof(CS.UnityEngine.ParticleSystem)
    local Tweening = CS.DG.Tweening
    local MyStr = tostring
    local myRandom = math.random
    local posFrom = SceneUtils.TileIndexToWorld(mainPoint, ForceChangeScene.World)
    for _, explodeIndex in ipairs(scorePoints) do
      local posTo = SceneUtils.TileIndexToWorld(explodeIndex, ForceChangeScene.World)
      local effectItem = self.theJifen:GameObjectSpawn()
      local jifen_particle = effectItem.transform:GetComponent(TypePS)
      if jifen_particle ~= nil then
        effectItem.name = MyStr(explodeIndex)
        effectItem:SetActive(true)
        effectItem.transform:Set_localPosition(posFrom.x, posFrom.y, posFrom.z)
        local startPos = Vector3.New(posFrom.x, posFrom.y, posFrom.z)
        local destPos = Vector3.New(posTo.x, posTo.y, posTo.z)
        local curveTime = 2.0
        local pointOffset = Vector3.New(0, myRandom(3, 7), 0)
        local controlPos = (startPos + destPos) * 0.5 + pointOffset
        local pathVec = Bezier2Path(startPos, controlPos, destPos)
        local seq = Tweening.DOTween.Sequence()
        seq:Append(effectItem.transform:DOPath(pathVec, curveTime)):SetEase(Tweening.Ease.Linear)
        
        function seq.onComplete()
          effectItem:GameObjectRecycle()
        end
      else
        effectItem:GameObjectRecycle()
      end
    end
  end, 1.0)
end

function WorldBattleFieldBuildUIBase:ShowDamageNum(number)
  if self.detailInfo == nil then
    return
  end
  local bSelf = self:BSelf()
  BattleFieldUtil.PlaySoliderNumChange(bSelf, self.pointId, number)
end

function WorldBattleFieldBuildUIBase:InitConfig()
end

function WorldBattleFieldBuildUIBase:UpdateStatus()
end

function WorldBattleFieldBuildUIBase:TimerAction()
end

function WorldBattleFieldBuildUIBase:BSelf()
  return false
end

function WorldBattleFieldBuildUIBase:OnRoleChanged(role)
end

function WorldBattleFieldBuildUIBase:GetHeadIcon()
  return self.head_icon
end

return WorldBattleFieldBuildUIBase
