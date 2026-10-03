local ThumbsUpItem = BaseClass("ThumbsUpItem")
local ResourceManager = CS.GameEntry.Resource
local TouchObjectEventTrigger = CS.TouchObjectEventTrigger

function ThumbsUpItem:__init(world)
  self.__world = world
end

function ThumbsUpItem:__delete()
  if self.req ~= nil then
    self.req:Destroy()
  end
  if self.collider then
    self.collider.onPointerClick = nil
  end
  self.req = nil
  self.collider = nil
end

function ThumbsUpItem:IsFinished(curTimeStamp, lifeTime)
  if self.startTimeStamp == nil then
    return false
  end
  return lifeTime <= curTimeStamp - self.startTimeStamp
end

function ThumbsUpItem:SetActive(flag)
  if self.gameObject then
    self.gameObject:SetActive(flag)
  end
end

function ThumbsUpItem:OnShow(serverId, pointId, sender, text, iconPath, prefabPath, exText)
  self.startTimeStamp = nil
  local UI_BUBBLE_PATH = prefabPath or "Assets/Main/Prefabs/UI/LWPlayerInfo/ThumbsUpMessageTip.prefab"
  if self.req and self.prefabPath == UI_BUBBLE_PATH then
    self:OnCreate(prefabPath, serverId, pointId, sender, text, iconPath, exText)
    return
  end
  if not self.__world then
    self.__world = CS.SceneManager.World
  end
  if not SceneUtils.GetIsInWorld() or self.__world == nil then
    self.bubbleHandle = ResourceManager:InstantiateAsync(UI_BUBBLE_PATH)
  else
    self.bubbleHandle = self.__world:InstantiateAsyncDynamicObj(UI_BUBBLE_PATH, 0)
  end
  self.req = nil
  self.prefabPath = nil
  self.bubbleHandle:completed("+", function(req)
    if req.isError then
      self.startTimeStamp = 0
      return
    end
    if not SceneUtils.GetIsInWorld() or not self.__world then
      self.startTimeStamp = 0
      req:Destroy()
      return
    end
    self:GetComponent(req)
    if not self.headIcon or not self.animRoot then
      self.startTimeStamp = 0
      req:Destroy()
      return
    end
    self.req = req
    self.prefabPath = UI_BUBBLE_PATH
    self:OnCreate(prefabPath, serverId, pointId, sender, text, iconPath, exText)
  end)
end

function ThumbsUpItem:OnCreate(prefabPath, serverId, pointId, sender, text, iconPath, exText)
  self.startTimeStamp = UITimeManager:GetInstance():GetServerTime()
  if self.unity_icon and self.anim then
    local specifiedRes
    self.playerUid = sender.uid
    local pic = sender.headPic or sender.pic
    local picVer = sender.headPicVer or sender.picVer or sender.picver
    if pic and pic ~= "" and type(pic) == "string" then
      local pic1, pic2 = string.match(pic, "(Assets/Main/.*)(Assets/Main/.*)")
      if pic1 and pic2 then
        specifiedRes = pic2
      end
    end
    self.gameObject.name = string.format("ThumbsUp_%s", pointId)
    self.transform:SetParent(self.__world.DynamicObjNode)
    self.transform.position = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, serverId)
    self.animRoot.gameObject:SetActive(true)
    self:SetActive(true)
    if specifiedRes then
      self.unity_icon:UseSpecifiedRes(specifiedRes)
    elseif not pic and not picVer then
      self.unity_icon:UseSystemHead()
    else
      self.unity_icon:SetData(sender.uid, pic, toInt(picVer), false)
    end
    if self.anim:IsPlaying("Default") then
      self.anim:Rewind("Default")
    else
      self.anim:Play("Default")
    end
  end
  if prefabPath and not self.tmp_unity_txt then
    self.tmp_unity_txt = self.txt.gameObject:GetComponent(typeof(CS.SuperTextMesh))
  end
  if self.exTxt and not self.unity_txt_ex then
    self.unity_txt_ex = self.exTxt.gameObject:GetComponent(typeof(CS.TextMeshProEx))
  end
  local unity_txt = self.tmp_unity_txt or self.unity_txt
  if unity_txt then
    unity_txt.text = text
  end
  if self.unity_heart_icon then
    self.unity_heart_icon:LoadSprite(iconPath)
  end
  if self.unity_txt_ex and exText ~= nil then
    self.unity_txt_ex.text = exText
  end
end

function ThumbsUpItem:GetComponent(req)
  self.gameObject = req.gameObject
  self.transform = self.gameObject.transform
  self.animRoot = self.transform:Find("bg")
  self.headIcon = self.transform:Find("bg/headIcon")
  self.txt = self.transform:Find("bg/txt")
  self.heart = self.transform:Find("bg/heart")
  self.exTxt = self.transform:Find("bg/exTxt")
  self.anim = self.gameObject:GetComponent(typeof(CS.SimpleAnimation))
  self.unity_icon = self.headIcon.gameObject:GetComponent(typeof(CS.UIPlayerHead))
  self.unity_txt = self.txt.gameObject:GetComponent(typeof(CS.TextMeshProEx))
  self.unity_heart_icon = self.heart.gameObject:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.collider = self.transform:Find("bg/btn"):GetComponent(typeof(TouchObjectEventTrigger))
  if self.collider then
    function self.collider.onPointerClick()
      if self.playerUid then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true, hideTop = false}, self.playerUid)
      end
    end
  end
end

return ThumbsUpItem
