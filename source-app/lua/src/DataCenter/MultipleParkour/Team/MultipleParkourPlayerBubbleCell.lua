local MultipleParkourPlayerBubbleCell = BaseClass("MultipleParkourPlayerBubbleCell", UIBaseContainer)
local base = UIBaseContainer
local resPath = "Assets/Main/Prefabs/UI/MultipleParkour/MultipleParkourPlayerBubble.prefab"
local Resource = CS.GameEntry.Resource
local emoji_bg1_path = "Content/emojiBg1"
local emoji_img1_path = "Content/emojiBg1/emojiImg1"
local emoji_bg2_path = "Content/emojiBg2"
local emoji_img2_path = "Content/emojiBg2/emojiImg2"

function MultipleParkourPlayerBubbleCell:__init()
end

function MultipleParkourPlayerBubbleCell:__delete()
  self:OnDestroy()
  if self.req then
    self.req:Destroy()
    self.req = nil
  end
  self.target = nil
end

function MultipleParkourPlayerBubbleCell:Load(member, transform, height, emojiId)
  self.member = member
  self.target = transform
  self.camera = CS.UnityEngine.Camera.main
  if not height or height < 0 then
    self.height = 1
  else
    self.height = height
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
    self:SetData(self.member)
    self:ShowEmoji(emojiId)
  end)
end

function MultipleParkourPlayerBubbleCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MultipleParkourPlayerBubbleCell:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function MultipleParkourPlayerBubbleCell:ComponentDefine()
  self.emoji_bg1 = self:AddComponent(UIImage, emoji_bg1_path)
  self.emoji_img1 = self:AddComponent(UIImage, emoji_img1_path)
  self.emoji_bg2 = self:AddComponent(UIImage, emoji_bg2_path)
  self.emoji_img2 = self:AddComponent(UIImage, emoji_img2_path)
  self.emoji_bg1:SetActive(false)
  self.emoji_bg2:SetActive(false)
end

function MultipleParkourPlayerBubbleCell:ComponentDestroy()
  self.emoji_bg1 = nil
  self.emoji_img1 = nil
  self.emoji_bg2 = nil
  self.emoji_img2 = nil
end

function MultipleParkourPlayerBubbleCell:DataDefine()
end

function MultipleParkourPlayerBubbleCell:DataDestroy()
  if self.updateTimer ~= nil then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
  self.member = nil
  self.target = nil
end

function MultipleParkourPlayerBubbleCell:SetData(member)
  if not self.updateTimer then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
end

function MultipleParkourPlayerBubbleCell:ShowEmoji(id)
  local data = LocalController:instance():getLine(TableName.LW_EMOJI, id)
  if data then
    local path = "Assets/Main/Sprites/UI/LWChatEmoji/Default/" .. data.path .. ".png"
    local rand = math.random()
    if rand < 0.5 then
      self.emoji_img1:LoadSprite(path)
      self.emoji_bg1:SetActive(true)
    else
      self.emoji_img2:LoadSprite(path)
      self.emoji_bg2:SetActive(true)
    end
  end
end

function MultipleParkourPlayerBubbleCell:UpdateHeight(height)
  if not height or height < 0 then
    self.height = 1
  else
    self.height = height
  end
end

function MultipleParkourPlayerBubbleCell:OnUpdate()
  if self.transform then
    self:UpdatePos()
  end
end

function MultipleParkourPlayerBubbleCell:UpdatePos()
  self.myWorldPos.x, self.myWorldPos.y, self.myWorldPos.z = self.target:Get_position()
  self.myWorldPos.y = self.myWorldPos.y + self.height
  self.transform.position = CS.CSUtils.WorldPositionToUISpacePosition(self.myWorldPos)
end

return MultipleParkourPlayerBubbleCell
