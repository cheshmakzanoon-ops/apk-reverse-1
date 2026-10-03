local LWTrainPrepareScenePassengerBubble = BaseClass("LWTrainPrepareScenePassengerBubble", UIBaseContainer)
local base = UIBaseContainer
local resPath = "Assets/Main/Prefabs/UI/UILWRailway/Scene/UITrainPrepareBubble.prefab"
local Resource = CS.GameEntry.Resource

function LWTrainPrepareScenePassengerBubble:__init(camera)
  self.valid = true
  self.camera = camera
end

function LWTrainPrepareScenePassengerBubble:__delete()
  self:OnDestroy()
  if self.req then
    self.req:Destroy()
    self.req = nil
  end
  self:RemoveTimer()
  self.data = nil
  self.target = nil
  self.camera = nil
  self.bubbleTip = nil
end

function LWTrainPrepareScenePassengerBubble:InPool()
  self.valid = false
  if self.gameObject then
    self.gameObject:SetActive(false)
  end
end

function LWTrainPrepareScenePassengerBubble:OutPool()
  self.valid = true
  if self.gameObject then
    self.gameObject:SetActive(true)
  end
end

function LWTrainPrepareScenePassengerBubble:SetData(data, transform, bubbleTip, height)
  self.data = data
  self.bubbleTip = bubbleTip
  self.target = transform
  if not height or height < 0 then
    self.height = 1
  else
    self.height = height
  end
  if self.transform then
    self:RefreshShow()
  end
end

function LWTrainPrepareScenePassengerBubble:Load()
  if self.req then
    return
  end
  self.myWorldPos = Vector3.zero
  self.req = Resource:InstantiateAsync(resPath)
  self.req:completed("+", function(req)
    local go = req.gameObject
    local CanvasNormal = UIManager:GetInstance():GetLayer(UILayer.Scene.Name).gameObject
    go.transform:SetParent(CanvasNormal.transform)
    self.gameObject = go
    self.transform = go.transform
    self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.__var_arg = self.gameObject
    self:OnCreate()
    self:AddTimer()
    self:RefreshShow()
    self:SetActive(self.valid)
  end)
end

function LWTrainPrepareScenePassengerBubble:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWTrainPrepareScenePassengerBubble:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWTrainPrepareScenePassengerBubble:ComponentDefine()
  self.root = self:AddComponent(UIBaseComponent, "Root")
  self.name = self:AddComponent(UIText, "Root/top/name")
  self.head = self:AddComponent(UICommonHead, "Root/top/head")
  self.words = self:AddComponent(UIText, "Root/words")
end

function LWTrainPrepareScenePassengerBubble:ComponentDestroy()
  self.name = nil
  self.head = nil
  self.words = nil
end

function LWTrainPrepareScenePassengerBubble:AddTimer()
  if not self.updateTimer then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
end

function LWTrainPrepareScenePassengerBubble:RemoveTimer()
  if self.updateTimer ~= nil then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

function LWTrainPrepareScenePassengerBubble:RefreshShow()
  if self.words then
    self.words:SetText(self.bubbleTip)
  end
  if self.name then
    self.name:SetText(self.data.name)
  end
  if self.head then
    if self.uid == LuaEntry.Player.uid then
      local headSkinPath = LuaEntry.Player:GetHeadBgImg()
      self.head:SetData(self.uid, self.data.pic, self.data.picVer, nil, headSkinPath)
    else
      self.head:SetHeadAndFrame(self.uid, self.data.headPic, self.data.headPicVer, false, self.data.headSkinId, self.data.headSkinET)
    end
  end
  self:OnUpdate()
end

function LWTrainPrepareScenePassengerBubble:OnUpdate()
  if self.transform and self.valid then
    local parentRect = UIManager:GetInstance():GetLayer(UILayer.Scene.Name).rectTransform
    local screenPos = CS.CSUtils.WorldTransformToUIPosition(self.target, self.camera, parentRect, self.height)
    if screenPos == nil then
      return
    end
    local half = 121
    local right = -70
    local x = screenPos.x
    local pivotX = 0.5
    if right < x + half then
      local newX = right - half
      local diff = x - newX
      diff = Mathf.Clamp(diff, 0, half)
      pivotX = pivotX + diff / half * 0.5
    end
    self.rectTransform:Set_anchoredPosition(x, screenPos.y)
    self.root.rectTransform:Set_pivot(pivotX, 0)
    self.root.rectTransform:Set_anchoredPosition(0, 16)
  end
end

return LWTrainPrepareScenePassengerBubble
