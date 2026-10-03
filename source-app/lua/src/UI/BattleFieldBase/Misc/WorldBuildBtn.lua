local WorldBuildBtn = BaseClass("WorldBuildBtn", UIAsyncContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local btn_path = ""
local arrow_path = "Arrow"
local icon_path = "Icon"
local name_path = "Name"
local leftPadding = 350
local topPadding = 450
local BgRotationDelta = Vector3.New(0, 0, 0)

function WorldBuildBtn:OnCreate()
  base.OnCreate(self)
  local ok, errorMsg = pcall(function()
    self:ComponentDefine()
    self:DataDefine()
    self:UpdateMilePointer()
  end)
  if not ok and errorMsg then
    Logger.LogError(errorMsg)
  end
end

function WorldBuildBtn:OnDestroy()
  self.polygon = nil
  self.btnActive = nil
  self.arrowRotation = nil
  self.btnPosX = nil
  self.btnPosY = nil
  self.buildId = nil
  self.role = nil
  self.constructPos = nil
  self.disText = nil
  base.OnDestroy(self)
end

function WorldBuildBtn:ComponentDefine()
  self.btn = self:AddComponent(UIButton, btn_path)
  self.arrow = self:AddComponent(UIImage, arrow_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    if self.constructPos ~= nil then
      GoToUtil.GotoDragonPos(self.constructPos, CS.SceneManager.World.InitZoom)
    end
  end)
end

function WorldBuildBtn:DataDefine()
  self.polygon = nil
  self.btnActive = nil
  self.arrowRotation = nil
  self.btnPosX = nil
  self.btnPosY = nil
  self.buildId = nil
  self.role = nil
  self.constructPos = nil
  self.disText = Localization:GetString(GameDialogDefine.KILOMETRE)
end

function WorldBuildBtn:SetRange(points)
  self.polygon = points or {}
end

function WorldBuildBtn:GetRange()
  if table.IsNullOrEmpty(self.polygon) then
    local points = {}
    local width, height = Screen.width, Screen.height
    table.insert(points, {leftPadding, topPadding})
    table.insert(points, {
      width - leftPadding,
      topPadding
    })
    table.insert(points, {
      width - leftPadding,
      height - topPadding
    })
    table.insert(points, {
      leftPadding,
      height - topPadding
    })
    self.polygon = points
  end
  return self.polygon
end

function WorldBuildBtn:UpdateMilePointer(constructPos, buildId, role, parentCom)
  if constructPos ~= nil and CS.SceneManager:IsInWorld() then
    local rect = parentCom.rectTransform.rect
    local show, dist, _, _, eulerAngles_z, mainScreenPos = UIUtil.CalcConstructMilePointer(0, 0, constructPos, CS.SceneManager.World.CurTarget, rect)
    if show and 0 < dist then
      self.constructPos = constructPos
      self:SetBtnActive(true)
      self:SetArrowRotation(eulerAngles_z)
      self:SetBtnPos(mainScreenPos.x, mainScreenPos.y)
      self:SetBtnName(dist .. self.disText)
      self:LoadImg(buildId, role)
      return
    end
  end
  self.constructPos = nil
  self:SetBtnActive(false)
end

function WorldBuildBtn:SetBtnActive(value)
  if self.btnActive == value then
    return
  end
  self.btnActive = value
  self.btn:SetActive(value)
end

local function Distance(x1, y1, x2, y2)
  local dx = x2 - x1
  local dy = y2 - y1
  return math.sqrt(dx * dx + dy * dy)
end

function WorldBuildBtn:FixXY(x, y)
  local polygon = self.polygon
  local inside = false
  local minDist = math.huge
  local fixX, fixY
  for i = 1, #polygon do
    local j = i % #polygon + 1
    local xi, yi = polygon[i][1], polygon[i][2]
    local xj, yj = polygon[j][1], polygon[j][2]
    local intersect = y < yi ~= (y < yj) and x < (xj - xi) * (y - yi) / (yj - yi) + xi
    if intersect then
      inside = not inside
    end
    local dx = xj - xi
    local dy = yj - yi
    local t = ((x - xi) * dx + (y - yi) * dy) / (dx * dx + dy * dy)
    local nx, ny
    if t < 0 then
      nx, ny = xi, yi
    elseif 1 < t then
      nx, ny = xj, yj
    else
      nx = xi + t * dx
      ny = yi + t * dy
    end
    local dist = Distance(x, y, nx, ny)
    if minDist > dist then
      minDist = dist
      fixX = nx
      fixY = ny
    end
  end
  if inside then
    return x, y
  end
  return fixX, fixY
end

function WorldBuildBtn:SetBtnPos(posX, posY)
  if CommonUtil.IsArabicAutoMirrorOpen() then
    posX = Screen.width - posX
  end
  local x, y = self:FixXY(posX, posY)
  if self.btnPosX == x and self.btnPosY == y then
    return
  end
  self.btnPosX = x
  self.btnPosY = y
  self.btn:SetAnchoredPositionXY(x, y)
end

function WorldBuildBtn:SetArrowRotation(value)
  if self.arrowRotation == value then
    return
  end
  self.arrowRotation = value
  self.arrow:SetEulerAnglesXYZ(0, 0, BgRotationDelta.z + value)
end

function WorldBuildBtn:SetBtnName(value)
  if self.nameStr == value then
    return
  end
  self.nameStr = value
  self.name:SetText(value)
end

function WorldBuildBtn:LoadImg(buildId, role)
  if self.buildId == buildId and self.role == role then
    return
  end
  self.buildId = buildId
  self.role = role
  if buildId == nil and role == nil then
    return
  end
  local config = DataCenter.EpidemicBuildTemplateMgr:GetTemplate(buildId)
  local path = string.format(LoadPath.LWBattleFieldEpidemicPath, config.small_map_icon .. "0")
  self.icon:LoadSpriteAuto(path)
  local path1, path2, hexValue
  if role == EpidemicZoneRole.Default then
    path1 = "mjc_yibianjinqu_daditu_weizhi_01_huang"
    path2 = "mjc_yibianjinqu_daditu_weizhi_02_huang"
    hexValue = "fff2c7"
  else
    local bEnemy = BattleFieldUtil.IsBattleFieldEnemy(role, BattleFieldType.EpidemicZone)
    path1 = bEnemy and "mjc_yibianjinqu_daditu_weizhi_01_hong" or "mjc_yibianjinqu_daditu_weizhi_01_lan"
    path2 = bEnemy and "mjc_yibianjinqu_daditu_weizhi_02_hong" or "mjc_yibianjinqu_daditu_weizhi_02_lan"
    hexValue = bEnemy and "ffcdb4" or "b4dcff"
  end
  if not string.IsNullOrEmpty(path1) then
    self.btn:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldEpidemicPath, path1))
    self.arrow:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldEpidemicPath, path2))
    self.icon:SetColorHex(hexValue)
  end
end

return WorldBuildBtn
