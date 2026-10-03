local MultipleParkourPlayerBarCell = BaseClass("MultipleParkourPlayerBarCell", UIBaseContainer)
local base = UIBaseContainer
local resPath = "Assets/Main/Prefabs/UI/MultipleParkour/MultipleParkourPlayerHead.prefab"
local Resource = CS.GameEntry.Resource
local ScoreColor = Color.New(1, 1, 1, 1)
local MyScoreColor = Color.New(0.03529412, 0.6078432, 0.2901961, 1)
local emoji_bg1_path = "Content/emojiBg1"
local emoji_img1_path = "Content/emojiBg1/emojiImg1"
local emoji_bg2_path = "Content/emojiBg2"
local emoji_img2_path = "Content/emojiBg2/emojiImg2"

function MultipleParkourPlayerBarCell:__init()
end

function MultipleParkourPlayerBarCell:__delete()
  self:OnDestroy()
  if self.req then
    self.req:Destroy()
    self.req = nil
  end
  self.target = nil
end

function MultipleParkourPlayerBarCell:Load(member, transform, height)
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
  end)
end

function MultipleParkourPlayerBarCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MultipleParkourPlayerBarCell:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function MultipleParkourPlayerBarCell:ComponentDefine()
  self.content = self:AddComponent(UIBaseContainer, "Content")
  self.player_img = self:AddComponent(UIPlayerHead, "Content/UIPlayerHead/HeadIcon")
  self.playerHeadFg = self:AddComponent(UIImage, "Content/UIPlayerHead/Foreground")
  self.score = self:AddComponent(UITextMeshProUGUIEx, "Content/layout/score")
  self.nameTxt = self:AddComponent(UITextMeshProUGUIEx, "Content/layout/name")
  self.selfFlag = self:AddComponent(UIImage, "Content/selfFlag")
  self.emoji_bg1 = self:AddComponent(UIImage, emoji_bg1_path)
  self.emoji_img1 = self:AddComponent(UIImage, emoji_img1_path)
  self.emoji_bg2 = self:AddComponent(UIImage, emoji_bg2_path)
  self.emoji_img2 = self:AddComponent(UIImage, emoji_img2_path)
  self.emoji_bg1:SetActive(false)
  self.emoji_bg2:SetActive(false)
  self.nameTxt:SetActive(false)
end

function MultipleParkourPlayerBarCell:ComponentDestroy()
  self.content = nil
  self.player_img = nil
  self.playerHeadFg = nil
  self.score = nil
  self.selfFlag = nil
  self.emoji_bg1 = nil
  self.emoji_img1 = nil
  self.emoji_bg2 = nil
  self.emoji_img2 = nil
end

function MultipleParkourPlayerBarCell:DataDefine()
end

function MultipleParkourPlayerBarCell:DataDestroy()
  if self.updateTimer ~= nil then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
  self.member = nil
  self.target = nil
end

function MultipleParkourPlayerBarCell:SetData(member)
  if not self.updateTimer then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
  local data = member.playerData
  self.player_img:SetData(data.playerId, data.pic, data.picver)
  if not string.IsNullOrEmpty(data.headSkinId) then
    self.playerHeadFg:SetActive(true)
    local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(data.headSkinId)
    self.playerHeadFg:LoadSprite(headBgImg)
  else
    self.playerHeadFg:SetActive(false)
  end
  if data.mySelf then
    self.content.transform:Set_localScale(0.3, 0.3, 0.3)
    self.selfFlag:SetActive(true)
  else
    self.content.transform:Set_localScale(0.2, 0.2, 0.2)
    self.selfFlag:SetActive(false)
  end
  self.score:SetColor(ScoreColor)
  self.score:SetText(data:GetShowScore())
  self.nameTxt:SetText(data.name)
end

function MultipleParkourPlayerBarCell:UpdateScore()
  if IsNull(self.transform) then
    return
  end
  local data = self.member.playerData
  self.score:SetText(data:GetShowScore())
end

function MultipleParkourPlayerBarCell:ShowName(height)
  if IsNull(self.transform) then
    return
  end
  self.nameTxt:SetActive(true)
  if height then
    self.height = height
  end
  self:UpdateScale(0.3)
end

function MultipleParkourPlayerBarCell:UpdateHeight(height)
  if not height or height < 0 then
    self.height = 1
  else
    self.height = height
  end
end

function MultipleParkourPlayerBarCell:UpdateScale(scale)
  if IsNull(self.transform) then
    return
  end
  self.content.transform:Set_localScale(scale, scale, scale)
end

function MultipleParkourPlayerBarCell:ShowEmoji(id)
  if IsNull(self.transform) then
    return
  end
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

function MultipleParkourPlayerBarCell:OnUpdate()
  if self.transform then
    self:UpdatePos()
  end
end

function MultipleParkourPlayerBarCell:UpdatePos()
  self.myWorldPos.x, self.myWorldPos.y, self.myWorldPos.z = self.target:Get_position()
  self.myWorldPos.y = self.myWorldPos.y + self.height
  self.transform.position = CS.CSUtils.WorldPositionToUISpacePosition(self.myWorldPos)
end

return MultipleParkourPlayerBarCell
