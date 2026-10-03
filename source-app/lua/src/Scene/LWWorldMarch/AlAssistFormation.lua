local AlAssistFormation = {}
AlAssistFormation.Pos = {
  [1] = Vector3.New(-3, 0, 3),
  [2] = Vector3.New(3, 0, 3),
  [3] = Vector3.New(-3, 0, -3),
  [4] = Vector3.New(0, 0, 0),
  [5] = Vector3.New(3, 0, -3)
}
AlAssistFormation.SinglePos = Vector3.zero

function AlAssistFormation.GetOffsetByIndex(index, total)
  if total == 1 then
    return AlAssistFormation.SinglePos
  end
  return AlAssistFormation.Pos[index]
end

function AlAssistFormation.GetScaleByIndex(index)
  return 1
end

return AlAssistFormation
