local AllianceFriendsHelpBubbleItem = BaseClass("AllianceFriendsHelpBubble")
local TouchObjectEventTrigger = CS.TouchObjectEventTrigger

function AllianceFriendsHelpBubbleItem:__init(transform)
  if transform == nil then
    return
  end
  transform:Set_localPosition(0, 0, 0)
  transform:Set_localScale(1, 0, 1)
  self.transform = transform
  self.theSimpleAnimation = transform:GetComponent(typeof(CS.SimpleAnimation))
  self.userName = transform:Find("txt"):GetComponent(typeof(CS.SuperTextMesh))
  self.bg = transform:Find("bg"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.userIcon = transform:Find("UserHead/head"):GetComponent(typeof(CS.UIPlayerHead))
  self.userFrame = transform:Find("UserHead/frame"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.btn1 = transform:Find("UserHead/btn1"):GetComponent(typeof(TouchObjectEventTrigger))
  self.btn2 = transform:Find("btn2"):GetComponent(typeof(TouchObjectEventTrigger))
  
  function self.btn1.onPointerClick()
    if self.data ~= nil and self.data.userInfo ~= nil and self.data.userInfo.uid ~= nil then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true, hideTop = false}, self.data.userInfo.uid)
    end
  end
  
  self.btn1.previewType = CS.WorldPreviewType.GUI
  
  function self.btn2.onPointerClick()
    if self.data ~= nil and self.data.userInfo ~= nil and self.data.userInfo.uid ~= nil then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true, hideTop = false}, self.data.userInfo.uid)
    end
  end
  
  self.btn2.previewType = CS.WorldPreviewType.GUI
end

function AllianceFriendsHelpBubbleItem:__delete()
  self.btn1.onPointerClick = nil
  self.btn2.onPointerClick = nil
  self.userIcon = nil
  self.userFrame = nil
  self.userName = nil
  self.btn1 = nil
  self.btn2 = nil
  self.theSimpleAnimation = nil
end

function AllianceFriendsHelpBubbleItem:ShowIt(data)
  self.data = data
  if self.theSimpleAnimation == nil then
    return
  end
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(data.userInfo.headSkinId, data.userInfo.headSkinET)
  if headBgImg then
    self.userFrame:LoadSprite(headBgImg)
  end
  self.userIcon:SetData(data.userInfo.uid, data.userInfo.pic, toInt(data.userInfo.picVer or 0), false)
  self.userName.text = UIUtil.FormatServerAllianceName(data.userInfo.serverId, data.userInfo.abbr, data.userInfo.name)
  self.transform:Set_localPosition(0, 0, 0)
  self.transform:Set_localScale(1, 0, 1)
  self.bg.color = Color.New(1, 1, 1, 0.8)
  if DataCenter.SeasonFactionWarDataManager:IsInSameCampByServer(data.userInfo.serverId, mySourceServerId) then
    self.userName.color = Color.white
  else
    self.userName.color = Color.New(249, 112, 119, 255)
  end
  self.theSimpleAnimation:Rewind("Default")
  self.theSimpleAnimation:Play("Default")
end

local base = UIAsyncNode
local AllianceFriendsHelpBubble = BaseClass("AllianceFriendsHelpBubble", base)

function AllianceFriendsHelpBubble:OnCreate(go)
  if self.gameObject ~= nil and self.transform ~= nil then
    local transform = self.transform
    transform:Set_localPosition(1, 0, 0)
    transform:Set_localScale(0.5, 0.5, 0.5)
    self.Root1 = AllianceFriendsHelpBubbleItem.New(transform:Find("Root1"))
    self.Root2 = AllianceFriendsHelpBubbleItem.New(transform:Find("Root2"))
    self.Root3 = AllianceFriendsHelpBubbleItem.New(transform:Find("Root3"))
    if self.dataList ~= nil then
      self.showCursor = 0
      self.nextNode = self.Root1
      self:AddTimer()
    end
  end
end

function AllianceFriendsHelpBubble:OnDestroy()
  self:DeleteTimer()
  self.nextNode = nil
  self.dataList = nil
  self.Root1:Delete()
  self.Root2:Delete()
  self.Root3:Delete()
end

function AllianceFriendsHelpBubble:UpdateLod(lod)
  self.lodCache = toInt(lod)
end

function AllianceFriendsHelpBubble:AddFriendsHelp(data)
  if self.dataList == nil then
    self.dataList = {}
    self.showCursor = 0
    self.nextNode = self.Root1
  end
  table.insert(self.dataList, data)
  if self.Root1 then
    self:AddTimer()
  end
end

function AllianceFriendsHelpBubble:ShowNext()
  if self.timer_action and self.nextNode and self.dataList and self.showCursor and (self.lodCache == nil or self.lodCache < 3) then
    local count = #self.dataList
    if count > self.showCursor then
      self.showCursor = self.showCursor + 1
      local data = self.dataList[self.showCursor]
      if data then
        local useNode = self.nextNode
        if useNode then
          useNode:ShowIt(data)
        end
        if useNode == self.Root1 then
          self.nextNode = self.Root2
        elseif useNode == self.Root2 then
          self.nextNode = self.Root3
        elseif useNode == self.Root3 then
          self.nextNode = self.Root1
        end
      end
    else
      self.dataList = {}
      self.showCursor = 0
      self:DeleteTimer()
    end
  end
end

function AllianceFriendsHelpBubble:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer_action = nil
    self.timer = nil
  end
end

function AllianceFriendsHelpBubble:AddTimer()
  if self.timer == nil then
    if self.timer_action == nil then
      function self.timer_action()
        self:ShowNext()
      end
    end
    self.timer = TimerManager:GetInstance():GetTimer(1.55, self.timer_action, self, false, false, false)
    self.timer:Start()
  end
end

return AllianceFriendsHelpBubble
