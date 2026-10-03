local ActEasterEggMainAniEggData = BaseClass("ActEasterEggMainAniEggData")

function ActEasterEggMainAniEggData:__init()
  self.canCaptureEgg = {}
  local eggIndexStr = CommonUtil.PlayerPrefsGetString("ActEasterCanCaptureEggList")
  if not string.IsNullOrEmpty(eggIndexStr) then
    local pointIndexList = string.split(eggIndexStr, ",")
    for k, v in pairs(pointIndexList) do
      table.insert(self.canCaptureEgg, tonumber(v))
    end
  else
    for i = 1, 6 do
      table.insert(self.canCaptureEgg, i)
    end
    self:RecordCaptureEggList()
  end
end

function ActEasterEggMainAniEggData:__delete()
  self.canCaptureEgg = nil
end

function ActEasterEggMainAniEggData:GetCanCaptureEggList()
  return self.canCaptureEgg
end

function ActEasterEggMainAniEggData:RecoverEggList()
  if table.count(self.canCaptureEgg) ~= 0 then
    Logger.LogError("ActEasterEggMainAniEggData:RecoverEggList error")
    return
  end
  self.canCaptureEgg = {}
  for i = 1, 6 do
    table.insert(self.canCaptureEgg, i)
  end
end

function ActEasterEggMainAniEggData:RemoveEggFromList(index)
  if not self.canCaptureEgg or table.hasvalue(self.canCaptureEgg, index) == nil then
    return
  end
  local numIndex = table.indexof(self.canCaptureEgg, index)
  if numIndex then
    table.remove(self.canCaptureEgg, numIndex)
    self:RecordCaptureEggList()
  end
end

function ActEasterEggMainAniEggData:RecordCaptureEggList()
  local str = ""
  for k, v in pairs(self.canCaptureEgg) do
    str = str .. v .. ","
  end
  CommonUtil.PlayerPrefsSetString("ActEasterCanCaptureEggList", str)
end

return ActEasterEggMainAniEggData
