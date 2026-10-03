local base = require("DataCenter.BattleField.BattleAnim.BattleObj")
local BattleObjWinterDrop = BaseClass("BattleObjWinterDrop", base)
local typeofSA = typeof(CS.SimpleAnimation)
local Resource = CS.GameEntry.Resource

function BattleObjWinterDrop:OnDestroy()
  self:CleanReq()
  self.bShow = nil
  base.OnDestroy(self)
end

function BattleObjWinterDrop:Update(curTime)
  if IsNull(self.gameObject) then
    self:OnCreate(self.pointIndex)
  end
  self:EnableMyGo(self.seqJls == nil)
end

function BattleObjWinterDrop:EnableMyGo(bShow)
  if IsNotNull(self.gameObject) and self.bShow ~= bShow then
    self.bShow = bShow
    self.gameObject:SetActive(bShow)
    self.transform:Set_localScale(1, 1, 1)
    self.transform:Set_localRotation(0, 0, 0)
  end
end

function BattleObjWinterDrop:CleanReq()
  if self.seqJls ~= nil then
    self.seqJls:Pause()
    self.seqJls:Kill()
    self.seqJls = nil
  end
  if self.jlsReq ~= nil then
    self.jlsReq:Destroy()
    self.jlsReq = nil
  end
  if self.boxReq ~= nil then
    self.boxReq:Destroy()
    self.boxReq = nil
  end
end

function BattleObjWinterDrop:InitDrop()
  self:CleanReq()
  self:EnableMyGo(false)
  local buildId = self.detailInfo.BuildId
  self.jlsReq = Resource:InstantiateAsync(UIAssets.LWWorldWinterDrop)
  self.jlsReq:completed("+", function(req)
    if req.isError then
      if self.jlsReq ~= nil then
        self.jlsReq:Destroy()
        self.jlsReq = nil
      end
      self:EnableMyGo(true)
      return
    end
    local go = req.gameObject
    go.name = "WS_Jls_" .. buildId
    local tf = go.transform
    tf:SetParent(CS.SceneManager.World.DynamicObjNode)
    local startPos = SceneUtils.TileIndexToWorld(self.pointIndex, ForceChangeScene.World)
    tf:Set_localPosition(startPos.x, startPos.y, startPos.z)
    self:PlayDrop(tf)
  end)
end

function BattleObjWinterDrop:PlayDrop(tf)
  local animation = tf:GetComponentInChildren(typeofSA)
  local flag = IsNull(animation)
  tf.gameObject:SetActive(not flag)
  self:EnableMyGo(flag)
  if flag then
    return
  end
  local boxPt = animation.transform:Find("To_unity/Root/box02")
  if not IsNull(boxPt) then
    local modelPath = self.config:GetModelPath()
    self:AddBox(boxPt, modelPath)
  end
  local JlsAct = "Default"
  if animation:IsPlaying(JlsAct) then
    animation:Rewind(JlsAct)
  else
    animation:Play(JlsAct)
  end
  local clipL = animation:GetClipLength(JlsAct)
  self.seqJls = CS.DG.Tweening.DOTween.Sequence()
  self.seqJls:AppendInterval(clipL)
  self.seqJls:OnComplete(function()
    self.seqJls = nil
    tf.gameObject:SetActive(false)
    self:EnableMyGo(true)
  end)
end

function BattleObjWinterDrop:AddBox(boxPt, modelPath)
  self.boxReq = Resource:InstantiateAsync(modelPath)
  self.boxReq:completed("+", function(req)
    if req.isError then
      if self.boxReq ~= nil then
        self.boxReq:Destroy()
        self.boxReq = nil
      end
      return
    end
    local tf = req.gameObject.transform
    tf:SetParent(boxPt)
    tf:Set_localPosition(0, 0, 0)
    tf:Set_localScale(1, 1, 1)
    tf:Set_localRotation(0, 0, 0)
  end)
end

return BattleObjWinterDrop
