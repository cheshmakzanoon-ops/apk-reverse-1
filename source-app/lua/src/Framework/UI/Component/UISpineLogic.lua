local UISpineLogic = BaseClass("UISpineLogic", UIBaseContainer)
local base = UIBaseContainer
UISpineLogic.UISpineLogicType = {Once = 1, Loop = 2}

function UISpineLogic:OnCreate()
  base.OnCreate(self)
  self.spine = self:AddComponent(UISpine, "")
  self.playMap = {}
  self.showIndex = -1
  self.mode = UISpineLogic.UISpineLogicType.Once
end

function UISpineLogic:OnDestroy()
  base.OnDestroy(self)
  self.spine = nil
  self.playMap = nil
  self.showIndex = -1
end

function UISpineLogic:SetPlayerMap(playMap, mode, loop)
  self.mode = mode
  table.clear(self.playMap)
  self.playMap.spineDataAsset = playMap.spineDataAsset
  
  local function loadFinish()
    if playMap.anims ~= nil and #playMap.anims > 0 then
      for index, spineAnimInfo in ipairs(playMap.anims) do
        if spineAnimInfo.time == nil then
          spineAnimInfo.time = self.spine:GetAnimationDuration(spineAnimInfo.animName)
        end
        self.playMap[index] = {
          animName = spineAnimInfo.animName,
          time = spineAnimInfo.time,
          opTime = spineAnimInfo.time,
          callback = playMap.callback
        }
      end
      self.showIndex = 1
      if loop ~= nil then
        self.spine:SetAnimation(0, self.playMap[self.showIndex].animName, loop)
      else
        self.spine:SetAnimation(0, self.playMap[self.showIndex].animName, self.showIndex == #self.playMap)
      end
    end
  end
  
  if self.playMap.spineDataAsset ~= nil then
    self.spine:LoadSkeletonDataAsset(self.playMap.spineDataAsset, loadFinish)
  else
    loadFinish()
  end
end

function UISpineLogic:Update()
  if #self.playMap == 0 or 0 >= self.showIndex then
    return
  end
  local curAnimInfo = self.playMap[self.showIndex]
  if 0 < curAnimInfo.opTime then
    curAnimInfo.opTime = curAnimInfo.opTime - Time.deltaTime
    if 0 > curAnimInfo.opTime then
      curAnimInfo.opTime = curAnimInfo.time
      self.showIndex = self.showIndex + 1
      if curAnimInfo.callback ~= nil then
        curAnimInfo.callback()
        curAnimInfo.callback = nil
      end
      if self.showIndex > #self.playMap then
        if self.mode == UISpineLogic.UISpineLogicType.Once then
          self.showIndex = -1
        else
          self.showIndex = 1
        end
      end
      if 0 < self.showIndex then
        self.spine:SetAnimation(0, self.playMap[self.showIndex].animName, self.showIndex == #self.playMap)
      end
    end
  end
end

return UISpineLogic
