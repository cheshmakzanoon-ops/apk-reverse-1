local TorchRelayBattleRecordLine = BaseClass("TorchRelayBattleRecordLine")

function TorchRelayBattleRecordLine:__init()
end

function TorchRelayBattleRecordLine:__delete()
  if self.handle then
    self.handle:Destroy()
    self.handle = nil
  end
end

function TorchRelayBattleRecordLine:Load(pos, res, content)
  if self.handle then
    self.handle:Destroy()
    self.handle = nil
  end
  self.handle = CS.GameEntry.Resource:InstantiateAsync(res)
  self.handle:completed("+", function()
    if self.handle.isError then
      Logger.LogError("[TorchRelay] \232\181\132\230\186\144\229\138\160\232\189\189\229\164\177\232\180\165  path:" .. self.resConfig.prefab)
      return
    end
    self.gameObject = self.handle.gameObject
    self.transform = self.gameObject.transform
    self.transform:Set_localPosition(pos.x, pos.y, pos.z)
    self.transform:Set_localEulerAngles(0, 0, 0)
    self:RefreshContent(self.transform, content)
  end)
end

function TorchRelayBattleRecordLine:RefreshContent(trans, content)
  local tmp = trans:GetComponentInChildren(typeof(CS.TextMeshProUGUIEx))
  if tmp then
    tmp.text = content
  end
end

return TorchRelayBattleRecordLine
