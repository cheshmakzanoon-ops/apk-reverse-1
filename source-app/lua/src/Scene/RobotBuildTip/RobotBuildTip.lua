local RobotBuildTip = BaseClass("RobotBuildTip")
local add_des_text_path = "PosGo/addDes"
local add_num_text_path = "PosGo/addNum"
local icon_path = "PosGo/Bg/icon"
local PositionDelta7 = Vector3.New(-6, 5, -6)
local PositionDelta = Vector3.New(0, 5, 0)

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
end

local function ComponentDefine(self)
  self.add_des_text = self.transform:Find(add_des_text_path):GetComponent(typeof(CS.SuperTextMesh))
  self.add_num_text = self.transform:Find(add_num_text_path):GetComponent(typeof(CS.SuperTextMesh))
  self.icon = self.transform:Find(icon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.isDoAnim = false
  
  function self.__update_handle()
    self:Update()
  end
  
  UpdateManager:GetInstance():AddUpdate(self.__update_handle)
end

local function ComponentDestroy(self)
  self.add_des_text = nil
  self.icon = nil
  self.add_num_text = nil
end

local function RemoveTimer(self)
  UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
  self.__update_handle = nil
end

local function StartShowTip(self, param)
  self.data = param
  self:UpdatePosition(self.data.pointId)
  self:RefreshShow(self.data.icon, self.data.nameStr, self.data.numStr)
end

local function RefreshShow(self, icon, nameStr, numStr)
  self.icon:LoadSprite(icon)
  self.add_des_text.text = nameStr
  self.add_num_text.text = numStr
  self.curTime = 0
  self.isDoAnim = true
  self:Update()
end

local function Update(self)
  if self.isDoAnim then
    self.curTime = self.curTime + Time.deltaTime
    if self.curTime > 2.5 then
      self:RemoveTimer()
      RobotBuildTipManager:GetInstance():RemoveOneEffect(self.data.bUuid)
    else
    end
  end
end

local function UpdatePosition(self, index)
  local worldPos
  if self.data.tileX == BuildTilesSize.Seven then
    worldPos = SceneUtils.TileIndexToWorld(index) + PositionDelta7 + PositionDelta
  else
    worldPos = BuildingUtils.GetBuildModelDownVec(index, self.data.tileX, self.data.tileY) + PositionDelta
  end
  self.transform.position = worldPos
end

RobotBuildTip.OnCreate = OnCreate
RobotBuildTip.OnDestroy = OnDestroy
RobotBuildTip.ComponentDefine = ComponentDefine
RobotBuildTip.ComponentDestroy = ComponentDestroy
RobotBuildTip.RefreshShow = RefreshShow
RobotBuildTip.UpdatePosition = UpdatePosition
RobotBuildTip.Update = Update
RobotBuildTip.StartShowTip = StartShowTip
RobotBuildTip.RemoveTimer = RemoveTimer
return RobotBuildTip
