local TestGC = {}
setmetatable(TestGC, {
  __gc = function()
    print(">>>lsz TestGC")
  end
})

function TestGC:Log()
  print(">>>lsz log")
end

return TestGC
