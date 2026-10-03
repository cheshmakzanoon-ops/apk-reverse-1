local HSRView = BaseClass("HSRView")
local HSRCarriage = require("DataCenter.LWRailway.HighSpeedRailway.HSRCarriage")
local Resource = CS.GameEntry.Resource
local Icon_Path = {
  [HSRDirection.East] = "Assets/Main/SeasonRes/S5/Sprites/HighSpeedRailway/lyt_S5_wujisuofang_huoche2.png",
  [HSRDirection.West] = "Assets/Main/SeasonRes/S5/Sprites/HighSpeedRailway/lyt_S5_wujisuofang_huoche1.png",
  [HSRDirection.South] = "Assets/Main/SeasonRes/S5/Sprites/HighSpeedRailway/lyt_S5_wujisuofang_huoche4.png",
  [HSRDirection.North] = "Assets/Main/SeasonRes/S5/Sprites/HighSpeedRailway/lyt_S5_wujisuofang_huoche3.png"
}

function HSRView:__init()
  self.refreshHeadIndex = 1
end

function HSRView:__delete()
  self:Destroy()
end

function HSRView:Destroy()
  self:RemoveView()
  self.hsrData = nil
end

function HSRView:RemoveView()
  if self.req then
    self.req:Destroy()
    self.req = nil
  end
  self.transform = nil
  self.sprite = nil
  self.direction = nil
  if self.trigger then
    self.trigger.onPointerClick = nil
  end
  if self.hsrCarriages then
    for _, v in pairs(self.hsrCarriages) do
      v:Destroy()
    end
  end
  self.hsrCarriages = {}
end

function HSRView:Init(hsrData)
  self.hsrData = hsrData
  self:RemoveView()
  if not self.req then
    self.req = Resource:InstantiateAsync("Assets/Main/SeasonRes/S5/Prefabs/World/WorldTroopHSR.prefab")
    self.req:completed("+", function(request)
      local go = request.gameObject
      if IsNull(go) then
        return
      end
      local transform = go.transform
      self.transform = transform
      transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      transform:Set_eulerAngles(0, 0, 0)
      local now = UITimeManager:GetInstance():GetServerTime()
      local pos, dir = self.hsrData:GetPosition(now)
      transform:Set_position(pos.x, 0, pos.z)
      local model = transform:Find("Model")
      self.sprite = transform:Find("Icon/Sprite"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
      self.trigger = transform:GetComponent(typeof(CS.TouchObjectEventTrigger))
      self.trigger.previewName = CS.GameEntry.Localization:GetString("activity_1200044_tips1")
      self.trigger.previewIconPath = "Assets/Main/SeasonRes/S5/Sprites/HighSpeedRailway/LXYS5_zhanquhuoche_icon01.png"
      self.trigger.previewType = CS.WorldPreviewType.HSR
      
      function self.trigger.onPointerClick()
        self:OnClick()
      end
      
      self.hsrCarriages = {}
      for i = 0, self.hsrData:GetCarriageCount() do
        local carriage = HSRCarriage.New()
        carriage:Init(self.hsrData, i, model)
        table.insert(self.hsrCarriages, carriage)
      end
    end)
  end
end

function HSRView:OnUpdate()
  if self.transform then
    local now = UITimeManager:GetInstance():GetServerTime()
    local pos, dir = self.hsrData:GetPosition(now)
    self:SetDirection(dir)
    self.transform:Set_position(pos.x, 0, pos.z)
    if self.hsrCarriages then
      for _, v in pairs(self.hsrCarriages) do
        v:OnUpdate(now)
      end
      local carriageCount = #self.hsrCarriages
      self.refreshHeadIndex = self.refreshHeadIndex + 1
      if carriageCount < self.refreshHeadIndex then
        self.refreshHeadIndex = 2
      end
      if self.hsrCarriages[self.refreshHeadIndex] then
        self.hsrCarriages[self.refreshHeadIndex]:LazyRefreshHead()
      end
    end
  end
end

function HSRView:SetDirection(dir)
  if not self.sprite then
    return
  end
  if self.direction == dir then
    return
  end
  self.direction = dir
  self.sprite:LoadSprite(Icon_Path[dir])
end

function HSRView:OnClick()
  if CS.SDKManager.IS_UNITY_EDITOR() then
    if CS.GMSwitch.FocusMyClick then
      CS.SceneManager.EditorFocusGameObject(self.transform:Find("Model").gameObject)
    end
    CS.WorldMarchDataManager.SelectMarchUuid = self.hsrData.uuid
  end
  UIUtil.OnClickWorldTroop(self.hsrData.uuid)
end

function HSRView:GetFollowGO()
  if self.transform then
    return self.transform:Find("CameraFollow").gameObject
  end
end

function HSRView:OnHSRHeadDataRefresh()
  if self.hsrCarriages then
    for _, v in pairs(self.hsrCarriages) do
      v:OnHSRHeadDataRefresh()
    end
  end
end

return HSRView
