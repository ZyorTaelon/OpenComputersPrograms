local event = require("event") -- load event table and store the pointer to it in event
local thread = require("thread")
local ctifview = require("ctifview")
local component = require("component")
local gpu = component.gpu;

function unknownEvent()
  -- do nothing if the event wasn't relevant
end

continueLoop = true;

local cleanup_thread = thread.create(function()
  event.pull("interrupted")
  continueLoop = false
  print("Interrupt received. Exiting")
  ctifview.clear();
end)

local main_thread = thread.create(function()
  ctifview.show('lib/TransporterDisplay_320.ctif')
  print("Waiting for incoming events:")
  gpu.setForeground(0xFFFFFF)
  while continueLoop do
    local id, _, x, y = event.pullMultiple("touch", "interrupted")
    if id == "touch" then
      gpu.set(x, y, "user clicked (" .. x .. ',' .. y ..')')
    end
  end
end)